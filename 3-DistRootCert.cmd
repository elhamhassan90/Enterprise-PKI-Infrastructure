certutil -dspublish -f c:\import\RootCA_ROOTCA-CA.crt rootCA 
certutil -addstore -f root c:\import\RootCA_ROOTCA-CA.crt 
certutil -addstore -f root c:\import\ROOTCA-CA.crl
pause