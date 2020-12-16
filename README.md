# CONTAINUX

 > tip: Go to https://debayanlab.github.io/containux/ to view the github page. Images might not display depending on the permissions of the repo.

## Description

Containux is an Arch-based linux distribution built with user control and privacy in mind. In today's world users are constantly downloading and installing numerous applications from various sources on the internet. More often than not, the user does not verify the source or "trustedness" of the application before running it on their computer.
In doing so the user has no idea what information such applications can access and send over the internet.
	Applications with malicious behaviour can modify, delete or encrypt files thereby leaving the user at the mercy of the publisher. Moreover, other applications can at the same time snoop around a user's filesystem and network potentially collecting sensitive, personal and identifying information without consent.
Unfortunately a large percentage of the applications the average person runs on a daily basis are closed-source (the source code is not open to the public) and hence has to simply take the publisher's word on issues of privacy and security. Containux is built with a solution to the aforementioned problem. It gets it's name from the fusion of the terms "container" and "linux". In short, containux provides the user appropriate tools to contain applications' behaviour. It can be used to restrict applications from accessing devices such as the microphone, webcam or even specific folders on the filesystem.


## Containerization

Containers have seen increased popularity in recent years with the revolution of the "cloud". Companies are increasingly contracting out all of their work and storage to offsite servers and reducing onsite storage of data.  These servers need to run a vast suits of applications and store all sorts of data in an efficient and secure manner. Containers and virtualization seem to have become the solution to this dilemma.

Containerization technologies such as docker allow applications to run independently of the operating system while replicating their very own virtual vertical stack. This means that applications have access to their own set of resources and libraries irrespective of the underlying system. This has a number of advantages such as different applications with dependencies on different versions of the same library can run on the same system. This also elimnates problems such as recursive and incomplete dependency cycles. Portability is also a huge plus as the same container can be uprooted and run on a completely different operating system while maintaining th same behaviour.

The reason containerization is important for the purpose of this project however is privacy and security. When applications run in their own containers, their scope of access is restricted to that "bubble". In doing so, it reduces the "surface of attack" in the case of any malicious behaviour by the appplication. Containux attempts to use this containment model of security where the user can choose to contain and restrict an application's behaviour.

