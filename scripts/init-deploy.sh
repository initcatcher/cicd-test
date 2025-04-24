#!/bin/bash

# 공통 함수 불러오기
source scripts/common.sh

# 환경 변수 설정
DOCKER_HUB_USERNAME=$1

# 매개변수 검증
check_docker_hub_username "$DOCKER_HUB_USERNAME"
if [ -z "$DOCKER_HUB_USERNAME" ]; then
    echo "사용법: bash init-deploy.sh YOUR_DOCKER_HUB_USERNAME"
    exit 1
fi

print_message "초기 배포 환경 설정 시작"

# 필요한 디렉토리 생성
mkdir -p nginx

# nginx 설정 파일 복사 (이미 존재함을 가정)
if [ ! -f "nginx/nginx.conf" ]; then
    exit_with_error "nginx/nginx.conf 파일이 존재하지 않습니다."
fi

# 최신 이미지 가져오기
echo "최신 이미지 가져오기 중..."
docker pull ${DOCKER_HUB_USERNAME}/demo:latest

# Blue/Green 환경 태그 생성
echo "Blue/Green 환경 태그 생성 중..."
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:blue
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:green

# Docker Compose로 모든 서비스 시작
echo "Docker Compose로 모든 서비스 시작 중..."
DOCKER_HUB_USERNAME=${DOCKER_HUB_USERNAME} docker-compose up -d

print_message "초기 배포 환경 설정 완료"
echo "현재 Blue 환경이 활성화되어 있습니다." 