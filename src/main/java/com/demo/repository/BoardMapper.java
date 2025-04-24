package com.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.demo.model.Board;

@Mapper
public interface BoardMapper {
    
    // 모든 게시물 조회
    List<Board> findAll();
    
    // ID로 게시물 조회
    Board findById(Long id);
    
    // 게시물 저장
    void save(Board board);
    
    // 게시물 수정
    void update(Board board);
    
    // 게시물 삭제
    void deleteById(Long id);
    
    // 조회수 증가
    void incrementViewCount(Long id);
} 