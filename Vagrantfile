# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Configurações globais
  config.vm.box = "debian/bookworm64" # Versão 12 Estável

  # Desativa a atualização automática errática do plugin vbguest
  # Isso evita que ele tente instalar headers específicos que podem não existir mais no repo.
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false 
  end
  
  config.vm.define "formacao-aws" do |general|
    general.vm.hostname = "formacao-aws.domain.local"      

    # Melhores Práticas: auto_correct evita falhas se a porta 80 estiver ocupada no host
    #general.vm.network "forwarded_port", guest: 80, host: 8080, auto_correct: true
    #general.vm.network "forwarded_port", guest: 443, host: 8443, auto_correct: true
    
    # Rede Privada (Host-only)
    general.vm.network "private_network", ip: "192.168.56.250"

    general.vm.provider "virtualbox" do |vb|
      vb.memory = 2048 # 2GB de RAM
      vb.cpus = 2
      vb.name = "formacao-aws"
      
      # Desabilitar interface gráfica (headless mode)
      vb.gui = false
    
    end
    
    # PREPARAÇÃO: Garante que o sistema esteja atualizado ANTES do setup.sh
    # O uso do linux-headers-amd64 (meta-pacote) evita o erro de "package not found"
    general.vm.provision "shell", inline: <<-SHELL
      echo "Limpando e atualizando repositórios..."
      apt-get update
      apt-get install -y linux-headers-amd64 build-essential dkms
    SHELL

    # PROVISIONAMENTO PRINCIPAL: Executa o script setup.sh
    general.vm.provision "shell", path: "setup.sh"
    
  end
end