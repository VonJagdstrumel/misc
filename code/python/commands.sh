# list trackers from libtorrent files
find BT_backup -type f -name '*.fastresume' | read -r i; do
    ./torrent_parser.py < "$i"
done | sort -u

# check for dupes based on IP/SLD
egrep -o '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|[^.:/]+\.[^.:/]+)($|:|/)' | sed -r 's@[:/]$@@'| sort | uniq -c

# filter invalid trackers
for i in $(seq 1 4); do
    ./tracker_checker.py < list/current.txt
done | sort -u

comm -12 list/{old,good}.txt
