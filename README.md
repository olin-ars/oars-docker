# A Basic Overview of Docker, and Our Docker Image & Commands
## Why Docker?
Realize that using Docker is a command-line heavy experience! It's somewhat like SSH-ing into things - your main interface with the Docker container is the terminal. That means processes that occupy your terminal while running become very annoying! Fortunately, Docker allows multiple terminals to connect to an active container - using special commands. To avoid having to pull up new terminals for every new connection to Docker, we suggest using `tmux`. It's a powerful tool for having multiple sessions within the same terminal screen (and to have them run even after closing the terminal).

Why use Docker when it's somewhat complicated? Because of something called containers. Think of Docker as a better and faster VM - it allows you to instantiate prebuilt *images* of a working computer. You'll use one such image for doing OARS work - that image will be the base from which we'll build upon. Every time you instantiate the image, it creates a container - data made/installed/screwed up within the container doesn't affect your main system (for the most part - there is one technicality). This makes it quite useful - often, we'll make/compile/install something foolish and break our computer. By using Docker, the only thing broken will be our container, and not our actual computer. Furthermore, Docker images are really quick to start up again - meaning you can easily replace the container whenever things go awry. It also lets you use tools meant for other OS's. Ex. we are using ROS Melodic, which requires Ubuntu 18.04 - even if you are running Ubuntu 16.04 or some other OS, you can use a Docker image to get access to Ubuntu 18.04, and thus ROS Melodic.

## How do we use Docker?
How does one store data? Well, as long as the container is not deleted, any changes made within it will persist between sessions. However, once you delete the container all the data is lost! This almost ruins the niceness of Docker - but fear not, volumes and mounts exist!
 - Mounts essentially allow you to access parts of your computer from within the container. Using the given commands, your OARS container will mount the home directory of your computer - which will give you access to all folders and subfolders within your home directory. Don't do your work in this, though! **All changes made to the home directory will stay even after you delete the container, meaning you can ACTUALLY break your computer by messing around in the home directory from within the container!! DO NOT WORK WITHIN THE HOME DIRECTORY!** The mount exists just as an easy for you to transfer files when necessary.
 - Instead, we advocate using *volumes*. The given commands will automatically mount a volume named `oars-volume` to your OARS container. Volumes are spaces set aside by Docker within your computer that aren't accessible by anything on your main computer, and vice versa. As long as the volume isn't deleted, the data on it persists; containers can be connected toone to edit it, but deleting attached containers does not delete the volume. This means any work you do on a volume from a container will stay, even after you break and delete the container - and without the risk of destroying your main system! And of course, that means **don't delete your volume unless you're absolutely positive that you're okay with losing all the stored data**.

## Ok, so how do we *actually* use Docker?

With that said, we'll dive into the commands we've provided you to interact with Docker:
 - `useoars`:
   - This is the command you use to join your Docker container.
   - It will use the prebuilt `olinoars/ros:2019-2020` image, which has ROS and the OARS repo already downloaded.
   - If the container is already instantiated, it will start up that container. If not, it will instantiate a new container.
   - It will mount your main system (the container's host machine) under the folder `~/host`. The volume that we recommend you do work in will be mounted as `~/volumes`.
   - The default user for the container is `oliner`, usergroup `oars`. This means to install things, or use the `apt` package manager, you'll need to become the root user. The `sudo` command doesn't work - instead, become the root user with the command `su`. The password for the root user is `octopus`.
   - **The container will be named `oars`. This terminal connection to the container will then become the main connection - once it is exited, all other connections to the container will be terminated as well.**
 - `joinoars`:
   - If the container is already up and running, this creates another connection. It will not be the main connection, and so exiting this will not close other sessions.
 - `cleanoars_soft` and `cleanoars_hard`:
   - This will remove the container.
   - `cleanoars_soft` will only remove the container.
   - `cleanoars_hard` will remove the connected volume along with the container. **Be careful! Deleting volumes is a massive endeavor that can end poorly!**
 - `resetoars_soft` and `resetoars_hard`:
   - This is the same as the `cleanoars` commands, but after deleting the container (and volume, if `hard`), it reinstantiates a container.
   - The volume is reinstantiated automatically with the container, if it doesn't already exist, so don't worry.

# I'd like to improve the image
Awesome! The Docker image used by OARS - `olinoars/ros:2019-2020` - is built using the `Dockerfile` and `ros_entrypoint.sh` files in the `docker_setup/` folder.
 - If you're a contributor to this repo, make a separate branch, make your edits, and submit a PR.
 - If you're not, feel free to fork the repo, make your edits, and submit a PR. All contributions are welcome!

Please make sure to clearly elaborate what your edits are/do, and why you feel they are necessary.
