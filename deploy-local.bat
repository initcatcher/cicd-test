@echo off
echo === Maven으로 애플리케이션 빌드 ===
call mvnw clean package -DskipTests

echo === 도커 컴포즈로 애플리케이션 실행 ===
docker-compose -f docker-compose-local.yml down
docker-compose -f docker-compose-local.yml up -d --build

echo === 배포 완료 ===
echo 애플리케이션 접속 URL: http://localhost
echo 직접 접속 URL: http://localhost:8080 