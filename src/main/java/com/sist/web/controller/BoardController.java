package com.sist.web.controller;

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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Admin;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardLike;
import com.sist.web.model.BoardMark;
import com.sist.web.model.BoardNotice;
import com.sist.web.model.BoardNoticeFile;
import com.sist.web.model.BoardQna;
import com.sist.web.model.BoardQnaFile;
import com.sist.web.model.Comment;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.AdminService;
import com.sist.web.service.BoardService;
import com.sist.web.service.CartService;
import com.sist.web.service.CommentService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("boardController")
public class BoardController {

   private static Logger logger = LoggerFactory.getLogger(BoardController.class);

   @Value("#{env['auth.cookie.name']}")
   private String AUTH_COOKIE_NAME;

   @Value("#{env['auth.cookie.rate']}")
   private String AUTH_COOKIE_RATE;

   @Value("#{env['upload.save.dir']}")
   private String UPLOAD_SAVE_DIR;

   // ListCount pageCount 상수정의
   private static final int LIST_COUNT = 7; // 한 페이지의 게시물 수
   private static final int PAGE_COUNT = 10; // 페이징 수

   private static final int QNA_LIST_COUNT = 10; // 한 페이지의 게시물 수
   private static final int QNA_PAGE_COUNT = 10; // 페이징 수

   @Autowired
   private BoardService boardService;

   @Autowired
   private AccountService accountService;

   @Autowired
   private AdminService adminService;

   @Autowired
   private CommentService commentService;

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
    *   선생님 화면
    ===================================================*/
   @RequestMapping(value = "/board/teachList", method = RequestMethod.GET)
   public String teachList(HttpServletRequest request, HttpServletResponse response) {
      return "/board/teachList";
   }

   /*===================================================
    *   공지사항 화면
    ===================================================*/
   @RequestMapping(value = "/board/noticeList")
   public String noticeList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      // 조회 항목(1:작성자, 2.제목, 3:내용)
      String searchType = HttpUtil.get(request, "searchType", "");
      // 조회값
      String searchValue = HttpUtil.get(request, "searchValue", "");
      // 현재 페이지
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      // 총 게시물 수
      long totalCount = 0;
      // 게시물 리스트
      List<BoardNotice> list = null; // 값이 없을 때는 아무것도 안 보여주어야 하니까 null로 설정

      // ismust가 "Y"인 공지사항 리스트
      List<BoardNotice> mustList = null;

      Admin admin = adminService.AdminSelect(cookieUserId);

      // 조회 객체
      BoardNotice search = new BoardNotice();
      // 페이징 객체
      Paging paging = null; // List와 동일하게 totalCount가 0 이상일 때 보여줘야 하니까

