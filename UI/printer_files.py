import ftplib
import ssl

class ImplicitFTP_TLS(ftplib.FTP_TLS):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._sock = None

    @property
    def sock(self):
        return self._sock

    @sock.setter
    def sock(self, value):
        if value is not None and not isinstance(value, ssl.SSLSocket):
            value = self.context.wrap_socket(value)
        self._sock = value

    def ntransfercmd(self, cmd, rest=None):
        conn, size = ftplib.FTP.ntransfercmd(self, cmd, rest)
        if self._prot_p:
            session = self.sock.session if isinstance(self.sock, ssl.SSLSocket) else None
            conn = self.context.wrap_socket(conn, server_hostname=self.host, session=session)
        return conn, size

def fetch_files_from_printer(ip, username, password):
    try:
        ftps = ImplicitFTP_TLS()
        ftps.connect(host=ip, port=990)
        ftps.login(user=username, passwd=password)
        ftps.prot_p()
        files = ftps.nlst()
        ftps.quit()
        allowed_exts = (".3mf", ".gcode", ".stl.gcode.3mf")
        filtered = [f for f in files if f.lower().endswith(allowed_exts)]
        return filtered
    except Exception as e:
        print(f"❌ Fout bij ophalen bestanden van printer {ip}: {e}")
        return []