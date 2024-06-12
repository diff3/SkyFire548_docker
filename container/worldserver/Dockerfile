FROM ubuntu:24.04

# ENV DEBIAN_FRONTEND=noninteractive
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get install -y libace-dev libmysqlclient-dev libreadline-dev libmysql++-dev

WORKDIR /app/skyfire-server/bin

COPY container/worldserver/entry.sh /
RUN chmod +x /entry.sh
CMD ["/entry.sh"]