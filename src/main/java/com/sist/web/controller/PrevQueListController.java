package com.sist.web.controller;

import java.io.File;
import java.util.List;

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
import org.springframework.web.servlet.ModelAndView;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Admin;
import com.sist.web.model.Paging;
import com.sist.web.model.PrevQue;
import com.sist.web.model.PrevQue_Easy_Hard;
import com.sist.web.model.Response;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.AdminService;
import com.sist.web.service.CartService;
import com.sist.web.service.PrevQueListService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("prevQueListController")
public class PrevQueListController {

   private static Logger logger = LoggerFactory.getLogger(PrevQueListController.class);

   @Value("#{env['auth.cookie.name']}")
   private String AUTH_COOKIE_NAME;

   @Value("#{env['exam.save.dir']}")
   private String EXAM_SAVE_DIR;

   @Value("#{env['ans.save.dir']}")
   private String ANS_SAVE_DIR;
   
   @Autowired
   private AdminService adminService;

   // ListCount pageCount 상수 정의
   /*
    * private static final int LIST_COUNT = 10; // 한 페이지의 게시물 수
    */
   private static final int PAGE_COUNT = 10; // 페이징 수

   @Autowired
   private PrevQueListService prevQueListService;

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
    *    기출문제 글쓰기 화면
    ===================================================*/
   @RequestMapping(value = "/dataroom/prevQueWriteForm")
   public String prevQueWriteForm (ModelMap model, HttpServletRequest request, HttpServletResponse response) {
      
      // 조회 항목 (1: 작성자, 2: 제목, 3: 내용)
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long examSeq = HttpUtil.get(request, "examSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      int classCode = HttpUtil.get(request, "classCode", 1);
      int options = HttpUtil.get(request, "options", 1);
      int listCount = HttpUtil.get(request, "listCount", 10);
      
      
      model.addAttribute("examSeq", examSeq);
      model.addAttribute("options", options);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("classCode", classCode);
      model.addAttribute("listCount", listCount);
     model.addAttribute("classCode", classCode);
      
      return "/dataroom/prevQueWriteForm";
   }
   
   /*===================================================
    *    기출문제 글쓰기 동작
    ===================================================*/
   @RequestMapping(value = "/dataroom/prevQueWriteProc")
   @ResponseBody
   public Response<Object> prevQueWriteProc (MultipartHttpServletRequest request, HttpServletResponse response) {
      
      Response<Object> res = new Response<Object>();
      
      // 쿠키값
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      // 과목
      int classCode = HttpUtil.get(request, "category", 0);
      // 제목
      String title = HttpUtil.get(request, "title", "");
      // 문항수
      int qcnt = HttpUtil.get(request, "qcnt", 0);
      
      // 시퀀스 번호
      String examSeq = String.valueOf(prevQueListService.seqSelect());
      // 기출문제
      FileData examFile = HttpUtil.getFile(request, "examFile", EXAM_SAVE_DIR, examSeq);
      // 답안
      FileData ansFile = HttpUtil.getFile(request, "ansFile", ANS_SAVE_DIR, examSeq);
      
      logger.debug("=========================================");
      logger.debug("cookieUserId : " + cookieUserId);
      logger.debug("classCode: " + classCode);
      logger.debug("title: " + title);
      logger.debug("qcnt: " + qcnt);
      logger.debug("examSeq: " + examSeq);
      logger.debug("examFile: " + examFile);
      logger.debug("ansFile: " + ansFile);
      logger.debug("=========================================");
      
      
      if (!StringUtil.isEmpty(classCode) && !StringUtil.isEmpty(title) && !StringUtil.isEmpty(qcnt)
            && examFile != null && ansFile != null && !StringUtil.isEmpty(examSeq)) {
         
         if (!StringUtil.isEmpty(cookieUserId)) {
            PrevQue pq = new PrevQue();
            
            pq.setExamSeq(Long.parseLong(examSeq));
            pq.setExamTitle(title);
            pq.setExamQcnt(qcnt);
            pq.setClassCode(classCode);
            pq.setExamTestFileName(examSeq);
            pq.setExamAnsFileName(examSeq);
            
            if (prevQueListService.prevQueInsert(pq) > 0) {
               res.setResponse(0, "성공");
            }
            else {
               res.setResponse(-1, "오류 : SQL 삽입 실패");
            }
            
         }
         else {
            res.setResponse(999, "오류 : 로그인 안 함");
         }
      }
      else {
         res.setResponse(400, "오류 : 파라미터 값 안 넘어옴");
      }
      
      if (logger.isDebugEnabled()) {
         logger.debug("[prevQueController] /prevQueWriteProc response\n" + JsonUtil.toJsonPretty(res));
      }
      
      return res;
      
   }
   
   /*===================================================
    *    기출문제 삭제 동작
    ===================================================*/
   @RequestMapping(value = "/dataroom/prevQueDelete")
   @ResponseBody
   public Response<Object> prevQueDelete (HttpServletRequest request, HttpServletResponse response) {
      Response<Object> res = new Response<Object>();
      
      long examSeq = HttpUtil.get(request, "examSeq", 0);
      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      
      if (examSeq > 0) {
         
         if (!StringUtil.isEmpty(cookieUserId)) {
            PrevQue pq = prevQueListService.prevQueSelect(examSeq);
            
            if (pq != null) {
               
               // 기출문제 && 답안 파일 삭제
               if (prevQueListService.prevQueDelete(examSeq) > 0) {
                  res.setResponse(0, "성공!");
               }
               else {
                  res.setResponse(-1, "실패 : SQL 오류");
               }
               
            }
            else {
               res.setResponse(404, "실패 : 게시글 존재하지 않음");
            }
            
         }
         else {
            res.setResponse(999, "실패 : 로그인 미상태");
         }
        
      }
         
      else {
         res.setResponse(400, "실패 : 파라미터 값 안 넘어옴");
      }
      
      
      return res;
   }
   
   
   

   /*===================================================
    *    기출문제 화면
    ===================================================*/
   @RequestMapping(value = "/dataroom/prevQueList")
   public String prevQueList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

      String userId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME); // 쿠키에서 userId 가져오기
      model.addAttribute("userId", userId); // JSP로 전달
      
