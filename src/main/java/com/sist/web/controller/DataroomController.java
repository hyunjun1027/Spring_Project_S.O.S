package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller("dataroomController")
public class DataroomController {

	/*===================================================
	 *	기출문제 화면
	 ===================================================*/
	@RequestMapping(value = "/dataroom/prevQueList", method = RequestMethod.GET)
	public String prevQueList(HttpServletRequest request, HttpServletResponse response) {
		return "/dataroom/prevQueList";
	}
}
