# list trackers from libtorrent files
for i in $(find torrent -name "*.fastresume"); do
    ./torrent_parser.py < "$i"
done | sort -u

# check for dupes based on IP/SLD
cat list/current.txt | egrep -o '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|[^.:/]+\.[^.:/]+)($|:|/)' | sed -r 's@[:/]$@@' | sort | uniq -c

# filter invalid trackers
for i in $(seq 1 10); do
    ./tracker_checker.py < list/current.txt
done | sort -u
