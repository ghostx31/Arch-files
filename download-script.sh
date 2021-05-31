#!/bin/sh

printf "This script will install packages you'll need to get started with Arch Linux. Please do not run this script as root. Please enter the password whenever required. Continue? (Y/N) "

read choice

if [ $choice == 'Y' ] || [ $choice == 'y' ]
  then 
    printf "Installing paru, an AUR helper to install packages from the AUR. "
    #sudo pacman -S git 
    git clone https://aur.archlinux.org/paru.git
    cd paru/
    makepkg -si
    paru -S bat 
    printf "Paru is installed. Get its help by typing paru -h"
  else
    exit 1
  fi 

  printf "Now the script will check if the partition if btrfs. If the partition is btrfs, then this will install timeshift and timeshift-autosnap. "
  if [ "$(stat -f --format=%T /)" == "btrfs" ]
then 
  printf "BTRFS partition detected. "
  printf "Installing timeshift. "
  paru -S timeshift timeshift-autosnap 
else
  printf "BTRFS not detected. "
fi

printf "Adding pacman hooks to /etc/pacman.d/hooks"
mkdir ~/git-files
cd ~/git-files/
mkdir /etc/pacman.d/hooks
cd Arch-files/
cd hooks/
sudo mv *.hook /etc/pacman.d/hooks
printf "Moved hooks to /etc/pacman.d/hooks "

printf "Do you want to install linux-zen kernel? "
read answer
if [ "$answer" == 'Y' ] || [ "$answer" == 'y' ]
then
  paru -S linux-zen linux-zen-headers
else
  printf "Not installing additional kernels "
fi

printf "Installing auto-cpufreq, tlp and tlpui from AUR... "
paru -S auto-cpufreq tlp tlpui 
systemctl enable auto-cpufreq.service
systemctl enable tlp.service 

printf "Do you want to install nvidia drivers? "
read nv 
printf "Installing nvidia-dkms package. If you have not installed the linux-zen kernel, then free feel to uninstall this package and run sudo pacman -S nvidia nvidia-utils nvidia-settings "

if [ "$nv" == "y" ] || [ "$nv" == "Y" ]
  then
    paru -S dkms 
    paru -S nvidia-dkms nvidia-utils nvidia-settings  
  else
    printf "Not installing nvidia drivers. "
fi 

printf "Installing Pulseaudio then presets for it. You will get notification about conflicting programs. Remove the conflicting programs by selecting 'y' "
paru -S pulseeffects 
printf "Installing presets "
bash -c "$(curl -fsSL https://raw.githubusercontent.com/JackHack96/PulseEffects-Presets/master/install.sh)"

printf "Updating the system. "
sudo pacman -Syu 

printf "Thank you for using this script. For further instructions, feel free to contact me. "



