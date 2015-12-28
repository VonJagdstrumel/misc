@echo off
powershell.exe -Command (new-object System.Net.WebClient).DownloadFile('http://cygwin.com/setup-x86_64.exe','setup-x86_64.exe')
setup-x86_64.exe ^
-s ftp://ftp-stud.hs-esslingen.de/pub/Mirrors/sources.redhat.com/cygwin/ ^
-P attr,bash-completion,bc,bind-utils,cmake,curl,cvs,diffutils,dos2unix,file-devel,gcc-g++,gdb,gettext,libboost-devel,lua-bit,lua-crypto,lua-json,lua-lfs,lua-logging,lua-lpeg,lua-socket,make,man-pages-posix,mingw-gcc-g++,mingw64-i686-gcc-g++,mingw64-x86_64-gcc-g++,nc,openssl-devel,patch,perl,ruby,time,upx,unzip,wget,zsh ^
-l C:\Windows\Temp ^
-D -L -q -n -g -o
del setup-x86_64.exe
