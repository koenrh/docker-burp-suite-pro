# Burp Suite Pro

## Running

1. open -a XQuartz
2. socat TCP-LISTEN:6000,reuseaddr,fork "UNIX-CLIENT:\""$E:DISPLAY"\""
3.
docker run --rm -v "/tmp/.X11-unix:/tmp/.X11-unix" -e "DISPLAY=192.168.1.59:0" -v $E:HOME"/src/github.com/koenrh/burp/java:/home/burp/.java" -v $E:HOME" /src/github.com/koenrh/burp/BurpSuite:/home/burp/.BurpSuite" -p 8080:8080 --name burp koenrh/burp


Burp Suite: Proxy listeners, listen on 'all interfaces'.




## Build image

docker build -t koenrh/burp --build-arg PORTSWIGGER_EMAIL_ADDRESS="foo@bar.baz" --build-arg PORTSWIGGER_CUSTOMER_NUMBER="bar" .
