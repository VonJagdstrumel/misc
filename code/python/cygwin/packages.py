#!/usr/bin/env python3

import csv
import sys

import requests

from utils import dataproc


class PackageParser:
    def __init__(self, url):
        self.pkgs = {}
        resp = requests.get(url)
        gen = (i.decode() for i in resp.iter_lines())
        reader = csv.reader(gen, delimiter=' ')

        for row in reader:
            if len(row) < 2:
                continue

            key, *val = row
            key = key[:-1]

            if not key:
                pkg = {'category': set(), 'requires': set()}
                name = val[0]
                self.pkgs[name] = pkg
            elif key in pkg.keys():
                pkg[key] |= set(val)
            elif key == 'provides':
                name = val[0]
                self.pkgs[name] = pkg

    def resolve(self, name):
        res_deps = set()

        if name not in self.pkgs:
            return res_deps

        curr_deps = self.pkgs[name]['requires']

        while len(curr_deps):
            next_deps = set()

            for curr in curr_deps:
                if curr in self.pkgs:
                    next_deps |= self.pkgs[curr]['requires']

            res_deps |= curr_deps
            curr_deps = next_deps - res_deps

        return res_deps

    def resolve_all(self, names):
        res_deps = set()

        for name in names:
            res_deps |= self.resolve(name)

        return res_deps

    def category(self, categ):
        return set(name for name in self.pkgs.keys()
                   if categ in self.pkgs[name]['category'])

    def clean(self, names):
        return names - self.resolve_all(names) - self.category('Base')


if __name__ == '__main__':
    parser = PackageParser('https://ftp.fau.de/cygwin/x86_64/setup.ini')
    names = set(dataproc.clean_reader(sys.stdin))

    for name in parser.clean(names):
        print(name)
