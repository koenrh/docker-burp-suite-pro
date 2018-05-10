#!/bin/sh

email="$PORTSWIGGER_EMAIL_ADDRESS"
customer_number="$PORTSWIGGER_CUSTOMER_NUMBER"

name="burpsuite_pro"
version="$BURP_SUITE_PRO_VERSION"
file_name="$HOME/${name}_v$version.jar"
checksum="$BURP_SUITE_PRO_CHECKSUM"

cookie_jar="$HOME/cookies"

# Make initial request to get the 'request verification token' (CSRF).
token=$(curl -s --cookie-jar $cookie_jar "https://portswigger.net/users" | grep -oE "[a-zA-Z0-9_-]{108}")

# Login using the username (email address) and password (customer number).
curl -X POST https://portswigger.net/users \
  -b $cookie_jar \
  -c $cookie_jar \
  -F "EmailAddress=$email" \
  -F "CustomerNumber=$customer_number" \
  -F "__RequestVerificationToken=$token"

# Download the JAR file.
curl -b $cookie_jar \
  -o "$file_name" \
  "https://portswigger.net/burp/releases/download?product=pro&version=$version&type=jar" -v

echo "$checksum *$file_name" | sha256sum -c || exit
