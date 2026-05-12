
# **🚀 DevOps Sandbox: Laboratório de IaC e AWS Cloud com Vagrant & Docker**

Este projeto automatiza a criação de um ambiente de desenvolvimento completo utilizando **Vagrant** e **VirtualBox**. A solução provisiona uma máquina virtual rodando **Debian 12 (Bookworm)** com Docker, ferramentas de rede e DevOps, compiladores e utilitários CLI modernos.

# **🛠️ Tecnologias Incluídas**

* **OS:** Debian 12 (Stable)  
* **Container Runtime:** Docker Engine & Docker Compose (V2)  
* **Linguagens/Compiladores:** GCC, G++, Python3, Pip, Build-essential, NodeJs  
* **Ferramentas CLI:** `gh` (GitHub CLI), `httpie` (alternativa ao curl), `ignr`  
* **Monitoramento de Rede:** `htop`, `nload`, `iftop`, `nmap`, `tcpdump`  
* **Banco de Dados:** `postgresql-client`
* **DevOps:** Terrafrom, Ansible, Kubernets, Docker, Lazydocker
* **AWS:** AWS Cli, AWS SAM, AWS SSM, Kiro-cli, LocalStack

# **📋 Pré-requisitos**

Antes de começar, certifique-se de ter instalado em sua máquina hospedeira:

