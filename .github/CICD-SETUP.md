# GitHub CI/CD 설정 안내

이 프로젝트는 GitHub Actions를 사용하여 지속적 통합(CI) 및 배포(CD)를 구현합니다.

## 필요한 시크릿 설정하기

CI/CD 파이프라인이 올바르게 작동하려면 GitHub 리포지토리에 다음 시크릿을 설정해야 합니다:

### Docker Hub 인증 정보
- `DOCKER_HUB_USERNAME`: Docker Hub 사용자 이름
- `DOCKER_HUB_TOKEN`: Docker Hub 액세스 토큰 (비밀번호 대신 토큰 사용 권장)

## 시크릿 설정 방법

1. GitHub 리포지토리 페이지로 이동합니다.
2. `Settings` 탭을 클릭합니다.
3. 왼쪽 사이드바에서 `Secrets and variables` → `Actions`를 선택합니다.
4. `New repository secret` 버튼을 클릭합니다.
5. 이름 필드에 시크릿 이름(예: `DOCKER_HUB_USERNAME`)을 입력합니다.
6. 값 필드에 실제 값을 입력합니다.
7. `Add secret` 버튼을 클릭합니다.
8. 필요한 모든 시크릿에 대해 이 과정을 반복합니다.

## 워크플로우 사용자 정의

`ci-cd.yml` 파일에서 워크플로우를 프로젝트 요구 사항에 맞게 조정할 수 있습니다:

- 배포 대상 변경
- 테스트 구성 변경
- 빌드 단계 추가 또는 수정

## 주의사항

- 현재 워크플로우는 `main` 또는 `master` 브랜치에 변경 사항이 푸시되거나 이 브랜치들에 대한 풀 리퀘스트가 생성될 때 트리거됩니다.
- Docker 및 배포 작업은 `main` 또는 `master` 브랜치에 직접 푸시될 때만 실행됩니다.
- 실제 배포 작업은 프로젝트의 배포 환경에 맞게 수정해야 합니다. 