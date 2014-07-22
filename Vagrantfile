# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  # Shared folders, this dir will be synced to /vagrant
  config.vm.synced_folder '.', '/vagrant'

  # Build machines

  machines = {
    :precise => 'https://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box',
    :wheezy  => 'http://puppet-vagrant-boxes.puppetlabs.com/debian-73-x64-virtualbox-puppet.box',
  }

  machines.each_pair do |dist, box_url|

    config.vm.define :"#{dist}-build" do |build|

      build.vm.box      = "audiowaveform-#{dist}"
      build.vm.box_url  = box_url
      build.vm.hostname = :"#{dist}-build"

      build.vm.provision 'shell', :inline => %Q{

       # Update apt
       apt-get update

       # Install build dependencies
       apt-get install -y build-essential              \
                          cdbs                         \
                          cmake                        \
                          debhelper                    \
                          devscripts                   \
                          git-core                     \
                          libboost-filesystem-dev      \
                          libboost-program-options-dev \
                          libboost-regex-dev           \
                          libgd2-xpm-dev               \
                          libmad0-dev                  \
                          libsndfile1-dev              \
                          ntp                          \
                          pbuilder                     \
                          valgrind

        # Install gmock

        cd /vagrant
        wget -O gmock-1.7.0.zip https://googlemock.googlecode.com/files/gmock-1.7.0.zip
        unzip -o gmock-1.7.0.zip
        rm -f gmock
        ln -s gmock-1.7.0 gmock

        # Create pbuilder env

        pbuilder create --distribution #{dist} \
          --debootstrapopts --variant=buildd

      }
    end

    # Deployment machine
    config.vm.define :"#{dist}-deploy" do |deploy|
      deploy.vm.box      = "audiowaveform-#{dist}"
      deploy.vm.box_url  = box_url
      deploy.vm.hostname = :"#{dist}-deploy"
      deploy.vm.provision 'shell', :inline => 'apt-get update'
    end

  end

end

