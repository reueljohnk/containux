# CONTAINUX

## Description

Containux is an Arch-based linux distribution built with user control and privacy in mind. In today's world users are constantly downloading and installing numerous applications from various sources on the internet.More often than not, the user does not verify the source or "trustedness" of the application before running it on their computer.
In doing so the user has no idea what information such applications can access and send over the internet.
Applications with malicious behaviour can modify, delete or encrypt files thereby leaving the user at the mercy of the publisher.Moreover, non-malicious applications can at the same time snoop around the user's filesystem and network potentially collecting sensitive, personal and identifying information without the user's consent.
Unfortunately a large percentage of the applications the average person runs on a daily basis are closed-source (the source code is not open to the public) and hence has to simply take the publisher's word on issues of privacy and security.

Containux is built with a solution to the aforementioned problem. It gets it's name from the merging(?) of the terms "container" and "linux". In short, containux provides the user appropriate tools to contain applications' behaviour. It can be used to restrict applications from accessing devices such as the microphone, webcam or even specific folders on the filesystem.


## Linux Security Module (LSM)
  
	
## Tools used

### App Armor

### Firejail

## Installation

### Requirements

 Download the latest arch linux iso from [here](https:/https://www.archlinux.org/download//)
 
 Ensure that the machine you want to install containux on has at least 1GB of RAM and 20GB of disk space
 
 A stable internet connection
 
 ### Setup

####  Windows

Burn the iso to a pendrive with a tool such as [rufus](https://https://rufus.ie/)

#### Linux/Mac

`sudo dd if=archlinux.iso of=/dev/sd[x] status="progess"`

where `/dev/sd[x]` is the partition of the external drive.

> :warning: **Double check the /dev/sd[x] partition before burning the iso**. If you choose the wrong partition it can result in data loss

### Virtual Machine

Select the boot device as the downloaded iso and boot

### Clone

Once Arch Linux has booted you should get an installation tty.

Clone the git repo: 

`https://github.com/debayanLab/containux`

cd into the directory

`cd containux`

run the script

`make install`

### Finishing up

The script will build the distribution with the appropriate tools. You will be prompted for a root password, username and the username's password.

##  Usage

### Create a container

To create a new container for an application:

`cx -n firefox`

To create a new container for a shell script:

`cx -n test.sh`

### Deny access to a device / folder / internet

`cx -d firefox [webcam,net,/home/user/Documents ]`

### Allow access to a device / folder / internet

`cx -a firefox [webcam,net,/home/user/Documents ]`

### Deny access to a library for a shell script

`cx -d test.sh /usr/bin/cd`

### Allow access to a library for a shell script

`cx -a test.sh /usr/bin/cd`

### List all active containers

`cx -l`

## Links