1. [VirtualBox](https://www.virtualbox.org/)  
2. [Vagrant](https://www.vagrantup.com/)

## Instalação do Virtual Box e Vagrant no Ubuntu

### Atualizar o sistema
```Bash
sudo apt update && sudo apt upgrade -y
```

### Instalar VirtualBox e pacotes de extensão
```Bash
sudo apt install -y virtualbox virtualbox-ext-pack
```

### Adicionar seu usuário ao grupo do VirtualBox (ajuda com permissões)
```Bash
sudo usermod -aG vboxusers $USER
```

### Adicionar a chave GPG oficial da HashiCorp (Vagrant)
```Bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
```

### Adicionar o repositório da HashiCorp
```Bash
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
```

### Instalar o Vagrant
```Bash
sudo apt update && sudo apt install -y vagrant
```

### Verificar as versões instaladas
```Bash
vboxmanage --version
vagrant --version
```

# **🚀 Como Executar**

## **1\. Clonar o repositório**

```Bash  
git clone https://github.com/nilo-lima/debian-devops-lab.git
cd debian-devops-lab
```

## **2\. Verificar os arquivos**

Certifique-se de que o arquivo `Vagrantfile` e o `setup.sh` estão na raiz do diretório.

**Importante para usuários Windows:** Certifique-se de que o arquivo `setup.sh` utiliza a codificação de final de linha **LF** (padrão Unix) e não CRLF. No VS Code, você pode alterar isso no canto inferior direito da barra de status.

## **3\. Iniciar a Máquina Virtual**

Execute o comando abaixo para baixar a imagem, configurar a rede e rodar o script de instalação automática:

```Bash  
vagrant up
```

## **4\. Acessar o Ambiente**

Assim que o processo terminar, acesse a VM via SSH:

```Bash  
vagrant ssh
```

### **🌐 Informações de Rede**

A máquina está configurada com os seguintes acessos:

* **IP Fixo (Rede Privada):** `192.168.56.248`  
* **Forwarding de Portas:**  
  * Porta `8080` do seu computador ➡️ Porta `80` da VM.  
  * Porta `8443` do seu computador ➡️ Porta `443` da VM.

### **🐳 Testando o Docker**

Dentro da VM, você pode verificar se o Docker está funcionando sem necessidade de `sudo`:

```Bash  
docker ps  
docker compose version
```

### **🧹 Comandos Úteis**

* `vagrant halt`: Desliga a máquina virtual.  
* `vagrant suspend`: Pausa a máquina (mantém o estado atual).  
* `vagrant resume`: Retoma a máquina pausada.  
* `vagrant destroy`: Exclui a máquina virtual (cuidado, apaga os dados internos).  
* `vagrant provision`: Executa o script `setup.sh` novamente sem precisar reiniciar a VM.

---

## **5\. 🛠️ Troubleshooting (Resolução de Problemas)**

Se você encontrar erros durante o `vagrant up`, verifique as soluções abaixo para os problemas mais comuns:

###  Conflito de Nome de VM (VirtualBox error: VERR\_ALREADY\_EXISTS)  
Se o Vagrant falhar informando que o nome da máquina ou a pasta já existem, execute os comandos abaixo para limpar registros órfãos:

```bash  
# Remove o registro da VM no VirtualBox  
VBoxManage unregistervm "debian-general" --delete

# Remove a pasta física residual (ajuste o caminho se necessário)  
rm -rf "/home/administrador/VirtualBox VMs/debian-general"

# Limpa o estado local do Vagrant no projeto  
rm -rf .vagrant/  
```

### Erro de Virtualização (VT-x is being used by another hypervisor)

Este erro ocorre quando o **KVM** do Linux está bloqueando o uso do processador pelo VirtualBox.

**Solução temporária (até o próximo reboot):**

```Bash  
# Para processadores AMD  
sudo modprobe -r kvm_amd  
sudo modprobe -r kvm

# Para processadores Intel  
sudo modprobe -r kvm_intel  
sudo modprobe -r kvm  
```

**Solução definitiva (Desativar KVM permanentemente):**

1. Crie o arquivo de blacklist: `sudo nano /etc/modprobe.d/blacklist-kvm.conf`

2. Adicione as linhas:  
```bash  
   blacklist kvm_intel  
   blacklist kvm_amd  
   blacklist kvm
```   

### Erro na Montagem de Pastas (Guest Additions / Kernel Headers)

Se o erro for `Unable to locate package linux-headers-$(uname -r)`, é sinal de que os índices da sua Box estão desalinhados com o repositório oficial.

Passo 1: Instale o plugin de suporte no Host

```Bash  
vagrant plugin install vagrant-vbguest  
```

Passo 2: Garanta os Headers Genéricos no Vagrantfile

Certifique-se de que seu `Vagrantfile` ou `setup.sh` contenha a instalação dos headers estáveis (que não dependem da versão exata do kernel atual):

```Bash  
config.vm.provision "shell", inline: "apt-get update && apt-get install -y linux-headers-amd64"  
```

### Box do Vagrant Desatualizada

Se você estiver enfrentando erros estranhos de rede ou pacotes, tente atualizar a imagem base do Debian:

```Bash  
# Atualiza a imagem baixada  
vagrant box update

# Aplica a nova imagem (isso recriará a VM do zero)  
vagrant destroy -f && vagrant up  
```


### DevOps e Cloud

Esta VM foi provisionada com uma stack completa de ferramentas prontas para uso:

* `Terraform:` Ferramenta de Infraestrutura como Código (IaC) que permite criar, alterar e versionar recursos de nuvem de forma declarativa.

* `Ansible:` Ferramenta de automação de TI que utiliza YAML para configurar sistemas, instalar softwares e orquestrar tarefas complexas sem agentes.

* `LocalStack:` Emulador de nuvem que permite rodar serviços da AWS (S3, Lambda, SQS) localmente em containers Docker para testes sem custo.

* `ctop:` Monitor de interface de texto (TUI) que exibe métricas de desempenho (CPU, RAM, Rede) de containers Docker em tempo real.

* `Lazydocker:` é uma interface de terminal (TUI) de código aberto projetada para facilitar o gerenciamento de ambientes Docker. Em vez de digitar comandos longos, você utiliza uma interface visual navegável pelo teclado para controlar seus containers, imagens e volumes.

* `AWS CLI:` Ferramenta unificada para gerenciar todos os serviços da AWS através de comandos no terminal.

* `AWS SAM:` Ferramenta da AWS para construir, testar localmente e fazer deploy de aplicações serverless (Lambda).

* `AWS SSM:` O Session Manager Plugin permite acessar instâncias EC2 via terminal sem precisar de chaves SSH abertas na porta 22.

* `Kiro-cli:` Interface de linha de comando para automação de tarefas e gerenciamento de infraestrutura específica em ambientes AWS.


### LocalStack (Simulador de AWS Local)
O LocalStack permite que você rode serviços da AWS (S3, Lambda, DynamoDB, SQS) dentro de containers Docker na sua VM, sem gastar dinheiro na conta real da AWS.

Por que? É a melhor forma de testar scripts de automação e infraestrutura antes de dar o "deploy" na nuvem real.

Como usar? Basta rodar via Docker Compose na sua VM:

```YAML
# exemplo de docker-compose.yml dentro da VM
services:
  localstack:
    image: localstack/localstack
    ports:
      - "4566:4566"
    environment:
      - SERVICES=s3,ec2,lambda
```


## **6\.🏗️ Como organizar seu fluxo de estudos agora?**

Com essas ferramentas instaladas, seu fluxo DevOps seguirá esta hierarquia:

- **Desenvolvimento Local:** Use o Docker e o Node.js para criar seus apps.

- **Simulação Cloud:** Use o LocalStack para testar S3 e Lambdas com o AWS SAM sem gastar nada.

- **Deploy Cloud:** Use o AWS CLI e Kiro-cli para enviar suas aplicações para a AWS real.

- **Acesso Remoto:** Use o Session Manager para entrar em suas EC2 na nuvem de forma segura.

- **Observabilidade:** Monitore tudo com ctop e Lazydocker.

---

Desenvolvido por **Nilo Lima Jr**.
