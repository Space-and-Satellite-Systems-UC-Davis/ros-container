FROM ros:jazzy-ros-base

SHELL ["/bin/bash", "-c"]

# Install desktop environment and VNC
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  git \
  ripgrep \
  python3-colcon-common-extensions \
  python3-rosdep \
  ros-jazzy-navigation2 \
  ros-jazzy-nav2-bringup \
  ros-jazzy-rviz2 \
  ros-jazzy-ros-gz-bridge \
  ros-jazzy-ros-gz-sim \
  tigervnc-standalone-server \
  tigervnc-common \
  novnc \
  websockify \
  supervisor \
  xfce4 \
  xfce4-terminal \
  dbus-x11 \
  libglx-mesa0 \
  libgl1 \
  mesa-utils \
  && rm -rf /var/lib/apt/lists/*

# Install Gazebo
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
RUN apt-get update && apt-get install -y gz-harmonic && rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN rosdep init || true

# Configure VNC directory
RUN mkdir -p /root/.vnc

# Copy VNC configuration scripts
COPY scripts/xstartup /root/.vnc/xstartup
COPY scripts/start-vnc.sh /usr/local/bin/start-vnc.sh

# Make scripts executable
RUN chmod +x /root/.vnc/xstartup && \
  chmod +x /usr/local/bin/start-vnc.sh

ENV DISPLAY=:1

EXPOSE 6080 5901