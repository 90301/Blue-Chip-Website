#!/bin/bash
cd "$(dirname "$0")"

find_content () {
    egrep -n '^\s*<!--\s*CONTENT\s*-->\s*$' "$1" | cut -d: -f1
}

update_template () {
    src="$1"
    if ! [ -f "$src" ]; then
        printf '<!-- CONTENT -->\n<!-- CONTENT -->\n' > "$src"
    fi
    target=".$src.tmp"
    src_linenos=( $(find_content "$src") )
    template_lineno="$(find_content template.html)"
    head -n "$template_lineno" template.html > "$target"
    if [ "$((src_linenos[0] + 1))" -lt "$((src_linenos[-1] - 1))" ]; then
        sed -n "$((src_linenos[0] + 1)),$((src_linenos[-1] - 1))p" "$src" >> "$target"
    fi
    tail -n "+$template_lineno" template.html >> "$target"
    mv "$target" "$src"
}

update_template index.html
update_template datacenters.html
update_template publications.html
update_template team.html
update_template contact.html
update_template construction.html
update_template computers.html
