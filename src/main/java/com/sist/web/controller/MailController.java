package com.sist.web.controller;

import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Mail;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.Response;
import com.sist.web.service.AccountService;
import com.sist.web.service.MailService;
import com.sist.web.service.OrderService;
import com.sist.web.util.HttpUtil;

@Controller("mailController")
public class MailController {
	private static Logger logger = LoggerFactory.getLogger(MailController.class);
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;
	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	@Autowired
	private AccountService accountService;

	@Autowired
	private MailService mailService;
	
	@Autowired
	private OrderService orderService;

	// 6자리 숫자 + 대문자영어 난수 생성
	public String randomCode(int len) {
		// 사용할 문자 집합 정의 (숫자 + 대문자)
		String characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		SecureRandom random = new SecureRandom();
		StringBuilder code = new StringBuilder(len);

		for (int i = 0; i < len; i++) {
			int index = random.nextInt(characters.length());
			code.append(characters.charAt(index));
		}

		return code.toString();
	}
	
	// 주문내역 이메일 전송
	//public void sendOrderEmail (HttpServletRequest request, HttpServletResponse response, long orderSeq) throws Exception {
	public void sendOrderEmail (long orderSeq) {
		
		//request.setCharacterEncoding("utf-8");
		// response.setContentType("text/html;charset=utf-8");
		
		logger.debug("============================");
		logger.debug("|     주문 내역 이메일 전송 시작     |");
		logger.debug("============================");
		Order order = new Order();
		if (orderSeq > 0) {
			
			Mail mail = new Mail();
			Account account;
			
			logger.debug("orderSeq: " + orderSeq);
			logger.debug("1111111111111");
			
			order = orderService.orderSelect(orderSeq);
			
			logger.debug("order : " + order);
			
			logger.debug("order : " + order.getUserId() + ", userType : " + order.getUserType()); 
			
			// 학생
			if (StringUtil.equals(order.getUserType(), "U")) {
				account = accountService.userSelect(order.getUserId());
			}
			// 강사
			else {
				account = accountService.teacherSelect(order.getUserId());
			}
			
			List<OrderDetail> odl = orderService.orderDetailSelect(order.getOrderSeq());
			DeliveryInfo di = orderService.deliInfoSelect(order.getOrderSeq());
			
			String subject = "";
			String content = "";
			
			subject = "[S.O.S] 주문 안내";
			
			content = "<div style='max-width: 700px; margin: auto; padding: 40px; font-family: Arial, sans-serif; background-color: #f9f9f9;'>" + 
		              "<div style='margin-bottom: 50px; text-align: center;'>" + 
		              "<img src='cid:logo' alt='Logo' style='width: 150px; height: auto;'>" + 
		              "</div>" + 

		              "<div style='border-top: 3px solid rgb(57, 57, 57); border-bottom: 1px solid gray; padding: 30px; text-align: center; margin-bottom: 30px'>" + 
		              "<p style='font-size: 28px; margin-bottom: 20px; font-weight: bold;'><span style='color: #030605;'>주문 완료</span></p>" + 

		              "<p style='color: #000000; font-size: 18px; line-height: 1.6; margin: 50px 0px;'>" + 
		              "<b>고객님의 주문이 확인되었습니다.</b><br>" + 
		              account.getUserName() + "님의 " + order.getOrderSeq() + " 주문이 정상적으로 확인 되었습니다.<br>" + 
		              "주문내역 및 배송정보는 <a href='http://localhost:8088/user/paymentHistoryDetail?orderSeq= " + order.getOrderSeq() + "' style='color: black;'>마이페이지 > 주문조회</a>에서 확인하실 수 있습니다.<br>" + 
		              "</p>" + 

		              "<table style='width: 100%; border-collapse: collapse; margin: 20px 0; background-color: #ffffff; border: 1px solid rgb(212, 212, 212); border-radius: 3px;'>" + 
		              "<tr>" + 
		              "<th colspan='2' style='padding: 20px; text-align: left; border: 1px solid #dddddd; background-color: #e0e0e0; font-weight: bold;'>주문정보</th>" + 
		              "</tr>" + 
		              "<tr style='border-bottom: 1px solid #dddddd;'>" + 
		              "<td style='padding: 20px; text-align: left;'>주문일자</td>" + 
		              "<td style='padding: 20px; text-align: left;'>" + order.getOrderDate() + "</td>" + 
		              "</tr>" + 
		              "<tr style='border-bottom: 1px solid #dddddd;'>" + 
		              "<td style='padding: 20px; text-align: left;'>주문번호</td>" + 
		              "<td style='padding: 20px; text-align: left;'>" + order.getOrderSeq() + "</td>" + 
		              "</tr>" + 

		              "<tr style='border-bottom: 1px solid #dddddd;'>" + 
		              "<td style='padding: 20px; text-align: left;'>상품정보</td>" + 
		              "<td style='padding: 20px; text-align: left;'>" + 
		              "<table style='width: 100%; border-collapse: collapse; border-style: none;'>" + 
		              "<tr style='border-bottom: 1px solid black;'>" + 
		              "<td style='padding: 10px;'>상품명</td>" + 
		              "<td style='padding: 10px;'>주문수량</td>" + 
		              "<td style='padding: 10px;'>상품<br>가격</td>" + 
		              "</tr>";
		              
		  for (OrderDetail od : odl) {
			  content +=  "<tr style='border-bottom: 1px solid rgb(207, 207, 207);'>" + 
		              "<td style='padding: 10px;'>" + od.getProName() + "</td>" + 
		              "<td style='padding: 10px;'>" + od.getOrderCnt() + "</td>" + 
		              "<td style='padding: 10px;'>" + String.format("%,d", od.getPayPrice()) + "</td>" + 
		              "</tr>";
		  }
		              
		  content +=  "</table>" + 
		              "</td>" + 
		              "</tr>" + 
		              
		              "<tr style='border-bottom: 1px solid #dddddd;'>" + 
		              "<td style='padding: 20px; text-align: left;'>결제정보</td>" + 
		              "<td style='padding: 20px; text-align: left;'>최종 결제 금액 : " +  String.format("%,d", order.getPayPrice()) + "원</td>" + 
		              "</tr>" + 
		              "<tr style='border-bottom: 1px solid #dddddd;'>" + 
		              "<td style='padding: 20px; text-align: left; vertical-align: top;'>배송정보</td>" + 
		              "<td colspan='2' style='padding: 20px; text-align: left; color: #555; vertical-align: top;'>" + 
		              "수령인 : " + di.getDlvName() + "<br>" + 
		              "주소 : [" + di.getAddrCode() + "] " + di.getAddrBase() + " " + di.getAddrDetail() + "<br>" + 
		              "핸드폰 : " + di.getUserPhone().substring(0, 3) + "-" + di.getUserPhone().substring(3, 7) + "-" + di.getUserPhone().substring(7) + "<br>" + 
		              "배송메세지 : 문앞에 두고 가주세요.<br>" + 
		              "</td>" + 
		              "</tr>" + 
		              "</table>" + 

		              "</div>" + 

		              "<p style='color: #777; font-size: 16px;'>" + 
		              "본 메일은 발신전용 메일이므로 문의 및 회신하실 경우 답변되지 않습니다.<br>" + 
		              "메일 내용에 대해 궁금한 사항이 있으시면 고객센터로 문의하여 주시기 바랍니다.<br>" + 
		              "<p>©2025 S.O.S All rights reserved.</p>" + 
		              "</p>" + 
		              "</div>";
		  
		  mailService.sendMail(account.getUserEmail(), subject, content);
			
		}
		else {
			logger.debug("오류 : 값 넘어오지 않음");
			logger.debug("orderSeq : " + orderSeq);
		}
		
		
		
		// 주문 완료
		
		// 주문 취소
	}


