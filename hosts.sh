#!/usr/bin/bash
curl -s https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts | grep -v -e '^#' -e '^$' | grep '^0\.0\.0\.0' | awk '{ print "address=/"$2"/" }' | grep -v -e 'openload.co' -e 'h\-\-\-' > fgp.conf
curl -s https://raw.githubusercontent.com/sgraf-pub/fakenews-cz-sk/master/hosts | grep -v -e '^#' -e '^$' | grep '^0\.0\.0\.0' | awk '{ print "address=/"$2"/" }' > czf.conf

