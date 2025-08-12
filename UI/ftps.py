import ssl
import socket
import os
import tempfile

class ImplicitFTPS:
    def __init__(self, host, port, username, password):
        self.host = host
        self.port = port
        self.username = username
        self.password = password

        self.context = ssl.create_default_context()
        self.context.check_hostname = False
        self.context.verify_mode = ssl.CERT_NONE

    def connect(self):
        raw_sock = socket.create_connection((self.host, self.port), timeout=10)
        self.ssl_sock = self.context.wrap_socket(raw_sock, server_hostname=self.host)
        self.file = self.ssl_sock.makefile("r", encoding="utf-8")

        self.file.readline()  # Welkomsttekst

        self.send_cmd(f"USER {self.username}")
        self.send_cmd(f"PASS {self.password}")

    def send_cmd(self, cmd):
        self.ssl_sock.sendall((cmd + "\r\n").encode())
        response = self.file.readline()
        return response.strip()

    def upload_file(self, local_path, remote_filename):
        # Passive mode starten
        pasv_response = self.send_cmd("PASV")
        start = pasv_response.find('(')
        end = pasv_response.find(')', start)
        numbers = pasv_response[start+1:end].split(',')
        data_host = ".".join(numbers[:4])
        data_port = (int(numbers[4]) << 8) + int(numbers[5])

        data_sock = socket.create_connection((data_host, data_port))
        data_sock_ssl = self.context.wrap_socket(data_sock, server_hostname=self.host)

        self.send_cmd(f"STOR {remote_filename}")

        with open(local_path, "rb") as f:
            while True:
                chunk = f.read(8192)
                if not chunk:
                    break
                data_sock_ssl.sendall(chunk)

        data_sock_ssl.close()
        self.file.readline()  # 226 Transfer complete

    def delete_file(self, remote_filename):
        return self.send_cmd(f"DELE {remote_filename}")


def upload_file_to_printer(file_storage):
    """
    Ontvangt een werkzeug FileStorage object uit Flask en uploadt het via Implicit FTPS.
    """
    try:
        with tempfile.NamedTemporaryFile(delete=False) as tmp:
            file_storage.save(tmp.name)
            tmp_path = tmp.name
            filename = file_storage.filename

        ftp = ImplicitFTPS(
            host="192.168.178.242",  # ← pas dit eventueel dynamisch aan in Flask
            port=990,
            username="bblp",
            password="25793839"
        )
        ftp.connect()
        ftp.upload_file(tmp_path, filename)
        os.remove(tmp_path)

        return {"success": True, "filename": filename}
    except Exception as e:
        return {"success": False, "error": str(e)}


def delete_file_from_printer(printer, filename):
    """
    Verwijdert een bestand op de printer via FTPS.
    """
    try:
        ftp = ImplicitFTPS(
            host=printer["ip"],
            port=990,
            username="bblp",
            password=printer["access_code"]
        )
        ftp.connect()
        response = ftp.delete_file(filename)
        return {"success": True, "response": response}
    except Exception as e:
        return {"success": False, "error": str(e)}