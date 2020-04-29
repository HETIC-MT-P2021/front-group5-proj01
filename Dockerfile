FROM nginx:alpine

COPY ./app/conf/default.conf /etc/nginx/conf.d/
COPY ./app/public/ /usr/share/nginx/html/

EXPOSE 8000