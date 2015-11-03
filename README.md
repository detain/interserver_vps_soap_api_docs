# InterServer API Documentation

  - <a href='https://my.interserver.net/'>Login / Signup At <b>InterServer</b></a>
  - <p>Source Sample Downloads:</p>
  - <a href='https://github.com/detain/interserver-api-php-samples' title='Download PHP Samples'>PHP</a>&nbsp;&nbsp;<a href='https://github.com/detain/interserver-api-perl-samples' title='Download Perl Samples'>Perl</a>&nbsp;&nbsp;<a href='https://github.com/detain/interserver-api-python-samples' title='Download Python Samples'>Python</a>&nbsp;&nbsp;<a href='https://github.com/detain/interserver-api-ruby-samples' title='Download Ruby Samples'>Ruby</a>

## Introduction

Welcome to the InterServer API!  You can use this API to access the featurs you enjoy through our websites.  We have code samples for all of the API calls in many languages and implementnig the API calls in varoius ways.   At the time of this writing we have at least 1 script for each api call in PHP, Python, Perl, and Ruby. 

You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

## Connecting To the API

### Prerequisites and API URLs

> API Endpoint: [https://my.interserver.net/api.php](https://my.interserver.net/api.php)<br>
> WSDL File: [https://my.interserver.net/api.php?wsdl](https://my.interserver.net/api.php?wsdl)

To use the API you will need to first have an account with us.  You can sign up for an account at [http://my.interserver.net/](http://my.interserver.net/)

* You will need the login name (email address) you used to sign up with InterServer and your password.
* The SOAP server is accessible at [https://my.interserver.net/api.php](https://my.interserver.net/api.php)
* The WSDL is available at [https://my.interserver.net/api.php?wsdl](https://my.interserver.net/api.php?wsdl)


### Authentication
> Use this code to authenticate and get a **session id**.   Make sure to replace 'username@site.com' and 'password' with your actual info

```php
<?php
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
$session_id = $client->api_login('username@site.com', 'password');
if (!strlen($session_id) > 0)
	die("Failure!\nNo Session Returned - Bad Login Info\n");
echo "Success!\n Got Session ID: {$session_id}\n”;
// Rest of code logic would go here
?>
```
```perl
use SOAP::Lite;
print SOAP::Lite
-> uri('urn:myapi')
-> proxy('https://my.interserver.net/api.php?wsdl')
-> api_login('username@site.com', 'password')
-> result;
```
```ruby
require 'savon'

## create a client for the service
client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(:api_login, message: {})
print response.body[:api_login_response][:return],"\n"
```
```python
from pysimplesoap.client import SoapClient
client = SoapClient(wsdl="https://my.interserver.net/api.php?WSDL",trace=False)
response = client.api_login('username@site.com', 'password')
print response
```

* We use a session based authentication system.   You will need to authenticate yourself with our system to get a Session ID.   Once you have a Session ID, you just pass that to prove your identity.  

* To get a Session ID, you need to make a SOAP call to api_login(login, password)  using the information you use to login to [https://my.interserver.net](https://my.interserver.net)

* Sending an api_login(login, password) call will attempt to authenticate your account and if successful will return a Session ID valid for at least several hours.    Subsequent commands and calls to the API will need this Session ID, so keep it handy.

<aside class="notice">
The Session ID, or SID will be needed for most future commands so store this value in a variable for later use!
</aside>

## Billing




### Add Prepay

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$module = $ARGV[2];
$amount = $ARGV[3];
$automatic_use = $ARGV[4];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_add_prepay($sid, $module, $amount, $automatic_use);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_add_prepay()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_add_prepay, message: { 
    sid: ARGV[0], 
    module: ARGV[1], 
    amount: ARGV[2], 
    automatic_use: ARGV[3], 
})
print response.body[:api_add_prepay_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$module = $_SERVER['argv'][3];
$amount = $_SERVER['argv'][4];
$automatic_use = $_SERVER['argv'][5];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_add_prepay($sid, $module, $amount, $automatic_use);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_add_prepay**

Adds a PrePay into the system under the given module.    PrePays are a credit on
* your account by prefilling  your account with funds.   These are stored in a
* PrePay.    PrePay funds can be automaticaly used as needed or set to only be
* usable by direct action

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
module|string|the module the prepay is for. use [get_modules](#get_modules) to get a list of modules
amount|float|the dollar amount of prepay total
automatic_use|bool|wether or not the prepay will get used automatically by billing system.

#### Output Fields

Field|Type|Description
-----|----|-----------
return|int|the prepay id


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Integer</td>
			<td>1274</td>
		</tr>
	</tbody>
</table>


### Backups Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_backups_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_cancel_service**

This Function Applies to the Backup Services services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Backups Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_backups_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_get_client_invoices**

This Function Applies to the Backup Services services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Backups Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_backups_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_get_client_unpaid_invoices**

This Function Applies to the Backup Services services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Cancel License Ip

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$ip = $ARGV[2];
$type = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_cancel_license_ip($sid, $ip, $type);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_cancel_license_ip()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_cancel_license_ip, message: { 
    sid: ARGV[0], 
    ip: ARGV[1], 
    type: ARGV[2], 
})
print response.body[:api_cancel_license_ip_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$ip = $_SERVER['argv'][3];
$type = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_cancel_license_ip($sid, $ip, $type);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_cancel_license_ip**

Cancel a License by IP and Type.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
ip|string|IP Address to cancel
type|int|Package ID. use [get_license_types](#get-license-types) to get a list of possible types.

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Invalid License IP/Type</td>
		</tr>
	</tbody>
</table>


### Cancel License

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_cancel_license($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_cancel_license()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_cancel_license, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_cancel_license_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_cancel_license($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_cancel_license**

Cancel a License.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|License Order ID

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Invalid License ID</td>
		</tr>
	</tbody>
</table>


### Domains Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_domains_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_cancel_service**

This Function Applies to the Domain Registrations services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Domains Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_domains_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_get_client_invoices**

This Function Applies to the Domain Registrations services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Domains Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_domains_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_get_client_unpaid_invoices**

This Function Applies to the Domain Registrations services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Get Paypal Url

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$module = $ARGV[0];
$invoice = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> api_get_paypal_url($module, $invoice);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
  
result = client.service.api_get_paypal_url()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(
  :api_get_paypal_url, message: { 
    module: ARGV[0], 
    invoice: ARGV[1], 
})
print response.body[:api_get_paypal_url_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$module = $_SERVER['argv'][1];
$invoice = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->api_get_paypal_url($module, $invoice);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_paypal_url**

Get the PayPal payment URL for an invoice on a given module.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
module|string|the module the invoice is for. use [get_modules](#get_modules) to get a list of modules
invoice|int|the invoice id, or a comma seperated list of invoice ids to get a payment url for.  

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|the paypal payment url.


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>String</td>
			<td><a href="https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=vps@interserver.net&item_name=%28Repeat+Invoice%3A+385928%29+INTERSERVER-EXTERNAL&custom=INVdomains10000&buyer_credit_promo_code=&buyer_credit_product_category=&buyer_credit_shipping_method=&buyer_credit_user_address_change=&amount=34.00&no_shipping=0&no_note=1&currency_code=USD&lc=US&bn=PP%2dBuyNowBF&charset=UTF%2d8" target=_blank>Click Here to make a PayPal payment</a></td>
		</tr>
	</tbody>
</table>


### Get Prepay List

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_get_prepay_list($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_get_prepay_list()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_get_prepay_list, message: { 
    sid: ARGV[0], 
})
print response.body[:api_get_prepay_list_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_get_prepay_list($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_prepay_list**

Gets a list of your current prepays added into the system and how much is left
* on each one.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
prepay_id|int|
prepay_type|int|
prepay_status|string|
prepay_date|string|
prepay_created|string|
prepay_amount|float|
prepay_remaining|float|
prepay_service|int|
prepay_automatic_use|int|
prepay_module|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Prepay Id
			</th>
			<th>
				Prepay Type
			</th>
			<th>
				Prepay Status
			</th>
			<th>
				Prepay Date
			</th>
			<th>
				Prepay Created
			</th>
			<th>
				Prepay Amount
			</th>
			<th>
				Prepay Remaining
			</th>
			<th>
				Prepay Service
			</th>
			<th>
				Prepay Automatic Use
			</th>
			<th>
				Prepay Module
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				1116
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:06:37
			</td>
			<td>
				2015-10-29 23:06:37
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1117
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:10:23
			</td>
			<td>
				2015-10-29 23:10:23
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1118
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:26:52
			</td>
			<td>
				2015-10-29 23:26:52
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1119
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:28:27
			</td>
			<td>
				2015-10-29 23:28:27
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1120
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:36:50
			</td>
			<td>
				2015-10-29 23:36:50
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1121
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:44:48
			</td>
			<td>
				2015-10-29 23:44:48
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1122
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:52:55
			</td>
			<td>
				2015-10-29 23:52:55
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1123
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:57:24
			</td>
			<td>
				2015-10-29 23:57:24
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1124
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-29 23:58:56
			</td>
			<td>
				2015-10-29 23:58:56
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1125
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 00:03:50
			</td>
			<td>
				2015-10-30 00:03:50
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1126
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 00:04:34
			</td>
			<td>
				2015-10-30 00:04:34
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1127
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 00:29:32
			</td>
			<td>
				2015-10-30 00:29:32
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1128
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 00:31:38
			</td>
			<td>
				2015-10-30 00:31:38
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1129
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 00:48:41
			</td>
			<td>
				2015-10-30 00:48:41
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1130
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:02:53
			</td>
			<td>
				2015-10-30 01:02:53
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1131
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:09:31
			</td>
			<td>
				2015-10-30 01:09:31
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1132
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:13:03
			</td>
			<td>
				2015-10-30 01:13:03
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1133
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:14:30
			</td>
			<td>
				2015-10-30 01:14:30
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1134
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:15:18
			</td>
			<td>
				2015-10-30 01:15:18
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1135
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:17:42
			</td>
			<td>
				2015-10-30 01:17:42
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1136
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:18:04
			</td>
			<td>
				2015-10-30 01:18:04
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1137
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:19:13
			</td>
			<td>
				2015-10-30 01:19:13
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1138
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:20:54
			</td>
			<td>
				2015-10-30 01:20:54
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1139
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:21:19
			</td>
			<td>
				2015-10-30 01:21:19
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1140
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:22:44
			</td>
			<td>
				2015-10-30 01:22:44
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1141
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:40:44
			</td>
			<td>
				2015-10-30 01:40:44
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1142
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 01:54:02
			</td>
			<td>
				2015-10-30 01:54:02
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1143
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:01:25
			</td>
			<td>
				2015-10-30 02:01:25
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1144
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:15:47
			</td>
			<td>
				2015-10-30 02:15:47
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1145
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:23:04
			</td>
			<td>
				2015-10-30 02:23:04
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1146
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:26:35
			</td>
			<td>
				2015-10-30 02:26:35
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1147
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:36:40
			</td>
			<td>
				2015-10-30 02:36:40
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1148
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:39:59
			</td>
			<td>
				2015-10-30 02:39:59
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1149
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:42:15
			</td>
			<td>
				2015-10-30 02:42:15
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1150
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:44:05
			</td>
			<td>
				2015-10-30 02:44:05
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1151
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 02:56:59
			</td>
			<td>
				2015-10-30 02:56:59
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1152
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 04:27:34
			</td>
			<td>
				2015-10-30 04:27:34
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1156
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 14:48:00
			</td>
			<td>
				2015-10-30 14:48:00
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1157
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 14:55:41
			</td>
			<td>
				2015-10-30 14:55:41
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1158
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 14:55:57
			</td>
			<td>
				2015-10-30 14:55:57
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1159
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:00:26
			</td>
			<td>
				2015-10-30 15:00:26
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1160
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:01:13
			</td>
			<td>
				2015-10-30 15:01:13
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1161
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:02:57
			</td>
			<td>
				2015-10-30 15:02:57
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1162
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:05:15
			</td>
			<td>
				2015-10-30 15:05:15
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1163
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:08:01
			</td>
			<td>
				2015-10-30 15:08:01
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1164
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:15:26
			</td>
			<td>
				2015-10-30 15:15:26
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1165
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:21:50
			</td>
			<td>
				2015-10-30 15:21:50
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1166
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:27:48
			</td>
			<td>
				2015-10-30 15:27:48
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1167
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:29:10
			</td>
			<td>
				2015-10-30 15:29:10
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1168
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:29:23
			</td>
			<td>
				2015-10-30 15:29:23
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1169
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:29:43
			</td>
			<td>
				2015-10-30 15:29:43
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1170
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:29:52
			</td>
			<td>
				2015-10-30 15:29:52
			</td>
			<td>
				109
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1171
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:29:55
			</td>
			<td>
				2015-10-30 15:29:55
			</td>
			<td>
				109
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1172
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:29:57
			</td>
			<td>
				2015-10-30 15:29:57
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1173
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:35:31
			</td>
			<td>
				2015-10-30 15:35:31
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1174
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:44:53
			</td>
			<td>
				2015-10-30 15:44:53
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1175
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:45:06
			</td>
			<td>
				2015-10-30 15:45:06
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1176
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:45:44
			</td>
			<td>
				2015-10-30 15:45:44
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1177
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:48:39
			</td>
			<td>
				2015-10-30 15:48:39
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1178
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:50:22
			</td>
			<td>
				2015-10-30 15:50:22
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1179
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:51:26
			</td>
			<td>
				2015-10-30 15:51:26
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1180
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:52:00
			</td>
			<td>
				2015-10-30 15:52:00
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1181
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 15:53:00
			</td>
			<td>
				2015-10-30 15:53:00
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1182
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-10-30 16:26:46
			</td>
			<td>
				2015-10-30 16:26:46
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1246
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 11:21:14
			</td>
			<td>
				2015-11-03 11:21:14
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1247
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:28:39
			</td>
			<td>
				2015-11-03 12:28:39
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1248
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:31:39
			</td>
			<td>
				2015-11-03 12:31:39
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1249
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:34:45
			</td>
			<td>
				2015-11-03 12:34:45
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1250
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:38:22
			</td>
			<td>
				2015-11-03 12:38:22
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1251
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:41:20
			</td>
			<td>
				2015-11-03 12:41:20
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1253
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:44:51
			</td>
			<td>
				2015-11-03 12:44:51
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1254
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 12:50:16
			</td>
			<td>
				2015-11-03 12:50:16
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1255
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:35:18
			</td>
			<td>
				2015-11-03 13:35:18
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1256
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:44:03
			</td>
			<td>
				2015-11-03 13:44:03
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1257
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:46:17
			</td>
			<td>
				2015-11-03 13:46:17
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1258
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:48:09
			</td>
			<td>
				2015-11-03 13:48:09
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1259
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:51:14
			</td>
			<td>
				2015-11-03 13:51:14
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1260
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:59:41
			</td>
			<td>
				2015-11-03 13:59:41
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1261
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 13:59:52
			</td>
			<td>
				2015-11-03 13:59:52
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1262
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:02:00
			</td>
			<td>
				2015-11-03 14:02:00
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1263
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:03:35
			</td>
			<td>
				2015-11-03 14:03:35
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1264
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:04:33
			</td>
			<td>
				2015-11-03 14:04:33
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1265
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:06:21
			</td>
			<td>
				2015-11-03 14:06:21
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1266
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:08:45
			</td>
			<td>
				2015-11-03 14:08:45
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1267
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:15:31
			</td>
			<td>
				2015-11-03 14:15:31
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1268
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:30:40
			</td>
			<td>
				2015-11-03 14:30:40
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1269
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:31:36
			</td>
			<td>
				2015-11-03 14:31:36
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1270
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 14:36:05
			</td>
			<td>
				2015-11-03 14:36:05
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1271
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 16:47:31
			</td>
			<td>
				2015-11-03 16:47:31
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1272
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 16:52:46
			</td>
			<td>
				2015-11-03 16:52:46
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1273
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 16:58:52
			</td>
			<td>
				2015-11-03 16:58:52
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				1274
			</td>
			<td>
				-1
			</td>
			<td>
				
			</td>
			<td>
				2015-11-03 17:01:43
			</td>
			<td>
				2015-11-03 17:01:43
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
			<td>
				0
			</td>
			<td>
				1
			</td>
			<td>
				domains
			</td>
		</tr>
	</tbody>
</table>


### Get Prepay Paypal Fill Url

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$module = $ARGV[2];
$prepay_id = $ARGV[3];
$amount = $ARGV[4];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_get_prepay_paypal_fill_url($sid, $module, $prepay_id, $amount);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_get_prepay_paypal_fill_url()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_get_prepay_paypal_fill_url, message: { 
    sid: ARGV[0], 
    module: ARGV[1], 
    prepay_id: ARGV[2], 
    amount: ARGV[3], 
})
print response.body[:api_get_prepay_paypal_fill_url_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$module = $_SERVER['argv'][3];
$prepay_id = $_SERVER['argv'][4];
$amount = $_SERVER['argv'][5];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_get_prepay_paypal_fill_url($sid, $module, $prepay_id, $amount);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_prepay_paypal_fill_url**

Gets a PayPal URL to fill a PrePay.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
module|string|the module the prepay is for. use [get_modules](#get_modules) to get a list of modules
prepay_id|int|the ID of the PrePay
amount|float|the amount to pay on the prepay.

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|a paypal payment url.


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>String</td>
			<td>https://www.paypal.com/cgi-bin/webscr?cmd=_xclick&business=vps@interserver.net&item_name=Fill+domains+PrePay+100&custom=PREPAYdomains100&buyer_credit_promo_code=&buyer_credit_product_category=&buyer_credit_shipping_method=&buyer_credit_user_address_change=&amount=10.00&no_shipping=0&no_note=1&currency_code=USD&lc=US&bn=PP%2dBuyNowBF&charset=UTF%2d8</td>
		</tr>
	</tbody>
</table>


### Get Prepay Remaining

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$module = $ARGV[0];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> api_get_prepay_remaining($module);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
  
result = client.service.api_get_prepay_remaining()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(
  :api_get_prepay_remaining, message: { 
    module: ARGV[0], 
})
print response.body[:api_get_prepay_remaining_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$module = $_SERVER['argv'][1];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->api_get_prepay_remaining($module);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_prepay_remaining**

Get the PrePay amount available for a given module.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
module|string|the module you want to check your prepay amounts on

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>String</td>
			<td>Array</td>
		</tr>
	</tbody>
</table>


### Licenses Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_licenses_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_cancel_service**

This Function Applies to the Licensing services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Licenses Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_licenses_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_get_client_invoices**

This Function Applies to the Licensing services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Invoices Id
			</th>
			<th>
				Invoices Description
			</th>
			<th>
				Invoices Amount
			</th>
			<th>
				Invoices Custid
			</th>
			<th>
				Invoices Type
			</th>
			<th>
				Invoices Date
			</th>
			<th>
				Invoices Group
			</th>
			<th>
				Invoices Extra
			</th>
			<th>
				Invoices Paid
			</th>
			<th>
				Invoices Module
			</th>
			<th>
				Invoices Due Date
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				2514249
			</td>
			<td>
				(Repeat Invoice: 2504689) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:40
			</td>
			<td>
				0
			</td>
			<td>
				2504689
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:40
			</td>
		</tr>
		<tr>
			<td>
				2514250
			</td>
			<td>
				(Repeat Invoice: 2504690) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:56
			</td>
			<td>
				0
			</td>
			<td>
				2504690
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:56
			</td>
		</tr>
		<tr>
			<td>
				2514251
			</td>
			<td>
				(Repeat Invoice: 2504691) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:00:25
			</td>
			<td>
				0
			</td>
			<td>
				2504691
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:00:25
			</td>
		</tr>
		<tr>
			<td>
				2514252
			</td>
			<td>
				(Repeat Invoice: 2504692) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:01:12
			</td>
			<td>
				0
			</td>
			<td>
				2504692
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:01:12
			</td>
		</tr>
		<tr>
			<td>
				2514255
			</td>
			<td>
				(Repeat Invoice: 2504694) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:02:56
			</td>
			<td>
				0
			</td>
			<td>
				2504694
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:02:56
			</td>
		</tr>
		<tr>
			<td>
				2514256
			</td>
			<td>
				(Repeat Invoice: 2504695) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:05:14
			</td>
			<td>
				0
			</td>
			<td>
				2504695
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:05:14
			</td>
		</tr>
		<tr>
			<td>
				2514257
			</td>
			<td>
				(Repeat Invoice: 2504696) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:15:25
			</td>
			<td>
				0
			</td>
			<td>
				2504696
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:15:25
			</td>
		</tr>
		<tr>
			<td>
				2514258
			</td>
			<td>
				(Repeat Invoice: 2504697) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:21:50
			</td>
			<td>
				0
			</td>
			<td>
				2504697
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:21:50
			</td>
		</tr>
		<tr>
			<td>
				2514259
			</td>
			<td>
				(Repeat Invoice: 2504698) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:27:46
			</td>
			<td>
				0
			</td>
			<td>
				2504698
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:27:46
			</td>
		</tr>
		<tr>
			<td>
				2514262
			</td>
			<td>
				(Repeat Invoice: 2504700) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:35:30
			</td>
			<td>
				0
			</td>
			<td>
				2504700
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:35:30
			</td>
		</tr>
		<tr>
			<td>
				2514263
			</td>
			<td>
				(Repeat Invoice: 2504701) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:48:38
			</td>
			<td>
				0
			</td>
			<td>
				2504701
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:48:38
			</td>
		</tr>
		<tr>
			<td>
				2514264
			</td>
			<td>
				(Repeat Invoice: 2504702) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:50:21
			</td>
			<td>
				0
			</td>
			<td>
				2504702
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:50:21
			</td>
		</tr>
		<tr>
			<td>
				2514265
			</td>
			<td>
				(Repeat Invoice: 2504703) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:51:59
			</td>
			<td>
				0
			</td>
			<td>
				2504703
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:51:59
			</td>
		</tr>
		<tr>
			<td>
				2514266
			</td>
			<td>
				(Repeat Invoice: 2504704) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 16:26:45
			</td>
			<td>
				0
			</td>
			<td>
				2504704
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 16:26:45
			</td>
		</tr>
		<tr>
			<td>
				2515314
			</td>
			<td>
				(Repeat Invoice: 2504881) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 11:21:14
			</td>
			<td>
				0
			</td>
			<td>
				2504881
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 11:21:14
			</td>
		</tr>
		<tr>
			<td>
				2515335
			</td>
			<td>
				(Repeat Invoice: 2504886) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:28:38
			</td>
			<td>
				0
			</td>
			<td>
				2504886
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:28:38
			</td>
		</tr>
		<tr>
			<td>
				2515336
			</td>
			<td>
				(Repeat Invoice: 2504887) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:31:38
			</td>
			<td>
				0
			</td>
			<td>
				2504887
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:31:38
			</td>
		</tr>
		<tr>
			<td>
				2515340
			</td>
			<td>
				(Repeat Invoice: 2504890) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:34:44
			</td>
			<td>
				0
			</td>
			<td>
				2504890
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:34:44
			</td>
		</tr>
		<tr>
			<td>
				2515341
			</td>
			<td>
				(Repeat Invoice: 2504891) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:38:22
			</td>
			<td>
				0
			</td>
			<td>
				2504891
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:38:22
			</td>
		</tr>
		<tr>
			<td>
				2515343
			</td>
			<td>
				(Repeat Invoice: 2504892) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:41:19
			</td>
			<td>
				0
			</td>
			<td>
				2504892
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:41:19
			</td>
		</tr>
		<tr>
			<td>
				2515347
			</td>
			<td>
				(Repeat Invoice: 2504895) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:44:51
			</td>
			<td>
				0
			</td>
			<td>
				2504895
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:44:51
			</td>
		</tr>
		<tr>
			<td>
				2515351
			</td>
			<td>
				(Repeat Invoice: 2504897) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:50:15
			</td>
			<td>
				0
			</td>
			<td>
				2504897
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:50:15
			</td>
		</tr>
		<tr>
			<td>
				2515359
			</td>
			<td>
				(Repeat Invoice: 2504902) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:35:17
			</td>
			<td>
				0
			</td>
			<td>
				2504902
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:35:17
			</td>
		</tr>
		<tr>
			<td>
				2515362
			</td>
			<td>
				(Repeat Invoice: 2504904) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:44:02
			</td>
			<td>
				0
			</td>
			<td>
				2504904
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:44:02
			</td>
		</tr>
		<tr>
			<td>
				2515363
			</td>
			<td>
				(Repeat Invoice: 2504905) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:46:16
			</td>
			<td>
				0
			</td>
			<td>
				2504905
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:46:16
			</td>
		</tr>
		<tr>
			<td>
				2515364
			</td>
			<td>
				(Repeat Invoice: 2504906) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:48:08
			</td>
			<td>
				0
			</td>
			<td>
				2504906
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:48:08
			</td>
		</tr>
		<tr>
			<td>
				2515365
			</td>
			<td>
				(Repeat Invoice: 2504907) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:51:13
			</td>
			<td>
				0
			</td>
			<td>
				2504907
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:51:13
			</td>
		</tr>
		<tr>
			<td>
				2515366
			</td>
			<td>
				(Repeat Invoice: 2504908) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:40
			</td>
			<td>
				0
			</td>
			<td>
				2504908
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:40
			</td>
		</tr>
		<tr>
			<td>
				2515367
			</td>
			<td>
				(Repeat Invoice: 2504909) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:51
			</td>
			<td>
				0
			</td>
			<td>
				2504909
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:51
			</td>
		</tr>
		<tr>
			<td>
				2515368
			</td>
			<td>
				(Repeat Invoice: 2504910) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:01:59
			</td>
			<td>
				0
			</td>
			<td>
				2504910
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:01:59
			</td>
		</tr>
		<tr>
			<td>
				2515369
			</td>
			<td>
				(Repeat Invoice: 2504911) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:03:34
			</td>
			<td>
				0
			</td>
			<td>
				2504911
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:03:34
			</td>
		</tr>
		<tr>
			<td>
				2515370
			</td>
			<td>
				(Repeat Invoice: 2504912) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:04:33
			</td>
			<td>
				0
			</td>
			<td>
				2504912
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:04:33
			</td>
		</tr>
		<tr>
			<td>
				2515371
			</td>
			<td>
				(Repeat Invoice: 2504913) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:06:20
			</td>
			<td>
				0
			</td>
			<td>
				2504913
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:06:20
			</td>
		</tr>
		<tr>
			<td>
				2515372
			</td>
			<td>
				(Repeat Invoice: 2504914) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:08:44
			</td>
			<td>
				0
			</td>
			<td>
				2504914
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:08:44
			</td>
		</tr>
		<tr>
			<td>
				2515373
			</td>
			<td>
				(Repeat Invoice: 2504915) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:15:31
			</td>
			<td>
				0
			</td>
			<td>
				2504915
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:15:31
			</td>
		</tr>
		<tr>
			<td>
				2515375
			</td>
			<td>
				(Repeat Invoice: 2504916) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:30:39
			</td>
			<td>
				0
			</td>
			<td>
				2504916
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:30:39
			</td>
		</tr>
		<tr>
			<td>
				2515376
			</td>
			<td>
				(Repeat Invoice: 2504917) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:31:35
			</td>
			<td>
				0
			</td>
			<td>
				2504917
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:31:35
			</td>
		</tr>
		<tr>
			<td>
				2515377
			</td>
			<td>
				(Repeat Invoice: 2504918) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:36:04
			</td>
			<td>
				0
			</td>
			<td>
				2504918
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:36:04
			</td>
		</tr>
		<tr>
			<td>
				2515389
			</td>
			<td>
				(Repeat Invoice: 2504927) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:47:30
			</td>
			<td>
				0
			</td>
			<td>
				2504927
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:47:30
			</td>
		</tr>
		<tr>
			<td>
				2515392
			</td>
			<td>
				(Repeat Invoice: 2504929) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:52:45
			</td>
			<td>
				0
			</td>
			<td>
				2504929
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:52:45
			</td>
		</tr>
		<tr>
			<td>
				2515393
			</td>
			<td>
				(Repeat Invoice: 2504930) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:58:51
			</td>
			<td>
				0
			</td>
			<td>
				2504930
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:58:51
			</td>
		</tr>
		<tr>
			<td>
				2515394
			</td>
			<td>
				(Repeat Invoice: 2504931) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 17:01:43
			</td>
			<td>
				0
			</td>
			<td>
				2504931
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 17:01:43
			</td>
		</tr>
	</tbody>
</table>


### Licenses Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_licenses_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_get_client_unpaid_invoices**

This Function Applies to the Licensing services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Invoices Id
			</th>
			<th>
				Invoices Description
			</th>
			<th>
				Invoices Amount
			</th>
			<th>
				Invoices Custid
			</th>
			<th>
				Invoices Type
			</th>
			<th>
				Invoices Date
			</th>
			<th>
				Invoices Group
			</th>
			<th>
				Invoices Extra
			</th>
			<th>
				Invoices Paid
			</th>
			<th>
				Invoices Module
			</th>
			<th>
				Invoices Due Date
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				2514249
			</td>
			<td>
				(Repeat Invoice: 2504689) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:40
			</td>
			<td>
				0
			</td>
			<td>
				2504689
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:40
			</td>
		</tr>
		<tr>
			<td>
				2514250
			</td>
			<td>
				(Repeat Invoice: 2504690) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:56
			</td>
			<td>
				0
			</td>
			<td>
				2504690
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:56
			</td>
		</tr>
		<tr>
			<td>
				2514251
			</td>
			<td>
				(Repeat Invoice: 2504691) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:00:25
			</td>
			<td>
				0
			</td>
			<td>
				2504691
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:00:25
			</td>
		</tr>
		<tr>
			<td>
				2514252
			</td>
			<td>
				(Repeat Invoice: 2504692) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:01:12
			</td>
			<td>
				0
			</td>
			<td>
				2504692
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:01:12
			</td>
		</tr>
		<tr>
			<td>
				2514255
			</td>
			<td>
				(Repeat Invoice: 2504694) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:02:56
			</td>
			<td>
				0
			</td>
			<td>
				2504694
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:02:56
			</td>
		</tr>
		<tr>
			<td>
				2514256
			</td>
			<td>
				(Repeat Invoice: 2504695) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:05:14
			</td>
			<td>
				0
			</td>
			<td>
				2504695
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:05:14
			</td>
		</tr>
		<tr>
			<td>
				2514257
			</td>
			<td>
				(Repeat Invoice: 2504696) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:15:25
			</td>
			<td>
				0
			</td>
			<td>
				2504696
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:15:25
			</td>
		</tr>
		<tr>
			<td>
				2514258
			</td>
			<td>
				(Repeat Invoice: 2504697) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:21:50
			</td>
			<td>
				0
			</td>
			<td>
				2504697
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:21:50
			</td>
		</tr>
		<tr>
			<td>
				2514259
			</td>
			<td>
				(Repeat Invoice: 2504698) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:27:46
			</td>
			<td>
				0
			</td>
			<td>
				2504698
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:27:46
			</td>
		</tr>
		<tr>
			<td>
				2514262
			</td>
			<td>
				(Repeat Invoice: 2504700) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:35:30
			</td>
			<td>
				0
			</td>
			<td>
				2504700
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:35:30
			</td>
		</tr>
		<tr>
			<td>
				2514263
			</td>
			<td>
				(Repeat Invoice: 2504701) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:48:38
			</td>
			<td>
				0
			</td>
			<td>
				2504701
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:48:38
			</td>
		</tr>
		<tr>
			<td>
				2514264
			</td>
			<td>
				(Repeat Invoice: 2504702) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:50:21
			</td>
			<td>
				0
			</td>
			<td>
				2504702
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:50:21
			</td>
		</tr>
		<tr>
			<td>
				2514265
			</td>
			<td>
				(Repeat Invoice: 2504703) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:51:59
			</td>
			<td>
				0
			</td>
			<td>
				2504703
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:51:59
			</td>
		</tr>
		<tr>
			<td>
				2514266
			</td>
			<td>
				(Repeat Invoice: 2504704) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 16:26:45
			</td>
			<td>
				0
			</td>
			<td>
				2504704
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 16:26:45
			</td>
		</tr>
		<tr>
			<td>
				2515314
			</td>
			<td>
				(Repeat Invoice: 2504881) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 11:21:14
			</td>
			<td>
				0
			</td>
			<td>
				2504881
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 11:21:14
			</td>
		</tr>
		<tr>
			<td>
				2515335
			</td>
			<td>
				(Repeat Invoice: 2504886) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:28:38
			</td>
			<td>
				0
			</td>
			<td>
				2504886
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:28:38
			</td>
		</tr>
		<tr>
			<td>
				2515336
			</td>
			<td>
				(Repeat Invoice: 2504887) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:31:38
			</td>
			<td>
				0
			</td>
			<td>
				2504887
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:31:38
			</td>
		</tr>
		<tr>
			<td>
				2515340
			</td>
			<td>
				(Repeat Invoice: 2504890) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:34:44
			</td>
			<td>
				0
			</td>
			<td>
				2504890
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:34:44
			</td>
		</tr>
		<tr>
			<td>
				2515341
			</td>
			<td>
				(Repeat Invoice: 2504891) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:38:22
			</td>
			<td>
				0
			</td>
			<td>
				2504891
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:38:22
			</td>
		</tr>
		<tr>
			<td>
				2515343
			</td>
			<td>
				(Repeat Invoice: 2504892) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:41:19
			</td>
			<td>
				0
			</td>
			<td>
				2504892
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:41:19
			</td>
		</tr>
		<tr>
			<td>
				2515347
			</td>
			<td>
				(Repeat Invoice: 2504895) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:44:51
			</td>
			<td>
				0
			</td>
			<td>
				2504895
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:44:51
			</td>
		</tr>
		<tr>
			<td>
				2515351
			</td>
			<td>
				(Repeat Invoice: 2504897) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:50:15
			</td>
			<td>
				0
			</td>
			<td>
				2504897
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:50:15
			</td>
		</tr>
		<tr>
			<td>
				2515359
			</td>
			<td>
				(Repeat Invoice: 2504902) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:35:17
			</td>
			<td>
				0
			</td>
			<td>
				2504902
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:35:17
			</td>
		</tr>
		<tr>
			<td>
				2515362
			</td>
			<td>
				(Repeat Invoice: 2504904) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:44:02
			</td>
			<td>
				0
			</td>
			<td>
				2504904
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:44:02
			</td>
		</tr>
		<tr>
			<td>
				2515363
			</td>
			<td>
				(Repeat Invoice: 2504905) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:46:16
			</td>
			<td>
				0
			</td>
			<td>
				2504905
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:46:16
			</td>
		</tr>
		<tr>
			<td>
				2515364
			</td>
			<td>
				(Repeat Invoice: 2504906) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:48:08
			</td>
			<td>
				0
			</td>
			<td>
				2504906
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:48:08
			</td>
		</tr>
		<tr>
			<td>
				2515365
			</td>
			<td>
				(Repeat Invoice: 2504907) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:51:13
			</td>
			<td>
				0
			</td>
			<td>
				2504907
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:51:13
			</td>
		</tr>
		<tr>
			<td>
				2515366
			</td>
			<td>
				(Repeat Invoice: 2504908) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:40
			</td>
			<td>
				0
			</td>
			<td>
				2504908
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:40
			</td>
		</tr>
		<tr>
			<td>
				2515367
			</td>
			<td>
				(Repeat Invoice: 2504909) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:51
			</td>
			<td>
				0
			</td>
			<td>
				2504909
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:51
			</td>
		</tr>
		<tr>
			<td>
				2515368
			</td>
			<td>
				(Repeat Invoice: 2504910) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:01:59
			</td>
			<td>
				0
			</td>
			<td>
				2504910
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:01:59
			</td>
		</tr>
		<tr>
			<td>
				2515369
			</td>
			<td>
				(Repeat Invoice: 2504911) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:03:34
			</td>
			<td>
				0
			</td>
			<td>
				2504911
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:03:34
			</td>
		</tr>
		<tr>
			<td>
				2515370
			</td>
			<td>
				(Repeat Invoice: 2504912) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:04:33
			</td>
			<td>
				0
			</td>
			<td>
				2504912
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:04:33
			</td>
		</tr>
		<tr>
			<td>
				2515371
			</td>
			<td>
				(Repeat Invoice: 2504913) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:06:20
			</td>
			<td>
				0
			</td>
			<td>
				2504913
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:06:20
			</td>
		</tr>
		<tr>
			<td>
				2515372
			</td>
			<td>
				(Repeat Invoice: 2504914) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:08:44
			</td>
			<td>
				0
			</td>
			<td>
				2504914
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:08:44
			</td>
		</tr>
		<tr>
			<td>
				2515373
			</td>
			<td>
				(Repeat Invoice: 2504915) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:15:31
			</td>
			<td>
				0
			</td>
			<td>
				2504915
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:15:31
			</td>
		</tr>
		<tr>
			<td>
				2515375
			</td>
			<td>
				(Repeat Invoice: 2504916) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:30:39
			</td>
			<td>
				0
			</td>
			<td>
				2504916
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:30:39
			</td>
		</tr>
		<tr>
			<td>
				2515376
			</td>
			<td>
				(Repeat Invoice: 2504917) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:31:35
			</td>
			<td>
				0
			</td>
			<td>
				2504917
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:31:35
			</td>
		</tr>
		<tr>
			<td>
				2515377
			</td>
			<td>
				(Repeat Invoice: 2504918) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:36:04
			</td>
			<td>
				0
			</td>
			<td>
				2504918
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:36:04
			</td>
		</tr>
		<tr>
			<td>
				2515389
			</td>
			<td>
				(Repeat Invoice: 2504927) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:47:30
			</td>
			<td>
				0
			</td>
			<td>
				2504927
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:47:30
			</td>
		</tr>
		<tr>
			<td>
				2515392
			</td>
			<td>
				(Repeat Invoice: 2504929) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:52:45
			</td>
			<td>
				0
			</td>
			<td>
				2504929
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:52:45
			</td>
		</tr>
		<tr>
			<td>
				2515393
			</td>
			<td>
				(Repeat Invoice: 2504930) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:58:51
			</td>
			<td>
				0
			</td>
			<td>
				2504930
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:58:51
			</td>
		</tr>
		<tr>
			<td>
				2515394
			</td>
			<td>
				(Repeat Invoice: 2504931) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 17:01:43
			</td>
			<td>
				0
			</td>
			<td>
				2504931
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 17:01:43
			</td>
		</tr>
	</tbody>
</table>


### Make Payment

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$module = $ARGV[2];
$invoice = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_make_payment($sid, $module, $invoice);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_make_payment()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_make_payment, message: { 
    sid: ARGV[0], 
    module: ARGV[1], 
    invoice: ARGV[2], 
})
print response.body[:api_make_payment_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$module = $_SERVER['argv'][3];
$invoice = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_make_payment($sid, $module, $invoice);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_make_payment**

Makes a payment for an invoice on a module.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
module|string|the module of the service being paid on
invoice|int|the invoice id you want to make a payment on

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Invalid Invoice Number Passed or missing Module information.</td>
		</tr>
	</tbody>
</table>


### Quickservers Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_quickservers_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_cancel_service**

This Function Applies to the QuickServers services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Quickservers Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_quickservers_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_get_client_invoices**

This Function Applies to the QuickServers services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Quickservers Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_quickservers_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_get_client_unpaid_invoices**

This Function Applies to the QuickServers services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### SSL Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_ssl_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_cancel_service**

This Function Applies to the SSL Certificates services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### SSL Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_ssl_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_get_client_invoices**

This Function Applies to the SSL Certificates services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### SSL Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_ssl_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_get_client_unpaid_invoices**

This Function Applies to the SSL Certificates services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### VPS Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_cancel_service**

This Function Applies to the VPS services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td>1</td>
		</tr>
	</tbody>
</table>


### VPS Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_vps_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_client_invoices**

This Function Applies to the VPS services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### VPS Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_vps_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_client_unpaid_invoices**

This Function Applies to the VPS services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Webhosting Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_webhosting_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_cancel_service**

This Function Applies to the Webhosting services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Webhosting Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_webhosting_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_get_client_invoices**

This Function Applies to the Webhosting services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Webhosting Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_webhosting_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_get_client_unpaid_invoices**

This Function Applies to the Webhosting services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps

## General




### Get Ima

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_get_ima($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_get_ima()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_get_ima, message: { 
    sid: ARGV[0], 
})
print response.body[:api_get_ima_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_get_ima($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_ima**

Returns the IMA value.  This function tells you that I'm a client, or I'm a
* admin. This is almost always going to return client, Adminsitrators will get an
* admin response.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|


### Login

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> api_login($username, $password);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
  
result = client.service.api_login()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(
  :api_login, message: { 
    username: ARGV[0], 
    password: ARGV[1], 
})
print response.body[:api_login_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->api_login($username, $password);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_login**

This function creates a session in our system which you will need to pass to
* most functions for authentication.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
username|string|the username (email address) you signed up with.
password|string|the password you use to login to the web account, or alternatively the API key.

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>String</td>
			<td>1400d4e56fe72cd483fb5d5328fb2779</td>
		</tr>
	</tbody>
</table>


### Get Hostname

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$ip = $ARGV[0];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_hostname($ip);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
  
result = client.service.get_hostname()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(
  :get_hostname, message: { 
    ip: ARGV[0], 
})
print response.body[:get_hostname_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$ip = $_SERVER['argv'][1];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_hostname($ip);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_hostname**

Resolves an IP Address and returns the hostname it points to.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
ip|string|IP Address

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>String</td>
			<td>my.interserver.net</td>
		</tr>
	</tbody>
</table>


### Get Locked Ips

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_locked_ips();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.get_locked_ips()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:get_locked_ips)
print response.body[:get_locked_ips_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_locked_ips();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_locked_ips**

This will return a list of all IP addresses used for fraud.   Its probably of no
* real use to anyone, butI use it to block IP addresses and similar things. 

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
return|array|Array of IP Addresses


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Value
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				0.0.214.110
			</td>
		</tr>
		<tr>
			<td>
				0.155.34.18
			</td>
		</tr>
		<tr>
			<td>
				1.10.217.123
			</td>
		</tr>
		<tr>
			<td>
				1.120.165.35
			</td>
		</tr>
		<tr>
			<td>
				1.187.113.69
			</td>
		</tr>
		<tr>
			<td>
				1.187.160.99
			</td>
		</tr>
		<tr>
			<td>
				1.187.161.30
			</td>
		</tr>
		<tr>
			<td>
				1.187.167.191
			</td>
		</tr>
		<tr>
			<td>
				1.187.169.215
			</td>
		</tr>
		<tr>
			<td>
				1.187.178.73
			</td>
		</tr>
		<tr>
			<td>
				1.187.184.93
			</td>
		</tr>
	</tbody>
</table>


### Get Modules

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_modules();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.get_modules()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:get_modules)
print response.body[:get_modules_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_modules();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_modules**

Returns a list of all the modules available.

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
return|array|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Value
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				domains
			</td>
		</tr>
		<tr>
			<td>
				vps
			</td>
		</tr>
		<tr>
			<td>
				backups
			</td>
		</tr>
		<tr>
			<td>
				licenses
			</td>
		</tr>
		<tr>
			<td>
				ssl
			</td>
		</tr>
		<tr>
			<td>
				webhosting
			</td>
		</tr>
		<tr>
			<td>
				quickservers
			</td>
		</tr>
	</tbody>
</table>


### StrPixels

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$string = $ARGV[0];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> strPixels($string);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
  
result = client.service.strPixels()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(
  :strPixels, message: { 
    string: ARGV[0], 
})
print response.body[:strPixels_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$string = $_SERVER['argv'][1];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->strPixels($string);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: strPixels**

This function uses the array below to calculate the pixel width of a string of
* characters. The widths of each character are based on a 12px Helvetica font. 
* Kerning is not taken into account so RESULTS ARE APPROXIMATE.  The purpose is to
* return a relative size to help in formatting. For example, strPixels('I like
* cake') == 54    strPixels('I LIKE CAKE') == 67

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
string|string|characters to measure size

#### Output Fields

Field|Type|Description
-----|----|-----------
return|int|size in pixels.


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Integer</td>
			<td>64</td>
		</tr>
	</tbody>
</table>

## Support




### GetTicketList

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$page = $ARGV[2];
$limit = $ARGV[3];
$status = $ARGV[4];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_getTicketList($sid, $page, $limit, $status);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_getTicketList()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_getTicketList, message: { 
    sid: ARGV[0], 
    page: ARGV[1], 
    limit: ARGV[2], 
    status: ARGV[3], 
})
print response.body[:api_getTicketList_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$page = $_SERVER['argv'][3];
$limit = $_SERVER['argv'][4];
$status = $_SERVER['argv'][5];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_getTicketList($sid, $page, $limit, $status);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_getTicketList**

Returns a list of any tickets in the system.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
page|int|page number of tickets to list
limit|int|how many tickets to show per page
status|string|null for no status limi t or limit to a speicifc status

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|null for no status limi t or limit to a speicifc status
status_text|string|
totalPages|string|
tickets|tns:getTicketList_tickets|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>ok</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>List of tickets</td>
		</tr>
		<tr>
			<td>totalPages</td>
			<td>0</td>
		</tr>
		<tr>
			<td>tickets</td>
			<td>Array</td>
		</tr>
	</tbody>
</table>


### OpenTicket

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$user_email = $ARGV[2];
$user_ip = $ARGV[3];
$subject = $ARGV[4];
$product = $ARGV[5];
$body = $ARGV[6];
$box_auth_value = $ARGV[7];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_openTicket($sid, $user_email, $user_ip, $subject, $product, $body, $box_auth_value);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_openTicket()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_openTicket, message: { 
    sid: ARGV[0], 
    user_email: ARGV[1], 
    user_ip: ARGV[2], 
    subject: ARGV[3], 
    product: ARGV[4], 
    body: ARGV[5], 
    box_auth_value: ARGV[6], 
})
print response.body[:api_openTicket_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$user_email = $_SERVER['argv'][3];
$user_ip = $_SERVER['argv'][4];
$subject = $_SERVER['argv'][5];
$product = $_SERVER['argv'][6];
$body = $_SERVER['argv'][7];
$box_auth_value = $_SERVER['argv'][8];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_openTicket($sid, $user_email, $user_ip, $subject, $product, $body, $box_auth_value);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_openTicket**

This command creates a new ticket in our system.  

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
user_email|string|client email address
user_ip|string|client ip address
subject|string|subject of the ticket
product|string|the product/service if any this is in reference to.  
body|string|full content/description for the ticket
box_auth_value|string|encryption string?

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|
ticket_reference_id|int|


### TicketPost

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$ticketID = $ARGV[2];
$content = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ticketPost($sid, $ticketID, $content);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ticketPost()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ticketPost, message: { 
    sid: ARGV[0], 
    ticketID: ARGV[1], 
    content: ARGV[2], 
})
print response.body[:api_ticketPost_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$ticketID = $_SERVER['argv'][3];
$content = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ticketPost($sid, $ticketID, $content);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ticketPost**

This commands adds the content parameter as a response/reply to an existing
* ticket specified by ticketID.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
ticketID|string|the id of the ticket to add a response to. you can use [getTicketList](#getticketlist) to get a list of your tickets 
content|string|the message to add to the ticket

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>Failed</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Kayako exception occurred getting ticket detail. Please try again!</td>
		</tr>
	</tbody>
</table>


### ViewTicket

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$ticketID = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_viewTicket($sid, $ticketID);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_viewTicket()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_viewTicket, message: { 
    sid: ARGV[0], 
    ticketID: ARGV[1], 
})
print response.body[:api_viewTicket_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$ticketID = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_viewTicket($sid, $ticketID);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_viewTicket**

View/Retrieve information about the given ticketID.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
ticketID|string|the id of the ticket to retrieve. you can use [getTicketList](#getticketlist) to get a list of your tickets

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|
result|tns:view_ticketdetail_array|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>Failed</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Kayako exception occurred getting ticket details. Please try again!</td>
		</tr>
		<tr>
			<td>result</td>
			<td>Array</td>
		</tr>
	</tbody>
</table>

## VPS



### Controlling the VPS

You can use the API to perform basic control functions on your VPS server.   
Current commands include the ability to Stop, Start, and Restart the server using the [vps_queue_stop](#vps-queue-stop), [vps_queue_start](#vps-queue-start), and [vps_queue_restart](#vps-queue-restart) function calls.
Some VPS types also allow you to use the [vps_screenshot](#vps-screenshot) function to get a screenshot of whats currently on the VPS's screen.

### Purchasing a VPS

The VPS order process is broken down into 2 functions.
After choosing the order parameters, you must first make a call to [validate_buy_vps](#validate-buy-vps) to check for any problems in the parameters.
The function will respond with an array containing an updated set of parameters (if any of them needed changed) and additional fields telling you if the order details were ok or a description of what problems there were in the order. 
It also will return with sevral fields telling you how much it will cost initially , how much it will cost each time you are billed after the initial signup, and how often you are billed.
When you get an 'ok' as the 'status' response you can pass the parameters to the [buy_vps](#buy-vps) function to place the order.   
This function will also return a status field with 'ok' if the order was placed properly or 'error' otherwise and a description of any problems in status_text.

### VPS Server Locations

Our more popular VPS types are available in multiple locations.   
You should probably choose the location closest to you or your clients.  
To get a list of the current locations use the [get_vps_locations_array](#get_vps_locations_array) function.  
Our primary datacenter location is in Secaucus, NJ (location id 1) and is probably the best choice if unsure what to choose.  
Some of the VPS types might only be available at that location as well.

### VPS Types and Pricing

We have several types of Servers available for use with VPS Hosting. 
You can get a list of the types available and there cost per slice/unit by making a call to the [get_vps_slice_types](#get_vps_slice_types) function.  
Additionally you can get a list of the vps platforms with the [get_vps_platforms_array](#get_vps_platforms_array) function.

### VPS Details

To get a list of all your current VPS's you can use the [vps_get_services](#vps-get-services) function and [vps_get_service](#vps-get-service) to get all the details for a given VPS.


### Buy VPS Admin

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$os = $ARGV[2];
$slices = $ARGV[3];
$platform = $ARGV[4];
$controlpanel = $ARGV[5];
$period = $ARGV[6];
$location = $ARGV[7];
$version = $ARGV[8];
$hostname = $ARGV[9];
$coupon = $ARGV[10];
$rootpass = $ARGV[11];
$server = $ARGV[12];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_api_buy_vps_admin($sid, $os, $slices, $platform, $controlpanel, $period, $location, $version, $hostname, $coupon, $rootpass, $server);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_api_buy_vps_admin()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_api_buy_vps_admin, message: { 
    sid: ARGV[0], 
    os: ARGV[1], 
    slices: ARGV[2], 
    platform: ARGV[3], 
    controlpanel: ARGV[4], 
    period: ARGV[5], 
    location: ARGV[6], 
    version: ARGV[7], 
    hostname: ARGV[8], 
    coupon: ARGV[9], 
    rootpass: ARGV[10], 
    server: ARGV[11], 
})
print response.body[:api_api_buy_vps_admin_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$os = $_SERVER['argv'][3];
$slices = $_SERVER['argv'][4];
$platform = $_SERVER['argv'][5];
$controlpanel = $_SERVER['argv'][6];
$period = $_SERVER['argv'][7];
$location = $_SERVER['argv'][8];
$version = $_SERVER['argv'][9];
$hostname = $_SERVER['argv'][10];
$coupon = $_SERVER['argv'][11];
$rootpass = $_SERVER['argv'][12];
$server = $_SERVER['argv'][13];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_api_buy_vps_admin($sid, $os, $slices, $platform, $controlpanel, $period, $location, $version, $hostname, $coupon, $rootpass, $server);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_api_buy_vps_admin**

Purchase a VPS (admins only).   Returns a comma seperated list of invoices if
* any need paid.  Same as client function but allows specifying which server to
* install to if there are resources available on the specified server.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
os|string|file field from [get_vps_templates](#get_vps_templates)
slices|int|1 to 16 specifying the scale of the VPS resources you want (a 3 slice has 3x the resources of a 1 slice vps)
platform|string|platform field from the [get_vps_platforms_array](#get_vps_platforms_array)
controlpanel|string|none, cpanel, or da for None, cPanel, or DirectAdmin control panel addons, only availbale with CentOS
period|int|1-36, How frequently to be billed in months. Some discounts as given based on the period
location|int|id field from the [get_vps_locations_array](#get_vps_locations_array)
version|int|os field from [get_vps_templates](#get_vps_templates)
hostname|string|Desired Hostname for the VPS
coupon|string|Optional Coupon to pass
rootpass|string|Desired Root Password (unused for windows, send a blank string)
server|int|0 for auto assign otherwise the id of the vps master to put this on

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|
invoices|string|Array
cost|float|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Password must contain atleast 8 characters, one lowercase letter, one uppercase letter, one number, a special character and autogenerated password filled in it.</td>
		</tr>
		<tr>
			<td>invoices</td>
			<td></td>
		</tr>
		<tr>
			<td>cost</td>
			<td>6</td>
		</tr>
	</tbody>
</table>


### Buy VPS

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$os = $ARGV[2];
$slices = $ARGV[3];
$platform = $ARGV[4];
$controlpanel = $ARGV[5];
$period = $ARGV[6];
$location = $ARGV[7];
$version = $ARGV[8];
$hostname = $ARGV[9];
$coupon = $ARGV[10];
$rootpass = $ARGV[11];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_api_buy_vps($sid, $os, $slices, $platform, $controlpanel, $period, $location, $version, $hostname, $coupon, $rootpass);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_api_buy_vps()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_api_buy_vps, message: { 
    sid: ARGV[0], 
    os: ARGV[1], 
    slices: ARGV[2], 
    platform: ARGV[3], 
    controlpanel: ARGV[4], 
    period: ARGV[5], 
    location: ARGV[6], 
    version: ARGV[7], 
    hostname: ARGV[8], 
    coupon: ARGV[9], 
    rootpass: ARGV[10], 
})
print response.body[:api_api_buy_vps_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$os = $_SERVER['argv'][3];
$slices = $_SERVER['argv'][4];
$platform = $_SERVER['argv'][5];
$controlpanel = $_SERVER['argv'][6];
$period = $_SERVER['argv'][7];
$location = $_SERVER['argv'][8];
$version = $_SERVER['argv'][9];
$hostname = $_SERVER['argv'][10];
$coupon = $_SERVER['argv'][11];
$rootpass = $_SERVER['argv'][12];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_api_buy_vps($sid, $os, $slices, $platform, $controlpanel, $period, $location, $version, $hostname, $coupon, $rootpass);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_api_buy_vps**

Places a VPS order in our system. These are the same parameters as
* api_validate_buy_vps..   Returns a comma seperated list of invoices if any need
* paid.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
os|string|file field from [get_vps_templates](#get_vps_templates)
slices|int|1 to 16 specifying the scale of the VPS resources you want (a 3 slice has 3x the resources of a 1 slice vps)
platform|string|platform field from the [get_vps_platforms_array](#get_vps_platforms_array)
controlpanel|string|none, cpanel, or da for None, cPanel, or DirectAdmin control panel addons, only availbale with CentOS
period|int|1-36, How frequently to be billed in months. Some discounts as given based on the period
location|int|id field from the [get_vps_locations_array](#get_vps_locations_array)
version|string|os field from [get_vps_templates](#get_vps_templates)
hostname|string|Desired Hostname for the VPS
coupon|string|Optional Coupon to pass
rootpass|string|Desired Root Password (unused for windows, send a blank string)

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|
invoices|string|Array
cost|float|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Password must contain atleast 8 characters, one lowercase letter, one uppercase letter, one number, a special character and autogenerated password filled in it.</td>
		</tr>
		<tr>
			<td>invoices</td>
			<td></td>
		</tr>
		<tr>
			<td>cost</td>
			<td>6</td>
		</tr>
	</tbody>
</table>


### Validate Buy VPS

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$os = $ARGV[2];
$slices = $ARGV[3];
$platform = $ARGV[4];
$controlpanel = $ARGV[5];
$period = $ARGV[6];
$location = $ARGV[7];
$version = $ARGV[8];
$hostname = $ARGV[9];
$coupon = $ARGV[10];
$rootpass = $ARGV[11];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_api_validate_buy_vps($sid, $os, $slices, $platform, $controlpanel, $period, $location, $version, $hostname, $coupon, $rootpass);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_api_validate_buy_vps()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_api_validate_buy_vps, message: { 
    sid: ARGV[0], 
    os: ARGV[1], 
    slices: ARGV[2], 
    platform: ARGV[3], 
    controlpanel: ARGV[4], 
    period: ARGV[5], 
    location: ARGV[6], 
    version: ARGV[7], 
    hostname: ARGV[8], 
    coupon: ARGV[9], 
    rootpass: ARGV[10], 
})
print response.body[:api_api_validate_buy_vps_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$os = $_SERVER['argv'][3];
$slices = $_SERVER['argv'][4];
$platform = $_SERVER['argv'][5];
$controlpanel = $_SERVER['argv'][6];
$period = $_SERVER['argv'][7];
$location = $_SERVER['argv'][8];
$version = $_SERVER['argv'][9];
$hostname = $_SERVER['argv'][10];
$coupon = $_SERVER['argv'][11];
$rootpass = $_SERVER['argv'][12];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_api_validate_buy_vps($sid, $os, $slices, $platform, $controlpanel, $period, $location, $version, $hostname, $coupon, $rootpass);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_api_validate_buy_vps**

Checks if the parameters for your order pass validation and let you know if
* there are any errors. It will also give you information on the pricing
* breakdown.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
os|string|file field from [get_vps_templates](#get_vps_templates)
slices|int|1 to 16 specifying the scale of the VPS resources you want (a 3 slice has 3x the resources of a 1 slice vps)
platform|string|platform field from the [get_vps_platforms_array](#get_vps_platforms_array)
controlpanel|string|none, cpanel, or da for None, cPanel, or DirectAdmin control panel addons, only availbale with CentOS
period|int|1-36, How frequently to be billed in months. Some discounts as given based on the period
location|int|id field from the [get_vps_locations_array](#get_vps_locations_array)
version|string|os field from [get_vps_templates](#get_vps_templates)
hostname|string|Desired Hostname for the VPS
coupon|string|Optional Coupon to pass
rootpass|string|Desired Root Password (unused for windows, send a blank string)

#### Output Fields

Field|Type|Description
-----|----|-----------
coupon_code|int|
service_cost|float|
slice_cost|float|
service_type|int|
repeat_slice_cost|float|
original_slice_cost|float|
original_cost|float|
repeat_service_cost|float|
monthly_service_cost|float|
custid|int|
os|string|file field from [get_vps_templates](#get_vps_templates)
slices|int|1 to 16 specifying the scale of the VPS resources you want (a 3 slice has 3x the resources of a 1 slice vps)
platform|string|platform field from the [get_vps_platforms_array](#get_vps_platforms_array)
controlpanel|string|none, cpanel, or da for None, cPanel, or DirectAdmin control panel addons, only availbale with CentOS
period|int|1-36, How frequently to be billed in months. Some discounts as given based on the period
location|int|id field from the [get_vps_locations_array](#get_vps_locations_array)
version|string|os field from [get_vps_templates](#get_vps_templates)
hostname|string|Desired Hostname for the VPS
coupon|string|Optional Coupon to pass
rootpass|string|Desired Root Password (unused for windows, send a blank string)
status_text|string|
status|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>coupon_code</td>
			<td>0</td>
		</tr>
		<tr>
			<td>service_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>slice_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>service_type</td>
			<td>31</td>
		</tr>
		<tr>
			<td>repeat_slice_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>original_slice_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>original_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>repeat_service_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>monthly_service_cost</td>
			<td>6</td>
		</tr>
		<tr>
			<td>custid</td>
			<td>160884</td>
		</tr>
		<tr>
			<td>os</td>
			<td>ubuntu-15.04-x86_64.tar.gz</td>
		</tr>
		<tr>
			<td>slices</td>
			<td>1</td>
		</tr>
		<tr>
			<td>platform</td>
			<td>openvz</td>
		</tr>
		<tr>
			<td>controlpanel</td>
			<td>none</td>
		</tr>
		<tr>
			<td>period</td>
			<td>1</td>
		</tr>
		<tr>
			<td>location</td>
			<td>1</td>
		</tr>
		<tr>
			<td>version</td>
			<td>ubuntu</td>
		</tr>
		<tr>
			<td>hostname</td>
			<td>myserver.mydomain.com</td>
		</tr>
		<tr>
			<td>coupon</td>
			<td></td>
		</tr>
		<tr>
			<td>rootpass</td>
			<td>sampleP4ssw0rd</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Password must contain atleast 8 characters, one lowercase letter, one uppercase letter, one number, a special character and autogenerated password filled in it.</td>
		</tr>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
	</tbody>
</table>


### VPS Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_cancel_service**

This Function Applies to the VPS services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td>1</td>
		</tr>
	</tbody>
</table>


### VPS Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_vps_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_client_invoices**

This Function Applies to the VPS services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### VPS Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_vps_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_client_unpaid_invoices**

This Function Applies to the VPS services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### VPS Get Server Name

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_server_name($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_server_name()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_server_name, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_get_server_name_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_server_name($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_server_name**

Get the name of the vps master/host server your giving the id for

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|id of the vps master

#### Output Fields

Field|Type|Description
-----|----|-----------
return|string|vps masters name


### VPS Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_service**

This Function Applies to the VPS services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
vps_id|int|Service ID
vps_server|int|
vps_vzid|string|
vps_type|int|Package ID
vps_cost|float|Service Cost
vps_custid|int|Customer ID
vps_ip|string|IP Address
vps_status|string|Billing Status
vps_invoice|int|Invoice ID
vps_coupon|int|Coupon ID
vps_extra|string|
vps_hostname|string|
vps_server_status|string|
vps_comment|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>vps_id</td>
			<td>10000</td>
		</tr>
		<tr>
			<td>vps_server</td>
			<td>53</td>
		</tr>
		<tr>
			<td>vps_vzid</td>
			<td>10000</td>
		</tr>
		<tr>
			<td>vps_type</td>
			<td>32</td>
		</tr>
		<tr>
			<td>vps_cost</td>
			<td>22</td>
		</tr>
		<tr>
			<td>vps_custid</td>
			<td>11803</td>
		</tr>
		<tr>
			<td>vps_ip</td>
			<td>206.72.197.216</td>
		</tr>
		<tr>
			<td>vps_status</td>
			<td>canceled</td>
		</tr>
		<tr>
			<td>vps_invoice</td>
			<td>1011318</td>
		</tr>
		<tr>
			<td>vps_coupon</td>
			<td>3507</td>
		</tr>
		<tr>
			<td>vps_extra</td>
			<td>a:10:{s:8:"rootpass";s:0:"";s:2:"os";s:1:"5";s:6:"slices";i:2;s:8:"platform";s:3:"kvm";s:8:"location";i:1;s:7:"version";i:1;s:4:"name";s:12:"windows10000";s:8:"kmemsize";s:6:"752000";s:3:"mac";s:17:"52:54:00:60:52:f8";s:3:"vnc";s:2:"-1";}</td>
		</tr>
		<tr>
			<td>vps_hostname</td>
			<td>windows10000</td>
		</tr>
		<tr>
			<td>vps_server_status</td>
			<td>deleted</td>
		</tr>
		<tr>
			<td>vps_comment</td>
			<td></td>
		</tr>
	</tbody>
</table>


### VPS Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_vps_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_get_services**

This Function Applies to the VPS services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
vps_id|int|Service ID
vps_server|int|
vps_vzid|string|
vps_type|int|Package ID
vps_cost|float|Service Cost
vps_custid|int|Customer ID
vps_ip|string|IP Address
vps_status|string|Billing Status
vps_invoice|int|Invoice ID
vps_coupon|int|Coupon ID
vps_extra|string|
vps_hostname|string|
vps_server_status|string|
vps_comment|string|


### VPS Queue Restart

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_queue_restart($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_queue_restart()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_queue_restart, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_queue_restart_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_queue_restart($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_queue_restart**

restart a vps

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|defaults to false, if specifeid tries usign that di instead of the one passed

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>That VPS Does Not Belong To Your</td>
		</tr>
	</tbody>
</table>


### VPS Queue Start

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_queue_start($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_queue_start()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_queue_start, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_queue_start_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_queue_start($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_queue_start**

start a vps

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|defaults to false, if specifeid tries usign that di instead of the one passed

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>That VPS Does Not Belong To Your</td>
		</tr>
	</tbody>
</table>


### VPS Queue Stop

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_queue_stop($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_queue_stop()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_queue_stop, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_queue_stop_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_queue_stop($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_queue_stop**

stops a vps

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|defaults to false, if specifeid tries usign that di instead of the one passed

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>That VPS Does Not Belong To You</td>
		</tr>
	</tbody>
</table>


### VPS Screenshot

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_vps_screenshot($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_vps_screenshot()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_vps_screenshot, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_vps_screenshot_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_vps_screenshot($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_vps_screenshot**

This command returns a link to an animated screenshot of your VPS.   Only works
* currently with KVM VPS servers

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|false to link to the image itself , otherwise a url

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|
url|string|
link|string|
js|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Your VPS has no screenshots currently.</td>
		</tr>
		<tr>
			<td>url</td>
			<td></td>
		</tr>
		<tr>
			<td>link</td>
			<td></td>
		</tr>
		<tr>
			<td>js</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Get VPS Locations Array

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_vps_locations_array();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.get_vps_locations_array()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:get_vps_locations_array)
print response.body[:get_vps_locations_array_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_vps_locations_array();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_vps_locations_array**

Use this function to get a list of the Locations available for ordering. The id
* field in the return value is also needed to pass to the buy_vps functions.

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
id|int|Internal ID
name|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Id
			</th>
			<th>
				Name
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				1
			</td>
			<td>
				Secaucus, NJ
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				Los Angeles, CA
			</td>
		</tr>
	</tbody>
</table>


### Get VPS Platforms Array

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_vps_platforms_array();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.get_vps_platforms_array()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:get_vps_platforms_array)
print response.body[:get_vps_platforms_array_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_vps_platforms_array();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_vps_platforms_array**

Use this function to get a list of the various platforms available for ordering.
* The platform field in the return value is also needed to pass to the buy_vps
* functions.

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
platform|string|
name|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Platform
			</th>
			<th>
				Name
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				openvz
			</td>
			<td>
				OpenVZ
			</td>
		</tr>
		<tr>
			<td>
				kvm
			</td>
			<td>
				KVM
			</td>
		</tr>
		<tr>
			<td>
				cloudkvm
			</td>
			<td>
				Cloud
			</td>
		</tr>
	</tbody>
</table>


### Get VPS Slice Types

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_vps_slice_types();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.get_vps_slice_types()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:get_vps_slice_types)
print response.body[:get_vps_slice_types_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_vps_slice_types();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_vps_slice_types**

We have several types of Servers available for use with VPS Hosting. You can get
* a list of the types available and  there cost per slice/unit by making a call to
* this function

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
name|string|
type|int|
cost|float|
buyable|int|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Name
			</th>
			<th>
				Type
			</th>
			<th>
				Cost
			</th>
			<th>
				Buyable
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				OpenVZ VPS Slice
			</td>
			<td>
				6
			</td>
			<td>
				6
			</td>
			<td>
				1
			</td>
		</tr>
		<tr>
			<td>
				KVM Windows VPS Slice
			</td>
			<td>
				1
			</td>
			<td>
				10
			</td>
			<td>
				1
			</td>
		</tr>
		<tr>
			<td>
				KVM Linux VPS Slice
			</td>
			<td>
				2
			</td>
			<td>
				8
			</td>
			<td>
				1
			</td>
		</tr>
		<tr>
			<td>
				Cloud KVM Windows VPS Slice
			</td>
			<td>
				3
			</td>
			<td>
				22
			</td>
			<td>
				1
			</td>
		</tr>
		<tr>
			<td>
				Cloud KVM Linux VPS Slice
			</td>
			<td>
				4
			</td>
			<td>
				20
			</td>
			<td>
				1
			</td>
		</tr>
		<tr>
			<td>
				SSD OpenVZ VPS Slice
			</td>
			<td>
				5
			</td>
			<td>
				9
			</td>
			<td>
				1
			</td>
		</tr>
		<tr>
			<td>
				LXC VPS Slice
			</td>
			<td>
				9
			</td>
			<td>
				6
			</td>
			<td>
				0
			</td>
		</tr>
		<tr>
			<td>
				Xen Windows VPS Slice
			</td>
			<td>
				7
			</td>
			<td>
				6
			</td>
			<td>
				0
			</td>
		</tr>
		<tr>
			<td>
				Xen Linux VPS Slice
			</td>
			<td>
				8
			</td>
			<td>
				6
			</td>
			<td>
				0
			</td>
		</tr>
		<tr>
			<td>
				VMware VPS Slice
			</td>
			<td>
				10
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
		</tr>
		<tr>
			<td>
				Hyper-V VPS Slice
			</td>
			<td>
				11
			</td>
			<td>
				10
			</td>
			<td>
				0
			</td>
		</tr>
	</tbody>
</table>


### Get VPS Templates

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> get_vps_templates();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.get_vps_templates()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:get_vps_templates)
print response.body[:get_vps_templates_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->get_vps_templates();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: get_vps_templates**

Get the currently available VPS templates for each server type.

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
type|int|
virtulization|string|
bits|int|
os|string|
version|string|
file|string|
title|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Type
			</th>
			<th>
				Virtulization
			</th>
			<th>
				Bits
			</th>
			<th>
				Os
			</th>
			<th>
				Version
			</th>
			<th>
				File
			</th>
			<th>
				Title
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				1
			</td>
			<td>
				KVM Windows
			</td>
			<td>
				64
			</td>
			<td>
				windows
			</td>
			<td>
				2012
			</td>
			<td>
				windows2012
			</td>
			<td>
				Windows 2012 64bit 
			</td>
		</tr>
		<tr>
			<td>
				1
			</td>
			<td>
				KVM Windows
			</td>
			<td>
				64
			</td>
			<td>
				windows
			</td>
			<td>
				2008 r2
			</td>
			<td>
				windowsr2
			</td>
			<td>
				Windows 2008 r2 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7
			</td>
			<td>
				centos55
			</td>
			<td>
				CentOS 7 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6
			</td>
			<td>
				centos5
			</td>
			<td>
				CentOS 6 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				7
			</td>
			<td>
				debian6
			</td>
			<td>
				Debian 7 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				freepbx
			</td>
			<td>
				6.6
			</td>
			<td>
				freepbx
			</td>
			<td>
				FreePBX 6.6 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu10
			</td>
			<td>
				Ubuntu 14.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04 Desktop
			</td>
			<td>
				ubuntudesktop
			</td>
			<td>
				Ubuntu 14.04 Desktop 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04
			</td>
			<td>
				ubuntu12
			</td>
			<td>
				Ubuntu 12.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				2
			</td>
			<td>
				KVM Linux
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				10.04
			</td>
			<td>
				ubuntu10
			</td>
			<td>
				Ubuntu 10.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7 minimal
			</td>
			<td>
				centos-7-x86_64-minimal.tar.gz
			</td>
			<td>
				CentOS 7 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7
			</td>
			<td>
				centos-7-x86_64.tar.gz
			</td>
			<td>
				CentOS 7 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6 minimal
			</td>
			<td>
				centos-6-x86_64-minimal.tar.gz
			</td>
			<td>
				CentOS 6 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6 devel
			</td>
			<td>
				centos-6-x86_64-devel.tar.gz
			</td>
			<td>
				CentOS 6 devel 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6
			</td>
			<td>
				centos-6-x86_64.tar.gz
			</td>
			<td>
				CentOS 6 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				6 minimal
			</td>
			<td>
				centos-6-x86-minimal.tar.gz
			</td>
			<td>
				CentOS 6 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				6 devel
			</td>
			<td>
				centos-6-x86-devel.tar.gz
			</td>
			<td>
				CentOS 6 devel 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				6
			</td>
			<td>
				centos-6-x86.tar.gz
			</td>
			<td>
				CentOS 6 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				5 devel
			</td>
			<td>
				centos-5-x86_64-devel.tar.gz
			</td>
			<td>
				CentOS 5 devel 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				5
			</td>
			<td>
				centos-5-x86_64.tar.gz
			</td>
			<td>
				CentOS 5 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				5 devel
			</td>
			<td>
				centos-5-x86-devel.tar.gz
			</td>
			<td>
				CentOS 5 devel 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				5
			</td>
			<td>
				centos-5-x86.tar.gz
			</td>
			<td>
				CentOS 5 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7 nginxwordpress
			</td>
			<td>
				centos-7-x86_64-nginxwordpress.tar.gz
			</td>
			<td>
				CentOS 7 nginxwordpress 64bit (http:mirror.trouble-free.netmyadminopenvz)
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				8.0 minimal
			</td>
			<td>
				debian-8.0-x86_64-minimal.tar.gz
			</td>
			<td>
				Debian 8.0 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				8.0
			</td>
			<td>
				debian-8.0-x86_64.tar.gz
			</td>
			<td>
				Debian 8.0 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				7.0 minimal
			</td>
			<td>
				debian-7.0-x86_64-minimal.tar.gz
			</td>
			<td>
				Debian 7.0 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				7.0
			</td>
			<td>
				debian-7.0-x86.tar.gz
			</td>
			<td>
				Debian 7.0 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				7.0 minimal
			</td>
			<td>
				debian-7.0-x86-minimal.tar.gz
			</td>
			<td>
				Debian 7.0 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				6.0 minimal
			</td>
			<td>
				debian-6.0-x86_64-minimal.tar.gz
			</td>
			<td>
				Debian 6.0 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				6.0
			</td>
			<td>
				debian-6.0-x86_64.tar.gz
			</td>
			<td>
				Debian 6.0 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				6.0 minimal
			</td>
			<td>
				debian-6.0-x86-minimal.tar.gz
			</td>
			<td>
				Debian 6.0 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				6.0
			</td>
			<td>
				debian-6.0-x86.tar.gz
			</td>
			<td>
				Debian 6.0 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				7.0
			</td>
			<td>
				debian-7.0-x86_64.tar.gz
			</td>
			<td>
				Debian 7.0 64bit (contrib)
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				fedora
			</td>
			<td>
				21
			</td>
			<td>
				fedora-21-x86_64.tar.gz
			</td>
			<td>
				Fedora 21 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				fedora
			</td>
			<td>
				20
			</td>
			<td>
				fedora-20-x86_64.tar.gz
			</td>
			<td>
				Fedora 20 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				fedora
			</td>
			<td>
				20
			</td>
			<td>
				fedora-20-x86.tar.gz
			</td>
			<td>
				Fedora 20 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				fedora
			</td>
			<td>
				22
			</td>
			<td>
				fedora-22-x86_64.tar.gz
			</td>
			<td>
				Fedora 22 64bit (beta)
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				scientific
			</td>
			<td>
				6
			</td>
			<td>
				scientific-6-x86_64.tar.gz
			</td>
			<td>
				Scientific 6 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				scientific
			</td>
			<td>
				6
			</td>
			<td>
				scientific-6-x86.tar.gz
			</td>
			<td>
				Scientific 6 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				suse
			</td>
			<td>
				13.2
			</td>
			<td>
				suse-13.2-x86_64.tar.gz
			</td>
			<td>
				SuSe 13.2 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				suse
			</td>
			<td>
				13.1
			</td>
			<td>
				suse-13.1-x86_64.tar.gz
			</td>
			<td>
				SuSe 13.1 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				suse
			</td>
			<td>
				13.1 minimal
			</td>
			<td>
				suse-13.1-x86_64-minimal.tar.gz
			</td>
			<td>
				SuSe 13.1 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				suse
			</td>
			<td>
				13.1 minimal
			</td>
			<td>
				suse-13.1-x86-minimal.tar.gz
			</td>
			<td>
				SuSe 13.1 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				suse
			</td>
			<td>
				13.1
			</td>
			<td>
				suse-13.1-x86.tar.gz
			</td>
			<td>
				SuSe 13.1 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				15.04 minimal
			</td>
			<td>
				ubuntu-15.04-x86_64-minimal.tar.gz
			</td>
			<td>
				Ubuntu 15.04 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				15.04
			</td>
			<td>
				ubuntu-15.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 15.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu-14.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 14.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04 minimal
			</td>
			<td>
				ubuntu-14.04-x86_64-minimal.tar.gz
			</td>
			<td>
				Ubuntu 14.04 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu-14.04-x86.tar.gz
			</td>
			<td>
				Ubuntu 14.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04 minimal
			</td>
			<td>
				ubuntu-14.04-x86-minimal.tar.gz
			</td>
			<td>
				Ubuntu 14.04 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04 minimal
			</td>
			<td>
				ubuntu-12.04-x86_64-minimal.tar.gz
			</td>
			<td>
				Ubuntu 12.04 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04
			</td>
			<td>
				ubuntu-12.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 12.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04 minimal
			</td>
			<td>
				ubuntu-12.04-x86-minimal.tar.gz
			</td>
			<td>
				Ubuntu 12.04 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04
			</td>
			<td>
				ubuntu-12.04-x86.tar.gz
			</td>
			<td>
				Ubuntu 12.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				10.04
			</td>
			<td>
				ubuntu-10.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 10.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				5
			</td>
			<td>
				SSD OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				10.04
			</td>
			<td>
				ubuntu-10.04-x86.tar.gz
			</td>
			<td>
				Ubuntu 10.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7 minimal
			</td>
			<td>
				centos-7-x86_64-minimal.tar.gz
			</td>
			<td>
				CentOS 7 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7
			</td>
			<td>
				centos-7-x86_64.tar.gz
			</td>
			<td>
				CentOS 7 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6 minimal
			</td>
			<td>
				centos-6-x86_64-minimal.tar.gz
			</td>
			<td>
				CentOS 6 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6 devel
			</td>
			<td>
				centos-6-x86_64-devel.tar.gz
			</td>
			<td>
				CentOS 6 devel 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				6
			</td>
			<td>
				centos-6-x86_64.tar.gz
			</td>
			<td>
				CentOS 6 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				6 minimal
			</td>
			<td>
				centos-6-x86-minimal.tar.gz
			</td>
			<td>
				CentOS 6 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				6 devel
			</td>
			<td>
				centos-6-x86-devel.tar.gz
			</td>
			<td>
				CentOS 6 devel 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				6
			</td>
			<td>
				centos-6-x86.tar.gz
			</td>
			<td>
				CentOS 6 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				5 devel
			</td>
			<td>
				centos-5-x86_64-devel.tar.gz
			</td>
			<td>
				CentOS 5 devel 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				5
			</td>
			<td>
				centos-5-x86_64.tar.gz
			</td>
			<td>
				CentOS 5 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				5 devel
			</td>
			<td>
				centos-5-x86-devel.tar.gz
			</td>
			<td>
				CentOS 5 devel 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				centos
			</td>
			<td>
				5
			</td>
			<td>
				centos-5-x86.tar.gz
			</td>
			<td>
				CentOS 5 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				centos
			</td>
			<td>
				7 nginxwordpress
			</td>
			<td>
				centos-7-x86_64-nginxwordpress.tar.gz
			</td>
			<td>
				CentOS 7 nginxwordpress 64bit (http:mirror.trouble-free.netmyadminopenvz)
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				8.0 minimal
			</td>
			<td>
				debian-8.0-x86_64-minimal.tar.gz
			</td>
			<td>
				Debian 8.0 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				8.0
			</td>
			<td>
				debian-8.0-x86_64.tar.gz
			</td>
			<td>
				Debian 8.0 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				7.0 minimal
			</td>
			<td>
				debian-7.0-x86_64-minimal.tar.gz
			</td>
			<td>
				Debian 7.0 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				7.0
			</td>
			<td>
				debian-7.0-x86.tar.gz
			</td>
			<td>
				Debian 7.0 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				7.0 minimal
			</td>
			<td>
				debian-7.0-x86-minimal.tar.gz
			</td>
			<td>
				Debian 7.0 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				6.0 minimal
			</td>
			<td>
				debian-6.0-x86_64-minimal.tar.gz
			</td>
			<td>
				Debian 6.0 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				6.0
			</td>
			<td>
				debian-6.0-x86_64.tar.gz
			</td>
			<td>
				Debian 6.0 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				6.0 minimal
			</td>
			<td>
				debian-6.0-x86-minimal.tar.gz
			</td>
			<td>
				Debian 6.0 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				debian
			</td>
			<td>
				6.0
			</td>
			<td>
				debian-6.0-x86.tar.gz
			</td>
			<td>
				Debian 6.0 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				debian
			</td>
			<td>
				7.0
			</td>
			<td>
				debian-7.0-x86_64.tar.gz
			</td>
			<td>
				Debian 7.0 64bit (contrib)
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				fedora
			</td>
			<td>
				21
			</td>
			<td>
				fedora-21-x86_64.tar.gz
			</td>
			<td>
				Fedora 21 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				fedora
			</td>
			<td>
				20
			</td>
			<td>
				fedora-20-x86_64.tar.gz
			</td>
			<td>
				Fedora 20 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				fedora
			</td>
			<td>
				20
			</td>
			<td>
				fedora-20-x86.tar.gz
			</td>
			<td>
				Fedora 20 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				fedora
			</td>
			<td>
				22
			</td>
			<td>
				fedora-22-x86_64.tar.gz
			</td>
			<td>
				Fedora 22 64bit (beta)
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				scientific
			</td>
			<td>
				6
			</td>
			<td>
				scientific-6-x86_64.tar.gz
			</td>
			<td>
				Scientific 6 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				scientific
			</td>
			<td>
				6
			</td>
			<td>
				scientific-6-x86.tar.gz
			</td>
			<td>
				Scientific 6 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				suse
			</td>
			<td>
				13.2
			</td>
			<td>
				suse-13.2-x86_64.tar.gz
			</td>
			<td>
				SuSe 13.2 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				suse
			</td>
			<td>
				13.1 minimal
			</td>
			<td>
				suse-13.1-x86_64-minimal.tar.gz
			</td>
			<td>
				SuSe 13.1 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				suse
			</td>
			<td>
				13.1
			</td>
			<td>
				suse-13.1-x86_64.tar.gz
			</td>
			<td>
				SuSe 13.1 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				suse
			</td>
			<td>
				13.1 minimal
			</td>
			<td>
				suse-13.1-x86-minimal.tar.gz
			</td>
			<td>
				SuSe 13.1 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				suse
			</td>
			<td>
				13.1
			</td>
			<td>
				suse-13.1-x86.tar.gz
			</td>
			<td>
				SuSe 13.1 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				15.04 minimal
			</td>
			<td>
				ubuntu-15.04-x86_64-minimal.tar.gz
			</td>
			<td>
				Ubuntu 15.04 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				15.04
			</td>
			<td>
				ubuntu-15.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 15.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu-14.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 14.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04 minimal
			</td>
			<td>
				ubuntu-14.04-x86_64-minimal.tar.gz
			</td>
			<td>
				Ubuntu 14.04 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu-14.04-x86.tar.gz
			</td>
			<td>
				Ubuntu 14.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04 minimal
			</td>
			<td>
				ubuntu-14.04-x86-minimal.tar.gz
			</td>
			<td>
				Ubuntu 14.04 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04 minimal
			</td>
			<td>
				ubuntu-12.04-x86_64-minimal.tar.gz
			</td>
			<td>
				Ubuntu 12.04 minimal 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04
			</td>
			<td>
				ubuntu-12.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 12.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04 minimal
			</td>
			<td>
				ubuntu-12.04-x86-minimal.tar.gz
			</td>
			<td>
				Ubuntu 12.04 minimal 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				12.04
			</td>
			<td>
				ubuntu-12.04-x86.tar.gz
			</td>
			<td>
				Ubuntu 12.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				10.04
			</td>
			<td>
				ubuntu-10.04-x86_64.tar.gz
			</td>
			<td>
				Ubuntu 10.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				6
			</td>
			<td>
				OpenVZ
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				10.04
			</td>
			<td>
				ubuntu-10.04-x86.tar.gz
			</td>
			<td>
				Ubuntu 10.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				9
			</td>
			<td>
				LXC
			</td>
			<td>
				64
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu-trusty-amd64
			</td>
			<td>
				Ubuntu 14.04 64bit 
			</td>
		</tr>
		<tr>
			<td>
				9
			</td>
			<td>
				LXC
			</td>
			<td>
				32
			</td>
			<td>
				ubuntu
			</td>
			<td>
				14.04
			</td>
			<td>
				ubuntu-trusty-i3864
			</td>
			<td>
				Ubuntu 14.04 32bit 
			</td>
		</tr>
		<tr>
			<td>
				10
			</td>
			<td>
				VMware
			</td>
			<td>
				64
			</td>
			<td>
				windows
			</td>
			<td>
				2008
			</td>
			<td>
				windows2008
			</td>
			<td>
				Windows 2008 64bit 
			</td>
		</tr>
		<tr>
			<td>
				11
			</td>
			<td>
				Hyper-V
			</td>
			<td>
				64
			</td>
			<td>
				windows
			</td>
			<td>
				2012 Standard
			</td>
			<td>
				Windows2012Standard
			</td>
			<td>
				Windows 2012 Standard 64bit 
			</td>
		</tr>
	</tbody>
</table>

## Webhosting




### Webhosting Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_webhosting_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_cancel_service**

This Function Applies to the Webhosting services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Webhosting Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_webhosting_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_get_client_invoices**

This Function Applies to the Webhosting services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Webhosting Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_webhosting_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_get_client_unpaid_invoices**

This Function Applies to the Webhosting services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Webhosting Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_webhosting_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_get_service**

This Function Applies to the Webhosting services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
website_id|int|Server ID
website_server|int|
website_type|int|Server Type
website_cost|float|Service Cost
website_custid|int|Customer ID
website_ip|string|IP Address
website_status|string|Billing Status
website_invoice|int|Invoice ID
website_coupon|int|Coupon ID
website_extra|string|
website_hostname|string|
website_comment|string|
website_username|string|
website_server_status|string|


### Webhosting Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_webhosting_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_webhosting_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_webhosting_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_webhosting_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_webhosting_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_webhosting_get_services**

This Function Applies to the Webhosting services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
website_id|int|Server ID
website_server|int|
website_type|int|Server Type
website_cost|float|Service Cost
website_custid|int|Customer ID
website_ip|string|IP Address
website_status|string|Billing Status
website_invoice|int|Invoice ID
website_coupon|int|Coupon ID
website_extra|string|
website_hostname|string|
website_comment|string|
website_username|string|
website_server_status|string|

## Licenses




### Buy License

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$ip = $ARGV[2];
$type = $ARGV[3];
$coupon = $ARGV[4];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_buy_license($sid, $ip, $type, $coupon);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_buy_license()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_buy_license, message: { 
    sid: ARGV[0], 
    ip: ARGV[1], 
    type: ARGV[2], 
    coupon: ARGV[3], 
})
print response.body[:api_buy_license_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$ip = $_SERVER['argv'][3];
$type = $_SERVER['argv'][4];
$coupon = $_SERVER['argv'][5];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_buy_license($sid, $ip, $type, $coupon);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_buy_license**

Purchase a License.  Returns an invoice ID.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
ip|string|ip address you wish to license some software on
type|int|the package id of the license type you want. use [get_license_types](#get-license-types) to get a list of possible types.
coupon|string|an optional coupon

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|
invoice|int|
cost|float|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>ok</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Order Completed Successfully.</td>
		</tr>
		<tr>
			<td>invoice</td>
			<td>2515394</td>
		</tr>
		<tr>
			<td>cost</td>
			<td>34.95</td>
		</tr>
	</tbody>
</table>


### Cancel License Ip

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$ip = $ARGV[2];
$type = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_cancel_license_ip($sid, $ip, $type);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_cancel_license_ip()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_cancel_license_ip, message: { 
    sid: ARGV[0], 
    ip: ARGV[1], 
    type: ARGV[2], 
})
print response.body[:api_cancel_license_ip_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$ip = $_SERVER['argv'][3];
$type = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_cancel_license_ip($sid, $ip, $type);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_cancel_license_ip**

Cancel a License by IP and Type.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
ip|string|IP Address to cancel
type|int|Package ID. use [get_license_types](#get-license-types) to get a list of possible types.

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Invalid License IP/Type</td>
		</tr>
	</tbody>
</table>


### Cancel License

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_cancel_license($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_cancel_license()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_cancel_license, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_cancel_license_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_cancel_license($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_cancel_license**

Cancel a License.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|License Order ID

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Invalid License ID</td>
		</tr>
	</tbody>
</table>


### Change License Ip By Id

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$newip = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_change_license_ip_by_id($sid, $id, $newip);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_change_license_ip_by_id()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_change_license_ip_by_id, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
    newip: ARGV[2], 
})
print response.body[:api_change_license_ip_by_id_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$newip = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_change_license_ip_by_id($sid, $id, $newip);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_change_license_ip_by_id**

Change the IP on an active license.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the license order id of the license to change the ip for
newip|string|the new ip address to associate with the license

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>No license found
</td>
		</tr>
	</tbody>
</table>


### Change License Ip

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$oldip = $ARGV[2];
$newip = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_change_license_ip($sid, $oldip, $newip);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_change_license_ip()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_change_license_ip, message: { 
    sid: ARGV[0], 
    oldip: ARGV[1], 
    newip: ARGV[2], 
})
print response.body[:api_change_license_ip_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$oldip = $_SERVER['argv'][3];
$newip = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_change_license_ip($sid, $oldip, $newip);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_change_license_ip**

Change the IP on an active license.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
oldip|string|the old ip address
newip|string|the new ip address

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>Multiple Licenses On This IP.  Use the website or contact support@interserver.net.
</td>
		</tr>
	</tbody>
</table>


### Get License Types

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$res = $client
  -> api_get_license_types();
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
result = client.service.api_get_license_types()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')
response = client.call(:api_get_license_types)
print response.body[:api_get_license_types_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $res = $client->api_get_license_types();
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_license_types**

Get a license of the various license types.

#### Input

This function takes no input parameters

#### Output Fields

Field|Type|Description
-----|----|-----------
0|tns:license_type[]|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Services Id
			</th>
			<th>
				Services Name
			</th>
			<th>
				Services Cost
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				5000
			</td>
			<td>
				INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
		</tr>
		<tr>
			<td>
				5001
			</td>
			<td>
				INTERSERVER-EXTERNAL-VPS
			</td>
			<td>
				14.95
			</td>
		</tr>
		<tr>
			<td>
				5002
			</td>
			<td>
				INTERSERVER-EXTERNAL-VZZO
			</td>
			<td>
				13.95
			</td>
		</tr>
		<tr>
			<td>
				5003
			</td>
			<td>
				Fantastico
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5005
			</td>
			<td>
				INTERSERVER-ENKOMP-EXTERNAL-A500
			</td>
			<td>
				55
			</td>
		</tr>
		<tr>
			<td>
				5006
			</td>
			<td>
				Softaculous
			</td>
			<td>
				3
			</td>
		</tr>
		<tr>
			<td>
				5007
			</td>
			<td>
				Softaculous VPS
			</td>
			<td>
				2
			</td>
		</tr>
		<tr>
			<td>
				5008
			</td>
			<td>
				INTERSERVER-INTERNAL
			</td>
			<td>
				20
			</td>
		</tr>
		<tr>
			<td>
				5009
			</td>
			<td>
				INTERSERVER-INTERNAL-VZZO
			</td>
			<td>
				10
			</td>
		</tr>
		<tr>
			<td>
				5013
			</td>
			<td>
				Fantastico VPS
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5014
			</td>
			<td>
				INTERSERVER-INTERNAL-VPS
			</td>
			<td>
				10
			</td>
		</tr>
		<tr>
			<td>
				5017
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ 10 Domains (Inside DataCenter)
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5018
			</td>
			<td>
				Parallels Plesk v10+/v11+ 10 Domains (Inside DataCenter)
			</td>
			<td>
				16
			</td>
		</tr>
		<tr>
			<td>
				5019
			</td>
			<td>
				Parallels Plesk v10+/v11+ Unlimited Domains (Inside DataCenter)
			</td>
			<td>
				40
			</td>
		</tr>
		<tr>
			<td>
				5020
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ 10 Domains (Outside DataCenter)
			</td>
			<td>
				12
			</td>
		</tr>
		<tr>
			<td>
				5021
			</td>
			<td>
				Parallels Plesk v10+/v11+ 10 Domains (Outside DataCenter)
			</td>
			<td>
				20
			</td>
		</tr>
		<tr>
			<td>
				5022
			</td>
			<td>
				Parallels Plesk v10+/v11+ Unlimited Domains (Outside DataCenter)
			</td>
			<td>
				50
			</td>
		</tr>
		<tr>
			<td>
				5023
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ Unlimited Domains (Inside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5024
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ Unlimited Domains (Outside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5025
			</td>
			<td>
				LiteSpeed WebServer VPS License
			</td>
			<td>
				13.95
			</td>
		</tr>
		<tr>
			<td>
				5026
			</td>
			<td>
				LiteSpeed WebServer Ultra-VPS License
			</td>
			<td>
				19
			</td>
		</tr>
		<tr>
			<td>
				5027
			</td>
			<td>
				LiteSpeed WebServer 1-CPU License
			</td>
			<td>
				30
			</td>
		</tr>
		<tr>
			<td>
				5028
			</td>
			<td>
				LiteSpeed WebServer 2-CPU License
			</td>
			<td>
				46
			</td>
		</tr>
		<tr>
			<td>
				5029
			</td>
			<td>
				LiteSpeed WebServer 4-CPU License
			</td>
			<td>
				65
			</td>
		</tr>
		<tr>
			<td>
				5030
			</td>
			<td>
				LiteSpeed WebServer 8-CPU License
			</td>
			<td>
				92
			</td>
		</tr>
		<tr>
			<td>
				5031
			</td>
			<td>
				LiteSpeed Load Balancer
			</td>
			<td>
				65
			</td>
		</tr>
		<tr>
			<td>
				5032
			</td>
			<td>
				CloudLinux License
			</td>
			<td>
				10
			</td>
		</tr>
		<tr>
			<td>
				5033
			</td>
			<td>
				CloudLinux Type2 License
			</td>
			<td>
				11.95
			</td>
		</tr>
		<tr>
			<td>
				5034
			</td>
			<td>
				KernelCare License
			</td>
			<td>
				2.95
			</td>
		</tr>
		<tr>
			<td>
				5035
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows Unlimited Domains (Inside DataCenter)
			</td>
			<td>
				40
			</td>
		</tr>
		<tr>
			<td>
				5036
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows Unlimited Domains (Outside DataCenter)
			</td>
			<td>
				50
			</td>
		</tr>
		<tr>
			<td>
				5037
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows for VZ Unlimited Domains (Inside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5038
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows for VZ Unlimited Domains (Outside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5039
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VPS Unlimited Domains (Inside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5040
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VPS Unlimited Domains (Outside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5041
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows for VPS Unlimited Domains (Inside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5042
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows for VPS Unlimited Domains (Outside DataCenter)
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5043
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VPS 100 Domains (Inside DataCenter)
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5044
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VPS 100 Domains (Outside DataCenter)
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5045
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows 100 Domains (Inside DaCenter)
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5046
			</td>
			<td>
				Parallels Plesk v10+/v11+ for Windows 100 Domains (Outside DataCenter)
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5047
			</td>
			<td>
				Parallels Plesk v10+/v11+ 100 Domains (Inside DataCenter)
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5048
			</td>
			<td>
				Parallels Plesk v10+/v11+ 100 Domains (Outside DataCenter)
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5049
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ 100 Domains (Inside DataCenter)
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5050
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ 100 Domains (Outside DataCenter)
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5051
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ 100 Domains (Inside DataCenter)
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5052
			</td>
			<td>
				Parallels Plesk v10+/v11+ for VZ 100 Domains (Outside DataCenter)
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5053
			</td>
			<td>
				Plesk v12 Web Admin Edition for Virtual Machines
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5054
			</td>
			<td>
				Plesk v12 Web Admin Edition for Dedicated Servers
			</td>
			<td>
				4
			</td>
		</tr>
		<tr>
			<td>
				5055
			</td>
			<td>
				Plesk v12 Web App Edition for Virtual Machines
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5056
			</td>
			<td>
				Plesk v12 Web App Edition for Dedicated Servers
			</td>
			<td>
				5
			</td>
		</tr>
		<tr>
			<td>
				5057
			</td>
			<td>
				Plesk v12 Web Pro Edition for Virtual Machines
			</td>
			<td>
				10
			</td>
		</tr>
		<tr>
			<td>
				5058
			</td>
			<td>
				Plesk v12 Web Pro Edition for Dedicated Servers
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5059
			</td>
			<td>
				Plesk v12 Web Host Edition for Virtual Machines
			</td>
			<td>
				15
			</td>
		</tr>
		<tr>
			<td>
				5060
			</td>
			<td>
				Plesk v12 Web Host Edition for Dedicated Servers
			</td>
			<td>
				35
			</td>
		</tr>
		<tr>
			<td>
				5061
			</td>
			<td>
				Plesk v12 Web ProEdition with CloudLinux for Virtual Machines
			</td>
			<td>
				20
			</td>
		</tr>
		<tr>
			<td>
				5062
			</td>
			<td>
				Plesk v12 Web ProEdition with CloudLinux for Dedicated Servers
			</td>
			<td>
				25
			</td>
		</tr>
		<tr>
			<td>
				5063
			</td>
			<td>
				Plesk v12 Web HostEdition with CloudLinux for Virtual Machines
			</td>
			<td>
				25
			</td>
		</tr>
		<tr>
			<td>
				5064
			</td>
			<td>
				Plesk v12 Web HostEdition with CloudLinux for Dedicated Servers
			</td>
			<td>
				45
			</td>
		</tr>
		<tr>
			<td>
				5066
			</td>
			<td>
				DirectAdmin for CentOS 5 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5067
			</td>
			<td>
				DirectAdmin for CentOS 6 32-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5068
			</td>
			<td>
				DirectAdmin for CentOS 6 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5069
			</td>
			<td>
				DirectAdmin for CentOS 7 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5070
			</td>
			<td>
				DirectAdmin for FreeBSD 8.x 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5071
			</td>
			<td>
				DirectAdmin for FreeBSD 9.x 32-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5072
			</td>
			<td>
				DirectAdmin for FreeBSD 9.x 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5073
			</td>
			<td>
				DirectAdmin for Debian 6.0 32-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5074
			</td>
			<td>
				DirectAdmin for Debian 6.0 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5075
			</td>
			<td>
				DirectAdmin for Debian 7.0 32-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5076
			</td>
			<td>
				DirectAdmin for Debian 7.0 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5077
			</td>
			<td>
				DirectAdmin for Debian 8.0 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5078
			</td>
			<td>
				DirectAdmin for Debian 5.0 32-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5079
			</td>
			<td>
				DirectAdmin for Debian 5.0 64-bit
			</td>
			<td>
				8
			</td>
		</tr>
		<tr>
			<td>
				5080
			</td>
			<td>
				DirectAdmin for CentOS 5 32-bit
			</td>
			<td>
				8
			</td>
		</tr>
	</tbody>
</table>


### Licenses Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_licenses_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_cancel_service**

This Function Applies to the Licensing services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Licenses Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_licenses_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_get_client_invoices**

This Function Applies to the Licensing services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Invoices Id
			</th>
			<th>
				Invoices Description
			</th>
			<th>
				Invoices Amount
			</th>
			<th>
				Invoices Custid
			</th>
			<th>
				Invoices Type
			</th>
			<th>
				Invoices Date
			</th>
			<th>
				Invoices Group
			</th>
			<th>
				Invoices Extra
			</th>
			<th>
				Invoices Paid
			</th>
			<th>
				Invoices Module
			</th>
			<th>
				Invoices Due Date
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				2514249
			</td>
			<td>
				(Repeat Invoice: 2504689) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:40
			</td>
			<td>
				0
			</td>
			<td>
				2504689
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:40
			</td>
		</tr>
		<tr>
			<td>
				2514250
			</td>
			<td>
				(Repeat Invoice: 2504690) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:56
			</td>
			<td>
				0
			</td>
			<td>
				2504690
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:56
			</td>
		</tr>
		<tr>
			<td>
				2514251
			</td>
			<td>
				(Repeat Invoice: 2504691) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:00:25
			</td>
			<td>
				0
			</td>
			<td>
				2504691
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:00:25
			</td>
		</tr>
		<tr>
			<td>
				2514252
			</td>
			<td>
				(Repeat Invoice: 2504692) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:01:12
			</td>
			<td>
				0
			</td>
			<td>
				2504692
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:01:12
			</td>
		</tr>
		<tr>
			<td>
				2514255
			</td>
			<td>
				(Repeat Invoice: 2504694) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:02:56
			</td>
			<td>
				0
			</td>
			<td>
				2504694
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:02:56
			</td>
		</tr>
		<tr>
			<td>
				2514256
			</td>
			<td>
				(Repeat Invoice: 2504695) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:05:14
			</td>
			<td>
				0
			</td>
			<td>
				2504695
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:05:14
			</td>
		</tr>
		<tr>
			<td>
				2514257
			</td>
			<td>
				(Repeat Invoice: 2504696) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:15:25
			</td>
			<td>
				0
			</td>
			<td>
				2504696
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:15:25
			</td>
		</tr>
		<tr>
			<td>
				2514258
			</td>
			<td>
				(Repeat Invoice: 2504697) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:21:50
			</td>
			<td>
				0
			</td>
			<td>
				2504697
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:21:50
			</td>
		</tr>
		<tr>
			<td>
				2514259
			</td>
			<td>
				(Repeat Invoice: 2504698) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:27:46
			</td>
			<td>
				0
			</td>
			<td>
				2504698
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:27:46
			</td>
		</tr>
		<tr>
			<td>
				2514262
			</td>
			<td>
				(Repeat Invoice: 2504700) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:35:30
			</td>
			<td>
				0
			</td>
			<td>
				2504700
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:35:30
			</td>
		</tr>
		<tr>
			<td>
				2514263
			</td>
			<td>
				(Repeat Invoice: 2504701) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:48:38
			</td>
			<td>
				0
			</td>
			<td>
				2504701
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:48:38
			</td>
		</tr>
		<tr>
			<td>
				2514264
			</td>
			<td>
				(Repeat Invoice: 2504702) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:50:21
			</td>
			<td>
				0
			</td>
			<td>
				2504702
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:50:21
			</td>
		</tr>
		<tr>
			<td>
				2514265
			</td>
			<td>
				(Repeat Invoice: 2504703) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:51:59
			</td>
			<td>
				0
			</td>
			<td>
				2504703
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:51:59
			</td>
		</tr>
		<tr>
			<td>
				2514266
			</td>
			<td>
				(Repeat Invoice: 2504704) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 16:26:45
			</td>
			<td>
				0
			</td>
			<td>
				2504704
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 16:26:45
			</td>
		</tr>
		<tr>
			<td>
				2515314
			</td>
			<td>
				(Repeat Invoice: 2504881) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 11:21:14
			</td>
			<td>
				0
			</td>
			<td>
				2504881
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 11:21:14
			</td>
		</tr>
		<tr>
			<td>
				2515335
			</td>
			<td>
				(Repeat Invoice: 2504886) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:28:38
			</td>
			<td>
				0
			</td>
			<td>
				2504886
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:28:38
			</td>
		</tr>
		<tr>
			<td>
				2515336
			</td>
			<td>
				(Repeat Invoice: 2504887) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:31:38
			</td>
			<td>
				0
			</td>
			<td>
				2504887
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:31:38
			</td>
		</tr>
		<tr>
			<td>
				2515340
			</td>
			<td>
				(Repeat Invoice: 2504890) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:34:44
			</td>
			<td>
				0
			</td>
			<td>
				2504890
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:34:44
			</td>
		</tr>
		<tr>
			<td>
				2515341
			</td>
			<td>
				(Repeat Invoice: 2504891) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:38:22
			</td>
			<td>
				0
			</td>
			<td>
				2504891
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:38:22
			</td>
		</tr>
		<tr>
			<td>
				2515343
			</td>
			<td>
				(Repeat Invoice: 2504892) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:41:19
			</td>
			<td>
				0
			</td>
			<td>
				2504892
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:41:19
			</td>
		</tr>
		<tr>
			<td>
				2515347
			</td>
			<td>
				(Repeat Invoice: 2504895) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:44:51
			</td>
			<td>
				0
			</td>
			<td>
				2504895
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:44:51
			</td>
		</tr>
		<tr>
			<td>
				2515351
			</td>
			<td>
				(Repeat Invoice: 2504897) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:50:15
			</td>
			<td>
				0
			</td>
			<td>
				2504897
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:50:15
			</td>
		</tr>
		<tr>
			<td>
				2515359
			</td>
			<td>
				(Repeat Invoice: 2504902) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:35:17
			</td>
			<td>
				0
			</td>
			<td>
				2504902
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:35:17
			</td>
		</tr>
		<tr>
			<td>
				2515362
			</td>
			<td>
				(Repeat Invoice: 2504904) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:44:02
			</td>
			<td>
				0
			</td>
			<td>
				2504904
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:44:02
			</td>
		</tr>
		<tr>
			<td>
				2515363
			</td>
			<td>
				(Repeat Invoice: 2504905) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:46:16
			</td>
			<td>
				0
			</td>
			<td>
				2504905
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:46:16
			</td>
		</tr>
		<tr>
			<td>
				2515364
			</td>
			<td>
				(Repeat Invoice: 2504906) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:48:08
			</td>
			<td>
				0
			</td>
			<td>
				2504906
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:48:08
			</td>
		</tr>
		<tr>
			<td>
				2515365
			</td>
			<td>
				(Repeat Invoice: 2504907) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:51:13
			</td>
			<td>
				0
			</td>
			<td>
				2504907
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:51:13
			</td>
		</tr>
		<tr>
			<td>
				2515366
			</td>
			<td>
				(Repeat Invoice: 2504908) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:40
			</td>
			<td>
				0
			</td>
			<td>
				2504908
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:40
			</td>
		</tr>
		<tr>
			<td>
				2515367
			</td>
			<td>
				(Repeat Invoice: 2504909) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:51
			</td>
			<td>
				0
			</td>
			<td>
				2504909
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:51
			</td>
		</tr>
		<tr>
			<td>
				2515368
			</td>
			<td>
				(Repeat Invoice: 2504910) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:01:59
			</td>
			<td>
				0
			</td>
			<td>
				2504910
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:01:59
			</td>
		</tr>
		<tr>
			<td>
				2515369
			</td>
			<td>
				(Repeat Invoice: 2504911) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:03:34
			</td>
			<td>
				0
			</td>
			<td>
				2504911
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:03:34
			</td>
		</tr>
		<tr>
			<td>
				2515370
			</td>
			<td>
				(Repeat Invoice: 2504912) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:04:33
			</td>
			<td>
				0
			</td>
			<td>
				2504912
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:04:33
			</td>
		</tr>
		<tr>
			<td>
				2515371
			</td>
			<td>
				(Repeat Invoice: 2504913) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:06:20
			</td>
			<td>
				0
			</td>
			<td>
				2504913
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:06:20
			</td>
		</tr>
		<tr>
			<td>
				2515372
			</td>
			<td>
				(Repeat Invoice: 2504914) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:08:44
			</td>
			<td>
				0
			</td>
			<td>
				2504914
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:08:44
			</td>
		</tr>
		<tr>
			<td>
				2515373
			</td>
			<td>
				(Repeat Invoice: 2504915) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:15:31
			</td>
			<td>
				0
			</td>
			<td>
				2504915
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:15:31
			</td>
		</tr>
		<tr>
			<td>
				2515375
			</td>
			<td>
				(Repeat Invoice: 2504916) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:30:39
			</td>
			<td>
				0
			</td>
			<td>
				2504916
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:30:39
			</td>
		</tr>
		<tr>
			<td>
				2515376
			</td>
			<td>
				(Repeat Invoice: 2504917) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:31:35
			</td>
			<td>
				0
			</td>
			<td>
				2504917
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:31:35
			</td>
		</tr>
		<tr>
			<td>
				2515377
			</td>
			<td>
				(Repeat Invoice: 2504918) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:36:04
			</td>
			<td>
				0
			</td>
			<td>
				2504918
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:36:04
			</td>
		</tr>
		<tr>
			<td>
				2515389
			</td>
			<td>
				(Repeat Invoice: 2504927) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:47:30
			</td>
			<td>
				0
			</td>
			<td>
				2504927
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:47:30
			</td>
		</tr>
		<tr>
			<td>
				2515392
			</td>
			<td>
				(Repeat Invoice: 2504929) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:52:45
			</td>
			<td>
				0
			</td>
			<td>
				2504929
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:52:45
			</td>
		</tr>
		<tr>
			<td>
				2515393
			</td>
			<td>
				(Repeat Invoice: 2504930) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:58:51
			</td>
			<td>
				0
			</td>
			<td>
				2504930
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:58:51
			</td>
		</tr>
		<tr>
			<td>
				2515394
			</td>
			<td>
				(Repeat Invoice: 2504931) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 17:01:43
			</td>
			<td>
				0
			</td>
			<td>
				2504931
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 17:01:43
			</td>
		</tr>
	</tbody>
</table>


### Licenses Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_licenses_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_get_client_unpaid_invoices**

This Function Applies to the Licensing services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				Invoices Id
			</th>
			<th>
				Invoices Description
			</th>
			<th>
				Invoices Amount
			</th>
			<th>
				Invoices Custid
			</th>
			<th>
				Invoices Type
			</th>
			<th>
				Invoices Date
			</th>
			<th>
				Invoices Group
			</th>
			<th>
				Invoices Extra
			</th>
			<th>
				Invoices Paid
			</th>
			<th>
				Invoices Module
			</th>
			<th>
				Invoices Due Date
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				2514249
			</td>
			<td>
				(Repeat Invoice: 2504689) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:40
			</td>
			<td>
				0
			</td>
			<td>
				2504689
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:40
			</td>
		</tr>
		<tr>
			<td>
				2514250
			</td>
			<td>
				(Repeat Invoice: 2504690) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 14:55:56
			</td>
			<td>
				0
			</td>
			<td>
				2504690
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 14:55:56
			</td>
		</tr>
		<tr>
			<td>
				2514251
			</td>
			<td>
				(Repeat Invoice: 2504691) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:00:25
			</td>
			<td>
				0
			</td>
			<td>
				2504691
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:00:25
			</td>
		</tr>
		<tr>
			<td>
				2514252
			</td>
			<td>
				(Repeat Invoice: 2504692) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:01:12
			</td>
			<td>
				0
			</td>
			<td>
				2504692
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:01:12
			</td>
		</tr>
		<tr>
			<td>
				2514255
			</td>
			<td>
				(Repeat Invoice: 2504694) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:02:56
			</td>
			<td>
				0
			</td>
			<td>
				2504694
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:02:56
			</td>
		</tr>
		<tr>
			<td>
				2514256
			</td>
			<td>
				(Repeat Invoice: 2504695) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:05:14
			</td>
			<td>
				0
			</td>
			<td>
				2504695
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:05:14
			</td>
		</tr>
		<tr>
			<td>
				2514257
			</td>
			<td>
				(Repeat Invoice: 2504696) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:15:25
			</td>
			<td>
				0
			</td>
			<td>
				2504696
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:15:25
			</td>
		</tr>
		<tr>
			<td>
				2514258
			</td>
			<td>
				(Repeat Invoice: 2504697) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:21:50
			</td>
			<td>
				0
			</td>
			<td>
				2504697
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:21:50
			</td>
		</tr>
		<tr>
			<td>
				2514259
			</td>
			<td>
				(Repeat Invoice: 2504698) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:27:46
			</td>
			<td>
				0
			</td>
			<td>
				2504698
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:27:46
			</td>
		</tr>
		<tr>
			<td>
				2514262
			</td>
			<td>
				(Repeat Invoice: 2504700) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:35:30
			</td>
			<td>
				0
			</td>
			<td>
				2504700
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:35:30
			</td>
		</tr>
		<tr>
			<td>
				2514263
			</td>
			<td>
				(Repeat Invoice: 2504701) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:48:38
			</td>
			<td>
				0
			</td>
			<td>
				2504701
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:48:38
			</td>
		</tr>
		<tr>
			<td>
				2514264
			</td>
			<td>
				(Repeat Invoice: 2504702) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:50:21
			</td>
			<td>
				0
			</td>
			<td>
				2504702
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:50:21
			</td>
		</tr>
		<tr>
			<td>
				2514265
			</td>
			<td>
				(Repeat Invoice: 2504703) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 15:51:59
			</td>
			<td>
				0
			</td>
			<td>
				2504703
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 15:51:59
			</td>
		</tr>
		<tr>
			<td>
				2514266
			</td>
			<td>
				(Repeat Invoice: 2504704) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-10-30 16:26:45
			</td>
			<td>
				0
			</td>
			<td>
				2504704
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-08 16:26:45
			</td>
		</tr>
		<tr>
			<td>
				2515314
			</td>
			<td>
				(Repeat Invoice: 2504881) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 11:21:14
			</td>
			<td>
				0
			</td>
			<td>
				2504881
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 11:21:14
			</td>
		</tr>
		<tr>
			<td>
				2515335
			</td>
			<td>
				(Repeat Invoice: 2504886) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:28:38
			</td>
			<td>
				0
			</td>
			<td>
				2504886
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:28:38
			</td>
		</tr>
		<tr>
			<td>
				2515336
			</td>
			<td>
				(Repeat Invoice: 2504887) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:31:38
			</td>
			<td>
				0
			</td>
			<td>
				2504887
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:31:38
			</td>
		</tr>
		<tr>
			<td>
				2515340
			</td>
			<td>
				(Repeat Invoice: 2504890) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:34:44
			</td>
			<td>
				0
			</td>
			<td>
				2504890
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:34:44
			</td>
		</tr>
		<tr>
			<td>
				2515341
			</td>
			<td>
				(Repeat Invoice: 2504891) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:38:22
			</td>
			<td>
				0
			</td>
			<td>
				2504891
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:38:22
			</td>
		</tr>
		<tr>
			<td>
				2515343
			</td>
			<td>
				(Repeat Invoice: 2504892) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:41:19
			</td>
			<td>
				0
			</td>
			<td>
				2504892
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:41:19
			</td>
		</tr>
		<tr>
			<td>
				2515347
			</td>
			<td>
				(Repeat Invoice: 2504895) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:44:51
			</td>
			<td>
				0
			</td>
			<td>
				2504895
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:44:51
			</td>
		</tr>
		<tr>
			<td>
				2515351
			</td>
			<td>
				(Repeat Invoice: 2504897) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 12:50:15
			</td>
			<td>
				0
			</td>
			<td>
				2504897
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 12:50:15
			</td>
		</tr>
		<tr>
			<td>
				2515359
			</td>
			<td>
				(Repeat Invoice: 2504902) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:35:17
			</td>
			<td>
				0
			</td>
			<td>
				2504902
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:35:17
			</td>
		</tr>
		<tr>
			<td>
				2515362
			</td>
			<td>
				(Repeat Invoice: 2504904) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:44:02
			</td>
			<td>
				0
			</td>
			<td>
				2504904
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:44:02
			</td>
		</tr>
		<tr>
			<td>
				2515363
			</td>
			<td>
				(Repeat Invoice: 2504905) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:46:16
			</td>
			<td>
				0
			</td>
			<td>
				2504905
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:46:16
			</td>
		</tr>
		<tr>
			<td>
				2515364
			</td>
			<td>
				(Repeat Invoice: 2504906) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:48:08
			</td>
			<td>
				0
			</td>
			<td>
				2504906
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:48:08
			</td>
		</tr>
		<tr>
			<td>
				2515365
			</td>
			<td>
				(Repeat Invoice: 2504907) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:51:13
			</td>
			<td>
				0
			</td>
			<td>
				2504907
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:51:13
			</td>
		</tr>
		<tr>
			<td>
				2515366
			</td>
			<td>
				(Repeat Invoice: 2504908) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:40
			</td>
			<td>
				0
			</td>
			<td>
				2504908
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:40
			</td>
		</tr>
		<tr>
			<td>
				2515367
			</td>
			<td>
				(Repeat Invoice: 2504909) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 13:59:51
			</td>
			<td>
				0
			</td>
			<td>
				2504909
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 13:59:51
			</td>
		</tr>
		<tr>
			<td>
				2515368
			</td>
			<td>
				(Repeat Invoice: 2504910) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:01:59
			</td>
			<td>
				0
			</td>
			<td>
				2504910
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:01:59
			</td>
		</tr>
		<tr>
			<td>
				2515369
			</td>
			<td>
				(Repeat Invoice: 2504911) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:03:34
			</td>
			<td>
				0
			</td>
			<td>
				2504911
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:03:34
			</td>
		</tr>
		<tr>
			<td>
				2515370
			</td>
			<td>
				(Repeat Invoice: 2504912) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:04:33
			</td>
			<td>
				0
			</td>
			<td>
				2504912
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:04:33
			</td>
		</tr>
		<tr>
			<td>
				2515371
			</td>
			<td>
				(Repeat Invoice: 2504913) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:06:20
			</td>
			<td>
				0
			</td>
			<td>
				2504913
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:06:20
			</td>
		</tr>
		<tr>
			<td>
				2515372
			</td>
			<td>
				(Repeat Invoice: 2504914) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:08:44
			</td>
			<td>
				0
			</td>
			<td>
				2504914
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:08:44
			</td>
		</tr>
		<tr>
			<td>
				2515373
			</td>
			<td>
				(Repeat Invoice: 2504915) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:15:31
			</td>
			<td>
				0
			</td>
			<td>
				2504915
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:15:31
			</td>
		</tr>
		<tr>
			<td>
				2515375
			</td>
			<td>
				(Repeat Invoice: 2504916) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:30:39
			</td>
			<td>
				0
			</td>
			<td>
				2504916
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:30:39
			</td>
		</tr>
		<tr>
			<td>
				2515376
			</td>
			<td>
				(Repeat Invoice: 2504917) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:31:35
			</td>
			<td>
				0
			</td>
			<td>
				2504917
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:31:35
			</td>
		</tr>
		<tr>
			<td>
				2515377
			</td>
			<td>
				(Repeat Invoice: 2504918) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 14:36:04
			</td>
			<td>
				0
			</td>
			<td>
				2504918
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 14:36:04
			</td>
		</tr>
		<tr>
			<td>
				2515389
			</td>
			<td>
				(Repeat Invoice: 2504927) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:47:30
			</td>
			<td>
				0
			</td>
			<td>
				2504927
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:47:30
			</td>
		</tr>
		<tr>
			<td>
				2515392
			</td>
			<td>
				(Repeat Invoice: 2504929) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:52:45
			</td>
			<td>
				0
			</td>
			<td>
				2504929
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:52:45
			</td>
		</tr>
		<tr>
			<td>
				2515393
			</td>
			<td>
				(Repeat Invoice: 2504930) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 16:58:51
			</td>
			<td>
				0
			</td>
			<td>
				2504930
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 16:58:51
			</td>
		</tr>
		<tr>
			<td>
				2515394
			</td>
			<td>
				(Repeat Invoice: 2504931) INTERSERVER-EXTERNAL
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				1
			</td>
			<td>
				2015-11-03 17:01:43
			</td>
			<td>
				0
			</td>
			<td>
				2504931
			</td>
			<td>
				0
			</td>
			<td>
				licenses
			</td>
			<td>
				2015-11-12 17:01:43
			</td>
		</tr>
	</tbody>
</table>


### Licenses Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_licenses_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_get_service**

This Function Applies to the Licensing services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
license_id|int|Service ID
license_type|int|Package ID
license_cost|float|Service Cost
license_custid|int|Customer ID
license_ip|string|
license_status|string|Billing Status
license_invoice|int|Invoice ID
license_coupon|int|Coupon ID
license_extra|string|
license_hostname|string|


### Licenses Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_licenses_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_licenses_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_licenses_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_licenses_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_licenses_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_licenses_get_services**

This Function Applies to the Licensing services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
license_id|int|Service ID
license_type|int|Package ID
license_cost|float|Service Cost
license_custid|int|Customer ID
license_ip|string|
license_status|string|Billing Status
license_invoice|int|Invoice ID
license_coupon|int|Coupon ID
license_extra|string|
license_hostname|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>
				License Id
			</th>
			<th>
				License Type
			</th>
			<th>
				License Cost
			</th>
			<th>
				License Custid
			</th>
			<th>
				License Ip
			</th>
			<th>
				License Status
			</th>
			<th>
				License Invoice
			</th>
			<th>
				License Coupon
			</th>
			<th>
				License Extra
			</th>
			<th>
				License Hostname
			</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>
				381906
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504689
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381907
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504690
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381908
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504691
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381909
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504692
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381910
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504694
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381911
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504695
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381912
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504696
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381913
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504697
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381914
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504698
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381915
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504700
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381916
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504701
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381917
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504702
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381918
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504703
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381919
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504704
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381929
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504881
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381930
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504886
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381931
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504887
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381932
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504890
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381933
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504891
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381934
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504892
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381937
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504895
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381938
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504897
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381939
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504902
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381940
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504904
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381941
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504905
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381942
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504906
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381943
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504907
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381944
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504908
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381945
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504909
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381946
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504910
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381947
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504911
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381948
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504912
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381949
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504913
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381950
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504914
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381951
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504915
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381952
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504916
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381953
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504917
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381954
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504918
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381956
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504927
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381957
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504929
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381958
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504930
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
		<tr>
			<td>
				381959
			</td>
			<td>
				5000
			</td>
			<td>
				34.95
			</td>
			<td>
				160884
			</td>
			<td>
				4.4.4.4
			</td>
			<td>
				pending
			</td>
			<td>
				2504931
			</td>
			<td>
				0
			</td>
			<td>
				
			</td>
			<td>
				
			</td>
		</tr>
	</tbody>
</table>

## Quickservers




### Quickservers Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_quickservers_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_cancel_service**

This Function Applies to the QuickServers services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Quickservers Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_quickservers_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_get_client_invoices**

This Function Applies to the QuickServers services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Quickservers Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_quickservers_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_get_client_unpaid_invoices**

This Function Applies to the QuickServers services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due
invoices_service|int|ID of the Service/Order this Invoice is for such as 1000 if the order was vps1000 and the module was vps


### Quickservers Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_quickservers_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_get_service**

This Function Applies to the QuickServers services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
qs_id|int|Server ID
qs_server|int|
qs_vzid|string|
qs_type|int|Server Type
qs_cost|float|Service Cost
qs_custid|int|Customer ID
qs_ip|string|IP Address
qs_status|string|Billing Status
qs_invoice|int|Invoice ID
qs_coupon|int|Coupon ID
qs_extra|string|
qs_hostname|string|
qs_server_status|string|
qs_comment|string|
qs_slices|int|
qs_vnc|string|


### Quickservers Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_quickservers_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_quickservers_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_quickservers_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_quickservers_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_quickservers_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_quickservers_get_services**

This Function Applies to the QuickServers services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
qs_id|int|Server ID
qs_server|int|
qs_vzid|string|
qs_type|int|Server Type
qs_cost|float|Service Cost
qs_custid|int|Customer ID
qs_ip|string|IP Address
qs_status|string|Billing Status
qs_invoice|int|Invoice ID
qs_coupon|int|Coupon ID
qs_extra|string|
qs_hostname|string|
qs_server_status|string|
qs_comment|string|
qs_slices|int|
qs_vnc|string|

## Domains




### Domains Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_domains_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_cancel_service**

This Function Applies to the Domain Registrations services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Domains Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_domains_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_get_client_invoices**

This Function Applies to the Domain Registrations services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Domains Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_domains_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_get_client_unpaid_invoices**

This Function Applies to the Domain Registrations services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Domains Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_domains_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_get_service**

This Function Applies to the Domain Registrations services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
domain_id|int|Service ID
domain_hostname|string|
domain_username|string|
domain_password|string|
domain_type|int|Package ID
domain_cost|float|Service Cost
domain_custid|int|Customer ID
domain_status|string|Billing Status
domain_invoice|int|Invoice ID
domain_coupon|int|Coupon ID
domain_extra|string|
domain_firstname|string|
domain_lastname|string|
domain_email|string|
domain_address|string|
domain_address2|string|
domain_address3|string|
domain_city|string|
domain_state|string|
domain_zip|string|
domain_country|string|
domain_phone|string|
domain_fax|string|
domain_company|string|


### Domains Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_domains_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_domains_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_domains_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_domains_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_domains_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_domains_get_services**

This Function Applies to the Domain Registrations services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
domain_id|int|Service ID
domain_hostname|string|
domain_username|string|
domain_password|string|
domain_type|int|Package ID
domain_cost|float|Service Cost
domain_custid|int|Customer ID
domain_status|string|Billing Status
domain_invoice|int|Invoice ID
domain_coupon|int|Coupon ID
domain_extra|string|
domain_firstname|string|
domain_lastname|string|
domain_email|string|
domain_address|string|
domain_address2|string|
domain_address3|string|
domain_city|string|
domain_state|string|
domain_zip|string|
domain_country|string|
domain_phone|string|
domain_fax|string|
domain_company|string|

## SSL




### SSL Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_ssl_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_cancel_service**

This Function Applies to the SSL Certificates services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### SSL Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_ssl_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_get_client_invoices**

This Function Applies to the SSL Certificates services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### SSL Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_ssl_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_get_client_unpaid_invoices**

This Function Applies to the SSL Certificates services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### SSL Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_ssl_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_get_service**

This Function Applies to the SSL Certificates services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
ssl_id|int|Service ID
ssl_hostname|string|
ssl_order_id|string|
ssl_type|int|Package ID
ssl_cost|float|Service Cost
ssl_custid|int|Customer ID
ssl_status|string|Billing Status
ssl_invoice|int|Invoice ID
ssl_coupon|int|Coupon ID
ssl_firstname|string|
ssl_lastname|string|
ssl_phone|string|
ssl_email|string|
ssl_company|string|
ssl_address|string|
ssl_city|string|
ssl_state|string|
ssl_zip|string|
ssl_country|string|
ssl_department|string|
ssl_extra|string|


### SSL Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_ssl_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_ssl_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_ssl_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_ssl_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_ssl_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_ssl_get_services**

This Function Applies to the SSL Certificates services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
ssl_id|int|Service ID
ssl_hostname|string|
ssl_order_id|string|
ssl_type|int|Package ID
ssl_cost|float|Service Cost
ssl_custid|int|Customer ID
ssl_status|string|Billing Status
ssl_invoice|int|Invoice ID
ssl_coupon|int|Coupon ID
ssl_firstname|string|
ssl_lastname|string|
ssl_phone|string|
ssl_email|string|
ssl_company|string|
ssl_address|string|
ssl_city|string|
ssl_state|string|
ssl_zip|string|
ssl_country|string|
ssl_department|string|
ssl_extra|string|

## Backups




### Backups Cancel Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_cancel_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_cancel_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_cancel_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_backups_cancel_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_cancel_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_cancel_service**

This Function Applies to the Backup Services services.
* Cancels a service for the passed module matching the passed id.  Canceling a
* service will also cancel any addons for that service at the same time.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|the Order ID / Service ID you wish to cancel

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Backups Get Client Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_get_client_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_get_client_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_get_client_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_backups_get_client_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_get_client_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_get_client_invoices**

This Function Applies to the Backup Services services.
* Gets a list of all the invoices.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Backups Get Client Unpaid Invoices

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_get_client_unpaid_invoices($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_get_client_unpaid_invoices()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_get_client_unpaid_invoices, message: { 
    sid: ARGV[0], 
})
print response.body[:api_backups_get_client_unpaid_invoices_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_get_client_unpaid_invoices($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_get_client_unpaid_invoices**

This Function Applies to the Backup Services services.
* This function returns a list of all the unpaid invoices matching the module
* passed..

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
invoices_id|int|ID of the Invoice used for referencing
invoices_description|string|Description of what the Invoice was for
invoices_amount|float|Cost of the Invoice
invoices_custid|int|ID of the Customer this Invoice is for
invoices_type|int|The Type of Invoice (1 = charge, 10+ are payment types)
invoices_date|string|Date the Invoice was Created
invoices_group|int|Billing Group the Invoice falls under, Not currently used
invoices_extra|int|If type 1 invoice this points to the repeat invoice id, otherwise points to the id of the charge invoice its a payment for.
invoices_paid|int|Wether or not the Invoice was paid (if applicable)
invoices_module|string|Module the Invoice was for.  You can use [get_modules](#get-modules) to get a list of available modules.
invoices_due_date|string|Date the Invoice is Due


### Backups Get Service

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_get_service($sid, $id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_get_service()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_get_service, message: { 
    sid: ARGV[0], 
    id: ARGV[1], 
})
print response.body[:api_backups_get_service_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_get_service($sid, $id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_get_service**

This Function Applies to the Backup Services services.
* Gets service info for the given ID in the given Module.   An example of this
* would be in the "vps" modulei have order id

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
id|int|service id, such as VPS ID

#### Output Fields

Field|Type|Description
-----|----|-----------
backup_id|int|Service ID
backup_server|int|
backup_username|string|
backup_type|int|Package ID
backup_cost|float|Service Cost
backup_custid|int|Customer ID
backup_quota|int|
backup_ip|string|
backup_status|string|Billing Status
backup_invoice|int|Invoice ID
backup_coupon|int|Coupon ID
backup_extra|string|
backup_server_status|string|


### Backups Get Services

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_backups_get_services($sid);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_backups_get_services()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_backups_get_services, message: { 
    sid: ARGV[0], 
})
print response.body[:api_backups_get_services_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_backups_get_services($sid);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_backups_get_services**

This Function Applies to the Backup Services services.
* Gets List of Services

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call

#### Output Fields

Field|Type|Description
-----|----|-----------
backup_id|int|Service ID
backup_server|int|
backup_username|string|
backup_type|int|Package ID
backup_cost|float|Service Cost
backup_custid|int|Customer ID
backup_quota|int|
backup_ip|string|
backup_status|string|Billing Status
backup_invoice|int|Invoice ID
backup_coupon|int|Coupon ID
backup_extra|string|
backup_server_status|string|

## DNS




### Add Dns Domain

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain = $ARGV[2];
$ip = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_add_dns_domain($sid, $domain, $ip);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_add_dns_domain()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_add_dns_domain, message: { 
    sid: ARGV[0], 
    domain: ARGV[1], 
    ip: ARGV[2], 
})
print response.body[:api_add_dns_domain_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain = $_SERVER['argv'][3];
$ip = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_add_dns_domain($sid, $domain, $ip);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_add_dns_domain**

Adds a new domain into our system.  The status will be "ok" if it added, or
* "error" if there was any problems status_text will contain a description of the
* problem if any.

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain|string|domain name to host
ip|string|ip address to assign it to.

#### Output Fields

Field|Type|Description
-----|----|-----------
status|string|
status_text|string|


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Field</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>status</td>
			<td>error</td>
		</tr>
		<tr>
			<td>status_text</td>
			<td>That Domain Is Already Setup On Our Servers, Try Another Or Contact john@interserver.net</td>
		</tr>
	</tbody>
</table>


### Add Dns Record

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain_id = $ARGV[2];
$name = $ARGV[3];
$content = $ARGV[4];
$type = $ARGV[5];
$ttl = $ARGV[6];
$prio = $ARGV[7];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_add_dns_record($sid, $domain_id, $name, $content, $type, $ttl, $prio);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_add_dns_record()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_add_dns_record, message: { 
    sid: ARGV[0], 
    domain_id: ARGV[1], 
    name: ARGV[2], 
    content: ARGV[3], 
    type: ARGV[4], 
    ttl: ARGV[5], 
    prio: ARGV[6], 
})
print response.body[:api_add_dns_record_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain_id = $_SERVER['argv'][3];
$name = $_SERVER['argv'][4];
$content = $_SERVER['argv'][5];
$type = $_SERVER['argv'][6];
$ttl = $_SERVER['argv'][7];
$prio = $_SERVER['argv'][8];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_add_dns_record($sid, $domain_id, $name, $content, $type, $ttl, $prio);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_add_dns_record**

Adds a single DNS record

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain_id|int|The ID of the domain in question.
name|string|the hostname being set on the dns record.
content|string|the value of the dns record, or what its set to.
type|string|dns record type.
ttl|int|dns record time to live, or update time.
prio|int|dns record priority

#### Output Fields

Field|Type|Description
-----|----|-----------
return|int|


### Delete Dns Domain

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain_id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_delete_dns_domain($sid, $domain_id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_delete_dns_domain()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_delete_dns_domain, message: { 
    sid: ARGV[0], 
    domain_id: ARGV[1], 
})
print response.body[:api_delete_dns_domain_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain_id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_delete_dns_domain($sid, $domain_id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_delete_dns_domain**

Deletes a Domain from our DNS servers

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain_id|int|The ID of the domain in question.

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|will return true if it succeeded, or false if there was some type of error.


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Delete Dns Record

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain_id = $ARGV[2];
$record_id = $ARGV[3];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_delete_dns_record($sid, $domain_id, $record_id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_delete_dns_record()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_delete_dns_record, message: { 
    sid: ARGV[0], 
    domain_id: ARGV[1], 
    record_id: ARGV[2], 
})
print response.body[:api_delete_dns_record_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain_id = $_SERVER['argv'][3];
$record_id = $_SERVER['argv'][4];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_delete_dns_record($sid, $domain_id, $record_id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_delete_dns_record**

Deletes a single DNS record

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain_id|int|The ID of the domain in question.
record_id|int|The ID of the domains record to remove.

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|will return true if it succeeded, or false if there was some type of error.


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>


### Get Dns Domain

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain_id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_get_dns_domain($sid, $domain_id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_get_dns_domain()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_get_dns_domain, message: { 
    sid: ARGV[0], 
    domain_id: ARGV[1], 
})
print response.body[:api_get_dns_domain_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain_id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_get_dns_domain($sid, $domain_id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_dns_domain**

Gets the DNS entry for a given Domain ID

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain_id|int|The ID of the domain in question.

#### Output Fields

Field|Type|Description
-----|----|-----------
id|int|Internal ID
name|string|
master|string|
last_check|int|
type|string|
notified_serial|int|
account|string|


### Get Dns Records

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain_id = $ARGV[2];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_get_dns_records($sid, $domain_id);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_get_dns_records()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_get_dns_records, message: { 
    sid: ARGV[0], 
    domain_id: ARGV[1], 
})
print response.body[:api_get_dns_records_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain_id = $_SERVER['argv'][3];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_get_dns_records($sid, $domain_id);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_get_dns_records**

Gets the DNS records associated with given Domain ID

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain_id|int|The ID of the domain in question.

#### Output Fields

Field|Type|Description
-----|----|-----------
id|int|Internal ID
domain_id|int|The ID of the domain in question.
name|string|
type|string|
content|string|
ttl|int|
prio|int|
change_date|int|


### Update Dns Record

```perl
#!/usr/bin/perl -w
use SOAP::Lite;

$username = $ARGV[0];
$password = $ARGV[1];
$domain_id = $ARGV[2];
$record_id = $ARGV[3];
$name = $ARGV[4];
$content = $ARGV[5];
$type = $ARGV[6];
$ttl = $ARGV[7];
$prio = $ARGV[8];
$client = SOAP::Lite
  -> uri('urn:myapi')
  -> proxy('https://my.interserver.net/api.php?wsdl');
$sid = $client
  -> api_login($username, $password)
  -> result;
if (length($sid) == 0)  {
  die "Got A Blank Sessoion";
} 
$res = $client
  -> api_update_dns_record($sid, $domain_id, $record_id, $name, $content, $type, $ttl, $prio);
die $res->faultstring if ($res->fault);
print "Response:\n",$res->result,"\n";
```

```python
#!/usr/bin/python
from suds.client import Client
client = Client("https://my.interserver.net/api.php?wsdl")
#print client ## shows detailed client info
sid = client.service.api_login(argv[1], argv[2])
if (sid == '')
  die("Got a blank session")
print "Got Session ID "+sid+"\n"
  
result = client.service.api_update_dns_record()
print result
```

```ruby
#!/usr/bin/env ruby
require 'savon'

client = Savon.client(wsdl: 'https://my.interserver.net/api.php?wsdl')

response = client.call(
  :api_login, message: {
    username: ARGV[0],
    password: ARGV[1]
})
sid = response.body[:api_login_response][:return]
if (sid == "")
  die("Got a blank session id");
print "got session id ",sid,"\n"
response = client.call(
  :api_update_dns_record, message: { 
    sid: ARGV[0], 
    domain_id: ARGV[1], 
    record_id: ARGV[2], 
    name: ARGV[3], 
    content: ARGV[4], 
    type: ARGV[5], 
    ttl: ARGV[6], 
    prio: ARGV[7], 
})
print response.body[:api_update_dns_record_response][:return],"\n"
```

```php
<?php
ini_set("soap.wsdl_cache_enabled", "0");
$username = $_SERVER['argv'][1];
$password = $_SERVER['argv'][2];
$domain_id = $_SERVER['argv'][3];
$record_id = $_SERVER['argv'][4];
$name = $_SERVER['argv'][5];
$content = $_SERVER['argv'][6];
$type = $_SERVER['argv'][7];
$ttl = $_SERVER['argv'][8];
$prio = $_SERVER['argv'][9];
$client = new SoapClient("https://my.interserver.net/api.php?wsdl");
try  { 
  $sid = $client->api_login($username, $password);
  if (strlen($sid) == 0)
    die("Got A Blank Sessoion");
  $res = $client->api_update_dns_record($sid, $domain_id, $record_id, $name, $content, $type, $ttl, $prio);
  echo '$res = '.var_export($res, true)."\n";
 } catch (Exception $ex) {
  echo "Exception Occured!\n";
  echo "Code:{$ex->faultcode}\n";
  echo "String:{$ex->faultstring}\n";
}; 
?>
```

**API Function Name: api_update_dns_record**

Updates a single DNS record

#### Input Parameters

Parameter|Type|Description
---------|----|-----------
sid|string|the *Session ID* you get from the [login](#login) call
domain_id|int|The ID of the domain in question.
record_id|int|The ID of the record to update
name|string|the hostname being set on the dns record.
content|string|the value of the dns record, or what its set to.
type|string|dns record type.
ttl|int|dns record time to live, or update time.
prio|int|dns record priority

#### Output Fields

Field|Type|Description
-----|----|-----------
return|bool|True on success, False on failure.


#### Example API Response

<table>
	<thead>
		<tr>
			<th>Type</th>
			<th>Value</th>
		</tr>
	</thead>
	<tbody>
		<tr>
			<td>Boolean</td>
			<td></td>
		</tr>
	</tbody>
</table>

