# Wyoming Faster Whisper on ROCm Compatible Devices

A fork from the [original repo](https://github.com/rhasspy/wyoming-faster-whisper) that adds support for inference on ROCm compatible devices.

Tested using docker on a Radeon RX 9060 XT.

## Building

Clone the repo and build the docker image.

```sh
git clone git@github.com:ekdennisek/wyoming-faster-whisper.git .
cd wyoming-faster-whisper
docker build -t my-tag-name .
```

## Running

### Run directly using docker

```sh
docker run --rm -it \
  --device=/dev/kfd --device=/dev/dri \
  --group-add video \
  --security-opt seccomp=unconfined \
  --ipc=host \
  -p 10300:10300 \
  -v "$PWD/whisper-data:/data" \
  my-tag-name \
  --device cuda \
  --compute-type float16 \
  --model KBLab/kb-whisper-medium \
  --language sv
```

### Run using docker compose

```sh
services:
  whisper:
    image: my-tag-name
    build: .
    devices:
      - /dev/kfd
      - /dev/dri
    group_add:
      - video
    security_opt:
      - seccomp=unconfined
    ipc: host
    ports:
      - "10300:10300"
    volumes:
      - ./whisper-data:/data
    command:
      - --device
      - cuda
      - --compute-type
      - float16
      - --model
      - KBLab/kb-whisper-medium
      - --language
      - sv
```
