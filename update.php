<?php
$cmd = 'curl "http://documentup.com/detain/interserver_vps_soap_api_docs/" -# | sed -e s#"//documentup.com/stylesheets/themes/"#"documentup."#g -e s#"//use.typekit.net/\'"#""#g;';
// -d name="InterServer API Documentation" -d color="#336699" -d twitter="interserver" -d theme="v1" -d google_analytics="UA-32229521-1" -d travis="false" -d issues="true";';
// -A "Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20100101 Firefox/10.0";';
$json = `$cmd`;
$json = trim($json);
$json = json_decode($json);
file_put_contents('apidoc.html', $json->html);
?>
