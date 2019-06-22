# Dockerfile for gophernotes with audio ml support

## Build the image
~~~~bash
docker build . -t kai5263499/gophernotes-audio-ml
~~~~

## Run pulseaudio on the docker host
~~~~bash
# Check if pulse audio is running on the host
pulseaudio --check -v
~~~~

~~~~bash
# Start pulse audio daemon on the host allowing anonymous connections from the docker ip range
pulseaudio --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.17.0.0/24 auth-anonymous=1" --exit-idle-time=-1 --daemon
~~~~

## Run the built image
~~~~bash
docker run -it -p 8888:8888 -v ~/code/training-ai/machine-learning-with-go:/notebooks -e PULSE_SERVER=docker.for.mac.localhost -v ~/.config/pulse:/home/pulseaudio/.config/pulse gophernotes-audio-ml
~~~~

## Test pulseaudio setup 

#### Speaker test
~~~~bash
speaker-test -c 2 -l 1 -t wav
~~~~

#### Mic check w/ 2 sec delay
~~~~bash
pacat -r | pacat -p --latency-msec=2000
~~~~

#### Run Jupyter notebook
~~~~bash
jupyter notebook --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ip=0.0.0.0 --allow-root
~~~~