FROM ubuntu:xenial

MAINTAINER David Bauske <david.bauske@voltstorage.com>

WORKDIR /root

RUN apt-get update
RUN apt-get install -y git wget make libncurses-dev flex bison gperf python python-serial cmake g++

# install node
RUN \
  cd /tmp && \
  wget https://nodejs.org/dist/v8.9.1/node-v8.9.1.tar.gz && \
  tar xvzf node-v8.9.1.tar.gz && \
  rm -f node-v8.9.1.tar.gz && \
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
WORKDIR /root/esp/esp-idf
RUN git checkout -b v2.1 origin/release/v2.1
RUN git submodule update

ENV IDF_PATH "/root/esp/esp-idf"
RUN echo "export IDF_PATH=/root/esp/esp-idf" >> ~/.bashrc

WORKDIR /
