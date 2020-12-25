FROM openjdk:11-jre-slim@sha256:dff4e41cba98a2d186e8d1505f2762c4701e0e935c62c7ecf3d6ae8fd0bb7410
LABEL maintainer="Koen Rouwhorst <koen@privesc.com>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_PASSWORD

ENV BURP_SUITE_PRO_VERSION="2020.12.1"
ENV BURP_SUITE_PRO_CHECKSUM="f8b6fd763a432adb653802138038e4e92a2839957ec8c7bf5da6ab0e5da76e7d"

ENV HOME /home/burp

ENV JAVA_OPTS "-Dawt.useSystemAAFontSettings=gasp "\
  "-Dswing.aatext=true "\
  "-Dsun.java2d.xrender=true" \
  "-XX:+UnlockExperimentalVMOptions "\
  "-XX:+UseCGroupMemoryLimitForHeap "\
  "-XshowSettings:vm"

RUN apt update && apt install -y curl openssl ca-certificates \
  fontconfig ttf-dejavu libxext6 libxrender1 libxtst6

COPY ./download.sh ./entrypoint.sh /home/burp/
RUN chmod +x /home/burp/download.sh /home/burp/entrypoint.sh && \
  /home/burp/download.sh && \
  mv "$HOME/burpsuite_pro_v$BURP_SUITE_PRO_VERSION.jar" /home/burp/burpsuite_pro.jar

RUN addgroup --system burp && \
  adduser --system --ingroup burp burp

RUN mkdir -p .java/.userPrefs

USER burp
WORKDIR $HOME

# Burp Proxy
EXPOSE 8080

# Burp REST API
EXPOSE 1337

ENTRYPOINT ["/home/burp/entrypoint.sh", "/home/burp/burpsuite_pro.jar"]
