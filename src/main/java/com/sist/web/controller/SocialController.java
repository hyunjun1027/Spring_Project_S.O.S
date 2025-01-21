package com.sist.web.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.math.BigInteger;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.SecureRandom;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("socialController")
public class SocialController {
	private static Logger logger = LoggerFactory.getLogger(SocialController.class);

	@Autowired
	private AccountService accountService;

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	@Value("#{env['naver.client.id']}")
	private String NAVER_CLIENT_ID;

	@Value("#{env['naver.client.secret']}")
	private String NAVER_CLIENT_SECRET;

	@Value("#{env['naver.redirect.uri']}")
	private String NAVER_REDIRECT_URI;

	// SecureRandom을 사용하여 state 값 생성
	private String generateState() {
		// CSRF 공격 방지를 위해 SecureRandom을 사용하여 무작위 state 값
		SecureRandom random = new SecureRandom();
		return new BigInteger(130, random).toString(32); // 32진수 문자열 반환
	}

	// naver 로그인 화면
	// 참고사이트
	// (https://developers.naver.com/docs/login/devguide/devguide.md#3-3-1-%EB%84%A4%EC%9D%B4%EB%B2%84-%EB%A1%9C%EA%B7%B8%EC%9D%B8-%ED%9A%8C%EC%9B%90%EC%9D%98-%ED%94%84%EB%A1%9C%ED%95%84-%EC%A0%95%EB%B3%B4)
	@RequestMapping(value = "/login/naver", method = RequestMethod.GET)
	public String loginNaver(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
		// CSRF 방지를 위해 동적으로 state 값을 생성하고 세션에 저장
		String state = generateState();

		String url = "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=" + NAVER_CLIENT_ID + "&redirect_uri="
				+ NAVER_REDIRECT_URI + "&state=" + state;

		logger.debug("============================================================================");
		logger.debug("naver_url : " + url);
		logger.debug("============================================================================");

		return "redirect:" + url;
	}

	// naver 콜백 함수
	@RequestMapping(value = "/naver/callback")
	public String callback(HttpServletRequest request, HttpServletResponse response, @RequestParam String code, @RequestParam String state,
			HttpSession session) {

		logger.debug("============================================================================");
		logger.debug("callback 함수 시작");
		logger.debug("============================================================================");

		try {
			// Access Token 요청 URL 생성
			// grant_type=authorization_code는 네이버 OAuth2 인증에서 Access Token을 요청할 때 필요
			String tokenURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code" + "&client_id=" + NAVER_CLIENT_ID
					+ "&client_secret=" + NAVER_CLIENT_SECRET + "&redirect_uri=" + NAVER_REDIRECT_URI + "&code=" + code + "&state=" + state;

			// 네이버에 GET 요청
			URL url = new URL(tokenURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");

			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) {
				// 성공적인 응답
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else {
				// 에러 응답 처리
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}

			// 응답 읽기 및 Access Token 파싱
			StringBuilder res = new StringBuilder();
			String inputLine;
			while ((inputLine = br.readLine()) != null)
				res.append(inputLine);

			br.close();

			logger.debug("Access Token Response: " + res.toString());

			// JSON 파싱: 액세스 토큰 추출
			JSONObject jsonResponse = new JSONObject(res.toString());
			String accessToken = jsonResponse.getString("access_token");

			// 사용자 프로필 가져오기
			String userProfile = getUserProfile(accessToken);

			if (!StringUtil.isEmpty(userProfile)) {
				JSONObject profileJson = new JSONObject(userProfile);

				String userId = profileJson.getJSONObject("response").getString("id");
				String userName = profileJson.getJSONObject("response").getString("name");
				String userEmail = profileJson.getJSONObject("response").getString("email");

				logger.debug("============================================================================");
				logger.debug("userId : " + userId);
				logger.debug("userName : " + userName);
				logger.debug("userEmail : " + userEmail);
				logger.debug("============================================================================");

				if (!StringUtil.isEmpty(userId)) {
					User user = null;
					user = accountService.userSelect(userId);

					if (user == null) {

						user = new User();

						user.setUserId(userId);
						user.setUserName(userName);
						user.setUserEmail(userEmail);
						user.setStatus("Y");
						user.setRating("U");
						user.setLoginType("N");

						accountService.userInsert(user);
					}

					CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
					CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_RATE, CookieUtil.stringToHex(user.getRating()));
				}
			}

			return "/popupClose";

		} catch (Exception e) {
			logger.error("Error during Naver callback", e);
			return "Error occurred during Naver callback.";
		}
	}

	// 사용자 프로필 API 호출
	private String getUserProfile(String accessToken) throws Exception {
		String apiURL = "https://openapi.naver.com/v1/nid/me";
		URL url = new URL(apiURL);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET");
		con.setRequestProperty("Authorization", "Bearer " + accessToken);

		int responseCode = con.getResponseCode();
		BufferedReader br;
		if (responseCode == 200) {
			br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} else {
			br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		}

		StringBuilder res = new StringBuilder();
		String inputLine;
		while ((inputLine = br.readLine()) != null) {
			res.append(inputLine);
		}
		br.close();

		return res.toString();
	}

	// 구글 로그인
	@RequestMapping(value = "/social/loginProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> loginProc(HttpServletResponse response, HttpServletRequest request) {
		Response<Object> res = new Response<Object>();

		String userId = HttpUtil.get(request, "userId");
		String userEmail = HttpUtil.get(request, "userEmail");
		String userName = HttpUtil.get(request, "userName");
		User user = new User();
		if (accountService.userSelect(userId) == null) {

			user.setUserId(userId);
			user.setUserEmail(userEmail);
			user.setUserName(userName);
			user.setLoginType("G");
			user.setRating("U");
			if (accountService.userInsert(user) > 0) {
				res.setResponse(0, "구글 회원가입 완료");
			} else {
				res.setResponse(500, "internal server error");
			}
		}
		user = accountService.userSelect(userId);
		if (user != null) {
			res.setResponse(0, "로그인 성공");
			CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
			CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_RATE, CookieUtil.stringToHex(user.getRating()));
		}

		return res;
	}
}
