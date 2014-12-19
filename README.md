
# InterServer VPS SOAP API Documentation

Integrating VPS Setup and Operation into 3<sup>rd</sup> Party Sites and Software
Version 0.9.0 – December 15, 2014 - ©2014 InterServer


## Connecting To the API

### Prerequisites and API URLs

To use the API you will need to first have an account with us.  You can sign up for an account at [http://my.interserver.net/](http://my.interserver.net/)

* You will need the login name (email address) you used to sign up with InterServer and your password.
* The SOAP server is accessible at [https://my.interserver.net/api.php](https://my.interserver.net/api.php)
* The WSDL is available at [https://my.interserver.net/api.php?wsdl](https://my.interserver.net/api.php?wsdl)

### Authentication

* We use a session based authentication system.   You will need to authenticate yourself with our system to get a Session ID.   Once you have a Session ID, you just pass that to prove your identity.  

* To get a Session ID, you need to make a SOAP call to api_login(login, password)  using the information you use to login to [https://my.interserver.net](https://my.interserver.net)

* Sending an api_login(login, password) call will attempt to authenticate your account and if successful will return a Session ID valid for at least several hours.    Subsequent commands and calls to the API will need this Session ID, so keep it handy.

### Sample Login Code

#### PHP
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

#### Perl
```perl
 #!perl -w
  use SOAP::Lite;
  print SOAP::Lite                                             
	-> uri('urn:myapi')
	-> proxy('https://my.interserver.net/api.php?WSDL')
	-> api_login('username@site.com', 'password')                                                    
	-> result;
```

#### Python
```python
from pysimplesoap.client import SoapClient
client = SoapClient(wsdl="https://my.interserver.net/api.php?WSDL",trace=False)
response = client.api_login('username@site.com', 'password')
print response
```

* * *

## Available VPS Server Types and Pricing

We have several types of Servers available for use with VPS Hosting. You can get a list of the types available and there cost per slice/unit by making a call to the **get_vps_slice_types**  function.

## Getting the Available VPS OS Templates

Each Type of Virtualization has its own set of installable OS templates/images.   To get a list of them use the get_vps_templates function.

## Function Reference

* [api_login](https://my1.interserver.net/api.php)

* [api_make_payment](https://my1.interserver.net/api.php)

* [api_get_paypal_url](https://my1.interserver.net/api.php)

* [api_vps_get_service](https://my1.interserver.net/api.php)

* [api_vps_get_services](https://my1.interserver.net/api.php)

* [api_vps_cancel_service](https://my1.interserver.net/api.php)

* [api_vps_get_client_invoices](https://my1.interserver.net/api.php)

* [api_vps_queue_stop](https://my1.interserver.net/api.php)

* [api_vps_queue_start](https://my1.interserver.net/api.php)

* [api_vps_queue_restart](https://my1.interserver.net/api.php)

* [api_vps_get_client_unpaid_invoices](https://my1.interserver.net/api.php)

* [get_vps_locations](https://my1.interserver.net/api.php)

* [get_vps_templates](https://my1.interserver.net/api.php)

* [get_vps_platforms](https://my1.interserver.net/api.php)

* [api_api_validate_buy_vps](https://my1.interserver.net/api.php)

* [api_api_buy_vps](https://my1.interserver.net/api.php)

* [api_vps_screenshot](https://my1.interserver.net/api.php)

* [api_vps_get_server_name](https://my1.interserver.net/api.php)

* [get_hostname](https://my1.interserver.net/api.php)



## get_vps_platforms_array
Use this function to get a list of the various platforms available for ordering.
The *platform* field is also needed to pass to the buy_vps functions.

### Input Parameters
No Input / Parameters to pass

### Output

Field Name|Description
----------|-----------
platform|Field used in the buy_vps functions
name|Name of the VPS Platform

### Example Output

platform|name
--------|----
openvz|OpenVZ 
kvm|KVM
cloudkvm|Cloud


## get_vps_locations_array
Use this function to get a list of the Locations available for ordering.   
The *id* field is also needed to pass to the buy_vps functions. 

### Input Parameters
No Input / Parameters to pass

### Output

Field Name|Description
----------|-----------
id|Location ID used in the ordering process for referencing.
name|Name of the location

### Example Output

id|name
--|----
1|Secaucus, NJ
2|Los Angeles, CA


## get_login
This function creates a session in our system which you will need to pass to most functions for authentication.

### Input Parameters

Parameter|Description
---------|-----------
username|The login/email adddress used to signup
password|Your account password

*This is temporary and will be changed to an API specific key at some point   

### Output

String output, the Session ID if successfull, otherwise a blank string 


## get_vps_slice_types

### Input Parameters
No Input / Parameters to pass

### Output 

Outputs an associative array.

Field Name|Description
----------|-----------
name|This field contains a text description of the package/service
type|Use to match up what OS Image templates are available for this VPS type.
cost|The cost per unit/slice.
buyable|If the service be purchased now<br /> 1 = Available for purchase.<br /> 0 = Not Available for Purchase

### Example Output

* (as of 12/14/2014)

name|type|cost|buyable
----|----|----|-------
OpenVZ VPS Slice|0|6.00|1
KVM Windows VPS Slice|1|10.00|1
KVM Linux VPS Slice|2|8.00|1
Cloud KVM Windows VPS Slice|3|22.00|1
Cloud KVM Linux VPS Slice|4|20.00|1
SSD OpenVZ VPS Slice|5|10.00|1
LXC VPS Slice|9|6.00|0


## api_validate_buy_vps

Checks if the parameters for your order pass validation and let you know if there are any errors.   
It will also give you information on the pricing breakdown. 

### Input Parameters

Parameter|Description
---------|-----------
sid|Session ID from **api_login**
os|File filed from **get_vps_templates**
slices|Integer from 1 to 16 specifying the scale of the VPS resources you want (a 3 slice has 3x the resources of a 1 slice vps)
platform|platform field from the **get_vps_platforms_array**
controlpanel|none, cpanel, or da   for None, cPanel, or DirectAdmin control panel addons, only availbale with CentOS
period|1-36, How frequently to be billed in months.   Some discounts as given based on the period.   
location|id field from the **get_vps_locations_array**
version|os field from **get_vps_templates**
hostname|Desired Hostname for the VPS
coupon|Optional Coupon to pass
rootpass|Desired Root Password (unused for windows, send a blank string) 

### Output Fields

Field|Type|Description
-----|----|-----------
coupon_code|Integer|ID of the Coupon you passed if any
service_cost|Float|Total cost of the order 
slice_cost|Float|Cost of 1 slice based on your order parameters
service_type|Integer|ID of the package you are ordering
repeat_slice_cost|Float|Cost of 1 slice after the order (some coupons might discount only the signup not the monthly (or however often you choose to be billed) amount 
original_slice_cost|Float|Cost of 1 slice without any discounts
original_cost|Float|Total cost of the order before any discounts
repeat_service_cost|Float|Amount that will be billed on future invoices each billig interval after the order 
monthly_service_cost|Float|What the repeat service cost would be with a period of 1 month
custid|Integer|Customer ID
os|String|same field passed for input, if there were any errors in the validation it might be changed.
slices|Integer|same field passed for input, if there were any errors in the validation it might be changed.
platform|String|same field passed for input, if there were any errors in the validation it might be changed.
controlpanel|String|same field passed for input, if there were any errors in the validation it might be changed.
period|Integer|same field passed for input, if there were any errors in the validation it might be changed.
location|Integer|same field passed for input, if there were any errors in the validation it might be changed.
version|String|same field passed for input, if there were any errors in the validation it might be changed.
hostname|String|same field passed for input, if there were any errors in the validation it might be changed.
coupon|String|same field passed for input, if there were any errors in the validation it might be changed.
rootpass|String|same field passed for input, if there were any errors in the validation it might be changed.
status_text|String|descriptive text explaining errors if any, or related response from the order validation  
status|String|'ok' or 'error'

### Example Output


## api_buy_vps

Places a VPS order in our system.    These are the same parameters as api_validate_buy_vps.

### Input Parameters

Parameter|Description
---------|-----------
sid|Session ID from **api_login**
os|File filed from **get_vps_templates**
slices|Integer from 1 to 16 specifying the scale of the VPS resources you want (a 3 slice has 3x the resources of a 1 slice vps)
platform|platform field from the **get_vps_platforms_array**
controlpanel|none, cpanel, or da   for None, cPanel, or DirectAdmin control panel addons, only availbale with CentOS
period|1-36, How frequently to be billed in months.   Some discounts as given based on the period.   
location|id field from the **get_vps_locations_array**
version|os field from **get_vps_templates**
hostname|Desired Hostname for the VPS
coupon|Optional Coupon to pass
rootpass|Desired Root Password (unused for windows, send a blank string)

### Output Fields

Field|Type|Description
-----|----|-----------
status|String|'ok' or 'error'
status_text|String|descriptive text explaining errors if any, or related response from the order  
invoices|String|Invoices associated with th eorder
cost|Float|Total cost of the order

### Example Output


## get_vps_templates

### Input Parameters

No Input / Parameters to pass

### Output Fields

Outputs an associative array.

Field|Description
-----|-----------
type|matches above **type**
bits|32 or 64 Bit OS
os|Distribution / OS Name
version|Distribution / OS Version
file|the **os** field in **buy_vps**
title|Full template name including OS / Version/ Architecture information.

### Example Output

type|virtulization|bits|os|version|file|title
----|-------------|----|--|-------|----|-----
0|OpenVZ|64|altlinux|5.1|altlinux-5.1-x86_64.tar.gz|Altlinux 5.1 64bit (contrib)
0|OpenVZ|32|altlinux|5.1|altlinux-5.1-i586.tar.gz|Altlinux 5.1 32bit (contrib)
0|OpenVZ|64|altlinux|p6 20120321|altlinux-p6-20120321-x86_64.tar.gz|Altlinux p6 20120321 64bit (contrib)
0|OpenVZ|64|altlinux|p7 ovz generic 20140612|altlinux-p7-ovz-generic-20140612-x86_64.tar.xz|Altlinux p7 ovz generic 20140612 64bit (contrib)
0|OpenVZ|32|altlinux|p6 20120321|altlinux-p6-20120321-i586.tar.gz|Altlinux p6 20120321 32bit (contrib)
0|OpenVZ|32|altlinux|p7 ovz generic 20140612|altlinux-p7-ovz-generic-20140612-i586.tar.xz|Altlinux p7 ovz generic 20140612 32bit (contrib)
0|OpenVZ|64|arch|20140707|arch-20140707-x86_64.tar.xz|Arch 20140707 64bit (contrib)
0|OpenVZ|64|arch|20131014|arch-20131014-x86_64.tar.xz|Arch 20131014 64bit (contrib)
0|OpenVZ|64|arch|0.8 minimal|arch-0.8-x86_64-minimal.tar.gz|Arch 0.8 minimal 64bit (contrib)
0|OpenVZ|32|arch|0.8 minimal|arch-0.8-i686-minimal.tar.gz|Arch 0.8 minimal 32bit (contrib)
0|OpenVZ|64|cctel|6.2.18 default|cctel-6.2.18-x86_64-default.tar.gz|Cctel 6.2.18 default 64bit (contrib)
0|OpenVZ|64|centos|7|centos-7-x86_64.tar.gz|CentOS 7 64bit
0|OpenVZ|64|centos|7 minimal|centos-7-x86_64-minimal.tar.gz|CentOS 7 minimal 64bit
0|OpenVZ|64|centos|6|centos-6-x86_64.tar.gz|CentOS 6 64bit
0|OpenVZ|64|centos|6 devel|centos-6-x86_64-devel.tar.gz|CentOS 6 devel 64bit
0|OpenVZ|64|centos|6 minimal|centos-6-x86_64-minimal.tar.gz|CentOS 6 minimal 64bit
0|OpenVZ|32|centos|6|centos-6-x86.tar.gz|CentOS 6 32bit
0|OpenVZ|32|centos|6 devel|centos-6-x86-devel.tar.gz|CentOS 6 devel 32bit
0|OpenVZ|32|centos|6 minimal|centos-6-x86-minimal.tar.gz|CentOS 6 minimal 32bit
0|OpenVZ|64|centos|5|centos-5-x86_64.tar.gz|CentOS 5 64bit
0|OpenVZ|64|centos|5 devel|centos-5-x86_64-devel.tar.gz|CentOS 5 devel 64bit
0|OpenVZ|32|centos|5|centos-5-x86.tar.gz|CentOS 5 32bit
0|OpenVZ|32|centos|5 devel|centos-5-x86-devel.tar.gz|CentOS 5 devel 32bit
0|OpenVZ|64|centos|7 20141113|centos-7-x86_64-20141113.tar.xz|CentOS 7 20141113 64bit (contrib)
0|OpenVZ|64|centos|7 minimal 20141113|centos-7-x86_64-minimal-20141113.tar.xz|CentOS 7 minimal 20141113 64bit (contrib)
0|OpenVZ|64|centos|6 20141113|centos-6-x86_64-20141113.tar.xz|CentOS 6 20141113 64bit (contrib)
0|OpenVZ|64|centos|6 minimal 20141113|centos-6-x86_64-minimal-20141113.tar.xz|CentOS 6 minimal 20141113 64bit (contrib)
0|OpenVZ|32|centos|6 minimal 20141113|centos-6-x86-minimal-20141113.tar.xz|CentOS 6 minimal 20141113 32bit (contrib)
0|OpenVZ|32|centos|6 20141113|centos-6-x86-20141113.tar.xz|CentOS 6 20141113 32bit (contrib)
0|OpenVZ|64|centos|5 default|centos-5-x86_64-default.tar.gz|CentOS 5 default 64bit (contrib)
0|OpenVZ|64|centos|5 20141113|centos-5-x86_64-20141113.tar.xz|CentOS 5 20141113 64bit (contrib)
0|OpenVZ|64|centos|5 minimal|centos-5-x86_64-minimal.tar.gz|CentOS 5 minimal 64bit (contrib)
0|OpenVZ|64|centos|5 goautodial ce 2.1|centos-5-x86_64-goautodial-ce-2.1-openvz.tar.gz|CentOS 5 goautodial ce 2.1 64bit (contrib)
0|OpenVZ|32|centos|5 default|centos-5-i386-default.tar.gz|CentOS 5 default 32bit (contrib)
0|OpenVZ|32|centos|5 minimal|centos-5-i386-minimal.tar.gz|CentOS 5 minimal 32bit (contrib)
0|OpenVZ|32|centos|5 20141113|centos-5-x86-20141113.tar.xz|CentOS 5 20141113 32bit (contrib)
0|OpenVZ|64|centos|4 EOL|centos-4-x86_64-EOL.tar.xz|CentOS 4 EOL 64bit (contrib)
0|OpenVZ|32|centos|4 EOL|centos-4-x86-EOL.tar.xz|CentOS 4 EOL 32bit (contrib)
0|OpenVZ|64|cern|4 default|cern-4-x86_64-default.tar.gz|Cern 4 default 64bit (contrib)
0|OpenVZ|64|cern|4 minimal|cern-4-x86_64-minimal.tar.gz|Cern 4 minimal 64bit (contrib)
0|OpenVZ|32|cern|4 default|cern-4-i386-default.tar.gz|Cern 4 default 32bit (contrib)
0|OpenVZ|32|cern|4 minimal|cern-4-i386-minimal.tar.gz|Cern 4 minimal 32bit (contrib)
0|OpenVZ|64|debian|7.0 minimal|debian-7.0-x86_64-minimal.tar.gz|Debian 7.0 minimal 64bit
0|OpenVZ|32|debian|7.0|debian-7.0-x86.tar.gz|Debian 7.0 32bit
0|OpenVZ|32|debian|7.0 minimal|debian-7.0-x86-minimal.tar.gz|Debian 7.0 minimal 32bit
0|OpenVZ|64|debian|6.0|debian-6.0-x86_64.tar.gz|Debian 6.0 64bit
0|OpenVZ|64|debian|6.0 minimal|debian-6.0-x86_64-minimal.tar.gz|Debian 6.0 minimal 64bit
0|OpenVZ|32|debian|6.0|debian-6.0-x86.tar.gz|Debian 6.0 32bit
0|OpenVZ|32|debian|6.0 minimal|debian-6.0-x86-minimal.tar.gz|Debian 6.0 minimal 32bit
0|OpenVZ|64|debian|7.0|debian-7.0-x86_64.tar.gz|Debian 7.0 64bit (contrib)
0|OpenVZ|64|debian|7.0 minimal|debian-7.0-amd64-minimal.tar.gz|Debian 7.0 minimal 64bit (contrib)
0|OpenVZ|64|debian|7.0 envbox|debian-7.0-amd64-envbox.tar.xz|Debian 7.0 envbox 64bit (contrib)
0|OpenVZ|64|debian|7.0 minimal|debian-7.0-amd64-minimal.tar.xz|Debian 7.0 minimal 64bit (contrib)
0|OpenVZ|32|debian|7.0 minimal|debian-7.0-i386-minimal.tar.gz|Debian 7.0 minimal 32bit (contrib)
0|OpenVZ|32|debian|7.0 minimal|debian-7.0-i386-minimal.tar.xz|Debian 7.0 minimal 32bit (contrib)
0|OpenVZ|64|debian|6.0 minimal|debian-6.0-amd64-minimal.tar.gz|Debian 6.0 minimal 64bit (contrib)
0|OpenVZ|32|debian|6.0 minimal|debian-6.0-i386-minimal.tar.gz|Debian 6.0 minimal 32bit (contrib)
0|OpenVZ|64|debian|5.0 minimal|debian-5.0-amd64-minimal.tar.gz|Debian 5.0 minimal 64bit (contrib)
0|OpenVZ|32|debian|5.0 minimal|debian-5.0-i386-minimal.tar.gz|Debian 5.0 minimal 32bit (contrib)
0|OpenVZ|64|debian|4.0 minimal|debian-4.0-amd64-minimal.tar.gz|Debian 4.0 minimal 64bit (contrib)
0|OpenVZ|32|debian|4.0 proxmox mailgateway 2.0|debian-4.0-proxmox-mailgateway-2.0.tar.gz|Debian 4.0 proxmox mailgateway 2.0 32bit (contrib)
0|OpenVZ|32|debian|4.0 minimal|debian-4.0-i386-minimal.tar.gz|Debian 4.0 minimal 32bit (contrib)
0|OpenVZ|64|fedora|20|fedora-20-x86_64.tar.gz|Fedora 20 64bit
0|OpenVZ|32|fedora|20|fedora-20-x86.tar.gz|Fedora 20 32bit
0|OpenVZ|64|fedora|19|fedora-19-x86_64.tar.gz|Fedora 19 64bit
0|OpenVZ|32|fedora|19|fedora-19-x86.tar.gz|Fedora 19 32bit
0|OpenVZ|64|fedora|20 XFCE 20140909|fedora-20-x86_64-XFCE-20140909.tar.xz|Fedora 20 XFCE 20140909 64bit (contrib)
0|OpenVZ|64|fedora|20 20141113|fedora-20-x86_64-20141113.tar.xz|Fedora 20 20141113 64bit (contrib)
0|OpenVZ|64|fedora|20 minimal 20141113|fedora-20-x86_64-minimal-20141113.tar.xz|Fedora 20 minimal 20141113 64bit (contrib)
0|OpenVZ|32|fedora|20 minimal 20141113|fedora-20-x86-minimal-20141113.tar.xz|Fedora 20 minimal 20141113 32bit (contrib)
0|OpenVZ|32|fedora|20 20141113|fedora-20-x86-20141113.tar.xz|Fedora 20 20141113 32bit (contrib)
0|OpenVZ|64|fedora|19 20141113|fedora-19-x86_64-20141113.tar.xz|Fedora 19 20141113 64bit (contrib)
0|OpenVZ|32|fedora|19 20141113|fedora-19-x86-20141113.tar.xz|Fedora 19 20141113 32bit (contrib)
0|OpenVZ|64|fedora|18 EOL|fedora-18-x86_64-EOL.tar.xz|Fedora 18 EOL 64bit (contrib)
0|OpenVZ|32|fedora|18 EOL|fedora-18-x86-EOL.tar.xz|Fedora 18 EOL 32bit (contrib)
0|OpenVZ|64|fedora|17 EOL|fedora-17-x86_64-EOL.tar.xz|Fedora 17 EOL 64bit (contrib)
0|OpenVZ|32|fedora|17 EOL|fedora-17-x86-EOL.tar.xz|Fedora 17 EOL 32bit (contrib)
0|OpenVZ|64|fedora|16 EOL|fedora-16-x86_64-EOL.tar.xz|Fedora 16 EOL 64bit (contrib)
0|OpenVZ|32|fedora|16 EOL|fedora-16-x86-EOL.tar.xz|Fedora 16 EOL 32bit (contrib)
0|OpenVZ|64|fedora|15 EOL|fedora-15-x86_64-EOL.tar.xz|Fedora 15 EOL 64bit (contrib)
0|OpenVZ|32|fedora|15 EOL|fedora-15-x86-EOL.tar.xz|Fedora 15 EOL 32bit (contrib)
0|OpenVZ|64|fedora|14 EOL|fedora-14-x86_64-EOL.tar.xz|Fedora 14 EOL 64bit (contrib)
0|OpenVZ|32|fedora|14 EOL|fedora-14-x86-EOL.tar.xz|Fedora 14 EOL 32bit (contrib)
0|OpenVZ|64|fedora|13 default EOL|fedora-13-x86_64-default-EOL.tar.xz|Fedora 13 default EOL 64bit (contrib)
0|OpenVZ|32|fedora|13 default EOL|fedora-13-i386-default-EOL.tar.xz|Fedora 13 default EOL 32bit (contrib)
0|OpenVZ|64|fedora|12 default EOL|fedora-12-x86_64-default-EOL.tar.gz|Fedora 12 default EOL 64bit (contrib)
0|OpenVZ|32|fedora|12 default EOL|fedora-12-i386-default-EOL.tar.gz|Fedora 12 default EOL 32bit (contrib)
0|OpenVZ|64|fedora|11 default EOL|fedora-11-x86_64-default-EOL.tar.gz|Fedora 11 default EOL 64bit (contrib)
0|OpenVZ|32|fedora|11 default EOL|fedora-11-i386-default-EOL.tar.gz|Fedora 11 default EOL 32bit (contrib)
0|OpenVZ|64|fedora|10 default EOL|fedora-10-x86_64-default-EOL.tar.gz|Fedora 10 default EOL 64bit (contrib)
0|OpenVZ|32|fedora|10 default EOL|fedora-10-i386-default-EOL.tar.gz|Fedora 10 default EOL 32bit (contrib)
0|OpenVZ|64|fedora|9 default|fedora-9-x86_64-default.tar.gz|Fedora 9 default 64bit (contrib)
0|OpenVZ|64|fedora|9 default EOL|fedora-9-x86_64-default-EOL.tar.gz|Fedora 9 default EOL 64bit (contrib)
0|OpenVZ|64|fedora|9 minimal|fedora-9-x86_64-minimal.tar.gz|Fedora 9 minimal 64bit (contrib)
0|OpenVZ|32|fedora|9 default EOL|fedora-9-i386-default-EOL.tar.gz|Fedora 9 default EOL 32bit (contrib)
0|OpenVZ|32|fedora|9 default|fedora-9-i386-default.tar.gz|Fedora 9 default 32bit (contrib)
0|OpenVZ|32|fedora|9 minimal|fedora-9-i386-minimal.tar.gz|Fedora 9 minimal 32bit (contrib)
0|OpenVZ|64|fedora|8 default EOL|fedora-8-x86_64-default-EOL.tar.gz|Fedora 8 default EOL 64bit (contrib)
0|OpenVZ|32|fedora|8 default EOL|fedora-8-i386-default-EOL.tar.gz|Fedora 8 default EOL 32bit (contrib)
0|OpenVZ|32|fedora|core 7 default|fedora-core-7-i386-default.tar.gz|Fedora core 7 default 32bit (contrib)
0|OpenVZ|32|fedora|core 7 minimal|fedora-core-7-i386-minimal.tar.gz|Fedora core 7 minimal 32bit (contrib)
0|OpenVZ|32|funtoo|current generic_32 latest|funtoo-current-generic_32-openvz-latest.tar.xz|Funtoo current generic_32 latest 32bit (contrib)
0|OpenVZ|32|funtoo|current generic_64 latest|funtoo-current-generic_64-openvz-latest.tar.xz|Funtoo current generic_64 latest 32bit (contrib)
0|OpenVZ|64|gentoo|20071018|gentoo-amd64-20071018.tar.gz|Gentoo 20071018 64bit (contrib)
0|OpenVZ|64|gentoo|2008.11.27|gentoo-openvz-amd64-2008.11.27.tar.gz|Gentoo 2008.11.27 64bit (contrib)
0|OpenVZ|32|gentoo|2008.11.30|gentoo-openvz-x86-2008.11.30.tar.gz|Gentoo 2008.11.30 32bit (contrib)
0|OpenVZ|64|gentoo|stage3 20110520|gentoo-openvz-stage3-amd64-20110520.tar.gz|Gentoo stage3 20110520 64bit (contrib)
0|OpenVZ|32|opensuse|11.0 20081217|opensuse-11.0-i586-20081217.tar.gz|Opensuse 11.0 20081217 32bit (contrib)
0|OpenVZ|32|opensuse|10.1|opensuse-10.1-i386.tar.gz|Opensuse 10.1 32bit (contrib)
0|OpenVZ|64|oracle|7 minimal 20141113|oracle-7-x86_64-minimal-20141113.tar.xz|Oracle 7 minimal 20141113 64bit (contrib)
0|OpenVZ|64|oracle|7 20141113|oracle-7-x86_64-20141113.tar.xz|Oracle 7 20141113 64bit (contrib)
0|OpenVZ|64|oracle|6 minimal 20141113|oracle-6-x86_64-minimal-20141113.tar.xz|Oracle 6 minimal 20141113 64bit (contrib)
0|OpenVZ|64|oracle|6 20141113|oracle-6-x86_64-20141113.tar.xz|Oracle 6 20141113 64bit (contrib)
0|OpenVZ|32|oracle|6 minimal 20141113|oracle-6-x86-minimal-20141113.tar.xz|Oracle 6 minimal 20141113 32bit (contrib)
0|OpenVZ|32|oracle|6 20141113|oracle-6-x86-20141113.tar.xz|Oracle 6 20141113 32bit (contrib)
0|OpenVZ|64|owl|3.0 release|owl-3.0-release-x86_64.tar.gz|Owl 3.0 release 64bit (contrib)
0|OpenVZ|32|owl|3.0 release|owl-3.0-release-i686.tar.gz|Owl 3.0 release 32bit (contrib)
0|OpenVZ|64|scientific|6|scientific-6-x86_64.tar.gz|Scientific 6 64bit
0|OpenVZ|32|scientific|6|scientific-6-x86.tar.gz|Scientific 6 32bit
0|OpenVZ|64|scientific|7 minimal 20141118|scientific-7-x86_64-minimal-20141118.tar.xz|Scientific 7 minimal 20141118 64bit (contrib)
0|OpenVZ|64|scientific|7 20141118|scientific-7-x86_64-20141118.tar.xz|Scientific 7 20141118 64bit (contrib)
0|OpenVZ|64|scientific|6 minimal 20141113|scientific-6-x86_64-minimal-20141113.tar.xz|Scientific 6 minimal 20141113 64bit (contrib)
0|OpenVZ|64|scientific|6 20141113|scientific-6-x86_64-20141113.tar.xz|Scientific 6 20141113 64bit (contrib)
0|OpenVZ|32|scientific|6 minimal 20141113|scientific-6-x86-minimal-20141113.tar.xz|Scientific 6 minimal 20141113 32bit (contrib)
0|OpenVZ|32|scientific|6 20141113|scientific-6-x86-20141113.tar.xz|Scientific 6 20141113 32bit (contrib)
0|OpenVZ|64|scientific|5 20141113|scientific-5-x86_64-20141113.tar.xz|Scientific 5 20141113 64bit (contrib)
0|OpenVZ|32|scientific|5 20141113|scientific-5-x86-20141113.tar.xz|Scientific 5 20141113 32bit (contrib)
0|OpenVZ|64|scientific|4 EOL|scientific-4-x86_64-EOL.tar.xz|Scientific 4 EOL 64bit (contrib)
0|OpenVZ|32|scientific|4 EOL|scientific-4-x86-EOL.tar.xz|Scientific 4 EOL 32bit (contrib)
0|OpenVZ|64|slackware|13.37 minimal|slackware-13.37-x86_64-minimal.tar.gz|Slackware 13.37 minimal 64bit (contrib)
0|OpenVZ|32|slackware|13.37 i486 minimal|slackware-13.37-i486-minimal.tar.gz|Slackware 13.37 i486 minimal 32bit (contrib)
0|OpenVZ|32|slackware|13.1 minimal|slackware-13.1-i386-minimal.tar.gz|Slackware 13.1 minimal 32bit (contrib)
0|OpenVZ|32|slackware|12.0 minimal|slackware-12.0-i386-minimal.tar.gz|Slackware 12.0 minimal 32bit (contrib)
0|OpenVZ|32|slackware|11.0 minimal|slackware-11.0-i386-minimal.tar.gz|Slackware 11.0 minimal 32bit (contrib)
0|OpenVZ|32|slackware|10.2 minimal|slackware-10.2-i386-minimal.tar.gz|Slackware 10.2 minimal 32bit (contrib)
0|OpenVZ|32|sles|10.2 minimal|sles-10.2-i586-minimal.tar.gz|Sles 10.2 minimal 32bit (contrib)
0|OpenVZ|64|suse|13.1|suse-13.1-x86_64.tar.gz|SuSe 13.1 64bit
0|OpenVZ|64|suse|13.1 minimal|suse-13.1-x86_64-minimal.tar.gz|SuSe 13.1 minimal 64bit
0|OpenVZ|32|suse|13.1 minimal|suse-13.1-x86-minimal.tar.gz|SuSe 13.1 minimal 32bit
0|OpenVZ|32|suse|13.1|suse-13.1-x86.tar.gz|SuSe 13.1 32bit
0|OpenVZ|64|suse|12.3|suse-12.3-x86_64.tar.gz|SuSe 12.3 64bit
0|OpenVZ|32|suse|12.3|suse-12.3-x86.tar.gz|SuSe 12.3 32bit
0|OpenVZ|64|suse|9.3|suse-9.3-x86_64.tar.gz|SuSe 9.3 64bit (contrib)
0|OpenVZ|64|ubuntu|14.04|ubuntu-14.04-x86_64.tar.gz|Ubuntu 14.04 64bit
0|OpenVZ|64|ubuntu|14.04 minimal|ubuntu-14.04-x86_64-minimal.tar.gz|Ubuntu 14.04 minimal 64bit
0|OpenVZ|32|ubuntu|14.04|ubuntu-14.04-x86.tar.gz|Ubuntu 14.04 32bit
0|OpenVZ|32|ubuntu|14.04 minimal|ubuntu-14.04-x86-minimal.tar.gz|Ubuntu 14.04 minimal 32bit
0|OpenVZ|64|ubuntu|12.04|ubuntu-12.04-x86_64.tar.gz|Ubuntu 12.04 64bit
0|OpenVZ|64|ubuntu|12.04 minimal|ubuntu-12.04-x86_64-minimal.tar.gz|Ubuntu 12.04 minimal 64bit
0|OpenVZ|32|ubuntu|12.04|ubuntu-12.04-x86.tar.gz|Ubuntu 12.04 32bit
0|OpenVZ|32|ubuntu|12.04 minimal|ubuntu-12.04-x86-minimal.tar.gz|Ubuntu 12.04 minimal 32bit
0|OpenVZ|64|ubuntu|10.04|ubuntu-10.04-x86_64.tar.gz|Ubuntu 10.04 64bit
0|OpenVZ|32|ubuntu|10.04|ubuntu-10.04-x86.tar.gz|Ubuntu 10.04 32bit
0|OpenVZ|32|ubuntu|10.04 minimal|ubuntu-10.04-minimal_10.04_i386.tar.gz|Ubuntu 10.04 minimal 32bit (contrib)
0|OpenVZ|32|ubuntu|10.04 minimal|ubuntu-10.04-minimal_10.04_amd64.tar.gz|Ubuntu 10.04 minimal 32bit (contrib)
0|OpenVZ|32|ubuntu|10.04 lamp|ubuntu-10.04-lamp_10.04_i386.tar.gz|Ubuntu 10.04 lamp 32bit (contrib)
0|OpenVZ|32|ubuntu|10.04 lamp|ubuntu-10.04-lamp_10.04_amd64.tar.gz|Ubuntu 10.04 lamp 32bit (contrib)
0|OpenVZ|32|ubuntu|9.04 minimal|ubuntu-9.04-i386-minimal.tar.gz|Ubuntu 9.04 minimal 32bit (contrib)
0|OpenVZ|32|ubuntu|8.04.2 minimal|ubuntu-8.04.2-i386-minimal.tar.gz|Ubuntu 8.04.2 minimal 32bit (contrib)
0|OpenVZ|32|ubuntu|7.10 minimal|ubuntu-7.10-i386-minimal.tar.gz|Ubuntu 7.10 minimal 32bit (contrib)
0|OpenVZ|32|ubuntu|6.06 minimal|ubuntu-6.06-i386-minimal.tar.gz|Ubuntu 6.06 minimal 32bit (contrib)
1|KVM Windows|64|windows|2012|windows2012|Windows 2012 64bit
1|KVM Windows|64|windows|2008 r2|windowsr2|Windows 2008 r2 64bit
1|KVM Windows|32|windows|2008 r2|windows2|Windows 2008 r2 32bit
2|KVM Linux|64|centos|7|centos55|CentOS 7 64bit
2|KVM Linux|64|centos|6|centos5|CentOS 6 64bit
2|KVM Linux|64|debian|7|debian6|Debian 7 64bit
2|KVM Linux|64|freepbx|5.8|freepbx|FreePBX 5.8 64bit
2|KVM Linux|64|ubuntu|14.04|ubuntu10|Ubuntu 14.04 64bit
2|KVM Linux|64|ubuntu|14.04 Desktop|ubuntudesktop|Ubuntu 14.04 Desktop 64bit
2|KVM Linux|64|ubuntu|12.04|ubuntu12|Ubuntu 12.04 64bit
2|KVM Linux|64|ubuntu|10.04|ubuntu10|Ubuntu 10.04 64bit
5|SSD OpenVZ|64|altlinux|5.1|altlinux-5.1-x86_64.tar.gz|Altlinux 5.1 64bit (contrib)
5|SSD OpenVZ|32|altlinux|5.1|altlinux-5.1-i586.tar.gz|Altlinux 5.1 32bit (contrib)
5|SSD OpenVZ|64|altlinux|p6 20120321|altlinux-p6-20120321-x86_64.tar.gz|Altlinux p6 20120321 64bit (contrib)
5|SSD OpenVZ|64|altlinux|p7 ovz generic 20140612|altlinux-p7-ovz-generic-20140612-x86_64.tar.xz|Altlinux p7 ovz generic 20140612 64bit (contrib)
5|SSD OpenVZ|32|altlinux|p6 20120321|altlinux-p6-20120321-i586.tar.gz|Altlinux p6 20120321 32bit (contrib)
5|SSD OpenVZ|32|altlinux|p7 ovz generic 20140612|altlinux-p7-ovz-generic-20140612-i586.tar.xz|Altlinux p7 ovz generic 20140612 32bit (contrib)
5|SSD OpenVZ|64|arch|20140707|arch-20140707-x86_64.tar.xz|Arch 20140707 64bit (contrib)
5|SSD OpenVZ|64|arch|20131014|arch-20131014-x86_64.tar.xz|Arch 20131014 64bit (contrib)
5|SSD OpenVZ|64|arch|0.8 minimal|arch-0.8-x86_64-minimal.tar.gz|Arch 0.8 minimal 64bit (contrib)
5|SSD OpenVZ|32|arch|0.8 minimal|arch-0.8-i686-minimal.tar.gz|Arch 0.8 minimal 32bit (contrib)
5|SSD OpenVZ|64|cctel|6.2.18 default|cctel-6.2.18-x86_64-default.tar.gz|Cctel 6.2.18 default 64bit (contrib)
5|SSD OpenVZ|64|centos|7|centos-7-x86_64.tar.gz|CentOS 7 64bit
5|SSD OpenVZ|64|centos|7 minimal|centos-7-x86_64-minimal.tar.gz|CentOS 7 minimal 64bit
5|SSD OpenVZ|64|centos|6 devel|centos-6-x86_64-devel.tar.gz|CentOS 6 devel 64bit
5|SSD OpenVZ|64|centos|6|centos-6-x86_64.tar.gz|CentOS 6 64bit
5|SSD OpenVZ|64|centos|6 minimal|centos-6-x86_64-minimal.tar.gz|CentOS 6 minimal 64bit
5|SSD OpenVZ|32|centos|6 devel|centos-6-x86-devel.tar.gz|CentOS 6 devel 32bit
5|SSD OpenVZ|32|centos|6|centos-6-x86.tar.gz|CentOS 6 32bit
5|SSD OpenVZ|32|centos|6 minimal|centos-6-x86-minimal.tar.gz|CentOS 6 minimal 32bit
5|SSD OpenVZ|64|centos|5 devel|centos-5-x86_64-devel.tar.gz|CentOS 5 devel 64bit
5|SSD OpenVZ|64|centos|5|centos-5-x86_64.tar.gz|CentOS 5 64bit
5|SSD OpenVZ|32|centos|5 devel|centos-5-x86-devel.tar.gz|CentOS 5 devel 32bit
5|SSD OpenVZ|32|centos|5|centos-5-x86.tar.gz|CentOS 5 32bit
5|SSD OpenVZ|64|centos|7 20141113|centos-7-x86_64-20141113.tar.xz|CentOS 7 20141113 64bit (contrib)
5|SSD OpenVZ|64|centos|7 minimal 20141113|centos-7-x86_64-minimal-20141113.tar.xz|CentOS 7 minimal 20141113 64bit (contrib)
5|SSD OpenVZ|64|centos|6 minimal 20141113|centos-6-x86_64-minimal-20141113.tar.xz|CentOS 6 minimal 20141113 64bit (contrib)
5|SSD OpenVZ|64|centos|6 20141113|centos-6-x86_64-20141113.tar.xz|CentOS 6 20141113 64bit (contrib)
5|SSD OpenVZ|32|centos|6 minimal 20141113|centos-6-x86-minimal-20141113.tar.xz|CentOS 6 minimal 20141113 32bit (contrib)
5|SSD OpenVZ|32|centos|6 20141113|centos-6-x86-20141113.tar.xz|CentOS 6 20141113 32bit (contrib)
5|SSD OpenVZ|64|centos|5 default|centos-5-x86_64-default.tar.gz|CentOS 5 default 64bit (contrib)
5|SSD OpenVZ|64|centos|5 20141113|centos-5-x86_64-20141113.tar.xz|CentOS 5 20141113 64bit (contrib)
5|SSD OpenVZ|64|centos|5 minimal|centos-5-x86_64-minimal.tar.gz|CentOS 5 minimal 64bit (contrib)
5|SSD OpenVZ|64|centos|5 goautodial ce 2.1|centos-5-x86_64-goautodial-ce-2.1-openvz.tar.gz|CentOS 5 goautodial ce 2.1 64bit (contrib)
5|SSD OpenVZ|32|centos|5 default|centos-5-i386-default.tar.gz|CentOS 5 default 32bit (contrib)
5|SSD OpenVZ|32|centos|5 20141113|centos-5-x86-20141113.tar.xz|CentOS 5 20141113 32bit (contrib)
5|SSD OpenVZ|32|centos|5 minimal|centos-5-i386-minimal.tar.gz|CentOS 5 minimal 32bit (contrib)
5|SSD OpenVZ|64|centos|4 EOL|centos-4-x86_64-EOL.tar.xz|CentOS 4 EOL 64bit (contrib)
5|SSD OpenVZ|32|centos|4 EOL|centos-4-x86-EOL.tar.xz|CentOS 4 EOL 32bit (contrib)
5|SSD OpenVZ|64|cern|4 default|cern-4-x86_64-default.tar.gz|Cern 4 default 64bit (contrib)
5|SSD OpenVZ|64|cern|4 minimal|cern-4-x86_64-minimal.tar.gz|Cern 4 minimal 64bit (contrib)
5|SSD OpenVZ|32|cern|4 default|cern-4-i386-default.tar.gz|Cern 4 default 32bit (contrib)
5|SSD OpenVZ|32|cern|4 minimal|cern-4-i386-minimal.tar.gz|Cern 4 minimal 32bit (contrib)
5|SSD OpenVZ|64|debian|7.0 minimal|debian-7.0-x86_64-minimal.tar.gz|Debian 7.0 minimal 64bit
5|SSD OpenVZ|32|debian|7.0|debian-7.0-x86.tar.gz|Debian 7.0 32bit
5|SSD OpenVZ|32|debian|7.0 minimal|debian-7.0-x86-minimal.tar.gz|Debian 7.0 minimal 32bit
5|SSD OpenVZ|64|debian|6.0|debian-6.0-x86_64.tar.gz|Debian 6.0 64bit
5|SSD OpenVZ|64|debian|6.0 minimal|debian-6.0-x86_64-minimal.tar.gz|Debian 6.0 minimal 64bit
5|SSD OpenVZ|32|debian|6.0|debian-6.0-x86.tar.gz|Debian 6.0 32bit
5|SSD OpenVZ|32|debian|6.0 minimal|debian-6.0-x86-minimal.tar.gz|Debian 6.0 minimal 32bit
5|SSD OpenVZ|64|debian|7.0|debian-7.0-x86_64.tar.gz|Debian 7.0 64bit (contrib)
5|SSD OpenVZ|64|debian|7.0 minimal|debian-7.0-amd64-minimal.tar.gz|Debian 7.0 minimal 64bit (contrib)
5|SSD OpenVZ|64|debian|7.0 envbox|debian-7.0-amd64-envbox.tar.xz|Debian 7.0 envbox 64bit (contrib)
5|SSD OpenVZ|64|debian|7.0 minimal|debian-7.0-amd64-minimal.tar.xz|Debian 7.0 minimal 64bit (contrib)
5|SSD OpenVZ|32|debian|7.0 minimal|debian-7.0-i386-minimal.tar.gz|Debian 7.0 minimal 32bit (contrib)
5|SSD OpenVZ|32|debian|7.0 minimal|debian-7.0-i386-minimal.tar.xz|Debian 7.0 minimal 32bit (contrib)
5|SSD OpenVZ|64|debian|6.0 minimal|debian-6.0-amd64-minimal.tar.gz|Debian 6.0 minimal 64bit (contrib)
5|SSD OpenVZ|32|debian|6.0 minimal|debian-6.0-i386-minimal.tar.gz|Debian 6.0 minimal 32bit (contrib)
5|SSD OpenVZ|64|debian|5.0 minimal|debian-5.0-amd64-minimal.tar.gz|Debian 5.0 minimal 64bit (contrib)
5|SSD OpenVZ|32|debian|5.0 minimal|debian-5.0-i386-minimal.tar.gz|Debian 5.0 minimal 32bit (contrib)
5|SSD OpenVZ|64|debian|4.0 minimal|debian-4.0-amd64-minimal.tar.gz|Debian 4.0 minimal 64bit (contrib)
5|SSD OpenVZ|32|debian|4.0 minimal|debian-4.0-i386-minimal.tar.gz|Debian 4.0 minimal 32bit (contrib)
5|SSD OpenVZ|32|debian|4.0 proxmox mailgateway 2.0|debian-4.0-proxmox-mailgateway-2.0.tar.gz|Debian 4.0 proxmox mailgateway 2.0 32bit (contrib)
5|SSD OpenVZ|64|fedora|20|fedora-20-x86_64.tar.gz|Fedora 20 64bit
5|SSD OpenVZ|32|fedora|20|fedora-20-x86.tar.gz|Fedora 20 32bit
5|SSD OpenVZ|64|fedora|19|fedora-19-x86_64.tar.gz|Fedora 19 64bit
5|SSD OpenVZ|32|fedora|19|fedora-19-x86.tar.gz|Fedora 19 32bit
5|SSD OpenVZ|64|fedora|20 XFCE 20140909|fedora-20-x86_64-XFCE-20140909.tar.xz|Fedora 20 XFCE 20140909 64bit (contrib)
5|SSD OpenVZ|64|fedora|20 20141113|fedora-20-x86_64-20141113.tar.xz|Fedora 20 20141113 64bit (contrib)
5|SSD OpenVZ|64|fedora|20 minimal 20141113|fedora-20-x86_64-minimal-20141113.tar.xz|Fedora 20 minimal 20141113 64bit (contrib)
5|SSD OpenVZ|32|fedora|20 minimal 20141113|fedora-20-x86-minimal-20141113.tar.xz|Fedora 20 minimal 20141113 32bit (contrib)
5|SSD OpenVZ|32|fedora|20 20141113|fedora-20-x86-20141113.tar.xz|Fedora 20 20141113 32bit (contrib)
5|SSD OpenVZ|64|fedora|19 20141113|fedora-19-x86_64-20141113.tar.xz|Fedora 19 20141113 64bit (contrib)
5|SSD OpenVZ|32|fedora|19 20141113|fedora-19-x86-20141113.tar.xz|Fedora 19 20141113 32bit (contrib)
5|SSD OpenVZ|64|fedora|18 EOL|fedora-18-x86_64-EOL.tar.xz|Fedora 18 EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|18 EOL|fedora-18-x86-EOL.tar.xz|Fedora 18 EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|17 EOL|fedora-17-x86_64-EOL.tar.xz|Fedora 17 EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|17 EOL|fedora-17-x86-EOL.tar.xz|Fedora 17 EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|16 EOL|fedora-16-x86_64-EOL.tar.xz|Fedora 16 EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|16 EOL|fedora-16-x86-EOL.tar.xz|Fedora 16 EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|15 EOL|fedora-15-x86_64-EOL.tar.xz|Fedora 15 EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|15 EOL|fedora-15-x86-EOL.tar.xz|Fedora 15 EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|14 EOL|fedora-14-x86_64-EOL.tar.xz|Fedora 14 EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|14 EOL|fedora-14-x86-EOL.tar.xz|Fedora 14 EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|13 default EOL|fedora-13-x86_64-default-EOL.tar.xz|Fedora 13 default EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|13 default EOL|fedora-13-i386-default-EOL.tar.xz|Fedora 13 default EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|12 default EOL|fedora-12-x86_64-default-EOL.tar.gz|Fedora 12 default EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|12 default EOL|fedora-12-i386-default-EOL.tar.gz|Fedora 12 default EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|11 default EOL|fedora-11-x86_64-default-EOL.tar.gz|Fedora 11 default EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|11 default EOL|fedora-11-i386-default-EOL.tar.gz|Fedora 11 default EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|10 default EOL|fedora-10-x86_64-default-EOL.tar.gz|Fedora 10 default EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|10 default EOL|fedora-10-i386-default-EOL.tar.gz|Fedora 10 default EOL 32bit (contrib)
5|SSD OpenVZ|64|fedora|9 default EOL|fedora-9-x86_64-default-EOL.tar.gz|Fedora 9 default EOL 64bit (contrib)
5|SSD OpenVZ|64|fedora|9 default|fedora-9-x86_64-default.tar.gz|Fedora 9 default 64bit (contrib)
5|SSD OpenVZ|64|fedora|9 minimal|fedora-9-x86_64-minimal.tar.gz|Fedora 9 minimal 64bit (contrib)
5|SSD OpenVZ|32|fedora|9 default EOL|fedora-9-i386-default-EOL.tar.gz|Fedora 9 default EOL 32bit (contrib)
5|SSD OpenVZ|32|fedora|9 default|fedora-9-i386-default.tar.gz|Fedora 9 default 32bit (contrib)
5|SSD OpenVZ|32|fedora|9 minimal|fedora-9-i386-minimal.tar.gz|Fedora 9 minimal 32bit (contrib)
5|SSD OpenVZ|64|fedora|8 default EOL|fedora-8-x86_64-default-EOL.tar.gz|Fedora 8 default EOL 64bit (contrib)
5|SSD OpenVZ|32|fedora|8 default EOL|fedora-8-i386-default-EOL.tar.gz|Fedora 8 default EOL 32bit (contrib)
5|SSD OpenVZ|32|fedora|core 7 default|fedora-core-7-i386-default.tar.gz|Fedora core 7 default 32bit (contrib)
5|SSD OpenVZ|32|fedora|core 7 minimal|fedora-core-7-i386-minimal.tar.gz|Fedora core 7 minimal 32bit (contrib)
5|SSD OpenVZ|32|funtoo|current generic_32 latest|funtoo-current-generic_32-openvz-latest.tar.xz|Funtoo current generic_32 latest 32bit (contrib)
5|SSD OpenVZ|32|funtoo|current generic_64 latest|funtoo-current-generic_64-openvz-latest.tar.xz|Funtoo current generic_64 latest 32bit (contrib)
5|SSD OpenVZ|64|gentoo|20071018|gentoo-amd64-20071018.tar.gz|Gentoo 20071018 64bit (contrib)
5|SSD OpenVZ|64|gentoo|2008.11.27|gentoo-openvz-amd64-2008.11.27.tar.gz|Gentoo 2008.11.27 64bit (contrib)
5|SSD OpenVZ|32|gentoo|2008.11.30|gentoo-openvz-x86-2008.11.30.tar.gz|Gentoo 2008.11.30 32bit (contrib)
5|SSD OpenVZ|64|gentoo|stage3 20110520|gentoo-openvz-stage3-amd64-20110520.tar.gz|Gentoo stage3 20110520 64bit (contrib)
5|SSD OpenVZ|32|opensuse|11.0 20081217|opensuse-11.0-i586-20081217.tar.gz|Opensuse 11.0 20081217 32bit (contrib)
5|SSD OpenVZ|32|opensuse|10.1|opensuse-10.1-i386.tar.gz|Opensuse 10.1 32bit (contrib)
5|SSD OpenVZ|64|oracle|7 20141113|oracle-7-x86_64-20141113.tar.xz|Oracle 7 20141113 64bit (contrib)
5|SSD OpenVZ|64|oracle|7 minimal 20141113|oracle-7-x86_64-minimal-20141113.tar.xz|Oracle 7 minimal 20141113 64bit (contrib)
5|SSD OpenVZ|64|oracle|6 20141113|oracle-6-x86_64-20141113.tar.xz|Oracle 6 20141113 64bit (contrib)
5|SSD OpenVZ|64|oracle|6 minimal 20141113|oracle-6-x86_64-minimal-20141113.tar.xz|Oracle 6 minimal 20141113 64bit (contrib)
5|SSD OpenVZ|32|oracle|6 minimal 20141113|oracle-6-x86-minimal-20141113.tar.xz|Oracle 6 minimal 20141113 32bit (contrib)
5|SSD OpenVZ|32|oracle|6 20141113|oracle-6-x86-20141113.tar.xz|Oracle 6 20141113 32bit (contrib)
5|SSD OpenVZ|64|owl|3.0 release|owl-3.0-release-x86_64.tar.gz|Owl 3.0 release 64bit (contrib)
5|SSD OpenVZ|32|owl|3.0 release|owl-3.0-release-i686.tar.gz|Owl 3.0 release 32bit (contrib)
5|SSD OpenVZ|64|scientific|6|scientific-6-x86_64.tar.gz|Scientific 6 64bit
5|SSD OpenVZ|32|scientific|6|scientific-6-x86.tar.gz|Scientific 6 32bit
5|SSD OpenVZ|64|scientific|7 minimal 20141118|scientific-7-x86_64-minimal-20141118.tar.xz|Scientific 7 minimal 20141118 64bit (contrib)
5|SSD OpenVZ|64|scientific|7 20141118|scientific-7-x86_64-20141118.tar.xz|Scientific 7 20141118 64bit (contrib)
5|SSD OpenVZ|64|scientific|6 minimal 20141113|scientific-6-x86_64-minimal-20141113.tar.xz|Scientific 6 minimal 20141113 64bit (contrib)
5|SSD OpenVZ|64|scientific|6 20141113|scientific-6-x86_64-20141113.tar.xz|Scientific 6 20141113 64bit (contrib)
5|SSD OpenVZ|32|scientific|6 minimal 20141113|scientific-6-x86-minimal-20141113.tar.xz|Scientific 6 minimal 20141113 32bit (contrib)
5|SSD OpenVZ|32|scientific|6 20141113|scientific-6-x86-20141113.tar.xz|Scientific 6 20141113 32bit (contrib)
5|SSD OpenVZ|64|scientific|5 20141113|scientific-5-x86_64-20141113.tar.xz|Scientific 5 20141113 64bit (contrib)
5|SSD OpenVZ|32|scientific|5 20141113|scientific-5-x86-20141113.tar.xz|Scientific 5 20141113 32bit (contrib)
5|SSD OpenVZ|64|scientific|4 EOL|scientific-4-x86_64-EOL.tar.xz|Scientific 4 EOL 64bit (contrib)
5|SSD OpenVZ|32|scientific|4 EOL|scientific-4-x86-EOL.tar.xz|Scientific 4 EOL 32bit (contrib)
5|SSD OpenVZ|64|slackware|13.37 minimal|slackware-13.37-x86_64-minimal.tar.gz|Slackware 13.37 minimal 64bit (contrib)
5|SSD OpenVZ|32|slackware|13.37 i486 minimal|slackware-13.37-i486-minimal.tar.gz|Slackware 13.37 i486 minimal 32bit (contrib)
5|SSD OpenVZ|32|slackware|13.1 minimal|slackware-13.1-i386-minimal.tar.gz|Slackware 13.1 minimal 32bit (contrib)
5|SSD OpenVZ|32|slackware|12.0 minimal|slackware-12.0-i386-minimal.tar.gz|Slackware 12.0 minimal 32bit (contrib)
5|SSD OpenVZ|32|slackware|11.0 minimal|slackware-11.0-i386-minimal.tar.gz|Slackware 11.0 minimal 32bit (contrib)
5|SSD OpenVZ|32|slackware|10.2 minimal|slackware-10.2-i386-minimal.tar.gz|Slackware 10.2 minimal 32bit (contrib)
5|SSD OpenVZ|32|sles|10.2 minimal|sles-10.2-i586-minimal.tar.gz|Sles 10.2 minimal 32bit (contrib)
5|SSD OpenVZ|64|suse|13.1|suse-13.1-x86_64.tar.gz|SuSe 13.1 64bit
5|SSD OpenVZ|64|suse|13.1 minimal|suse-13.1-x86_64-minimal.tar.gz|SuSe 13.1 minimal 64bit
5|SSD OpenVZ|32|suse|13.1 minimal|suse-13.1-x86-minimal.tar.gz|SuSe 13.1 minimal 32bit
5|SSD OpenVZ|32|suse|13.1|suse-13.1-x86.tar.gz|SuSe 13.1 32bit
5|SSD OpenVZ|64|suse|12.3|suse-12.3-x86_64.tar.gz|SuSe 12.3 64bit
5|SSD OpenVZ|32|suse|12.3|suse-12.3-x86.tar.gz|SuSe 12.3 32bit
5|SSD OpenVZ|64|suse|9.3|suse-9.3-x86_64.tar.gz|SuSe 9.3 64bit (contrib)
5|SSD OpenVZ|64|ubuntu|14.04|ubuntu-14.04-x86_64.tar.gz|Ubuntu 14.04 64bit
5|SSD OpenVZ|64|ubuntu|14.04 minimal|ubuntu-14.04-x86_64-minimal.tar.gz|Ubuntu 14.04 minimal 64bit
5|SSD OpenVZ|32|ubuntu|14.04|ubuntu-14.04-x86.tar.gz|Ubuntu 14.04 32bit
5|SSD OpenVZ|32|ubuntu|14.04 minimal|ubuntu-14.04-x86-minimal.tar.gz|Ubuntu 14.04 minimal 32bit
5|SSD OpenVZ|64|ubuntu|12.04|ubuntu-12.04-x86_64.tar.gz|Ubuntu 12.04 64bit
5|SSD OpenVZ|64|ubuntu|12.04 minimal|ubuntu-12.04-x86_64-minimal.tar.gz|Ubuntu 12.04 minimal 64bit
5|SSD OpenVZ|32|ubuntu|12.04|ubuntu-12.04-x86.tar.gz|Ubuntu 12.04 32bit
5|SSD OpenVZ|32|ubuntu|12.04 minimal|ubuntu-12.04-x86-minimal.tar.gz|Ubuntu 12.04 minimal 32bit
5|SSD OpenVZ|64|ubuntu|10.04|ubuntu-10.04-x86_64.tar.gz|Ubuntu 10.04 64bit
5|SSD OpenVZ|32|ubuntu|10.04|ubuntu-10.04-x86.tar.gz|Ubuntu 10.04 32bit
5|SSD OpenVZ|32|ubuntu|10.04 lamp|ubuntu-10.04-lamp_10.04_amd64.tar.gz|Ubuntu 10.04 lamp 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|10.04 lamp|ubuntu-10.04-lamp_10.04_i386.tar.gz|Ubuntu 10.04 lamp 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|10.04 minimal|ubuntu-10.04-minimal_10.04_amd64.tar.gz|Ubuntu 10.04 minimal 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|10.04 minimal|ubuntu-10.04-minimal_10.04_i386.tar.gz|Ubuntu 10.04 minimal 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|9.04 minimal|ubuntu-9.04-i386-minimal.tar.gz|Ubuntu 9.04 minimal 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|8.04.2 minimal|ubuntu-8.04.2-i386-minimal.tar.gz|Ubuntu 8.04.2 minimal 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|7.10 minimal|ubuntu-7.10-i386-minimal.tar.gz|Ubuntu 7.10 minimal 32bit (contrib)
5|SSD OpenVZ|32|ubuntu|6.06 minimal|ubuntu-6.06-i386-minimal.tar.gz|Ubuntu 6.06 minimal 32bit (contrib)
9|LXC|64|ubuntu|14.04|ubuntu-trusty-amd64|Ubuntu 14.04 64bit
9|LXC|32|ubuntu|14.04|ubuntu-trusty-i3864|Ubuntu 14.04 32bit

## Feedback and Suggestions

If you have any questions or ideas on how we can improve our services, please let us know at support@interserver.net,
