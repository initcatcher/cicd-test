#!/bin/bash

# 공통 함수 불러오기
source scripts/common.sh

# 환경 변수 설정
DOCKER_HUB_USERNAME=$1
TARGET_COLOR=$2
OTHER_COLOR=""

# 매개변수 검증
check_docker_hub_username "$DOCKER_HUB_USERNAME"

if [ "$TARGET_COLOR" == "blue" ]; then
    OTHER_COLOR="green"
elif [ "$TARGET_COLOR" == "green" ]; then
    OTHER_COLOR="blue"
else
    exit_with_error "두 번째 인자로 'blue' 또는 'green'을 지정해야 합니다."
fi

print_message "${TARGET_COLOR} 환경 배포 시작"

# 새 이미지 가져오기
echo "최신 이미지를 가져오는 중..."
docker pull ${DOCKER_HUB_USERNAME}/demo:latest
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:${TARGET_COLOR}

# 타겟 컨테이너 재시작
echo "${TARGET_COLOR} 환경 컨테이너 재시작 중..."
docker-compose up -d --no-deps app-${TARGET_COLOR}

# 컨테이너가 정상적으로 시작되었는지 확인
echo "컨테이너 시작 대기 중..."
sleep 10

# 헬스체크
if ! health_check 10; then
    exit_with_error "헬스 체크 실패. 배포를 중단합니다."
fi

# Nginx 설정 업데이트 - weight를 변경하여 트래픽 전환
echo "Nginx 설정 업데이트 중..."
sed -i "s/server app-${TARGET_COLOR}:8080 weight=[0-9]*;/server app-${TARGET_COLOR}:8080 weight=10;/" ./nginx/nginx.conf
sed -i "s/server app-${OTHER_COLOR}:8080 weight=[0-9]*;/server app-${OTHER_COLOR}:8080 weight=0;/" ./nginx/nginx.conf

# Nginx 재시작으로 설정 적용
echo "Nginx 재시작 중..."
docker exec nginx nginx -s reload

print_message "배포 완료" 