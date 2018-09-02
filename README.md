## Dockerfile for gophernotes with audio ml support

install jupyter for go OR build the docker image for jupyter with go 
in this folder
```
$ cd 

$ docker build . -t kai5263499/gophernotes-audio-ml
```

Run the built image

```
$ docker run -it -p 8888:8888 -v /PATH/TO/LOCAL/PROJECT/training-ai:/go/src/training-ai  kai5263499/gophernotes-audio-ml

```