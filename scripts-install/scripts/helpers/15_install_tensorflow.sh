#!/bin/bash

TENSORFLOW_VERSION=${TENSORFLOW_VERSION:-"2.12.*"}
TENSORRT_VERSION=${TENSORRT_VERSION:-"8.6.1"}

install_tensorflow_pip() {
    python3 -m pip install tensorflow==${TENSORFLOW_VERSION}
}

install_tensorrt_pip() {
    python3 -m pip install tensorrt==${TENSORRT_VERSION}
}

verify_tensorflow() {
    python3 -c "import tensorflow as tf; print(tf.__version__)"
}

verify_tensorrt() {
    python3 -c "import tensorrt as trt; print(trt.__version__)"
}

install_tensorflow() {
    install_miniconda

    ## Install TensorFlow
    if ! verify_tensorflow; then
        install_tensorflow_pip
    fi

    ## (optional) Install TensorRT
    if ! verify_tensorrt; then
        install_tensorrt_pip
    fi

    echo "TensorFlow ${TENSORFLOW_VERSION} and TensorRT ${TENSORRT_VERSION} installed"
}
