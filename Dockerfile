FROM python:3.11.9-slim

ARG TARGETARCH
ARG TARGETVARIANT
ENV JASPER_CONFIG=/config

COPY ../naomi-docker/apt_req.txt .
RUN apt update -y  \
    && apt upgrade -y  \
    && awk '! /^ *(#|$)/' apt_req.txt | xargs -r -- apt install -y --no-install-recommends \
    && apt clean \
    && apt autoremove \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -u 1000 naomi  \
    && usermod -aG sudo naomi  \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN mkdir /config

RUN git clone https://github.com/NaomiProject/Naomi.git /Naomi/
WORKDIR "/Naomi/"
RUN pip install --upgrade pip

COPY requirements.txt .
RUN printf "Building for arch ${TARGETARCH}";
RUN --mount=type=cache,target=/root/.cache/pip if [ "$TARGETARCH" = "amd64" ]; then \
        pip install --no-cache-dir -r requirements.txt; \
    elif [ "$TARGETARCH$TARGETVARIANT" = "armv7" -o "$TARGETARCH" = "arm64" ]; then \
        pip3 install --no-cache-dir --index-url=https://www.piwheels.org/simple --extra-index-url=https://pypi.python.org/simple/ --no-cache-dir -r requirements.txt \
    ; fi

RUN /Naomi/compile_translations.sh

USER naomi

CMD ["python", "Naomi.py", "--debug"]


