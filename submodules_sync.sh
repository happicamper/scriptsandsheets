# #!/bin/bash
# you can put it .git/hooks
# you can you the code below if you're not experiencing error related to ""." exists"
# git clone $remote_url . --recursive

# alternative for cloning into the current directory
echo "INITIALIZING A DIRECTORY"
git init
git remote add origin $remote_url
git fetch --all --prune

echo "CHECKOUT $branch_name"
git checkout $branch_name
git submodule update --init --recursive
repo=$(pwd)
echo $pwd

# create a textfile that list the name of submodules folders
ls $repo/docs | grep "$folders" > submod_lists.txt

# checkout all the submodules folders inline with the main repository
while IFS='' read -r submod_dir || [[ -n "$submod_dir" ]] || [[ -n $submod_lists ]]; do
echo "$submod_dir"
cd $repo/docs/$submod_dir && git checkout $bamboo_planRepository_branchName
if [ "$submod_dir" = "" ]; then
  exit
fi
done < "submod_lists.txt"
