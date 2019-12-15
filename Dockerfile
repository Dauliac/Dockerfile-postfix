FROM ubuntu:bionic

EXPOSE 25

ENV MAILNAME dmic.example.com
ENV MY_NETWORKS 172.17.0.0/16 127.0.0.0/8
ENV MY_DESTINATION localhost.localdomain, localhost

RUN  apt update \
    && apt --yes install postfix vim supervisor rsyslog

# We disable IPv6 for now, IPv6 is available in Docker even if the host does not have IPv6 connectivity.
RUN postconf -# sms.dmic.dmz \
    && postconf -e inet_protocols=ipv4 \
    && postconf -e mail_spool_directory="/var/spool/mail/" \
    && touch /var/log/mail.log

COPY conf/supervisord.conf /etc/supervisord.conf
COPY conf/rsyslog.conf /etc/rsyslog.conf
#COPY conf/postfix.conf /etc/postfix/main.cf

CMD supervisord -c /etc/supervisord.conf
