FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ENV INSTALL_DIR=/opt

RUN apt update && apt install -y build-essential git cmake cmake-extras libgtk-3-dev libgtkmm-3.0-dev liblensfun-dev librsvg2-dev liblcms2-dev libfftw3-dev libiptcdata0-dev libtiff-dev libcanberra-gtk3-dev

WORKDIR /home/

RUN git clone https://github.com/Beep6581/RawTherapee.git rawtherapee.git && cd rawtherapee.git && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/rawtherapee .. && make && make install

RUN tar fcz /home/rawtherapee.tar.gz -C $INSTALL_DIR rawtherapee
RUN mkdir /shared

CMD install -m 664 /home/rawtherapee.tar.gz /shared
