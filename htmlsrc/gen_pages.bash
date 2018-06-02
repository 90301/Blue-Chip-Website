#!/bin/bash
cd "$(dirname "$0")"

gen_page () {
    lineno="$(egrep -n '^\s*<!--\s*CONTENT\s*-->\s*$' template.html | cut -d: -f1)"
    target="../$1"
    head -n "$lineno" template.html > "$target"
    [ -f "$1" ] && cat "$1" >> "$target"
    tail -n "+$lineno" template.html >> "$target"
}

gen_page index.html
gen_page datacenters.html
gen_page publications.html
gen_page team.html
gen_page contact.html
gen_page construction.html
gen_page computers.html
