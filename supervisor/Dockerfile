FROM centos:7
RUN yum update -y && \
  rpm -Uvh https://www.andrisoft.com/files/redhat7/WANrepo-6.3-0.noarch.rpm \
  && yum install -y WANsensor WANfilter \
  && yum clean all && rm -rf /var/cache/yum

VOLUME [ "/opt/andrisoft/dumps/", "/opt/andrisoft/flows/"]

COPY startup.sh /startup.sh
RUN chmod +x /startup.sh
CMD ["/startup.sh"]