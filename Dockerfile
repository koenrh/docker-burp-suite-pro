FROM openjdk:11-jre-slim@sha256:46285dcf00260440e00dcb68b5432cbed8f5fea734470be6ffb8ac7cc052024b
LABEL maintainer="Koen Rouwhorst <koen@privesc.com>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_PASSWORD

ENV BURP_SUITE_PRO_VERSION="2021.4.3"
ENV BURP_SUITE_PRO_CHECKSUM="df1979a9beaf60ed92c3e67af729d51422d4c39ca226545703652dbe466747a3"

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
