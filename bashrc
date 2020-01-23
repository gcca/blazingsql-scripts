#!/bin/bash

function conda-create() {
   local NAME=$1

   conda create -n $NAME python=3.7 -y

   conda activate $NAME && cd $CONDA_PREFIX

   conda install -c conda-forge openjdk=8.0 maven cmake gtest gmock rapidjson cppzmq cython=0.29 jpype1 netifaces pyhive

   conda install -c blazingsql-nightly bsql-toolchain -y

   conda install -c conda-forge openjdk=8.0 maven pyspark=2.4.3 pytest
   pip install pydrill
   pip install openpyxl
   pip install pymysql
   pip install gitpython
   pip install pynvml


   cudf_version=0.11
   rapids_channel=rapidsai-nightly
   cuda_version=10.0

   conda install \
      --yes \
      -c conda-forge \
      -c $rapids_channel/label/cuda$cuda_version librmm=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version rmm=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version libnvstrings=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version nvstrings=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version libcudf=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version cudf=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version dask-cudf=$cudf_version

   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version dask-cuda
}

function conda-go() {
   local NAME=$1
   conda activate $NAME && cd $CONDA_PREFIX
}

function conda-bai() {
   local NAME=$(basename `pwd`)
   ./conda/recipes/$NAME/build.sh
}

function nv-restart() {
   sudo rmmod nvidia_uvm nvidia nvidia_modeset ipmi_msghandler ipmi_devintf nvidiafb -f
   lsmod | ag nv
}

function git-2pk() {
   local NAME=`git remote get-url origin`
   local BASEDIR=$(basename $(dirname $NAME))
   local BASE=$(basename $NAME)
   git remote set-url origin git@github.com:$BASEDIR/$BASE.git
}

function gtl-kp() {
   killall -9 /home/gcca/opt/miniconda2/envs/devb/bin/python3.7 2>/dev/null
   sleep 1
   nvidia-smi
}

function conda-ie2e() {
conda install --yes -c conda-forge openjdk=8.0 maven pyspark=2.4.3 pytest
    pip install pydrill
    pip install openpyxl
    pip install pymysql
    pip install gitpython
    pip install pynvml
 }

function dask-info() {
   python -c "from pprint import pprint;from dask.distributed import Client;c=Client('"$1":8786');pprint(c.scheduler_info())"
}

function e2e_() {
   if [ ${#COMP_WORDS[@]} == '2' ]
   then
      COMPREPLY=($(compgen -d -f ${COMP_WORDS[1]}))
   fi
   if [ ${#COMP_WORDS[@]} != '3' ]
   then
      return
   fi
   NAMES=`ls EndToEndTests | xargs -ix basename x .py`
   COMPREPLY=($(compgen -W "$NAMES" "${COMP_WORDS[2]}"))
}

function e2e() {
   if [ ! -f $1 ]
   then
      echo "Path $1 does not exist or it's not a conf file"
      return
   fi
   python -m EndToEndTests.$2 $1
}
complete -F e2e_ e2e

function cuinstall() {
   cudf_version=0.12
   rapids_channel=rapidsai-nightly
   cuda_version=10.0
   python_version=3.7

   conda install --yes \
      -c $rapids_channel \
      -c nvidia \
      -c conda-forge \
      -c defaults \
      dask-cuda=$cudf_version \
      dask-cudf=$cudf_version \
      cudf=$cudf_version \
      python=$python_version \
      cudatoolkit=$cuda_version

   conda install --yes \
      -c conda-forge \
      openjdk=8.0 \
      maven \
      cmake \
      gtest \
      gmock \
      rapidjson \
      cppzmq \
      cython=0.29 \
      jpype1 \
      netifaces \
      pyhive

   conda install --yes \
      -c conda-forge \
      -c blazingsql-nightly \
      bsql-toolchain
}
