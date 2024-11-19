Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  # Network configuration
  config.vm.network "public_network", ip: "192.168.1.111"
  config.vm.hostname = 'k8s-master-01'

  # VMware Provider Configuration
  config.vm.provider :vmware_workstation do |v|
    v.gui = true
    v.vmx['virtualHW.version'] = '19'
    v.vmx['guestOS'] = 'ubuntu-64'
    v.vmx["numvcpus"] = "2"
    v.vmx["cpuid.coresPerSocket"] = "2"
    v.vmx["vhv.enable"] = "TRUE"
    v.vmx["memsize"] = "4096"
    v.vmx["displayname"] = "k8s-master-01"
  end

  #config.vm.synced_folder "", ""   # enable sycned folder for vm

  # Provisioning commands
  config.vm.provision "shell", inline: <<-SHELL

    # Disable SELinux (for CentOS/RHEL, not applicable for Ubuntu)
    if [ -f /etc/sysconfig/selinux ]; then
      setenforce 0
      sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux
    fi

    # Change root password and enable SSH login for root
    echo "root:123" | chpasswd
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
    systemctl reload sshd

    # Update hostname 
    # Define entries to add
        HOSTS=(
          "192.168.1.111 k8s-master-1"
          "192.168.1.112 k8s-master-2"
          "192.168.1.113 k8s-master-3"
        )

        # Iterate and add each entry if it doesn't exist
        for HOST in "${HOSTS[@]}"; do
          if ! grep -q "$HOST" /etc/hosts; then
            echo "$HOST" | sudo tee -a /etc/hosts > /dev/null
          else
            echo "$HOST already exists in /etc/hosts"
          fi
        done

  SHELL

end
