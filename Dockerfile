FROM ruby:2.5.3

ARG uid
ARG gid
ENV UID=${uid}
ENV GID=${gid}

#Add a user for development
RUN adduser -m -l -g $GID -u $UID emonitor --shell /bin/bash --disabled-password -gecos ""

ADD Gemfile /var/www/
ADD Gemfile.lock /var/www/
ADD easy_monitor.gemspec /var/www

RUN chown -R emonitor:emonitor /var/www &&\
  mkdir /var/bundle &&\
  chown -R emonitor:emonitor /var/bundle

RUN su -c "cd /var/www && bundle install --path /var/bundle" -s /bin/bash -l emonitor
ADD . /var/www
RUN chown -R emonitor:emonitor /var/www

USER emonitor

WORKDIR /var/www

CMD ["bundle", "exec", "rspec"]
