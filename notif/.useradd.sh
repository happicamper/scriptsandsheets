#!/bin/bash
while :
do
read -p 'Enter Username: ' uname
read -sp 'Enter Password: ' pword
useradd $uname
echo $pword | passwd $uname --stdin
done
