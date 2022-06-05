FROM openjdk:11-jre-slim@sha256:0234799f2639310eb821cf05eb0206e0db946c41e178a9c7a395e82d31b6df37
LABEL maintainer="Koen Rouwhorst <koen@privesc.com>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_PASSWORD

ENV BURP_SUITE_PRO_VERSION="2022.1.1"
ENV BURP_SUITE_PRO_CHECKSUM="5a896484f1e219523cc2564607785021cc1361d7b6ada75cc810966a9430c398"

ENV HOME /home/burp

ENV JAVA_OPTS "-Dawt.useSystemAAFontSettings=gasp "\
  "-Dswing.aatext=true "\
  "-Dsun.java2d.xrender=true" \
  "-XX:+UnlockExperimentalVMOptions "\
  "-XX:+UseCGroupMemoryLimitForHeap "\
  "-XshowSettings:vm"

RUN apt update && apt install -y curl openssl ca-certificates \
  fontconfig libxext6 libxrender1 libxtst6

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
