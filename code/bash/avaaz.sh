IFS=''

read -r -d '' tplData <<'EOF'
Email=~~EMAIL~~
Name=~~NAME~~
CountryID=45
Postcode=75000
City=Paris
fb_reason=
cid=1508
skin=do_blue
lang=fr
is_shared_on_fb=0
petition_id=353506
action=sign
im_not_a_bot=
supports_history_api=true
hash=fDWSwgb
secure_validation=~~DATE~~
used_js=~~DATE~~
EOF

read -r -d '' tplHeaders <<'EOF'
-H 'Host: secure.avaaz.org'
-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:50.0) Gecko/20100101 Firefox/50.0'
-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
-H 'X-Requested-With: XMLHttpRequest'
EOF

for i in {1163..5000}; do
  currEmail=i$(echo $i+514735 | bc -q)@mvrht.com
  currDate=$(LC_ALL=en_US.utf8 date '+%a %b %d %Y %H:%M:%S GMT%z')
  currName="Jean-Pierre Dupont $i"
  currData=$(echo $tplData | tr '\n' '&' | sed "s/~~DATE~~/$currDate/g" | sed "s/~~EMAIL~~/$currEmail/g" | sed "s/~~NAME~~/$currName/g" | sed 's/&&$//')
  ( curl -d "$currData" $(echo $tplHeaders | tr '\n' ' ') 'https://secure.avaaz.org/act/do.php' & ) > /dev/null 2>&1
done
