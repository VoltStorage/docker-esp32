FROM ubuntu:bionic

# This installs the ESP32 IDF with the xtensa toolchain.
MAINTAINER David Bauske <david.bauske@voltstorage.com>

WORKDIR /root

RUN apt-get update
RUN apt-get install -y git wget libncurses-dev flex bison gperf python python-pip python-setuptools python-serial python-cryptography python-future python-pyparsing cmake ninja-build ccache g++ curl software-properties-common

# install node
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# Install ESP32 toolchain
RUN mkdir -p /root/esp
WORKDIR /root/esp
RUN wget https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
RUN tar xfvz xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
RUN rm xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz

ENV PATH "$PATH:/root/esp/xtensa-esp32-elf/bin"
RUN echo "export PATH=$PATH:/root/esp/xtensa-esp32-elf/bin" >> /root/.bashrc

# Install ESP-IDF
RUN git clone -b release/v3.3 --recursive https://github.com/espressif/esp-idf.git
WORKDIR /root/esp/esp-idf

# The new CMake-based build system of ESP-IDF aggressively checks the compiler and doesn't allow us to use
# any other compiler than their "xtensa" models. We'll stop this check from failing the build by replacing
# the severity level ...
RUN sed -i -e 's/FATAL_ERROR/WARNING/g' tools/cmake/idf_functions.cmake

ENV IDF_PATH "/root/esp/esp-idf"
RUN echo "export IDF_PATH=/root/esp/esp-idf" >> /root/.bashrc

# Install Python dependencies
RUN python2 -m pip install --user -r $IDF_PATH/requirements.txt

# Install clang-format, version 11
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository "deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic  main"
RUN apt update
RUN apt install -y clang-format clang-format-11

WORKDIR /
