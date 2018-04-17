########################PREPARE TLS ARTIFACTS##############################3

#passwork has to be at least 6 characters
export pleaseHackMePasswd=password

#generate files, directory structure for generation of self-signed certs, keysotres, and truststores
./util/ssl-ca.sh

cd ssl_ca

#use openssl utility, act as a CA and generate a private key
openssl genrsa -out private/acme-ca.key -des3 -passout pass:$pleaseHackMePasswd 2048

#Using the openssl utility, act as a CA and generate a publicly dispersible CA certificate in PEM format:
openssl req -new -x509 -key private/acme-ca.key -days 365 -out acme-ca.crt -subj "/CN=ACME Certification Authority" -passin pass:$pleaseHackMePasswd

#Using the Java-based keytool command, generate a private certificate that resides in a new keystore:
 keytool -genkeypair -keyalg RSA -keysize 2048 \
          -alias sso-ssl-key \
          -keystore sso-ssl.jks \
          -storepass $pleaseHackMePasswd \
          -keypass $pleaseHackMePasswd \
          -dname "CN=secure-sso-rht-sso.$OCP_WILDCARD_DOMAIN"

#    The keystore (which at this point includes only a private key), is leveraged later by your Red Hat SSO server at runtime.
    #Next, you need to create a Certificate Signing Request (CSR) for this certificate and submit them both to a CA.

#Create a CSR based on the certificate in your keystore:
 keytool -certreq -keyalg rsa -alias sso-ssl-key -keystore sso-ssl.jks -storepass $pleaseHackMePasswd -file sso-ssl.csr

    #You are now ready to (notionally) submit the CSR to a CA (which, strictly for the purposes of this lab, is also you.)

#Sign the CSR using the CA certificate
openssl ca -config ca.cnf -out sso-ssl.crt -passin pass:$pleaseHackMePasswd -batch -infiles sso-ssl.csr

#    Now that your CSR is signed by the CA, the signed CSR is typically returned to you along with the CA’s certificate. In any case, you have both the signed CSR and the CA’s certificate and are ready to add them both to your previously created keystore.

#Import the CA’s certificate into the SSL keystore:
 keytool -import -file acme-ca.crt -alias acme.ca -keystore sso-ssl.jks -storepass $pleaseHackMePasswd

#Import the signed certificate reply into the SSL keystore:
keytool -import -file sso-ssl.crt -alias sso-ssl-key -keystore sso-ssl.jks -storepass $pleaseHackMePasswd

#Confirm that the following two items are in the sso-ssl.jks keystore:

    #sso-ssl-key: The SSL private key and signed public certificate reply

    #acme.ca: The CA’s certificate
keytool -v -list -keystore sso-ssl.jks -storepass $pleaseHackMePasswd


#Import the CA’s certificate into the truststore:
keytool -import -file acme-ca.crt -alias xpaas.ca -keystore truststore.jks -storepass $pleaseHackMePasswd

#    The truststore is used by both the Red Hat SSO server as well as Java clients (for example, your Swarm and Vert.x business services) communicating with that server.

#As a last step, generate a secure key for the JGroups keystore:
keytool -genseckey -alias jgroups -storetype JCEKS -keystore jgroups.jceks -storepass $pleaseHackMePasswd -keypass $pleaseHackMePasswd

    This key is used to support encrypted communication of a cluster of Red Hat SSO servers (a configuration beyond the scope of this course).

#Review the generated SSL artifacts:

    #~/ssl_ca/private/acme-ca.key: The CA’s private key

    #~/ssl_ca/truststore.jks: The Java truststore containing the CA’s certificate

    #~/ssl_ca/sso-ssl.jks: The Java keystore containing your signed Red Hat SSO certificate


########################
