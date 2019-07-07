FROM debian:sid-slim

LABEL MAINTAINER Wes Widner <kai5263499@gmail.com>

# Based on https://github.com/ardanlabs/training-ai/tree/master/etc/gophernotesDocker

# gopher user
ENV NB_USER gopher
ENV NB_UID 1000
RUN set -x \
    && useradd -rm -d /home/${NB_USER} -s /bin/bash -g root -G sudo -u ${NB_UID} ${NB_USER} \
    && mkdir /home/$NB_USER/work \
    && mkdir /home/$NB_USER/.jupyter \
    && mkdir /home/$NB_USER/.local \
    && mkdir -p /home/$NB_USER/.local/share/jupyter/kernels/gophernotes

# Install pulseaudio
RUN set -x && \
    apt-get update && apt-get install -y --no-install-recommends \
    alsa-utils \
    ca-certificates \
    libasound2 libasound2-plugins \
    pulseaudio pulseaudio-utils portaudio19-dev \
    libportmidi0 libportmidi-dev \
    gcc automake autoconf libtool git make direnv \
    libespeak-ng1 libespeak-ng-dev espeak-ng-data espeak-ng \
    sox swig ffmpeg curl pkg-config libatlas-base-dev

# environment variables
ENV CGO_ENABLED=1 CGO_CPPFLAGS="-I/usr/include"
ENV GOPATH=/go
ENV PATH=/go/bin:$PATH

RUN set -x \
&& apt-get update \
&& apt-get install -y python3 python3-pip \
    jupyter-notebook ca-certificates \
    pkg-config libzmq5 libzmq3-dev \
    golang go-dep \
    libsptk-dev libosptk4 sptk \
    ca-certificates libzmq5 libzmq3-dev pkg-config \
    python3-numpy python-h5py \
    python3-pyaudio libsdl-ttf2.0-0 python3-pygame \
&& git clone --depth 1 https://github.com/gopherdata/gophernotes.git /go/src/github.com/gopherdata/gophernotes \
&& go install github.com/gopherdata/gophernotes \
&& mkdir -p /go/src/github.com/xigh \
&& git clone --depth 1 https://github.com/xigh/spectrogram /go/src/github.com/xigh/spectrogram

# install gophernotes
RUN set -x \
    && go get -insecure github.com/pebbe/zmq4 \
    && go get github.com/gopherdata/gophernotes \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cp -r /go/src/github.com/gopherdata/gophernotes/kernel/* /home/$NB_USER/.local/share/jupyter/kernels/gophernotes

# # get the relevant Go packages
RUN set -x \
    && go get -insecure gonum.org/v1/plot/... \
    && go get -insecure gonum.org/v1/gonum/... \
    && go get github.com/kniren/gota/... \
    && go get github.com/sajari/regression \
    && go get github.com/sjwhitworth/golearn/... \
    && go get -insecure go-hep.org/x/hep/csvutil/... \
    && go get -insecure go-hep.org/x/hep/fit \
    && go get -insecure go-hep.org/x/hep/hbook \
    && go get github.com/montanaflynn/stats \
    && go get github.com/boltdb/bolt \
    && go get github.com/patrickmn/go-cache \
    && go get github.com/chewxy/math32 \
    && go get gonum.org/v1/gonum/mat \
    && go get github.com/chewxy/hm \
    && go get -u gorgonia.org/gorgonia \
    && go get -u gorgonia.org/vecf64 \
    && go get -u gorgonia.org/vecf32 \
    && go get github.com/awalterschulze/gographviz \
    && go get github.com/leesper/go_rng \
    && go get github.com/pkg/errors \
    && go get github.com/stretchr/testify/assert \
    && go get github.com/kniren/gota/dataframe \
    && go get github.com/skelterjohn/go.matrix \
    && go get github.com/gonum/matrix/mat64 \
    && go get github.com/gonum/stat \
    && go get github.com/mash/gokmeans \
    && go get github.com/garyburd/go-oauth/oauth \
    && go get github.com/machinebox/sdk-go/textbox \
    && go get github.com/go-audio/aiff \
    && go get github.com/go-audio/audio \
    && go get github.com/go-audio/wav \
    && go get github.com/mjibson/go-dsp/fft \
    && go get github.com/mjibson/go-dsp/spectral \
    && go get github.com/mjibson/go-dsp/window \
    && go get github.com/mjibson/go-dsp/wav \
    && go get github.com/mattetti/audio/decoder \
    && go get github.com/r9y9/gossp/io \
    && go get github.com/r9y9/gossp/window \
    && go get github.com/r9y9/gossp/stft \
    && go get github.com/davecgh/go-spew/spew \
    && go get github.com/brentnd/go-snowboy \
    && go get github.com/gordonklaus/portaudio \
    && go get github.com/r9y9/gossp

# Install SPTK
RUN set -x \
&& git clone https://github.com/r9y9/SPTK.git && cd SPTK \
&& ./waf configure && ./waf \
&& ./waf install

# Install python packages
RUN set -x \
&& pip3 install tensorflow keras \
    flask flask_socketio python_speech_features \
    spidev librosa matplotlib pandas python-pptx \
    tqdm tensorboard sklearn scikit-learn

# Fix permissions
RUN set +x \
&& chown -R ${NB_USER} /go \
&& chown -R ${NB_USER} /home/${NB_USER}

USER gopher

WORKDIR /go

EXPOSE 8888
CMD [ "jupyter", "notebook", "--no-browser", "--ip=0.0.0.0",  "--NotebookApp.token=''", "--NotebookApp.disable_check_xsrf=True", "--notebook-dir=/go/src/github.com/kai5263499/gophernotes-audio-ml/notebooks" ]
