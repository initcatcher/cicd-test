# 스프링부트 프로젝트 개요

test github action


## 기술 스택
- **백엔드**: Spring Boot
- **데이터베이스**: MySQL
- **ORM**: MyBatis
- **View**: Jsp
- **인프라**: 
  - Docker & Docker Compose
  - Nginx (무중단 배포)
- **배포 방식**: 블루/그린 무중단 배포!!
- **CI/CD**: GitHub Actions

## 무중단 배포 구성

이 프로젝트는 Nginx와 블루/그린 배포 방식을 사용하여 무중단 배포를 구현하고 있습니다.

### 구성 요소
- **Nginx**: 트래픽을 블루/그린 환경으로 라우팅
- **Docker Compose**: 컨테이너 오케스트레이션
- **GitHub Actions**: CI/CD 자동화

### 시작하기

#### 1. GitHub에서 레포지토리 포크 및 클론하기
```bash
# GitHub에서 레포지토리 포크 (웹 인터페이스에서 수행)
# 포크한 레포지토리 클론하기
git clone https://github.com/your-username/your-repo.git
cd your-repo

# 원본 레포지토리를 upstream으로 추가
git remote add upstream https://github.com/original-username/original-repo.git

# 모든 브랜치 확인
git branch -a

# 필요한 브랜치로 체크아웃
git checkout main
```

### AWS EC2에 무중단 배포 환경 구성하기

#### 1. EC2 인스턴스에 접속
```bash
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

#### 2. 기본 설치 및 레포지토리 클론
```bash
# 기본 패키지 업데이트
sudo apt-get update
sudo apt-get upgrade -y

# Git 설치
sudo apt-get install -y git

# 프로젝트 디렉토리 생성 및 이동
mkdir -p ~/app
cd ~/app

# 레포지토리 클론
git clone https://github.com/your-username/your-repo.git .

# setup.sh 스크립트에 실행 권한 부여
chmod +x setup.sh
```

#### 3. setup.sh 스크립트 실행
```bash
# 스크립트 실행
./setup.sh
```

setup.sh 스크립트는 다음 작업을 자동으로 수행합니다:
- 시스템 패키지 업데이트
- Git, curl, wget 등 기본 도구 설치
- Docker 및 Docker Compose 설치
- Docker 권한 설정
- 방화벽 설정 (SSH, HTTP, HTTPS 포트 오픈)
- 타임존을 Asia/Seoul로 설정
- Swap 파일 설정 (2GB)
- 애플리케이션 디렉토리 생성 (~/app)

스크립트 실행 후 서버를 재부팅하는 것이 좋습니다:
```bash
sudo reboot
```

#### 4. 재부팅 후 무중단 배포 환경 초기 설정
```bash
# EC2 인스턴스에 다시 접속
ssh -i your-key.pem ubuntu@your-ec2-public-ip

# app 디렉토리로 이동
cd ~/app

# 스크립트 실행 권한 부여
chmod +x scripts/make-executable.sh
bash scripts/make-executable.sh

# 초기 배포 환경 설정
bash scripts/init-deploy.sh YOUR_DOCKER_HUB_USERNAME
```

초기 설정 후 블루 환경이 기본적으로 활성화됩니다.

#### 5. 애플리케이션 확인
웹 브라우저에서 `http://your-ec2-public-ip`로 접속하여 스프링부트 애플리케이션 확인

### 무중단 배포 프로세스

#### 자동 배포
1. 코드를 main/master 브랜치에 푸시합니다.
2. GitHub Actions가 자동으로 CI/CD 파이프라인을 실행합니다:
   - 코드 빌드 및 테스트
   - Docker 이미지 빌드 및 Docker Hub에 푸시
   - 현재 비활성 환경(블루 또는 그린)에 새 버전 배포
   - 헬스체크 후 성공 시 트래픽 전환

#### 수동 빌드 및 배포

필요한 경우 수동으로 빌드 및 배포할 수 있습니다:

#### 옵션 1: 통합 빌드 및 배포 스크립트 사용 (권장)

```bash
# 스크립트 실행 권한 부여
bash scripts/make-executable.sh

# 빌드와 배포를 한 번에 진행 (배포 환경 자동 선택)
bash scripts/manual-deploy.sh YOUR_DOCKER_HUB_USERNAME

# 또는 특정 환경에 배포
bash scripts/manual-deploy.sh YOUR_DOCKER_HUB_USERNAME blue
```

