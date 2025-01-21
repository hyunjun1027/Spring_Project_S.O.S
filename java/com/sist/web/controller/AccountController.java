package com.sist.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.CartService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("accountController")
public class AccountController {
   private static Logger logger = LoggerFactory.getLogger(IndexController.class);

   @Value("#{env['auth.cookie.name']}")
   private String AUTH_COOKIE_NAME;

   @Value("#{env['auth.cookie.rate']}")
   private String AUTH_COOKIE_RATE;

   @Autowired
   private AccountService accountService;

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
    *   회원가입 화면
    ===================================================*/
   @RequestMapping(value = "/account/joinForm", method = RequestMethod.GET)
   public String index(HttpServletRequest request, HttpServletResponse response) {
      return "/account/joinForm";
   }

   /*===================================================
   // 로그인 /account/loginProc
    ===================================================*/

   @RequestMapping(value = "/account/loginProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> login(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String rating = HttpUtil.get(request, "login-rating");
      String userId = HttpUtil.get(request, "loginUserId");
      String userPwd = HttpUtil.get(request, "loginUserPwd");
      Account account;
      if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {
         if (StringUtil.equals(rating, "U")) {
            account = accountService.userSelect(userId);
         } else if (StringUtil.equals(rating, "T")) {
            account = accountService.teacherSelect(userId);
         } else {
            account = null;
         }
         if (account != null) {
            if (StringUtil.equals(userPwd, account.getUserPwd())) {
               if (StringUtil.equals(account.getStatus(), "Y") || StringUtil.equals(account.getStatus(), "P")) {
                  res.setResponse(0, "success", account.getStatus());
                  CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
                  CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_RATE, CookieUtil.stringToHex(account.getRating()));
               } else if (StringUtil.equals(account.getStatus(), "W")) {
                  res.setResponse(-98, "승인되지 않은 계정입니다. 관리자에게 문의해주세요.");
               } else {
                  res.setResponse(-99, "정상적인 계정이 아닙니다.");
               }
            } else {
               res.setResponse(-1, "아이디나 비밀번호를 확인해주세요.");
            }
         } else {
            res.setResponse(404, "아이디나 비밀번호를 확인해주세요.");
         }
      } else {
         res.setResponse(400, "아이디나 비밀번호를 입력해주세요.");
      }
      return res;
   }

   /*===================================================
   * 아이디 찾기
    ===================================================*/
   @RequestMapping(value = "/account/idSearchProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> idSearchProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String userName = HttpUtil.get(request, "idUserName");
      String userEmail = HttpUtil.get(request, "idUserEmail");
      String userPhone = HttpUtil.get(request, "idUserPhone");
      String rating = HttpUtil.get(request, "find-id-rating");
      String userId = "";
      if (!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userPhone)) {
         if (StringUtil.equals(rating, "U")) {
            userId = accountService.userIdSearch(userName, userEmail, userPhone);
         } else if (StringUtil.equals(rating, "T")) {
            userId = accountService.teacherIdSearch(userName, userEmail, userPhone);
         } else {
            res.setResponse(400, "rating is empty");
            return res;
         }

         if (!StringUtil.isEmpty(userId)) {
            res.setResponse(0, "idSearch success", userId); // userId alert으로
         } else {
            res.setResponse(404, "No user data");
         }
      } else {
         res.setResponse(400, "input is empty");
      }

      return res;
   }

   /*===================================================
   * 비밀번호 찾기
    ===================================================*/
   @RequestMapping(value = "/account/pwdSearchProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> pwdSearchProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();

      String rating = HttpUtil.get(request, "find-pw-rating");
      String userId = HttpUtil.get(request, "pwUserId");
      String userName = HttpUtil.get(request, "pwUserName");
      String userEmail = HttpUtil.get(request, "pwUserEmail");
      String userPhone = HttpUtil.get(request, "pwUserPhone");
      Account account;
      if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userPhone)) {
         if (StringUtil.equals(rating, "U")) {
            account = accountService.userSelect(userId);
         } else if (StringUtil.equals(rating, "T")) {
            account = accountService.teacherSelect(userId);
         } else {
            account = null;
            res.setResponse(400, "rating is empty");
         }
         if (account != null) {
            if (StringUtil.equals(userEmail, account.getUserEmail()) && StringUtil.equals(userName, account.getUserName())
                  && StringUtil.equals(userPhone, account.getUserPhone())) {
               res.setResponse(0, "success");
               // 이메일로 인증번호 전송.
            } else {
               res.setResponse(400, "invalid input");
            }
         } else {
            res.setResponse(404, "no user");
         }
      } else {
         res.setResponse(400, "input is Empty");
      }

      return res;
   }

   /*===================================================
   * 아이디 중복체크
    ===================================================*/
   @RequestMapping(value = "/account/idCheck", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> idCheck(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String userId = HttpUtil.get(request, "userId");
      if (!StringUtil.isEmpty(userId)) {
         if (accountService.userSelect(userId) == null && accountService.teacherSelect(userId) == null) {
            res.setResponse(0, "사용 가능한 아이디입니다.");
         } else {
            res.setResponse(100, "이미 사용 중인 아이디입니다.");
         }
      } else {
         res.setResponse(400, "사용자 아이디가 존재하지 않습니다.");
      }

      return res;
   }

   /*===================================================
   * 이메일 중복체크
    ===================================================*/
   @RequestMapping(value = "/account/emailCheck", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> emailCheck(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();

      String userEmail = HttpUtil.get(request, "userEmail");
      if (!StringUtil.isEmpty(userEmail)) {
         if (accountService.userEmailCheck(userEmail) == 0 && accountService.teacherEmailCheck(userEmail) == 0) {
            res.setResponse(0, "사용 가능한 이메일입니다.");
         } else {
            res.setResponse(100, "이미 사용 중인 이메일입니다.");
         }
      } else {
         res.setResponse(400, "사용자 이메일이 존재하지 않습니다.");
      }

      return res;
   }

   /*===================================================
	* 회원등록 (회원가입)
	 ===================================================*/
	@RequestMapping(value = "/account/joinProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> joinProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		String userId = HttpUtil.get(request, "userId");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userPwd = HttpUtil.get(request, "userPwd");
		String userName = HttpUtil.get(request, "userName");
		String userPhone = HttpUtil.get(request, "userPhone");
		String addrCode = HttpUtil.get(request, "addrCode", "");
		String addrBase = HttpUtil.get(request, "addrBase", "");
		String addrDetail = HttpUtil.get(request, "addrDetail", "");
		String rating = HttpUtil.get(request, "rating");
		String classCode = HttpUtil.get(request, "classCode");
		logger.debug(rating + "===============");
		if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userPwd) && !StringUtil.isEmpty(userName)
				&& !StringUtil.isEmpty(userPhone) && !StringUtil.isEmpty(rating)) {
			if (accountService.userSelect(userId) == null && accountService.teacherSelect(userId) == null) {
				if (accountService.userEmailCheck(userEmail) == 0 && accountService.teacherEmailCheck(userEmail) == 0) {
					if (StringUtil.equals(rating, "U")) {
						User account = new User();
						account.setUserId(userId);
						account.setUserPwd(userPwd);
						account.setUserEmail(userEmail);
						account.setUserName(userName);
						account.setUserPhone(userPhone);
						account.setAddrCode(addrCode);
						account.setAddrBase(addrBase);
						account.setAddrDetail(addrDetail);
						account.setRating(rating);
						if (accountService.userInsert(account) > 0) {
							res.setResponse(0, "success");
						} else {
							res.setResponse(500, "error");
						}
					} else if (StringUtil.equals(rating, "T")) {
						Teacher account = new Teacher();
						account.setUserId(userId);
						account.setUserPwd(userPwd);
						account.setUserEmail(userEmail);
						account.setUserName(userName);
						account.setUserPhone(userPhone);
						account.setAddrCode(addrCode);
						account.setAddrBase(addrBase);
						account.setAddrDetail(addrDetail);
						account.setRating(rating);
						account.setClassCode(classCode);
						if (accountService.teacherInsert(account) > 0) {
							res.setResponse(1, "success");
						} else {
							res.setResponse(500, "error");
						}
					}
				} else {
					res.setResponse(100, "이미 가입한 이메일입니다.");
				}
			} else {
				res.setResponse(100, "이미 강비한 아이디입니다.");
			}
		} else {
			res.setResponse(400, "필수 정보를 입력해주세요");
		}

		return res;
	}


   /*===================================================
   * 로그아웃
    ===================================================*/
   @RequestMapping(value = "/account/logoutProc")
   public String logoutProc(HttpServletRequest request, HttpServletResponse response) {
      if (CookieUtil.getHexValue(request, AUTH_COOKIE_NAME) != null && CookieUtil.getHexValue(request, AUTH_COOKIE_RATE) != null) {
         CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
         CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_RATE);
      }

      return "redirect:/";
   }
}
