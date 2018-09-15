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
    title_line="$(egrep '^\s*<title>.*</title>\s*$' "$src" | head -n1)"
    mobile_line="$(egrep '^\s*<h3 id="mobile-title".*</h3>\s*$' "$src" | head -n1)"
    src_linenos=( $(find_content "$src") )
    template_lineno="$(find_content template.html)"
    head -n "$template_lineno" template.html > "$target"
    if [ "$((src_linenos[0] + 1))" -lt "$((src_linenos[-1] - 1))" ]; then
        sed -n "$((src_linenos[0] + 1)),$((src_linenos[-1] - 1))p" "$src" >> "$target"
    fi
    tail -n "+$template_lineno" template.html >> "$target"
    ( echo "$mobile_line" ; ( echo "$title_line" ; cat "$target" ) \
        | sed -n '1{h;n};/^\s*<title>.*<\/title>\s*$/{g;p;n};p' ) \
        | sed -n '1{h;n};/^\s*<h3 id="mobile-title".*<\/h3>\s*$/{g;p;n};p' >"$src"
    rm "$target"
}

update_template index.html
update_template datacenters.html
update_template publications.html
update_template team.html
update_template construction.html
update_template computers.html
update_template internships.html
update_template network.html
