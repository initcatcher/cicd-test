#!/bin/bash

# 환경 변수 설정
DOCKER_HUB_USERNAME=$1

if [ -z "$DOCKER_HUB_USERNAME" ]; then
    echo "Error: 첫 번째 인자로 Docker Hub 사용자명을 지정해야 합니다."
    exit 1
fi

echo "초기 배포 환경 설정 시작"

# 필요한 디렉토리 생성
mkdir -p nginx

# nginx 설정 파일 복사 (이미 존재함을 가정)
if [ ! -f "nginx/nginx.conf" ]; then
    echo "Error: nginx/nginx.conf 파일이 존재하지 않습니다."
    exit 1
fi

# 최신 이미지 가져오기
echo "최신 이미지 가져오기"
docker pull ${DOCKER_HUB_USERNAME}/demo:latest

# Blue 환경 태그 생성
echo "Blue 환경 태그 생성"
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:blue

# Green 환경 태그 생성 (같은 이미지로 시작)
echo "Green 환경 태그 생성"
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:green

# Docker Compose로 모든 서비스 시작
echo "Docker Compose로 모든 서비스 시작"
DOCKER_HUB_USERNAME=${DOCKER_HUB_USERNAME} docker-compose -f docker-compose-bluegreen.yml up -d

echo "초기 배포 환경 설정 완료!"
echo "현재 Blue 환경이 활성화되어 있습니다." 