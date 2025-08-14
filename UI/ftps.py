import ssl
import socket
import os
import tempfile

class ImplicitFTPS:
    def __init__(self, host, port, username, password, timeout=10):
        self.host = host
        self.port = port
        self.username = username
        self.password = password
        self.timeout = timeout
        self.context = ssl.create_default_context()
        self.context.check_hostname = False
        self.context.verify_mode = ssl.CERT_NONE
        self.ssl_sock = None
        self.file = None  # control-conn reader

    # ---------- low-level ----------
    def _readline(self):
        line = self.file.readline()
        # print("<<<", line.strip())  # debug
        return line

    def _send_cmd(self, cmd):
        # print(">>>", cmd)  # debug
        self.ssl_sock.sendall((cmd + "\r\n").encode("utf-8"))
        return self._readline().strip()

    # ---------- control connection ----------
    def connect(self):
        raw_sock = socket.create_connection((self.host, self.port), timeout=self.timeout)
        self.ssl_sock = self.context.wrap_socket(raw_sock, server_hostname=self.host)
        self.file = self.ssl_sock.makefile("r", encoding="utf-8", newline="\r\n")

        self._readline()  # welkomstregel
        self._send_cmd(f"USER {self.username}")
        self._send_cmd(f"PASS {self.password}")
        self._send_cmd("TYPE I")  # binary transfers

    def close(self):
        try:
            if self.ssl_sock:
                try:
                    self._send_cmd("QUIT")
                except Exception:
                    pass
                self.ssl_sock.close()
        finally:
            self.ssl_sock = None
            self.file = None

    # ---------- data connection helpers ----------
    def _enter_pasv_port(self):
        """
        Parse 227 (h1,h2,h3,h4,p1,p2) en retourneer alleen de PORT.
        We negeren het hostdeel en verbinden altijd naar self.host → stabiel bij NAT/buggy PASV.
        """
        resp = self._send_cmd("PASV")
        # Voorbeeld: 227 Entering Passive Mode (192,168,1,10,195,80).
        start = resp.find("(")
        end = resp.find(")", start)
        nums = resp[start + 1:end].split(",")
        if len(nums) < 6:
            raise RuntimeError(f"PASV parse error: {resp}")
        p1, p2 = int(nums[-2]), int(nums[-1])
        return (p1 << 8) + p2

    # ---------- file ops ----------
    def upload_file(self, local_path, remote_filename):
        port = self._enter_pasv_port()
        data_sock = socket.create_connection((self.host, port), timeout=self.timeout)
        data_ssl = self.context.wrap_socket(data_sock, server_hostname=self.host)

        self._send_cmd(f"STOR {remote_filename}")
        with open(local_path, "rb") as f:
            while True:
                chunk = f.read(65536)
                if not chunk:
                    break
                data_ssl.sendall(chunk)
        data_ssl.close()
        # wacht op "226 Transfer complete"
        self._readline()

    def delete_file(self, remote_filename):
        return self._send_cmd(f"DELE {remote_filename}")

# ---------- convenience API voor Flask ----------
def upload_file_to_printer(file_storage, printer):
    """
    file_storage: werkzeug.FileStorage
    printer: dict met keys: ip, access_code
    """
    tmp_path = None
    try:
        with tempfile.NamedTemporaryFile(delete=False) as tmp:
            file_storage.save(tmp.name)
            tmp_path = tmp.name
        filename = file_storage.filename

        ftp = ImplicitFTPS(
            host=printer["ip"],
            port=990,
            username="bblp",
            password=printer["access_code"],
        )
        ftp.connect()
        ftp.upload_file(tmp_path, filename)
        ftp.close()

        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)

        return {"success": True, "filename": filename, "printer_ip": printer["ip"]}
    except Exception as e:
        try:
            ftp.close()
        except Exception:
            pass
        if tmp_path and os.path.exists(tmp_path):
            os.remove(tmp_path)
        return {"success": False, "error": str(e)}


def delete_file_from_printer(printer, filename):
    try:
        ftp = ImplicitFTPS(
            host=printer["ip"],
            port=990,
            username="bblp",
            password=printer["access_code"],
        )
        ftp.connect()
        resp = ftp.delete_file(filename)
        ftp.close()
        return {"success": True, "response": resp}
    except Exception as e:
        try:
            ftp.close()
        except Exception:
            pass
        return {"success": False, "error": str(e)}
