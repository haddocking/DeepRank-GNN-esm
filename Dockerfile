#===============================================================================================
FROM continuumio/anaconda3:2023.03-1 as base

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential

WORKDIR /opt/software

RUN git clone https://github.com/haddocking/DeepRank-GNN-esm.git

WORKDIR /opt/software/DeepRank-GNN-esm
# TEMPORARY FIX
RUN git checkout cli
# END TEMPORARY FIX

#===============================================================================================
FROM base as cpu

RUN conda env create -f environment-cpu.yml -n env
SHELL ["conda", "run", "-n", "env", "/bin/bash", "-c"]
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

RUN source activate env
RUN pip install .
#===============================================================================================
FROM base as gpu

RUN conda env create -f environment-cpu.yml -n env
SHELL ["conda", "run", "-n", "env", "/bin/bash", "-c"]
RUN echo "source activate env" > ~/.bashrc
ENV PATH /opt/conda/envs/env/bin:$PATH

RUN source activate env
RUN pip install .
#===============================================================================================

# docker run -v "$(pwd)":/opt/software/DeepRank-GNN-esm --rm ci-cd.science.uu.nl/deeprank-gnn-esm  deeprank-gnn-esm-predict 2OOB.pdb