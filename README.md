# Keiko
Small script to create and manage simple docker containers.

## Introduction
During development and testing, applications very often need a quick way to set up a temporal database o web server. This script quickly creates these test containers based on configuration templates.

## Why is the project named Keiko?
Well, Docker's logo has a whale named [Moby Dock](https://www.docker.com/blog/call-me-moby-dock/), so I named the project with the first whale I could remember. [Keiko](https://en.wikipedia.org/wiki/Keiko_(killer_whale)) was a male killer whale that was the main attraction of "Reino Aventura" (a Mexico City amusement park) and portrayed Willy in the 1993 film Free Willy.

## Installation
1. Clone or download the content of this repository into any directory.
1. Add the directory to the `PATH` environment variable, or create a soft link into any directory already in the `PATH`.

If the user is not in the `docker` group, you will need to run the script using `sudo` or something similar.

Here is an example of how to install Keiko in Debian 11. It shouldn't be too different from installing in other Linux flavors.
~~~
$ cd /opt
$ sudo git clone https://github.com/jcanop/keiko.git
$ sudo ln -s /opt/keiko/keiko.sh /usr/local/bin/keiko
~~~

## Commands

Here is the list of the available commands. You can run these commands at the command line in this format:

~~~
$ keiko [command]
~~~

| Command | Description |
| ------- | ----------- |
| ls      | List available images. |
| ps      | List running containers. |
| run     | Creates and runs a container. |
| stop    | Stops all running containers. |
| version | Prints the current version. |

### Create and Run a Container

There are two required arguments: the name of the image and the container's name. There are also two optional arguments: the binding port and the mounting volume.

~~~
$ keiko run [image] [name] (arguments)
~~~

| Argument | Default | Description |
| -------- | ------- | ----------- |
| image |                           | Image to run. |
| name  |                           | Container's name. |
| -p    | Container's exported port | Container's Binding port. |
| -v    | Current directory         | Mounting volume. |


#### Examples
~~~
$ keiko run nginx web -p 8080 -v $PWD/site
~~~

~~~
$ keiko run mariadb db
~~~

## Adding a New Image

To create a new image for the script, you need to create a new configuration template at the `configs` directory located in the installation directory.

Variables for the configuration template.

| Argument | Description |
| -------- | ----------- |
| image       | Image's name at the docker's hub repository. |
| description | Description of the image. |
| dir         | Volume mounting point. |
| port        | Exposed port. |
| args        | Optional arguments. |

### Example
~~~
image="jekyll/minimal"
description="Jekyll Server"
dir="/srv/jekyll"
port=4000
args="jekyll serve -d /dev/shm/site --safe --force_polling"
~~~
