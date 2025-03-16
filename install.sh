#!/bin/sh
#PBS -q rt_HF
#PBS -N install
#PBS -l select=1:ncpus=192:ngpus=8
#PBS -l walltime=1:00:00
#PBS -j oe
#PBS -koed
#PBS -o outputs/install/

cd $PBS_O_WORKDIR
mkdir -p outputs/install

source /etc/profile.d/modules.sh
module use /home/acf15649kv/modules/modulefiles

module load cuda/12.4
module load cudnn/9.1.1
module load nccl/2.21.5
module load hpcx/2.18.1

source .env/bin/activate

pip install --upgrade pip
pip install --upgrade wheel cmake ninja packaging
pip install torch==2.5.1 --index-url https://download.pytorch.org/whl/cu124
pip install numpy

# DeepGEMM
git submodule update --init --recursive
python setup.py develop
python tests/test_jit.py
