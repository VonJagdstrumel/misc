import http.server

routes = {}


def route(path):

    def route_decorator(func):
        routes[path] = func
        return func

    return route_decorator


class CustomHTTPRequestHandler(http.server.BaseHTTPRequestHandler):

    def do_GET(self):
        call = routes.get(self.path)

        if(call):
            self.send_response(200)
            self.end_headers()
            self.wfile.write(call(self))
        else:
            self.send_response(404)
            self.end_headers()

    @route('/loadavg')
    def get_loadavg(self):
        with open('/proc/loadavg') as f:
            return f.read().encode()


if __name__ == '__main__':
    server_address = ('127.0.0.1', 8000)
    httpd = http.server.ThreadingHTTPServer(server_address, CustomHTTPRequestHandler)
    httpd.serve_forever()
