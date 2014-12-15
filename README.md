
# InterServer VPS SOAP API Documentation

Integrating VPS Setup and Operation into 3<sup>rd</sup> Party Sites and Software



- - -

_ _ _

_ _ _

_ _ _

_ _ _

Version 1.0 – December 14, 2014 - ©2014 InterServer


* * *


## Connecting To the API

### Prerequisites and API URLs

To use the API you will need to first have an account with us.  You can sign up for an account at [http://my.interserver.net/](http://my.interserver.net/)

* You will need the login name (email address) you used to sign up with InterServer and your password.
* The SOAP server is accessible at [https://my.interserver.net/api.php](https://my.interserver.net/api.php)
* The WSDL is available at [https://my.interserver.net/api.php?wsdl](https://my.interserver.net/api.php?wsdl)

### Authentication

* We use a session based authentication system.   You will need to authenticate yourself with our system to get a Session ID.   Once you have a Session ID, you just pass that to prove your identity.  

* To get a Session ID, you need to make a SOAP call to api_login(\$login, \$password)  using the information you use to login to [https://my.interserver.net](https://my.interserver.net)

* Sending an api_login(\$login, \$password) call will attempt to authenticate your account and if successful will return a Session ID valid for at least several hours.    Subsequent commands and calls to the API will need this Session ID, so keep it handy.

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
    -> hi()                                                    
    -> result;
```

#### Python
```python
from pysimplesoap.client import SoapClient
client = SoapClient(wsdl="http://127.0.0.1:8000/webservices/sample/call/soap?WSDL",trace=False)
response = client.AddIntegers(a=1,b=2)
result = response['AddResult']
print result
```

* * *

## Available VPS Server Types and Pricing

We have several types of Servers available for use with VPS Hosting. You can get a list of the types available and there cost per slice/unit by making a call to the **get_vps_slice_types**  function.


### Input Parameters for API get_vps_slice_types
<table>
<col width="50%" />
<col width="50%" />
<tbody>
<tr class="odd">
<td align="left"><p><strong>Parameter</strong></p></td>
<td align="left"><p><strong>Description</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p>None</p></td>
<td align="left"><p>None</p></td>
</tr>
</tbody>
</table>


### Output Fields for API get_vps_slice_types
<table>
<col width="50%" />
<col width="50%" />
<tbody>
<tr class="odd">
<td align="left"><p><strong>Field Name</strong></p></td>
<td align="left"><p><strong>Description</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p>name</p></td>
<td align="left"><p>This field contains a text description of the package/service</p></td>
</tr>
<tr class="odd">
<td align="left"><p>type</p></td>
<td align="left"><p>Use to match up what OS Image templates are available for this VPS type.</p></td>
</tr>
<tr class="even">
<td align="left"><p>cost</p></td>
<td align="left"><p>The cost per unit/slice.</p></td>
</tr>
<tr class="odd">
<td align="left"><p>buyable</p></td>
<td align="left"><p>If the service be purchased now<br /> 1 = Available for purchase.<br /> 0 = Not Available for Purchase</p></td>
</tr>
</tbody>
</table>


### Example API get_vps_slice_types Output (as of 12/14/2014)

<table>
<col width="25%" />
<col width="25%" />
<col width="25%" />
<col width="25%" />
<tbody>
<tr class="odd">
<td align="left"><p><strong>name</strong></p></td>
<td align="left"><p><strong>type</strong></p></td>
<td align="left"><p><strong>cost</strong></p></td>
<td align="left"><p><strong>buyable</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p>OpenVZ VPS Slice</p></td>
<td align="left"><p>0</p></td>
<td align="left"><p>6.00</p></td>
<td align="left"><p>1</p></td>
</tr>
<tr class="odd">
<td align="left"><p>KVM Windows VPS Slice</p></td>
<td align="left"><p>1</p></td>
<td align="left"><p>10.00</p></td>
<td align="left"><p>1</p></td>
</tr>
<tr class="even">
<td align="left"><p>KVM Linux VPS Slice</p></td>
<td align="left"><p>2</p></td>
<td align="left"><p>8.00</p></td>
<td align="left"><p>1</p></td>
</tr>
<tr class="odd">
<td align="left"><p>Cloud KVM Windows VPS Slice</p></td>
<td align="left"><p>3</p></td>
<td align="left"><p>22.00</p></td>
<td align="left"><p>1</p></td>
</tr>
<tr class="even">
<td align="left"><p>Cloud KVM Linux VPS Slice</p></td>
<td align="left"><p>4</p></td>
<td align="left"><p>20.00</p></td>
<td align="left"><p>1</p></td>
</tr>
<tr class="odd">
<td align="left"><p>SSD OpenVZ VPS Slice</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>10.00</p></td>
<td align="left"><p>1</p></td>
</tr>
<tr class="even">
<td align="left"><p>LXC VPS Slice</p></td>
<td align="left"><p>9</p></td>
<td align="left"><p>6.00</p></td>
<td align="left"><p>0</p></td>
</tr>
</tbody>
</table>


## Getting the Available VPS OS Templates

Each Type of Virtualization has its own set of installable OS templates/images.   To get a list of them use the get_vps_templates function.


### Input Parameters for API get_vps_templates

<table>
<col width="50%" />
<col width="50%" />
<tbody>
<tr class="odd">
<td align="left"><p><strong>Parameter</strong></p></td>
<td align="left"><p><strong>Description</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p>None</p></td>
<td align="left"><p>None</p></td>
</tr>
</tbody>
</table>


### Output Fields for API get_vps_templates

<table>
<col width="50%" />
<col width="50%" />
<tbody>
<tr class="odd">
<td align="left"><p><strong>Field Name</strong></p></td>
<td align="left"><p><strong>Description</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p>type</p></td>
<td align="left"><p><em>matches above <strong>services_type</strong></em></p></td>
</tr>
<tr class="odd">
<td align="left"><p>virtualization</p></td>
<td align="left"><p><em>Type of Virtualization</em></p></td>
</tr>
<tr class="even">
<td align="left"><p>bits</p></td>
<td align="left"><p><em>32 or 64 Bit OS</em></p></td>
</tr>
<tr class="odd">
<td align="left"><p>os</p></td>
<td align="left"><p><em>Distribution /</em> <em>OS Name</em></p></td>
</tr>
<tr class="even">
<td align="left"><p>version</p></td>
<td align="left"><p><em>Distribution / OS Version</em></p></td>
</tr>
<tr class="odd">
<td align="left"><p>file</p></td>
<td align="left"><p><em>the <strong>os</strong> field in <strong>buy_vps</strong></em></p></td>
</tr>
<tr class="even">
<td align="left"><p>title</p></td>
<td align="left"><p><em>Full template name including OS / Version/ Architecture information.</em></p></td>
</tr>
</tbody>
</table>

### Example API get_vps_templates Output (as of 12/14/2014)

<table>
<col width="14%" />
<col width="14%" />
<col width="14%" />
<col width="14%" />
<col width="14%" />
<col width="14%" />
<col width="14%" />
<tbody>
<tr class="odd">
<td align="left"><p><strong>type</strong></p></td>
<td align="left"><p><strong>virtulization</strong></p></td>
<td align="left"><p><strong>bits</strong></p></td>
<td align="left"><p><strong>os</strong></p></td>
<td align="left"><p><strong>version</strong></p></td>
<td align="left"><p><strong>file</strong></p></td>
<td align="left"><p><strong>title</strong></p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>5.1</p></td>
<td align="left"><p>altlinux-5.1-x86_64.tar.gz</p></td>
<td align="left"><p>Altlinux 5.1 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>5.1</p></td>
<td align="left"><p>altlinux-5.1-i586.tar.gz</p></td>
<td align="left"><p>Altlinux 5.1 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p6 20120321</p></td>
<td align="left"><p>altlinux-p6-20120321-x86_64.tar.gz</p></td>
<td align="left"><p>Altlinux p6 20120321 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p7 ovz generic 20140612</p></td>
<td align="left"><p>altlinux-p7-ovz-generic-20140612-x86_64.tar.xz</p></td>
<td align="left"><p>Altlinux p7 ovz generic 20140612 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p6 20120321</p></td>
<td align="left"><p>altlinux-p6-20120321-i586.tar.gz</p></td>
<td align="left"><p>Altlinux p6 20120321 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p7 ovz generic 20140612</p></td>
<td align="left"><p>altlinux-p7-ovz-generic-20140612-i586.tar.xz</p></td>
<td align="left"><p>Altlinux p7 ovz generic 20140612 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>20140707</p></td>
<td align="left"><p>arch-20140707-x86_64.tar.xz</p></td>
<td align="left"><p>Arch 20140707 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>20131014</p></td>
<td align="left"><p>arch-20131014-x86_64.tar.xz</p></td>
<td align="left"><p>Arch 20131014 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>0.8 minimal</p></td>
<td align="left"><p>arch-0.8-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Arch 0.8 minimal 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>0.8 minimal</p></td>
<td align="left"><p>arch-0.8-i686-minimal.tar.gz</p></td>
<td align="left"><p>Arch 0.8 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>cctel</p></td>
<td align="left"><p>6.2.18 default</p></td>
<td align="left"><p>cctel-6.2.18-x86_64-default.tar.gz</p></td>
<td align="left"><p>Cctel 6.2.18 default 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7</p></td>
<td align="left"><p>centos-7-x86_64.tar.gz</p></td>
<td align="left"><p>CentOS 7 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7 minimal</p></td>
<td align="left"><p>centos-7-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 7 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>centos-6-x86_64.tar.gz</p></td>
<td align="left"><p>CentOS 6 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 devel</p></td>
<td align="left"><p>centos-6-x86_64-devel.tar.gz</p></td>
<td align="left"><p>CentOS 6 devel 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal</p></td>
<td align="left"><p>centos-6-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 6 minimal 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>centos-6-x86.tar.gz</p></td>
<td align="left"><p>CentOS 6 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 devel</p></td>
<td align="left"><p>centos-6-x86-devel.tar.gz</p></td>
<td align="left"><p>CentOS 6 devel 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal</p></td>
<td align="left"><p>centos-6-x86-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 6 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>centos-5-x86_64.tar.gz</p></td>
<td align="left"><p>CentOS 5 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 devel</p></td>
<td align="left"><p>centos-5-x86_64-devel.tar.gz</p></td>
<td align="left"><p>CentOS 5 devel 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>centos-5-x86.tar.gz</p></td>
<td align="left"><p>CentOS 5 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 devel</p></td>
<td align="left"><p>centos-5-x86-devel.tar.gz</p></td>
<td align="left"><p>CentOS 5 devel 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7 20141113</p></td>
<td align="left"><p>centos-7-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 7 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7 minimal 20141113</p></td>
<td align="left"><p>centos-7-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 7 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>centos-6-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>centos-6-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>centos-6-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>centos-6-x86-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 default</p></td>
<td align="left"><p>centos-5-x86_64-default.tar.gz</p></td>
<td align="left"><p>CentOS 5 default 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>centos-5-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 5 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 minimal</p></td>
<td align="left"><p>centos-5-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 5 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 goautodial ce 2.1</p></td>
<td align="left"><p>centos-5-x86_64-goautodial-ce-2.1-openvz.tar.gz</p></td>
<td align="left"><p>CentOS 5 goautodial ce 2.1 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 default</p></td>
<td align="left"><p>centos-5-i386-default.tar.gz</p></td>
<td align="left"><p>CentOS 5 default 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 minimal</p></td>
<td align="left"><p>centos-5-i386-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 5 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>centos-5-x86-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 5 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>centos-4-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>CentOS 4 EOL 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>centos-4-x86-EOL.tar.xz</p></td>
<td align="left"><p>CentOS 4 EOL 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 default</p></td>
<td align="left"><p>cern-4-x86_64-default.tar.gz</p></td>
<td align="left"><p>Cern 4 default 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 minimal</p></td>
<td align="left"><p>cern-4-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Cern 4 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 default</p></td>
<td align="left"><p>cern-4-i386-default.tar.gz</p></td>
<td align="left"><p>Cern 4 default 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 minimal</p></td>
<td align="left"><p>cern-4-i386-minimal.tar.gz</p></td>
<td align="left"><p>Cern 4 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0</p></td>
<td align="left"><p>debian-7.0-x86.tar.gz</p></td>
<td align="left"><p>Debian 7.0 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-x86-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0</p></td>
<td align="left"><p>debian-6.0-x86_64.tar.gz</p></td>
<td align="left"><p>Debian 6.0 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0</p></td>
<td align="left"><p>debian-6.0-x86.tar.gz</p></td>
<td align="left"><p>Debian 6.0 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-x86-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0</p></td>
<td align="left"><p>debian-7.0-x86_64.tar.gz</p></td>
<td align="left"><p>Debian 7.0 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 envbox</p></td>
<td align="left"><p>debian-7.0-amd64-envbox.tar.xz</p></td>
<td align="left"><p>Debian 7.0 envbox 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-amd64-minimal.tar.xz</p></td>
<td align="left"><p>Debian 7.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-i386-minimal.tar.xz</p></td>
<td align="left"><p>Debian 7.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>5.0 minimal</p></td>
<td align="left"><p>debian-5.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 5.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>5.0 minimal</p></td>
<td align="left"><p>debian-5.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 5.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>4.0 minimal</p></td>
<td align="left"><p>debian-4.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 4.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>4.0 proxmox mailgateway 2.0</p></td>
<td align="left"><p>debian-4.0-proxmox-mailgateway-2.0.tar.gz</p></td>
<td align="left"><p>Debian 4.0 proxmox mailgateway 2.0 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>4.0 minimal</p></td>
<td align="left"><p>debian-4.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 4.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20</p></td>
<td align="left"><p>fedora-20-x86_64.tar.gz</p></td>
<td align="left"><p>Fedora 20 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20</p></td>
<td align="left"><p>fedora-20-x86.tar.gz</p></td>
<td align="left"><p>Fedora 20 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19</p></td>
<td align="left"><p>fedora-19-x86_64.tar.gz</p></td>
<td align="left"><p>Fedora 19 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19</p></td>
<td align="left"><p>fedora-19-x86.tar.gz</p></td>
<td align="left"><p>Fedora 19 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 XFCE 20140909</p></td>
<td align="left"><p>fedora-20-x86_64-XFCE-20140909.tar.xz</p></td>
<td align="left"><p>Fedora 20 XFCE 20140909 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 20141113</p></td>
<td align="left"><p>fedora-20-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 minimal 20141113</p></td>
<td align="left"><p>fedora-20-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 minimal 20141113</p></td>
<td align="left"><p>fedora-20-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 20141113</p></td>
<td align="left"><p>fedora-20-x86-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19 20141113</p></td>
<td align="left"><p>fedora-19-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 19 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19 20141113</p></td>
<td align="left"><p>fedora-19-x86-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 19 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>18 EOL</p></td>
<td align="left"><p>fedora-18-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 18 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>18 EOL</p></td>
<td align="left"><p>fedora-18-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 18 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>17 EOL</p></td>
<td align="left"><p>fedora-17-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 17 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>17 EOL</p></td>
<td align="left"><p>fedora-17-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 17 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>16 EOL</p></td>
<td align="left"><p>fedora-16-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 16 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>16 EOL</p></td>
<td align="left"><p>fedora-16-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 16 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>15 EOL</p></td>
<td align="left"><p>fedora-15-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 15 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>15 EOL</p></td>
<td align="left"><p>fedora-15-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 15 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>14 EOL</p></td>
<td align="left"><p>fedora-14-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 14 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>14 EOL</p></td>
<td align="left"><p>fedora-14-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 14 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>13 default EOL</p></td>
<td align="left"><p>fedora-13-x86_64-default-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 13 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>13 default EOL</p></td>
<td align="left"><p>fedora-13-i386-default-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 13 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>12 default EOL</p></td>
<td align="left"><p>fedora-12-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 12 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>12 default EOL</p></td>
<td align="left"><p>fedora-12-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 12 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>11 default EOL</p></td>
<td align="left"><p>fedora-11-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 11 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>11 default EOL</p></td>
<td align="left"><p>fedora-11-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 11 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>10 default EOL</p></td>
<td align="left"><p>fedora-10-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 10 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>10 default EOL</p></td>
<td align="left"><p>fedora-10-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 10 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default</p></td>
<td align="left"><p>fedora-9-x86_64-default.tar.gz</p></td>
<td align="left"><p>Fedora 9 default 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default EOL</p></td>
<td align="left"><p>fedora-9-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 9 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 minimal</p></td>
<td align="left"><p>fedora-9-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Fedora 9 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default EOL</p></td>
<td align="left"><p>fedora-9-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 9 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default</p></td>
<td align="left"><p>fedora-9-i386-default.tar.gz</p></td>
<td align="left"><p>Fedora 9 default 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 minimal</p></td>
<td align="left"><p>fedora-9-i386-minimal.tar.gz</p></td>
<td align="left"><p>Fedora 9 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>8 default EOL</p></td>
<td align="left"><p>fedora-8-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 8 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>8 default EOL</p></td>
<td align="left"><p>fedora-8-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 8 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>core 7 default</p></td>
<td align="left"><p>fedora-core-7-i386-default.tar.gz</p></td>
<td align="left"><p>Fedora core 7 default 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>core 7 minimal</p></td>
<td align="left"><p>fedora-core-7-i386-minimal.tar.gz</p></td>
<td align="left"><p>Fedora core 7 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>funtoo</p></td>
<td align="left"><p>current generic_32 latest</p></td>
<td align="left"><p>funtoo-current-generic_32-openvz-latest.tar.xz</p></td>
<td align="left"><p>Funtoo current generic_32 latest 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>funtoo</p></td>
<td align="left"><p>current generic_64 latest</p></td>
<td align="left"><p>funtoo-current-generic_64-openvz-latest.tar.xz</p></td>
<td align="left"><p>Funtoo current generic_64 latest 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>20071018</p></td>
<td align="left"><p>gentoo-amd64-20071018.tar.gz</p></td>
<td align="left"><p>Gentoo 20071018 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>2008.11.27</p></td>
<td align="left"><p>gentoo-openvz-amd64-2008.11.27.tar.gz</p></td>
<td align="left"><p>Gentoo 2008.11.27 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>2008.11.30</p></td>
<td align="left"><p>gentoo-openvz-x86-2008.11.30.tar.gz</p></td>
<td align="left"><p>Gentoo 2008.11.30 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>stage3 20110520</p></td>
<td align="left"><p>gentoo-openvz-stage3-amd64-20110520.tar.gz</p></td>
<td align="left"><p>Gentoo stage3 20110520 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>opensuse</p></td>
<td align="left"><p>11.0 20081217</p></td>
<td align="left"><p>opensuse-11.0-i586-20081217.tar.gz</p></td>
<td align="left"><p>Opensuse 11.0 20081217 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>opensuse</p></td>
<td align="left"><p>10.1</p></td>
<td align="left"><p>opensuse-10.1-i386.tar.gz</p></td>
<td align="left"><p>Opensuse 10.1 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>7 minimal 20141113</p></td>
<td align="left"><p>oracle-7-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 7 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>7 20141113</p></td>
<td align="left"><p>oracle-7-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 7 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>oracle-6-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>oracle-6-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>oracle-6-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>oracle-6-x86-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>owl</p></td>
<td align="left"><p>3.0 release</p></td>
<td align="left"><p>owl-3.0-release-x86_64.tar.gz</p></td>
<td align="left"><p>Owl 3.0 release 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>owl</p></td>
<td align="left"><p>3.0 release</p></td>
<td align="left"><p>owl-3.0-release-i686.tar.gz</p></td>
<td align="left"><p>Owl 3.0 release 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>scientific-6-x86_64.tar.gz</p></td>
<td align="left"><p>Scientific 6 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>scientific-6-x86.tar.gz</p></td>
<td align="left"><p>Scientific 6 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>7 minimal 20141118</p></td>
<td align="left"><p>scientific-7-x86_64-minimal-20141118.tar.xz</p></td>
<td align="left"><p>Scientific 7 minimal 20141118 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>7 20141118</p></td>
<td align="left"><p>scientific-7-x86_64-20141118.tar.xz</p></td>
<td align="left"><p>Scientific 7 20141118 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>scientific-6-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>scientific-6-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>scientific-6-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>scientific-6-x86-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>scientific-5-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 5 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>scientific-5-x86-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 5 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>scientific-4-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Scientific 4 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>scientific-4-x86-EOL.tar.xz</p></td>
<td align="left"><p>Scientific 4 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>13.37 minimal</p></td>
<td align="left"><p>slackware-13.37-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 13.37 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>13.37 i486 minimal</p></td>
<td align="left"><p>slackware-13.37-i486-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 13.37 i486 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>13.1 minimal</p></td>
<td align="left"><p>slackware-13.1-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 13.1 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>12.0 minimal</p></td>
<td align="left"><p>slackware-12.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 12.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>11.0 minimal</p></td>
<td align="left"><p>slackware-11.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 11.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>10.2 minimal</p></td>
<td align="left"><p>slackware-10.2-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 10.2 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>sles</p></td>
<td align="left"><p>10.2 minimal</p></td>
<td align="left"><p>sles-10.2-i586-minimal.tar.gz</p></td>
<td align="left"><p>Sles 10.2 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1</p></td>
<td align="left"><p>suse-13.1-x86_64.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1 minimal</p></td>
<td align="left"><p>suse-13.1-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 minimal 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1 minimal</p></td>
<td align="left"><p>suse-13.1-x86-minimal.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1</p></td>
<td align="left"><p>suse-13.1-x86.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>12.3</p></td>
<td align="left"><p>suse-12.3-x86_64.tar.gz</p></td>
<td align="left"><p>SuSe 12.3 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>12.3</p></td>
<td align="left"><p>suse-12.3-x86.tar.gz</p></td>
<td align="left"><p>SuSe 12.3 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>9.3</p></td>
<td align="left"><p>suse-9.3-x86_64.tar.gz</p></td>
<td align="left"><p>SuSe 9.3 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu-14.04-x86_64.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04 minimal</p></td>
<td align="left"><p>ubuntu-14.04-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu-14.04-x86.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04 minimal</p></td>
<td align="left"><p>ubuntu-14.04-x86-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04</p></td>
<td align="left"><p>ubuntu-12.04-x86_64.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04 minimal</p></td>
<td align="left"><p>ubuntu-12.04-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04</p></td>
<td align="left"><p>ubuntu-12.04-x86.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04 minimal</p></td>
<td align="left"><p>ubuntu-12.04-x86-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04</p></td>
<td align="left"><p>ubuntu-10.04-x86_64.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04</p></td>
<td align="left"><p>ubuntu-10.04-x86.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 minimal</p></td>
<td align="left"><p>ubuntu-10.04-minimal_10.04_i386.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 minimal</p></td>
<td align="left"><p>ubuntu-10.04-minimal_10.04_amd64.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 lamp</p></td>
<td align="left"><p>ubuntu-10.04-lamp_10.04_i386.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 lamp 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 lamp</p></td>
<td align="left"><p>ubuntu-10.04-lamp_10.04_amd64.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 lamp 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>9.04 minimal</p></td>
<td align="left"><p>ubuntu-9.04-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 9.04 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>8.04.2 minimal</p></td>
<td align="left"><p>ubuntu-8.04.2-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 8.04.2 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>7.10 minimal</p></td>
<td align="left"><p>ubuntu-7.10-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 7.10 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>0</p></td>
<td align="left"><p>OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>6.06 minimal</p></td>
<td align="left"><p>ubuntu-6.06-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 6.06 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>1</p></td>
<td align="left"><p>KVM Windows</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>windows</p></td>
<td align="left"><p>2012</p></td>
<td align="left"><p>windows2012</p></td>
<td align="left"><p>Windows 2012 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>1</p></td>
<td align="left"><p>KVM Windows</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>windows</p></td>
<td align="left"><p>2008 r2</p></td>
<td align="left"><p>windowsr2</p></td>
<td align="left"><p>Windows 2008 r2 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>1</p></td>
<td align="left"><p>KVM Windows</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>windows</p></td>
<td align="left"><p>2008 r2</p></td>
<td align="left"><p>windows2</p></td>
<td align="left"><p>Windows 2008 r2 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7</p></td>
<td align="left"><p>centos55</p></td>
<td align="left"><p>CentOS 7 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>centos5</p></td>
<td align="left"><p>CentOS 6 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7</p></td>
<td align="left"><p>debian6</p></td>
<td align="left"><p>Debian 7 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>freepbx</p></td>
<td align="left"><p>5.8</p></td>
<td align="left"><p>freepbx</p></td>
<td align="left"><p>FreePBX 5.8 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu10</p></td>
<td align="left"><p>Ubuntu 14.04 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04 Desktop</p></td>
<td align="left"><p>ubuntudesktop</p></td>
<td align="left"><p>Ubuntu 14.04 Desktop 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04</p></td>
<td align="left"><p>ubuntu12</p></td>
<td align="left"><p>Ubuntu 12.04 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>2</p></td>
<td align="left"><p>KVM Linux</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04</p></td>
<td align="left"><p>ubuntu10</p></td>
<td align="left"><p>Ubuntu 10.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>5.1</p></td>
<td align="left"><p>altlinux-5.1-x86_64.tar.gz</p></td>
<td align="left"><p>Altlinux 5.1 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>5.1</p></td>
<td align="left"><p>altlinux-5.1-i586.tar.gz</p></td>
<td align="left"><p>Altlinux 5.1 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p6 20120321</p></td>
<td align="left"><p>altlinux-p6-20120321-x86_64.tar.gz</p></td>
<td align="left"><p>Altlinux p6 20120321 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p7 ovz generic 20140612</p></td>
<td align="left"><p>altlinux-p7-ovz-generic-20140612-x86_64.tar.xz</p></td>
<td align="left"><p>Altlinux p7 ovz generic 20140612 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p6 20120321</p></td>
<td align="left"><p>altlinux-p6-20120321-i586.tar.gz</p></td>
<td align="left"><p>Altlinux p6 20120321 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>altlinux</p></td>
<td align="left"><p>p7 ovz generic 20140612</p></td>
<td align="left"><p>altlinux-p7-ovz-generic-20140612-i586.tar.xz</p></td>
<td align="left"><p>Altlinux p7 ovz generic 20140612 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>20140707</p></td>
<td align="left"><p>arch-20140707-x86_64.tar.xz</p></td>
<td align="left"><p>Arch 20140707 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>20131014</p></td>
<td align="left"><p>arch-20131014-x86_64.tar.xz</p></td>
<td align="left"><p>Arch 20131014 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>0.8 minimal</p></td>
<td align="left"><p>arch-0.8-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Arch 0.8 minimal 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>arch</p></td>
<td align="left"><p>0.8 minimal</p></td>
<td align="left"><p>arch-0.8-i686-minimal.tar.gz</p></td>
<td align="left"><p>Arch 0.8 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>cctel</p></td>
<td align="left"><p>6.2.18 default</p></td>
<td align="left"><p>cctel-6.2.18-x86_64-default.tar.gz</p></td>
<td align="left"><p>Cctel 6.2.18 default 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7</p></td>
<td align="left"><p>centos-7-x86_64.tar.gz</p></td>
<td align="left"><p>CentOS 7 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7 minimal</p></td>
<td align="left"><p>centos-7-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 7 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 devel</p></td>
<td align="left"><p>centos-6-x86_64-devel.tar.gz</p></td>
<td align="left"><p>CentOS 6 devel 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>centos-6-x86_64.tar.gz</p></td>
<td align="left"><p>CentOS 6 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal</p></td>
<td align="left"><p>centos-6-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 6 minimal 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 devel</p></td>
<td align="left"><p>centos-6-x86-devel.tar.gz</p></td>
<td align="left"><p>CentOS 6 devel 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>centos-6-x86.tar.gz</p></td>
<td align="left"><p>CentOS 6 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal</p></td>
<td align="left"><p>centos-6-x86-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 6 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 devel</p></td>
<td align="left"><p>centos-5-x86_64-devel.tar.gz</p></td>
<td align="left"><p>CentOS 5 devel 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>centos-5-x86_64.tar.gz</p></td>
<td align="left"><p>CentOS 5 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 devel</p></td>
<td align="left"><p>centos-5-x86-devel.tar.gz</p></td>
<td align="left"><p>CentOS 5 devel 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5</p></td>
<td align="left"><p>centos-5-x86.tar.gz</p></td>
<td align="left"><p>CentOS 5 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7 20141113</p></td>
<td align="left"><p>centos-7-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 7 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>7 minimal 20141113</p></td>
<td align="left"><p>centos-7-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 7 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>centos-6-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>centos-6-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>centos-6-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>centos-6-x86-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 6 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 default</p></td>
<td align="left"><p>centos-5-x86_64-default.tar.gz</p></td>
<td align="left"><p>CentOS 5 default 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>centos-5-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 5 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 minimal</p></td>
<td align="left"><p>centos-5-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 5 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 goautodial ce 2.1</p></td>
<td align="left"><p>centos-5-x86_64-goautodial-ce-2.1-openvz.tar.gz</p></td>
<td align="left"><p>CentOS 5 goautodial ce 2.1 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 default</p></td>
<td align="left"><p>centos-5-i386-default.tar.gz</p></td>
<td align="left"><p>CentOS 5 default 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>centos-5-x86-20141113.tar.xz</p></td>
<td align="left"><p>CentOS 5 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>5 minimal</p></td>
<td align="left"><p>centos-5-i386-minimal.tar.gz</p></td>
<td align="left"><p>CentOS 5 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>centos-4-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>CentOS 4 EOL 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>centos</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>centos-4-x86-EOL.tar.xz</p></td>
<td align="left"><p>CentOS 4 EOL 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 default</p></td>
<td align="left"><p>cern-4-x86_64-default.tar.gz</p></td>
<td align="left"><p>Cern 4 default 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 minimal</p></td>
<td align="left"><p>cern-4-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Cern 4 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 default</p></td>
<td align="left"><p>cern-4-i386-default.tar.gz</p></td>
<td align="left"><p>Cern 4 default 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>cern</p></td>
<td align="left"><p>4 minimal</p></td>
<td align="left"><p>cern-4-i386-minimal.tar.gz</p></td>
<td align="left"><p>Cern 4 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0</p></td>
<td align="left"><p>debian-7.0-x86.tar.gz</p></td>
<td align="left"><p>Debian 7.0 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-x86-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0</p></td>
<td align="left"><p>debian-6.0-x86_64.tar.gz</p></td>
<td align="left"><p>Debian 6.0 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0</p></td>
<td align="left"><p>debian-6.0-x86.tar.gz</p></td>
<td align="left"><p>Debian 6.0 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-x86-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0</p></td>
<td align="left"><p>debian-7.0-x86_64.tar.gz</p></td>
<td align="left"><p>Debian 7.0 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 envbox</p></td>
<td align="left"><p>debian-7.0-amd64-envbox.tar.xz</p></td>
<td align="left"><p>Debian 7.0 envbox 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-amd64-minimal.tar.xz</p></td>
<td align="left"><p>Debian 7.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 7.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>7.0 minimal</p></td>
<td align="left"><p>debian-7.0-i386-minimal.tar.xz</p></td>
<td align="left"><p>Debian 7.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>6.0 minimal</p></td>
<td align="left"><p>debian-6.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 6.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>5.0 minimal</p></td>
<td align="left"><p>debian-5.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 5.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>5.0 minimal</p></td>
<td align="left"><p>debian-5.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 5.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>4.0 minimal</p></td>
<td align="left"><p>debian-4.0-amd64-minimal.tar.gz</p></td>
<td align="left"><p>Debian 4.0 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>4.0 minimal</p></td>
<td align="left"><p>debian-4.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Debian 4.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>debian</p></td>
<td align="left"><p>4.0 proxmox mailgateway 2.0</p></td>
<td align="left"><p>debian-4.0-proxmox-mailgateway-2.0.tar.gz</p></td>
<td align="left"><p>Debian 4.0 proxmox mailgateway 2.0 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20</p></td>
<td align="left"><p>fedora-20-x86_64.tar.gz</p></td>
<td align="left"><p>Fedora 20 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20</p></td>
<td align="left"><p>fedora-20-x86.tar.gz</p></td>
<td align="left"><p>Fedora 20 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19</p></td>
<td align="left"><p>fedora-19-x86_64.tar.gz</p></td>
<td align="left"><p>Fedora 19 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19</p></td>
<td align="left"><p>fedora-19-x86.tar.gz</p></td>
<td align="left"><p>Fedora 19 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 XFCE 20140909</p></td>
<td align="left"><p>fedora-20-x86_64-XFCE-20140909.tar.xz</p></td>
<td align="left"><p>Fedora 20 XFCE 20140909 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 20141113</p></td>
<td align="left"><p>fedora-20-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 minimal 20141113</p></td>
<td align="left"><p>fedora-20-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 minimal 20141113</p></td>
<td align="left"><p>fedora-20-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>20 20141113</p></td>
<td align="left"><p>fedora-20-x86-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 20 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19 20141113</p></td>
<td align="left"><p>fedora-19-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 19 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>19 20141113</p></td>
<td align="left"><p>fedora-19-x86-20141113.tar.xz</p></td>
<td align="left"><p>Fedora 19 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>18 EOL</p></td>
<td align="left"><p>fedora-18-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 18 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>18 EOL</p></td>
<td align="left"><p>fedora-18-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 18 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>17 EOL</p></td>
<td align="left"><p>fedora-17-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 17 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>17 EOL</p></td>
<td align="left"><p>fedora-17-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 17 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>16 EOL</p></td>
<td align="left"><p>fedora-16-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 16 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>16 EOL</p></td>
<td align="left"><p>fedora-16-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 16 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>15 EOL</p></td>
<td align="left"><p>fedora-15-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 15 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>15 EOL</p></td>
<td align="left"><p>fedora-15-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 15 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>14 EOL</p></td>
<td align="left"><p>fedora-14-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 14 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>14 EOL</p></td>
<td align="left"><p>fedora-14-x86-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 14 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>13 default EOL</p></td>
<td align="left"><p>fedora-13-x86_64-default-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 13 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>13 default EOL</p></td>
<td align="left"><p>fedora-13-i386-default-EOL.tar.xz</p></td>
<td align="left"><p>Fedora 13 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>12 default EOL</p></td>
<td align="left"><p>fedora-12-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 12 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>12 default EOL</p></td>
<td align="left"><p>fedora-12-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 12 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>11 default EOL</p></td>
<td align="left"><p>fedora-11-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 11 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>11 default EOL</p></td>
<td align="left"><p>fedora-11-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 11 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>10 default EOL</p></td>
<td align="left"><p>fedora-10-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 10 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>10 default EOL</p></td>
<td align="left"><p>fedora-10-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 10 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default EOL</p></td>
<td align="left"><p>fedora-9-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 9 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default</p></td>
<td align="left"><p>fedora-9-x86_64-default.tar.gz</p></td>
<td align="left"><p>Fedora 9 default 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 minimal</p></td>
<td align="left"><p>fedora-9-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Fedora 9 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default EOL</p></td>
<td align="left"><p>fedora-9-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 9 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 default</p></td>
<td align="left"><p>fedora-9-i386-default.tar.gz</p></td>
<td align="left"><p>Fedora 9 default 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>9 minimal</p></td>
<td align="left"><p>fedora-9-i386-minimal.tar.gz</p></td>
<td align="left"><p>Fedora 9 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>8 default EOL</p></td>
<td align="left"><p>fedora-8-x86_64-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 8 default EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>8 default EOL</p></td>
<td align="left"><p>fedora-8-i386-default-EOL.tar.gz</p></td>
<td align="left"><p>Fedora 8 default EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>core 7 default</p></td>
<td align="left"><p>fedora-core-7-i386-default.tar.gz</p></td>
<td align="left"><p>Fedora core 7 default 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>fedora</p></td>
<td align="left"><p>core 7 minimal</p></td>
<td align="left"><p>fedora-core-7-i386-minimal.tar.gz</p></td>
<td align="left"><p>Fedora core 7 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>funtoo</p></td>
<td align="left"><p>current generic_32 latest</p></td>
<td align="left"><p>funtoo-current-generic_32-openvz-latest.tar.xz</p></td>
<td align="left"><p>Funtoo current generic_32 latest 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>funtoo</p></td>
<td align="left"><p>current generic_64 latest</p></td>
<td align="left"><p>funtoo-current-generic_64-openvz-latest.tar.xz</p></td>
<td align="left"><p>Funtoo current generic_64 latest 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>20071018</p></td>
<td align="left"><p>gentoo-amd64-20071018.tar.gz</p></td>
<td align="left"><p>Gentoo 20071018 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>2008.11.27</p></td>
<td align="left"><p>gentoo-openvz-amd64-2008.11.27.tar.gz</p></td>
<td align="left"><p>Gentoo 2008.11.27 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>2008.11.30</p></td>
<td align="left"><p>gentoo-openvz-x86-2008.11.30.tar.gz</p></td>
<td align="left"><p>Gentoo 2008.11.30 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>gentoo</p></td>
<td align="left"><p>stage3 20110520</p></td>
<td align="left"><p>gentoo-openvz-stage3-amd64-20110520.tar.gz</p></td>
<td align="left"><p>Gentoo stage3 20110520 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>opensuse</p></td>
<td align="left"><p>11.0 20081217</p></td>
<td align="left"><p>opensuse-11.0-i586-20081217.tar.gz</p></td>
<td align="left"><p>Opensuse 11.0 20081217 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>opensuse</p></td>
<td align="left"><p>10.1</p></td>
<td align="left"><p>opensuse-10.1-i386.tar.gz</p></td>
<td align="left"><p>Opensuse 10.1 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>7 20141113</p></td>
<td align="left"><p>oracle-7-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 7 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>7 minimal 20141113</p></td>
<td align="left"><p>oracle-7-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 7 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>oracle-6-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>oracle-6-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>oracle-6-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>oracle</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>oracle-6-x86-20141113.tar.xz</p></td>
<td align="left"><p>Oracle 6 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>owl</p></td>
<td align="left"><p>3.0 release</p></td>
<td align="left"><p>owl-3.0-release-x86_64.tar.gz</p></td>
<td align="left"><p>Owl 3.0 release 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>owl</p></td>
<td align="left"><p>3.0 release</p></td>
<td align="left"><p>owl-3.0-release-i686.tar.gz</p></td>
<td align="left"><p>Owl 3.0 release 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>scientific-6-x86_64.tar.gz</p></td>
<td align="left"><p>Scientific 6 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6</p></td>
<td align="left"><p>scientific-6-x86.tar.gz</p></td>
<td align="left"><p>Scientific 6 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>7 minimal 20141118</p></td>
<td align="left"><p>scientific-7-x86_64-minimal-20141118.tar.xz</p></td>
<td align="left"><p>Scientific 7 minimal 20141118 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>7 20141118</p></td>
<td align="left"><p>scientific-7-x86_64-20141118.tar.xz</p></td>
<td align="left"><p>Scientific 7 20141118 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>scientific-6-x86_64-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 minimal 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>scientific-6-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 20141113 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 minimal 20141113</p></td>
<td align="left"><p>scientific-6-x86-minimal-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 minimal 20141113 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>6 20141113</p></td>
<td align="left"><p>scientific-6-x86-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 6 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>scientific-5-x86_64-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 5 20141113 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>5 20141113</p></td>
<td align="left"><p>scientific-5-x86-20141113.tar.xz</p></td>
<td align="left"><p>Scientific 5 20141113 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>scientific-4-x86_64-EOL.tar.xz</p></td>
<td align="left"><p>Scientific 4 EOL 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>scientific</p></td>
<td align="left"><p>4 EOL</p></td>
<td align="left"><p>scientific-4-x86-EOL.tar.xz</p></td>
<td align="left"><p>Scientific 4 EOL 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>13.37 minimal</p></td>
<td align="left"><p>slackware-13.37-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 13.37 minimal 64bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>13.37 i486 minimal</p></td>
<td align="left"><p>slackware-13.37-i486-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 13.37 i486 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>13.1 minimal</p></td>
<td align="left"><p>slackware-13.1-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 13.1 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>12.0 minimal</p></td>
<td align="left"><p>slackware-12.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 12.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>11.0 minimal</p></td>
<td align="left"><p>slackware-11.0-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 11.0 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>slackware</p></td>
<td align="left"><p>10.2 minimal</p></td>
<td align="left"><p>slackware-10.2-i386-minimal.tar.gz</p></td>
<td align="left"><p>Slackware 10.2 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>sles</p></td>
<td align="left"><p>10.2 minimal</p></td>
<td align="left"><p>sles-10.2-i586-minimal.tar.gz</p></td>
<td align="left"><p>Sles 10.2 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1</p></td>
<td align="left"><p>suse-13.1-x86_64.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1 minimal</p></td>
<td align="left"><p>suse-13.1-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 minimal 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1 minimal</p></td>
<td align="left"><p>suse-13.1-x86-minimal.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>13.1</p></td>
<td align="left"><p>suse-13.1-x86.tar.gz</p></td>
<td align="left"><p>SuSe 13.1 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>12.3</p></td>
<td align="left"><p>suse-12.3-x86_64.tar.gz</p></td>
<td align="left"><p>SuSe 12.3 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>12.3</p></td>
<td align="left"><p>suse-12.3-x86.tar.gz</p></td>
<td align="left"><p>SuSe 12.3 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>suse</p></td>
<td align="left"><p>9.3</p></td>
<td align="left"><p>suse-9.3-x86_64.tar.gz</p></td>
<td align="left"><p>SuSe 9.3 64bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu-14.04-x86_64.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04 minimal</p></td>
<td align="left"><p>ubuntu-14.04-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu-14.04-x86.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04 minimal</p></td>
<td align="left"><p>ubuntu-14.04-x86-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 14.04 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04</p></td>
<td align="left"><p>ubuntu-12.04-x86_64.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04 minimal</p></td>
<td align="left"><p>ubuntu-12.04-x86_64-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 minimal 64bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04</p></td>
<td align="left"><p>ubuntu-12.04-x86.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 32bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>12.04 minimal</p></td>
<td align="left"><p>ubuntu-12.04-x86-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 12.04 minimal 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04</p></td>
<td align="left"><p>ubuntu-10.04-x86_64.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04</p></td>
<td align="left"><p>ubuntu-10.04-x86.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 32bit</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 lamp</p></td>
<td align="left"><p>ubuntu-10.04-lamp_10.04_amd64.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 lamp 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 lamp</p></td>
<td align="left"><p>ubuntu-10.04-lamp_10.04_i386.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 lamp 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 minimal</p></td>
<td align="left"><p>ubuntu-10.04-minimal_10.04_amd64.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>10.04 minimal</p></td>
<td align="left"><p>ubuntu-10.04-minimal_10.04_i386.tar.gz</p></td>
<td align="left"><p>Ubuntu 10.04 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>9.04 minimal</p></td>
<td align="left"><p>ubuntu-9.04-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 9.04 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>8.04.2 minimal</p></td>
<td align="left"><p>ubuntu-8.04.2-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 8.04.2 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>7.10 minimal</p></td>
<td align="left"><p>ubuntu-7.10-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 7.10 minimal 32bit (contrib)</p></td>
</tr>
<tr class="even">
<td align="left"><p>5</p></td>
<td align="left"><p>SSD OpenVZ</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>6.06 minimal</p></td>
<td align="left"><p>ubuntu-6.06-i386-minimal.tar.gz</p></td>
<td align="left"><p>Ubuntu 6.06 minimal 32bit (contrib)</p></td>
</tr>
<tr class="odd">
<td align="left"><p>9</p></td>
<td align="left"><p>LXC</p></td>
<td align="left"><p>64</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu-trusty-amd64</p></td>
<td align="left"><p>Ubuntu 14.04 64bit</p></td>
</tr>
<tr class="even">
<td align="left"><p>9</p></td>
<td align="left"><p>LXC</p></td>
<td align="left"><p>32</p></td>
<td align="left"><p>ubuntu</p></td>
<td align="left"><p>14.04</p></td>
<td align="left"><p>ubuntu-trusty-i3864</p></td>
<td align="left"><p>Ubuntu 14.04 32bit</p></td>
</tr>
</tbody>
</table>




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



## Feedback and Suggestions

If you have any questions or ideas on how we can improve our services, please let us know at support@interserver.net,
