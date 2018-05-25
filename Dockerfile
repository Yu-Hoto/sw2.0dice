FROM ruby:2.4.1

WORKDIR /sw2.0dice
COPY . /sw2.0dice

RUN brew update && brew install -y \
      libopus-dev \
      libsodium-dev \
      wget \
      xz-utils
RUN wget http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz \
      && tar Jxvf ./ffmpeg-release-64bit-static.tar.xz \
      && cp ./ffmpeg*64bit-static/ffmpeg /usr/local/bin/
RUN bundle install

CMD ["ruby", "main.rb"]

