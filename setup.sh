#!/bin/bash

# Captura o tempo inicial em segundos
START_TIME=$(date +%s)

echo "--- Iniciando instalação: $(date) ---"

# --- Configurações Iniciais ---
export DEBIAN_FRONTEND=noninteractive
USER_VAGRANT="vagrant"
HOME_DIR="/home/$USER_VAGRANT"

echo ""
echo "--- Iniciando instalacao do ambiente de desenvolvimento ---"

echo "--- Atualizando kernel e instalando headers genéricos ---"
sudo apt-get update

# Instala o meta-pacote que sempre aponta para a versão mais recente
sudo apt-get install -y linux-image-amd64 linux-headers-amd64 build-essential dkms


# 1. Atualização Global (Executada uma única vez no início)
echo "--- Atualizando lista de pacotes e sistema ---"
sudo apt -y update && sudo apt -y full-upgrade


# 2. Instalação de Dependências e Compiladores
# Agrupados todos os pacotes de build, bibliotecas de desenvolvimento e libs de sistema
echo "--- Instalando compiladores e bibliotecas de desenvolvimento ---"
sudo apt -y install \
    build-essential autoconf automake libtool bison g++ gcc make \
    binutils cpp flex m4 pkg-config \
    zlib1g-dev libssl-dev libncurses5-dev libncursesw5-dev \
    libreadline-dev libsqlite3-dev libgdbm-dev libdb5.3-dev \
    libbz2-dev libexpat1-dev liblzma-dev tk-dev libffi-dev \
    libgdbm-compat-dev libnss3-dev libarchive-zip-perl nodejs npm


# 3. Utilitários de Sistema, Rede e Terminal
echo "--- Instalando utilitários de rede e ferramentas CLI ---"
sudo apt -y install \
    vim curl wget git unzip zip lynx ncftp nmap openssl fontconfig \
    software-properties-common gnupg2 ca-certificates lsb-release \
    net-tools tcpdump iptraf-ng bwm-ng iftop tcptrack dstat ifstat nload htop \
    jq bash-completion gh postgresql-client python3-pip jq


# 4. Configuração do Docker (Método Oficial Debian 12)
echo "--- Preparando ambiente Docker ---"
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt -y update
sudo apt -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adicionando usuário ao grupo docker
sudo usermod -aG docker $USER_VAGRANT

# --- Configuração de Aliases e Atalhos ---
echo "Configurando aliases para Docker..."

# Atalho para Docker Compose (dc)
echo "alias dc='docker compose'" >> /home/vagrant/.bashrc

# Atalho para listar containers de forma limpa (dps)
echo "alias dps='docker ps --format \"table {{.Names}}\t{{.Status}}\t{{.Ports}}\"'" >> /home/vagrant/.bashrc

# Garante que o Bash carregue os aliases imediatamente e ajusta permissões
chown vagrant:vagrant /home/vagrant/.bashrc
source /home/vagrant/.bashrc 


# 5. Instalação de Ferramentas Python (ignr e httpie)
# No Debian 12, usamos ambientes virtuais ou o pip do sistema com cautela
echo "--- Instalando ferramentas Python (ignr e httpie) ---"
sudo pip install --upgrade --break-system-packages pip  # Força o update do pip no Debian 12
sudo pip install --break-system-packages ignr httpie


# 6. Instalação de ferramentas para DevOps
# Instalar Ansible
sudo apt install -y ansible

# Instalar Terraform
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --yes
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com bookworm main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update
sudo apt install terraform -y

# Instalar AWS CLI
echo "--- Instalando AWS CLI v2 ---"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install -y unzip
unzip awscliv2.zip
sudo ./aws/install
rm -rf awscliv2.zip aws/

# Instalando ctop
sudo wget https://github.com/bcicen/ctop/releases/download/v0.7.7/ctop-0.7.7-linux-amd64 -O /usr/local/bin/ctop
sudo chmod +x /usr/local/bin/ctop

# Instalando Lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
# O lazydocker é instalado em ~/.local/bin/ por padrão, vamos mover para o path global:
sudo mv $HOME/.local/bin/lazydocker /usr/local/bin/

# AWS SAM CLI
wget https://github.com/aws/aws-sam-cli/releases/latest/download/aws-sam-cli-linux-x86_64.zip
unzip aws-sam-cli-linux-x86_64.zip -d sam-installation
sudo ./sam-installation/install
rm -rf sam-installation aws-sam-cli-linux-x86_64.zip

# AWS Session Manager Plugin (essencial para segurança em Cloud)
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
sudo dpkg -i session-manager-plugin.deb
rm session-manager-plugin.deb

