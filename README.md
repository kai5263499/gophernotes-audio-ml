# Dockerfile for gophernotes with audio ml support

## Build the image
~~~~bash
make image
~~~~

## Run pulseaudio on the docker host
~~~~bash
# Check if pulse audio is running on the host
pulseaudio --check -v

# Start pulse audio daemon on the host allowing anonymous connections from the docker ip range
pulseaudio --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.17.0.0/24 auth-anonymous=1" --exit-idle-time=-1 --daemon
~~~~

## Run the built image
~~~~bash
# Run the notebook as a server daemon. You will likely need to change the volume mounts as these are tied to my development setup
make run-notebook-daemon

# Exec into the running notebook. This is useful for collecting recordings or testing out scripts
make exec-interactive
~~~~

## Test pulseaudio setup 

Here are a few commands I've found helpful to test the audio setup.

~~~~bash
# Speaker test
speaker-test -c 2 -l 1 -t wav

# Mic check w/ 2 sec delay
pacat -r | pacat -p --latency-msec=2000

# Record raw audio from the default pulseaudio source without silence detection
arecord -vv -fdat simple_recording.wav

# Record raw audio from the default pulseaudio source with silence detection
sox -t alsa default recording_with_silence_detection.wav silence 1 0.1 5% 1 1.0 5%
~~~~

#### Run Jupyter notebook
~~~~bash
jupyter notebook --no-browser --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True --ip=0.0.0.0 --allow-root
~~~~