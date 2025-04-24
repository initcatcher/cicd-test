#!/bin/bash

# 환경 변수 설정
DOCKER_HUB_USERNAME=$1
TARGET_COLOR=$2
OTHER_COLOR=""

if [ "$TARGET_COLOR" == "blue" ]; then
    OTHER_COLOR="green"
elif [ "$TARGET_COLOR" == "green" ]; then
    OTHER_COLOR="blue"
else
    echo "Error: 두 번째 인자로 'blue' 또는 'green'을 지정해야 합니다."
    exit 1
fi

echo "Deploying ${TARGET_COLOR} environment"

# 새 이미지 가져오기
echo "Pulling the latest image for ${TARGET_COLOR} environment"
docker pull ${DOCKER_HUB_USERNAME}/demo:latest
docker tag ${DOCKER_HUB_USERNAME}/demo:latest ${DOCKER_HUB_USERNAME}/demo:${TARGET_COLOR}

# 타겟 컨테이너 재시작
echo "Restarting app-${TARGET_COLOR} container"
docker-compose -f docker-compose-bluegreen.yml up -d --no-deps app-${TARGET_COLOR}

# 컨테이너가 정상적으로 시작되었는지 확인
echo "Waiting for app-${TARGET_COLOR} to start"
sleep 10

# 헬스체크
MAX_RETRIES=10
RETRIES=0

while [ $RETRIES -lt $MAX_RETRIES ]; do
    STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/actuator/health -m 5)
    
    if [ "$STATUS_CODE" == "200" ]; then
        echo "Health check successful!"
        break
    else
        echo "Health check failed. Retrying in 5 seconds..."
        sleep 5
        RETRIES=$((RETRIES+1))
    fi
done

if [ $RETRIES -eq $MAX_RETRIES ]; then
    echo "Health check failed after $MAX_RETRIES attempts. Aborting deployment."
    exit 1
fi

# Nginx 설정 업데이트 - weight를 변경하여 트래픽 전환
echo "Updating Nginx configuration to route traffic to ${TARGET_COLOR}"
sed -i "s/server app-${TARGET_COLOR}:8080 weight=[0-9]*;/server app-${TARGET_COLOR}:8080 weight=10;/" ./nginx/nginx.conf
sed -i "s/server app-${OTHER_COLOR}:8080 weight=[0-9]*;/server app-${OTHER_COLOR}:8080 weight=0;/" ./nginx/nginx.conf

# Nginx 재시작으로 설정 적용
echo "Reloading Nginx"
docker exec nginx nginx -s reload

echo "Deployment completed successfully!" 