FROM openjdk:8u151-jre-alpine3.7@sha256:8d6f291d02454a43c312b771915c24c1abcf95324de579945a4ac86e4561ac2a
LABEL maintainer "Koen Rouwhorst <info@koenrouwhorst.nl>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_CUSTOMER_NUMBER

ENV BURP_SUITE_PRO_VERSION="1.7.37"
ENV BURP_SUITE_PRO_CHECKSUM="490c1b2abfe7f85e4eb62659b2e4be2a8d894d095a69d91fe4ee129ef6f8e68b"

ENV HOME /home/burp

ENV JAVA_OPTS "-Dawt.useSystemAAFontSettings=gasp "\
  "-Dswing.aatext=true "\
  "-Dsun.java2d.xrender=true "\
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

EXPOSE 8080

ENTRYPOINT ["/home/burp/entrypoint.sh", "/home/burp/burpsuite_pro.jar"]
