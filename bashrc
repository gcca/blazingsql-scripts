#!/bin/bash

function repos-st() {
   cd $CONDA_PREFIX
   echo -e '\033[32mblazingdb-io\033[0m'
   cd blazingdb-io
   git st
   cd ..
   echo
   echo -e '\033[32mblazingdb-protocol\033[0m'
   cd blazingdb-protocol
   git st
   cd ..
   echo
   echo -e '\033[32mblazingdb-communication\033[0m'
   cd blazingdb-communication
   git st
   cd ..
   echo
   echo -e '\033[32mblazingdb-calcite\033[0m'
   cd blazingdb-calcite
   git st
   cd ..
   #echo
   #echo -e '\033[32mblazingdb-orchestrator\033[0m'
   #cd blazingdb-orchestrator
   #git st
   #cd ..
   echo
   echo -e '\033[32mblazingdb-ral\033[0m'
   cd blazingdb-ral
   git st
   cd ..
   echo
   echo -e '\033[32mpyBlazing\033[0m'
   cd pyBlazing
   git st
   cd ..
}

function repos-ss() {
   function ps() {
      echo -e '\033[32m'`basename $(pwd)`': \033[33m'`git rev-parse --abbrev-ref HEAD`'\033[0m'
   }
   for dir in $CONDA_PREFIX/blazingdb-io ../blazingdb-communication ../blazingdb-calcite ../blazingdb-ral ../pyBlazing
   do
      cd $dir
      ps
   done
   cd ..
}

function repos-hs() {
   function ps() {
      echo -e '\033[32m'`basename $(pwd)`' \033[33m'`git rev-parse HEAD`'\033[0m'
   }
   for dir in $CONDA_PREFIX/blazingdb-io ../blazingdb-communication ../blazingdb-calcite ../blazingdb-ral ../pyBlazing
   do
      cd $dir
      ps
   done
   cd ..
}

function repos-c() {
   for dir in $CONDA_PREFIX/blazingdb-io ../blazingdb-communication ../blazingdb-calcite ../blazingdb-ral ../pyBlazing
   do
      cd $dir
      git $1
   done
   cd ..
}

function repos-pldev() {
   cd $CONDA_PREFIX
   echo blazingdb-io
   cd blazingdb-io
   git co develop
   git pl
   cd ..
   echo
   echo blazingdb-protocol
   cd blazingdb-protocol
   git co develop
   git pl
   cd ..
   echo
   echo blazingdb-communication
   cd blazingdb-communication
   git co develop
   git pl
   cd ..
   echo
   echo blazingdb-calcite
   cd blazingdb-calcite
   git co develop
   git pl
   cd ..
   echo
   echo blazingdb-orchestrator
   cd blazingdb-orchestrator
   git co develop
   git pl
   cd ..
   echo
   echo blazingdb-ral
   cd blazingdb-ral
   git co develop
   git pl
   cd ..
   echo
   echo pyBlazing
   cd pyBlazing
   git co develop
   git pl
   cd ..
}

function repos-pl() {
   cd $CONDA_PREFIX
   for dir in blazingdb-io blazingdb-communication blazingdb-calcite blazingdb-ral pyBlazing
   do
      echo -e "\033[32m$dir\033[0m"
      cd $dir
      git pl --no-edit
      cd ..
   done
}

function repos-build() {
   cd $CONDA_PREFIX
   echo blazingdb-io
   cd blazingdb-io/build
   make -j4 blazingdb-io
   [[ $? -ne 0 ]] && return
   make install
   [[ $? -ne 0 ]] && return
   cd ../..
   echo
   echo blazingdb-protocol
   cd blazingdb-protocol/build
   make -j4 blazingdb-protocol
   [[ $? -ne 0 ]] && return
   make install
   [[ $? -ne 0 ]] && return
   cd ../..
   echo
   echo blazingdb-communication
   cd blazingdb-communication/build
   make -j4 blazingdb-transport
   [[ $? -ne 0 ]] && return
   # blazingdb-manager
   make install
   [[ $? -ne 0 ]] && return
   cd ../..
   echo
   echo blazingdb-calcite
   cd blazingdb-calcite
   rm */target -r
   mvn clean compile
   [[ $? -ne 0 ]] && return
   cd ..
   echo
   echo blazingdb-orchestrator
   cd blazingdb-orchestrator/build
   make -j4 blazingdb_orchestator_service
   [[ $? -ne 0 ]] && return
   cd ../..
   echo
   echo blazingdb-ral
   cd blazingdb-ral/build
   make -j4 testing-libgdf
   [[ $? -ne 0 ]] && return
   cd ../..
   echo
   #echo pyBlazing
   #cd pyBlazing
   #git co develop
   #git pl
   #cd ..
}