      // 관리자 체크
      Admin admin = adminService.adminSelect(userId);
      
      if (admin != null) {
         if (StringUtil.equals(admin.getRating(), "A")) {
            model.addAttribute("rating", admin.getRating());
         }
      }

      // 조회 항목 (1: 작성자, 2: 제목, 3: 내용)
      String searchType = HttpUtil.get(request, "searchType", "");
      String searchValue = HttpUtil.get(request, "searchValue", "");
      long examSeq = HttpUtil.get(request, "examSeq", (long) 0);
      long curPage = HttpUtil.get(request, "curPage", (long) 1);
      int classCode = HttpUtil.get(request, "classCode", 1);
      int options = HttpUtil.get(request, "options", 1);
      int listCount = HttpUtil.get(request, "listCount", 10);

      logger.debug("examSeq from request: " + examSeq); // examSeq 값 확인

      long totalCount = 0;
      long easyCnt = 0;
      long hardCnt = 0;
      List<PrevQue> list = null;
      PrevQue search = new PrevQue();
      Paging paging = null;

      if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
         search.setSearchType(searchType);
         search.setSearchValue(searchValue);
      }
      search.setOptions(options);
      search.setClassCode(classCode);

      totalCount = prevQueListService.prevQueListCount(search);

      if (totalCount > 0) {
         paging = new Paging("/dataroom/prevQueList", totalCount, listCount, PAGE_COUNT, curPage, "curPage");
         search.setStartRow(paging.getStartRow());
         search.setEndRow(paging.getEndRow());
         list = prevQueListService.prevQueList(search);

         PrevQue_Easy_Hard prevQue_Easy_Hard = new PrevQue_Easy_Hard();
         // 쉬워요, 어려워요 카운트 가져오기
         for (int i = 0; i < list.size(); i++) {
            logger.debug("" + list.get(i).getExamSeq());

            prevQue_Easy_Hard.setExamSeq(list.get(i).getExamSeq());
            easyCnt = prevQueListService.easyCnt(list.get(i).getExamSeq());
            hardCnt = prevQueListService.hardCnt(list.get(i).getExamSeq());
            list.get(i).setEasyCnt(easyCnt);
            list.get(i).setHardCnt(hardCnt);
         }
      }

      // 모델에 easyCnt와 hardCnt 추가
      model.addAttribute("examSeq", examSeq);
      model.addAttribute("easyCnt", easyCnt);
      model.addAttribute("hardCnt", hardCnt);
      model.addAttribute("list", list);
      model.addAttribute("options", options);
      model.addAttribute("searchType", searchType);
      model.addAttribute("searchValue", searchValue);
      model.addAttribute("curPage", curPage);
      model.addAttribute("paging", paging);
      model.addAttribute("classCode", classCode);
      model.addAttribute("totalCount", totalCount);
      model.addAttribute("listCount", listCount);

      return "/dataroom/prevQueList";
   }

   @RequestMapping(value = "/dataroom/easyHardInsert", method = RequestMethod.POST)
   @ResponseBody
   public Response<Object> easyHardInsert(HttpServletRequest request, HttpServletResponse response) {
      Response<Object> ajaxResponse = new Response<Object>();

      String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
      long examSeq = HttpUtil.get(request, "examSeq", 0L);
      String status = HttpUtil.get(request, "status", "");

      logger.debug("쿠키에서 가져온 userId: " + cookieUserId);

      if (!StringUtil.isEmpty(cookieUserId)) {
         User user = accountService.userSelect(cookieUserId);
         logger.debug("userSelect 결과: " + user);

         if (user != null && examSeq > 0) {
            PrevQue prevQue = prevQueListService.prevQueSelect(examSeq);
            if (prevQue != null) {
               PrevQue_Easy_Hard prevQue_Easy_Hard = new PrevQue_Easy_Hard();
               prevQue_Easy_Hard.setExamSeq(examSeq);
               prevQue_Easy_Hard.setUserId(cookieUserId);
               prevQue_Easy_Hard.setStatus(status);

               List<PrevQue_Easy_Hard> list = prevQueListService.easyHardSelect(prevQue_Easy_Hard);

               if (list == null || list.isEmpty()) {
                   if (prevQueListService.easyHardInsert(prevQue_Easy_Hard) > 0) {
                       long count;
                       if ("E".equals(status)) {
                           count = prevQueListService.easyCnt(examSeq);
                       } else {
                           count = prevQueListService.hardCnt(examSeq);
                       }
                       ajaxResponse.setResponse(0, "success", count);
                   } else {
                       ajaxResponse.setResponse(-99, "error(2)");
                   }
               } else {
                   // 이미 상태가 있는 경우
                   PrevQue_Easy_Hard existingRecord = list.get(0); // 사용자의 기존 기록
                   if (existingRecord.getStatus().equals(status)) {
                       // 같은 상태를 다시 선택한 경우 삭제
                       prevQueListService.easyHardDelete(prevQue_Easy_Hard);
                       long count;
                       if ("E".equals(status)) {
                           count = prevQueListService.easyCnt(examSeq);
                       } else {
                           count = prevQueListService.hardCnt(examSeq);
                       }
                       ajaxResponse.setResponse(-1, "success", count);
                   } else {
                       // 다른 상태를 선택한 경우 에러 응답
                       ajaxResponse.setResponse(-3, "You cannot vote for both '쉬워요' and '어려워요'.");
                   }
               }

            }
         } else {
            ajaxResponse.setResponse(-2, "invalid examSeq or user");
         }
      } else {
         ajaxResponse.setResponse(400, "user not authenticated");
      }

      return ajaxResponse;
   }

   /////////////////////////////////////// 기출문제
   /////////////////////////////////////// 다운로드////////////////////////////////////////////////////////

   // 기출문제 다운
   @RequestMapping(value = "/dataroom/examdownload", method = RequestMethod.GET)
   public ModelAndView examdownload(HttpServletRequest request, HttpServletResponse response) {
      ModelAndView modelAndView = null;

      // examSeq 파라미터를 받음
      long examSeq = HttpUtil.get(request, "examSeq", (long) 0);

      // fileType 파라미터를 받아서 pdf 파일을 처리하도록
      String fileType = HttpUtil.get(request, "fileType", "exam");
      if (examSeq > 0) {
         PrevQue prevQue = prevQueListService.prevQueSelect(examSeq);

         if (prevQue != null) {
            String fileName = prevQue.getExamTestFileName();
            logger.debug("File name found: " + fileName);

            // fileType에 맞춰 확장자 추가
            if ("pdf".equals(fileType)) {
               fileName += ".pdf";
            }

            // 실제 파일 경로를 `webapp/resources/file/exam/`로 수정
            /*
             * String path = request.getServletContext().getRealPath(EXAM_SAVE_DIR +
             * FileUtil.getFileSeparator() + fileName); logger.debug("File path: " + path);
             * // 실제 경로 로그 출력
             */
            File file = new File(EXAM_SAVE_DIR + FileUtil.getFileSeparator() + fileName);

            if (file.exists() && file.isFile()) {
               logger.debug("File exists, proceeding with download.");
               modelAndView = new ModelAndView();
               modelAndView.setViewName("fileDownloadView");
               modelAndView.addObject("file", file);
               modelAndView.addObject("fileName", prevQue.getExamTitle() + " 문제.pdf");
            }
         }
      }

      return modelAndView;
   }

   // 답안지 다운
   @RequestMapping(value = "/dataroom/ansdownload", method = RequestMethod.GET)
   public ModelAndView ansdownload(HttpServletRequest request, HttpServletResponse response) {
      ModelAndView modelAndView = null;

      // examSeq 파라미터를 받음
      long examSeq = HttpUtil.get(request, "examSeq", (long) 0);

      // fileType 파라미터를 받아서 pdf 파일을 처리하도록
      String fileType = HttpUtil.get(request, "fileType", "exam");
      if (examSeq > 0) {
         PrevQue prevQue = prevQueListService.prevQueSelect(examSeq);

         if (prevQue != null) {
            String fileName = prevQue.getExamAnsFileName();
            logger.debug("File name found: " + fileName);

            // fileType에 맞춰 확장자 추가
            if ("png".equals(fileType)) {
               fileName += ".png";
            }

            // 실제 파일 경로를 `webapp/resources/file/exam/`로 수정
            /*
             * String path = request.getServletContext().getRealPath(EXAM_SAVE_DIR +
             * FileUtil.getFileSeparator() + fileName); logger.debug("File path: " + path);
             * // 실제 경로 로그 출력
             */
            File file = new File(ANS_SAVE_DIR + FileUtil.getFileSeparator() + fileName);

            if (file.exists() && file.isFile()) {
               logger.debug("File exists, proceeding with download.");
               modelAndView = new ModelAndView();
               modelAndView.setViewName("fileDownloadView");
               modelAndView.addObject("file", file);
               modelAndView.addObject("fileName", prevQue.getExamTitle() + " 답안.png");
            }
         }
      }

      return modelAndView;
   }

}
