image:
	docker rmi -f kai5263499/gophernotes-audio-ml; true
	docker build -t kai5263499/gophernotes-audio-ml .

run-notebook-daemon:
	docker rm -f gophernotes-audio-ml; true
	docker run -d --name gophernotes-audio-ml -p 8889:8888 \
	-v ~/code/deproot/src/github.com/kai5263499/diy-jarvis:/go/src/github.com/kai5263499/diy-jarvis \
	-v ~/code/pais:/pais \
	-v ${PWD}:/go/src/github.com/kai5263499/gophernotes-audio-ml \
	-e PULSE_SERVER=docker.for.mac.localhost -v ~/.config/pulse:/home/pulseaudio/.config/pulse \
	kai5263499/gophernotes-audio-ml

exec-interactive:
	docker exec -it --user root gophernotes-audio-ml bash

.PHONY: image run-notebook-daemon interactive-test