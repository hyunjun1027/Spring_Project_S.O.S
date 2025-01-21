package com.sist.web.controller;

import java.io.File;
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
import org.springframework.web.servlet.ModelAndView;

import com.sist.common.model.FileData;
import com.sist.common.util.FileUtil;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Course;
import com.sist.web.model.CourseList;
import com.sist.web.model.CourseListFile;
import com.sist.web.model.Lecture;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.service.AccountService;
import com.sist.web.service.CartService;
import com.sist.web.service.CourseListService;
import com.sist.web.service.CourseService;
import com.sist.web.service.TeachService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;
import com.sist.web.util.JsonUtil;

@Controller("courseListController")
public class CourseListController {

	private static Logger logger = LoggerFactory.getLogger(CourseListController.class);

	// 쿠키 이름 얻어오기
	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	// 파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	// 페이징 상수 정의
	private static final int LIST_COUNT = 10;
	private static final int PAGE_COUNT = 5;

	// 강사 서비스 의존성 주입
	@Autowired
	private TeachService teachService;

	// 회원 서비스 의존성 주입
	@Autowired
	private AccountService accountService;

	// 코스 서비스 의존성 주입
	@Autowired
	private CourseService courseService;

	// 코스 게시판 의존성 주입
	@Autowired
	private CourseListService courseListService;

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

	/*===================================================
	 *	공지사항 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseNotice")
	public String courseNotice(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 코스 강사인지 아닌지 판별
		String isTeacher = "N";
		// 강사 아이디
		String teacherId = HttpUtil.get(request, "teacherId", "");

		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");

		// 총 게시글 수
		long totalCount = 0;
		// 게시글 리스트
		List<CourseList> list = null;
		// 조회할 객체
		CourseList search = new CourseList();
		// 페이징 객체
		Paging paging = null;

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				if (StringUtil.equals(cookieUserId, teacher.getUserId())) {
					isTeacher = "Y";
				}

				model.addAttribute("isTeacher", isTeacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}

		search.setCourseCode(courseCode);
		search.setUserId(teacherId);

		totalCount = courseListService.courseNoticeListCount(search);

		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");

		if (totalCount > 0) {
			paging = new Paging("/course/courseNotice", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());

			list = courseListService.courseNoticeList(search);
		}

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("paging", paging);

		return "/course/courseNotice";
	}

	/*===================================================
	 *	공지사항 페이지 상세화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseNoticeView")
	public String courseNoticeView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 로그인 한 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 내가 쓴 글인지 확인
		String boardMe = "N";
		// 강사인지 확인
		String isTeacher = "N";
		// 강사 아이디
		String teacherId = HttpUtil.get(request, "teacherId", "");

		// 현재 게시글
		CourseList list = null;
		// 이전 게시글
		CourseList prevList = null;
		// 다음 게시글
		CourseList nextList = null;
		// 조회할 객체
		CourseList search = new CourseList();

		logger.debug("================================================");
		logger.debug("courseCode: " + courseCode + ", classCode : " + classCode);
		logger.debug("================================================");

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				if (StringUtil.equals(cookieUserId, teacher.getUserId())) {
					isTeacher = "Y";
				}

				teacherId = teacher.getUserId();

				model.addAttribute("teacherId", teacherId);
				model.addAttribute("isTeacher", isTeacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {
			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}

			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			// 게시글 조회
			Map<String, Object> result = courseListService.courseNoticeViewResult(search);

			list = (CourseList) result.get("list");
			prevList = (CourseList) result.get("prevList");
			nextList = (CourseList) result.get("nextList");

			if (StringUtil.equals(list.getUserId(), cookieUserId)) {
				boardMe = "Y";
			}
		}

		model.addAttribute("teacherId", teacherId);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("notice", list);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("prevList", prevList); // 이전글
		model.addAttribute("nextList", nextList); // 다음글

		return "/course/courseNoticeView";

	}

	/*===================================================
	 *	공지사항 페이지 글쓰기 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseNoticeWrite")
	public String courseNoticeWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (cookieUserId != null) {

			User who = accountService.userOrTeacher(cookieUserId);

			// 학생이라면
			if (StringUtil.equals(who.getRating(), "U")) {
				User user = accountService.userSelect(cookieUserId);

				if (user != null) {
					model.addAttribute("user", user);
				}
			}
			// 강사라면 (답글)
			else if (StringUtil.equals(who.getRating(), "T")) {
				Teacher user = accountService.teacherSelect(cookieUserId);

				if (user != null) {
					model.addAttribute("user", user);
				}

			}

		}

		return "/course/courseNoticeWrite";
	}

	/*===================================================
	 *	공지사항 페이지 글쓰기 동작
	 ===================================================*/
	@RequestMapping(value = "/course/courseNoticeWriteProc")
	@ResponseBody
	public Response<Object> courseNoticeWriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");

