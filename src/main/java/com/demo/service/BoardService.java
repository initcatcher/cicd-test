package com.demo.service;

import java.util.List;

import com.demo.model.Board;

public interface BoardService {
    List<Board> getAllBoards();
    Board getBoardById(Long id);
    void saveBoard(Board board);
    void updateBoard(Board board);
    void deleteBoard(Long id);
    Board viewBoard(Long id); // 조회수 증가 포함
} 