from configparser import ConfigParser
from datetime import datetime, timedelta
import socket
import sys
from threading import Thread
import time


class PeerPool:
    def __init__(self, config):
        self._config = config
        self._pool = {}

    def __iter__(self):
        self._prune()
        return iter(self._pool)

    def _prune(self, key=None):
        if key:
            if key in self._pool:
                ttl = timedelta(seconds=self._config.lifetime)
                expire_date = self._pool[key] + ttl

                if expire_date < datetime.now():
                    del self._pool[key]
        else:
            for key in self._pool:
                self._prune(key)

    def update(self, key):
        self._pool[key] = datetime.now()


class Configuration:
    def __init__(self, path=None):
        conf_str = '[config]'
        parser = ConfigParser()
        self.__dict__ = {
            'group': '239.4.8.20',
            'port': 4820,
            'lifetime': 60,
            'update_delay': 20
        }

        if path:
            with open(path) as fp:
                conf_str += '\n' + fp.read()

        parser.read_string(conf_str)

        for key in parser['config']:
            if key not in self.__dict__:
                pass
            elif type(self.__dict__[key]) is int:
                self.__dict__[key] = int(parser['config'][key])
            else:
                self.__dict__[key] = parser['config'][key]


class QueryHandler(Thread):
    def __init__(self, config, pool):
        super().__init__()
        self._config = config
        self._pool = pool

    def run(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        port = ('127.0.0.1', self._config.port)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind(port)
        sock.listen()

        while True:
            conn, _ = sock.accept()

            with conn:
                peers = tuple(self._pool)
                msg = pack(*peers)
                conn.sendall(msg)


class Receiver(Thread):
    def __init__(self, config, pool):
        super().__init__()
        self._config = config
        self._pool = pool

    def run(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        port = ('', self._config.port)
        group = socket.inet_aton(self._config.group)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind(port)

        for iface in interfaces():
            iface = socket.inet_aton(iface)
            sock.setsockopt(socket.IPPROTO_IP,
                            socket.IP_ADD_MEMBERSHIP, group + iface)

        while True:
            _, addr = sock.recvfrom(1024)

            if addr[0] not in interfaces():
                self._pool.update(addr[0])


class Sender(Thread):
    def __init__(self, config):
        super().__init__()
        self._config = config

    def run(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        addr = (self._config.group, self._config.port)

        while True:
            for iface in interfaces():
                iface = socket.inet_aton(iface)
                sock.setsockopt(socket.IPPROTO_IP,
                                socket.IP_MULTICAST_IF, iface)
                sock.sendto(b'', addr)

            time.sleep(self._config.update_delay)


def pack(*args):
    return '\0'.join(args).encode()


def unpack(raw):
    ds = raw.decode()
    return ds.split('\0') if '\0' in ds else ds


def interfaces():
    name = socket.gethostname()
    host = socket.gethostbyname_ex(name)
    return host[2]


if __name__ == '__main__':
    if len(sys.argv) > 1:
        config = Configuration(sys.argv[1])
    else:
        config = Configuration()

    pool = PeerPool(config)
    queryHandler = QueryHandler(config, pool)
    receiver = Receiver(config, pool)
    sender = Sender(config)
    queryHandler.start()
    receiver.start()
    sender.start()
