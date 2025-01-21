package com.sist.web.controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.BoardQna;
import com.sist.web.model.Course;
import com.sist.web.model.CourseList;
import com.sist.web.model.Board;
import com.sist.web.model.Note;

import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.BoardService;
import com.sist.web.service.CartService;
import com.sist.web.service.CourseListService;
import com.sist.web.service.CourseService;
import com.sist.web.service.NoteService;
import com.sist.web.service.OrderService;
import com.sist.web.service.TeachService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("userController")
public class UserController {

   private static Logger logger = LoggerFactory.getLogger(IndexController.class);

   @Value("#{env['auth.cookie.name']}")
   private String AUTH_COOKIE_NAME;

   @Value("#{env['auth.cookie.rate']}")
   private String AUTH_COOKIE_RATE;

   @Value("#{env['profile.save.dir']}")
   private String PROFILE_SAVE_DIR;

   private static final int LIST_COUNT = 5; // 한페이지의 게시물 수
   private static final int PAGE_COUNT = 5; // 페이징 수

   @Autowired
   private AccountService accountService;

   @Autowired
   private BoardService boardService;

   @Autowired
   private NoteService noteService;

   @Autowired
   private CartService cartService;

   @Autowired
   private OrderService orderService;

   @Autowired
   private TeachService teachService;

   @Autowired
   private CourseService courseService;

   @Autowired
   private CourseListService courseListService;

   // 과목코드 별 과목명
   public String className(int classCode) {
      if (classCode == 1)
         return "국어";
      else if (classCode == 2)
         return "영어";
      else if (classCode == 3)
         return "수학";
      else if (classCode == 4)
         return "사회";
      else if (classCode == 5)
         return "과학";
      else
         return "그외";
   }

   // 유저 정보
   @ModelAttribute("user")
   public Account getUser(HttpServletRequest request, HttpServletResponse response) {
      Account user;

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      if (StringUtil.equals(rating, "U")) {
         user = accountService.userSelect(cookieUserId);
      } else if (StringUtil.equals(rating, "T")) {
         user = accountService.teacherSelect(cookieUserId);
      } else {
         user = null;
      }
      return user;
   }
   
   // 미결제건 수
   @ModelAttribute("noPayCnt")
   public int noPayCnt (HttpServletRequest request, HttpServletResponse response) {
	   int noPayCnt = 0;
	   
	   String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
	   
	   if (!StringUtil.isEmpty(cookieUserId)) {
		   noPayCnt = orderService.noPayCount(cookieUserId);
	   }
	   
	   logger.debug("noPayCnt : " + noPayCnt);
	   
	   return noPayCnt;
   }

   // 쪽지 수
   @ModelAttribute("noteCnt")
   public int getNoteCnt(HttpServletRequest request, HttpServletResponse response) {
      int noteCnt = 0;

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      if (!StringUtil.isEmpty(cookieUserId)) {
         noteCnt = noteService.noreadCount(cookieUserId);
      }

      logger.debug("noteCnt : " + noteCnt);

      return noteCnt;

   }

   // 장바구니 수
   @ModelAttribute("cartCount")
   public int cartCount(HttpServletRequest request, HttpServletResponse response) {
      int cartCount = 0;
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      cartCount = cartService.cartCount(cookieUserId);

      return cartCount;
   }

   // QnA 수
   @ModelAttribute("qnaCount")
   public long qnaCount(HttpServletRequest request, HttpServletResponse response) {
      long qnaTeachCount = 0;
      long qnaAdminCount = 0;
      long qnaCount = 0;
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      CourseList courseList = new CourseList();

      courseList.setUserId(cookieUserId);

      qnaTeachCount = courseListService.courseQnAMyBrdListCount(courseList);
      qnaAdminCount = boardService.qnaMyPageListCount(cookieUserId);

      qnaCount = qnaTeachCount + qnaAdminCount;

      return qnaCount;
   }

