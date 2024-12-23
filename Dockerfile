FROM quay.io/jupyter/base-notebook:2024-12-02

USER root

RUN apt-get -y -qq update \
 && apt-get -y -qq install \
        dbus-x11 \
        xclip \
        xfce4 \
        xfce4-panel \
        xfce4-session \
        xfce4-settings \
        xorg \
        xubuntu-icon-theme \
        fonts-dejavu \
 && apt-get -y -qq remove xfce4-screensaver \
 && mkdir -p /opt/install \
 && chown -R $NB_UID:$NB_GID $HOME /opt/install \
 && rm -rf /var/lib/apt/lists/*

# Instalar o servidor VNC (TigerVNC ou TurboVNC)
ARG vncserver=tigervnc
RUN if [ "${vncserver}" = "tigervnc" ]; then \
        echo "Installing TigerVNC"; \
        apt-get -y -qq update; \
        apt-get -y -qq install tigervnc-standalone-server; \
        rm -rf /var/lib/apt/lists/*; \
    fi

ENV PATH=/opt/TurboVNC/bin:$PATH
RUN if [ "${vncserver}" = "turbovnc" ]; then \
        echo "Installing TurboVNC"; \
        wget -q -O- https://packagecloud.io/dcommander/turbovnc/gpgkey | \
        gpg --dearmor >/etc/apt/trusted.gpg.d/TurboVNC.gpg; \
        wget -O /etc/apt/sources.list.d/TurboVNC.list https://raw.githubusercontent.com/TurboVNC/repo/main/TurboVNC.list; \
        apt-get -y -qq update; \
        apt-get -y -qq install turbovnc; \
        rm -rf /var/lib/apt/lists/*; \
    fi

USER $NB_USER

# Copiar o arquivo environment.yml e instalar o ambiente Conda
COPY --chown=$NB_UID:$NB_GID environment.yml /tmp
RUN . /opt/conda/bin/activate && \
    mamba env update --quiet --file /tmp/environment.yml

# Copiar arquivos de instalação e instalar dependências
COPY --chown=$NB_UID:$NB_GID . /opt/install
RUN . /opt/conda/bin/activate && \
    mamba install -y -q "nodejs>=22" && \
    pip install --no-deps /opt/install
    
