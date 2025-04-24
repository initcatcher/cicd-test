#!/bin/bash

# EC2 인스턴스 초기 설정 스크립트
echo "EC2 인스턴스 셋업을 시작합니다..."

# 시스템 업데이트
echo "시스템 패키지 업데이트 중..."
sudo apt-get update -y
sudo apt-get upgrade -y

# 기본 도구 설치
echo "기본 도구 설치 중..."
sudo apt-get install -y \
    git \
    curl \
    wget \
    unzip \
    vim \
    software-properties-common

# JDK 21 설치 (빌드에 필요)
echo "JDK 21 설치 중..."
sudo apt-get install -y openjdk-21-jdk
echo "JAVA_HOME 환경 변수 설정 중..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Maven 설치
echo "Maven 설치 중..."
sudo apt-get install -y maven

# Docker 설치
echo "Docker 설치 중..."
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Docker Compose 설치
echo "Docker Compose 설치 중..."
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Docker 권한 설정
echo "Docker 권한 설정 중..."
sudo usermod -aG docker $USER

# 방화벽 설정
echo "방화벽 설정 중..."
sudo apt-get install -y ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
sudo ufw --force enable

# 타임존 설정
echo "타임존 설정 중..."
sudo timedatectl set-timezone Asia/Seoul

# 프로젝트 디렉토리 생성
echo "프로젝트 디렉토리 생성 중..."
mkdir -p ~/app

echo "EC2 인스턴스 셋업이 완료되었습니다!"
echo "서버를 재시작하여 모든 변경사항이 적용되도록 하세요." 