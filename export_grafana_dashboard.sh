#!/bin/bash

set -o errexit
set -o pipefail


FULLURL="${1?Please Provide Grafana URL Full Path -> Usage: ./$0 https://localhost:3000 eyJrIjoiOWpqRXpONHo5UktBSlpTZ2ZP}"
headers="Authorization: Bearer ${2?Please Provide Grafana Token -> Usage: ./$0 https://localhost:3000 eyJrIjoiOWpqRXpONHo5UktBSlpTZ2ZP}"
in_path=dashboards_raw
set -o nounset

echo "Exporting Grafana dashboards from $FULLURL"
mkdir -p $in_path
for dash in $(curl -H "$headers" -s "$FULLURL/api/search?query=&" | jq -r '.[] | select(.type == "dash-db") | .uid'); do
        dash_path="$in_path/$dash.json"
        curl -H "$headers" -s "$FULLURL/api/dashboards/uid/$dash" | jq -r . > $dash_path
        slug=$(cat $dash_path | jq -r '.meta.slug')
        folder="$(cat $dash_path | jq -r '.meta.folderTitle')"
        mkdir -p "$folder"
        mv -fv $dash_path $folder/${dash}-${slug}.json
done

mv General Dashboard_Backup



#bash export.sh http://localhost:3000 "eyJrIjoiOWpqRXpONHo5UktBSlpTZ2ZPSm1YWDU2eHQ2NnV6MmsiLCJuIjoiZmV0Y2giLCJpZCI6MX0="
#https://gist.github.com/crisidev/bd52bdcc7f029be2f295
