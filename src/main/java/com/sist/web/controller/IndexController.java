/**
 * <pre>
 * 프로젝트명 : HiBoard
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * </pre>
 */
package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.sist.web.model.Book;
import com.sist.web.model.Teacher;
import com.sist.web.service.BookService;
import com.sist.web.service.CartService;
import com.sist.web.service.TeachService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

/**
 * <pre>
 * 패키지명   : com.icia.web.controller
 * 파일명     : IndexController.java
 * 작성일     : 2021. 1. 21.
 * 작성자     : daekk
 * 설명       : 인덱스 컨트롤러
 * </pre>
 */

@Controller("indexController")
public class IndexController {

	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	// 쿠키 이름 얻어오기
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	@Autowired
	private BookService bookService;

	@Autowired
	private CartService cartService;
	@Autowired
	private TeachService teachService;

	// 장바구니 수
	@ModelAttribute("cartCount")
	public int cartCount(HttpServletRequest request, HttpServletResponse response) {
		int cartCount = 0;
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		cartCount = cartService.cartCount(cookieUserId);

		return cartCount;
	}

	/**
	 * <pre>
	 * 메소드명   : index
	 * 작성일     : 2021. 1. 21.
	 * 작성자     : daekk
	 * 설명       : 인덱스 페이지
	 * </pre>
	 * 
	 * @param request  HttpServletRequest
	 * @param response HttpServletResponse
	 * @return String
	 */
	/*===================================================
	*   메인 화면
	===================================================*/
	@RequestMapping(value = "/index", method = RequestMethod.GET)
	public String index(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		Random random = new Random();
		List<Book> list = new ArrayList<>();

		for (int i = 0; i < 10; i++) {
			long bookNumRan = random.nextInt(899) + 1;
			Book search = bookService.bookIndexSelect(bookNumRan);

			if (search != null) {
				list.add(search);
				logger.debug("책 제목 :" + search.getBookTitle());
			}
		}
		
		List<Teacher> kor = teachService.teacherListSelect(1);
		List<Teacher> eng = teachService.teacherListSelect(2);
		List<Teacher> math = teachService.teacherListSelect(3);
		List<Teacher> social = teachService.teacherListSelect(4);
		List<Teacher> science = teachService.teacherListSelect(5);
		int korInt = (int)(Math.random() * (kor.size() - 3) + 1);
		int engInt = (int)(Math.random() * (eng.size() - 3) + 1);
		int mathInt = (int)(Math.random() * (math.size() - 3) + 1);
		int socialInt = (int)(Math.random() * (social.size() - 3) + 1);
		int scienceInt = (int)(Math.random() * (science.size() - 3) + 1);
		
		
		kor = kor.subList(korInt, korInt + 3);
		eng = eng.subList(engInt, engInt + 3);
		math = math.subList(mathInt, mathInt + 3);
		social = social.subList(socialInt, socialInt + 3);
		science = science.subList(scienceInt, scienceInt + 3);
		
		
		
		// 리스트의 크기 출력
		logger.debug("총 저장된 Book 객체 수: " + list.size());
		model.addAttribute("kor", kor);
		model.addAttribute("eng", eng);
		model.addAttribute("math", math);
		model.addAttribute("social", social);
		model.addAttribute("science", science);
		model.addAttribute("list", list);

		return "/index";
	}

	/*===================================================
	*   교재 상세 페이지로 이동
	===================================================*/
	@RequestMapping(value = "/user/bookDetail")
	public String bookDetails(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		long bookSeq = HttpUtil.get(request, "bookSeq", (long) 0);

		Book book = null;

		if (bookSeq > 0) {
			book = bookService.bookIndexSelect(bookSeq);
		}

		model.addAttribute("book", book);

		return "/book/bookDetail";
	}

}
