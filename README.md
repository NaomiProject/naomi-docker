
# Naomi Docker

Naomi, dockerized. 

This is the best way to install Naomi quickly and easily without altering the host system.

## Prerequisites

You need to install Docker on your host, [see instructions here](https://docs.docker.com/engine/install/). 

Docker desktop **isn't** required. 

You also need [Pipewire](https://pipewire.org/) as your host's sound server, at least **v1.0.7** on your device to use this container. 

Raspberry Pi OS 12 (Bookworm) should be fine, since Pipewire is the new audio server by default since then. 

To check if this is the case, use `pactl info` in your favourite terminal, if you see `PulseAudio (on PipeWire 1.0.7)` you're good, otherwise you'll need to find 
the right instructions to install and enable it on your device. 

## Production 

### Run Naomi docker 

#### Classic method
To start a container based on the image available on DockerHub :

```shell
docker run -it -d --name naomi-docker
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 
    -v /host/path/to/config:/config/
    --env XDG_RUNTIME_DIR=/tmp 
    tuxseb/naomi-test:latest 
```

#### Docker compose 

You can also use the provided docker compose file, `docker-compose.yml`.  

```shell
docker compose up
```

### Audio Setup 

⚠️ On setup, use both audio input & output labeled `pipewire`, It'll use the microphone and speakers you picked on your host.

Your `profile.yaml` entry for audio should look like this : 
```shell
audio:
  input_chunksize: '1024'
  input_device: pipewire
  input_rate: '16000'
  output_device: pipewire
```

## Development 

If you want to build the image by yourself for development purposes or out of curiosity, here are the instructions.

### Build image

Clone this repository on your device and then:

```Docker build --tag naomi-docker .```

Then launch Naomi with :

```shell
docker run -it -d --name naomi-docker
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 
    -v /host/path/to/config:/config/
    --env XDG_RUNTIME_DIR=/tmp 
    naomi-docker 
```

See the setup part above for sound configuration with Pipewire. 

### Multi arch build 

To build multi architectures images locally (amd64, armv7, arm64...), you need to use [Docker Buildx](https://github.com/docker/buildx), 
here's a tutorial [to set it up on your machine](https://www.baeldung.com/ops/docker-buildx). 

Once done, use: 

```docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --push --tag <Dockerhub repository> .```

Take note that you can change the platform argument following your needs.
Depending on your CPU, it may take a while since Buildx needs to emulate the target architectures locally. # naomi-docker
Naomi, dockerized. 
