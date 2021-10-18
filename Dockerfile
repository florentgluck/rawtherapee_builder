FROM ubuntu:20.04

ARG INSTALL_DIR
ARG TARBALL
ARG UID
ARG GID

ENV HOME /home/yoda

RUN addgroup --gid $GID yoda && adduser --system --disabled-password --home $HOME --uid $UID --gid $GID yoda
RUN mkdir -p $INSTALL_DIR && chown yoda:yoda $INSTALL_DIR

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential git cmake cmake-extras libgtk-3-dev libgtkmm-3.0-dev liblensfun-dev librsvg2-dev liblcms2-dev libfftw3-dev libiptcdata0-dev libtiff-dev libcanberra-gtk3-dev

WORKDIR $HOME
USER yoda

RUN git clone https://github.com/Beep6581/RawTherapee.git rawtherapee.git && cd rawtherapee.git && mkdir build && cd build && cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR/rawtherapee .. && make && make install

RUN tar fcz $HOME/$TARBALL -C $INSTALL_DIR rawtherapee

CMD install -m 664 $HOME/$TARBALL /shared/$TARBALL
