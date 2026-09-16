FROM nvidia/cuda:12.8.1-cudnn-runtime-ubuntu24.04 as gpu

WORKDIR /app

RUN apt-get update -y && \
  apt-get install -y python3 python3-pip python3-venv portaudio19-dev && \
  rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements-gpu* /app/
RUN pip install --upgrade pip setuptools wheel && \
  pip install -r /app/requirements-gpu-torch.txt && \
  pip install -r /app/requirements-gpu.txt

RUN mkdir example_browserclient
COPY example_browserclient/server.py /app/example_browserclient/server.py
COPY RealtimeSTT /app/RealtimeSTT

EXPOSE 9001
ENV PYTHONPATH="/app:${PYTHONPATH}"
CMD ["python3", "example_browserclient/server.py"]

# --------------------------------------------

FROM ubuntu:24.04 as cpu

WORKDIR /app

RUN apt-get update -y && \
  apt-get install -y python3 python3-pip python3-venv portaudio19-dev && \
  rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt /app/requirements.txt
RUN pip install --upgrade pip setuptools wheel && \
  pip install -r /app/requirements.txt

EXPOSE 9001
ENV PYTHONPATH="/app:${PYTHONPATH}"
CMD ["python3", "example_browserclient/server.py"]
