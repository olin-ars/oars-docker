FROM ros:melodic-ros-base-bionic

ENV HOME /home/oliner
WORKDIR /home/oliner

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/oliner && \
    mkdir -p /etc/sudoers.d && \
    echo "oliner:x:${uid}:${gid}:Developer,,,:/home/oliner:/bin/bash" >> /etc/passwd && \
    echo "oliner:x:${uid}:" >> /etc/group && \
    echo "oliner ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/oliner && \
    chmod 0440 /etc/sudoers.d/oliner && \
    chown ${uid}:${gid} -R /home/oliner && \
    # install the latest version of Git
    apt-get -y update && \
    apt-get install -y --no-install-recommends software-properties-common curl && \
    add-apt-repository ppa:git-core/ppa && \
    # install VS Code
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg && \
    install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ && \
    sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list' && \
    apt-get -y update && \
    apt-get -y --no-install-recommends dist-upgrade && \
    # install a whole lot of dependencies
    apt-get install -y --no-install-recommends build-essential git libgtk-3-dev vim \
    pkg-config libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev sudo \
    ros-melodic-rosserial ros-melodic-rosserial-arduino apt-transport-https code python-pip && \
    pip install --upgrade python pip virtualenv && \
    # clean up temp files and caches
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /tmp/* && \
    rm -rf /var/likb/apt/lists/*

RUN sed "s/^dialout.*/&oliner/" /etc/group -i && \
    sed "s/^root.*/&oliner/" /etc/group -i

ENV DISPLAY :1.0

# setup entrypoint and permissions
COPY ./ros_entrypoint.sh /ros_entrypoint.sh
RUN chmod +x /ros_entrypoint.sh
USER oliner

# download git repo and setup virtualenv
RUN cd /home/oliner && \
    git clone https://github.com/olin-robotic-sailing/autonomous-research-sailboat.git /home/oliner/oars-research && \
    rosdep update && \
    mkdir /home/oliner/.virtualenvs && \
    virtualenv -p python2.7 --system-site-packages /home/oliner/.virtualenvs/oars && \
    echo "export PYTHONPATH=\$PYTHONPATH:catkin_ws" >> /home/oliner/.virtualenvs/oars/bin/activate && \
    echo "alias useoars='source /home/oliner/.virtualenvs/oars/bin/activate'" >> /home/oliner/.bashrc && \
    echo "useoars" >> /home/oliner/.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
