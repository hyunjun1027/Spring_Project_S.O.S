package com.sist.web.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.Admin;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardNotice;
import com.sist.web.model.BoardQna;
import com.sist.web.model.Book;
import com.sist.web.model.Course;
import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.OrderStatus;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.AdminService;
import com.sist.web.service.BoardService;
import com.sist.web.service.BookService;
import com.sist.web.service.CourseService;
import com.sist.web.service.OrderService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("adminController")
public class AdminController {

   private static Logger logger = LoggerFactory.getLogger(AdminController.class);

   @Value("#{env['auth.cookie.name']}")
   private String AUTH_COOKIE_NAME;

   @Value("#{env['auth.cookie.rate']}")
   private String AUTH_COOKIE_RATE;

   @Value("#{env['book.save.dir']}")
   private String BOOK_SAVE_DIR;

   private static final int ORDER_LIST_COUNT = 10; // 한페이지의 게시물 수
   private static final int ORDER_PAGE_COUNT = 5; // 페이징 수

   private static final int LIST_COUNT = 5; // 한 페이지의 게시물 수
   private static final int PAGE_COUNT = 5; // 페이징 수

   @Autowired
   private AdminService adminService;

   @Autowired
   private AccountService accountService;

   @Autowired
   private BoardService boardService;

   @Autowired
   private BookService bookService;

   @Autowired
   private OrderService orderService;

   @Autowired
   private CourseService courseService;

   // 결제 상태
   public String payStatus(String payStatus) {
      switch (payStatus) {
      case "1":
         return "입금대기";
      case "2":
         return "결제완료";
      case "3":
         return "결제실패";
      case "4":
         return "취소요청";
      case "5":
         return "주문취소";
      default:
         return "";
      }
   }

   // 주문 상태 (결제상태가 '결제완료'일 때만 유효)
   public String orderStatus(String payStatus, String orderStatus) {
      if (!"2".equals(payStatus)) { // 결제 상태가 '결제완료'인지 확인
         return "";
      }

      switch (orderStatus) {
      case "1":
         return "주문접수";
      case "2":
         return "주문확인";
      case "3":
         return "준비 중";
      case "4":
         return "주문완료";
      default:
         return "";
      }
   }

   // 배송 상태 (주문상태가 '주문완료'일 때만 유효)
   public String deliStatus(String orderStatus, String deliStatus) {
      if (!"4".equals(orderStatus)) { // 주문 상태가 '주문완료'인지 확인
         return "";
      }

      switch (deliStatus) {
      case "1":
         return "배송준비중";
      case "2":
         return "배송중";
      case "3":
         return "배송완료";
      default:
         return "";
      }
   }

   // viewStatus 계산
   public String viewStatusCal(String payStatus, String orderStatus, String deliStatus) {
      String viewStatus = "";

      if (StringUtil.equals(payStatus, "취소요청") || StringUtil.equals(payStatus, "주문취소")) {
         // 결제 상태가 '취소요청' 또는 '취소완료'인 경우
         viewStatus = payStatus;
      } else {
         // 그 외의 경우
         if (!StringUtil.isEmpty(deliStatus)) {
            // 배송상태가 존재하면 배송상태
            viewStatus = deliStatus;
         } else if (!StringUtil.isEmpty(orderStatus)) {
            // 배송상태가 없고, 주문상태가 존재하면 주문상태
            viewStatus = orderStatus;
         } else {
            // 주문상태와 배송상태 모두 없으면 결제상태
            viewStatus = payStatus;
         }
      }

      return viewStatus;
   }

   /*===================================================
    * 관리자 로그인 화면
    ===================================================*/
   @RequestMapping(value = "/admin/adminLogin")
   public String admin(HttpServletRequest request, HttpServletResponse response) {
      return "/admin/adminLogin";
   }

   // 로그인
   @RequestMapping(value = "/admin/adminLogin", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> login(HttpServletRequest request, HttpServletResponse response) {

      Response<Object> res = new Response<Object>();

      String userId = HttpUtil.get(request, "admId");
      String userPwd = HttpUtil.get(request, "admPwd");

      if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {

         Admin admin = adminService.AdminSelect(userId);

         if (admin != null) {

            if (StringUtil.equals(admin.getUserPwd(), userPwd)) {

               if (StringUtil.equals(admin.getRating(), "A")) {

                  CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_NAME, CookieUtil.stringToHex(userId));
                  CookieUtil.addCookie(response, "/", 0, AUTH_COOKIE_RATE, CookieUtil.stringToHex(admin.getRating()));
                  res.setResponse(0, "success");

               } else {
                  res.setResponse(-99, "rating error");
               }
            } else {
               // 비밀번호 불일치
               res.setResponse(-1, "password mismatch");
            }
         } else {
            res.setResponse(404, "not found");
         }
      } else {
         res.setResponse(400, "Bad Request");
      }

      return res;

   }
   
