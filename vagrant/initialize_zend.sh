#!/bin/bash

CURRENT_DIR=$PWD
vagrant_folder=$CURRENT_DIR
project_folder=$CURRENT_DIR/../project
zendskeletonapp=$CURRENT_DIR/../project/ZendSkeletonApplication
zendtag=release-2.5.0

if [ ! -f "composer.phar" ]; then
  echo "Downloading composer.phar.."
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" &&
  php -r "if (hash_file('SHA384', 'composer-setup.php') === 'e115a8dc7871f15d853148a7fbac7da27d6c0030b848d9b3dc09e2a0388afed865e6a3d6b3c0fad45c48e2b5fc1196ae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" &&
  php composer-setup.php &&
  php -r "unlink('composer-setup.php');"
fi

echo "Updating composer.phar to the latest version.."
php composer.phar self-update

echo "Begin setup zendframework 2.."

if [ ! -d "$project_folder" ]; then
	echo "Creating project folder.."
  mkdir $project_folder
fi

if [ ! -d "$project_folder/db" ]; then
	echo "Creating db folder.."
  mkdir $project_folder/db
fi

cd $project_folder
if [ ! -d "module" ]; then
  read -p "Specify the release tag of Zend to setup. You can find it in https://github.com/zendframework/ZendSkeletonApplication (choose one of the release-* tags): " zendtag

  echo "Cloning Zend Skeleton.."
  git clone -b $zendtag --depth 1 https://github.com/zendframework/ZendSkeletonApplication
fi

echo "Removing unecessary files.."

if [ -f "$zendskeletonapp/Vagrantfile" ]; then
  echo "Removing Vagrantfile from $zendskeletonapp.."
  rm "$zendskeletonapp/Vagrantfile"
fi

if [ -d "$zendskeletonapp/.git" ]; then
  echo "Removing .git from $zendskeletonapp.."
  rm -rf $zendskeletonapp/.git
fi

if [ -d "$zendskeletonapp" ]; then
  echo "Moving all the files from $zendskeletonapp to $project_folder.."
  cp -R $zendskeletonapp/* $project_folder
  echo "Removing $zendskeletonapp.."
  rm -rf $zendskeletonapp
fi

echo "Setting correct permissions for files and folders"
cd $project_folder/..
find . -type f -print0 | xargs -0 chmod 0644
find * -type d -print0 | xargs -0 chmod 0755
chmod 755 vagrant/composer.phar
chmod +x vagrant/initialize_zend.sh

echo "Done. Running vagrant up.."
cd $vagrant_folder
vagrant up
vagrant provision
