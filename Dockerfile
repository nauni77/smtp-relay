#Dockerfile for a Postfix email relay service
FROM centos:7
MAINTAINER Juan Luis Baptiste juan.baptiste@gmail.com

RUN yum install -y epel-release && yum update -y && \
    yum install -y cyrus-sasl cyrus-sasl-plain cyrus-sasl-md5 mailx nc \
    perl supervisor postfix rsyslog \
    && rm -rf /var/cache/yum/* \
    && yum clean all
RUN sed -i -e "s/^nodaemon=false/nodaemon=true/" /etc/supervisord.conf
RUN sed -i -e 's/inet_interfaces = localhost/inet_interfaces = all/g' /etc/postfix/main.cf



COPY etc/*.conf /etc/
COPY etc/rsyslog.d/* /etc/rsyslog.d
COPY run.sh /
RUN chmod +x /run.sh
COPY usr/local/bin/* /usr/local/bin/
RUN chmod +x /run.sh

COPY etc/supervisord.d/*.ini /etc/supervisord.d/
RUN newaliases

RUN rm /var/log/maillog
# try redirect maillog to docker output!
# RUN rm /var/log/maillog \
#     && ln -s /dev/stdout /var/log/maillog

EXPOSE 25
#ENTRYPOINT ["/run.sh"]

# HEALTHCHECK --interval=5s --timeout=3s --retries=3 \
#     CMD nc -zv 127.0.0.1 25 || exit 1

CMD ["/run.sh"]