# Build: docker build -t project_name .
# Build: docker build -t myenv .
# Run: docker run -v $(pwd):/workspace/project --gpus all -it --rm project_name
# Run: docker run -v $(pwd):/workspace/project --gpus all -it --rm myenv

FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04


# Basic setup
RUN apt update && \
    apt install -y bash \
                   build-essential \
                   git \
                   curl \
                   ca-certificates \
                   python3.8 \
                   python3-pip && \
    rm -rf /var/lib/apt/lists


# Set working directory
WORKDIR /workspace/project


# Install requirements
RUN cd /workspace/project
COPY requirements.txt ./
RUN python3 -m pip3 install -r requirements.txt


# Install Apex for mixed-precision training
RUN cd .. \
    git clone https://github.com/NVIDIA/apex
RUN cd apex && \
    python3 setup.py install && \
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./


CMD ["/bin/bash"]
