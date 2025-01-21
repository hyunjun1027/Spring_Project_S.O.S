package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.JsonObject;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Book;
import com.sist.web.model.Cart;
import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.KakaoPayApproveRequest;
import com.sist.web.model.KakaoPayApproveResponse;
import com.sist.web.model.KakaoPayCancelRequest;
import com.sist.web.model.KakaoPayCancelResponse;
import com.sist.web.model.KakaoPayReadyRequest;
import com.sist.web.model.KakaoPayReadyResponse;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.Refund;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.BookService;
import com.sist.web.service.CartService;
import com.sist.web.service.KakaoPayService;
import com.sist.web.service.OrderService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;
import com.sist.web.util.SessionUtil;

@Controller("orderController")
public class OrderController {
	private static Logger logger = LoggerFactory.getLogger(OrderController.class);

	@Value("#{env['kakaopay.tid.session.name']}")
	private String KAKAOPAY_TID_SESSION_NAME;

	// Client ID (CID)
	@Value("#{env['kakaopay.client.id']}")
	private String KAKAOPAY_CLIENT_ID;

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	@Value("#{env['kakaopay.orderid.session.name']}")
	private String KAKAOPAY_ORDERID_SESSION_NAME;

	@Autowired
	private MailController mailController;
	
	@Autowired
	AccountService accountService;

	@Autowired
	CartService cartService;

	@Autowired
	private OrderService orderService;

	@Autowired
	BookService bookService;

	@Autowired
	private KakaoPayService kakaoPayService;

	// 장바구니 수
	@ModelAttribute("cartCount")
	public int cartCount(HttpServletRequest request, HttpServletResponse response) {
		int cartCount = 0;
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		cartCount = cartService.cartCount(cookieUserId);

		return cartCount;
	}

	// 주문상세내역 리스트
	List<OrderDetail> orderDetailList = new ArrayList<OrderDetail>();

	/*===================================================
	 *   즉시 결제 처리
	 ===================================================*/
	@RequestMapping(value = "/order/cartDirectPay")
	@ResponseBody
	public Response<Object> cartDirectPay(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long prdCnt = HttpUtil.get(request, "prdCnt", 1);
		long bookSeq = HttpUtil.get(request, "bookSeq", 0);
		Cart cart = new Cart();
		Book book = null;
		if (!StringUtil.isEmpty(cookieUserId)) {

			if (bookSeq > 0) {

				cart.setUserId(cookieUserId);
				cart.setBookSeq(bookSeq);
				cart.setPrdCnt(prdCnt);
				book = bookService.bookSelect("", bookSeq);
				if (book.getInvenQtt() > 0 && cart.getPrdCnt() <= book.getInvenQtt()) {
					// 이미 장바구니에 있는 거라면 수량 UPDATE
					if (cartService.cartSelect(cart) != null) {
						if (cartService.cartPrdCntUpdate(cart) > 0) {
							res.setResponse(0, "이미 장바구니에 있는 품목 업데이트 성공");
						} else {
							res.setResponse(-1, "품목 업데이트 실패!!");
						}
					}
					// 장바구니에 없던 상품이라면 INSERT
					else {
						if (cartService.cartInsert(cart) > 0) {
							res.setResponse(0, "장바구니 INSERT 성공!");
						} else {
							res.setResponse(-1, "품목 INSERT 실패");
						}
					}
				} else {
					res.setResponse(400, "재고가 부족합니다.");
				}

			}

		} else {
			res.setResponse(404, "로그인 안 됨!");
		}

		return res;
	}

