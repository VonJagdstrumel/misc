#!/bin/bash

kill $(cat .lock | cut -d: -f1)
kill $(cat .lock | cut -d: -f2)
kill $(cat .lock | cut -d: -f3)
taskkill /im nginx.exe /f
rm .lock