	// ========================================================================================================================================================================================================
	// 인증번호 발급 및 전송
	@RequestMapping(value = "/mail/sendMail", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> sendMail(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Response<Object> res = new Response<Object>();
		logger.debug("================================");
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");

		String userId = HttpUtil.get(request, "userId", "");
		String rating = HttpUtil.get(request, "rating", "");
		String userEmail = HttpUtil.get(request, "userEmail", "");
		Account account;
		logger.debug("=======================");
		logger.debug("|     이메일 전송 시작     |");
		logger.debug("=======================");
		logger.debug("userId    : " + userId);
		logger.debug("userEmail : " + userEmail);
		logger.debug("=======================");

		if (!StringUtil.isEmpty(userEmail)) {
			// 인증번호를 보낸게 존재하면 db에서 삭제
			if (mailService.mailSelect(userEmail) != null)
				mailService.mailDelete(userEmail);

			Mail mail = new Mail();

			mail.setUserEmail(userEmail);

			if (StringUtil.equals(rating, "U")) {
				account = accountService.userSelect(userId);
			} else if (StringUtil.equals(rating, "T")) {
				account = accountService.teacherSelect(userId);
			} else {
				account = null;
			}

			String subject = "";
			String content = "";

			if (account == null) {
				String auth = randomCode(6);
				mail.setAuthNum(auth);
				subject = "[S.O.S] 회원가입 이메일 인증번호 안내";
				
				content = "<div style='max-width: 700px; margin: auto; padding: 40px; background-color: #f9f9f9;'>" + 
				          "<div style='margin-bottom: 50px; text-align: center;'>" + 
				          "<img src='cid:logo' alt='Logo' style='width: 150px; height: auto;'>" + 
				          "</div>" + 
				          "<div style='border-top: 3px solid rgb(57, 57, 57); border-bottom: 1px solid gray; padding: 30px; text-align: center; margin-bottom: 30px;'>" + 
				          "<p style='font-size: 28px; margin-bottom: 20px; font-weight: bold;'><span style='color: #030605;'>이메일 인증번호</span> 안내 드립니다.</p>" + 
				          "<p style='color: #000000; font-size: 18px; line-height: 1.6; margin: 50px 0px;'>" + 
				          "본 이메일은 S.O.S 회원가입을 위한 필수 사항입니다.<br>" + 
				          "아래 [이메일 인증번호]를 홈페이지에 입력하여<br> 남은 회원가입 절차를 완료해 주시기를 바랍니다.<br>" + 
				          "</p>" + 
				          "<div style='background-color: #e6e6e6; padding: 20px; border-radius: 2px; margin: 30px 0;'>" + 
				          "<h2 style='color: #000000; font-size: 36px; margin: 0; text-align: center;'>" + auth + "</h2>" + 
				          "</div>" + 
				          "</div>" + 
				          "<p style='color: #777; font-size: 16px;'>" + 
				          "본 메일은 발신전용 메일이므로 문의 및 회신하실 경우 답변되지 않습니다.<br>" + 
				          "메일 내용에 대해 궁금한 사항이 있으시면 고객센터로 문의하여 주시기 바랍니다.<br>" + 
				          "<p>© 2025 S.O.S All rights reserved.</p>" + 
				          "</p>" + 
				          "</div>";
				
				mailService.mailInsert(mail);
			} else {

				String tempPwd = randomCode(12);
				logger.debug(tempPwd + "============");
				if (StringUtil.equals(rating, "U")) {
					if (accountService.userPwdChange(userId, tempPwd) > 0) {
						accountService.userStatusupdate(userId, "P");
					} else {
						res.setResponse(500, "internal server error");
					}
				} else if (StringUtil.equals(rating, "T")) {
					if (accountService.teacherPwdChange(userId, tempPwd) > 0) {
						accountService.teacherStatusupdate(userId, "P");
					} else {
						res.setResponse(500, "internal server error");
					}
				}
				mail.setAuthNum(tempPwd);
				subject = "[S.O.S] 임시 비밀번호 안내";
				
				content = "<div style='max-width: 700px; margin: auto; padding: 40px; background-color: #f9f9f9;'>" + 
	                      "<div style='margin-bottom: 50px; text-align: center;'>" + 
	                      "<img src='cid:logo' alt='Logo' style='width: 150px; height: auto;'>" + 
	                      "</div>" + 
	                      "<div style='border-top: 3px solid rgb(57, 57, 57); border-bottom: 1px solid gray; padding: 30px; text-align: center; margin-bottom: 30px;'>" + 
	                      "<p style='font-size: 28px; margin-bottom: 20px; font-weight: bold;'><span style='color: #030605;'>임시 비밀번호</span> 안내 드립니다.</p>" + 
	                      "<p style='color: #000000; font-size: 18px; line-height: 1.6; margin: 50px 0px;'>" + 
	                      "아래의 임시 비밀번호를 입력하여 로그인 해주세요.<br>" + 
	                      "로그인 후, 비밀번호 변경을 권장드립니다.<br>" + 
	                      "</p>" + 
	                      "<div style='background-color: #e6e6e6; padding: 20px; border-radius: 2px; margin: 30px 0;'>" + 
	                      "<h2 style='color: #000000; font-size: 36px; margin: 0; text-align: center;'>" + tempPwd + "</h2>" + 
	                      "</div>" + 
	                      "</div>" + 
	                      "<p style='color: #777; font-size: 16px;'>" + 
	                      "본 메일은 발신전용 메일이므로 문의 및 회신하실 경우 답변되지 않습니다.<br>" + 
	                      "메일 내용에 대해 궁금한 사항이 있으시면 고객센터로 문의하여 주시기 바랍니다.<br>" + 
	                      "<p>© 2025 S.O.S All rights reserved.</p>" + 
	                      "</p>" + 
	                      "</div>";
			}

			mailService.sendMail(userEmail, subject, content);

			res.setResponse(0, "Success");
		} else
			res.setResponse(400, "Bad Request");

		return res;
	}

	// ========================================================================================================================================================================================================
	// 인증번호 체크
	@RequestMapping(value = "/mail/authCheck", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> authCheck(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Response<Object> res = new Response<Object>();

		String userEmail = HttpUtil.get(request, "userEmail", "");
		String authNum = HttpUtil.get(request, "authNum", "0");

		if (!StringUtil.isEmpty(userEmail)) {
			Mail mail = mailService.mailSelect(userEmail);

			if (mail != null) {
				if (StringUtil.equals(mail.getAuthNum(), authNum)) {
					mailService.mailDelete(userEmail);

					res.setResponse(0, "Success");
				} else
					res.setResponse(100, "Disagreement Authnum");

			} else
				res.setResponse(404, "Not Found");

		} else
			res.setResponse(400, "Bad Request");

		return res;
	}

	// ========================================================================================================================================================================================================
	// 인증번호 소멸
	@RequestMapping(value = "/mail/authDel", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> authDel(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Response<Object> res = new Response<Object>();

		String userEmail = HttpUtil.get(request, "userEmail", "");

		if (!StringUtil.isEmpty(userEmail)) {
			Mail mail = mailService.mailSelect(userEmail);

			if (mail != null) {
				if (mailService.mailDelete(userEmail) > 0)
					res.setResponse(0, "Success");
				else
					res.setResponse(500, "Internal Server Error");

			} else
				res.setResponse(404, "Not Found");

		} else
			res.setResponse(400, "Bad Request");

		return res;
	}

}
