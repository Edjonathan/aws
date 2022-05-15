#!/bin/sh

set -e

echo "<pres>" >>
/usr/local/apache2/htdocs/index.html
curl $ECS_CONTAINER_METADATA_URI | jq '.' >>
echo "</pres>" >>
/usr/local/apache2/htdocs/index.html

httpd-foreground