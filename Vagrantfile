Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/focal64'
  config.vm.box_version = '20200825.0.0'
  config.vm.box_check_update = false
  # config.ssh.insert_key = false
  config.vbguest.auto_update = false

  config.vm.provider 'virtualbox' do |vb|
    # Vagrant box startup timeout due to no serial port
    # https://bugs.launchpad.net/cloud-images/+bug/1829625
    vb.customize ['modifyvm', :id, '--uartmode1', 'file', File::NULL]

    # vb.gui = true
    vb.check_guest_additions = false

    vb.linked_clone = true
    vb.memory = 1024
    vb.cpus = 2
  end

  # PRIMARY
  config.vm.define 'primary', primary: true do |server|
    server.vm.hostname = 'primary'

    server.vm.network :private_network, ip: '10.0.0.101', netmask: '255.255.0.0'
    server.vm.network :forwarded_port, guest: 27_017, host: 27_018
    # server.vm.network :forwarded_port, guest: 22, host: 10_122

    server.vm.provider :virtualbox

    (0..2).each do |i|
      server.vm.disk :disk, size: '300MB', name: "disk-primary-#{i}"
    end
  end

  # ARBITER
  config.vm.define 'arbiter' do |server|
    server.vm.hostname = 'arbiter'

    server.vm.network :private_network, ip: '10.0.0.102', netmask: '255.255.0.0'
    server.vm.network :forwarded_port, guest: 27_017, host: 27_019
    # server.vm.network :forwarded_port, guest: 22, host: 10_222

    # server.vm.network :forwarded_port, guest: 80, host: 8880
    # server.vm.network :forwarded_port, guest: 443, host: 8443

    server.vm.provider 'virtualbox' do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
  end

  # MONITORING
  config.vm.define 'monitor' do |server|
    server.vm.hostname = 'monitor'

    server.vm.network :private_network, ip: '10.0.0.200', netmask: '255.255.0.0'

    server.vm.network :forwarded_port, guest: 80, host: 8880
    server.vm.network :forwarded_port, guest: 443, host: 8443

    server.vm.provider 'virtualbox' do |vb|
      vb.memory = 1024
      vb.cpus = 2
    end
  end

  # SECONDARY 0
  config.vm.define 'secondary-0' do |server|
    server.vm.hostname = 'secondary-0'

    server.vm.network :private_network, ip: '10.0.0.103', netmask: '255.255.0.0'
    server.vm.network :forwarded_port, guest: 27_017, host: 27_020
    # server.vm.network :forwarded_port, guest: 22, host: 10_322

    server.vm.provider :virtualbox

    (0..2).each do |i|
      server.vm.disk :disk, size: '300MB', name: "disk-secondary0-#{i}"
    end
  end

  # SECONDARY 1
  # config.vm.define 'secondary-1' do |server|
  #   server.vm.hostname = 'secondary-1'

  #   server.vm.network :private_network, ip: '10.0.0.104', netmask: '255.255.0.0'
  #   server.vm.network :forwarded_port, guest: 27_017, host: 27_021
  #   # server.vm.network :forwarded_port, guest: 22, host: 10_422

  #   server.vm.provider :virtualbox

  #   (0..2).each do |i|
  #     server.vm.disk :disk, size: '300MB', name: "disk-secondary1-#{i}"
  #   end
  # end

  config.vm.provision :ansible do |ansible|
    # ansible.verbose = 'vvvv'
    # ansible.playbook = 'provisioning/playbook.yml'
    # https://martincarstenbach.wordpress.com/2019/04/11/ansible-tipsntricks-provision-multiple-machines-in-parallel-with-vagrant-and-ansible/
    ansible.playbook = 'provisioning/check.yml'
    ansible.groups = {
      'primaries' => ['primary'],
      'arbiters' => ['arbiter'],
      'monitoring' => ['monitor'],
      'secondaries' => %w[
        secondary-0
        secondary-1
      ]
    }
    ansible.host_vars = {
      'primary' => { 'host_ip' => '10.0.0.101' },
      'arbiter' => { 'host_ip' => '10.0.0.102' },
      'monitor' => { 'host_ip' => '10.0.0.200' },
      'secondary-0' => { 'host_ip' => '10.0.0.103' },
      # 'secondary-1' => { 'host_ip' => '10.0.0.104' }
    }
  end
end
