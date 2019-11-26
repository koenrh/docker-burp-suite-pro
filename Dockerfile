FROM openjdk:8u151-jre-alpine3.7@sha256:6aa7da366e07ba497d00caaf6d9206167dd210a8bf54d960bee16b9d421a4f54
LABEL maintainer "Koen Rouwhorst <koen@privesc.com>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_PASSWORD

ENV BURP_SUITE_PRO_VERSION="2.1.06"
ENV BURP_SUITE_PRO_CHECKSUM="2f94055e1424fd2f95f2bc1b5d8d28f4daafd37fca1fbde9b4ae739a34fbfcfd"

ENV HOME /home/burp

ENV JAVA_OPTS "-Dawt.useSystemAAFontSettings=gasp "\
  "-Dswing.aatext=true "\
  "-Dsun.java2d.xrender=true" \
  "-XX:+UnlockExperimentalVMOptions "\
  "-XX:+UseCGroupMemoryLimitForHeap "\
  "-XshowSettings:vm"

RUN apk add --no-cache \
  curl~=7 \
  openssl~=1.0 \
  ca-certificates~=20171114 \
  ttf-freefont~=20120503 \
  ttf-dejavu~=2.37

COPY ./download.sh ./entrypoint.sh /home/burp/
RUN chmod +x /home/burp/download.sh /home/burp/entrypoint.sh && \
  /home/burp/download.sh && \
  mv "$HOME/burpsuite_pro_v$BURP_SUITE_PRO_VERSION.jar" /home/burp/burpsuite_pro.jar

RUN addgroup -S burp && \
  adduser -S -g burp burp

RUN mkdir -p .java/.userPrefs

USER burp
WORKDIR $HOME

# Burp Proxy
EXPOSE 8080

# Burp REST API
EXPOSE 1337

ENTRYPOINT ["/home/burp/entrypoint.sh", "/home/burp/burpsuite_pro.jar"]
