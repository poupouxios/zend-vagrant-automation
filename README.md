# Zend-Vagrant

Zend Vagrant automation is an automatic way to fetch Zend Framework 2 from GitHub and setup a local Zend project on your PC to play around. It initializes all the necessary files and folders to run.

The automation uses [Vagrant](https://www.vagrantup.com/) and [Ansible](http://www.ansible.com/) to build a local isolated VM to run the project.

You can have in a few minutes - assuming everything goes perfect :) - a Zend project to play around without the hassle of having to setup vhosts, setup databases, downloading and setting up Zend Framework Core files, setting up the correct permissions, setup specific versions of php so that the project and the dependencies can run etc.

The project is tested in Ubuntu 16.04.

## Dependencies

The project needs to have some essential components to start which are:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/). Use this [Getting Started guideline](https://docs.vagrantup.com/v2/getting-started/) to familiarise yourself 
* [Ansible](http://www.ansible.com/)
* [NFS enable on Linux](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-nfs-mount-on-ubuntu-14-04) - This is essential as it decreases the response time when you click around the Drupal site.

## Run this sample project

1. Clone the project and put it in any place on your computer `git clone https://github.com/poupouxios/zend-vagrant.git`
2. Navigate inside the vagrant folder and run the below command (if the script doesn't run change its permissions to be executable by doing `chmod +x initialize_zend.sh`:
  * `./initialize_zend.sh`
5. When you execute the script, It will prompt you to select what Zend tag to download. **Currently the script doesn't work with Zend Framework 3**. Visit `https://github.com/zendframework/ZendSkeletonApplication` and find the latest tag release for Zend Framework 2. I use the `release-2.5.0`.
6. After you select the correct tag, the script will clone the Zend Skeleton structure and setup everything.
7. Now sit back, grab a coffee or tea and watch the magic of Vagrant and Ansible setting up a Virtual Machine and setup everything to have a fresh Zend project to play.
8. If everything goes fine, and the ansible script finishes successfully, you should be able to access the Zend Application via [http://192.168.60.100](http://192.168.60.100).
9. You should be able also to access [Mailcatcher](http://mailcatcher.me/) through [http://192.168.60.100:1080](http://192.168.60.100:1080)

## Structure of the folders

The script will create a project folder which will have all the core files for Zend to start coding your application.

## Configuration variables

In order to create your own project, there are some configuration variables that can be set. These variables exist insibe the `vagrant/ansible/playbook.yml` file and are:
        hostname: sampletesthost
        database_user: sampleuser
        database_password: password
        database_name: sampletest
        database_dump_name: 

  * `hostname`: This will be the hostname for the server and the name of the Virtualhost inside the `/etc/apache2/sites-available` folder.
  * `database_name`: The variable describes its purpose. It sets the database name
  * `database_user`: This is the username that will be set to access the database name that you specified above
  * `database_password` : This is the password that will be set for the above username
  * `database_dump_name`: The purpose of this variable is to set a MySql dump name and ignore the steps of setting up a new Zend Application instance. By setting this variable, the script will try to find this dump name inside the db folder. An example is to set `zend-dump` name and inside db folder you have the `zend-dump.sql` file

There are also inside the `vagrant/Vagrantfile` some configuration variables you might want to change. These are:
  * `config.vm.hostname`: Change the name of this hostname to be something unique for your project. Set the same also in hostname variable.
  * `config.vm.network :private_network`: This needs to be changed so that each project has its own IP in order to run multiple projects in different VMs and access them at the same time.
  * `vb.customize ['modifyvm', :id, '--cpus', '1', '--memory', 2048]`: This customization is if you want to change the number of cores and memory that will run Zend application inside the VM. 

## Extra useful information

1. The first time Vagrant will run, it will provision to setup or load from a MySql dump. After that, it will only execute the first part to boot up the VM. If you want to force it to provision after the `vagrant up` command execute `vagrant provision`.
2. Always remember to `vagrant halt` before you shut down your PC because Linux doesn't shut down the VMs automatically and it hangs in the shut down process which leaves you with the option to press the shut down button on your computer to close.
4. If for some reason the VM was misconfigured and you want to run a new one, just execute `vagrant destroy` and re-run the script. The destroy command will remove entirely the VM and it will start a fresh one. **Always before destroy, ensure that you made a database dump because after the VM is destoyed anything inside the VM will be deleted. The files will not be deleted as they exist outside of the VM**
5. In order to get inside the VM, navigate to `vagrant` folder and execute `vagrant ssh`. This will get you inside the VM in order to access your MySql or configurate some OS stuff etc.

## About the Author

[Valentinos Papasavvas](http://www.papasavvas.me/) works as a Senior Web Developer and iOS Developer in a company based in Sheffield/UK. You can find more on his [website](http://www.papasavvas.me/).
