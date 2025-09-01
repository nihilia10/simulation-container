# Use an official Ubuntu base image
#FROM ubuntu:20.04
FROM osrf/ros:jazzy-desktop
ARG ROS_DISTRO=jazzy
ARG GZ_DIST=harmonic
# Avoid warnings by switching to noninteractive for the build process
ENV DEBIAN_FRONTEND=noninteractive

ENV USER=root

# ROS - Gazebo Utils
RUN apt-get update && apt-get install -y \
    wget gnupg lsb-release sudo curl git mesa-utils \
 && rm -rf /var/lib/apt/lists/*

# Repo OSRF Gazebo
RUN wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/gazebo-archive-keyring.gpg && \
    bash -lc 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/gazebo-archive-keyring.gpg] \
    http://packages.osrfoundation.org/gazebo/ubuntu-stable $(. /etc/os-release && echo $UBUNTU_CODENAME) main" \
    > /etc/apt/sources.list.d/gazebo-stable.list'

# Gazebo (meta) + puente ROS<->GZ
RUN apt-get update && apt-get install -y \
    gz-${GZ_DIST} \
    ros-${ROS_DISTRO}-ros-gz \
 && rm -rf /var/lib/apt/lists/*

# Paths de recursos (genéricos)
ENV GZ_SIM_RESOURCE_PATH=/usr/share/gz:/usr/share/gz-${GZ_DIST}:/usr/share/${GZ_DIST}:/usr/share

# Validación (no GUI)
RUN gz sim --help >/dev/null

# Install XFCE, VNC server, dbus-x11, and xfonts-base
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    xfonts-base \
    autocutsel xclip xfce4-clipman xauth \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup VNC server
RUN mkdir /root/.vnc \
    && echo "password" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

# Crear xstartup para XFCE + clipboard sync
RUN printf '%s\n' \
  '#!/bin/sh' \
  'xrdb $HOME/.Xresources' \
  'startxfce4 &' \
  'autocutsel -fork -selection PRIMARY' \
  'autocutsel -fork -selection CLIPBOARD' \
  > /root/.vnc/xstartup && chmod +x /root/.vnc/xstartup

RUN mkdir -p /root/.config/autostart && \
printf '[Desktop Entry]\nType=Application\nName=Clipman\nExec=xfce4-clipman\n' \
    > /root/.config/autostart/clipman.desktop

# Create an .Xauthority file
RUN touch /root/.Xauthority

# Set display resolution (change as needed)
ENV RESOLUTION=1920x1080

# Expose VNC port
EXPOSE 5901

# noVNC + websockify
RUN apt-get update && apt-get install -y --no-install-recommends \
    novnc websockify python3 \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Puerto web de noVNC
EXPOSE 6080

# Carpeta de trabajo donde quieres persistir archivos
ENV WORKSPACE=/workspace
RUN mkdir -p $WORKSPACE

# Opcional: que todo lo que hagas por defecto sea ahí
WORKDIR $WORKSPACE

# Copy a script to start the VNC server
COPY start-vnc.sh start-vnc.sh
RUN chmod +x start-vnc.sh

CMD ["./start-vnc.sh"]