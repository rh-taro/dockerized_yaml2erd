FROM ruby:2.5.1

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - &&\
    apt-get update -qq &&\
    apt-get install -y build-essential graphviz task-japanese fonts-ipafont fonts-noto-cjk
ENV TZ=Asia/Tokyo

WORKDIR /usr/src/yaml2erd
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install

CMD ["/bin/sh"]
