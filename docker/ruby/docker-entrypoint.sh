#!/bin/bash

if [[ $1 = "start" ]]; then
  mkdir -p /app/tmp/sockets /app/tmp/pids
  rm -f /app/tmp/sockets/* /app/tmp/pids/*

  bundle install --path vendor/bundle
  yarn install

  bundle exec rails webpacker:compile

  cp -rv /app/public/* /var/www/

  if [ -d /stanza ]; then
    rm -rf /stanza/dist/stanza /var/www/stanza

    ts build -stanza-base-dir /stanza
    cp -rv /stanza/dist/stanza /var/www/
  fi

  echo
  echo "start unicorn..."

  bundle exec unicorn --env production -c config/unicorn.rb
else
  exec "$@"
fi
