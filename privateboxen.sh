#!/bin/sh
#All in one script for private boxen
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
function sourcing_zsh {
##enable boxen in zsh terminal
if [[ -f ~/.zshrc ]]; then
found=$(grep  "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" ~/.zshrc)
  if [[ $found = "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" ]]; then
    echo "already in your .zshrc"
  else
  echo "[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh" >> ~/.zshrc
  /opt/boxen/repo/script/boxen --env
  echo "Done, You can now also run boxen using zsh"
  fi
  read -p "Do you want zsh to be your default shell? [Y/N]" -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
  chsh -s $(which zsh)
    if [ $SHELL = "/bin/zsh" ]; then
      echo "Restart your terminal to start using zsh!"
    else
      echo "Something went wrong, it's still on bash shell"
    fi
  else
  echo "Ok, bye"
  fi
else
  echo "No zsh installed! Your boxen will only work on bash environment Otherwise install zsh and run boxen again \nNow you're Good to Go!"
fi
}
function sshkeyupload {
  pubkey=$(cat ~/.ssh/id_rsa.pub)
  curl --silent --user $bituser:$bitpass -X POST https://bitbucket.org/api/1.0/users/$bituser/ssh-keys --data-urlencode "key=$pubkey" --data-urlencode "label=$label" >/dev/null
if [ ! -n "$(grep "^bitbucket.org " ~/.ssh/known_hosts)" ]; then
ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts 2>/dev/null;
fi
echo "\nPlease check your Bitbucket ssh-keys under Bitbucket settings"
  }
######add user ssh-key
while :
    do
label=$(hostname)
read -p "DevOps or Backend Build? [Y/N]" answer
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
      echo "Working into the next step....."
      break
;;
* )
      echo "invalid"
;;
esac
done
#######permission for our boxen to run casks###
echo "Sudo for some applications"
cd / && sudo chown -R $(whoami) /usr/local/bin
######warns user for xcode update
echo "Make sure your xcode is already installed and verified!"
#######update gems for dependencies
echo "Updating gems to make our boxen healthy"
cd /opt/boxen/repo && /opt/boxen/repo/script/bootstrap
read -p "Is your machine File Disk Encrypted? [Y/N]" fde
echo
if [[ $fde =~ ^[Yy]$ ]]; then
/opt/boxen/repo/script/boxen --debug
else
/opt/boxen/repo/script/boxen --no-fde --debug
fi
sourcing
sourcing_zsh
