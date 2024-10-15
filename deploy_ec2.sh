#!/bin/bash

# Vérifier si l'adresse IP de l'instance EC2 est fournie
if [ $# -eq 0 ]; then
    echo "Usage: $0 <ec2-ip-address>"
    exit 1
fi

EC2_IP=$1
EC2_USER="ec2-user"
KEY_PATH="~/.ssh/aws"
REMOTE_APP_DIR="/home/ec2-user/app"

# Fonction pour exécuter des commandes à distance
remote_exec() {
    ssh -i "$KEY_PATH" "$EC2_USER@$EC2_IP" "$1"
}

echo "Connexion à l'instance EC2 et installation de Docker et Docker Compose..."

# Mise à jour du système et installation de Docker
remote_exec "sudo yum update -y && sudo yum install docker -y && sudo systemctl start docker.service && sudo usermod -aG docker ec2-user && sudo systemctl enable docker.service"

# Installation de Docker Compose
remote_exec "sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose"

# Création du répertoire de l'application
remote_exec "mkdir -p $REMOTE_APP_DIR"

echo "Copie des fichiers locaux vers l'instance EC2..."

# Copie des fichiers locaux
scp -i "$KEY_PATH" compose.yml .env "$EC2_USER@$EC2_IP:$REMOTE_APP_DIR/"

echo "Configuration terminée. Docker et Docker Compose sont installés, et les fichiers ont été copiés."
