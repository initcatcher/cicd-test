DROP TABLE IF EXISTS board;

CREATE TABLE board (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    view_count INT DEFAULT 0
);

-- 샘플 데이터
INSERT INTO board (title, content, author, created_at, updated_at, view_count)
VALUES 
('첫 번째 게시글', '게시판의 첫 번째 게시글입니다.', '관리자', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 0),
('두 번째 게시글', '게시판의 두 번째 게시글입니다.', '사용자1', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 0),
('환영합니다', '게시판에 오신 것을 환영합니다.', '관리자', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP(), 0); 