	/*===================================================
	 *	장바구니 추가
	 ===================================================*/
	@RequestMapping(value = "/order/cartInsert", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartInsert(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long prdCnt = HttpUtil.get(request, "prdCnt", 1);
		long bookSeq = HttpUtil.get(request, "bookSeq", 0);
		Cart cart = new Cart();
		Book book = null;
		if (!StringUtil.isEmpty(cookieUserId)) {
			if (bookSeq > 0) {
				cart.setUserId(cookieUserId);
				cart.setBookSeq(bookSeq);
				cart.setPrdCnt(prdCnt);
				book = bookService.bookSelect("", bookSeq);
				if (book.getInvenQtt() > 0 && cart.getPrdCnt() <= book.getInvenQtt()) {
					if (cartService.cartInsert(cart) > 0) {

						int cartCount = 0;
						cartCount = cartService.cartCount(cookieUserId);

						res.setResponse(0, "장바구니에 넣었습니다.", cartCount);
					} else {
						res.setResponse(-1, "장바구니에 있는 항목입니다.");
					}
				} else {
					res.setResponse(400, "재고가 부족합니다.");
				}
			} else {
				res.setResponse(401, "오류가 발생하였습니다.");
			}
		} else {
			res.setResponse(404, "로그인 후 이용해주세요.");
		}

		return res;
	}

	/*===================================================
	 *	장바구니 개수 변경
	 ===================================================*/
	@RequestMapping(value = "/order/cartCntUpdate", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartCntUpdate(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long bookSeq = HttpUtil.get(request, "bookSeq", (long) 0);
		long prdCnt = HttpUtil.get(request, "prdCnt", (long) 0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Cart cart = new Cart();
		Book book = bookService.bookSelect("", bookSeq);
		if (!StringUtil.isEmpty(cookieUserId) && bookSeq != 0) {
			if (book.getInvenQtt() > 0 && book.getInvenQtt() >= prdCnt) {
				cart.setBookSeq(bookSeq);
				cart.setUserId(cookieUserId);
				cart.setPrdCnt(prdCnt);

				int price = bookService.bookSelect("", bookSeq).getBookPayPrice() * (int) prdCnt;

				if (cartService.cartPrdCntUpdate(cart) > 0) {
					res.setResponse(0, "success", price);
				} else {
					res.setResponse(-1, "오류가 발생하였습니다(-1)");
				}
			} else {
				res.setResponse(404, "재고가 모자랍니다. 다시 확인해주세요.");
			}
		} else {
			res.setResponse(400, "오류가 발생하였습니다(400)");
		}

		return res;
	}

	/*===================================================
	 *	장바구니 totalPrice 가져오기
	 ===================================================*/
	@RequestMapping(value = "/order/totalPrice", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> totalPrice(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Cart cart = new Cart();
		cart.setUserId(cookieUserId);
		int totalPrice = 0;
		List<Cart> list = cartService.cartListSelect(cart);
		for (int i = 0; i < list.size(); i++) {
			list.get(i).setBook(bookService.bookSelect("", list.get(i).getBookSeq()));
			if (StringUtil.equals(list.get(i).getChecked(), "Y")) {
				totalPrice += list.get(i).getBook().getBookPayPrice() * (int) list.get(i).getPrdCnt();
			}
		}
		res.setResponse(0, "success", totalPrice);
		return res;
	}

	/*===================================================
	 *	장바구니 chcecked 업데이트
	 ===================================================*/
	@RequestMapping(value = "/order/checkedUpdate", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> checkedUpdate(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long bookSeq = HttpUtil.get(request, "bookSeq", 0);
		Cart search = new Cart();

		search.setBookSeq(bookSeq);
		search.setUserId(cookieUserId);
		logger.debug("==============" + search.getUserId() + "===" + cookieUserId);
		Cart cart = cartService.cartSelect(search);
		if (StringUtil.equals(cart.getChecked(), "Y")) {
			search.setChecked("N");
			cartService.cartCheckedUpdate(search);
		} else if (StringUtil.equals(cart.getChecked(), "N")) {
			search.setChecked("Y");
			cartService.cartCheckedUpdate(search);
		}
		res.setResponse(0, "success");
		return res;
	}

	/*===================================================
	 *	장바구니 삭제 업데이트
	 ===================================================*/
	@RequestMapping(value = "/order/cartDelete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> cartDelete(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		long bookSeq = HttpUtil.get(request, "bookSeq", 0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Cart cart = new Cart();
		cart.setBookSeq(bookSeq);
		cart.setUserId(cookieUserId);
		cartService.cartDelete(cart);

		res.setResponse(0, "success");
		return res;
	}

	/*===================================================
	 *	장바구니 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/order/basket")
	public String basket(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Cart cart = new Cart();
		cart.setUserId(cookieUserId);
		List<Cart> list = cartService.cartListSelect(cart);
		int totalPrice = 0;
		for (int i = 0; i < list.size(); i++) {
			list.get(i).setBook(bookService.bookSelect("", list.get(i).getBookSeq()));
			if (StringUtil.equals(list.get(i).getChecked(), "Y")) {
				totalPrice += list.get(i).getBook().getBookPayPrice() * list.get(i).getPrdCnt();
			}
		}
		model.addAttribute("totalPrice", totalPrice);
		model.addAttribute("list", list);
		model.addAttribute("bookCount", list.size());
		return "/order/basket";
	}

	/*===================================================
	 *	결제 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/order/payment")
	public String payment(HttpServletRequest request, HttpServletResponse response, ModelMap model) {

		long listType = HttpUtil.get(request, "listType", 0);
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		Cart cart = new Cart();
		List<Cart> list = null;

		// 선택 결제
		if (listType == 0) {
			cart.setUserId(cookieUserId);
			cart.setChecked("Y");
			list = cartService.cartListSelect(cart);
		}
		// 전체 결제
		else if (listType == -1) {
			cart.setUserId(cookieUserId);
			list = cartService.cartListSelect(cart);
		}
		// 즉시 결제
		else {
			cart.setBookSeq(listType);
			cart.setUserId(cookieUserId);
			list = cartService.cartListSelect(cart);

		}

		int totalPrice = 0;
		String qttChk = "Y";
		Book book;
		for (int i = 0; i < list.size(); i++) {
			book = bookService.bookSelect("", list.get(i).getBookSeq());
			list.get(i).setBook(book);
			totalPrice += list.get(i).getBook().getBookPayPrice() * (int) list.get(i).getPrdCnt();
			if (book.getInvenQtt() <= 0 || book.getInvenQtt() < list.get(i).getPrdCnt()) {
				qttChk = "N";
			}
			if (StringUtil.equals(list.get(i).getChecked(), "N")) {
				list.get(i).setChecked("Y");
				cartService.cartCheckedUpdate(list.get(i));
			}
		}

		model.addAttribute("list", list);
		model.addAttribute("totalPrice", totalPrice);
		model.addAttribute("qttChk", qttChk);

		return "/order/payment";
	}

	/*===================================================
	 *	주문 취소 (삭제) 결제 취소 아님!!
	 ===================================================*/
	@RequestMapping(value = "/order/orderDelete", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> orderDelete(@RequestBody Map<String, Object> payload) {
		Response<Object> res = new Response<>();

		String postOrderSeq = (String) payload.getOrDefault("orderSeq", 0L);
		long orderSeq = Long.parseLong(postOrderSeq);
		orderDetailList = null;

		logger.debug("orderSeq : " + orderSeq);

		if (orderSeq > 0) {

			Order order = orderService.orderSelect(orderSeq);

			if (order != null) {
				// 재고
				// 1. 주문상세 조회
				// 2. 주문한 책 번호, 개수 조회
				// 3. 책 재고 +

				orderDetailList = orderService.orderDetailSelect(orderSeq);

				for (int i = 0; i < orderDetailList.size(); i++) {

					Book qttBook = bookService.bookSelect("", orderDetailList.get(i).getBookSeq());

					qttBook.setQttMgrChk("2");
					qttBook.setQttVal(orderDetailList.get(i).getOrderCnt());

					try {
						if (bookService.bookQttMgr(qttBook) > 0) {
							logger.debug("재고 업데이트 성공~");
						}
					} catch (Exception e) {
						logger.error("DB 설정 에러 222222222222", e);
						res.setResponse(-999, "재고 수정 실패");
						return res;
					}
				}

				if (orderService.orderDelete(orderSeq) > 0) {

					res.setResponse(0, "삭제 성공");

				} else {

					res.setResponse(-1, "삭제 실패");

				}

			} else {

				res.setResponse(404, "주문내역 없음");

			}
		} else {

			res.setResponse(400, "파라미터 값 안 넘어옴");
		}

		logger.debug("Response: " + JsonUtil.toJsonPretty(res));

		return res;
	}

	/*===================================================
	 * 결제 취소 요청 처리 (환불 테이블 INSERT / 주문 테이블 UPDATE)
	 ===================================================*/
	@RequestMapping(value = "/order/payCancleApply")
	@ResponseBody
	public Response<Object> payCancleApply(HttpServletRequest request, HttpServletResponse response) {

		Response<Object> res = new Response<Object>();

		long orderSeq = Long.parseLong(HttpUtil.get(request, "orderSeq", ""));
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

		logger.debug("orderSeq : " + orderSeq);

		if (orderSeq > 0) {

			Order order = orderService.orderSelect(orderSeq);

			if (order != null) {

				// 취소 요청 상태
				order.setOrderStatus("2");

				Refund refund = new Refund();

				refund.setOrderSeq(orderSeq);
				refund.setUserId(cookieUserId);

				if (orderService.refundApply(order, refund) > 0) {
					res.setResponse(0, "성공");
				} else {
					res.setResponse(-1, "실패 : DB 오류");
				}
			}

		} else {
			res.setResponse(400, "실패 : 파라미터 값 안 넘어옴");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[OrderController] /payCancleApply response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;

	}

	/*===================================================
	 * 카카오페이 연결 화면
	 ===================================================*/

	// 주문 테이블 먼저 INSERT -> 카카오페이 -> 최종 결제 후 주문완료 상태 변경
	// 주문상세(INSERT), 배송(INSERT), 장바구니(DELETE) 처리

	@Transactional
	@RequestMapping(value = "/kakao/readyAjax", method = RequestMethod.POST)
	@ResponseBody
	public Response<JsonObject> readyAjax(@RequestBody Map<String, Object> requestData, HttpServletRequest request, HttpServletResponse response) {
		Response<JsonObject> res = new Response<JsonObject>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

		orderDetailList.clear();

		// 재결제를 위한 주문번호
		String orderSeq = (String) requestData.get("orderSeq");

		logger.debug("orderSeq : " + orderSeq);

		// 재결제
		if (!StringUtil.isEmpty(orderSeq)) {

			Order order = orderService.orderSelect(Long.parseLong(orderSeq));
			logger.debug("order : " + order);

			String orderId = String.valueOf(order.getOrderSeq());

			KakaoPayReadyRequest kakaoPayReadyRequest = new KakaoPayReadyRequest();

			// 필수 입력값 세팅
			kakaoPayReadyRequest.setPartner_order_id(orderId); // 주문번호
			kakaoPayReadyRequest.setPartner_user_id(cookieUserId); // 회원 아이디
			kakaoPayReadyRequest.setItem_name(order.getOrderProName()); // 상품명
			// kakaoPayReadyRequest.setItem_code(goods.getGoodsCode()); // 상품코드 (필수X)
			kakaoPayReadyRequest.setQuantity(order.getOrderCnt()); // 주문수량
			kakaoPayReadyRequest.setTotal_amount(order.getPayPrice()); // 총 금액
			kakaoPayReadyRequest.setTax_free_amount(0); // 상품 비과세 금액

			// 카카오페이 연동 시작
			KakaoPayReadyResponse kakaoPayReadyResponse = kakaoPayService.ready(kakaoPayReadyRequest);

			// response 세팅 후 리턴
			if (kakaoPayReadyResponse != null) {

				// 카카오페이 트랜잭션 아이디 세션 저장
				HttpSession session = request.getSession(true);

				SessionUtil.setSession(session, KAKAOPAY_TID_SESSION_NAME, kakaoPayReadyResponse.getTid());
				// 카카오페이 트랜잭션 주문번호 세션 저장
				SessionUtil.setSession(session, KAKAOPAY_ORDERID_SESSION_NAME, orderId);

				JsonObject json = new JsonObject();

				json.addProperty("next_redirect_app_url", kakaoPayReadyResponse.getNext_redirect_app_url());
				json.addProperty("next_redirect_mobile_url", kakaoPayReadyResponse.getNext_redirect_mobile_url());

				// 실질적으로 next_redirect_pc_url만 씀
				json.addProperty("next_redirect_pc_url", kakaoPayReadyResponse.getNext_redirect_pc_url());

				json.addProperty("android_app_scheme", kakaoPayReadyResponse.getAndroid_app_scheme());
				json.addProperty("ios_app_scheme", kakaoPayReadyResponse.getIos_app_scheme());
				json.addProperty("created_at", kakaoPayReadyResponse.getCreated_at());

				res.setResponse(0, "성공", json);
			}

			else {
				res.setResponse(-1, "카카오페이 결제 준비 중 오류 발생");
			}
		}

		// ==============================================================================================
		// 처음 결제
		else {
			String name = (String) requestData.get("name");
			String phone = (String) requestData.get("phone");
			String addrCode = (String) requestData.get("addrCode");
			String addrBase = (String) requestData.get("addrBase");
			String addrDetail = (String) requestData.get("addrDetail");
			String deliMsg = (String) requestData.get("deliveryMessage");
			int totalPrice = (int) Double.parseDouble(requestData.get("totalPrice").toString());

			List<String> bookSeqList = (List<String>) requestData.get("bookSeqList");

			logger.debug("======================================================");
			logger.debug("name : " + name + ", phone : " + phone + ", addrCode : " + addrCode + ", addrBase : " + addrBase + ", addrDetail : "
					+ addrDetail + ", deliMsg : " + deliMsg + ", totalPrice : " + totalPrice);
			logger.debug("bookSeqList : " + bookSeqList);
			logger.debug("======================================================");

			Order order = new Order();

			// 강사인지 학생인지 판별
			User who = accountService.userOrTeacher(cookieUserId);

			// 학생이라면
			if (StringUtil.equals(who.getRating(), "U")) {
				User user = accountService.userSelect(cookieUserId);

				order.setOrderName(user.getUserName()); // 주문자명
				order.setOrderPhone(user.getUserPhone().trim()); // 주문자 연락처
				order.setUserType("U");
			}
			// 강사라면
			else {
				Teacher user = accountService.teacherSelect(cookieUserId);

				order.setOrderName(user.getUserName()); // 주문자명
				order.setOrderPhone(user.getUserPhone().trim()); // 주문자 연락처
				order.setUserType("T");
			}

			logger.debug("userType : " + order.getUserType());

			order.setUserId(cookieUserId);

			logger.debug("order.getUserId() : " + order.getUserId());
			logger.debug("order.getTeacher() : " + order.getTeacherId());

			// #################### 주문 테이블 값 세팅 시작 ####################
			// 주문 제품이 2개 이상이면 '(대표 제품명) 외 n건'으로 떠야 함

			// 대표 제품명 조회
			Book book = bookService.bookSelect("", Long.parseLong(bookSeqList.get(0)));

			if (bookSeqList.size() > 1) {
				String bookName = book.getBookTitle();
				// n건 조회
				int count = bookSeqList.size() - 1;

				// 주문 상품명
				String orderProName = bookName + " 외 " + count + "건";

				order.setOrderProName(orderProName); // 주문 상품명
			}
			// 주문 제품 1개
			else {
				order.setOrderProName(book.getBookTitle()); // 주문 상품명
			}

			// 주문날짜, 주문취소날짜
			order.setOrderCnt(bookSeqList.size()); // 주문수량
			order.setPayPrice(totalPrice); // 실제 결제 금액
			// 주문자명
			// 주문자 연락처
			order.setPayStatus("1"); // 결제상태 (1:입금대기/2:결제완료/3:결제실패/4:취소요청/5:취소완료)
			order.setOrderStatus("1"); // 주문상태 (1:주문접수/2:주문확인/3:준비중/4:주문완료)

			Cart search = new Cart();
			int orderPrdTotalPrice = 0;

			// brdSeqList를 이용해서 실제 물품 금액, 실제 결제 금액, 상품명, 구매수량 조회
			// #################### 주문상세 테이블 값 세팅 시작 ####################
			for (int i = 0; i < bookSeqList.size(); i++) {

				book = bookService.bookSelect("", Long.parseLong(bookSeqList.get(i)));

				String bookName = book.getBookTitle(); // 책 제목

				search.setUserId(cookieUserId);
				search.setBookSeq(Long.parseLong(bookSeqList.get(i)));

				Cart cart = cartService.cartSelect(search);

				long prdCount = cart.getPrdCnt(); // 책 구매수량
				int bookPrdPrice = book.getBookPrice() * (int) prdCount; // 책 금액
				int bookPayPrice = book.getBookPayPrice() * (int) prdCount; // 책 실제 결제 금액

				orderPrdTotalPrice += bookPrdPrice;

				OrderDetail od = new OrderDetail();

				// 주문상세번호, 주문번호를 제외한 값 세팅
				od.setBookSeq(Long.parseLong(bookSeqList.get(i))); // 책 번호
				od.setPrdPrice(bookPrdPrice); // 책 금액
				od.setOrderCnt((int) prdCount); // 주문수량
				od.setPayPrice(bookPayPrice); // 책 실제 결제 금액
				od.setProName(bookName); // 주문상품명

				orderDetailList.add(od);
			}
			// #################### 주문상세 테이블 값 세팅 끝 ####################

			order.setPrdPrice(orderPrdTotalPrice); // 실제 물품 금액

			// #################### 주문 테이블 값 세팅 끝 ####################

			logger.debug("===============================주문======================================");
			logger.debug("userId : " + order.getUserId() + ", orderName : " + order.getOrderName() + ", orderPhone : " + order.getOrderPhone()
					+ ", orderCnt : " + order.getOrderCnt() + ", prdPrice : " + order.getPrdPrice() + ", payPrice : " + order.getPayPrice()
					+ ", orderStatus : " + order.getOrderStatus() + ", payStatus " + order.getPayStatus() + ", orderPrdName : "
					+ order.getOrderProName());
			logger.debug("=========================================================================");

			logger.debug("===============================주문상세======================================");
			logger.debug("size : " + orderDetailList.size());

			for (int i = 0; i < orderDetailList.size(); i++) {

				OrderDetail od = orderDetailList.get(i);

				logger.debug("bookSeq : " + od.getBookSeq() + ", orderCnt : " + od.getOrderCnt() + ", prdPrice : " + od.getPrdPrice()
						+ ", payPrice : " + od.getPayPrice() + ", proName : " + od.getProName());
			}
			logger.debug("==============================================================================");

			// #################### 배송 테이블 값 세팅 시작 ####################
			DeliveryInfo di = new DeliveryInfo();

			// 주문번호
			di.setUserId(cookieUserId);
			di.setUserPhone(phone);
			di.setAddrCode(addrCode);
			di.setAddrBase(addrBase);
			di.setAddrDetail(addrDetail);
			di.setDlvRequest(deliMsg);
			// 배송상태(1:배송준비중/2:배송중/3:배송완료) -> '주문완료' 이후 상태에서만 생성가능 (관리자단에서 처리)
			// 배송 시작 날짜
			// 배송 완료 날짜
			di.setDlvName(name);

			// #################### 배송 테이블 값 세팅 시작 ####################

			logger.debug("===============================배송상태======================================");
			logger.debug("userPhone : " + di.getUserPhone() + ", addrCode : " + di.getAddrCode() + ", addrBase : " + di.getAddrBase()
					+ ", addrDetail : " + di.getAddrDetail() + ", dliMsg : " + di.getDlvRequest() + ", name : " + di.getDlvName());
			logger.debug("==============================================================================");

			// #################### 배송 테이블 값 세팅 끝 ####################

			try {
				// 재고 조회
				for (int i = 0; i < bookSeqList.size(); i++) {
					Book qttBook = bookService.bookSelect("", Long.parseLong(bookSeqList.get(i)));
					OrderDetail qttOrderDetail = orderDetailList.get(i);

					// 주문수량이 재고 수량보다 크다면 예외 발생
					if (qttBook.getInvenQtt() < qttOrderDetail.getOrderCnt()) {

						logger.debug("[재고 부족] " + qttBook.getBookTitle() + " 주문 수량: " + qttOrderDetail.getOrderCnt() + ", 재고 수량: "
								+ qttBook.getInvenQtt());

						throw new RuntimeException("[재고 부족] " + qttBook.getBookTitle() + " 주문 수량: " + qttOrderDetail.getOrderCnt() + ", 재고 수량: "
								+ qttBook.getInvenQtt());
					}
					// 재고수량 UPDATE
					else {
						qttBook.setQttMgrChk("1");
						qttBook.setQttVal(qttOrderDetail.getOrderCnt());

						if (bookService.bookQttMgr(qttBook) > 0) {
							logger.debug(qttBook.getBookSeq() + "번의 재고 업데이트 성공~");
						} else {
							throw new Exception("업데이트 중 오류 발생");
						}
					}
				}

				// ######################### INSERT 시작 ##########################

				// 주문 테이블 INSERT
				orderService.orderInsert(order);

				String orderId = String.valueOf(order.getOrderSeq());
				logger.debug("생성된 주문 번호 : " + orderId);

				// 주문상세 테이블 INSERT
				for (int i = 0; i < orderDetailList.size(); i++) {

					OrderDetail od = orderDetailList.get(i);
					od.setOrderSeq(order.getOrderSeq());

					orderService.orderDetailInsert(od);
				}

				// 배송 테이블 INSERT
				di.setOrderSeq(order.getOrderSeq());
				orderService.deliInfoInsert(di);

				// ######################### INSERT 끝 ##########################

				// 장바구니에 있는 품목 삭제
				for (int i = 0; i < orderDetailList.size(); i++) {

					OrderDetail od = new OrderDetail();
					Cart cart = new Cart();

					cart.setUserId(cookieUserId);
					cart.setBookSeq(od.getBookSeq());

					// 장바구니에서 주문한 제품 삭제
					if (cartService.cartDelete(cart) > 0) {
						logger.debug("###############################################");
						logger.debug("장바구니 삭제 완료!");
						logger.debug("###############################################");
					}
				}

				KakaoPayReadyRequest kakaoPayReadyRequest = new KakaoPayReadyRequest();

				// 필수 입력값 세팅
				kakaoPayReadyRequest.setPartner_order_id(orderId); // 주문번호
				kakaoPayReadyRequest.setPartner_user_id(cookieUserId); // 회원 아이디
				kakaoPayReadyRequest.setItem_name(order.getOrderProName()); // 상품명
				// kakaoPayReadyRequest.setItem_code(goods.getGoodsCode()); // 상품코드 (필수X)
				kakaoPayReadyRequest.setQuantity(order.getOrderCnt()); // 주문수량
				kakaoPayReadyRequest.setTotal_amount(order.getPayPrice()); // 총 금액
				kakaoPayReadyRequest.setTax_free_amount(0); // 상품 비과세 금액

				// 카카오페이 연동 시작
				KakaoPayReadyResponse kakaoPayReadyResponse = kakaoPayService.ready(kakaoPayReadyRequest);

				// response 세팅 후 리턴
				if (kakaoPayReadyResponse != null) {

					// 카카오페이 트랜잭션 아이디 세션 저장
					HttpSession session = request.getSession(true);
					SessionUtil.setSession(session, KAKAOPAY_TID_SESSION_NAME, kakaoPayReadyResponse.getTid());
					SessionUtil.setSession(session, KAKAOPAY_ORDERID_SESSION_NAME, orderId);

					JsonObject json = new JsonObject();

					json.addProperty("next_redirect_app_url", kakaoPayReadyResponse.getNext_redirect_app_url());
					json.addProperty("next_redirect_mobile_url", kakaoPayReadyResponse.getNext_redirect_mobile_url());

					// 실질적으로 next_redirect_pc_url만 씀
					json.addProperty("next_redirect_pc_url", kakaoPayReadyResponse.getNext_redirect_pc_url());

					json.addProperty("android_app_scheme", kakaoPayReadyResponse.getAndroid_app_scheme());
					json.addProperty("ios_app_scheme", kakaoPayReadyResponse.getIos_app_scheme());
					json.addProperty("created_at", kakaoPayReadyResponse.getCreated_at());

					res.setResponse(0, "성공", json);
				}

				else {
					throw new RuntimeException("카카오페이 결제 준비 중 오류 발생");
					// res.setResponse(-1, "카카오페이 결제 준비 중 오류 발생");
				}

			} catch (RuntimeException e) {
				// 재고 부족 및 기타 런타임 예외 처리
				logger.error("예외 발생: " + e.getMessage());
				res.setResponse(-999, "주문하신 상품의 재고가 부족합니다.");

			} catch (Exception e) {
				// 기타 예외 처리
				logger.error("주문 처리 중 시스템 오류 발생", e);
				res.setResponse(-1, "시스템 오류로 결제가 중단되었습니다.");
			}
		}

		logger.debug("=====================================");
		logger.debug("카카오페이 ReadyAjax 완료");
		logger.debug("=====================================");

		return res;
	}

	// 카카오페이 결제 승인
	@RequestMapping(value = "/order/kakaoPay/success", method = RequestMethod.GET)
	public String success(Model model, HttpServletRequest request, HttpServletResponse response) {

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String pg_token = HttpUtil.get(request, "pg_token");
		String tid = null;
		String orderId = null;

		// false : 세션이 존재하지 않을 경우, 새로운 세션을 생성하지 않고 null 반환
		// 기존 세션 존재시 그 세션을 반환함
		HttpSession session = request.getSession(false);

		if (session != null) {
			tid = (String) SessionUtil.getSession(session, KAKAOPAY_TID_SESSION_NAME);
			orderId = (String) SessionUtil.getSession(session, KAKAOPAY_ORDERID_SESSION_NAME);

			logger.debug("333333333333333333333333333333333333333333333333");
			logger.debug("orderId : " + orderId);
			logger.debug("TID: " + tid);
			logger.debug("333333333333333333333333333333333333333333333333");
		}

		logger.info("pg_token : [" + pg_token + "]");
		logger.info("tid : [" + tid + "]");
		logger.info("orderId : [" + orderId + "]");

		if (!StringUtil.isEmpty(pg_token) && !StringUtil.isEmpty(tid)) {

			KakaoPayApproveRequest kakaoPayApproveRequest = new KakaoPayApproveRequest();

			kakaoPayApproveRequest.setTid(tid);
			kakaoPayApproveRequest.setPartner_order_id(orderId);
			kakaoPayApproveRequest.setPartner_user_id(cookieUserId);
			kakaoPayApproveRequest.setPg_token(pg_token);

			// 결제 승인 요청
			KakaoPayApproveResponse kakaoPayApproveResponse = kakaoPayService.approve(kakaoPayApproveRequest);

			if (kakaoPayApproveResponse != null) {

				logger.info("[OrderKakaoPayController] approve KakaoPayApproveResponse : \n " + kakaoPayApproveResponse);

				if (kakaoPayApproveResponse.getError_code() == 0) {
					// 성공
					// 결제상태 -> '결제완료', TID값 세팅 (UPDATE)
					// 장바구니 -> orderDetailList에 있는 값들 삭제

					try {
						Order order = new Order();

						order.setOrderSeq(Long.parseLong(orderId));
						order.setTid(tid);
						order.setPayStatus("2");

						if (orderService.orderComUpdate(order) > 0) {
							logger.debug("###############################################");
							logger.debug("결제완료 / TID 값 세팅 성공!");
							logger.debug("###############################################");
							
							logger.debug("mailController : " + mailController);
							mailController.sendOrderEmail(Long.parseLong(orderId));

							model.addAttribute("orderId", orderId);
							model.addAttribute("code", 0);
							model.addAttribute("msg", "카카오페이 결제가 완료되었습니다.");
						} else {
							logger.debug("###############################################");
							logger.debug("DB 설정 에러 1111111111111");
							logger.debug("###############################################");
						}

					} catch (Exception e) {
						logger.error("DB 설정 에러 222222222222", e);
					}

				} else {
					// 실패
					model.addAttribute("code", -1);
					model.addAttribute("msg",
							(!StringUtil.isEmpty(kakaoPayApproveResponse.getError_message()) ? kakaoPayApproveResponse.getError_message()
									: "카카오페이 결제 중 오류가 발생하였습니다."));
				}

				if (!StringUtil.isEmpty(tid)) {
					// tid 세션 삭제
					SessionUtil.removeSession(session, KAKAOPAY_TID_SESSION_NAME);
					// SessionUtil.removeSession(session, KAKAOPAY_ORDERID_SESSION_NAME);
				}

			} else {
				// 실패
				model.addAttribute("code", -4);
				model.addAttribute("msg", "카카오페이 결제 처리 중 오류가 발생하였습니다.");
			}
		} else {
			model.addAttribute("code", -5);
			model.addAttribute("msg", "카카오페이 결제 처리 중 오류가 발생하였습니다.");
		}

		return "/order/result";
	}

	/*===================================================
	 *	결제 완료 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/order/paySuccess")
	public String paySuccess(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String testOrderSeq = HttpUtil.get(request, "orderSeq", "");
		long orderSeq = Long.parseLong(testOrderSeq);

		Order order = null;
		orderDetailList = null;
		DeliveryInfo di = null;

		if (orderSeq > 0) {

			// 주문, 주문상세, 배송 조회
			order = orderService.orderSelect(orderSeq);
			orderDetailList = orderService.orderDetailSelect(orderSeq);
			di = orderService.deliInfoSelect(orderSeq);

			if (order != null && orderDetailList != null && di != null) {

				model.addAttribute("deliInfo", di);
				model.addAttribute("order", order);
				model.addAttribute("orderDetailList", orderDetailList);
			}
		}

		return "/order/paySuccess";
	}

	/*===================================================
	 *	카카오페이 결제 취소
	 ===================================================*/
	@RequestMapping(value = "/order/kakaoPay/cancel")
	@ResponseBody
	public Response<Object> cancel(Model model, HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long orderSeq = Long.parseLong(HttpUtil.get(request, "orderSeq", ""));
		String userId = HttpUtil.get(request, "userId", "");

		logger.debug("orderSeq : " + orderSeq + ", userId : " + userId);

		long refSeq = 0;
		int refundPrice = 0;

		if (orderSeq > 0) {

			// 주문
			Order order = null;
			Refund refund = null;
			orderDetailList = null;

			HttpSession session = request.getSession(false);

			if (session != null) {

				try {
					// 주문 조회
					order = orderService.orderSelect(orderSeq);

					if (order != null) {

						// 환불 조회
						refund = orderService.refundSelect(orderSeq);

						// 환불 내역이 존재하지 않으면 INSERT
						if (refund == null) {

							// 취소 요청 상태
							order.setOrderStatus("2");

							refund = new Refund();

							refund.setOrderSeq(orderSeq);
							refund.setUserId(userId);

							orderService.refundApply(order, refund);
						}

						refund = orderService.refundSelect(orderSeq);

						// 환불번호 받아오기
						refSeq = refund.getRefSeq();

						logger.debug("11111111111111111111111");
						logger.debug("ref : " + refund);

						// 배송 조회
						DeliveryInfo di = null;

						// 배송 조회
						di = orderService.deliInfoSelect(orderSeq);

						// 배송 정보가 있다면 환불 금액 : 결제 금액 - 6,000
						if (!StringUtil.isEmpty(di.getDlvStartDate())) {
							refundPrice = order.getPayPrice() - 6000;
						}
						// 배송 정보가 없다면 환불 금액 : 결제 금액
						else {
							refundPrice = order.getPayPrice();
						}

						// 환불 금액 세팅
						refund.setRefPrice(refundPrice);

						KakaoPayCancelRequest kakaoPayCancelRequest = new KakaoPayCancelRequest();

						kakaoPayCancelRequest.setCid(KAKAOPAY_CLIENT_ID); // 필수값
						kakaoPayCancelRequest.setTid(order.getTid()); // 필수값
						kakaoPayCancelRequest.setCancel_amount(refundPrice); // 필수값
						kakaoPayCancelRequest.setCancel_tax_free_amount(0); // 필수값

						// 선택값 제거
						// kakaoPayCancelRequest.setCancel_vat_amount(0);
						// kakaoPayCancelRequest.setCancel_available_amount(refundPrice);

						// 카카오페이 연동 시작
						KakaoPayCancelResponse kakaoPayCancelResponse = kakaoPayService.cancel(kakaoPayCancelRequest);

						if (kakaoPayCancelResponse != null) {
							logger.info("[OrderKakaoPayController] cancel kakaoPayCancelResponse : \n " + kakaoPayCancelResponse);

							if (kakaoPayCancelResponse.getError_code() == 0) {
								// 재고
								// 1. 주문상세 조회
								// 2. 주문한 책 번호, 개수 조회
								// 3. 책 재고 +

								orderDetailList = orderService.orderDetailSelect(orderSeq);

								for (int i = 0; i < orderDetailList.size(); i++) {

									Book qttBook = bookService.bookSelect("", orderDetailList.get(i).getBookSeq());

									qttBook.setQttMgrChk("2");
									qttBook.setQttVal(orderDetailList.get(i).getOrderCnt());

									if (bookService.bookQttMgr(qttBook) > 0) {
										logger.debug("재고 업데이트 성공~");
									}
								}

								// 성공
								order.setOrderStatus("3");
								orderService.refundComp(order, refund);

								res.setResponse(0, "정상적으로 결제가 취소되었습니다.");
							} else {
								res.setResponse(-1,
										(!StringUtil.isEmpty(kakaoPayCancelResponse.getError_message()) ? kakaoPayCancelResponse.getError_message()
												: "카카오페이 결제 취소 중 오류가 발생하였습니다."));
							}

						} else {
							res.setResponse(-4, "카카오페이 결제 처리 중 오류가 발생하였습니다.");
						}

					} else {
						res.setResponse(404, "실패 : 주문 존재하지 않음 ");
					}
				} catch (Exception e) {
					logger.error("[OrderKakaoPayController] cancel SQLException", e);
					res.setResponse(-4, "실패 : SQL 오류");
				}

			}

		} else {
			res.setResponse(400, "실패 : 주문번호 없음");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[OrderController] /cancel response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;
	}

	/*===================================================
	 *	카카오페이 결제 실패
	 ===================================================*/
	@RequestMapping(value = "/order/kakaoPay/fail", method = RequestMethod.GET)
	public String fail(Model model, HttpServletRequest request, HttpServletResponse response) {
		String tid = null;

		HttpSession session = request.getSession(false);
		if (session != null) {
			tid = (String) SessionUtil.getSession(session, KAKAOPAY_TID_SESSION_NAME);

			if (!StringUtil.isEmpty(tid)) {
				// tid 세션 삭제
				SessionUtil.removeSession(session, KAKAOPAY_TID_SESSION_NAME);

				// 실패시 DB작업 필요.
			}
		}

		// 취소
		model.addAttribute("code", -3);
		model.addAttribute("msg", "카카오페이 결제가 실패 하였습니다.");

		return "/kakao/result";
	}
}
