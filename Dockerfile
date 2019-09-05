FROM alpine:3.9

ENV TF_VERSION 0.12.8
ENV TF_FILE    terraform_${TF_VERSION}_linux_amd64.zip

ENV ANSIBLE_VERSION 2.8.4
ENV AWSCLI_VERSION  1.16.232
ENV AZURE_VERSION   2.0.72
ENV DOCKER_COMPOSE  1.24.1
ENV DOCKER_ENGINE   4.0.2

# Install OS dependencies.
RUN echo "System dependencies" && \
    apk add --update \
      bash \
      ca-certificates \
      curl \
      docker \
      git \
      gnupg \
      make \
      openssl \
      python3

RUN echo "Build dependencies" && \
    apk add --virtual build-deps \
      build-base \
      gcc \
      libffi-dev \
      musl-dev \
      openssl-dev \
      python3-dev

RUN echo "Python3 dependencies" && \
    python3 -m ensurepip && \
    pip3 install --upgrade pip cffi && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi

RUN echo "Ansible dependencies" && \
    pip --no-cache-dir install \
      ansible==${ANSIBLE_VERSION} \
      docker-compose==${DOCKER_COMPOSE} \
      docker==${DOCKER_ENGINE}

RUN echo "Terraform dependencies" && \
    cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TF_VERSION}/${TF_FILE} && \
    unzip ${TF_FILE} && \
    mv terraform /usr/bin && \
    rm -f ${TF_FILE}

RUN echo "Azure dependencies" && \
    pip --no-cache-dir install azure-cli==${AZURE_VERSION}

RUN echo "AWS dependencies" && \
    pip --no-cache-dir install awscli==${AWSCLI_VERSION}

RUN echo "Cleanup" && \
    apk del --purge build-deps && \
    rm -rf /var/cache/apk/*
