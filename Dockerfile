FROM mambaorg/micromamba:jammy-cuda-12.1.0

# mambaorg/micromamba defaults to a non-root user. Add a "USER root" to install packages as root:
USER root
#Install ubuntu packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
     apt-get install -y --no-install-recommends \
     build-essential \
     git \
     curl \
     ca-certificates \     
     wget \
     # FFCV Libraries
     pkg-config \
     libturbojpeg0-dev \
     libopencv-dev && \     
     # Remove the effect of `apt-get update`
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Get mamba-user permisions once again     
USER $MAMBA_USER

#Create workdir
WORKDIR /app

COPY environment.yml .

# Create the environment:
RUN micromamba install --yes --name base -f environment.yml
RUN micromamba clean --all --yes

# Activate the environment, 
ARG MAMBA_DOCKERFILE_ACTIVATE=1

RUN git clone https://github.com/libffcv/ffcv.git  

RUN pip install --no-cache ffcv          