function repos-conbi() {
   cd $CONDA_PREFIX
   #for dir in blazingdb-io blazingdb-communication blazingdb-calcite blazingdb-ral pyBlazing
   #do
      #cd $dir
      #git st
      #cd ..
   #done
   #return
   for dir in blazingdb-io blazingdb-communication blazingdb-calcite
   do
      local hl=`printf '=%.0s' $(seq $(($(echo $dir | wc -c)-1)))`
      echo -e "\033[33m$hl\n\033[1;37;42m$dir\n\r\033[0;33m$hl\033[0m"
      cd $dir
      nf=(conda/recipes/*)
      if [ 1 -ne ${#nf[@]} ]; then
         echo "ERROR $dir"
         cd ..
         return -1
      fi
      bash conda/recipes/*/build.sh
      [[ $? -ne 0 ]] && return -1
      cd ..
   done
   local dir=blazingdb-ral
   local hl=`printf '=%.0s' $(seq $(($(echo $dir | wc -c)-1)))`
   echo -e "\033[33m$hl\n\033[1;37;42m$dir\n\r\033[0;33m$hl\033[0m"
   cd $dir
   bash conda/recipes/libbsql-engine/build.sh
   [[ $? -ne 0 ]] && return -1
   bash conda/recipes/bsql-engine/build.sh
   [[ $? -ne 0 ]] && return -1
   cd ..
   local dir=pyBlazing
   local hl=`printf '=%.0s' $(seq $(($(echo $dir | wc -c)-1)))`
   echo -e "\033[33m$hl\n\033[1;37;42m$dir\n\r\033[0;33m$hl\033[0m"
   cd $dir
   bash conda/recipes/blazingsql/build.sh
   [[ $? -ne 0 ]] && return -1
   cd ..
}

function repos-co() {
   cd $CONDA_PREFIX
   for dir in blazingdb-io blazingdb-communication blazingdb-calcite blazingdb-ral pyBlazing
   do
      echo 'adasmdamdkasmdsalda'
   done
}

function conda-create() {
   local NAME=$1

   conda create -n $NAME python=3.7 -y

   conda activate $NAME && cd $CONDA_PREFIX

   conda install -c conda-forge openjdk=8.0 maven cmake gtest gmock rapidjson cppzmq cython=0.29 jpype1 netifaces pyhive

   #conda install -c conda-forge -c rapidsai-nightly/label/cuda10.0 cudf=0.10 -y
   #conda install -c rapidsai-nightly/label/cuda10.0 dask-cudf=0.10 -y

   conda install -c blazingsql-nightly bsql-toolchain -y

   #conda install -c conda-forge -c rapidsai -c blazingsql -c blazingsql/label/cuda10.0 blazingsql-dev -y

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

function conda-icudf() {
   cudf_version=0.11
   rapids_channel=rapidsai-nightly
   cuda_version=10.0

   conda install \
      --yes \
      -c conda-forge \
      -c $rapids_channel/label/cuda$cuda_version \
      librmm=$cudf_version
   conda install \
      --yes \
      -c conda-forge \
      -c $rapids_channel/label/cuda$cuda_version \
      rmm=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version libnvstrings=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version nvstrings=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version libcudf=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version cudf=$cudf_version
   conda install --yes -c conda-forge -c $rapids_channel/label/cuda$cuda_version dask-cudf=$cudf_version
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
