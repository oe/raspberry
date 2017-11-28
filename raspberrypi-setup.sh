#!/bin/bash

# set backup path to ~/apt-backup
backup_path=~
backup_path="${backup_path}/apt-backup"
mkdir -p $backup_path

# ------------------- update apt sources ----------------------------
# update sources.list to mirrors for Chinese users
# you can change it to your country's mirrors, find more mirrors at
#     https://www.raspbian.org/RaspbianMirrors
source_path="/etc/apt/sources.list"
echo "update ${source_path}"
# backup orgin source.list
sudo cp $source_path "${backup_path}/sources.list"
# update content
sudo echo "deb http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib" > $source_path
sudo echo "deb-src http://mirrors.aliyun.com/raspbian/raspbian/ wheezy main non-free contrib" >> $source_path
# add stretch source, so raspbian can install php7.0 and other softwares
sudo echo "deb http://mirrors.ustc.edu.cn/raspbian/raspbian/ stretch main contrib non-free" >> $source_path
sudo echo "deb-src http://mirrors.ustc.edu.cn/raspbian/raspbian/ stretch main contrib non-free" >> $source_path

# update raspi.list
source_d_path="/etc/apt/sources.list.d/raspi.list"
echo "update ${source_d_path}"
sudo cp $source_d_path "${backup_path}/raspi.list"
sudo echo "deb https://mirrors.ustc.edu.cn/archive.raspberrypi.org/ jessie main ui" > $source_d_path

# update apt-preferences
#   following configuration can prevent all software download from stretch
#   download from jessie if not found
apt_preferences_path="/etc/apt/preferences"
echo "update ${apt_preferences_path}"
[ -f $apt_preferences_path ] && sudo cp $apt_preferences_path "${backup_path}/preferences"
sudo echo "Package: *" > $apt_preferences_path
sudo echo "Pin: release n=jessie " >> $apt_preferences_path
sudo echo "Pin-Priority: 600" >> $apt_preferences_path

# update apt to confirm apt source config files
sudo apt-get update
sudo apt-get upgrade
# ------------------- update apt sources end ----------------------------


# ------------------- enable ssh ----------------------------
sudo systemctl enable ssh
sudo systemctl start ssh
# ------------------- enable ssh end ----------------------------


# ---------- install Chinese font to solve CJK chars messy code ------------
#  this cannot solve CJK chars messy code, I'm still digging into it....
# install Chinese font
sudo apt-get install ttf-wqy-zenhei ttf-wqy-microhei
# -------- install Chinese font to solve CJK chars messy code end ---------




# -------------- install a complete version of vim ---------------------
# by default raspbian come with vim.tiny, which you may not familiar with
# install vim
echo "install vim"
sudo apt-get remove vim.tiny
sudo apt-get autoremove

sudo apt-get install vim-runtime
sudo apt-get install vim
# -------------- install a complete version of vim end ---------------------


# -------------- install zsh ---------------------
# zsh
echo "install zsh"
# install git in case of git is not installed
sudo apt-get install git
sudo apt-get install zsh
# install zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
# -------------- install zsh end ---------------------



# -------------- support extFat format usbdisk ---------------------
# exf disk
sudo apt-get install exfat-fuse
# -------------- support extFat format usbdisk end ---------------------


# -------------- install linux control panel ---------------------
# Baota control panel: https://www.bt.cn/
# Say language only in Chinese
wget -O install.sh "http://download.bt.cn/install/install-ubuntu.sh" && sudo bash install.sh
# -------------- install linux control panel end---------------------



# -------------- install balena(docker for LoT) ---------------------
# install balena docker manage
curl -sfL https://balena.io/install.sh | sh
# -------------- install balena(docker for LoT) end -----------------




# -------------- unlock root account ---------------------
# unlock root account, so you can maintain your system in emergency situations
echo "change root password"
sudo passwd root
sudo passwd --unlock root
# -------------- unlock root account ---------------------


###
## change timezone of pi 
# sudo raspi-config
# sudo mount /dev/sda1 /media/mhdd