      if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
         search.setSearchType(searchType);
         search.setSearchValue(searchValue);
      }

      totalCount = boardService.noticeBoardListCount(search);

      logger.debug("================================");
      logger.debug("totalCount : " + totalCount);
      logger.debug("================================");

      if (totalCount > 0) {
         paging = new Paging("/board/noticeList", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());

         list = boardService.noticeBoardList(search);
      }

      // 필수 공지사항 (ismust가 "Y"인 공지사항만 필터링)
      mustList = boardService.noticeBoardListByIsMust(search, "Y");

      // 모델에 데이터 추가
      model.addAttribute("list", list);
      model.addAttribute("mustList", mustList); // 필수 공지사항 리스트 추가
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("paging", paging);
      model.addAttribute("admin", admin);

      return "/board/noticeList";
   }

   /*===================================================
    *   공지사항 상세 화면
    ===================================================*/
   @RequestMapping(value = "/board/noticeView")
   public String noticeView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      // 쿠키값
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      // 게시물 번호
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      // 조회 항목 (1:작성자, 2:제목, 3:내용)
      String searchType = HttpUtil.get(request, "searchType", "");
      // 조회값
      String searchValue = HttpUtil.get(request, "searchValue");
      // 현재 페이지
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      // 본인글 여부
      String boardMe = "N";

      Admin admin = null;

      if (!StringUtil.isEmpty(cookieUserId)) {
         admin = adminService.AdminSelect(cookieUserId);
      }

      logger.debug("===============================");
      logger.debug("brdSeq : " + brdSeq);
      logger.debug("===============================");

      BoardNotice boardNotice = null;
      BoardNotice prevPost = null;
      BoardNotice nextPost = null;

      if (brdSeq > 0) {
         // 게시글 조회 (noticeBoardView 메소드에서 게시물, 이전글, 다음글 정보를 반환)
         Map<String, Object> result = boardService.noticeBoardView(brdSeq);

         // 결과에서 각 게시물 정보 추출
         boardNotice = (BoardNotice) result.get("boardNotice");
         prevPost = (BoardNotice) result.get("prevNotice");
         nextPost = (BoardNotice) result.get("nextNotice");

         // 본인글일시 수정/삭제버튼 보이게
         if (boardNotice != null && StringUtil.equals(cookieUserId, boardNotice.getUserId())) {
            boardMe = "Y";
         }
      }

      logger.debug("===============================");
      logger.debug("brdSeq : " + brdSeq);
      logger.debug("boardNotice : " + boardNotice);
      if (boardNotice != null) {
         logger.debug("BRD_TITLE: " + boardNotice.getBrdTitle());
         logger.debug("BRD_CONTENT: " + boardNotice.getBrdContent());
      }
      logger.debug("===============================");

      // 모델에 필요한 데이터 추가
      model.addAttribute("boardMe", boardMe);
      model.addAttribute("brdSeq", brdSeq);
      model.addAttribute("boardNotice", boardNotice);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("prevPost", prevPost); // 이전글
      model.addAttribute("nextPost", nextPost); // 다음글
      model.addAttribute("admin", admin); // 다음글

      return "/board/noticeView";
   }

   /*===================================================
    *   공지사항 글쓰기 화면
    ===================================================*/
   @RequestMapping(value = "/board/noticeWrite")
   public String noticeWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");

      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      Admin amdin = adminService.AdminSelect(cookieUserId);

      model.addAttribute("user", amdin);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);

      return "/board/noticeWrite";
   }

   /*===================================================
    * 공지사항 게시물 등록(aJax통신) 
    ==================================================== */
   @RequestMapping(value = "/board/noticewriteProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noticewriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      // 쿠키값
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String brdTitle = HttpUtil.get(request, "brdTitle", "");
      String brdContent = HttpUtil.get(request, "contentHtml", "");
      String isMust = HttpUtil.get(request, "isMust", "");
      FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);

      logger.debug("========== Received Parameters ==========");
      logger.debug("brdTitle: " + brdTitle);
      logger.debug("brdContent: " + brdContent);
      logger.debug("isMust: " + isMust);
      logger.debug("fileData: " + fileData);
      logger.debug("=========================================");

      if (!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent) && !StringUtil.isEmpty(isMust)) {

         BoardNotice boardNotice = new BoardNotice();

         boardNotice.setUserId(cookieUserId);
         boardNotice.setBrdTitle(brdTitle);
         boardNotice.setBrdContent(brdContent);
         boardNotice.setIsMust(isMust);

         if (fileData != null && fileData.getFileSize() > 0) {
            BoardNoticeFile boardNoticeFile = new BoardNoticeFile();

            boardNoticeFile.setFileName(fileData.getFileName());
            boardNoticeFile.setFileOrgName(fileData.getFileOrgName());
            boardNoticeFile.setFileExt(fileData.getFileExt());
            boardNoticeFile.setFileSize(fileData.getFileSize());

            boardNotice.setBoardNoticeFile(boardNoticeFile);

         }

         try {

            if (boardService.noticeBoardInsert(boardNotice) > 0) {

               ajaxResponse.setResponse(0, "success");

            } else {
               ajaxResponse.setResponse(500, "internal server error");
            }

         } catch (Exception e) {
            logger.error("[BoardController] noticewriteProc Exception", e);
            ajaxResponse.setResponse(500, "internal server error(2)");
         }

      } else {
         ajaxResponse.setResponse(400, "bad request");
      }

      return ajaxResponse;

   }

   /*===================================================
    *   공지사항 게시글 수정 화면
    ===================================================*/
   @RequestMapping(value = "/board/noticeUpdate")
   public String noticeUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      // 게시물 번호
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      // 조회항목
      String searchType = HttpUtil.get(request, "searchType", "");
      // 조회값
      String searchValue = HttpUtil.get(request, "searchValue", "");
      // 현재페이지
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      BoardNotice boardNotice = null;

      if (brdSeq > 0) {

         boardNotice = boardService.noticeBoardViewUpdate(brdSeq);

         /*
          * if(boardNotice != null){
          * 
          * if(!StringUtil.equals(boardNotice.getUserId(), cookieUserId)){ //내글이 아닌 경우 수정
          * 불가능하도록 처리 boardNotice = null; } }
          */
      }

      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("boardNotice", boardNotice);

      return "/board/noticeUpdate";
   }

   /*===================================================
    *   공지사항 게시글 수정
    ===================================================*/
   @RequestMapping(value = "/board/noticeUpdateProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noticeUpdateProc(MultipartHttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      String brdTitle = HttpUtil.get(request, "brdTitle", "");
      String brdContent = HttpUtil.get(request, "contentHtml", "");
      String isMust = HttpUtil.get(request, "isMust", "");
      FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);

      logger.debug("brdSeq: " + brdSeq);
      logger.debug("brdTitle: " + brdTitle);
      logger.debug("brdContent: " + brdContent);
      logger.debug("isMust: " + isMust);

      if (brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
         BoardNotice boardNotice = boardService.noticeBoardSelect(brdSeq);

         if (boardNotice != null) {
            boardNotice.setBrdTitle(brdTitle);
            boardNotice.setBrdContent(brdContent);
            boardNotice.setIsMust(isMust);

            if (fileData != null && fileData.getFileSize() > 0) {
               BoardNoticeFile boardNoticeFile = new BoardNoticeFile();

               boardNoticeFile.setFileName(fileData.getFileName());
               boardNoticeFile.setFileOrgName(fileData.getFileOrgName());
               boardNoticeFile.setFileExt(fileData.getFileExt());
               boardNoticeFile.setFileSize(fileData.getFileSize());

               boardNotice.setBoardNoticeFile(boardNoticeFile);

            }

            try {
               if (boardService.noticeBoardUpdate(boardNotice) > 0) {
                  ajaxResponse.setResponse(0, "success");
               } else {
                  ajaxResponse.setResponse(500, "internal server error2");
               }
            } catch (Exception e) {
               logger.error("[HiBoardController] updateProc Exception", e);
               ajaxResponse.setResponse(500, "internal server error");
            }

         } else {
            ajaxResponse.setResponse(404, "not found");
         }
      } else {
         ajaxResponse.setResponse(400, "bad request");
      }

      return ajaxResponse;
   }

   /*===================================================
    *   공지사항 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/board/noticeDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> noticeDelete(HttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);

      logger.debug("brdSeq: " + brdSeq);

      if (brdSeq > 0) {

         BoardNotice boardNotice = boardService.noticeBoardSelect(brdSeq);

         logger.debug("boardNotice: " + boardNotice);

         if (boardNotice != null) {

            try {

               if (boardService.noticeBoardDelete(brdSeq) > 0) {
                  logger.debug("게시물 삭제 성공: brdSeq=" + brdSeq);
                  ajaxResponse.setResponse(0, "success");

               } else {
                  logger.debug("게시물 삭제 실패: brdSeq=" + brdSeq);
                  ajaxResponse.setResponse(500, "server error(2)");
               }

            } catch (Exception e) {

               logger.error("[BoardController] noticeDelete Exception", e);
               ajaxResponse.setResponse(500, "server error(1)");

            }

         } else {
            ajaxResponse.setResponse(403, "server error");
         }

      } else {
         ajaxResponse.setResponse(404, "not found");
      }

      return ajaxResponse;

   }

   /*===================================================
    *   문의사항 화면
    ===================================================*/
   @RequestMapping(value = "/board/qnaList")
   public String qnaList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      long totalCount = 0;
      User user = accountService.userSelect(cookieUserId);
      Admin admin = adminService.adminSelect(cookieUserId);
      List<BoardQna> list = null;
      BoardQna search = new BoardQna();
      Paging paging = null;

      if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {

         search.setSearchType(searchType);
         search.setSearchValue(searchValue);
      }

      totalCount = boardService.qnaBoardListCount(search);

      logger.debug("================================");
      logger.debug("totalCount : " + totalCount);
      logger.debug("================================");

      if (totalCount > 0) {
         paging = new Paging("/board/qnaList", totalCount, QNA_LIST_COUNT, QNA_PAGE_COUNT, curPage, "curPage");

         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());

         list = boardService.qnaBoardList(search);

         // 각 게시글의 답변 상태
         for (BoardQna qna : list) {
            boolean hasReply = boardService.hasReplies(qna.getBrdSeq());
            qna.setHasReply(hasReply);
         }
      }

      model.addAttribute("list", list);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("paging", paging);
      model.addAttribute("user", user);
      model.addAttribute("admin", admin);

      return "/board/qnaList";
   }

   /*===================================================
    *   문의사항 게시글(상세) 화면
    ===================================================*/
   @RequestMapping(value = "/board/qnaView")
   public String qnaView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
      String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      if (StringUtil.equals(cookieRating, "U")) {
         User user = accountService.userSelect(cookieUserId);
         model.addAttribute("user", user);
      } else if (StringUtil.equals(cookieRating, "T")) {
         Teacher user = accountService.teacherSelect(cookieUserId);
         model.addAttribute("user", user);
      } else if (StringUtil.equals(cookieRating, "A")) {
         Admin user = adminService.adminSelect(cookieUserId);
         model.addAttribute("user", user);
      }

      String boardMe = "N";

      logger.debug("===============================");
      logger.debug("brdSeq : " + brdSeq);
      logger.debug("===============================");

      // 게시글 데이터
      BoardQna mainPost = null;

      // 답글 데이터
      BoardQna replyPost = null;

      if (brdSeq > 0) {

         // 게시글 데이터 조회
         mainPost = boardService.qnaBoardView(brdSeq);

         // 답글 데이터 조회 (부모가 현재 brdSeq인 경우)
         replyPost = boardService.qnaBoardReplyView(brdSeq);

         if (mainPost != null && StringUtil.equals(cookieUserId, mainPost.getUserId())) {
            boardMe = "Y";
         }
      }

      model.addAttribute("brdSeq", brdSeq);
      model.addAttribute("boardMe", boardMe);
      model.addAttribute("mainPost", mainPost); // 게시글 데이터
      model.addAttribute("replyPost", replyPost); // 답글 데이터
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);

      return "/board/qnaView";
   }

   /*===================================================
    *   문의사항 글쓰기 화면
    ===================================================*/
   @RequestMapping(value = "/board/qnaWrite")
   public String qnaWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");

      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      User user = accountService.userSelect(cookieUserId);

      model.addAttribute("user", user);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);

      return "/board/qnaWrite";
   }

   /*===================================================
    * 문의사항 게시물 등록(aJax통신) 
    ==================================================== */
   @RequestMapping(value = "/board/qnawriteProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnawriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      // 쿠키값
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String brdTitle = HttpUtil.get(request, "brdTitle", "");
      String brdContent = HttpUtil.get(request, "contentHtml", "");
      FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);
      String brdPwd = HttpUtil.get(request, "brdPwd");

      logger.debug("========== Received Parameters ==========");
      logger.debug("brdTitle: " + brdTitle);
      logger.debug("brdContent: " + brdContent);
      logger.debug("fileData: " + fileData);
      logger.debug("=========================================");

      if (!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {

         BoardQna boardQna = new BoardQna();

         boardQna.setUserId(cookieUserId);
         boardQna.setBrdTitle(brdTitle);
         boardQna.setBrdContent(brdContent);
         boardQna.setBrdPwd(brdPwd);

         if (fileData != null && fileData.getFileSize() > 0) {
            BoardQnaFile boardQnaFile = new BoardQnaFile();

            boardQnaFile.setFileName(fileData.getFileName());
            boardQnaFile.setFileOrgName(fileData.getFileOrgName());
            boardQnaFile.setFileExt(fileData.getFileExt());
            boardQnaFile.setFileSize(fileData.getFileSize());

            boardQna.setBoardQnaFile(boardQnaFile);

         }

         try {

            if (boardService.qnaBoardInsert(boardQna) > 0) {

               ajaxResponse.setResponse(0, "success");

            } else {
               ajaxResponse.setResponse(500, "internal server error");
            }

         } catch (Exception e) {
            logger.error("[BoardController] qnawriteProc Exception", e);
            ajaxResponse.setResponse(500, "internal server error(2)");
         }

      } else {
         ajaxResponse.setResponse(400, "bad request");
      }

      return ajaxResponse;

   }

   /*===================================================
    *   문의사항 게시글 수정 화면
    ===================================================*/
   @RequestMapping(value = "/board/qnaUpdate")
   public String qnaUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      String brdPwd = HttpUtil.get(request, "brdPwd", "");

      BoardQna boardQna = null;

      if (brdSeq > 0) {

         boardQna = boardService.qnaBoardViewUpdate(brdSeq);

         if (boardQna != null) {
            if (!StringUtil.equals(cookieUserId, boardQna.getUserId())) {
               boardQna = null;
            }
         }
      }

      model.addAttribute("brdPwd", brdPwd);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("boardQna", boardQna);
      model.addAttribute("curPage", curPage);

      return "/board/qnaUpdate";
   }

   /*===================================================
    *   문의사항 게시글 수정
    ===================================================*/
   @RequestMapping(value = "/board/qnaUpdateProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnaUpdateProc(MultipartHttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      String brdTitle = HttpUtil.get(request, "brdTitle", "");
      String brdContent = HttpUtil.get(request, "contentHtml", "");
      String brdPwd = HttpUtil.get(request, "brdPwd", "");
      FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);

      logger.debug("brdSeq: " + brdSeq);
      logger.debug("brdTitle: " + brdTitle);
      logger.debug("brdContent: " + brdContent);
      logger.debug("brdPwd: " + brdPwd);

      if (brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
         BoardQna boardQna = boardService.qnaBoardSelect(brdSeq);

         if (boardQna != null) {

            if (StringUtil.equals(cookieUserId, boardQna.getUserId())) {
               boardQna.setBrdTitle(brdTitle);
               boardQna.setBrdContent(brdContent);
               boardQna.setBrdPwd(brdPwd);

               if (fileData != null && fileData.getFileSize() > 0) {
                  BoardQnaFile boardqnaFile = new BoardQnaFile();

                  boardqnaFile.setFileName(fileData.getFileName());
                  boardqnaFile.setFileOrgName(fileData.getFileOrgName());
                  boardqnaFile.setFileExt(fileData.getFileExt());
                  boardqnaFile.setFileSize(fileData.getFileSize());

                  boardQna.setBoardQnaFile(boardqnaFile);

               }

               try {
                  if (boardService.qnaBoardUpdate(boardQna) > 0) {
                     ajaxResponse.setResponse(0, "success");
                  } else {
                     ajaxResponse.setResponse(500, "internal server error2");
                  }
               } catch (Exception e) {
                  logger.error("[BoardController] qnaUpdateProc Exception", e);
                  ajaxResponse.setResponse(500, "internal server error");
               }

            } else {
               ajaxResponse.setResponse(403, "server error");
            }

         } else {
            ajaxResponse.setResponse(404, "not found");
         }
      } else {
         ajaxResponse.setResponse(400, "bad request");
      }

      return ajaxResponse;
   }

   /*===================================================
    *   문의사항 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/board/qnaDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnaDelete(HttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);

      logger.debug("brdSeq: " + brdSeq);

      if (brdSeq > 0) {

         BoardQna boardQna = boardService.qnaBoardSelect(brdSeq);

         logger.debug("boardQna: " + boardQna);

         if (boardQna != null) {

            /* User user = accountService.userSelect(cookieUserId); */

            if (StringUtil.equals(cookieUserId, boardQna.getUserId())) {

               try {

                  if (boardService.qnaBoardDelete(brdSeq) > 0) {
                     logger.debug("게시물 삭제 성공: brdSeq=" + brdSeq);
                     ajaxResponse.setResponse(0, "success");

                  } else {
                     logger.debug("게시물 삭제 실패: brdSeq=" + brdSeq);
                     ajaxResponse.setResponse(500, "server error(2)");
                  }

               } catch (Exception e) {

                  logger.error("[BoardController] qnaDelete Exception", e);
                  ajaxResponse.setResponse(500, "server error(1)");

               }
            } else {
               ajaxResponse.setResponse(403, "server error");
            }

         } else {
            ajaxResponse.setResponse(403, "server error");
         }

      } else {
         ajaxResponse.setResponse(404, "not found");
      }

      return ajaxResponse;

   }

   /*===================================================
    *   문의사항 답글쓰기 화면
    ===================================================*/
   @RequestMapping(value = "/board/qnaCommWrite")
   public String qnaCommWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      BoardQna boardQna = null;

      if (brdSeq > 0) {

         boardQna = boardService.qnaBoardViewComm(brdSeq);
      }

      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("boardQna", boardQna);
      model.addAttribute("curPage", curPage);

      return "/board/qnaCommWrite";
   }

   /*===================================================
    * 문의사항 답글 등록(aJax통신) 
    ==================================================== */
   @RequestMapping(value = "/board/qnaCommWriteProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnaCommWriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      // 쿠키에서 사용자 ID 가져오기
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      // 요청 파라미터 받기
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0); // 부모 게시글의 BRD_SEQ
      String brdTitle = HttpUtil.get(request, "brdTitle", "");
      String brdContent = HttpUtil.get(request, "brdContent", "");
      FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);

      logger.debug("========== Received Parameters ==========");
      logger.debug("brdSeq (Parent): " + brdSeq);
      logger.debug("brdTitle: " + brdTitle);
      logger.debug("brdContent: " + brdContent);
      logger.debug("fileData: " + fileData);
      logger.debug("=========================================");

      if (!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
         BoardQna boardQna = new BoardQna();
         // 사용자 ID 및 기본 정보 설정
         boardQna.setUserId(cookieUserId);
         boardQna.setBrdTitle(brdTitle);
         boardQna.setBrdContent(brdContent);

         // 부모 게시글의 BRD_SEQ를 BRD_PARENT로 설정
         boardQna.setBrdParent(brdSeq);

         // 파일 처리
         if (fileData != null && fileData.getFileSize() > 0) {
            BoardQnaFile boardQnaFile = new BoardQnaFile();
            boardQnaFile.setFileName(fileData.getFileName());
            boardQnaFile.setFileOrgName(fileData.getFileOrgName());
            boardQnaFile.setFileExt(fileData.getFileExt());
            boardQnaFile.setFileSize(fileData.getFileSize());
            boardQna.setBoardQnaFile(boardQnaFile);
         }

         try {
            // 서비스 호출
            if (boardService.qnaBoardCommInsert(boardQna) > 0) {
               ajaxResponse.setResponse(0, "success");
            } else {
               ajaxResponse.setResponse(500, "internal server error");
            }
         } catch (Exception e) {
            logger.error("[BoardController] qnaCommWriteProc Exception", e);
            ajaxResponse.setResponse(500, "internal server error(2)");
         }
      } else {
         ajaxResponse.setResponse(400, "bad request");
      }

      return ajaxResponse;
   }

   /*===================================================
    *   문의사항 답변 수정 화면
    ===================================================*/
   @RequestMapping(value = "/board/qnaCommUpdate")
   public String qnaCommUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      String brdPwd = HttpUtil.get(request, "brdPwd", "");

      BoardQna boardQna = null;
      BoardQna boardQnaReply = null;

      if (brdSeq > 0) {

//         boardQna = boardService.qnaBoardViewUpdate(brdSeq);

         boardQnaReply = boardService.qnaBoardCommViewUpdate(brdSeq);

         boardQna = boardService.qnaBoardSelect(boardQnaReply.getBrdParent());

      }

      model.addAttribute("brdPwd", brdPwd);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("boardQna", boardQna);
      model.addAttribute("boardQnaReply", boardQnaReply);
      model.addAttribute("curPage", curPage);

      return "/board/qnaCommUpdate";
   }

   /*===================================================
    *   문의사항 답변 수정
    ===================================================*/
   @RequestMapping(value = "/board/qnaCommUpdateProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> qnaCommUpdateProc(MultipartHttpServletRequest request, HttpServletResponse response) {

      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      String brdTitle = HttpUtil.get(request, "brdTitle", "");
      String brdContent = HttpUtil.get(request, "brdContent", "");
      String brdPwd = HttpUtil.get(request, "brdPwd", "");
      FileData fileData = HttpUtil.getFile(request, "brdFile", UPLOAD_SAVE_DIR);

      logger.debug("brdSeq: " + brdSeq);
      logger.debug("brdTitle: " + brdTitle);
      logger.debug("brdContent: " + brdContent);
      logger.debug("brdPwd: " + brdPwd);

      if (brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
         BoardQna boardQna = boardService.qnaBoardSelect(brdSeq);

         if (boardQna != null) {
        	 
        	 Admin admin = adminService.adminSelect(cookieUserId);

            if (StringUtil.equals(cookieUserId, admin.getUserId())) {
               boardQna.setBrdTitle(brdTitle);
               boardQna.setBrdContent(brdContent);
               boardQna.setBrdPwd(brdPwd);

               if (fileData != null && fileData.getFileSize() > 0) {
                  BoardQnaFile boardqnaFile = new BoardQnaFile();

                  boardqnaFile.setFileName(fileData.getFileName());
                  boardqnaFile.setFileOrgName(fileData.getFileOrgName());
                  boardqnaFile.setFileExt(fileData.getFileExt());
                  boardqnaFile.setFileSize(fileData.getFileSize());

                  boardQna.setBoardQnaFile(boardqnaFile);

               }

               try {
                  if (boardService.qnaBoardUpdate(boardQna) > 0) {
                     ajaxResponse.setResponse(0, "success");
                  } else {
                     ajaxResponse.setResponse(500, "internal server error2");
                  }
               } catch (Exception e) {
                  logger.error("[BoardController] qnaUpdateProc Exception", e);
                  ajaxResponse.setResponse(500, "internal server error");
               }

            } else {
               ajaxResponse.setResponse(403, "server error");
            }

         } else {
            ajaxResponse.setResponse(404, "not found");
         }
      } else {
         ajaxResponse.setResponse(400, "bad request");
      }

      return ajaxResponse;
   }

   /*===================================================
   *   자유게시판 화면
   ===================================================*/
   @RequestMapping(value = "/board/freeList")
   public String freeList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      int category = HttpUtil.get(request, "category", (int) 0);
      int listCount = HttpUtil.get(request, "listCount", (int) 10);
      int options = HttpUtil.get(request, "options", (int) 1);
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      logger.debug(options + "=======");
      // 총 게시물 수
      long totalCount = 0;
      // 게시물 리스트
      List<Board> list = null;
      // 조회 객체
      Board search = new Board();
      // 페이징 객체
      Paging paging = null;
      // 댓글 수
      long commCount = 0;

      search.setOptions(options);

      if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
         search.setSearchType(searchType);
         search.setSearchValue(searchValue);
      }

      if (category > 0) {
         search.setCategory(category);
      }

      totalCount = boardService.freeBoardListCount(search);

      if (totalCount > 0) {
         paging = new Paging("/board/freeList", totalCount, listCount, PAGE_COUNT, curPage, "curPage");

         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());

         list = boardService.freeBoardList(search);
        

         for (int i = 0; i < list.size(); i++) {
            BoardFile boardFile = boardService.freeBoardFileSelect(list.get(i).getBrdSeq());
            int boardLikeCount = boardService.freeSelectLikeCount(list.get(i).getBrdSeq());
            list.get(i).setUserProfile(accountService.userOrTeacher(list.get(i).getUserId()).getUserProfile());

            list.get(i).setBoardCommCount(commentService.commentCount(list.get(i).getBrdSeq()));
            list.get(i).setBoardFile(boardFile);
            list.get(i).setBoardLikeCount(boardLikeCount);
         }
      }

      model.addAttribute("list", list);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("paging", paging);
      model.addAttribute("category", category);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("listCount", listCount);
      model.addAttribute("options", options);
      model.addAttribute("cookieUserId", cookieUserId);

      return "/board/freeList";
   }

   /*===================================================
    *   자유게시판 게시글 화면
    ===================================================*/
   @RequestMapping(value = "/board/freeView")
   public String freeView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      int options = HttpUtil.get(request, "options", (int) 1);

      String boardMe = "N";

      Board board = null;
      Board searchcount = new Board();
      long totalCount = 0;

      int boardLikeCount = boardService.freeSelectLikeCount(brdSeq);
      int commentCount = commentService.commentCount(brdSeq);

      BoardMark boardMark = boardService.freeSelectMark(brdSeq, cookieUserId);
      BoardLike boardLike = boardService.freeSelectLike(brdSeq, cookieUserId);
      int boardMarkStatus = 0;
      int boardLikeStatus = 0;

      if (boardMark != null) {
         boardMarkStatus = 1;
      }
      if (boardLike != null) {
         boardLikeStatus = 1;
      }

      if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
         searchcount.setSearchType(searchType);
         searchcount.setSearchValue(searchValue);
      }

      totalCount = boardService.freeBoardListCount(searchcount);

      if (brdSeq > 0) {
         board = boardService.freeBoardView(brdSeq);

         if (board != null && StringUtil.equals(board.getUserId(), cookieUserId)) {
            boardMe = "Y";
         }
      }

      Board search = new Board();
      search.setBrdSeq(brdSeq);
      search.setOptions(options);

      List<Board> list = boardService.freeBoardList(search);
      List<Comment> comment = commentService.commentSelect(brdSeq);
      System.out.println("댓글 목록: " + comment);

      // 대댓글
      for (Comment com : comment) {
         Long comSeq = com.getComSeq();
         List<Comment> replies = commentService.comcommentSelect(comSeq);
         System.out.println("대댓글 목록 for commentSeq " + comSeq + ": " + replies);
         com.setReplies(replies);
         com.setReplyCount(replies.size());
      }

      for (int i = 0; i < list.size(); i++) {
         BoardFile boardFile = boardService.freeBoardFileSelect(list.get(i).getBrdSeq());
         list.get(i).setBoardFile(boardFile);
      }

      model.addAttribute("brdSeq", brdSeq);
      model.addAttribute("board", board);
      model.addAttribute("boardMe", boardMe);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("boardLikeCount", boardLikeCount);
      model.addAttribute("list", list);
      model.addAttribute("comment", comment);
      model.addAttribute("cookieUserId", cookieUserId);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("commentCount", commentCount);
      model.addAttribute("options", options);
      model.addAttribute("boardMarkStatus", boardMarkStatus);
      model.addAttribute("boardLikeStatus", boardLikeStatus);

      return "/board/freeView";
   }

   /*===================================================
    *   자유게시판 글쓰기 화면
    ===================================================*/
   @RequestMapping(value = "/board/freeWrite")
   public String freeWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String searchType = HttpUtil.get(request, "searchType");
      String searchValue = HttpUtil.get(request, "searchValue");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      User user = accountService.userSelect(cookieUserId);
      Teacher teacher = accountService.teacherSelect(cookieUserId);

      model.addAttribute("user", user);
      model.addAttribute("teacher", teacher);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);

      return "/board/freeWrite";
   }

   // 게시물 등록(ajax통신)
   @RequestMapping(value = "/board/freeWriteProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeWriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      String brdTitle = HttpUtil.get(request, "title", "");
      String brdContent = HttpUtil.get(request, "contentHtml", "");
      int category = HttpUtil.get(request, "category", (int) 0);
      FileData fileData = HttpUtil.getFile(request, "file", UPLOAD_SAVE_DIR);

      if (cookieUserId == null || cookieUserId == "") {
         ajaxResponse.setResponse(999, "login plz");
      } else {
         if (!StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
            Board Board = new Board();

            Board.setUserId(cookieUserId);
            Board.setBrdTitle(brdTitle);
            Board.setBrdContent(brdContent);
            Board.setCategory(category);
            if (fileData != null && fileData.getFileSize() > 0) {
               BoardFile BoardFile = new BoardFile();
               BoardFile.setFileName(fileData.getFileName());
               BoardFile.setFileOrgName(fileData.getFileOrgName());
               BoardFile.setFileExt(fileData.getFileExt());
               BoardFile.setFileSize(fileData.getFileSize());

               Board.setBoardFile(BoardFile);
            }

            try {
               if (boardService.freeBoardInsert(Board) > 0) {
                  ajaxResponse.setResponse(0, "success");
               } else {
                  ajaxResponse.setResponse(500, "internal server error");
               }
            } catch (Exception e) {
               logger.error("[BoardController] freeWriteProc Exception", e);
               ajaxResponse.setResponse(500, "internal server error2");
            }
         } else {
            ajaxResponse.setResponse(400, "bad request");
         }
      }

      return ajaxResponse;
   }

   /*===================================================
    *   자유게시판 게시글 수정
    ===================================================*/
   @RequestMapping(value = "/board/freeUpdate")
   public String freeUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long curPage = HttpUtil.get(request, "curPage", (long) 1);

      Board board = null;

      if (brdSeq > 0) {
         board = boardService.freeBoardViewUpdate(brdSeq);

         if (board != null) {
            if (!StringUtil.equals(board.getUserId(), cookieUserId)) {
               board = null;
            }
         }
      }

      model.addAttribute("searchType", searchType);
      model.addAttribute("brdSeq", brdSeq);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("Board", board);

      return "/board/freeUpdate";
   }

   // 게시물 수정(ajax통신)
   @RequestMapping(value = "/board/freeUpdateProc", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeUpdateProc(MultipartHttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      String brdTitle = HttpUtil.get(request, "title", "");
      String brdContent = HttpUtil.get(request, "contentHtml", "");
      FileData fileData = HttpUtil.getFile(request, "file", UPLOAD_SAVE_DIR);

      if (cookieUserId == null || cookieUserId == "") {
         ajaxResponse.setResponse(999, "login plz");
      } else {
         if (brdSeq > 0 && !StringUtil.isEmpty(brdTitle) && !StringUtil.isEmpty(brdContent)) {
            Board board = boardService.freeBoardSelect(brdSeq);

            if (board != null) {
               if (StringUtil.equals(board.getUserId(), cookieUserId)) {
                  board.setBrdTitle(brdTitle);
                  board.setBrdContent(brdContent);
                  board.setBrdSeq(brdSeq);

                  if (fileData != null && fileData.getFileSize() > 0) {
                     BoardFile boardFile = new BoardFile();

                     boardFile.setFileName(fileData.getFileName());
                     boardFile.setFileOrgName(fileData.getFileOrgName());
                     boardFile.setFileExt(fileData.getFileExt());
                     boardFile.setFileSize(fileData.getFileSize());

                     board.setBoardFile(boardFile);
                  }

                  try {
                     if (boardService.freeBoardUpdate(board) > 0) {
                        ajaxResponse.setResponse(0, "success");
                     } else {
                        ajaxResponse.setResponse(500, "internal server error2");
                     }
                  } catch (Exception e) {
                     logger.error("[BoardController] freeUpdateProc Exception", e);
                     ajaxResponse.setResponse(500, "internal server error");
                  }
               } else {
                  ajaxResponse.setResponse(403, "server error");
               }
            } else {
               ajaxResponse.setResponse(404, "not found");
            }
         } else {
            ajaxResponse.setResponse(400, "bad request");
         }
      }

      return ajaxResponse;
   }

   /*===================================================
    *   자유게시판 좋아요 구독 알림설정까지..
    ===================================================*/
   @RequestMapping(value = "/board/freeLike", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeLike(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      BoardLike boardLike = new BoardLike();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      logger.info("brdSeq: {}", brdSeq);

      if (cookieUserId == null || cookieUserId == "") {
         ajaxResponse.setResponse(999, "login plz");
      } else {
         if (brdSeq > 0) {
            try {
               boardLike = boardService.freeSelectLike(brdSeq, cookieUserId);

               if (boardLike != null) {
                  boardService.freeDeleteLike(brdSeq, cookieUserId);
                  int boardLikeCount = boardService.freeSelectLikeCount(brdSeq);
                  ajaxResponse.setResponse(201, "succes(-)", boardLikeCount);

               } else {
                  boardService.freeInsertLike(brdSeq, cookieUserId);
                  int boardLikeCount = boardService.freeSelectLikeCount(brdSeq);
                  ajaxResponse.setResponse(200, "succes(+)", boardLikeCount);
               }
            } catch (Exception e) {
               logger.error("[BoardController] freeLike Exception", e);
            }
         } else {
            ajaxResponse.setResponse(500, "bad request");
         }
      }

      return ajaxResponse;
   }

   /*===================================================
    *   자유게시판 게시글 삭제
    ===================================================*/
   @RequestMapping(value = "/board/freeDelete", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeDelete(HttpServletRequest request, HttpServletResponse response) {
      logger.debug("=-=-=-=-=-=-");
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);

      if (cookieUserId == null || cookieUserId == "") {
         ajaxResponse.setResponse(999, "login plz");
      } else {
         if (brdSeq > 0) {
            Board board = boardService.freeBoardSelect(brdSeq);

            if (board != null) {
               if (StringUtil.equals(cookieUserId, board.getUserId())) {
                  try {
                     if (boardService.freeBoardDelete(brdSeq) > 0) {
                        ajaxResponse.setResponse(0, "success");
                     } else {
                        ajaxResponse.setResponse(500, "service error2");
                     }
                  } catch (Exception e) {
                     logger.error("[BoardController] freeDelete Exception", e);
                     ajaxResponse.setResponse(500, "service error1");
                  }
               } else {
                  // 내 글이 아닐때
                  ajaxResponse.setResponse(403, "service error");
               }
            } else {
               ajaxResponse.setResponse(404, "not found");
            }
         } else {
            ajaxResponse.setResponse(400, "bad request");
         }
      }

      return ajaxResponse;
   }

   /*===================================================
    *   자유게시판 북마크
    ===================================================*/
   @RequestMapping(value = "/board/freeBookMark", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> freeBookMark(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      BoardMark boardMark = new BoardMark();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

      long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
      logger.info("brdSeq: {}", brdSeq);

      if (cookieUserId == null || cookieUserId == "") {
         ajaxResponse.setResponse(999, "login plz");
      } else {
         if (brdSeq > 0) {
            try {
               boardMark = boardService.freeSelectMark(brdSeq, cookieUserId);

               if (boardMark != null) {
                  boardService.freeDeleteMark(brdSeq, cookieUserId);
                  ajaxResponse.setResponse(201, "succes(-)");

               } else {
                  boardService.freeInsertMark(brdSeq, cookieUserId);
                  ajaxResponse.setResponse(200, "succes(+)");
               }
            } catch (Exception e) {
               logger.error("[BoardController] freeBookMark Exception", e);
            }
         } else {
            ajaxResponse.setResponse(500, "bad request");
         }
      }

      return ajaxResponse;
   }

   /*===================================================
    *   FAQ 화면
    ===================================================*/
   @RequestMapping(value = "/board/faqList", method = RequestMethod.GET)
   public String faqList(HttpServletRequest request, HttpServletResponse response) {
      return "/board/faqList";
   }
}
