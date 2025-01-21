package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.BookDao;
import com.sist.web.model.Book;

@Service("bookService")
public class BookService {

	private static Logger logger = LoggerFactory.getLogger(BookService.class);

	@Autowired
	private BookDao bookDao;

	// 북 리스트 조회
	public List<Book> booklistSelect(Book book) {
		List<Book> list = null;

		try {
			list = bookDao.bookListSelect(book);
		} catch (Exception e) {
			logger.error("[BookService] booklistSelect Exception", e);
		}

		return list;
	}

	//관리자 북 리스트 조회
	public List<Book> adminBookList(Book book) {
		List<Book> list = null;

		try {
			list = bookDao.adminBookList(book);
		} catch (Exception e) {
			logger.error("[BookService] adminBookList Exception", e);
		}

		return list;
	}
	
	// 북 정보 조회
	public Book bookSelect(String bookCode, long bookSeq) {
		Book book = null;

		try {
			book = bookDao.bookSelect(bookCode, bookSeq);
		} catch (Exception e) {
			logger.error("[BookService] bookSelect Exception", e);
		}

		return book;
	}

	// 북 리스트 카운트
	public int bookListCount(Book book) {
		int count = 0;

		try {
			count = bookDao.bookListCount(book);
		} catch (Exception e) {
			logger.error("[BookService] bookListCount Exception", e);
		}

		return count;
	}

	//관리자 북 리스트 카운트
	public int adminBookCount(Book book) {
		int count = 0;

		try {
			count = bookDao.adminBookCount(book);
		} catch (Exception e) {
			logger.error("[BookService] adminBookCount Exception", e);
		}

		return count;
	}
	
	// 강의 페이지에서 교재 조회
	public Book lectureBookSelect(long courseCode) {
		Book book = null;

		try {
			book = bookDao.lectureBookSelect(courseCode);
		} catch (Exception e) {
			logger.error("[BookService] lectureBookSelect Exception", e);
		}

		return book;
	}

	// index 에서 교재 조회
	public Book bookIndexSelect(long bookSeq) {
		Book book = null;

		try {
			book = bookDao.bookIndexSelect(bookSeq);
		} catch (Exception e) {
			logger.error("[BookService] bookIndexSelect Exception", e);
		}

		return book;
	}

	// 재고 관리
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int bookQttMgr(Book book) {
		int count = 0;

		logger.debug("qttMgrChk : " + book.getQttMgrChk());

		count = bookDao.bookQttMgr(book);

		return count;
	}

//교재 수정
	public int bookUpdate(Book book) {
		int count = 0;

		try {
			count = bookDao.bookUpdate(book);
		} catch (Exception e) {
			logger.error("[BookService] bookUpdate Exception", e);
		}

		return count;
	}

	// 교재 등록
	public int bookInsert(Book book) {
		int count = 0;

		try {
			count = bookDao.bookInsert(book);
		} catch (Exception e) {
			logger.error("[BookService] bookInsert Exception", e);
		}

		return count;
	}

}
