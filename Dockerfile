##############################################################
##
##
##  Taiga-front
##
##
###############################################################


FROM ruby:2.1.2

MAINTAINER Clayton Santos da Silva <clayton@xdevel.com.br>

RUN apt-get update -y && apt-get install --no-install-recommends -y -q  nodejs npm



RUN (gem install sass scss-lint)
RUN (ln -s /usr/bin/nodejs /usr/bin/node)
RUN (npm install -g gulp bower)

ADD . /taiga-front

#COPY main.coffee /taiga-front/app/config/main.coffee

RUN (cd /taiga-front && npm install)
RUN (cd /taiga-front && bower install --allow-root)
RUN (cd /taiga-front && gulp deploy)

RUN (echo "alias ll='ls -atrhlF'" >> ~/.bashrc)

VOLUME /taiga

CMD mv /taiga-front/dist /taiga