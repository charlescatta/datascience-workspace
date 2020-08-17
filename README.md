# Data Science Workspace (dswp)
DSWP is an opinionated dockerized deep learning workspace with GPU acceleration packages preinstalled.

## Prerequisites
- An Nvidia GPU with Nvidia drivers installed
- [Docker](https://docs.docker.com/get-docker/)
- [NVIDIA Container Toolkit](https://github.com/NVIDIA/nvidia-docker)


## Usage

```bash
$ docker run -d --gpus all --restart always --name my-workspace -p 8888:8888 -v /work:/path/to/your/workdir charlescatta/dswp
```
