FROM nginx:alpine

EXPOSE 4444

COPY ./nginx-selenium.conf /etc/nginx/conf.d

# nginx starts 5 workers by default what's too much for one selenium server.
# So, let's decrease it to 1

# nginx shows a warning about not enough hash size by default. Below command multiplies default
# value to 2

RUN  sed -i -- 's/worker_processes.*;/worker_processes 1;/' /etc/nginx/nginx.conf && \
     sed -i -- 's/types_hash_max_size.*;/types_hash_max_size 4096;/' /etc/nginx/nginx.conf && \
     sed -i -- 's/^user/#user/' /etc/nginx/nginx.conf && \
     sed -i -- 's/listen\(.*\)80;/listen 8081;/' /etc/nginx/conf.d/default.conf && \
     chmod g+rwx /var/cache/nginx /var/run /var/log/nginx && \
     addgroup nginx root

USER nginx
