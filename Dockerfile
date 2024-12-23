# Use a base image with Jupyter environment
FROM quay.io/jupyter/base-notebook:2024-12-02

# Switch to root to install necessary packages
USER root

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    dbus-x11 \
    xclip \
    xfce4 \
    xfce4-panel \
    xfce4-session \
    xfce4-settings \
    xorg \
    xubuntu-icon-theme \
    fonts-dejavu \
    && apt-get remove -y xfce4-screensaver \
    && mkdir -p /opt/install \
    && chown -R $NB_UID:$NB_GID $HOME /opt/install \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for Jupyter and user
ENV JUPYTER_ENABLE_LAB=yes

# Switch back to the default jupyter user
USER $NB_UID

# Expose the Jupyter port
EXPOSE 8888

# Start Jupyter Notebook when the container starts
CMD ["start-notebook.sh"]
