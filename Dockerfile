##############################################################
##
##
##  Taiga-front
##
##
###############################################################


FROM ruby:2.1.2

MAINTAINER Clayton Santos da Silva <clayton@xdevel.com.br>

RUN apt-get update -y && apt-get install --no-install-recommends -y -q  nodejs npm nginx



RUN (gem install sass scss-lint)
RUN (ln -s /usr/bin/nodejs /usr/bin/node)
RUN (npm install -g gulp bower)

ADD . /taiga-front

#COPY main.coffee /taiga-front/app/config/main.coffee

RUN (cd /taiga-front && npm install)
RUN (cd /taiga-front && bower install --allow-root)
RUN (cd /taiga-front && gulp deploy)

RUN (echo "alias ll='ls -atrhlF'" >> ~/.bashrc)



# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

VOLUME ["/usr/share/nginx/html"]
VOLUME ["/etc/nginx"]
VOLUME ["/var/log/nginx"]



#COPY build/taiga/static /usr/local/nginx/html
COPY taiga.conf /etc/nginx/sites-enabled/default
WORKDIR /usr/local/nginx/html
RUN  (cp -rfvp /taiga-front/dist/* .) 
#RUN  (rm /etc/nginx/sites-enabled/default) 
ENV PATH /usr/local/nginx/sbin:$PATH



EXPOSE 80 8000

CMD ["nginx", "-g", "daemon off;"]