# Kiro-cli
curl -fsSL https://cli.kiro.dev/install | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Ministack (Instalação do CLI via Pip)
# O Ministack roda no Docker, mas o CLI ajuda a gerenciar o estado
pip install ministack --break-system-packages

# Baixar o binário do Kind para testar Kubernetes
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind


# 7. INSTALAÇÃO E CONFIGURAÇÃO: OH MY POSH & NERD FONTS
echo "--- Configurando Oh My Posh para DevOps ---"

# Instalar Oh My Posh
sudo curl -s https://ohmyposh.dev/install.sh | sudo bash -s -- -d /usr/local/bin

# Criar arquivo de configuração personalizado DevOps (.json)
cat <<EOF > "$HOME_DIR/.devops.omp.json"
{
  "\$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        { "foreground": "#00ff00", "style": "plain", "template": "{{ .UserName }}@{{ .HostName }} ", "type": "session" },
        { "foreground": "#4fb4d8", "properties": { "style": "folder" }, "style": "plain", "template": "{{ .Path }} ", "type": "path" },
        { "foreground": "#FFFB38", "properties": { "branch_icon": " ", "fetch_status": true }, "style": "plain", "template": "on {{ .HEAD }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }} ", "type": "git" },
        { "foreground": "#FFA500", "style": "plain", "template": " {{ .Profile }}{{ if .Region }} ({{ .Region }}){{ end }} ", "type": "aws" },
        { "foreground": "#5EADF2", "style": "plain", "template": "󱁢 {{ .WorkspaceName }} ", "type": "terraform" },
        { "foreground": "#326CE5", "style": "plain", "template": " {{.Context}}{{if .Namespace}} :: {{.Namespace}}{{end}} ", "type": "kubectl" }
      ],
      "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
        { "foreground": "#00ff00", "style": "plain", "template": "❯ ", "type": "text" }
      ],
      "type": "prompt"
    }
  ],
  "version": 2
}
EOF
chown $USER_VAGRANT:$USER_VAGRANT "$HOME_DIR/.devops.omp.json"

# Configurar o .bashrc para carregar o Oh My Posh
echo 'eval "$(oh-my-posh init bash --config ~/.devops.omp.json)"' >> "$HOME_DIR/.bashrc"


# 8. Limpeza Final
echo "--- Limpando pacotes desnecessários ---"
sudo apt -y autoremove && sudo apt -y autoclean

echo ""
echo "[OK] --- Ambiente de desenvolvimento concluido com sucesso! ---"


# Captura o tempo final
END_TIME=$(date +%s)

# Calcula a diferença
ELAPSED_TIME=$((END_TIME - START_TIME))

# Converte segundos para o formato Minutos e Segundos
MINUTOS=$((ELAPSED_TIME / 60))
SEGUNDOS=$((ELAPSED_TIME % 60))

echo "------------------------------------------------"
echo "✅ Instalação concluída com sucesso!"
echo "⏱️ Tempo total decorrido: ${MINUTOS}m ${SEGUNDOS}s"
echo "------------------------------------------------"

# ----------------------------------------------------------------------

### PASSO EXTRA: Ajustes no Sistema Operacional Nativo (Host)

### Para que a interface visual funcione corretamente, 
### realize as seguintes configurações no seu Ubuntu 24.04:

: << 'COMENTARIO_CONFIG'
# Cria o diretório de fontes se não existir
mkdir -p ~/.local/share/fonts

# Baixa a JetBrainsMono Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

# Descompacta apenas os arquivos de fonte
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts

# Atualiza o cache de fontes do sistema
fc-cache -fv

# Limpa o arquivo zip
rm JetBrainsMono.zip
COMENTARIO_CONFIG

###############################################################################
# ⚠️ ATENÇÃO: OS PASSOS ABAIXO DEVEM SER EXECUTADOS NO UBUNTU HOSPEDEIRO (HOST)
# Eles garantem que o seu terminal consiga renderizar os ícones do Oh My Posh.
###############################################################################
#
# 1. No Terminal do Ubuntu, clique no Menu (três linhas) -> Preferências.
# 2. Clique no seu perfil (ex: Padrão ou Sem nome) na barra lateral.
# 3. Vá até a aba "Texto".
# 4. Marque a caixa "Fonte personalizada".
# 5. Clique no nome da fonte atual para abrir a lista de seleção.
# 6. Procure por: "JetBrainsMono Nerd Font" (ou JetBrainsMono NF).
# 7. Clique em "Selecionar" e feche a janela de preferências.
#
# DICA: Se a fonte não aparecer, execute 'fc-cache -fv' no terminal do Host.
#
################################################################################

