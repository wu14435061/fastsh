#!/bin/bash

# 用法: ./install_conda_env_centos.sh <env_name> <environment.yml>
# 例如: ./install_conda_env_centos.sh myenv environment.yml

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <env_name> <environment.yml>"
    exit 1
fi

ENV_NAME=$1
ENV_YML=$2

# 检查conda是否安装，如未安装则安装Miniconda
if ! command -v conda &> /dev/null; then
    echo "Conda not found. Installing Miniconda..."
    MINICONDA=Miniconda3-latest-Linux-x86_64.sh
    wget https://repo.anaconda.com/miniconda/$MINICONDA -O /tmp/$MINICONDA
    bash /tmp/$MINICONDA -b -p $HOME/miniconda
    eval "$($HOME/miniconda/bin/conda shell.bash hook)"
    conda init
    source ~/.bashrc
else
    echo "Conda detected, skipping Miniconda installation."
    eval "$(conda shell.bash hook)"
fi

# 创建或更新环境
if conda env list | grep -q "^$ENV_NAME\s"; then
    echo "Environment $ENV_NAME already exists. Updating environment..."
    conda env update -n "$ENV_NAME" -f "$ENV_YML"
else
    echo "Creating environment $ENV_NAME..."
    conda env create -n "$ENV_NAME" -f "$ENV_YML"
fi

echo "Conda environment '$ENV_NAME' is ready."