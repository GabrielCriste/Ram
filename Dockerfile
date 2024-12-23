# Definir a imagem base
FROM quay.io/jupyter/base-notebook:2024-12-02

# Definir o usuário como root para permitir a instalação de pacotes
USER root

# Atualizar pacotes e instalar dependências necessárias
RUN apt-get -y update && \
    apt-get -y install \
    dbus-x11 \
    xclip \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    fonts-dejavu && \
    apt-get -y remove xfce4-screensaver && \
    mkdir -p /opt/install && \
    chown -R $NB_UID:$NB_GID $HOME /opt/install && \
    rm -rf /var/lib/apt/lists/*

# Instalar qualquer outro pacote ou dependência necessária
RUN apt-get -y install \
    python3-pip \
    python3-dev \
    build-essential

# Instalar Python dependências (se necessário)
RUN pip3 install --upgrade pip && \
    pip3 install \
    numpy \
    pandas \
    matplotlib \
    jupyterlab \
    # Adicione aqui outros pacotes Python necessários
    && rm -rf /root/.cache

# Alterar o diretório de trabalho para /home/jovyan
WORKDIR /home/jovyan

# Copiar arquivos do repositório (se necessário)
# COPY . /home/jovyan/

# Expor a porta do Jupyter
EXPOSE 8888

# Configurar comando para iniciar o Jupyter
CMD ["start-notebook.sh"]