   /*===================================================
   *   마이페이지 메인 화면
   ===================================================*/
   @RequestMapping(value = "/user/mypage")
   public String mypage(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      // 사용자 아이디
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      // 사용자 등급
      String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
      // 코스 번호
      int classCode = HttpUtil.get(request, "classCode", 1);
      // 수강 중인 코스 수
      int myCourseIngCnt = 0;
      // 수강 완료 코스 수
      int myCourseFinCnt = 0;
      // 나의 코스 수
      int myCourseCnt = 0;
      // 나의 강의 수
      int myLectureCnt = 0;
      // 최신 코스 리스트
      List<Course> listRecent = null;
      // course 리스트 객체
      List<Course> course = null;
      // course 검색 객체
      Course search = new Course();
      // 쿠키값이 존재하는 사용자인지 확인
      Account account = null;
      //선생 강의코드
      String teacherClassCode = "";
	  // 선생님 최신 코스 리스트
	  List<Course> teacherListRecent = new ArrayList<>();
      
      if (StringUtil.equals(cookieRating, "T")) {
         listRecent = teachService.teacherRecentCourseListSelect(cookieUserId);
         
         for(int i=0; i<3; i++)
         {
        	 Course course1 = listRecent.get(i);
        	 
        	 teacherListRecent.add(course1);
        	 
        	 if(teacherListRecent.size() == 3)
        	 {
        		break; 
        	 }
         }
         
         model.addAttribute("teacherListRecent", teacherListRecent);
         
         Teacher teacher = accountService.teacherSelect(cookieUserId);
         teacherClassCode = teacher.getClassCode();
      }
         
      if (StringUtil.equals(cookieRating, "U")) {
         account = accountService.userSelect(cookieUserId);

         if (account != null) {
            // 수강 완료 강좌 수
            myCourseFinCnt = courseService.myCourseFinSelect(cookieUserId);
            // 수강 중인 강좌 수
            myCourseIngCnt = courseService.myCourseAllSelect(cookieUserId) - myCourseFinCnt;
            // 최근 수강 강좌 목록
            search.setCourseStatus("recent");
            search.setUserId(cookieUserId);
            search.setClassCode(classCode);
            search.setStartRow(1);
            search.setEndRow(3);

            course = courseService.mypageCourseListSelect(search);

            for (int i = 0; i < course.size(); i++) {
               if (course.get(i).getLecCnt() != 0 || course.get(i).getFinLecCnt() != 0) {
                  double progress = Math.round(((double)course.get(i).getFinLecCnt() / course.get(i).getLecCnt()) * 10000.0) / 100.0;
                  course.get(i).setProgress(progress);
               }
            }
         }
      } else if (StringUtil.equals(cookieRating, "T")) {
         account = accountService.teacherSelect(cookieUserId);

         if (account != null) {
            myCourseCnt = teachService.teacherCourseCnt(account.getUserId());
            myLectureCnt = courseService.teachLectureCnt(account.getUserId());
         }
      } else {
         account = null;
      }

      model.addAttribute("account", account);
      model.addAttribute("classCode", classCode);
      model.addAttribute("className", className(classCode));
      model.addAttribute("myCourseIngCnt", myCourseIngCnt);
      model.addAttribute("myCourseFinCnt", myCourseFinCnt);
      model.addAttribute("myCourseCnt", myCourseCnt);
      model.addAttribute("myLectureCnt", myLectureCnt);
      model.addAttribute("course", course);
      model.addAttribute("listRecent", listRecent);
      model.addAttribute("teacherClassCode", teacherClassCode);

      return "/user/mypage";
   }

   /*===================================================
   *   쪽지 리스트 화면
   ===================================================*/
   @RequestMapping(value = "/user/noteList")
   public String noteList(Model model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      String type = HttpUtil.get(request, "type", "sent");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      long totalCount = 0;
      List<Note> list = null;
      Note note = new Note();
      Paging paging = null;

      logger.debug("cookieUserId: " + cookieUserId);
      logger.debug("type: " + type);

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (StringUtil.equals(type, "sent")) {
            totalCount = noteService.sendListCount(cookieUserId);

            if (totalCount > 0) {
               paging = new Paging("/user/noteList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

               note.setStartRow(paging.getStartRow());
               note.setEndRow(paging.getEndRow());
               note.setUserId(cookieUserId);

               list = noteService.noteSendList(note);
            }
         } else if (StringUtil.equals(type, "get")) {
            totalCount = noteService.getListCount(cookieUserId);

            if (totalCount > 0) {
               paging = new Paging("/user/noteList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

               note.setStartRow(paging.getStartRow());
               note.setEndRow(paging.getEndRow());
               note.setUserIdGet(cookieUserId);

               list = noteService.noteGetList(note);
            }
         }
      }

      model.addAttribute("list", list);
      model.addAttribute("note", note);
      model.addAttribute("paging", paging);
      model.addAttribute("curPage", curPage);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("type", type);
      return "/user/noteList";
   }

   /*===================================================
   *   쪽지 상세보기 화면
   ===================================================*/
   @RequestMapping(value = "/user/noteView")
   public String noteView(Model model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      String type = HttpUtil.get(request, "type", "sent");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      long noteSeq = HttpUtil.get(request, "noteSeq", (long) 0);

      logger.debug("type : " + type);

      Note note = new Note();

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (!StringUtil.isEmpty(type) && !StringUtil.isEmpty(noteSeq) && noteSeq > 0) {
            note = noteService.noteSelect(noteSeq);
            noteService.readChange(note);
         }
      }

      logger.debug("type" + type);
      logger.debug("note.userIdGet" + note.getUserIdGet());

      model.addAttribute("note", note);
      model.addAttribute("type", type);
      model.addAttribute("curPage", curPage);

      return "/user/noteView";
   }

   /*===================================================
   *   쪽지 작성 화면
   ===================================================*/
   @RequestMapping(value = "/user/noteWrite", method = RequestMethod.GET)
   public String noteWrite(HttpServletRequest request, HttpServletResponse response) {
      return "/user/noteWrite";
   }

