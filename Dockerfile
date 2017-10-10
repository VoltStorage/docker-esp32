FROM ubuntu:xenial

MAINTAINER David Bauske <david.bauske@voltstorage.com>

WORKDIR /root

RUN apt-get update
RUN apt-get install -y git wget make libncurses-dev flex bison gperf python python-serial cmake g++

# install node
RUN \
  cd /tmp && \
  wget http://nodejs.org/dist/node-latest.tar.gz && \
  tar xvzf node-latest.tar.gz && \
  rm -f node-latest.tar.gz && \
  cd node-v* && \
  ./configure && \
  CXX="g++ -Wno-unused-local-typedefs" make && \
  CXX="g++ -Wno-unused-local-typedefs" make install && \
  cd /tmp && \
  rm -rf /tmp/node-v* && \
  npm install -g npm && \
  printf '\n# Node.js\nexport PATH="node_modules/.bin:$PATH"' >> /root/.bashrc

# Install ESP32 toolchain
RUN mkdir -p /root/esp
WORKDIR /root/esp
RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-73-ge28a011-5.2.0.tar.gz
RUN tar xfvz xtensa-esp32-elf-linux64-1.22.0-73-ge28a011-5.2.0.tar.gz
RUN rm xtensa-esp32-elf-linux64-1.22.0-73-ge28a011-5.2.0.tar.gz

ENV PATH "$PATH:/root/esp/xtensa-esp32-elf/bin"
RUN echo "export PATH=$PATH:/root/esp/xtensa-esp32-elf/bin" >> /root/.bashrc

# Install ESP-IDF
RUN git clone --recursive https://github.com/espressif/esp-idf.git

ENV IDF_PATH "/root/esp/esp-idf"
RUN echo "export IDF_PATH=/root/esp/esp-idf" >> ~/.bashrc

WORKDIR /
