FROM ubuntu:latest

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

#Install Cron
RUN apt-get update
RUN apt-get -y install cron curl unzip zip

#Install Rclone
RUN curl https://rclone.org/install.sh | bash

COPY rclone-backup.sh /usr/bin/rclone-backup
RUN chmod +x /usr/bin/rclone-backup

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get -y install nodejs tzdata

RUN npm install -g crontab-ui

ENV HOST 0.0.0.0
ENV PORT 8080

# Run the command on container startup
CMD cron && crontab-ui