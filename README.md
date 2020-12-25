#Electric Tantra Linux

## Introduction
This repository houses all the files necessary to generate an Arch Linux iso file from the profile contained within the iso directory, or `releng`. This profile contains all the necessary files and configurations to build a `liveusb` of the Electric Tantra Linux. It can also serve as a basis for those interested in creating their own Archlinux spin off distribution and can follow along with its general workflow. 


## About Electric Tantra Linux

At its root, I built Electric Tantra Linux primarily as a means of actually demonstrating my dotfiles, especially my awesome window manager configuration, as they were intended to operate. Remote users' machines are widely different and utilize every imaginable set of programs to accomplish various tasks, were configured by people with various levels of knowledge and various workcases I can't even image. Thus expecting anyone to actually go through all the trouble to quickly decide they absolutely hate it is unrealistic and asking a bit much, I know I don't do that with configurations I see on Reddit or while browsing GitHub/GitLab. 

### 'Wait, there is AWMTT for that!'
Yes, an awesome awesomewm package that wraps up the window manager in an X window using zephyr exists and is a tool I employ in my wrestlings with Lua (what an awful language) but this too doesn't give you the complete experience the way that popping in a custom distro on a USB does. 

## Distro vs. Remaster
Some will bemoan my classification of the Electric Tantra Linux as a customized distro as it isn't adding in anything that Arch doesn't have and for the most part employs Arch's repositories. Others will agree it is a distro because it also includes a repository of a select number of packages that I maintain (ie I build the AUR packages and upload them to S3), which are generally employed solely to get the ISO to install all the fixings and distribute a few packages of my own specific to the project/my dotfiles (my gtk theme, icon theme, help app, etc). 

My take on the Distro vs. Remaster debate: **It really doesn't matter and its Linux, everything falls into semantic cracks like this. Arguing is just otherwise useful time wasted and rarely changes anyone else's mind (not that what they think even actually matters its what you do)**. But I am a weirdo I know, so as you were.


## Building the ISO 
That part is pretty straightforward, just a few quick terminal commands listed below and some time chewing on it from your CPU (mileage will vary based on your hardware but no where near as long as a kernel compilation from the AUR). 


### 'Where's the Build Scripts?!'
Many repos that contain the same sets of files and are intended as the source configurations for even relatively well known Arch-based systems contain scripts that are run as a means of building the ISO but not this one! I have opted against building with `build.sh` scripts, they introduce a host of issues into the process and are technically deprecated at this time anyway, and have instead opted to utilize the mkarchiso terminal program directly because this is what it is meant for (and for this I am most grateful as it simplifies a lot of the process to a level reasonable for a single person dev team). I also hate seeing the deprecation notice over and over during the debugging process, the one affixed to the customize_airootfs.sh is much easier to ignore because if I get it to that point, its pretty much smooth sailing until I pop it into vmWare workstation to see what's wrong with it this time. 


```bash
# git clone https://github.com/Thomashighbaugh/electric-tantra-linux-iso
# cd electric-tantra-linux-iso
# mkarchiso -v -w /tmp/mkarchiso-tmp ./releng
```

