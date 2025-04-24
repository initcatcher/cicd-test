#!/bin/bash

# 공통 함수 및 변수를 정의하는 스크립트
# 다른 스크립트에서 source로 불러와 사용

# 상태 메시지 출력 함수
print_message() {
    echo "===== $1 ====="
}

# 에러 메시지 출력 및 종료 함수
exit_with_error() {
    echo "Error: $1"
    exit 1
}

# Docker Hub 사용자명 확인 함수
check_docker_hub_username() {
    if [ -z "$1" ]; then
        exit_with_error "Docker Hub 사용자명을 지정해야 합니다."
    fi
}

# Maven 빌드 함수
build_maven() {
    print_message "Maven으로 애플리케이션 빌드 중"
    ./mvnw clean package
    if [ $? -ne 0 ]; then
        exit_with_error "Maven 빌드 실패"
    fi
}

# Docker 이미지 빌드 함수
build_docker_image() {
    local username=$1
    local tag=$2
    
    print_message "Docker 이미지 빌드 중"
    docker build -t ${username}/demo:${tag} .
    if [ $? -ne 0 ]; then
        exit_with_error "Docker 이미지 빌드 실패"
    fi
}

# Docker Hub 로그인 함수
docker_hub_login() {
    local username=$1
    
    print_message "Docker Hub 로그인"
    echo "Docker Hub에 로그인합니다. 비밀번호 또는 토큰을 입력하세요."
    docker login -u ${username}
    if [ $? -ne 0 ]; then
        exit_with_error "Docker Hub 로그인 실패"
    fi
}

# Docker 이미지 푸시 함수
push_docker_image() {
    local username=$1
    local tag=$2
    
    print_message "Docker 이미지 푸시 중"
    docker push ${username}/demo:${tag}
    if [ $? -ne 0 ]; then
        exit_with_error "Docker 이미지 푸시 실패"
    fi
}

# Blue/Green 환경 전환 계산 함수
get_target_environment() {
    if [ -f "nginx/nginx.conf" ]; then
        CURRENT_ENV=$(grep -Po "server app-\K(blue|green)(?=:8080 weight=10;)" nginx/nginx.conf)
        
        if [ "$CURRENT_ENV" == "blue" ]; then
            echo "green"
        else
            echo "blue"
        fi
    else
        # nginx.conf가 없는 경우 기본값으로 blue 반환
        echo "blue"
    fi
}

# 헬스 체크 함수
health_check() {
    local max_retries=$1
    local retries=0
    
    print_message "애플리케이션 헬스 체크 중"
    
    while [ $retries -lt $max_retries ]; do
        STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/actuator/health -m 5)
        
        if [ "$STATUS_CODE" == "200" ]; then
            echo "Health check successful!"
            return 0
        else
            echo "Health check failed. Retrying in 5 seconds... (${retries}/${max_retries})"
            sleep 5
            retries=$((retries+1))
        fi
    done
    
    return 1
} 