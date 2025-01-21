package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Book;

@Repository("bookDao")
public interface BookDao {
	// 책 리스트 조회
	public List<Book> bookListSelect(Book book);
	
	//관리자 페이지 책 리스트 조회
	public List<Book> adminBookList(Book book);

	// 책 정보 조회
	public Book bookSelect(@Param("classCode") String classCode, @Param("bookSeq") long bookSeq);

	// 책 리스트 카운트
	public int bookListCount(Book book);
	
	//관리자 페이지 북 카운트
	public int adminBookCount(Book book);
	
	// 강의 페이지에서 교재 조회
	public Book lectureBookSelect(long courseCode);

	// 인덱스 북 리스트 조회
	public Book bookIndexSelect(long bookSeq);

	// 책 재고 관리
	public int bookQttMgr(Book book);

	// 교재 수정
	public int bookUpdate(Book book);

	// 교재 등록
	public int bookInsert(Book book);
}
