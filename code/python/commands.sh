# list trackers from libtorrent files
for i in BT_backup/*.fastresume; do
    python3 -m torrent.parser < "$i"
done | sort -u

# check for dupes based on IP/SLD
egrep -o '([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+|[^.:/]+\.[^.:/]+)($|:|/)' | sed -r 's@[:/]$@@'| sort | uniq -c | awk '$1 > 1'

# filter invalid trackers
for i in $(seq 1 4); do
    python3 -m torrent.tracker < in.txt
done | sort -u

comm -23 {in,good}.txt > old.txt
