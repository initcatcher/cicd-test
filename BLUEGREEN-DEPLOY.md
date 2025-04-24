# Nginx를 활용한 무중단 배포 가이드

이 프로젝트는 Nginx를 사용한 블루/그린 배포 방식으로 Spring Boot 애플리케이션을 무중단 배포합니다.

## 구성 요소

- **Nginx**: 트래픽을 블루/그린 환경으로 라우팅
- **Spring Boot**: 자바 웹 애플리케이션
- **Docker & Docker Compose**: 컨테이너 관리
- **GitHub Actions**: CI/CD 파이프라인

## 작동 방식

1. Nginx가 현재 활성화된 환경(블루 또는 그린)으로 트래픽을 라우팅합니다.
2. 새 버전 배포 시, 현재 비활성화된 환경에 새 버전이 배포됩니다.
3. 새 버전이 성공적으로 배포되면, Nginx 설정을 업데이트하여 트래픽을 새 환경으로 전환합니다.
4. 트래픽이 완전히 전환되면 이전 환경은 대기 상태가 됩니다.

## 파일 구조

- `nginx/nginx.conf` - Nginx 설정 파일
- `docker-compose.yml` - Docker Compose 설정
- `scripts/deploy.sh` - 무중단 배포 스크립트
- `scripts/init-deploy.sh` - 초기 배포 환경 설정 스크립트
- `.github/workflows/ci-cd.yml` - GitHub Actions 워크플로우 파일

## 초기 설정

1. 필요한 GitHub Secrets 설정:
   - `DOCKER_HUB_USERNAME`: Docker Hub 사용자명
   - `DOCKER_HUB_TOKEN`: Docker Hub 액세스 토큰
   - `SERVER_HOST`: 배포 서버 호스트
   - `SERVER_USERNAME`: 배포 서버 사용자명
   - `SERVER_SSH_KEY`: 배포 서버 SSH 키
   - `SERVER_PORT`: 배포 서버 SSH 포트 (기본값: 22)

2. 서버에서 초기 배포 환경 설정:
   ```bash
   # 스크립트 실행 권한 부여
   bash scripts/make-executable.sh
   
   # 초기 배포 환경 설정
   bash scripts/init-deploy.sh YOUR_DOCKER_HUB_USERNAME
   ```

## 배포 프로세스

1. 코드를 main/master 브랜치에 푸시합니다.
2. GitHub Actions이 자동으로 CI/CD 파이프라인을 실행합니다:
   - 코드 빌드 및 테스트
   - Docker 이미지 빌드 및 푸시
   - 서버에 배포 (현재 비활성화된 환경으로)

## 수동 배포

필요한 경우 수동으로 배포할 수 있습니다:

```bash
# 블루 환경에 배포
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME blue

# 그린 환경에 배포
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME green
```

## 롤백

배포가 실패한 경우, 이전 환경으로 롤백할 수 있습니다. 새 환경에 배포했지만 아직 트래픽을 전환하지 않았다면, 단순히 Nginx 설정을 이전 상태로 유지하면 됩니다.

이미 트래픽을 전환했다면, 다시 이전 환경으로 배포 스크립트를 실행하세요:

```bash
# 현재 활성화된 환경이 blue라면, green 환경으로 롤백
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME green

# 현재 활성화된 환경이 green이라면, blue 환경으로 롤백
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME blue
``` 