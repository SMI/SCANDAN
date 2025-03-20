#!/bin/sh
set -e

git clone https://github.com/sikvesta/brat.git
/brat/install.sh -u << EOF
bratuser
bratpassword
j@sutherland.pw
EOF
