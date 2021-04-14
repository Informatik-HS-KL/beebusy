FROM google/dart:2.12-beta

WORKDIR /app

ADD pubspec.* /app/
RUN pub get --no-precompile
ADD . /app
RUN pub get --offline --no-precompile

EXPOSE 80

CMD []
ENTRYPOINT ["/usr/bin/dart", "--no-sound-null-safety", "bin/main.dart"]