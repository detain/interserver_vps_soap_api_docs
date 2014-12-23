#!/bin/bash
# issues can also be a URL for our own site
# travis for http://travis-ci.org/
# theme can be v1 or default

#curl -# -X POST -d name="Interserver VPS API Documentation" -d color="#336699" -d twitter=interserver -d theme=v1 \
#  -d google_analytics="UA-32229521-1" -d travis=false -d issues=true --data-urlencode content@README.md \
#  http://documentup.com/compiled > apidoc.html;
curl -# -A 'Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20100101 Firefox/10.0' \
  http://documentup.com/detain/interserver_vps_soap_api_docs/recompile > apidoc.html;
sed s#"//documentup.com/stylesheets/themes/"#"documentup."#g -i apidoc.html
sed s#"//use.typekit.net/'"#""#g -i apidoc.html