   //관리자 로그인 확인
   @RequestMapping(value = "/admin/adminLoginCheck", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> adminLoginCheck(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      
      if (!StringUtil.isEmpty(cookieUserId))
      {
         Admin admin = adminService.AdminSelect(cookieUserId);
         
         if(admin != null)
         {
            if (StringUtil.equals(admin.getRating(), "A")) 
            {
               res.setResponse(1, "pass");
            }
         }
         else
         {
            res.setResponse(-999, "user");
         }
      }
      else {
         res.setResponse(0, "login");
      }
      
      return res;
   }
   
   // 메인화면
   @RequestMapping(value = "/admin/index")
   public String index(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      List<User> list = null;
      String rating = HttpUtil.get(request, "rating", (String) "");
      String status = HttpUtil.get(request, "status", (String) "");

      ArrayList<Integer> orderCountList = new ArrayList<>();
      ArrayList<Integer> courseCountList = new ArrayList<>();

      for (int count = -5; count <= 0; count++) {
         orderCountList.add(adminService.getOrderCount(count));
      }

      for (int classCode = 1; classCode <= 5; classCode++) {
         courseCountList.add(courseService.allCourseClassListCntSelect(classCode));
      }

      list = adminService.userSelectAll(rating, status);

      // 이번달 주문건수
      int monthOrderCnt = adminService.monthOrderCnt();
      // 이번달 주문금액
      int monthOrderPrice = adminService.monthOrderPrice();
      java.util.Calendar calendar = java.util.Calendar.getInstance();
      // 이번달
      int currentMonth = calendar.get(java.util.Calendar.MONTH) + 1;

      // 결제상태
      String payStatus = "";
      // 주문상태
      String orderStatus = "";
      // 배송상태
      String deliStatus = "";
      // 보여줄 상태
      String viewStatus = "";

      int waitPay = 0;
      int comPay = 0;
      int waitDeli = 0;
      int ingDeli = 0;
      int comDeli = 0;
      int appCancle = 0;
      int comCancle = 0;

      List<OrderStatus> osl = adminService.monthOrderStatus();

      if (osl != null) {

         for (OrderStatus os : osl) {
            payStatus = payStatus(os.getPayStatus());
            orderStatus = orderStatus(os.getPayStatus(), os.getOrderStatus());
            deliStatus = deliStatus(os.getOrderStatus(), os.getDlvStatus());

            viewStatus = viewStatusCal(payStatus, orderStatus, deliStatus);

            switch (viewStatus) {
            case "입금대기":
               waitPay += 1;
               break;
            case "주문접수":
               comPay += 1;
               break;
            case "배송준비중":
               waitDeli += 1;
               break;
            case "배송중":
               ingDeli += 1;
               break;
            case "배송완료":
               comDeli += 1;
               break;
            case "취소요청":
               appCancle += 1;
               break;
            case "주문취소":
               comCancle += 1;
               break;
            default:
               System.out.println("Unknown viewStatus: " + viewStatus);
               break;
            }
         }
      }

      logger.debug("[입금대기] : " + waitPay + ", [주문접수] : " + comPay + ", [배송준비중] : " + waitDeli + ", [배송중] : " + ingDeli + ", [배송완료] : " + comDeli
            + ", [취소요청] : " + appCancle + ", [취소완료] : " + comCancle);

      model.addAttribute("waitPay", waitPay);
      model.addAttribute("comPay", comPay);
      model.addAttribute("waitDeli", waitDeli);
      model.addAttribute("ingDeli", ingDeli);
      model.addAttribute("comDeli", comDeli);
      model.addAttribute("appCancle", appCancle);
      model.addAttribute("comCancle", comCancle);

      model.addAttribute("monthOrderCnt", monthOrderCnt);
      model.addAttribute("monthOrderPrice", monthOrderPrice);
      model.addAttribute("currentMonth", currentMonth);

      model.addAttribute("list", list);
      model.addAttribute("orderCountList", orderCountList);
      model.addAttribute("courseCountList", courseCountList);

      return "/admin/index";
   }

   // 유저관리
   @RequestMapping(value = "/admin/userMgr")
   public String userMgr(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String rating = HttpUtil.get(request, "rating", "");
      String status = HttpUtil.get(request, "status", "");
      String classCode = HttpUtil.get(request, "classCode", "");

      List<User> list = null;
      List<Teacher> noTeacherList = null;

      list = adminService.userSelectAll(rating, status);
      noTeacherList = adminService.selectNoTeacher(classCode);
      
      for (Teacher teacher : noTeacherList) {
          String phone = teacher.getUserPhone();
          if (phone != null && phone.length() == 11) {
              phone = phone.substring(0, 3) + " - " + phone.substring(3, 7) + " - " + phone.substring(7);
              teacher.setUserPhone(phone);
          }
      }

      model.addAttribute("list", list);
      model.addAttribute("rating", rating);
      model.addAttribute("status", status);
      model.addAttribute("noTeacherList", noTeacherList);
      model.addAttribute("classCode", classCode);

      return "/admin/userMgr";
   }

   // 유저 업데이트
   @RequestMapping(value = "/admin/userChange", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> userChange(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String rating = HttpUtil.get(request, "rating", "");
      String status = HttpUtil.get(request, "status", "");
      String userId = HttpUtil.get(request, "userId", "");

      if (StringUtil.equals(rating, "U")) {
         if (accountService.userSelect(userId) != null) {
            accountService.userStatusupdate(userId, status);
            ajaxResponse.setResponse(0, "internal server error");
         } else {
            ajaxResponse.setResponse(500, "internal server error");
         }
      } else if (StringUtil.equals(rating, "T")) {
         if (accountService.teacherSelect(userId) != null) {
            accountService.teacherStatusupdate(userId, status);
            ajaxResponse.setResponse(0, "internal server error");
         } else {
            ajaxResponse.setResponse(500, "internal server error");
         }
      }

      return ajaxResponse;
   }

   // 강사신청 승인
   @RequestMapping(value = "/admin/noTeacherOk", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noTeacherOk(@RequestBody List<String> teacherIdList, HttpServletRequest request) {
      Response<Object> ajaxResponse = new Response<Object>();

      try {
         for (String teacherId : teacherIdList) {
            int result = adminService.noTeacherOk(teacherId);
            if (result < 0) {
               ajaxResponse.setResponse(300, "error");
               return ajaxResponse;
            }
         }
         ajaxResponse.setResponse(0, "seccuss");
      } catch (Exception e) {
         ajaxResponse.setResponse(500, "no access");
      }

      return ajaxResponse;
   }

   // 강사신청 승인
   @RequestMapping(value = "/admin/noTeacherNo", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noTeacherNo(@RequestBody List<String> teacherIdList, HttpServletRequest request) {
      Response<Object> ajaxResponse = new Response<Object>();

      try {
         for (String teacherId : teacherIdList) {
            int result = adminService.noTeacherNo(teacherId);
            if (result < 0) {
               ajaxResponse.setResponse(300, "error");
               return ajaxResponse;
            }
         }
         ajaxResponse.setResponse(0, "seccuss");
      } catch (Exception e) {
         ajaxResponse.setResponse(500, "no access");
      }

      return ajaxResponse;
   }

   // 관리자 조회
   @RequestMapping(value = "/admin/adminSelect", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> adminSelect(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();
      String userId = HttpUtil.get(request, "userId", "");

      Admin admin = null;

      if (!StringUtil.isEmpty(userId)) {

         admin = adminService.adminSelect(userId);

         if (admin != null) {
            ajaxResponse.setResponse(0, "success");
         } else {
            ajaxResponse.setResponse(400, "error");
         }
      } else {
         ajaxResponse.setResponse(500, "no access");
      }

      return ajaxResponse;
   }

   // 관리자 등록
   @RequestMapping(value = "/admin/adminInsert", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> joinProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();
      String userId = HttpUtil.get(request, "userId", "");
      String userPwd = HttpUtil.get(request, "userPwd", "");
      Admin admin = null;

      if (!StringUtil.isEmpty(userId) && !StringUtil.isEmpty(userPwd)) {

         admin = adminService.adminSelect(userId);

         if (admin == null) {
            admin = new Admin();

            admin.setUserId(userId);
            admin.setUserPwd(userPwd);

            if (adminService.adminInsert(admin) > 0) {
               ajaxResponse.setResponse(0, "success");
            } else {
               ajaxResponse.setResponse(300, "error");
            }
         } else {
            ajaxResponse.setResponse(400, "same Id");
         }
      } else {
         ajaxResponse.setResponse(404, "not code");
      }

      return ajaxResponse;
   }

   /*===================================================
      *   관리자 게시판 화면
      ===================================================*/
   @RequestMapping(value = "/admin/boardMgr")
   public String noticeQnaAndFreeList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

       long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
       String searchType = HttpUtil.get(request, "searchType", "");
       String searchValue = HttpUtil.get(request, "searchValue", "");
       long noticeCurPage = HttpUtil.get(request, "noticeCurPage", (long) 1); // 공지사항 페이지
       long qnaCurPage = HttpUtil.get(request, "qnaCurPage", (long) 1); // 문의사항 페이지
       long freeCurPage = HttpUtil.get(request, "freeCurPage", (long) 1); // 자유게시판 페이지
       long noticeDelCurPage = HttpUtil.get(request, "noticeDelCurPage", (long) 1); // 삭제된 공지사항 페이지
       long qnaDelCurPage = HttpUtil.get(request, "qnaDelCurPage", (long) 1); // 삭제된 문의사항 페이지
       long freeDelCurPage = HttpUtil.get(request, "freeDelCurPage", (long) 1); // 삭제된 자유게시판 페이지
       int category = HttpUtil.get(request, "category", (int) 0);
       int listCount = HttpUtil.get(request, "listCount", (int) 10);
       int options = HttpUtil.get(request, "options", (int) 1);

       // 총 게시물 수
       long noticeTotalCount = 0;
       long qnaTotalCount = 0;
       long freeTotalCount = 0;

       // 삭제된 게시물 수
       long noticeDelTotalCount = 0;
       long qnaDelTotalCount = 0;
       long freeDelTotalCount = 0;

       // 게시물 리스트
       List<BoardNotice> noticeList = null;
       List<BoardQna> qnaList = null;
       List<Board> freeList = null;

       List<BoardNotice> noticeDelList = null; // 삭제된 공지사항 리스트
       List<BoardQna> qnaDelList = null; // 삭제된 문의사항 리스트
       List<Board> freeDelList = null; // 삭제된 자유게시판 리스트

       Admin admin = adminService.AdminSelect(cookieUserId);

       // 조회 객체
       BoardNotice noticeSearch = new BoardNotice();
       BoardQna qnaSearch = new BoardQna();
       Board freeSearch = new Board();

       // 페이징 객체
       Paging noticePaging = null;
       Paging qnaPaging = null;
       Paging freePaging = null;
       Paging noticeDelPaging = null;
       Paging qnaDelPaging = null;
       Paging freeDelPaging = null;

       // 공지사항 검색 조건 설정
       if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
           noticeSearch.setSearchType(searchType);
           noticeSearch.setSearchValue(searchValue);
       }

       noticeTotalCount = boardService.noticeBoardListCount(noticeSearch);

       if (noticeTotalCount > 0) {
           noticePaging = new Paging("/admin/boardMgr", noticeTotalCount, LIST_COUNT, PAGE_COUNT, noticeCurPage, "noticeCurPage");

           noticeSearch.setStartRow(noticePaging.getStartRow());
           noticeSearch.setEndRow(noticePaging.getEndRow());

           noticeList = boardService.noticeBoardList(noticeSearch);
       }

       // 삭제된 공지사항 리스트 조회
       noticeDelTotalCount = boardService.noticeDelBoardListCount(noticeSearch); // 삭제된 공지사항 총 수
       if (noticeDelTotalCount > 0) {
           noticeDelPaging = new Paging("/admin/boardMgr", noticeDelTotalCount, LIST_COUNT, PAGE_COUNT, noticeDelCurPage, "noticeDelCurPage");

           noticeSearch.setStartRow(noticeDelPaging.getStartRow());
           noticeSearch.setEndRow(noticeDelPaging.getEndRow());

           noticeDelList = boardService.noticeDelBoardList(noticeSearch);
       }

       // 문의사항 검색 조건 설정
       if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
           qnaSearch.setSearchType(searchType);
           qnaSearch.setSearchValue(searchValue);
       }

       qnaTotalCount = boardService.qnaBoardListCount(qnaSearch);

       if (qnaTotalCount > 0) {
           qnaPaging = new Paging("/admin/boardMgr", qnaTotalCount, LIST_COUNT, PAGE_COUNT, qnaCurPage, "qnaCurPage");

           qnaSearch.setStartRow(qnaPaging.getStartRow());
           qnaSearch.setEndRow(qnaPaging.getEndRow());

           qnaList = boardService.qnaBoardList(qnaSearch);

           for (BoardQna qna : qnaList) {
               boolean hasReply = boardService.hasReplies(qna.getBrdSeq());
               qna.setHasReply(hasReply);
           }
       }

       // 삭제된 문의사항 리스트 조회
       qnaDelTotalCount = boardService.qnaDelBoardListCount(qnaSearch); // 삭제된 문의사항 총 수
       if (qnaDelTotalCount > 0) {
           qnaDelPaging = new Paging("/admin/boardMgr", qnaDelTotalCount, LIST_COUNT, PAGE_COUNT, qnaDelCurPage, "qnaDelCurPage");

           qnaSearch.setStartRow(qnaDelPaging.getStartRow());
           qnaSearch.setEndRow(qnaDelPaging.getEndRow());

           qnaDelList = boardService.qnaDelBoardList(qnaSearch);
           
           for (BoardQna qna : qnaDelList) {
               boolean hasReply = boardService.hasReplies(qna.getBrdSeq());
               qna.setHasReply(hasReply);
           }
       }

       // 자유게시판 검색 조건 설정
       freeSearch.setOptions(options);
       if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
           freeSearch.setSearchType(searchType);
           freeSearch.setSearchValue(searchValue);
       }
       if (category > 0) {
           freeSearch.setCategory(category);
       }

       freeTotalCount = boardService.freeBoardListCount(freeSearch);

       if (freeTotalCount > 0) {
           freePaging = new Paging("/admin/boardMgr", freeTotalCount, LIST_COUNT, PAGE_COUNT, freeCurPage, "freeCurPage");

           freeSearch.setStartRow(freePaging.getStartRow());
           freeSearch.setEndRow(freePaging.getEndRow());

           freeList = boardService.freeBoardList(freeSearch);

           for (Board board : freeList) {
               BoardFile boardFile = boardService.freeBoardFileSelect(board.getBrdSeq());
               int boardLikeCount = boardService.freeSelectLikeCount(board.getBrdSeq());

               board.setBoardFile(boardFile);
               board.setBoardLikeCount(boardLikeCount);
           }
       }

       // 삭제된 자유게시판 리스트 조회
       freeDelTotalCount = boardService.freeDelBoardListCount(freeSearch); // 삭제된 자유게시판 총 수
       if (freeDelTotalCount > 0) {
           freeDelPaging = new Paging("/admin/boardMgr", freeDelTotalCount, LIST_COUNT, PAGE_COUNT, freeDelCurPage, "freeDelCurPage");

           freeSearch.setStartRow(freeDelPaging.getStartRow());
           freeSearch.setEndRow(freeDelPaging.getEndRow());

           freeDelList = boardService.freeDelBoardList(freeSearch);
       }

       // 모델에 데이터 추가
       model.addAttribute("noticeTotalCount", noticeTotalCount);
       model.addAttribute("qnaTotalCount", qnaTotalCount);
       model.addAttribute("freeTotalCount", freeTotalCount);

       model.addAttribute("noticeList", noticeList);
       model.addAttribute("noticePaging", noticePaging);
       model.addAttribute("qnaList", qnaList);
       model.addAttribute("qnaPaging", qnaPaging);
       model.addAttribute("freeList", freeList);
       model.addAttribute("freePaging", freePaging);
       model.addAttribute("searchType", searchType);
       model.addAttribute("searchValue", searchValue);
       model.addAttribute("noticeCurPage", noticeCurPage); // 공지사항 페이지
       model.addAttribute("qnaCurPage", qnaCurPage); // 문의사항 페이지
       model.addAttribute("freeCurPage", freeCurPage); // 자유게시판 페이지
       model.addAttribute("category", category);
       model.addAttribute("listCount", listCount);
       model.addAttribute("options", options);
       model.addAttribute("admin", admin);
       model.addAttribute("brdSeq", brdSeq);

       // 삭제된 게시물 리스트 추가
       model.addAttribute("noticeDelList", noticeDelList);
       model.addAttribute("qnaDelList", qnaDelList);
       model.addAttribute("freeDelList", freeDelList);
       
       // 삭제된 게시물 총 갯수 추가
       model.addAttribute("noticeDelTotalCount", noticeDelTotalCount);
       model.addAttribute("qnaDelTotalCount", qnaDelTotalCount);
       model.addAttribute("freeDelTotalCount", freeDelTotalCount);
       
       // 삭제된 게시물 페이징 객체 추가
       model.addAttribute("noticeDelPaging", noticeDelPaging);
       model.addAttribute("qnaDelPaging", qnaDelPaging);
       model.addAttribute("freeDelPaging", freeDelPaging);

       return "/admin/boardMgr";
   }

   /*===================================================
    *   공지사항 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/admin/noticeDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noticeDelete(@RequestBody List<Long> brdSeqList, HttpServletRequest request) throws Exception {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 사용자 ID 추출

      if (cookieUserId == null || cookieUserId.isEmpty()) {
         ajaxResponse.setResponse(-400, "no access");
         return ajaxResponse; // 로그인되지 않은 사용자
      }

      StringBuilder failedBrdSeq = new StringBuilder();

      for (Long brdSeq : brdSeqList) {
         BoardNotice baordNotice = boardService.noticeBoardSelect(brdSeq);

         if (baordNotice != null) {
            // 게시글이 존재하고, 작성자가 로그인한 사용자와 동일한 경우에만 삭제
            int result = boardService.noticeBoardDelete(brdSeq); // 삭제 실행
            if (result == 0) {
               failedBrdSeq.append(brdSeq).append(", ");
            }
         } else {
            failedBrdSeq.append(brdSeq).append(", ");
         }
      }

      if (failedBrdSeq.length() > 0) {
         ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
      } else {
         ajaxResponse.setResponse(0, "Posts deleted successfully");
      }

      return ajaxResponse;
   }
   
   /*===================================================
    *   공지사항 게시글 완전 삭제
    ===================================================*/
   @RequestMapping(value = "/admin/noticeRealDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noticeRealDelete(@RequestBody List<Long> brdSeqList, HttpServletRequest request) throws Exception {
	   Response<Object> ajaxResponse = new Response<Object>();
	   String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 사용자 ID 추출
	   
	   if (cookieUserId == null || cookieUserId.isEmpty()) {
		   ajaxResponse.setResponse(-400, "no access");
		   return ajaxResponse; // 로그인되지 않은 사용자
	   }
	   
	   StringBuilder failedBrdSeq = new StringBuilder();
	   
	   for (Long brdSeq : brdSeqList) {
		   BoardNotice baordNotice = boardService.noticeBoardSelect(brdSeq);
		   
		   if (baordNotice != null) {
			   // 게시글이 존재하고, 작성자가 로그인한 사용자와 동일한 경우에만 삭제
			   int result = boardService.noticeRealBoardDelete(brdSeq); // 삭제 실행
			   if (result == 0) {
				   failedBrdSeq.append(brdSeq).append(", ");
			   }
		   } else {
			   failedBrdSeq.append(brdSeq).append(", ");
		   }
	   }
	   
	   if (failedBrdSeq.length() > 0) {
		   ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
	   } else {
		   ajaxResponse.setResponse(0, "Posts deleted successfully");
	   }
	   
	   return ajaxResponse;
   }

   /*===================================================
    *   1:1문의사항 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/admin/qnaDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnaDelete(@RequestBody List<Long> brdSeqList, HttpServletRequest request) throws Exception {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 사용자 ID 추출

      if (cookieUserId == null || cookieUserId.isEmpty()) {
         ajaxResponse.setResponse(-400, "no access");
         return ajaxResponse; // 로그인되지 않은 사용자
      }

      StringBuilder failedBrdSeq = new StringBuilder(); // 실패한 brdSeq를 기록

      for (Long brdSeq : brdSeqList) {
         BoardQna boardQna = boardService.qnaBoardSelect(brdSeq); // 게시글 조회

         if (boardQna != null) {
            int result = boardService.qnaBoardDelete(brdSeq); // 삭제 실행
            if (result == 0) {
               failedBrdSeq.append(brdSeq).append(", ");
            }
         } else {
            failedBrdSeq.append(brdSeq).append(", ");
         }
      }

      if (failedBrdSeq.length() > 0) {
         ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
      } else {
         ajaxResponse.setResponse(0, "Posts deleted successfully");
      }

      return ajaxResponse;
   }
   
   /*===================================================
    *   1:1문의사항 완전 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/admin/qnaRealDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnaRealDelete(@RequestBody List<Long> brdSeqList, HttpServletRequest request) throws Exception {
       Response<Object> ajaxResponse = new Response<Object>();
       String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 사용자 ID 추출

       if (cookieUserId == null || cookieUserId.isEmpty()) {
           ajaxResponse.setResponse(-400, "no access");
           return ajaxResponse; // 로그인되지 않은 사용자
       }

       StringBuilder failedBrdSeq = new StringBuilder(); // 실패한 brdSeq를 기록

       for (Long brdSeq : brdSeqList) {
           BoardQna boardQna = boardService.qnaBoardSelect(brdSeq); // 게시글 조회

           if (boardQna != null) {
               try {
                   // 게시글 삭제 실행
                   int result = boardService.qnaRealBoardDelete(brdSeq); // 게시글 및 관련 파일, 댓글 삭제
                   if (result == 0) {
                       failedBrdSeq.append(brdSeq).append(", ");
                   }
               } catch (Exception e) {
                   logger.error("Error during deletion of board seq: {}", brdSeq, e);
                   failedBrdSeq.append(brdSeq).append(", ");
               }
           } else {
               failedBrdSeq.append(brdSeq).append(", "); // 해당 게시글이 존재하지 않는 경우
           }
       }

       if (failedBrdSeq.length() > 0) {
           ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
       } else {
           ajaxResponse.setResponse(0, "Posts deleted successfully");
       }

       return ajaxResponse;
   }






   /*===================================================
    *   자유게시판 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/admin/freeDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeDelete(@RequestBody List<Long> brdSeqList, HttpServletRequest request) throws Exception {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 사용자 ID 추출

      if (cookieUserId == null || cookieUserId.isEmpty()) {
         ajaxResponse.setResponse(-400, "no access");
         return ajaxResponse; // 로그인되지 않은 사용자
      }

      StringBuilder failedBrdSeq = new StringBuilder();

      for (Long brdSeq : brdSeqList) {
         Board board = boardService.freeBoardSelect(brdSeq);

         if (board != null) {
            // 게시글이 존재하고, 작성자가 로그인한 사용자와 동일한 경우에만 삭제
            int result = boardService.freeBoardDelete(brdSeq); // 삭제 실행
            if (result == 0) {
               failedBrdSeq.append(brdSeq).append(", ");
            }
         } else {
            failedBrdSeq.append(brdSeq).append(", ");
         }
      }

      if (failedBrdSeq.length() > 0) {
         ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
      } else {
         ajaxResponse.setResponse(0, "Posts deleted successfully");
      }

      return ajaxResponse;
   }
   /*===================================================
    *   자유게시판 게시글 완전 삭제
    ===================================================*/
   @RequestMapping(value = "/admin/freeRealDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeRealDelete(@RequestBody List<String> brdSeqList, HttpServletRequest request) throws Exception {
       Response<Object> ajaxResponse = new Response<Object>();
       String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
       
       if (cookieUserId == null || cookieUserId.isEmpty()) {
           ajaxResponse.setResponse(-400, "no access");
           return ajaxResponse;
       }
       
       StringBuilder failedBrdSeq = new StringBuilder();
       
       for (String brdSeqString : brdSeqList) {
           long brdSeq = Long.parseLong(brdSeqString);
           int result = boardService.freeRealBoardDelete(brdSeq);
           
           if (result == 0) {
               failedBrdSeq.append(brdSeq).append(", ");
           }
       }
       
       
       if (failedBrdSeq.length() > 0) {
           failedBrdSeq.setLength(failedBrdSeq.length() - 2); 
           ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
       } else {
           ajaxResponse.setResponse(0, "Posts deleted successfully");
       }
       
       return ajaxResponse;
   }

   // 주문관리 페이지
   @RequestMapping(value = "/admin/orderMgr")
   public String orderMgr(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      // 유저 아이디
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      // 주문내역 리스트
      List<Order> ol = null;
      // 주문상세 내역
      OrderDetail od = null;
      // 배송
      DeliveryInfo di = null;
      // 결제상태
      String payStatus = "";
      // 주문상태
      String orderStatus = "";
      // 배송상태
      String deliStatus = "";
      // 보여줄 상태
      String viewStatus = "";

      // 검색 조건
      // 1. 주문상태
      String searchOrderStatus = HttpUtil.get(request, "searchOrderStatus", "0");
      // 2. 주문날짜 (시작날짜, 마감날짜)
      String searchStartDate = HttpUtil.get(request, "searchStartDate", "");
      String searchEndDate = HttpUtil.get(request, "searchEndDate", "");
      // 3. 주문번호
      String searchOrderSeq = HttpUtil.get(request, "searchOrderSeq", "");

      logger.debug("==================================================================================");
      logger.debug("검색 주문 상태 : " + searchOrderStatus + ", 검색 주문 시작 날짜 : " + searchStartDate + ", 검색 주문 마감 날짜 : " + searchEndDate + ", 검색 주문 번호 : "
            + searchOrderSeq);
      logger.debug("==================================================================================");

      // 검색할 객체
      Order search = new Order();
      // 주문내역 총 개수
      int totalCount = 0;
      // 페이징
      Paging paging = null;
      // 현재 페이지
      long curPage = HttpUtil.get(request, "curPage", 1);

      if (cookieUserId != null) {

         if (StringUtil.isEmpty(searchOrderStatus)) {
            searchOrderStatus = "0";
         }

         // 검색 조건
         if (!StringUtil.isEmpty(searchOrderStatus) && !StringUtil.equals(searchOrderStatus, "0")) {
            // 1. 주문접수
            if (StringUtil.equals(searchOrderStatus, "1")) {
               search.setOrderStatus("1");
            }

            // 2. 취소요청
            else if (StringUtil.equals(searchOrderStatus, "2")) {
               search.setOrderStatus("2");
            }

            // 3. 주문취소
            else if (StringUtil.equals(searchOrderStatus, "3")) {
               search.setOrderStatus("3");
            }

            // 4. 입금대기
            else if (StringUtil.equals(searchOrderStatus, "4")) {
               search.setOrderStatus("4");
            }

            // 5. 배송준비
            else if (StringUtil.equals(searchOrderStatus, "5")) {
               search.setOrderStatus("5");
            }

            // 6. 배송중
            else if (StringUtil.equals(searchOrderStatus, "6")) {
               search.setOrderStatus("6");
            }

            // 7. 배송완료
            else if (StringUtil.equals(searchOrderStatus, "7")) {
               search.setOrderStatus("7");
            }

            logger.debug(search.getOrderStatus());

         }

         if (!StringUtil.isEmpty(searchStartDate)) {
            search.setSearchStartDate(searchStartDate);
         }
         if (!StringUtil.isEmpty(searchEndDate)) {
            search.setSearchEndDate(searchEndDate);
         }
         if (!StringUtil.isEmpty(searchOrderSeq) && !StringUtil.equals(searchOrderSeq, "0")) {
            search.setSearchOrderSeq(Long.parseLong(searchOrderSeq));
         }

         totalCount = adminService.adminOrderListCount(search);

         logger.debug("========================================");
         logger.debug("totalCount : " + totalCount);
         logger.debug("========================================");

         if (totalCount > 0) {
            paging = new Paging("/admin/orderMgr", totalCount, ORDER_LIST_COUNT, ORDER_PAGE_COUNT, curPage, "curPage");

            search.setStartRow(paging.getStartRow());
            search.setEndRow(paging.getEndRow());

            ol = adminService.adminOrderList(search);

            model.addAttribute("orderPaging", paging);

            if (ol != null) {

               for (int i = 0; i < ol.size(); i++) {
                  Order order = ol.get(i);
                  di = orderService.deliInfoSelect(order.getOrderSeq());

                  payStatus = payStatus(order.getPayStatus());
                  orderStatus = orderStatus(order.getPayStatus(), order.getOrderStatus());
                  deliStatus = deliStatus(order.getOrderStatus(), di.getDlvStatus());
                  order.setViewOrderDate(di.getUserPhone());

                  logger.debug(order.getOrderSeq() + ", " + order.getPayStatus() + ", " + order.getOrderStatus() + ", " + di.getDlvStatus());

                  logger.debug("payStatus: " + payStatus + ", orderStatus : " + orderStatus + ", deliStatus : " + deliStatus);

                  viewStatus = viewStatusCal(payStatus, orderStatus, deliStatus);

                  order.setViewStatus(viewStatus);

                  // 디버깅
                  logger.debug("orderSeq : " + order.getOrderSeq() + ", viewStatus : " + viewStatus);

               }

               model.addAttribute("ol", ol);
            }
         }
      }

      // 날짜 포맷 변환
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
      try {
         if (searchStartDate != null && !searchStartDate.isEmpty()) {
            Date startDate = dateFormat.parse(searchStartDate);
            searchStartDate = dateFormat.format(startDate);
         }
         if (searchEndDate != null && !searchEndDate.isEmpty()) {
            Date endDate = dateFormat.parse(searchEndDate);
            searchEndDate = dateFormat.format(endDate);
         }
      } catch (ParseException e) {
         e.printStackTrace();
         searchStartDate = "";
         searchEndDate = "";
      }

      logger.debug("startDate : " + searchStartDate + ", endDate : " + searchEndDate);

      model.addAttribute("searchStartDate", searchStartDate);
      model.addAttribute("searchEndDate", searchEndDate);

      model.addAttribute("searchOrderStatus", searchOrderStatus);
      model.addAttribute("searchOrderSeq", searchOrderSeq);
      model.addAttribute("curPage", curPage);

      return "/admin/orderMgr";
   }

   // 모달창 주문상세정보 요청
   @RequestMapping(value = "/admin/orderDetailModal")
   @ResponseBody
   public Response<Object> orderDetailModal(HttpServletRequest request, HttpServletResponse response) {

      Response<Object> res = new Response<Object>();

      // 결제상태
      String payStatus = "";
      // 주문상태
      String orderStatus = "";
      // 배송상태
      String deliStatus = "";
      // 보여줄 상태
      String viewStatus = "";

      String orderSeqVal = HttpUtil.get(request, "orderSeq", "");
      long orderSeq = Long.parseLong(orderSeqVal);

      logger.debug("orderSeq : " + orderSeq);

      if (orderSeq > 0) {

         // 주문 조회 (상태값 때문에)
         // 주문 상세 조회 (List)
         // 배송 조회
         Order order = adminService.adminOrderSelect(orderSeq);
         List<OrderDetail> odl = adminService.adminOrderDetailSelect(orderSeq);
         DeliveryInfo di = adminService.adminDeliInfoSelect(orderSeq);

         if (order != null && odl != null && di != null) {
            Map<String, Object> responseData = new HashMap<>();

            responseData.put("order", order);
            responseData.put("orderDetailList", odl);
            responseData.put("deliveryInfo", di);

            payStatus = payStatus(order.getPayStatus());
            orderStatus = orderStatus(order.getPayStatus(), order.getOrderStatus());
            deliStatus = deliStatus(order.getOrderStatus(), di.getDlvStatus());

            logger.debug(order.getOrderSeq() + ", " + order.getPayStatus() + ", " + order.getOrderStatus() + ", " + di.getDlvStatus());

            logger.debug("payStatus: " + payStatus + ", orderStatus : " + orderStatus + ", deliStatus : " + deliStatus);

            viewStatus = viewStatusCal(payStatus, orderStatus, deliStatus);

            order.setViewStatus(viewStatus);

            res.setResponse(0, "성공", responseData);
         } else {
            res.setResponse(-1, "실패 : 데이터가 없음");
         }

      } else {
         res.setResponse(400, "실패 : 파라미터 값 안 넘어옴");
      }

      if (logger.isDebugEnabled()) {
         logger.debug("[AdminController] /orderDetailModal response\n" + JsonUtil.toJsonPretty(res));
      }

      return res;
   }

   // 주문상태 값 변경
   @RequestMapping(value = "/admin/orderStatusChange")
   @ResponseBody
   public Response<Object> orderStatusChange(HttpServletRequest request, HttpServletResponse response) {

      Response<Object> res = new Response<Object>();

      long orderSeq = Long.parseLong(HttpUtil.get(request, "orderSeq", ""));
      String modiOrderStatus = HttpUtil.get(request, "modiOrderStatus", "");

      logger.debug("orderSeq : " + orderSeq + ", modiOrderStatus : " + modiOrderStatus);

      if (!StringUtil.isEmpty(modiOrderStatus) && orderSeq > 0) {

         // 주문 테이블 -> 주문접수, 취소요청, 주문취소(X), 입금대기
         // 배송 테이블 -> 배송준비, 배송중, 배송완료
         Order order = new Order();

         order.setOrderSeq(orderSeq);

         // 1. 주문접수
         if (StringUtil.equals(modiOrderStatus, "1")) {
            order.setOrderStatus("1");
         }

         // 2. 취소요청
         if (StringUtil.equals(modiOrderStatus, "2")) {
            order.setOrderStatus("2");
         }

         // 3. 주문취소
         if (StringUtil.equals(modiOrderStatus, "3")) {
            order.setOrderStatus("3");
         }

         // 5. 배송준비
         if (StringUtil.equals(modiOrderStatus, "5")) {
            order.setOrderStatus("5");
         }

         // 6. 배송중
         if (StringUtil.equals(modiOrderStatus, "6")) {
            order.setOrderStatus("6");
         }

         // 7. 배송완료
         if (StringUtil.equals(modiOrderStatus, "7")) {
            order.setOrderStatus("7");
         }

         logger.debug("orderStatus : " + order.getOrderStatus());

         if (adminService.statusUpdate(order) > 0) {
            res.setResponse(0, "성공 : 주문 상태 업데이트 완료");
         } else {
            res.setResponse(-1, "실패 : DB 오류");
         }

      } else {
         res.setResponse(400, "실패 : 파라미터 값 안 넘어옴");
      }

      if (logger.isDebugEnabled()) {
         logger.debug("[AdminController] /orderStatusChange response\n" + JsonUtil.toJsonPretty(res));
      }

      return res;
   }

   // 강좌관리
   @RequestMapping(value = "/admin/courseMgr")
   public String courseMgr(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      long classCode = HttpUtil.get(request, "classCode", (long) 0);

      List<Course> courseList = null;
      List<Course> noCourseList = null;

      courseList = adminService.getCourseListSelect(classCode, "Y");
      noCourseList = adminService.getCourseListSelect(classCode, "N");

      model.addAttribute("courseList", courseList);
      model.addAttribute("noCourseList", noCourseList);
      model.addAttribute("classCode", classCode);

      return "/admin/courseMgr";
   }

   // 강좌삭제
   @RequestMapping(value = "/admin/courseDel", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> getcourseDel(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();
      long courseCode = HttpUtil.get(request, "courseCode", (long) 0);

      if (courseCode != 0) {
         if (adminService.getcourseDel(courseCode) > 0) {
            ajaxResponse.setResponse(0, "success");
         } else {
            ajaxResponse.setResponse(400, "error");
         }
      } else {
         ajaxResponse.setResponse(404, "not code");
      }

      return ajaxResponse;
   }

   // 강좌신청 승인
   @RequestMapping(value = "/admin/noCourseOk", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noCourseOk(@RequestBody List<String> courseCodeList, HttpServletRequest request) {
      Response<Object> ajaxResponse = new Response<Object>();

      try {
         for (String courseCodeString : courseCodeList) {
        	long courseCode = Long.parseLong(courseCodeString);
            int result = adminService.noCourseOk(courseCode);
            if (result < 1) {
               ajaxResponse.setResponse(300, "error");
               return ajaxResponse;
            }
         }
         ajaxResponse.setResponse(0, "success");
      } catch (Exception e) {
         ajaxResponse.setResponse(500, "no access");
      }

      return ajaxResponse;
   }
   
   

   // 강좌신청 반려
   @RequestMapping(value = "/admin/noCourseNo", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noCourseNo(@RequestBody List<String> courseCodeList, HttpServletRequest request) {
      Response<Object> ajaxResponse = new Response<Object>();

      try {
         for (String courseCodeString : courseCodeList) {
        	long courseCode = Long.parseLong(courseCodeString);
            int result = adminService.noCourseNo(courseCode);
            if (result < 0) {
               ajaxResponse.setResponse(300, "error");
               return ajaxResponse;
            }
         }
         ajaxResponse.setResponse(0, "seccuss");
      } catch (Exception e) {
         ajaxResponse.setResponse(500, "no access");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   교재관리 페이지
   ===================================================*/
   @RequestMapping(value = "/admin/bookMgr")
   public String bookMgr(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      String classCode = HttpUtil.get(request, "classCode", "");
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      long totalCount = 0;
      List<Book> list = null;
      Book book = new Book();
      Paging paging = null;

      logger.debug("cookieUserId :: " + cookieUserId);

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (!StringUtil.isEmpty(classCode)) {
            book.setClassCode(classCode);
         }

         if (!StringUtil.isEmpty(searchValue)) {
            book.setSearchValue(searchValue);
         }

         if (!StringUtil.isEmpty(searchType)) {
            book.setSearchType(searchType);
         }

         totalCount = bookService.adminBookCount(book);
         logger.debug("totalCount :: " + totalCount);

         if (totalCount > 0) {
            paging = new Paging("/admin/bookMgr", totalCount, ORDER_LIST_COUNT, ORDER_PAGE_COUNT, curPage, "curPage");

            book.setStartRow(paging.getStartRow());
            book.setEndRow(paging.getEndRow());

            list = bookService.adminBookList(book);
         }
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

      return "/admin/bookMgr";
   }

   /*===================================================
    *   교재정보 불러오는 ajax
    ===================================================*/
   @RequestMapping(value = "/admin/getBookDetails", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> bookSearch(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String classCode = HttpUtil.get(request, "classCode", "");
      long bookSeq = HttpUtil.get(request, "bookSeq", (long) 0);

      Book book = new Book();

      if (!StringUtil.isEmpty(bookSeq) && bookSeq >= 0 && !StringUtil.isEmpty(classCode)) {
         book = bookService.bookSelect(classCode, bookSeq);
         ajaxResponse.setResponse(0, "", book);
      }

      return ajaxResponse;
   }

   /*===================================================
    *   교재수정 ajax
    ===================================================*/
   @RequestMapping(value = "/admin/bookUpdate", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> bookUpdate(MultipartHttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      long bookSeq = HttpUtil.get(request, "bookSeq", (long) 0);
      String classCode = HttpUtil.get(request, "bookclassCode", "");
      String bookTitle = HttpUtil.get(request, "bookTitle", "");
      String bookInfo = HttpUtil.get(request, "bookInfo", "");
      String bookAuth = HttpUtil.get(request, "bookAuth", "");
      String bookPublisher = HttpUtil.get(request, "bookPublisher", "");
      int bookPrice = HttpUtil.get(request, "bookPrice", 0);
      int bookPayPrice = HttpUtil.get(request, "bookPayPrice", 0);
      String issueDate = HttpUtil.get(request, "issueDate", "");
      int invenQtt = HttpUtil.get(request, "invenQtt", 0);
      String bookStatus = HttpUtil.get(request, "bookStatus", "");
      String bookSeqStr = String.valueOf(bookSeq);

      logger.debug("bookStatus : " + bookStatus);

      FileData fileData = HttpUtil.getFile(request, "bookImg", 1, bookSeqStr, BOOK_SAVE_DIR);

      Book book = new Book();

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (!StringUtil.isEmpty(bookSeq) && !StringUtil.isEmpty(classCode) && !StringUtil.isEmpty(bookTitle) && !StringUtil.isEmpty(bookInfo)
               && !StringUtil.isEmpty(bookAuth) && !StringUtil.isEmpty(bookPublisher) && !StringUtil.isEmpty(bookPrice)
               && !StringUtil.isEmpty(bookPayPrice) && !StringUtil.isEmpty(issueDate) && !StringUtil.isEmpty(invenQtt)
               && !StringUtil.isEmpty(bookStatus)) {
            book.setBookSeq(bookSeq);
            book.setClassCode(classCode);
            book.setBookTitle(bookTitle);
            book.setBookInfo(bookInfo);
            book.setBookAuth(bookAuth);
            book.setBookPublisher(bookPublisher);
            book.setBookPrice(bookPrice);
            book.setBookPayPrice(bookPayPrice);
            book.setIssueDate(issueDate);
            book.setInvenQtt(invenQtt);
            book.setBookStatus(bookStatus);

            int count = bookService.bookUpdate(book);

            if (count > 0) {
               ajaxResponse.setResponse(0, "success");
            } else {
               ajaxResponse.setResponse(100, "update error");
            }
         }
      }

      return ajaxResponse;

   }

   /*===================================================
    *   교재등록 ajax
    ===================================================*/
   @RequestMapping(value = "/admin/bookInsert", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> bookInsert(MultipartHttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      String classCode = HttpUtil.get(request, "bookclassCode1", "");
      String bookTitle = HttpUtil.get(request, "bookTitle1", "");
      String bookInfo = HttpUtil.get(request, "bookInfo1", "");
      String bookAuth = HttpUtil.get(request, "bookAuth1", "");
      String bookPublisher = HttpUtil.get(request, "bookPublisher1", "");
      int bookPrice = HttpUtil.get(request, "bookPrice1", 0);
      int bookPayPrice = HttpUtil.get(request, "bookPayPrice1", 0);
      String issueDate = HttpUtil.get(request, "issueDate1", "");
      int invenQtt = HttpUtil.get(request, "invenQtt1", 0);

      logger.debug("classCode : " + classCode);
      logger.debug("bookTitle : " + bookTitle);
      Book book = new Book();
      FileData fileData = new FileData();

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (!StringUtil.isEmpty(classCode) && !StringUtil.isEmpty(bookTitle) && !StringUtil.isEmpty(bookInfo) && !StringUtil.isEmpty(bookAuth)
               && !StringUtil.isEmpty(bookPublisher) && !StringUtil.isEmpty(bookPrice) && !StringUtil.isEmpty(bookPayPrice)
               && !StringUtil.isEmpty(issueDate) && !StringUtil.isEmpty(invenQtt)) {
            book.setClassCode(classCode);
            book.setBookTitle(bookTitle);
            book.setBookInfo(bookInfo);
            book.setBookAuth(bookAuth);
            book.setBookPublisher(bookPublisher);
            book.setBookPrice(bookPrice);
            book.setBookPayPrice(bookPayPrice);
            book.setIssueDate(issueDate);
            book.setInvenQtt(invenQtt);

            int count = bookService.bookInsert(book);

            if (count > 0) {
               String bookSeqStr = String.valueOf(book.getBookSeq());

               fileData = HttpUtil.getFile(request, "bookImg1", 1, bookSeqStr, BOOK_SAVE_DIR);

               ajaxResponse.setResponse(0, "success");
            } else {
               ajaxResponse.setResponse(100, "update error");
            }
         }
      }

      return ajaxResponse;

   }
   
   /*===================================================
   * 로그아웃
    ===================================================*/
   @RequestMapping(value = "/account/adminLogoutProc")
   public String adminLogoutProc(HttpServletRequest request, HttpServletResponse response) {
      if (CookieUtil.getHexValue(request, AUTH_COOKIE_NAME) != null && CookieUtil.getHexValue(request, AUTH_COOKIE_RATE) != null) {
         CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
         CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_RATE);
      }

      return "redirect:/admin/adminLogin";
   }
   
}
