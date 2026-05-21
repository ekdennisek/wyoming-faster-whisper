FROM rocm/pytorch:rocm7.2.3_ubuntu24.04_py3.12_pytorch_release_2.10.0

ENV PATH="/opt/venv/bin:${PATH}"

WORKDIR /usr/src

ARG CT2_VERSION=4.7.2
RUN curl -fL -o /tmp/ct2-rocm.zip \
      "https://github.com/OpenNMT/CTranslate2/releases/download/v${CT2_VERSION}/rocm-python-wheels-Linux.zip" \
 && python3 -m zipfile -e /tmp/ct2-rocm.zip /tmp/ct2 \
 && pip install --no-cache-dir \
      "/tmp/ct2/temp-linux/ctranslate2-${CT2_VERSION}-cp312-cp312-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl" \
 && rm -rf /tmp/ct2 /tmp/ct2-rocm.zip

COPY ./pyproject.toml ./
RUN pip install --no-cache-dir -U setuptools wheel \
 && pip install --no-cache-dir -e '.[zeroconf,transformers,sherpa,onnx-asr]'

COPY ./ ./

EXPOSE 10300

ENTRYPOINT ["bash", "docker_run.sh"]
