FROM ruby:2-onbuild

RUN apt-get update && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /usr/src/app/source
EXPOSE 4567

CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]
