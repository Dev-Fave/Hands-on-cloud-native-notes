# ============================================
# Week 2: Cloud Native Notes Container
# ============================================

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import os

APP_NAME = os.getenv("APP_NAME", "Cloud Native Notes")

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/":
            self.send_response(200)
            self.send_header("Content-type", "text/html")
            self.end_headers()
            self.wfile.write(f"""
                <html>
                    <body>
                        <h1>{APP_NAME}</h1>
                        <p>Week 2: Containerized Cloud Native Notes Python App</p>
                        <p>Container ID: {os.uname().nodename}</p>
                        <p>Environment: {os.getenv("NODE_ENV", "development")}</p>
                    </body>
                </html>
            """.encode())

        elif self.path == "/health":
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({
                "status": "healthy",
                "app": APP_NAME,
                "week": 2
            }).encode())

        else:
            self.send_response(404)
            self.end_headers()

    def do_POST(self):
        if self.path == "/echo":
            content_length = int(self.headers.get("Content-Length", 0))
            body = self.rfile.read(content_length)
            self.send_response(200)
            self.send_header("Content-type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({
                "received": body.decode(),
                "echo": "Hello from Week 2!"
            }).encode())

def run(server_class=HTTPServer, handler_class=Handler, port=3000):
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    print(f" {APP_NAME} running on port {port}")
    print(f" http://localhost:{port}")
    print(f" Health: http://localhost:{port}/health")
    httpd.serve_forever()

if __name__ == "__main__":
    run()
