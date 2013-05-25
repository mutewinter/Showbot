# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.ssh.forward_agent = true

  config.vm.network :forwarded_port, guest: 5000, host: 5000

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks"]
    chef.add_recipe "apt"
    chef.add_recipe "mysql"
    chef.add_recipe "rvm::vagrant"
    chef.add_recipe "rvm::system"
    chef.json = {
      :rvm => {
        'user_installs' => [
          {
            'user' => 'vagrant',
            'default_ruby' => 'ruby-1.9.2-p320',
            'rubies' => ['1.9.2']
          }
        ],
        :rubies => [
          "1.9.2"
        ],
        :default_ruby => "ruby-1.9.2-p320",
        :user_default_ruby => "ruby-1.9.2-p320",
        'vagrant' => {
          'system_chef_solo' => '/usr/local/ruby/bin/chef-solo'
        }
      }
    }
  end
end
