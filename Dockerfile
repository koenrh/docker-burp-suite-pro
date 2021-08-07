FROM openjdk:11-jre-slim@sha256:46285dcf00260440e00dcb68b5432cbed8f5fea734470be6ffb8ac7cc052024b
LABEL maintainer="Koen Rouwhorst <koen@privesc.com>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_PASSWORD

ENV BURP_SUITE_PRO_VERSION="2021.8"
ENV BURP_SUITE_PRO_CHECKSUM="850573d72051142f42e4c041b20bb14d9c50a33aa2499caccefba6507e921a17"

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
