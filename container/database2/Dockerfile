FROM mysql:8.4

# ENV DEBIAN_FRONTEND=noninteractive
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# RUN apt-get update && apt-get -y install tzdata unzip wget

COPY container/database/entry.sh /docker-entrypoint-initdb.d