이 스크립트는 다음 작업을 자동으로 수행합니다:
- Maven으로 애플리케이션 빌드
- Docker 이미지 빌드
- Docker Hub에 로그인 및 이미지 푸시
- 대상 환경에 배포 (현재 활성 환경 자동 감지 후 반대 환경으로 배포)

#### 옵션 2: 개별 스크립트 사용

##### 1. Docker 이미지 빌드 및 푸시

```bash
# Docker 이미지 빌드 및 푸시
bash scripts/docker-push.sh YOUR_DOCKER_HUB_USERNAME
```

##### 2. 배포

```bash
# 블루 환경에 배포
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME blue

# 그린 환경에 배포
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME green
```

### 배포 스크립트 구조

프로젝트의 배포 스크립트는 다음과 같이 구성되어 있습니다:

- `scripts/common.sh`: 모든 스크립트에서 공통으로 사용하는 함수 모음
- `scripts/manual-deploy.sh`: 빌드부터 배포까지 모든 과정을 자동화한 통합 스크립트
- `scripts/docker-push.sh`: Docker 이미지 빌드 및 Docker Hub 푸시 전용 스크립트
- `scripts/deploy.sh`: 배포 전용 스크립트 (특정 환경에 애플리케이션 배포)
- `scripts/init-deploy.sh`: 초기 배포 환경 설정 스크립트
- `scripts/make-executable.sh`: 모든 스크립트에 실행 권한 부여 스크립트

각 스크립트는 서로 의존성이 있지만, 필요에 따라 개별적으로 실행할 수 있습니다.

### 배포 관련 확인 및 디버깅

#### 현재 활성 환경 확인
```bash
grep -Po "server app-\K(blue|green)(?=:8080 weight=10;)" nginx/nginx.conf
```

#### 컨테이너 상태 확인
```bash
docker ps
```

#### 로그 확인
```bash
# Nginx 로그 확인
docker logs nginx

# 블루 환경 로그 확인
docker logs app-blue

# 그린 환경 로그 확인
docker logs app-green
```

#### 배포 롤백
배포가 실패한 경우, 이전 환경으로 롤백할 수 있습니다:

```bash
# 현재 활성화된 환경이 블루라면, 그린 환경으로 롤백
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME green

# 현재 활성화된 환경이 그린이라면, 블루 환경으로 롤백
bash scripts/deploy.sh YOUR_DOCKER_HUB_USERNAME blue
```

## 프로젝트 개발 참여하기

### 브랜치 전략
1. 새로운 기능 개발 또는 버그 수정을 위한 브랜치 생성:
```bash
git checkout -b feature/기능명
# 또는
git checkout -b fix/버그명
```

2. 작업 완료 후 변경사항 커밋:
```bash
git add .
git commit -m "feat: 기능 설명" # 또는 "fix: 버그 수정 설명"
```

3. 원격 저장소에 푸시:
```bash
git push origin feature/기능명
```

4. GitHub에서 Pull Request 생성 후 코드 리뷰 요청

### 최신 코드 동기화하기
```bash
# 원본 레포지토리의 최신 변경사항 가져오기
git fetch upstream

# 현재 브랜치에 변경사항 적용
git merge upstream/main

# 또는 한 번에 가져와서 적용
git pull upstream main
```

## GitHub Actions CI/CD 구성

### 필요한 GitHub Secrets 설정

CI/CD 파이프라인을 위해 다음 시크릿을 설정해야 합니다:

1. `DOCKER_HUB_USERNAME`: Docker Hub 사용자명
2. `DOCKER_HUB_TOKEN`: Docker Hub 액세스 토큰
3. `SERVER_HOST`: 배포 서버 호스트 (EC2 퍼블릭 IP)
4. `SERVER_USERNAME`: 배포 서버 사용자명 (예: ubuntu)
5. `SERVER_SSH_KEY`: 배포 서버 SSH 개인키
6. `SERVER_PORT`: SSH 포트 (보통 22)

자세한 무중단 배포 구성 방법은 [BLUEGREEN-DEPLOY.md](BLUEGREEN-DEPLOY.md) 문서를 참조하세요.
