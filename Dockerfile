FROM centos:centos6.6
#MAINTAINER	phatnk

#install nginx
#RUN rpm -Uivh http://dl.marmotte.net/rpms/redhat/el6/x86_64/libmaxminddb-1.0.4-1.el6/libmaxminddb-1.0.4-1.el6.x86_64.rpm
#RUN rpm -Uivh http://dl.marmotte.net/rpms/redhat/el6/x86_64/luajit-2.0.4-2.el6/luajit-2.0.4-2.el6.x86_64.rpm
RUN rpm -Uivh http://nginx.org/packages/centos/6/x86_64/RPMS/nginx-1.8.0-1.el6.ngx.x86_64.rpm 

#install php-fpm
RUN yum install -y epel-release
RUN rpm -Uivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
ADD ./kp/remi.repo /etc/yum.repos.d/remi.repo
RUN yum install -y php-fpm

#setup nginx
USER root
RUN rm -rf /etc/nginx/conf.d/default.conf
ADD ./kp/nhacso.conf /etc/nginx/conf.d/
RUN echo "daemon off;" >> /etc/nginx/nginx.conf 
RUN mkdir -p /var/www/nhacso
ADD ./kp/index.php /var/www/nhacso/

#setup php-fpm
RUN sed -i '/daemonize /c \
daemonize = no' /etc/php-fpm.conf

#start service
#CMD /usr/sbin/nginx
ENTRYPOINT /usr/sbin/nginx & /usr/sbin/php-fpm --nodaemonize

EXPOSE 80
