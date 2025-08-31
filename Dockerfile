# Use an official Ubuntu base image
FROM ubuntu:20.04

# Avoid warnings by switching to noninteractive for the build process
ENV DEBIAN_FRONTEND=noninteractive

ENV USER=root

# Install XFCE, VNC server, dbus-x11, and xfonts-base
RUN apt-get update && apt-get install -y --no-install-recommends \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    dbus-x11 \
    xfonts-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Setup VNC server
RUN mkdir /root/.vnc \
    && echo "password" | vncpasswd -f > /root/.vnc/passwd \
    && chmod 600 /root/.vnc/passwd

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