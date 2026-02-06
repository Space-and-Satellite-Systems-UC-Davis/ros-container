ARG ROS_DISTRO=jazzy
FROM ros:${ROS_DISTRO}-ros-base

ARG ROS_DISTRO=jazzy
ARG INSTALL_NAV2_AND_SIMULATION=true
ARG INSTALL_MOVEIT=true
ARG INSTALL_VNC=true

SHELL ["/bin/bash", "-c"]

# Base packages (always installed)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    git \
    ripgrep \
    python3-colcon-common-extensions \
    python3-rosdep

# Nav2 + Simulation (Gazebo + RViz) - conditional
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    if [ "${INSTALL_NAV2_AND_SIMULATION}" = "true" ]; then \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-navigation2 \
    ros-${ROS_DISTRO}-nav2-bringup \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-ros-gz-bridge \
    ros-${ROS_DISTRO}-ros-gz-sim \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-xacro\
    ros-${ROS_DISTRO}-sdformat-urdf && \
    curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null && \
    apt-get update && \
    case "${ROS_DISTRO}" in \
    humble) GZ_VERSION=fortress ;; \
    jazzy) GZ_VERSION=harmonic ;; \
    kilted) GZ_VERSION=ionic ;; \
    rolling) GZ_VERSION=jetty ;; \
    *) echo "Unknown ROS_DISTRO: ${ROS_DISTRO}" && exit 1 ;; \
    esac && \
    apt-get install -y gz-${GZ_VERSION}; \
    fi

# MoveIt - conditional
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    if [ "${INSTALL_MOVEIT}" = "true" ]; then \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ros-${ROS_DISTRO}-moveit \
    ros-${ROS_DISTRO}-moveit-visual-tools \
    ros-${ROS_DISTRO}-rviz-visual-tools \
    ros-${ROS_DISTRO}-moveit-task-constructor-core \
    ros-${ROS_DISTRO}-warehouse-ros-sqlite \
    ros-${ROS_DISTRO}-moveit-resources-panda-moveit-config \
    ros-${ROS_DISTRO}-moveit-py \
    ros-${ROS_DISTRO}-ros2-control \
    ros-${ROS_DISTRO}-controller-manager \
    ros-${ROS_DISTRO}-joint-trajectory-controller \
    ros-${ROS_DISTRO}-joint-state-broadcaster \
    ros-${ROS_DISTRO}-joint-state-publisher \
    ros-${ROS_DISTRO}-robot-state-publisher \
    ros-${ROS_DISTRO}-rviz2 \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-joy; \
    fi

# VNC + XFCE - conditional
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    if [ "${INSTALL_VNC}" = "true" ]; then \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    tigervnc-standalone-server \
    tigervnc-common \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    libglx-mesa0 \
    libgl1 \
    mesa-utils && \
    mkdir -p /root/.vnc; \
    fi

# ROS setup
RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc && \
    rosdep init || true

# Copy VNC scripts (only used if VNC installed)
COPY scripts/xstartup /root/.vnc/xstartup
COPY scripts/start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /root/.vnc/xstartup /usr/local/bin/start-vnc.sh || true

ENV DISPLAY=:1

EXPOSE 5901
