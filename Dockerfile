# Base image -> https://github.com/runpod/containers/blob/main/official-templates/base/Dockerfile
# DockerHub -> https://hub.docker.com/r/runpod/base/tags
FROM runpod/base:0.4.0-cuda12.1.0

# Define build-time arguments
ARG GH_ORG
ARG GH_EMAIL
ARG HUGGINGFACE_PAT

# Add src files (Worker Template)
ADD src .

# --- Download the model from hf ---
COPY builder/download_model.sh /download_model.sh
RUN /bin/bash /download_model.sh && \
    rm /download_model.sh

# Python dependencies
COPY builder/requirements.txt /requirements.txt
RUN python3.11 -m pip install --upgrade pip && \
    python3.11 -m pip install --upgrade -r /requirements.txt --no-cache-dir && \
    rm /requirements.txt

CMD python3.11 -u /handler.py
