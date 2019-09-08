#!/usr/bin/env python3

import csv
import sys

import requests


class PackageParser:

    def __init__(self, url, data_list):
        self.pkg_list = {}
        self.name_set = set()
        resp = requests.get(url)
        iter = (i.decode() for i in resp.iter_lines())
        reader = csv.reader(iter, delimiter = ' ')

        for row in reader:
            if len(row) < 2:
                continue

            key, *value = row
            key = key[:-1]

            if not key:
                name = value[0]
                pkg = {'category': set(), 'requires': set()}
                self.pkg_list[name] = pkg
            elif key in pkg.keys():
                pkg[key] |= set(value)

        for line in data_list:
            line = line.strip()

            if line:
                self.name_set.add(line)

    def resolve(self, pkg_name):
        pkg = self.pkg_list[pkg_name]
        checked_set = set()
        current_set = pkg['requires']

        while len(current_set):
            next_set = set()

            for current in current_set:
                pkg = self.pkg_list[current]
                next_set |= pkg['requires']

            checked_set |= current_set
            current_set = next_set - checked_set

        return checked_set

    def resolve_all(self):
        dep_set = set()

        for p_name in self.name_set:
            dep_set |= self.resolve(p_name)

        return dep_set

    def category(self, categ):
        res_set = set()

        for pkg_name in self.pkg_list.keys():
            if categ in self.pkg_list[pkg_name]['category']:
                res_set.add(pkg_name)

        return res_set

    def clean(self):
        return self.name_set - self.resolve_all() - self.category('Base')


if __name__ == '__main__':
    parser = PackageParser('https://ftp.fau.de/cygwin/x86_64/setup.ini', sys.stdin)

    for p_name in parser.clean():
        print(p_name)
