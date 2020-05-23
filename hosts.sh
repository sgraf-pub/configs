#!/usr/bin/bash
wget --quiet --output-document=- https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts https://raw.githubusercontent.com/sgraf-pub/fakenews-cz-sk/master/hosts | grep -v -e '^#' -e '^$' -e '--' | awk '{ print "server=/"$2"/" }' | sort | uniq | sed -e "1d" > ads.conf

