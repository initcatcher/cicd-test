#!/bin/bash

# 애플리케이션 빌드
echo "=== Maven으로 애플리케이션 빌드 ==="
./mvnw clean package -DskipTests

# 도커 컴포즈로 애플리케이션 실행
echo "=== 도커 컴포즈로 애플리케이션 실행 ==="
docker-compose -f docker-compose-local.yml down  # 기존 컨테이너 중지 및 제거
docker-compose -f docker-compose-local.yml up -d --build  # 컨테이너 빌드 및 백그라운드로 실행

echo "=== 배포 완료 ==="
echo "애플리케이션 접속 URL: http://localhost"
echo "직접 접속 URL: http://localhost:8080" 