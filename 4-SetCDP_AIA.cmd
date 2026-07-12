certutil -setreg CA\CRLPublicationURLs "65:C:\Windows\System32\CertSrv\CertEnroll\%3%8%9.crl\n6:http://pki.EgyptSystems.local/pki/%3%8%9.crl\n65:file://\\IssuingCA\pki\%3%8%9.crl"

certutil -setreg CA\CACertPublicationURLs "2:http://pki.EgyptSystems.local/pki/%1_%3%4.crt"

net stop certsvc

net start certsvc

pause