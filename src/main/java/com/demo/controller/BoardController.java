package com.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.demo.model.Board;
import com.demo.service.BoardService;

import lombok.RequiredArgsConstructor;

@Controller
@RequestMapping("/board")
@RequiredArgsConstructor
public class BoardController {

    private final BoardService boardService;
    
    // 게시판 목록 페이지
    @GetMapping({"", "/", "/list"})
    public String list(Model model) {
        model.addAttribute("boards", boardService.getAllBoards());
        return "board/list";
    }
    
    // 게시글 상세 페이지
    @GetMapping("/view/{id}")
    public String view(@PathVariable Long id, Model model) {
        model.addAttribute("board", boardService.viewBoard(id));
        return "board/view";
    }
    
    // 게시글 작성 폼
    @GetMapping("/write")
    public String writeForm(Model model) {
        model.addAttribute("board", new Board());
        return "board/write";
    }
    
    // 게시글 저장
    @PostMapping("/write")
    public String write(@ModelAttribute Board board) {
        boardService.saveBoard(board);
        return "redirect:/board/list";
    }
    
    // 게시글 수정 폼
    @GetMapping("/edit/{id}")
    public String editForm(@PathVariable Long id, Model model) {
        model.addAttribute("board", boardService.getBoardById(id));
        return "board/edit";
    }
    
    // 게시글 수정 저장
    @PostMapping("/edit")
    public String edit(@ModelAttribute Board board) {
        boardService.updateBoard(board);
        return "redirect:/board/view/" + board.getId();
    }
    
    // 게시글 삭제
    @GetMapping("/delete/{id}")
    public String delete(@PathVariable Long id) {
        boardService.deleteBoard(id);
        return "redirect:/board/list";
    }
} 