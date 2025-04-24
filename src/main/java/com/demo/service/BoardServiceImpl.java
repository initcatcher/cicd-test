package com.demo.service;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.demo.model.Board;
import com.demo.repository.BoardMapper;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService {

    private final BoardMapper boardMapper;

    @Override
    public List<Board> getAllBoards() {
        return boardMapper.findAll();
    }

    @Override
    public Board getBoardById(Long id) {
        return boardMapper.findById(id);
    }

    @Override
    @Transactional
    public void saveBoard(Board board) {
        LocalDateTime now = LocalDateTime.now();
        board.setCreatedAt(now);
        board.setUpdatedAt(now);
        board.setViewCount(0);
        boardMapper.save(board);
    }

    @Override
    @Transactional
    public void updateBoard(Board board) {
        Board existingBoard = boardMapper.findById(board.getId());
        if (existingBoard != null) {
            board.setUpdatedAt(LocalDateTime.now());
            boardMapper.update(board);
        }
    }

    @Override
    @Transactional
    public void deleteBoard(Long id) {
        boardMapper.deleteById(id);
    }

    @Override
    @Transactional
    public Board viewBoard(Long id) {
        boardMapper.incrementViewCount(id);
        return boardMapper.findById(id);
    }
} 