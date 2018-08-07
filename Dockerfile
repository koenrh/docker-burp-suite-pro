FROM openjdk:8u151-jre-alpine3.7@sha256:8d6f291d02454a43c312b771915c24c1abcf95324de579945a4ac86e4561ac2a
LABEL maintainer "Koen Rouwhorst <info@koenrouwhorst.nl>"

ARG PORTSWIGGER_EMAIL_ADDRESS
ARG PORTSWIGGER_CUSTOMER_NUMBER

ENV BURP_SUITE_PRO_VERSION="1.7.34"
ENV BURP_SUITE_PRO_CHECKSUM="8f556f27cca14fbde5781fbaea5a962fdecb9aba91d6fcb8dd5b42a961d299ed"

ENV HOME /home/burp

# -Dawt.useSystemAAFontSettings=lcd \n\

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

COPY ./download.sh /home/burp/download.sh
RUN chmod +x /home/burp/download.sh
RUN /home/burp/download.sh

#RUN useradd --create-home --shell /bin/sh burp
#RUN adduser --shell /bin/sh burp
RUN addgroup -S burp && adduser -S -G burp burp

#COPY burpsuite_pro_v${BURP_SUITE_PRO_VERSION}.jar /home/burp/burpsuite_pro.jar
RUN mkdir -p .java/.userPrefs

USER burp
WORKDIR $HOME

EXPOSE 8080
ENTRYPOINT java $JAVA_OPTS -jar "$HOME/burpsuite_pro_v$BURP_SUITE_PRO_VERSION.jar"
