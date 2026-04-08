# 🚀 DevOps & AWS Cloud Lab: Debian 12 Edition

[![OS](https://img.shields.io/badge/OS-Debian%2012%20(Bookworm)-D70A53?logo=debian&logoColor=white)](https://www.debian.org/)
[![Vagrant](https://img.shields.io/badge/Tool-Vagrant-1868F2?logo=vagrant&logoColor=white)](https://www.vagrantup.com/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![AWS](https://img.shields.io/badge/Cloud-AWS%20Ready-FF9900?logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Lint and Validation](https://github.com/nilo-lima/debian-devops-lab/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/nilo-lima/debian-devops-lab/actions/workflows/lint.yml)


Um ambiente de desenvolvimento e laboratório de infraestrutura **totalmente automatizado**, projetado para engenheiros DevOps e arquitetos de nuvem. Este projeto provisiona uma máquina virtual robusta, "batteries-included", pronta para práticas de **IaC (Infrastructure as Code)**, **Cloud Simulation** e **Container Orchestration**.

---

## 🛠️ O que há dentro?

Este laboratório consolida as ferramentas líderes de mercado em um único ambiente isolado:

*   **Infraestrutura como Código:** Terraform & Ansible.
*   **Containers:** Docker Engine, Docker Compose, `ctop`, `lazydocker` e `kind` (Kubernetes in Docker).
*   **Ecossistema AWS:** AWS CLI v2, AWS SAM, AWS Session Manager Plugin e `localstack` (Simulador Cloud).
*   **Networking & Monitoramento:** `nmap`, `tcpdump`, `htop`, `nload`, `iftop` e `httpie`.
*   **Developer Experience:** Oh My Posh (Prompt customizado para DevOps), Nerd Fonts e GitHub CLI (`gh`).

---

## 📖 Documentação Detalhada

Para instruções passo a passo sobre a instalação do VirtualBox/Vagrant no Host, resolução de problemas comuns (Troubleshooting) e guia de estudos, consulte o nosso guia principal:

👉 **[Acessar GUIA.md (Manual Completo de Instalação e Uso)](./GUIA.md)**

---

## ⚡ Início Rápido

### Pré-requisitos
Certifique-se de ter o [Vagrant](https://www.vagrantup.com/downloads) e o [VirtualBox](https://www.virtualbox.org/wiki/Downloads) instalados em sua máquina hospedeira.

### Provisionamento
1. Clone este repositório:
   ```bash
   git clone https://github.com/nilo-lima/debian-devops-lab
   cd debian-devops-lab
   ```

2. Inicie a máquina virtual:
   ```bash
   vagrant up
   ```

3. Acesse o ambiente:
   ```bash
   vagrant ssh
   ```

---

## 🌐 Informações de Rede

Ao subir a VM, os seguintes acessos estarão disponíveis:

| Recurso | Host (Sua Máquina) | Guest (VM) |
| :--- | :--- | :--- |
| **IP Fixo** | `192.168.56.248` | `192.168.56.248` |

---

## 📂 Estrutura do Projeto

*   `Vagrantfile`: Configuração da máquina virtual (Recursos, Rede e Sincronização).
*   `setup.sh`: Script de provisionamento principal que instala e configura toda a stack.
*   `GUIA.md`: Manual detalhado de configuração do host e guia de ferramentas.

---

## 🤝 Contribuição e Autoría

Desenvolvido para fins educacionais e profissionais por **Nilo Lima Jr**. 

Sinta-se à vontade para abrir uma *Issue* ou enviar um *Pull Request* com melhorias no script de provisionamento ou na documentação.

---
*Este ambiente foi testado e otimizado para rodar sobre o Ubuntu 24.04 LTS como sistema operacional hospedeiro.*
