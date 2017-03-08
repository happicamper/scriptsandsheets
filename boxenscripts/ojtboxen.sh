#!/bin/sh
# tailored script for Boxen - Interns setup
function sourcing {
if [[ -f ~/.bashrc ]]; then
found=$(grep  "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" ~/.bashrc)
  if [[ $found = "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" ]]; then
    echo "already in your bashrc"
  else
  echo "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" >> ~/.bashrc
  /opt/boxen/repo/script/boxen --env
  echo "Done"
  fi
else
  sudo touch ~/.bashrc && sudo chmod 777 ~/.bashrc && echo "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" >> ~/.bashrc
  echo "Done"
fi
}
function sshkeyupload {
  pubkey=$(cat ~/.ssh/id_rsa.pub)
  curl --silent --user $bituser:$bitpass -X POST https://bitbucket.org/api/1.0/users/$bituser/ssh-keys --data-urlencode "key=$pubkey" --data-urlencode "label=$label" >/dev/null
if [ ! -n "$(grep "^bitbucket.org " ~/.ssh/known_hosts)" ]; then ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts 2>/dev/null; fi
echo "\nPlease check your Bitbucket ssh-keys under Bitbucket settings"
  }
######add user ssh-key
while :
    do
label=$(hostname)
read -p "upload ssh keys only applies on devops and backend bitbucket repos for now, Do you want to upload your ssh-keys to your Bitbucket? [y/n]" answer
case "$answer" in
y|Y )
      read -p 'Bitbucket username: ' bituser
      read -sp 'Password: ' bitpass
        if [[ -f ~/.ssh/id_rsa.pub ]]; then
          sshkeyupload
        else
          echo "Public key not found! \n Creating SSH key now....\n Please wait....."
          cat /dev/zero | ssh-keygen -q -N "" > /dev/null
          sshkeyupload
        fi
      echo "We will upload your Mac's ssh-keys to enable cloning from your bitbucket's repositories"
      break
;;
n|N )
      echo "skipped step for upload ssh keys"
      break
;;
* )
      echo "invalid"
;;
esac
done
#######permission for our boxen to run casks###
echo "Need to sudo for some applications"
cd / && sudo chown -R $(whoami) /usr/local/bin
read -sp "Confirm: `echo $'\n> '`" sudopass
#######for ojt setup, disabling of usb ports
while :
    do
read -p "Disable usb ports? [Y/N]? `echo $'\n> '`" res
case $res in
  Y|y )
        sudo echo 'echo "'$sudopass'" | sudo -S kextunload -b com.apple.iokit.IOUSBMassStorageDriver' > /opt/boxen/repo/script/usbrestrict.sh
        sudo cp /opt/boxen/repo/plist/com.usbrestrict.plist /Library/LaunchDaemons/
        sudo chown root:wheel /Library/LaunchDaemons/com.usbrestrict.plist
        sudo chmod 644 /Library/LaunchDaemons/com.usbrestrict.plist
        sudo launchctl load /Library/LaunchDaemons/com.usbrestrict.plist
        sudo launchctl start com.usbrestrict.plist
        break
;;
  N|n )
        echo "Proceeding to the next step"
        break
;;
  * )
        echo "invalid input"
;;
esac
done
######warns user for xcode update
echo "Make sure your xcode is already installed and verified!"
#######update gems for dependencies
echo "Updating gems to make our boxen healthy"
cd /opt/boxen/repo && /opt/boxen/repo/script/bootstrap
/opt/boxen/repo/script/boxen --no-fde --debug --no-issue
sourcing
