# Use the OSRF ROS jazzy Desktop Full image as the base
FROM osrf/ros:jazzy-desktop-full

# Update and install additional packages if necessary
RUN apt update -q \
    && apt upgrade -q -y \
    && apt install -y --no-install-recommends \
    software-properties-common \
    python3-pip \
    nano \
    xauth \
    ros-${ROS_DISTRO}-joint-state-publisher-gui \
    ros-${ROS_DISTRO}-moveit \
    ros-${ROS_DISTRO}-ros-gz \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# Create a new user named 'jazzy' with sudo privileges
RUN useradd -m jazzer && echo "jazzer:password" | chpasswd && adduser jazzer sudo

# Copy the entry point script into the container
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

## Make sure the script is executable and accessible by 'jazzer'
RUN chmod +x /usr/local/bin/entrypoint.sh \
    && chown jazzer:jazzer /usr/local/bin/entrypoint.sh

# Switch to the 'jazzer' user
USER jazzer

# Set up a working directory
RUN mkdir -p /home/jazzer/workspace/src
WORKDIR /home/jazzer/workspace

# Make sure the script is executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the entry point to the script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# (Optional) Set up an entrypoint or CMD
CMD ["bash"]