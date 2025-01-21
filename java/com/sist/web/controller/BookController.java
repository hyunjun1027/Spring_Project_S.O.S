package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.Book;
import com.sist.web.model.Paging;
import com.sist.web.service.AccountService;
import com.sist.web.service.BookService;
import com.sist.web.service.CartService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("bookController")
public class BookController {

	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	private static final int LIST_COUNT = 5; // 한페이지의 게시물 수
	private static final int PAGE_COUNT = 5; // 페이징 수

	@Autowired
	private AccountService accountService;

	@Autowired
	private BookService bookService;

	@Autowired
	private CartService cartService;

	// 장바구니 수
	@ModelAttribute("cartCount")
	public int cartCount(HttpServletRequest request, HttpServletResponse response) {
		int cartCount = 0;
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		cartCount = cartService.cartCount(cookieUserId);

		return cartCount;
	}

	/*===================================================
	 *	교재 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/book/book")
	public String book(Model model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String classCode = HttpUtil.get(request, "classCode", "1");
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		logger.debug("classCode : " + classCode);
		logger.debug("searchType : " + searchType);
		logger.debug("searchValue : " + searchValue);

		long totalCount = 0;
		List<Book> list = null;
		Book book = new Book();
		Paging paging = null;

		// 객체에 저장할 값
		book.setClassCode(classCode);
		book.setSearchType(searchType);

		if (!StringUtil.isEmpty(searchValue)) {
			book.setSearchValue(searchValue);
		}

		totalCount = bookService.bookListCount(book);

		if (totalCount > 0) {
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

			book.setStartRow(paging.getStartRow());
			book.setEndRow(paging.getEndRow());

			list = bookService.booklistSelect(book);
		}

		// 로그인 여부 확인
		Account account;

		if (!StringUtil.isEmpty(cookieUserId)) {
			account = accountService.userSelect(cookieUserId);
		} else {
			account = null;
		}

		model.addAttribute("list", list);
		model.addAttribute("book", book);
		model.addAttribute("paging", paging);
		model.addAttribute("totalCount", totalCount);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("classCode", classCode);
		model.addAttribute("curPage", curPage);
		model.addAttribute("account", account);
		return "/book/book";
	}

	/*===================================================
	 *	교재 상세 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/book/bookDetail")
	public String bookDetails(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String classCode = HttpUtil.get(request, "classCode", "1");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		long bookSeq = HttpUtil.get(request, "bookSeq", (long) 0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");

		Book book = null;

		if (bookSeq > 0) {
			book = bookService.bookSelect(classCode, bookSeq);
		}

		// 로그인 여부 확인
		Account account;

		if (!StringUtil.isEmpty(cookieUserId)) {
			account = accountService.userSelect(cookieUserId);
		} else {
			account = null;
		}

		model.addAttribute("book", book);
		model.addAttribute("classCode", classCode);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("account", account);

		return "/book/bookDetail";
	}

}