## Linux Security Module (LSM)
  The linux security module is a framework created by the developers of the linux kernel which can be used by third party developers to create extensions which can take advantage of some features of the kernel. The way this works is that the LSM creates "hooks"  third party applications can use to  "hook into" different parts of the system. Referring to the paper by Greg K.H et. al, "LSM allows modules to mediate access to kernel objectsby placing hooks in the kernel code just ahead of the access ... Just before the kernel would have  accessed  an  internal  object, a hook makes a call to a function that the LSM module must provide.  The module can either let the access occur, or deny access,forcing an error code return"
  
 ![](https://github.com/debayanLab/containux/blob/main/assets/lsmhook.png)
 ![](https://github.com/debayanLab/containux/blob/main/assets/lsmhook2.png)

One of the most popular and primary uses of the LSM is to create MAC extensions. MAC stands for Mandatory Access Control, an access handling policy which can dictate access to various parts of the filesystem and hardware devices. In a MAC system, there is one authority which determines the permissions and access policies for all of the aforementioned devices. Therefore, in the case of containux, it is the user that becomes the sole authority in determining the scope of applications in his/her system. One of the main advantages of the LSM was in fact the performance benefit. Since it is built into the kernel itself, the process of granting and denying access is significantly reduced. This framework is essential to the working of Containux as it relies on the MAC protocol combined with the LSM to contain the behaviour of various applications running on the system.

![](https://github.com/debayanLab/containux/blob/main/assets/lsmnumbers.png) 

![](https://github.com/debayanLab/containux/blob/main/assets/graph.png) 
## Tools used

### App Armor

AppArmor is a MAC tool that takes advantage of the LSM. It uses a method that involves setting profiles which in turn dictate the scope of various applications.  Programs that are not confined with Apparmor typically run in a DAC (Direct Access Control) mode. Therefore, if any apparmor rules are applied, it augments the traditional DAC to first test the said application against existing DAC policies only after which it is tested with the AppArmor rules. The standout feature of apparmor however, is that it maintains rules on a per application basis rather than on a per user basis. This makes it tougher for malicious applications to gain restriced access to files by means of a privilege escalation attack.

### Firejail

Firejail is an SUID (Set owner User ID up on execution) program. What this does is assign temporary permissions to each file in a system. Since "everything is a file on linux", this allows you to set permissions for pretty much any resource on the system. This concept of temporary permissions is very powerful when used intelligently.

For example, let us take the `ping` command. When a `ping` command is executed it opens up a socket on the host, opens a port and sends and receive packets. A normal user however does not have the permissions to open a port on the system. Therefore, the ping command "inherits" root permissions to open and close ports. This eliminates the need to grant a user blanket root privileges by giving certain apps special privileges. 

By using firejail, containux can restrict the behaviour of various programs.


## Architecture and Methodoloy

### Building the system

Archlinux by default comes with a very minimal ISO. It is not a typical linux system in that it does not have any pre-installed applications by default. This gives the user flexibility to only install the packages that are needed and build a very customizeable system. The two install scripts in the `install/` directory do precisely that. It does the following things

* Sets an english locale
* Configure the system clock
* Partition the disk with `1GB swap` and and integrated `root` and `home` partition.
* Set the appropriate boot flags and format partitions
* Install base packages needed to boot the system including apparmor and firejail
* Create an fstab file and configure hosts
* Configure kernel modules and set environment variables to ensure AppArmor and Firejail run smoothly
* Install and configure bootloader
* Install the `cx` tool to `/usr/loca/bin`

## CX tool

To contain the different applications and create security policies, the CX tool achieves that. It interfaces with firejail and apparmor to create "containers" for given applications. Everytime a container is created with CX, it sets up an apparmor and firejail profile for the given application. By default, everything is in an "unrestricted mode" where the application behaves just as it did before it was being contained. Once a rule is created however, cx relays this to both firejail and apparmor after which the profiles are regenerated. The application is now run by default with the `firejail` prefix in the background to ensure that all profiles are loaded and in effect.
![](https://github.com/debayanLab/containux/blob/main/assets/architecture.png)

## Installation

### Requirements

 Download the latest arch linux iso from [here](https://www.archlinux.org/download//)
 
 Ensure that the machine you want to install containux on has at least 1GB of RAM and 20GB of disk space.
 
 A stable internet connection.
 
 Make sure to change your boot selection order to "removable device first" or equivalent in your BIOS. This won't be necessary in a VM.
 
### Preparing the ISO
 
####  Windows/Mac 

Burn the iso to a pendrive with a tool such as [rufus](https://rufus.ie/)

#### Linux

`sudo dd if=archlinux.iso of=/dev/sd[x] status="progess"`

where `/dev/sd[x]` is the partition of the external drive.

> :warning: **Double check the /dev/sd[x] partition before burning the iso**. If you choose the wrong partition it can result in data loss

### Execute the script

Boot the device with the Arch Linux ISO.

### Clone

Once Arch Linux has booted you should get an installation tty.

Clone the git repo: 

`https://github.com/debayanLab/containux`

give executable permissions to the directory:

`chmod -R +x containux/`

cd into the installation directory

`cd containux/installation/`

run the script

`./install`

 > note: **You need to  have a stable internet connection to ensure a smooth installation of all packages**. You will also be prompted for a root password during installation which you will have to enter.


### Finishing up

Reboot the VM with the `reboot` command and take out the removable drive.

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

>:information_source: **Only works for root user**
`cx -d test.sh /usr/bin/cd`

### Allow access to a library for a shell script

>:information_source: **Only works for root user**
`cx -a test.sh /usr/bin/cd`

### List all active containers

`cx -l`

## License
MIT

## References

Linux Security Modules: General Security Support for the Linux Kernel
Chris Wright and Crispin Cowan, WireX Communications, Inc.;James Morris, Intercode Pty Ltd;  Stephen Smalley, NAI Labs, Network Associates, Inc.; Greg Kroah-Hartman, IBM Linux Technology Center(https://www.usenix.org/legacy/event/sec02/full_papers/wright/wright.pdf)

https://www.kernel.org/doc/html/latest/admin-guide/LSM/index.html

https://gitlab.com/apparmor/apparmor/-/wikis/Documentation

https://wiki.archlinux.org/index.php/Firejail

https://firejail.wordpress.com/documentation-2/ (yes this is their official page :3)

https://wiki.archlinux.org/index.php/Installation_guide

https://wiki.archlinux.org/index.php/AppArmor
