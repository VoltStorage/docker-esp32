FROM node:latest

MAINTAINER David Bauske <david.bauske@voltstorage.com>

WORKDIR /root

RUN apt-get update
RUN apt-get install -y git wget make libncurses-dev flex bison gperf python python-serial

# Install ESP32 toolchain
RUN mkdir -p /root/esp
WORKDIR /root/esp
RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-61-gab8375a-5.2.0.tar.gz
RUN tar xfvz xtensa-esp32-elf-linux64-1.22.0-61-gab8375a-5.2.0.tar.gz
RUN rm xtensa-esp32-elf-linux64-1.22.0-61-gab8375a-5.2.0.tar.gz

ENV PATH "$PATH:$HOME/esp/xtensa-esp32-elf/bin"
RUN echo "export PATH=$PATH:$HOME/esp/xtensa-esp32-elf/bin" >> /root/.bashrc

# Install ESP-IDF
RUN git clone --recursive https://github.com/espressif/esp-idf.git

ENV IDF_PATH "$HOME/esp/esp-idf"
RUN echo "export IDF_PATH=$HOME/esp/esp-idf" >> ~/.bashrc

WORKDIR /