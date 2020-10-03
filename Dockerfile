FROM	debian:buster

LABEL	maintainer="daelee@student.42seoul.kr"

RUN	apt-get update && apt-get install -y \
	nginx \
	mariadb-server \
	php-mysql \
	php-mbstring \
	openssl \
	vim \
	wget \
	php7.3-fpm \