   @RequestMapping(value = "/user/noteUserSearch", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noteUserSearch(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String userName = HttpUtil.get(request, "userName");
      List<User> list = accountService.userNameSearch(userName);
      res.setResponse(0, "success", list);

      return res;
   }

   /*===================================================
   *   쪽지 삭제(쪽지 상세화면에서)
   ===================================================*/
   @RequestMapping(value = "/user/noteDel", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noteDel(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      long noteSeq = HttpUtil.get(request, "noteSeq", (long) 0);

      Note note = new Note();

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (noteSeq > 0) {
            note = noteService.noteSelect(noteSeq);
            if (note != null) {
               if (noteService.noteDelete(noteSeq) > 0) {
                  ajaxResponse.setResponse(0, "success");
               } else {
                  ajaxResponse.setResponse(-110, "update error");
               }
            } else {
               ajaxResponse.setResponse(-10, "note null");
            }
         } else {
            ajaxResponse.setResponse(401, "parameter erroor");
         }
      } else {
         ajaxResponse.setResponse(100, "no access");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   쪽지 삭제(쪽지 리스트 화면에서)
   ===================================================*/
   @RequestMapping(value = "/user/noteListDel", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noteListDel(@RequestBody List<Long> noteSeqList, HttpServletRequest request) {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");

      boolean allDeleted = true; // 모든 삭제가 성공했는지 여부를 추적
      StringBuilder failedNoteSeq = new StringBuilder(); // 실패한 noteSeq를 기록

      if (!StringUtil.isEmpty(cookieUserId)) {
         for (Long noteSeq : noteSeqList) {
            int result = noteService.noteDelete(noteSeq);

            if (result == 0) {
               allDeleted = false; // 하나라도 실패하면 false로 설정
               failedNoteSeq.append(noteSeq).append(", "); // 실패한 noteSeq를 기록
            }
         }

         if (allDeleted) {
            ajaxResponse.setResponse(0, "모든 쪽지가 삭제되었습니다.");
         } else {
            // 실패한 noteSeq 정보 포함
            ajaxResponse.setResponse(-100, "일부 쪽지 삭제 실패: " + failedNoteSeq.toString());
         }
      } else {
         ajaxResponse.setResponse(-400, "no access");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   쪽지 전송 ajax
   ===================================================*/
   @RequestMapping(value = "/user/noteWriteProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noteWriteProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
      String noteContent = HttpUtil.get(request, "noteContent", "");
      String userIdGet = HttpUtil.get(request, "userIdGet", "");
      String userRatingGet = HttpUtil.get(request, "userRatingGet", "");
      Note note = new Note();

      logger.debug("noteContent :" + noteContent);
      logger.debug("userIdGet :" + userIdGet);
      logger.debug("cookieUserId :" + cookieUserId);
      if(StringUtil.equals(cookieUserId, userIdGet)) {
         ajaxResponse.setResponse(-1, "쪽지는 자신에게 보낼 수 없습니다.");
         return ajaxResponse;
      }
      if (!StringUtil.isEmpty(cookieUserId)) {
         Account user = null;

         if (StringUtil.equals(cookieRating, "U")) {
            user = accountService.userSelect(cookieUserId);
         } else if (StringUtil.equals(cookieRating, "T")) {
            user = accountService.teacherSelect(cookieUserId);
         } else {
            user = null;
         }

         if (user != null && StringUtil.equals(user.getStatus(), "Y")) {
            if (!StringUtil.isEmpty(noteContent) && !StringUtil.isEmpty(userIdGet)) {

               Account userSearch = null;

               if (StringUtil.equals(userRatingGet, "U")) {
                  userSearch = accountService.userSelect(userIdGet);
               } else if (StringUtil.equals(userRatingGet, "T")) {
                  userSearch = accountService.teacherSelect(userIdGet);
               } else {
                  ajaxResponse.setResponse(-400, "수신 아이디를 다시 확인하세요");
               }
               
               if (userSearch != null) {
                  if(!StringUtil.equals(userSearch.getStatus(), "D")) {
                     note.setUserId(cookieUserId);
                     note.setUserName(user.getUserName());
                     note.setRating(cookieRating);
                     note.setUserIdGet(userIdGet);
                     note.setUserNameGet(userSearch.getUserName());
                     note.setRatingGet(userSearch.getRating());
                     note.setNoteContent(noteContent);
   
                     logger.debug("cookieUserId :" + cookieUserId);
                     logger.debug("user.getUserName() :" + user.getUserName());
                     logger.debug("cookieRating :" + cookieRating);
                     logger.debug("userIdGet :" + userIdGet);
                     logger.debug("userSearch.getUserName() :" + userSearch.getUserName());
                     logger.debug("userSearch.getRating():" + userSearch.getRating());
   
                     if (noteService.noteInsert(note) > 0) {
                        ajaxResponse.setResponse(0, "쪽지가 성공적으로 전송되었습니다.");
                     } else {
                        ajaxResponse.setResponse(20, "쪽지전송 중 문제 발생했습니다.");
                     }
                  }
                  else {
                     ajaxResponse.setResponse(400, "탈퇴한 계정입니다.");
                  }
               } else {
                  ajaxResponse.setResponse(-400, "수신 아이디를 다시 확인하세요");
               }
            } else {
               ajaxResponse.setResponse(401, "파라미터 값 오류");
            }
         } else {
            ajaxResponse.setResponse(-100, "사용자 오류");
         }
      } else {
         ajaxResponse.setResponse(-101, "로그인을 먼저 진행하세요");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   나의 Q&A 화면
   ===================================================*/
   @RequestMapping(value = "/user/qnaList")
   public String qnaList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      String type = HttpUtil.get(request, "type", "teacher");
      // 내가 쓴 글 보기 확인
      String myBrdChk = HttpUtil.get(request, "myBrdChk", "N");
      // 코스 번호
      int courseCode = HttpUtil.get(request, "courseCode", 0);

      long totalCount1 = 0;
      long totalCount2 = 0;

      Account account = null;
      List<CourseList> list1 = null;
      List<BoardQna> list2 = null;
      CourseList search1 = new CourseList();
      BoardQna search2 = new BoardQna();
      Paging paging = null;

      if (!StringUtil.isEmpty(cookieUserId)) {
         if (StringUtil.equals(cookieRating, "U")) {
            account = accountService.userSelect(cookieUserId);
         } else if (StringUtil.equals(cookieRating, "T")) {
            account = accountService.teacherSelect(cookieUserId);
         } else {
            account = null;
         }

         if (account != null) {
            if (StringUtil.equals(type, "teacher")) {

               search1.setUserId(cookieUserId);
               totalCount1 = courseListService.courseQnAMyBrdListCount(search1);

               if (totalCount1 > 0) {
                  paging = new Paging("/user/qnaList", totalCount1, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

                  search1.setCourseCode(courseCode);
                  search1.setStartRow(paging.getStartRow());
                  search1.setEndRow(paging.getEndRow());

                  list1 = courseListService.courseMyPageQnaList(search1);

                  // 각 게시글의 답변 상태
                  for (CourseList qna : list1) {
                     boolean hasReply = courseListService.hasReplies(qna.getBrdSeq());
                     qna.setHasReply(hasReply);
                  }
               }

            } else if (StringUtil.equals(type, "student")) {
               search2.setUserId(cookieUserId);
               totalCount2 = boardService.qnaMyPageListCount(cookieUserId);

               if (totalCount2 > 0) {
                  paging = new Paging("/board/qnaList", totalCount2, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

                  search2.setStartRow(paging.getStartRow());
                  search2.setEndRow(paging.getEndRow());

                  list2 = boardService.myPageQnaList(search2);

                  // 각 게시글의 답변 상태
                  for (BoardQna qna : list2) {
                     boolean hasReply = boardService.hasReplies(qna.getBrdSeq());
                     qna.setHasReply(hasReply);
                  }
               }
            }
         }
      }

      logger.debug("================================");
      logger.debug("totalCount1 : " + totalCount1);
      logger.debug("totalCount2 : " + totalCount2);
      logger.debug("cookieUserId: " + cookieUserId);
      logger.debug("search1: " + search1);
      logger.debug("search2: " + search2);
      logger.debug("list1: " + list1);
      logger.debug("list2: " + list2);
      logger.debug("type: " + type);
      logger.debug("search1 courseCode: " + courseCode);
      logger.debug("search1 userId: " + search1.getUserId());
      logger.debug("================================");

      model.addAttribute("myBrdChk", myBrdChk);
      model.addAttribute("list1", list1);
      model.addAttribute("list2", list2);
      model.addAttribute("totalCount1", totalCount1);
      model.addAttribute("totalCount2", totalCount2);
      model.addAttribute("curPage", curPage);
      model.addAttribute("paging", paging);
      model.addAttribute("account", account);
      model.addAttribute("brdSeq", brdSeq);
      model.addAttribute("type", type);
      model.addAttribute("courseCode", courseCode);

      return "/user/qnaList";
   }

   /*===================================================
   *   1:1문의사항 게시글 삭제
   ===================================================*/
   @RequestMapping(value = "/user/qnaDelete", method = RequestMethod.POST)
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

         if (boardQna != null && cookieUserId.equals(boardQna.getUserId())) {
            // 게시글이 존재하고, 작성자가 로그인한 사용자와 동일한 경우에만 삭제
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
   * 강사 QnA 게시글 삭제
   ===================================================*/
   @RequestMapping(value = "/user/courseQnADelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> courseQnADelete(@RequestBody List<Long> brdSeqList, HttpServletRequest request) throws Exception {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 사용자 ID 추출

      if (cookieUserId == null || cookieUserId.isEmpty()) {
         ajaxResponse.setResponse(-400, "no access");
         return ajaxResponse; // 로그인되지 않은 사용자
      }

      StringBuilder failedBrdSeq = new StringBuilder(); // 삭제 실패한 brdSeq를 기록
      StringBuilder hasRepliesBrdSeq = new StringBuilder(); // 댓글이 있는 brdSeq를 기록

      for (Long brdSeq : brdSeqList) {
         CourseList courseQnA = courseListService.courseQnASelect(brdSeq); // 게시글 조회

         if (courseQnA != null && cookieUserId.equals(courseQnA.getUserId())) {
            // 댓글이 있는지 확인
            int commentCount = courseListService.myPageQnACommentSelect(brdSeq);

            if (commentCount > 0) {
               hasRepliesBrdSeq.append(brdSeq).append(", ");
               continue; // 댓글이 있는 경우 삭제하지 않음
            }

            // 게시글 삭제
            int result = courseListService.courseQnADelete(brdSeq); // 삭제 실행
            if (result == 0) {
               failedBrdSeq.append(brdSeq).append(", ");
            }
         } else {
            failedBrdSeq.append(brdSeq).append(", ");
         }
      }

      if (hasRepliesBrdSeq.length() > 0) {
         ajaxResponse.setResponse(-101, "The following posts have comments and cannot be deleted: " + hasRepliesBrdSeq.toString());
      } else if (failedBrdSeq.length() > 0) {
         ajaxResponse.setResponse(-100, "Some posts could not be deleted: " + failedBrdSeq.toString());
      } else {
         ajaxResponse.setResponse(0, "Posts deleted successfully");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   나의 쿠폰 화면
   ===================================================*/
   @RequestMapping(value = "/user/coupon", method = RequestMethod.GET)
   public String coupon(HttpServletRequest request, HttpServletResponse response) {
      return "/user/coupon";
   }

//   /*===================================================
//    *   장바구니 화면
//    ===================================================*/
//   @RequestMapping(value = "/user/basket", method = RequestMethod.GET)
//   public String basket(HttpServletRequest request, HttpServletResponse response) {
//      return "/user/basket";
//   }
//
//   /*===================================================
//    *   결제하기 화면
//    ===================================================*/
//   @RequestMapping(value = "/user/payment", method = RequestMethod.GET)
//   public String payment(HttpServletRequest request, HttpServletResponse response) {
//      return "/user/payment";
//   }
//
//   /*===================================================
//    *   결제완료 화면
//    ===================================================*/
//   @RequestMapping(value = "/user/paymentResult", method = RequestMethod.GET)
//   public String paymentResult(HttpServletRequest request, HttpServletResponse response) {
//      return "/user/paymentResult";
//   }

   /*===================================================
   *   수강 중인 강의 화면
   ===================================================*/
   @RequestMapping(value = "/user/studyList")
   public String studyList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      // 사용자 아이디
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      // 사용자 등급
      String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
      // 정렬 종류
      String type = HttpUtil.get(request, "type", "recent");
      // 현재 페이지
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      // course 리스트 객체
      List<Course> course = null;
      // course 검색 객체
      Course search = new Course();
      // paging 객체
      Paging paging = null;
      // 수강 코스 수
      int totalCount = 0;
      // 쿠키값이 존재하는 사용자인지 확인
      Account account = null;

      if (StringUtil.equals(cookieRating, "U")) {
         account = accountService.userSelect(cookieUserId);

         if (account != null) {
            totalCount = courseService.mypageCourseListCntSelect(cookieUserId);

            paging = new Paging("/user/studyList", totalCount, 5, 5, curPage, "curPage");

            // 최근 수강 강좌 목록
            search.setCourseStatus(type);
            search.setUserId(cookieUserId);
            search.setClassCode(0);
            search.setStartRow(paging.getStartRow());
            search.setEndRow(paging.getEndRow());

            course = courseService.mypageCourseListSelect(search);

            for (int i = 0; i < course.size(); i++) {
               course.get(i).setClassName(className(course.get(i).getClassCode()));

               if (course.get(i).getLecCnt() != 0 || course.get(i).getFinLecCnt() != 0) {
                  double progress = Math.round(((double)course.get(i).getFinLecCnt() / course.get(i).getLecCnt()) * 10000.0) / 100.0;
                   course.get(i).setProgress(progress);
               }
            }
         }
      }

      model.addAttribute("type", type);
      model.addAttribute("curPage", curPage);
      model.addAttribute("course", course);
      model.addAttribute("paging", paging);
      model.addAttribute("totalCount", totalCount);

      return "/user/studyList";
   }

   /*===================================================
   *   수강 취소 ajax
   ===================================================*/
   @RequestMapping(value = "/user/cancelCourse", method = RequestMethod.POST)
   @ResponseBody
   @Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
   public Response<Object> cancelCourse(@RequestBody List<Long> courseCodes, HttpServletRequest request) {
      Response<Object> res = new Response<>();

      // 쿠키 아이디
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      // course 객체
      Course course = null;
      // 수강 취소 성공 건수
      int countSuccess = 0;
      // 수강 취소 실패 건수
      int countFail = 0;

      // courseCodes가 비어있는지 확인
      if (StringUtil.isEmpty(courseCodes)) {
         res.setResponse(-400, "선택된 강좌가 없습니다.");
         return res;
      }

      try {
         // 수강 취소 작업 수행
         for (Long courseCode : courseCodes) {
            logger.debug("취소할 강좌 코드: " + courseCode);

            course = new Course();

            course.setUserId(cookieUserId);
            course.setCourseCode(courseCode);

            // 수강신청한 코스 중 수강 강의 존재 여부
            if (courseService.mycourseLectureSelect(course) <= 0) {
               // 삭제 작업 실행 및 실패 체크
               if (courseService.mycourseDelete(course) <= 0) {
                  // 작업 실패 시 강제로 예외를 발생시켜 트랜잭션 롤백
                  throw new RuntimeException("수강 취소 작업 중 오류 발생: 강좌 코드 " + courseCode);
               } else
                  countSuccess++;
            } else
               countFail++;
         }

         if (courseCodes.size() == countFail)
            res.setResponse(-10, "수강 중인 강의가 존재할 시 코스를 삭제할 수 없습니다.");
         else
            res.setResponse(0, "수강취소 성공 건수 : " + countSuccess + " / 수강취소 실패 건수 : " + countFail);
      } catch (Exception e) {
         res.setResponse(-100, "수강 취소 중 오류가 발생하였습니다.");

         throw e;
      }

      return res;
   }

   /*===================================================
   *   내가 작성한 글 화면
   ===================================================*/
   @RequestMapping(value = "/user/writeList")
   public String writeList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      int category = HttpUtil.get(request, "category", (int) 0);

      // 총 게시물 수
      long totalCount = 0;
      // 게시물 리스트
      List<Board> list = null;
      // 조회
      Board search = new Board();
      // 페이징 객체
      Paging paging = null;

      if (cookieUserId != null && cookieUserId != "") {
         search.setUserId(cookieUserId);
      }

      if (category > 0) {
         search.setCategory(category);
      }

      totalCount = accountService.selectboardListCount(search);
      if (totalCount > 0) {
         paging = new Paging("/user/writeList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());

         list = accountService.selectboardList(search);
      }

      model.addAttribute("list", list);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("paging", paging);
      model.addAttribute("category", category);
      model.addAttribute("curPage", curPage);

      return "/user/writeList";
   }

   /*===================================================
   *   내가 작성한 글 삭제
   ===================================================*/
   @RequestMapping(value = "/user/writeListDel", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> writeListDel(@RequestBody List<Long> brdSeqList, HttpServletRequest request) {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");

      boolean allDeleted = true; // 모든 삭제가 성공했는지 여부를 추적
      StringBuilder failedBrdSeq = new StringBuilder();

      if (!StringUtil.isEmpty(cookieUserId)) {
         for (Long brdSeq : brdSeqList) {
            try {
               int result = boardService.freeBoardDelete(brdSeq);

               if (result == 0) {
                  allDeleted = false; // 하나라도 실패하면 false로 설정
                  failedBrdSeq.append(brdSeq).append(", "); // 실패한 noteSeq를 기록
               }
            } catch (Exception e) {
               allDeleted = false;
               failedBrdSeq.append(brdSeq).append(" (삭제 실패), ");
            }
         }

         if (allDeleted) {
            ajaxResponse.setResponse(0, "모든 쪽지가 삭제되었습니다.");
         } else {
            // 실패한 noteSeq 정보 포함
            ajaxResponse.setResponse(-100, "일부 쪽지 삭제 실패: " + failedBrdSeq.toString());
         }
      } else {
         ajaxResponse.setResponse(-400, "no access");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   내가 저장한 글 화면
   ===================================================*/
   @RequestMapping(value = "/user/saveList")
   public String saveList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      int category = HttpUtil.get(request, "category", (int) 0);

      // 총 게시물 수
      long totalCount = 0;
      // 게시물 리스트
      List<Board> list = null;
      // 조회
      Board search = new Board();
      // 페이징 객체
      Paging paging = null;

      if (cookieUserId != null && cookieUserId != "") {
         search.setUserId(cookieUserId);
      }

      if (category > 0) {
         search.setCategory(category);
      }

      totalCount = accountService.bookMarkListCount(search);
      if (totalCount > 0) {
         paging = new Paging("/user/saveList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());

         list = accountService.BookMarkList(search);
      }

      model.addAttribute("list", list);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("paging", paging);
      model.addAttribute("category", category);
      model.addAttribute("curPage", curPage);

      return "/user/saveList";
   }

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

   /*=================
   *   나의 결제내역 화면
   =================*/
   @RequestMapping(value = "/user/paymentHistory")
   public String paymentHistory(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      // 유저 아이디
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      // 주문내역 리스트
      List<Order> ol = null;
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

      // 검색할 객체
      Order search = new Order();
      // 주문내역 총 개수
      int totalCount = 0;
      // 페이징
      Paging paging = null;
      // 현재 페이지
      long curPage = HttpUtil.get(request, "curPage", 1);

      if (cookieUserId != null) {

         search.setUserId(cookieUserId);

         User who = accountService.userOrTeacher(cookieUserId);

         if (StringUtil.equals(who.getRating(), "T")) {
            search.setUserType("T");
         } else {
            search.setUserType("U");
         }

         totalCount = orderService.myOrderListCount(search);

         logger.debug("========================================");
         logger.debug("totalCount : " + totalCount);
         logger.debug("========================================");

         if (totalCount > 0) {
            paging = new Paging("/user/paymentHistory", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

            search.setStartRow(paging.getStartRow());
            search.setEndRow(paging.getEndRow());

            ol = orderService.myOrderList(search);

            model.addAttribute("paging", paging);

            if (ol != null) {

               for (int i = 0; i < ol.size(); i++) {
                  Order order = ol.get(i);
                  di = orderService.deliInfoSelect(order.getOrderSeq());

                  payStatus = payStatus(order.getPayStatus());
                  orderStatus = orderStatus(order.getPayStatus(), order.getOrderStatus());
                  deliStatus = deliStatus(order.getOrderStatus(), di.getDlvStatus());

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

      model.addAttribute("curPage", curPage);

      return "/user/paymentHistory";
   }

   /*===================================================
   *   결제내역 상세보기 화면
   ===================================================*/
   @RequestMapping(value = "/user/paymentHistoryDetail") // , method = RequestMethod.POST)
   public String paymentHistoryDetail(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      long orderSeq = Long.parseLong(HttpUtil.get(request, "orderSeq", ""));

      logger.debug("orderSeq : " + orderSeq);

      Order order = null;
      List<OrderDetail> odl = null;
      DeliveryInfo di = null;

      String payStatus = "";
      String orderStatus = "";
      String deliStatus = "";
      String viewStatus = "";

      if (orderSeq > 0) {

         // 주문, 주문상세, 배송 조회
         order = orderService.orderSelect(orderSeq);
         odl = orderService.orderDetailSelect(orderSeq);
         di = orderService.deliInfoSelect(orderSeq);

         if (order != null && odl != null && di != null) {

            model.addAttribute("deliInfo", di);
            model.addAttribute("order", order);
            model.addAttribute("orderDetailList", odl);

            payStatus = payStatus(order.getPayStatus());
            orderStatus = orderStatus(order.getPayStatus(), order.getOrderStatus());
            deliStatus = deliStatus(order.getOrderStatus(), di.getDlvStatus());

            viewStatus = viewStatusCal(payStatus, orderStatus, deliStatus);

            model.addAttribute("orderSeq", orderSeq);
            model.addAttribute("viewStatus", viewStatus);
         }
      }

      return "/user/paymentHistoryDetail";
   }

   /*===================================================
   *   비밀번호 확인 화면1
   ===================================================*/
   @RequestMapping(value = "/user/pwdCheck1", method = RequestMethod.GET)
   public String pwdCheck1(HttpServletRequest request, HttpServletResponse response) {
      return "/user/pwdCheck1";
   }

   /*===================================================
   *   비밀번호 변경 화면
   ===================================================*/
   @RequestMapping(value = "/user/changePwd", method = RequestMethod.GET)
   public String changePwd(HttpServletRequest request, HttpServletResponse response, ModelMap model) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      Account account;
      logger.debug(rating + "======================================" + cookieUserId);
      if (StringUtil.equals(rating, "U")) {
         account = accountService.userSelect(cookieUserId);
         if (StringUtil.equals(account.getStatus(), "P")) {
            logger.debug("======================================" + account.getStatus());
            accountService.userStatusupdate(cookieUserId, "Y");
         }
      } else if (StringUtil.equals(rating, "T")) {
         account = accountService.teacherSelect(cookieUserId);
         if (StringUtil.equals(account.getStatus(), "P")) {
            logger.debug("======================================" + account.getStatus());
            accountService.teacherStatusupdate(cookieUserId, "Y");
         }
      } else {
         account = null;
      }

      if (StringUtil.isEmpty(account.getModDate())) {
         model.addAttribute("modDate", account.getRegDate());
      } else {
         model.addAttribute("modDate", account.getModDate());
      }
      model.addAttribute("userName", account.getUserName());

      return "/user/changePwd";
   }

   /*===================================================
   * 비밀번호 변경
   ===================================================*/
   @RequestMapping(value = "/user/changePwdProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> pwdChangeProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      String userPwd = HttpUtil.get(request, "userPwd");
      if (!StringUtil.isEmpty(cookieUserId) && !StringUtil.isEmpty(rating)) {
         if (!StringUtil.isEmpty(userPwd)) {
            if (accountService.userSelect(cookieUserId) != null || accountService.teacherSelect(cookieUserId) != null) {
               if (StringUtil.equals(rating, "U")) {
                  if (accountService.userPwdChange(cookieUserId, userPwd) > 0) {
                     accountService.userModDateUpdate(cookieUserId);
                     res.setResponse(0, "userPwdChange success");
                  } else {
                     res.setResponse(500, "internal server error");
                  }
               } else if (StringUtil.equals(rating, "T")) {
                  if (accountService.teacherPwdChange(cookieUserId, userPwd) > 0) {
                     accountService.teacherModDateUpdate(cookieUserId);
                     res.setResponse(0, "teacherPwdChange success");
                  } else {
                     res.setResponse(500, "internal server error");
                  }
               } else {
                  res.setResponse(100, "wrong rating value");
               }
            } else {
               res.setResponse(404, "no User");
            }
         } else {
            res.setResponse(400, "userPwd is empty");
         }
      } else {
         res.setResponse(400, "No login userId");
      }

      return res;
   }

   /*===================================================
   *   비밀번호 확인 화면2
   ===================================================*/
   @RequestMapping(value = "/user/pwdCheck2", method = RequestMethod.GET)
   public String pwdCheck2(HttpServletRequest request, HttpServletResponse response) {
      return "/user/pwdCheck2";
   }

   /*===================================================
   * 비밀번호 확인
   ===================================================*/
   @RequestMapping(value = "/user/pwdCheckProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> pwdCheckProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      String userPwd = HttpUtil.get(request, "userPwd");
      Account user;
      if (!StringUtil.isEmpty(cookieUserId)) {
         if(StringUtil.equals(rating, "U")) {
            user = accountService.userSelect(cookieUserId);
         }
         else if(StringUtil.equals(rating, "T")) {
            user = accountService.teacherSelect(cookieUserId);
         }
         else {
            user = null;
         }
         if (user != null) {
            if (StringUtil.equals(user.getUserPwd(), userPwd)) {
               res.setResponse(0, "success");
            } else {
               res.setResponse(400, "invalid pwd");
            }
         } else {
            res.setResponse(404, "no user");
         }
      } else {
         res.setResponse(100, "no login");
      }

      return res;
   }

   /*===================================================
   *   회원정보 수정 화면
   ===================================================*/
   @RequestMapping(value = "/user/updateForm", method = RequestMethod.GET)
   public String updateForm(HttpServletRequest request, HttpServletResponse response) {
      return "/user/updateForm";
   }

   /*===================================================
   * 회원정보 수정
   ===================================================*/
   @RequestMapping(value = "/user/updateProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> updateProc(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      String userEmail = HttpUtil.get(request, "userEmail");
      String userName = HttpUtil.get(request, "userName");
      String userPhone = HttpUtil.get(request, "userPhone");
      String addrCode = HttpUtil.get(request, "addrCode", "");
      String addrBase = HttpUtil.get(request, "addrBase", "");
      String addrDetail = HttpUtil.get(request, "addrDetail", "");
      Account user;
      if (!StringUtil.isEmpty(cookieUserId)) {
         
         if(StringUtil.equals(rating, "U")) {
            user = accountService.userSelect(cookieUserId);
         }
         else if(StringUtil.equals(rating, "T")) {
            user = accountService.teacherSelect(cookieUserId);
         }
         else {
            user = null;
         }

         if (user != null && StringUtil.equals(user.getStatus(), "Y")) {
            if (!StringUtil.isEmpty(userName) && !StringUtil.isEmpty(userEmail) && !StringUtil.isEmpty(userPhone)) {
               user.setUserEmail(userEmail);
               user.setUserName(userName);
               user.setUserPhone(userPhone);
               user.setAddrCode(addrCode);
               user.setAddrBase(addrBase);
               user.setAddrDetail(addrDetail);

               if(StringUtil.equals(user.getRating(), "U")) {
                  if (accountService.userInfoUpdate(user) > 0) {
                     res.setResponse(0, "success");
                  } else {
                     res.setResponse(-100, "update error");
                  }
               }
               else if(StringUtil.equals(user.getRating(), "T")) {
                  if (accountService.teacherInfoUpdate(user) > 0) {
                     res.setResponse(0, "success");
                  } else {
                     res.setResponse(-100, "update error");
                  }
               }
               
               
            } else {
               res.setResponse(401, "No parameter");
            }
         } else {
            res.setResponse(400, "No active status");
         }
      } else {
         res.setResponse(100, "No login userId");
      }

      return res;
   }

   /*===================================================
   *   프로필사진 변경
   ===================================================*/
   @RequestMapping(value = "/user/profileUpload", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> profileUpload(MultipartHttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      if (!StringUtil.isEmpty(cookieUserId)) {
         FileData fileData = HttpUtil.getFile(request, "file", 0, cookieUserId, PROFILE_SAVE_DIR);
         if (fileData != null) {
            if (StringUtil.equals(rating, "U")) {
               accountService.userProfileUpdate(cookieUserId, fileData.getFileName());
               res.setResponse(0, "프로필 변경 완료");
            } else if (StringUtil.equals(rating, "T")) {
               accountService.teacherProfileUpdate(cookieUserId, fileData.getFileName());
               res.setResponse(0, "프로필 변경 완료");
            } else {
               res.setResponse(400, "존재하지 않는 사용자 입니다.");
            }
         } else {
            res.setResponse(-1, "프로필 변경중 오류가 발생하였습니다. 관리자에게 문의하세요");
         }
      } else {
         res.setResponse(400, "로그인 후 이용해주세요");
      }

      return res;
   }
   
   /*===================================================
   *   회원탈퇴
   ===================================================*/
   @RequestMapping(value = "/user/withdraw", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> withdraw(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String rating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE);
      if (!StringUtil.isEmpty(cookieUserId)) {
         if(accountService.userOrTeacher(cookieUserId) != null) {
            if (StringUtil.equals(rating, "U")) {
               accountService.userStatusupdate(cookieUserId, "D");
               res.setResponse(0, "회원탈퇴 완료");
               CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
               CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_RATE);
            } else if (StringUtil.equals(rating, "T")) {
               accountService.teacherStatusupdate(cookieUserId, "D");
               res.setResponse(0, "회원탈퇴 완료");
               CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_NAME);
               CookieUtil.deleteCookie(request, response, "/", AUTH_COOKIE_RATE);
            } else {
               res.setResponse(400, "존재하지 않는 사용자 입니다.");
            }
         }
         else {
            res.setResponse(400, "존재하지 않는 사용자 입니다.");
         }
      } else {
         res.setResponse(400, "로그인 후 이용해주세요");
      }

      return res;
   }

}
