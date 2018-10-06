## Dockerfile for gophernotes with audio ml support

install jupyter for go OR build the docker image for jupyter with go 
in this folder
```
$ docker build . -t kai5263499/gophernotes-audio-ml
```

Run the built image

```
$ docker run -d --name gophernotes-audio-ml -p 8888:8888 -v /PATH/TO/gophernotes-audio-ml:/go/src/training-ai  kai5263499/gophernotes-audio-ml
```