#!/bin/bash

# 공통 함수 불러오기
source scripts/common.sh

# 환경 변수 설정
DOCKER_HUB_USERNAME=$1
TAG=${2:-latest}  # 기본값은 latest

# 매개변수 검증
check_docker_hub_username "$DOCKER_HUB_USERNAME"
if [ -z "$DOCKER_HUB_USERNAME" ]; then
    echo "사용법: bash docker-push.sh YOUR_DOCKER_HUB_USERNAME [TAG]"
    exit 1
fi

print_message "Docker 이미지 빌드 및 푸시 시작"

# JAR 파일 확인
if [ ! -f "target/demo-"*".jar" ]; then
    echo "JAR 파일이 없습니다. Maven으로 빌드합니다."
    build_maven
fi

# Docker 이미지 빌드
build_docker_image "$DOCKER_HUB_USERNAME" "$TAG"

# Docker Hub 로그인
docker_hub_login "$DOCKER_HUB_USERNAME"

# Docker 이미지 푸시
push_docker_image "$DOCKER_HUB_USERNAME" "$TAG"

# Blue 및 Green 태그 생성 및 푸시
print_message "Blue/Green 태그 생성 및 푸시"
docker tag ${DOCKER_HUB_USERNAME}/demo:${TAG} ${DOCKER_HUB_USERNAME}/demo:blue
docker push ${DOCKER_HUB_USERNAME}/demo:blue

docker tag ${DOCKER_HUB_USERNAME}/demo:${TAG} ${DOCKER_HUB_USERNAME}/demo:green
docker push ${DOCKER_HUB_USERNAME}/demo:green

print_message "Docker 이미지 빌드 및 푸시 완료"
echo "이미지: ${DOCKER_HUB_USERNAME}/demo:${TAG}"
echo "Blue/Green 태그도 푸시되었습니다." 