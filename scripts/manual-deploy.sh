#!/bin/bash

# 공통 함수 불러오기
source scripts/common.sh

# 환경 변수 설정
DOCKER_HUB_USERNAME=$1
TARGET_COLOR=$2

# 매개변수 검증
check_docker_hub_username "$DOCKER_HUB_USERNAME"
if [ -z "$DOCKER_HUB_USERNAME" ]; then
    echo "사용법: bash manual-deploy.sh YOUR_DOCKER_HUB_USERNAME [blue|green]"
    exit 1
fi

# 배포 환경 자동 결정
if [ -z "$TARGET_COLOR" ]; then
    echo "대상 환경을 자동으로 결정합니다..."
    TARGET_COLOR=$(get_target_environment)
    
    if [ -f "nginx/nginx.conf" ]; then
        CURRENT_ENV=$(grep -Po "server app-\K(blue|green)(?=:8080 weight=10;)" nginx/nginx.conf)
        echo "현재 활성화된 환경: $CURRENT_ENV, 배포 대상 환경: $TARGET_COLOR"
    else
        echo "nginx.conf 파일이 없습니다. 기본 환경(blue)으로 배포합니다."
    fi
fi

print_message "수동 빌드 및 배포 시작"

# 1. Maven으로 빌드
build_maven

# 2. Docker 이미지 빌드
build_docker_image "$DOCKER_HUB_USERNAME" "latest"

# 3. Docker Hub 로그인
docker_hub_login "$DOCKER_HUB_USERNAME"

# 4. Docker 이미지 푸시
push_docker_image "$DOCKER_HUB_USERNAME" "latest"

# 5. 대상 환경에 태그 생성 및 푸시
echo "대상 환경 태그 생성 및 푸시 중..."
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:${TARGET_COLOR}
push_docker_image "$DOCKER_HUB_USERNAME" "$TARGET_COLOR"

# 6. 배포 스크립트 실행
echo "배포 스크립트 실행 중..."
bash scripts/deploy.sh ${DOCKER_HUB_USERNAME} ${TARGET_COLOR}

print_message "수동 빌드 및 배포 완료"
echo "애플리케이션이 ${TARGET_COLOR} 환경에 성공적으로 배포되었습니다." 