		String title = HttpUtil.get(request, "title", "");
		String contentHtml = HttpUtil.get(request, "contentHtml", "");

		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		logger.debug("title : " + title + ", contentHtml : " + contentHtml + ", classCode: " + classCode + ", courseCode : " + courseCode);

		// FileData fileData = HttpUtil.getFile(request, "file", UPLOAD_SAVE_DIR);

		if (!StringUtil.isEmpty(title) && !StringUtil.isEmpty(contentHtml) && !StringUtil.isEmpty(courseCode) && !StringUtil.isEmpty(classCode)) {
			CourseList courseList = new CourseList();

			courseList.setUserId(cookieUserId);
			courseList.setBrdTitle(title);
			courseList.setBrdContent(contentHtml);
			courseList.setCourseCode(courseCode);

			try {

				if (courseListService.courseNoticeWrite(courseList) > 0) {
					res.setResponse(0, "success");
				} else {
					res.setResponse(500, "internal server error");
				}

			} catch (Exception e) {
				logger.error("[CourseControoler] courseQnAWriteProc SQLException", e);
				res.setResponse(500, "internal server error");
			}

		} else {
			res.setResponse(400, "bac request");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /updateProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;

	}

	/*===================================================
	 *	공지사항 수정 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseNoticeUpdate")
	public String courseNoticeUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		CourseList cl = null;

		logger.debug("brdSeq : " + brdSeq);

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {

			CourseList search = new CourseList();

			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			cl = courseListService.courseNoticeViewUpdate(search);

			if (cl != null) {

				logger.debug("111111");

				if (!StringUtil.equals(cl.getUserId(), cookieUserId)) {
					cl = null;
				}
			}

		}

		model.addAttribute("notice", cl);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("brdSeq", brdSeq);

		return "/course/courseNoticeUpdate";
	}

	/*===================================================
	 * 코스 공지 글수정 동작
	 ===================================================*/
	@RequestMapping(value = "/course/courseNoticeUpdateProc")
	@ResponseBody
	public Response<Object> courseNoticeUpdateProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String title = HttpUtil.get(request, "title", "");
		String contentHtml = HttpUtil.get(request, "contentHtml", "");
		int courseCode = HttpUtil.get(request, "courseCode", 0);

		logger.debug("brdSeq : " + brdSeq + ", title : " + title + ", contentHtml : " + contentHtml + ", courseCode : " + courseCode);

