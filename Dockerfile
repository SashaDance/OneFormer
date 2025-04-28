FROM puzlcloud/pytorch:1.10.1-cuda11.3-cudnn8-jupyter-g1-1.1.0-python3.8

# add user and his password
ARG USER=docker_oneformer
ARG UID=1053
ARG GID=1053
# default password
ARG PW=user
RUN id

# Instal basic utilities
RUN sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends python3.8-dev git wget unzip bzip2 sudo build-essential ca-certificates && \
    sudo apt-get install ffmpeg libsm6 libxext6  -y && \
    sudo apt-get clean && \
    sudo rm -rf /var/lib/apt/lists/*

# Create the user
RUN sudo useradd -m docker_oneformer --uid=1053 && echo "docker_oneformer:user1" | sudo chpasswd && sudo adduser docker_oneformer sudo
RUN id
USER docker_oneformer
WORKDIR /home/docker_oneformer
USER 1053:1053

RUN pip3 install -U opencv-python
RUN pip3.8 install -U pycocotools
RUN pip3 install detectron2 -f https://dl.fbaipublicfiles.com/detectron2/wheels/cu113/torch1.10/index.html
# RUN python3 -m pip install -U 'git+https://github.com/facebookresearch/detectron2.git@ff53992b1985b63bd3262b5a36167098e3dada02'
RUN pip3 install git+https://github.com/cocodataset/panopticapi.git
RUN pip3 install git+https://github.com/mcordts/cityscapesScripts.git
COPY . .
RUN cd OneFormer && \
    pip3 install -r ../requirements.txt && \
    pip3 install wandb