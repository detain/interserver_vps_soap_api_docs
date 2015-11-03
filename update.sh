#!/bin/bash
# issues can also be a URL for our own site
# travis for http://travis-ci.org/
# theme can be v1 or default
#agent="Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20100101 Firefox/10.0";
agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2553.1 Safari/537.36";
repo="detain/interserver_vps_soap_api_docs"
title="InterServer API Documentation"
ga="UA-32229521-1"
color="#336699"
issues="true"
travis="false"
twitter="interserver"
theme="v1"
#curl -# -X POST -d name="${title}" -d color="${color} -d twitter="${twitter}" -d theme="${theme}" \
#  -d google_analytics="${ga}" -d travis="${travis}" -d issues="${issues}" --data-urlencode content@README.md \
#  http://documentup.com/compiled > apidoc.html;
#curl http://documentup.com/${repo}/__recompile -# -X POST -d name="${title}" -d color="${color} -d twitter="${twitter}" -d theme="${theme}" -d google_analytics="${ga}" -d travis="${travis}" -d issues="${issues}" -A "${agent}"  ;
#curl -# -X POST -d name="${title}" -d color="${color} -d twitter="${twitter}" -d theme="${theme}" -d google_analytics="${ga}" -d travis="${travis}" -d issues="${issues}" -A "${agent}"  http://documentup.com/${repo} > apidoc.html;
curl -# -A "${agent}" http://documentup.com/${repo}/__recompile  > apidoc.html;
curl -# -A "${agent}" http://documentup.com/${repo}  > apidoc.html;
sed s#"//documentup.com/stylesheets/themes/"#"documentup."#g -i apidoc.html
sed s#"//use.typekit.net/'"#""#g -i apidoc.html