		if (brdSeq > 0 && !StringUtil.isEmpty(contentHtml) && !StringUtil.isEmpty(title)) {

			CourseList search = new CourseList();

			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			CourseList cl = courseListService.courseNoticeViewUpdate(search);

			if (cl != null) {

				cl.setBrdSeq(brdSeq);
				cl.setBrdTitle(title);
				cl.setBrdContent(contentHtml);
				cl.setCourseCode(courseCode);

				if (courseListService.courseNoticeUpdate(cl) > 0) {
					logger.debug("1111111");
					res.setResponse(0, "성공");
				} else {
					res.setResponse(-1, "실패");
				}

			} else {
				res.setResponse(403, "리스트 값 널임");
			}

		} else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /courseQnAReviewProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;

	}

	/*===================================================
	 * 코스 공지 글삭제 동작
	 ===================================================*/
	@RequestMapping(value = "/course/courseNoticeDelete")
	@ResponseBody
	public Response<Object> courseNoticeDelete(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		int courseCode = HttpUtil.get(request, "courseCode", 0);

		if (brdSeq > 0) {

			CourseList search = new CourseList();

			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			CourseList cl = courseListService.courseNoticeViewUpdate(search);

			if (cl != null) {

				if (courseListService.courseNoticeDelete(brdSeq) > 0) {
					res.setResponse(0, "성공");
				} else {
					res.setResponse(-1, "실패");
				}
			} else {
				res.setResponse(404, "값이 널임");
			}

		} else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}

		return res;
	}

	/*===================================================
	 *	Q&A 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseQnA")
	public String courseQnA(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 코스 번호
		int courseCode = HttpUtil.get(request, "courseCode", 0);
		// 내가 쓴 글 보기 확인
		String myBrdChk = HttpUtil.get(request, "myBrdChk", "N");
		// 로그인 한 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 총 게시글 수
		long totalCount = 0;
		// 게시글 리스트
		List<CourseList> list = null;
		// 조회할 객체
		CourseList search = new CourseList();
		// 페이징 객체
		Paging paging = null;

		// 강사인지 확인
		String isTeacher = "N";

		// 글번호
		int index = 0;
		logger.debug("========================================");
		logger.debug("myBrdChk : " + myBrdChk);
		logger.debug("courseCode : " + courseCode);
		logger.debug("cookieUserId : " + cookieUserId);
		logger.debug("========================================");

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				search.setTeacherId(teacher.getUserId());

				if (StringUtil.equals(cookieUserId, teacher.getUserId())) {
					isTeacher = "Y";
				}

				model.addAttribute("isTeacher", isTeacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (courseCode > 0) {

			if (!StringUtil.isEmpty(cookieUserId)) {
				// 내가 쓴 글 버튼을 눌렀다면
				if (StringUtil.equals(myBrdChk, "Y")) {
					search.setMyBrdChk(myBrdChk);
					search.setLoginUserId(cookieUserId);
				}

				search.setUserId(cookieUserId);
			}

			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}

			search.setCourseCode(courseCode);

			// 내가 쓴 글이라면 게시글 총 수 다르게 계산
			if (StringUtil.equals(myBrdChk, "Y")) {
				if (!StringUtil.isEmpty(cookieUserId)) {
					totalCount = courseListService.courseQnAMyBrdListCount(search);
				}
			} else {
				totalCount = courseListService.courseQnAListCount(search);
			}

			logger.debug("========================================");
			logger.debug("totalCount : " + totalCount);
			logger.debug("========================================");

			if (totalCount > 0) {
				paging = new Paging("/course/courseQnA", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "currPage");
				int tc = courseListService.courseQnAListCountM(search);
				search.setStartRow(paging.getStartRow());
				search.setEndRow(paging.getEndRow());
				int mc = courseListService.courseQnAListCountM(search);
				logger.debug(tc + " ============= " + mc);
				index = tc - mc;
				list = courseListService.courseQnAList(search);
			}

			model.addAttribute("myBrdChk", myBrdChk);
			model.addAttribute("courseCode", courseCode);
			model.addAttribute("list", list);
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("curPage", curPage);
			model.addAttribute("searchType", searchType);
			model.addAttribute("searchValue", searchValue);
			model.addAttribute("paging", paging);
			model.addAttribute("index", index);
		}

		return "/course/courseQnA";
	}

	/*===================================================
	 *	Q&A 페이지 상세 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseQnAView")
	public String courseQnAView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 코스 번호
		int courseCode = HttpUtil.get(request, "courseCode", 0);
		// 내가 쓴 글인지 확인
		String boardMe = "N";
		// 로그인 한 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 게시글 리스트
		List<CourseList> list = null;
		// 조회할 객체
		CourseList search = new CourseList();

		// 코스 강사인지 확인
		String isTeacher = "N";
		// 답글 달린 글이지 확인
		String isReply = "N";
		// 수정 버튼 확인을 위한 변수 (답글인지 원글인지)
		long nextBrdSeq = 0;

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				if (StringUtil.equals(cookieUserId, teacher.getUserId())) {
					isTeacher = "Y";
				}

				model.addAttribute("isTeacher", isTeacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {
			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}

			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			list = courseListService.courseNoticeQnAViewList(search);

			// 게시글 답글이 달렸을 때, 학생은 수정/삭제 불가
			// 강사는 수정/삭제 가능
			if (list.size() < 2) {
				if (StringUtil.equals(cookieUserId, list.get(0).getUserId()) && StringUtil.equals(isTeacher, "N")) {
					boardMe = "Y";
				}
			} else {
				if (StringUtil.equals(isTeacher, "Y")) {
					isReply = "Y";

					if (StringUtil.equals(cookieUserId, list.get(1).getUserId())) {
						boardMe = "Y";
					}

					// 두 번째 brdSeq로 보내기
					nextBrdSeq = list.get(1).getBrdSeq();
					logger.debug("nextBrdSeq : " + list.get(1).getBrdSeq());
				}

			}
		}

		model.addAttribute("nextBrdSeq", nextBrdSeq);
		model.addAttribute("isReply", isReply);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("list", list);

		return "/course/courseQnAView";
	}

	/*===================================================
	 *	Q&A 페이지 글쓰기 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseQnAWrite")
	public String courseQnAWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		// 게시글 번호
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);

		logger.debug("brdSeq : " + brdSeq);

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (cookieUserId != null) {

			User who = accountService.userOrTeacher(cookieUserId);

			// 학생이라면
			if (StringUtil.equals(who.getRating(), "U")) {
				User user = accountService.userSelect(cookieUserId);

				if (user != null) {
					model.addAttribute("user", user);
				}
			}
			// 강사라면 (답글)
			else if (StringUtil.equals(who.getRating(), "T") && brdSeq > 0) {
				Teacher user = accountService.teacherSelect(cookieUserId);

				if (user != null) {
					model.addAttribute("user", user);
				}

				model.addAttribute("brdSeq", brdSeq);
			}

		}

		return "/course/courseQnAWrite";
	}

	// QnA 게시판 글쓰기 동작
	@RequestMapping(value = "/course/courseQnAWriteProc", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> courseQnAWriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 게시글 번호
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);

		String title = HttpUtil.get(request, "title", "");
		String contentHtml = HttpUtil.get(request, "contentHtml", "");

		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		logger.debug("title : " + title + ", contentHtml : " + contentHtml + ", classCode: " + classCode + ", courseCode : " + courseCode);

		FileData fileData = HttpUtil.getFile(request, "file", UPLOAD_SAVE_DIR);

		if (!StringUtil.isEmpty(title) && !StringUtil.isEmpty(contentHtml) && !StringUtil.isEmpty(courseCode) && !StringUtil.isEmpty(classCode)) {
			CourseList courseList = new CourseList();

			User who = accountService.userOrTeacher(cookieUserId);

			// 학생이라면
			if (StringUtil.equals(who.getRating(), "U")) {
				courseList.setUserId(cookieUserId);
				courseList.setBrdTitle(title);
				courseList.setBrdContent(contentHtml);
				courseList.setCourseCode(courseCode);
			}
			// 강사라면
			else if (StringUtil.equals(who.getRating(), "T")) {
				CourseList parentCl = courseListService.courseQnASelect(brdSeq);

				if (parentCl != null) {
					courseList.setUserId(cookieUserId);
					courseList.setBrdTitle(title);
					courseList.setBrdContent(contentHtml);
					courseList.setCourseCode(courseCode);
					courseList.setBrdGroup(parentCl.getBrdGroup());
					courseList.setBrdOrder(parentCl.getBrdOrder() + 1);
					courseList.setBrdParent(brdSeq);
				}

			}

			// 파일이 존재하고 사이즈가 0보다 크다면
			if (fileData != null && fileData.getFileSize() > 0) {

				CourseListFile courseListFile = new CourseListFile();

				// 파일 세팅
				courseListFile.setFileName(fileData.getFileName());
				courseListFile.setFileOrgName(fileData.getFileOrgName());
				courseListFile.setFileExt(fileData.getFileExt());
				courseListFile.setFileSize(fileData.getFileSize());

				courseList.setCourseListFile(courseListFile);
			}

			try {

				if (courseListService.courseListQnAInsert(courseList) > 0) {
					res.setResponse(0, "success");
				} else {
					res.setResponse(500, "internal server error");
				}

			} catch (Exception e) {
				logger.error("[CourseControoler] courseQnAWriteProc SQLException", e);
				res.setResponse(500, "internal server error");
			}

		} else {
			res.setResponse(400, "bac request");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /updateProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;
	}

	// 코스 QnA 게시판 다운로드
	@RequestMapping(value = "/course/courseListFiledownload")
	public ModelAndView courseListFiledownload(HttpServletRequest request, HttpServletResponse response) {

		ModelAndView mav = null;

		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);

		if (brdSeq > 0) {

			CourseListFile clf = courseListService.courseQnAFileSelect(brdSeq);

			if (clf != null) {

				File file = new File(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + clf.getFileName());

				logger.debug("=======================================");
				logger.debug("UPLOAD_SAVE_DIR : " + UPLOAD_SAVE_DIR);
				logger.debug("FileUtil.getFileSeparator() : " + FileUtil.getFileSeparator());
				logger.debug("clf.getFileName() : " + clf.getFileName());
				logger.debug("clf.getFileOrgName() : " + clf.getFileOrgName());
				logger.debug("=======================================");

				// 파일 존재하는지 확인
				if (FileUtil.isFile(file)) {

					mav = new ModelAndView();

					mav.setViewName("fileDownloadView");
					mav.addObject("file", file);
					mav.addObject("fileName", clf.getFileOrgName());

					return mav;
				}
			}
		}

		return mav;

	}

	// 코스 QnA 게시글 수정 화면
	@RequestMapping(value = "/course/courseQnAUpdate")
	public String courseQnAUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		CourseList cl = null;

		logger.debug("brdSeq : " + brdSeq);

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {

			cl = courseListService.courseListQnAViewUpdate(brdSeq);

			if (cl != null) {

				if (!StringUtil.equals(cl.getUserId(), cookieUserId)) {
					cl = null;
				}
			}
		}

		model.addAttribute("qna", cl);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("brdSeq", brdSeq);

		return "/course/courseQnAUpdate";
	}

	// 코스 QnA 게시판 수정 동작
	@RequestMapping(value = "/course/courseQnAUpdateProc")
	@ResponseBody
	public Response<Object> courseQnAUpdateProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String title = HttpUtil.get(request, "title", "");
		String contentHtml = HttpUtil.get(request, "contentHtml", "");
		int courseCode = HttpUtil.get(request, "courseCode", 0);

		logger.debug("title : " + title + ", contentHtml : " + contentHtml + "brdSeq : " + brdSeq + ", courseCode : " + courseCode);

		FileData fileData = HttpUtil.getFile(request, "file", UPLOAD_SAVE_DIR);

		if (brdSeq > 0 && !StringUtil.isEmpty(title) && !StringUtil.isEmpty(contentHtml)) {

			CourseList courseList = courseListService.courseQnASelect(brdSeq);

			if (courseList != null) {

				courseList.setBrdSeq(brdSeq);
				courseList.setBrdTitle(title);
				courseList.setBrdContent(contentHtml);
				courseList.setCourseCode(courseCode);

				// 파일이 존재하고 사이즈가 0보다 크다면
				if (fileData != null && fileData.getFileSize() > 0) {

					CourseListFile courseListFile = new CourseListFile();

					// 파일 세팅
					courseListFile.setFileName(fileData.getFileName());
					courseListFile.setFileOrgName(fileData.getFileOrgName());
					courseListFile.setFileExt(fileData.getFileExt());
					courseListFile.setFileSize(fileData.getFileSize());

					courseListFile.setCourseCode(courseCode);

					courseList.setCourseListFile(courseListFile);

					logger.debug("파일세팅끝!!!!");
				}

				try {

					if (courseListService.courseQnAUpdate(courseList) > 0) {
						res.setResponse(0, "success");
					} else {
						res.setResponse(500, "internal server error");
					}

				} catch (Exception e) {
					logger.error("[CourseControoler] courseQnAUpdateProc SQLException", e);
					res.setResponse(500, "internal server error");
				}
			} else {
				res.setResponse(403, "internal server error");
			}
		} else {
			res.setResponse(400, "bac request");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /updateProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;
	}

	// 코스 QnA 게시글 삭제
	@RequestMapping(value = "/course/courseQnADelete")
	@ResponseBody
	public Response<Object> courseQnADelete(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);

		if (brdSeq > 0) {

			CourseList cl = courseListService.courseQnASelect(brdSeq);

			if (cl != null) {

				try {

					if (courseListService.courseQnADelete(brdSeq) > 0) {
						res.setResponse(0, "성공");
					} else {
						res.setResponse(500, "server error2");
					}

				} catch (Exception e) {
					logger.error("[CourseControoler] courseQnAUpdateProc SQLException", e);
					res.setResponse(500, "internal server error");
				}

			} else {
				res.setResponse(404, "not found");
			}
		}

		else {
			res.setResponse(400, "bad request");
		}

		return res;
	}

	/*===================================================
	 *	수강후기 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseReview")
	public String courseReview(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 강사 아이디
		// String userId = HttpUtil.get(request, "userId", "");

		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 내가 쓴 글 보기 확인
		String myBrdChk = HttpUtil.get(request, "myBrdChk", "N");
		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 선생인지 확인
		String isTeacher = "N";

		// 총 게시글 수
		long totalCount = 0;
		// 게시글 리스트
		List<CourseList> list = null;
		// 조회할 객체
		CourseList search = new CourseList();
		// 페이징 객체
		Paging paging = null;

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				if (StringUtil.equals(cookieUserId, teacher.getUserId())) {
					isTeacher = "Y";
				}

				model.addAttribute("isTeacher", isTeacher);

				search.setTeacherId(teacher.getUserId());

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}

		// 내가 쓴 글 버튼을 눌렀다면
		if (StringUtil.equals(myBrdChk, "Y")) {
			search.setMyBrdChk(myBrdChk);
			search.setLoginUserId(cookieUserId);
		}

		search.setUserId(cookieUserId);
		search.setCourseCode(courseCode);

		totalCount = courseListService.courseReviewListCount(search);

		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("========================================");

		if (totalCount > 0) {
			paging = new Paging("/course/courseReview", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());

			list = courseListService.courseReviewList(search);
		}

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("paging", paging);
		model.addAttribute("myBrdChk", myBrdChk);

		return "/course/courseReview";
	}

	/*===================================================
	 *	수강후기 상세 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseReviewView")
	public String courseReviewView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 내가 쓴 글인지 확인
		String boardMe = "N";

		// 게시글 리스트
		CourseList list = null;
		// 조회할 객체
		CourseList search = new CourseList();

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {
			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}

			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			list = courseListService.courseReviewView(search);

			if (StringUtil.equals(cookieUserId, list.getUserId())) {
				boardMe = "Y";
			}
		}

		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("boardMe", boardMe);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("review", list);

		return "/course/courseReviewView";
	}

	/*===================================================
	 *	수강후기 글쓰기 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseReviewWrite")
	public String courseReviewWrite(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (cookieUserId != null) {

			User user = accountService.userSelect(cookieUserId);

			if (user != null) {
				model.addAttribute("user", user);
			}

		}

		return "/course/courseReviewWrite";
	}

	// 코스 수강후기 글 여부 조회
	@RequestMapping(value = "/course/courseReviewWriteCheck")
	@ResponseBody
	public Response<Object> courseReviewWriteCheck(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		if (!StringUtil.isEmpty(cookieUserId) && courseCode > 0) {
			if (courseListService.courseReviewWriteCheck(cookieUserId, courseCode) <= 0) {
				res.setResponse(0, "success");
			} else {
				res.setResponse(404, "error");
			}
		} else {
			res.setResponse(404, "error");
		}

		return res;
	}

	// 코스 수강후기 글쓰기 동작
	@RequestMapping(value = "/course/courseReviewWriteProc")
	@ResponseBody
	public Response<Object> courseReviewWriteProc(MultipartHttpServletRequest request, HttpServletResponse response) {

		Response<Object> res = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);

		String title = HttpUtil.get(request, "title", "");
		String contentHtml = HttpUtil.get(request, "contentHtml", "");
		int rating = HttpUtil.get(request, "ratingValue", 0);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		if (!StringUtil.isEmpty(title) && !StringUtil.isEmpty(contentHtml) && !StringUtil.isEmpty(rating)) {
			CourseList cl = new CourseList();

			cl.setUserId(cookieUserId);
			cl.setBrdTitle(title);
			cl.setBrdContent(contentHtml);
			cl.setCourseCode(courseCode);
			cl.setBrdRating(rating);

			if (courseListService.courseReviewInsert(cl) > 0) {
				res.setResponse(0, "성공");
			} else {
				res.setResponse(-1, "실패");
			}

		} else {
			res.setResponse(400, "파라미터XX");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /courseReviewWriteProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;
	}

	// 코스 수강후기 글수정 화면
	@RequestMapping(value = "/course/courseReviewUpdate")
	public String courseReviewUpdate(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String searchType = HttpUtil.get(request, "searchType", "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);

		CourseList cl = null;

		logger.debug("brdSeq : " + brdSeq);

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스가 존재할 때
			if (course != null) {
				// 코스를 통한 강사 조회
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				// 완료된 강의 수
				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("finishLecCnt", finishLecCnt);
				model.addAttribute("totalProgress", totalProgress);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {

			cl = courseListService.courseReviewViewUpdate(brdSeq);

			if (cl != null) {

				logger.debug("111111");

				if (!StringUtil.equals(cl.getUserId(), cookieUserId)) {
					cl = null;
				}
			}

		}

		model.addAttribute("review", cl);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("brdSeq", brdSeq);

		return "/course/courseReviewUpdate";
	}

	// 코스 수강후기 글수정 동작
	@RequestMapping(value = "/course/courseReviewUpdateProc")
	@ResponseBody
	public Response<Object> courseQnAReviewProc(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();

		long brdSeq = HttpUtil.get(request, "brdSeq", 0);
		String title = HttpUtil.get(request, "title", "");
		String contentHtml = HttpUtil.get(request, "contentHtml", "");
		int rating = HttpUtil.get(request, "ratingValue", 0);
		int courseCode = HttpUtil.get(request, "courseCode", 0);

		logger.debug("brdSeq : " + brdSeq + ", title : " + title + ", contentHtml : " + contentHtml + ", brdRating : " + rating);

		if (brdSeq > 0 && !StringUtil.isEmpty(contentHtml) && !StringUtil.isEmpty(title)) {

			CourseList cl = courseListService.courseReviewViewUpdate(brdSeq);

			if (cl != null) {

				cl.setBrdSeq(brdSeq);
				cl.setBrdTitle(title);
				cl.setBrdContent(contentHtml);
				cl.setBrdRating(rating);
				cl.setCourseCode(courseCode);

				if (courseListService.courseReviewUpdate(cl) > 0) {
					logger.debug("1111111");
					res.setResponse(0, "성공");
				} else {
					res.setResponse(-1, "실패");
				}

			} else {
				res.setResponse(403, "리스트 값 널임");
			}

		} else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}

		if (logger.isDebugEnabled()) {
			logger.debug("[UserController] /courseQnAReviewProc response\n" + JsonUtil.toJsonPretty(res));
		}

		return res;
	}

	@RequestMapping(value = "/course/courseReviewDelete")
	@ResponseBody
	public Response<Object> courseReviewDelete(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		long brdSeq = HttpUtil.get(request, "brdSeq", 0);

		if (brdSeq > 0) {

			CourseList cl = courseListService.courseReviewViewUpdate(brdSeq);

			if (cl != null) {

				if (courseListService.courseReviewDelete(brdSeq) > 0) {
					res.setResponse(0, "성공");
				} else {
					res.setResponse(-1, "실패");
				}
			} else {
				res.setResponse(404, "값이 널임");
			}

		} else {
			res.setResponse(400, "파라미터 값 안 넘어옴");
		}

		return res;
	}

}
