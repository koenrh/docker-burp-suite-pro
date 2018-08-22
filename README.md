# Burp Suite Pro

This allows you to run Burp Suite Professional in a container. This guide describes
the steps to run Burp on a Mac, but steps for Linux should be fairly similar.

## Prerequisites

- You need a [Burp Suite Professional](https://portswigger.net/burp) license.
- You need to have the following installed on your host:
  - [Docker](https://docs.docker.com/install/)
  - [XQuartz](https://www.xquartz.org/)
  - [socat](http://www.dest-unreach.org/socat/)

## Building the image

First, clone this GitHub repository on your host:

```bash
git clone https://github.com/koenrh/docker-burp-suite-pro.git
```

Then, build the Docker image using the following command. Provide the email address
and customer number you would normally use to login to your PortSwigger account.

```bash
docker build -t koenrh/burp-suite-pro \
    --build-arg PORTSWIGGER_EMAIL_ADDRESS="john@example.com" \
    --build-arg PORTSWIGGER_CUSTOMER_NUMBER="FOOBAR" .
```

While building the image, the JAR (Java ARchive) of Burp Suite Pro is pulled form
the PortSwigger portal.

## Setup

1. Start the X window server by opening XQuartz (`open -a XQuartz`).
1. Expose the local XQuartz socket on TCP port 6000:

```
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

## Usage

```bash
docker run --rm \
  -v "/tmp/.X11-unix:/tmp/.X11-unix" \
  -e "DISPLAY=192.168.1.59:0" \
  -v $E:HOME"/src/github.com/koenrh/burp/java:/home/burp/.java" \
  -p 8080:8080 \
  --name burp-suite-pro
  koenrh/burp-suite-pro
```

You could make this command more easily accessible by putting it an executable,
and make sure that it is available in your `$PATH`. Alternative, you could create
wrapper functions for your `docker run` commands ([example](https://github.com/jessfraz/dotfiles/blob/master/.dockerfunc)).

### Burp Proxy

In order to make Burp Proxy available to the host, you need to bind on the public
interface.

1. In Burp, open the 'Proxy' tab, and then the 'Options' tab.
1. Add a new 'Proxy Listener' by clicking the 'Add' button.
1. Enter the preferred port number, and make sure that 'Bind to address' is set
  to 'All interfaces'.
1. Verify that the proxy is working by running the following command on your host:

```bash
curl -x http://127.0.0.1:8080 http://example.com
```

## Notes

1. When prompted, do not updated Burp Suite through the GUI. Pull and build an
  updated image instead.
1. Do not the delete the mapped `.java` directory on your host. It contains important
  license activation data.
