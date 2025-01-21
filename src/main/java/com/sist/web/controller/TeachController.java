package com.sist.web.controller;

import java.util.ArrayList;
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
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.Book;
import com.sist.web.model.Course;
import com.sist.web.model.CourseList;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.service.AccountService;
import com.sist.web.service.BookService;
import com.sist.web.service.CartService;
import com.sist.web.service.CourseListService;
import com.sist.web.service.CourseService;
import com.sist.web.service.TeachService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("teachController")
public class TeachController {

	private static Logger logger = LoggerFactory.getLogger(IndexController.class);

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	// 페이징 상수 정의
	private static final int LIST_COUNT = 5;
	private static final int PAGE_COUNT = 5;

	@Autowired
	private TeachService teachService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private CourseService courseService;

	@Autowired
	private CourseListService courseListService;

	@Autowired
	private BookService bookService;

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

	/*===================================================
	* 공지 게시글 값 보내기
	===================================================*/
	@ControllerAdvice
	public class CommonControllerAdvice {

		@ModelAttribute
		public void teacherNotice(HttpServletRequest request, ModelMap model) {
//         String requestURI = request.getRequestURI();
			// 강사 아이디
			String teacherId = HttpUtil.get(request, "teacherId", "");

			List<CourseList> teacherNotice = null;

			if (!StringUtil.isEmpty(teacherId)) {
				teacherNotice = courseListService.teachNoticeRec(teacherId);
				model.addAttribute("teacherNotice", teacherNotice);
			}

		}
	}

	@RequestMapping(value = "/teach/teachContainer")
	public String teacherContainer(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 강사 아이디
		String teacherId = HttpUtil.get(request, "teacherId", "");

		List<CourseList> teacherNotice = null;

		if (!StringUtil.isEmpty(teacherId)) {
			logger.debug("들어왔다!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

			teacherNotice = courseListService.teachNoticeRec(teacherId);
			model.addAttribute(teacherNotice);
		}

		return "/teach/teachContainer";
	}

	/*===================================================
	*   선생님 목록 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachList", method = RequestMethod.POST)
	public String teachList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 강사 리스트
		List<Teacher> teacherList = null;
		long totalCount = 0;

		totalCount = teachService.teacherListCount(classCode);

		if (totalCount > 0) {
			teacherList = teachService.teacherListSelect(classCode);

			if (teacherList != null) {
				model.addAttribute("totalCount", totalCount);
				model.addAttribute("teacherList", teacherList);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		// 과목별 최신 공지 4개 조회
		List<CourseList> cl = courseListService.classNotcieRec(classCode);

		if (cl != null) {
			model.addAttribute("noticeRec", cl);
		}

		return "/teach/teachList";
	}

	/*===================================================
	*   선생님 메인 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachPage", method = RequestMethod.POST)
	public String teachPage(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
		// 강사 아이디
		String teacherId = HttpUtil.get(request, "teacherId", "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 강사 코스 수
		int totalCount = 0;
		// 선생님 최신 코스 리스트
		List<Course> teacherListRecent = null;
		// 사용자 최신 코스 리스트
		List<Course> userListRecent = new ArrayList<>();
		// 선생님 로그인시 띄울 최신 코스 리스트
		List<Course> teacherListRecent1 = new ArrayList<>();

		// 인기 코스 리스트
		List<Course> listPopular = null;

		// 베스트 수강후기 3개 뽑기
		List<CourseList> bestList = courseListService.teachBestReview(teacherId);

		if (bestList != null) {
			model.addAttribute("bestList", bestList);
		}

		if (!StringUtil.isEmpty(teacherId)) {
			Teacher teacher = teachService.teacherSelect(teacherId);

			if (teacher != null) {
				model.addAttribute("teacher", teacher);

				totalCount = teachService.teacherCourseCnt(teacherId);

				if (totalCount > 0) {
					teacherListRecent = teachService.teacherRecentCourseListSelect(teacherId);
					listPopular = teachService.teacherPopularCourseListSelect(teacherId);

					if (teacherListRecent != null && teacherListRecent.size() > 0) {
						int courseSize = Math.min(teacherListRecent.size(), 3);

						// "N","Y" 통합 3개 추출
						for (int j = 0; j < courseSize; j++) {
							Course course1 = teacherListRecent.get(j);

							teacherListRecent1.add(course1);

						}
					}
					model.addAttribute("teacherListRecent1", teacherListRecent1);

					// "Y"값인거만 3개 추출
					for (int i = 0; i < teacherListRecent.size(); i++) {
						Course course = teacherListRecent.get(i);

						if (StringUtil.equals("Y", course.getCourseStatus())) {
							userListRecent.add(course);
						}

						if (userListRecent.size() == 3) {
							break;
						}
					}
					model.addAttribute("userListRecent", userListRecent);

					if (!StringUtil.isEmpty(cookieUserId)) {
//                  // 로그인 한 사용자가 수강 중인지 체크
//                  for (int i = 0; i < teacherListRecent.size(); i++) 
//                  {
//                     teacherListRecent.get(i).setMyCourseChk(courseService.myCourseSelect(cookieUserId, teacherListRecent.get(i).getCourseCode()));
//                     listPopular.get(i).setMyCourseChk(courseService.myCourseSelect(cookieUserId, listPopular.get(i).getCourseCode()));
//                  }

						if (teacherListRecent != null && teacherListRecent.size() > 0) {
							for (int i = 0; i < teacherListRecent.size(); i++) {
								teacherListRecent.get(i)
										.setMyCourseChk(courseService.myCourseSelect(cookieUserId, teacherListRecent.get(i).getCourseCode()));
							}
						}

						if (listPopular != null && listPopular.size() > 0) {
							for (int i = 0; i < listPopular.size(); i++) {
								listPopular.get(i).setMyCourseChk(courseService.myCourseSelect(cookieUserId, listPopular.get(i).getCourseCode()));
							}
						}

					}
				}
			}
		}

		// 로그인 여부 확인
		Account account = null;

		if (!StringUtil.isEmpty(cookieUserId)) {
			if (StringUtil.equals(cookieRating, "T"))
				account = accountService.teacherSelect(cookieUserId);
			else if (StringUtil.equals(cookieRating, "U"))
				account = accountService.userSelect(cookieUserId);
		}

		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("account", account);
		model.addAttribute("teacherListRecent", teacherListRecent);
		model.addAttribute("listPopular", listPopular);
		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		return "/teach/teachPage";
	}

	/*===================================================
	*   선생님 조회
	===================================================*/
	@RequestMapping(value = "/teach/teachSelect", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> teachSelect(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String userId = HttpUtil.get(request, "teacherId", "");

		if (!StringUtil.isEmpty(cookieUserId)) {
			Teacher teacher = teachService.teacherSelect(cookieUserId);

			if (teacher != null) {
				if (StringUtil.equals(cookieUserId, userId)) {
					ajaxResponse.setResponse(0, "success");
				} else {
					ajaxResponse.setResponse(500, "no eq teacher");
				}
			} else {
				ajaxResponse.setResponse(100, "no teacher");
			}
		} else {
			ajaxResponse.setResponse(400, "no access");
		}

		return ajaxResponse;
	}

	/*===================================================
	*   선생님 개인정보 수정
	===================================================*/
	@RequestMapping(value = "/teach/teachUpdate", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> teachUpdate(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String userDegree = HttpUtil.get(request, "userDegree");
		String userCareer = HttpUtil.get(request, "userCareer");
		String userIntro = HttpUtil.get(request, "userIntro");

		Teacher teacher = new Teacher();

		try {
			if (!StringUtil.isEmpty(cookieUserId) && !StringUtil.isEmpty(userDegree) && !StringUtil.isEmpty(userCareer)
					&& !StringUtil.isEmpty(userIntro)) {
				teacher.setUserId(cookieUserId);
				teacher.setUserDegree(userDegree);
				teacher.setUserCareer(userCareer);
				teacher.setUserIntro(userIntro);

				if (teachService.teachUpdate(teacher) > 0) {
					Teacher search = teachService.teacherSelect(cookieUserId);
					ajaxResponse.setResponse(0, "success", search);
				} else {
					ajaxResponse.setResponse(500, "error");
				}
			}
		} catch (Exception e) {
			ajaxResponse.setResponse(400, "no access");
		}

		return ajaxResponse;
	}

	/*===================================================
	*   선생님 강좌목록 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachCourse", method = RequestMethod.POST)
	public String teachCourse(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");

		// 강사 아이디
		String teacherId = HttpUtil.get(request, "teacherId", "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 코스 리스트
		List<Course> list = null;
		// 코스 객체
		Course search = new Course();
		// 강사 코스 수
		int totalCount = 0;
		// 페이징 객체
		Paging paging = null;

		Teacher teacher = null;

		if (!StringUtil.isEmpty(teacherId)) {
			teacher = teachService.teacherSelect(teacherId);

			logger.debug("teacherUserId :: " + teacher.getUserId());
			logger.debug("cookieUserId :: " + cookieUserId);
			logger.debug("cookieRating :: " + cookieRating);

			if (teacher != null) {

				totalCount = teachService.teacherCourseCnt(teacherId);

				if (totalCount > 0) {
					paging = new Paging("/teach/teachCourse", totalCount, 10, 5, curPage, "curPage");

					search.setUserId(teacherId);
					search.setStartRow(paging.getStartRow());
					search.setEndRow(paging.getEndRow());

					list = teachService.teacherCourseListSelect(search);

					if (!StringUtil.isEmpty(cookieUserId)) {
						// 로그인 한 사용자가 수강 중인지 체크
						for (int i = 0; i < list.size(); i++) {
							list.get(i).setMyCourseChk(courseService.myCourseSelect(cookieUserId, list.get(i).getCourseCode()));
						}
					}
				}
			}
		}

		// 로그인 여부 확인
		Account account = null;

		if (!StringUtil.isEmpty(cookieUserId)) {
			if (StringUtil.equals(cookieRating, "T"))
				account = accountService.teacherSelect(cookieUserId);
			else if (StringUtil.equals(cookieRating, "U"))
				account = accountService.userSelect(cookieUserId);
		}

		model.addAttribute("teacher", teacher);
		model.addAttribute("account", account);
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("curPage", curPage);
		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));
		model.addAttribute("cookieUserId", cookieUserId);
		model.addAttribute("cookieRating", cookieRating);

		return "/teach/teachCourse";
	}

	/*===================================================
	*   선생님 공지사항 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachNotice", method = RequestMethod.POST)
	public String teachNotice(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String teacherId = HttpUtil.get(request, "teacherId", "");
		int classCode = HttpUtil.get(request, "classCode", 1);

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

		if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}

		if (!StringUtil.isEmpty(teacherId)) {
			search.setUserId(teacherId);
		}

		totalCount = courseListService.courseNoticeListCount(search);

		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("teacherId : " + teacherId);
		logger.debug("========================================");

		if (totalCount > 0) {
			paging = new Paging("/teach/teachNotice", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

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

		if (!StringUtil.isEmpty(teacherId)) {
			Teacher teacher = teachService.teacherSelect(teacherId);

			if (teacher != null) {
				model.addAttribute("teacher", teacher);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		return "/teach/teachNotice";
	}

	/*===================================================
	*   선생님 공지사항 상세 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachNoticeView")
	public String teachNoticeView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String teacherId = HttpUtil.get(request, "teacherId", "");
		int classCode = HttpUtil.get(request, "classCode", 1);

		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");

		// 로그인 한 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 내가 쓴 글인지 확인
		String boardMe = "N";

		// 현재 게시글
		CourseList list = null;
		// 이전 게시글
//      CourseList prevList = null;
		// 다음 게시글
//      CourseList nextList = null;
		// 조회할 객체
		CourseList search = new CourseList();

		logger.debug("================================================");
		logger.debug("courseCode: " + courseCode + ", classCode : " + classCode);
		logger.debug("================================================");

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스를 통한 강사 조회
			Teacher teacher = teachService.teacherSelect(course.getUserId());

			// 코스가 존재할 때
			if (course != null) {
				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);
			}
		}

		if (!StringUtil.isEmpty(teacherId)) {
			Teacher teacher = teachService.teacherSelect(teacherId);

			if (teacher != null) {
				model.addAttribute("teacher", teacher);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {
			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}

			// 임의로 지정
			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);
			search.setTeacherId(teacherId);

			// 게시글 조회
			Map<String, Object> result = courseListService.courseNoticeViewResult(search);

			list = (CourseList) result.get("list");

			if (StringUtil.equals(list.getUserId(), cookieUserId)) {
				boardMe = "Y";
			}
		}

		model.addAttribute("boardMe", boardMe);
		model.addAttribute("notice", list);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);

		return "/teach/teachNoticeView";
	}

	/*===================================================
	*   선생님 학습 Q&A 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachQna", method = RequestMethod.POST)
	public String teachQna(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		String teacherId = HttpUtil.get(request, "teacherId", "");
		int classCode = HttpUtil.get(request, "classCode", 1);
		int courseCode = HttpUtil.get(request, "courseCode", 0);

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
		// 글번호
		int index = 0;
		logger.debug("================================================");
		logger.debug("courseCode: " + courseCode + ", classCode : " + classCode);
		logger.debug("teacherId: " + teacherId);
		logger.debug("================================================");

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스를 통한 강사 조회
			Teacher teacher = teachService.teacherSelect(course.getUserId());

			// 코스가 존재할 때
			if (course != null) {
				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}

		if (!StringUtil.isEmpty(teacherId)) {
			search.setTeacherId(teacherId);
		}

		totalCount = courseListService.courseQnAListCount(search);

		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("teacherId : " + teacherId);
		logger.debug("courseCode: " + courseCode);
		logger.debug("========================================");

		if (totalCount > 0) {
			paging = new Paging("/teach/teachQna", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");
			int tc = courseListService.courseQnAListCountM(search);
			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			int mc = courseListService.courseQnAListCountM(search);
			index = tc - mc;
			list = courseListService.courseQnAList(search);
			logger.debug(tc + " ================= " + mc);
		}

		model.addAttribute("totalCount", totalCount);
		model.addAttribute("list", list);
		model.addAttribute("curPage", curPage);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("paging", paging);
		model.addAttribute("index", index);

		if (!StringUtil.isEmpty(teacherId)) {
			Teacher teacher = teachService.teacherSelect(teacherId);

			if (teacher != null) {
				model.addAttribute("teacher", teacher);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		return "/teach/teachQna";
	}

	/*===================================================
	*   선생님 학습 Q&A 상세 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachQnAView")
	public String teachQnAView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		int classCode = HttpUtil.get(request, "classCode", 1);

		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");

		// 해당 코스 강사인지 확인
		String isTeacher = "N";

		// 로그인 한 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 내가 쓴 글인지 확인
		String boardMe = "N";
		// 답글 달린 글인지 확인
		String isReply = "N";
		// 답글/원글 수정인지 확인
		long nextBrdSeq = 0;

		// 게시글 리스트
		List<CourseList> list = null;
		// 조회할 객체
		CourseList search = new CourseList();

		logger.debug("================================================");
		logger.debug("courseCode: " + courseCode + ", classCode : " + classCode);
		logger.debug("================================================");

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스를 통한 강사 조회
			Teacher teacher = teachService.teacherSelect(course.getUserId());

			// 코스가 존재할 때
			if (course != null) {
				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				if (StringUtil.equals(cookieUserId, teacher.getUserId())) {
					isTeacher = "Y";
					model.addAttribute("isTeacher", isTeacher);
				}
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

			logger.debug("================================================");
			logger.debug("list: " + list);
			logger.debug("================================================");

			if (list.size() < 2) {
				if (StringUtil.equals(cookieUserId, list.get(0).getUserId())) {
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

		return "/teach/teachQnAView";
	}

	/*===================================================
	*   선생님 수강후기 화면
	===================================================*/
	@RequestMapping(value = "/teach/teachReview", method = RequestMethod.POST)
	public String teachReview(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");

		String teacherId = HttpUtil.get(request, "teacherId", "");
		int classCode = HttpUtil.get(request, "classCode", 1);

		// 총 게시글 수
		long totalCount = 0;
		// 게시글 리스트
		List<CourseList> list = null;
		// 조회할 객체
		CourseList search = new CourseList();
		// 페이징 객체
		Paging paging = null;

		if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
			search.setSearchType(searchType);
			search.setSearchValue(searchValue);
		}

		if (!StringUtil.isEmpty(teacherId)) {
			search.setTeacherId(teacherId);
		}

		totalCount = courseListService.courseReviewListCount(search);

		logger.debug("========================================");
		logger.debug("totalCount : " + totalCount);
		logger.debug("teacherId : " + teacherId);
		logger.debug("========================================");

		if (totalCount > 0) {
			paging = new Paging("/teach/teachNotice", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

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

		if (!StringUtil.isEmpty(teacherId)) {
			Teacher teacher = teachService.teacherSelect(teacherId);

			if (teacher != null) {
				model.addAttribute("teacher", teacher);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		return "/teach/teachReview";
	}

	/*===================================================
	*   선생님 수강후기 상세화면
	===================================================*/
	@RequestMapping(value = "/teach/teachReviewView")
	public String teachReviewView(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		int classCode = HttpUtil.get(request, "classCode", 1);

		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		// 현재 페이지
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		// 조회항목 (1 : 작성자, 2 : 제목, 3 : 내용)
		String searchType = HttpUtil.get(request, "searchType", "");
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 조회값
		String searchValue = HttpUtil.get(request, "searchValue", "");

		// 로그인 한 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 내가 쓴 글인지 확인
		String boardMe = "N";

		// 현재 게시글
		CourseList list = null;
		// 조회할 객체
		CourseList search = new CourseList();

		logger.debug("================================================");
		logger.debug("courseCode: " + courseCode + ", classCode : " + classCode);
		logger.debug("================================================");

		// 코스 번호가 정상적일 때
		if (courseCode > 0) {
			// 코스 조회
			Course course = courseService.courseSelect(courseCode);
			// 코스를 통한 강사 조회
			Teacher teacher = teachService.teacherSelect(course.getUserId());

			// 코스가 존재할 때
			if (course != null) {
				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		if (brdSeq > 0) {
			if (!StringUtil.isEmpty(searchType) && !StringUtil.isEmpty(searchValue)) {
				search.setSearchType(searchType);
				search.setSearchValue(searchValue);
			}

			// 임의로 지정
			search.setCourseCode(courseCode);
			search.setBrdSeq(brdSeq);

			list = courseListService.courseReviewView(search);

			if (StringUtil.equals(list.getUserId(), cookieUserId)) {
				boardMe = "Y";
			}
		}

		model.addAttribute("boardMe", boardMe);
		model.addAttribute("review", list);
		model.addAttribute("brdSeq", brdSeq);
		model.addAttribute("searchType", searchType);
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);

		return "/teach/teachReviewView";
	}

	/*===================================================
	*   코스등록 중 교재 검색
	===================================================*/
	@RequestMapping(value = "/teach/teachBookSearch")
	public String teachBookSearch(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String searchValue = HttpUtil.get(request, "searchValue", "");
		long curPage = HttpUtil.get(request, "curPage", (long) 1);
		String classCode = HttpUtil.get(request, "classCode", "");

		long totalCount = 0;
		List<Book> list = null;
		Book book = new Book();
		Paging paging = null;

		book.setSearchValue(searchValue);
		book.setClassCode(classCode);

		logger.debug("book.getSearchValue : " + book.getSearchValue());

		totalCount = bookService.bookListCount(book);

		if (totalCount > 0) {
			paging = new Paging("/board/list", totalCount, LIST_COUNT, PAGE_COUNT, curPage, "curPage");

			book.setStartRow(paging.getStartRow());
			book.setEndRow(paging.getEndRow());

			list = bookService.booklistSelect(book);
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
		model.addAttribute("searchValue", searchValue);
		model.addAttribute("curPage", curPage);
		model.addAttribute("account", account);
		return "/teach/teachBookSearch";
	}

	/*===================================================
	*   코스 등록
	===================================================*/
	@RequestMapping(value = "/teach/courseInsert")
	@ResponseBody
	public Response<Object> courseInsert(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
		String teachId = HttpUtil.get(request, "teacherId", "");
		String courseName = HttpUtil.get(request, "courseName", "");
		long bookSeq = HttpUtil.get(request, "bookSeq", (long) 1);
		String courseDetail = HttpUtil.get(request, "courseDetail", "");

		Course course = new Course();

		if (!StringUtil.isEmpty(cookieUserId) && StringUtil.equals(cookieRating, "T")) {
			if (StringUtil.equals(cookieUserId, teachId)) {
				if (!StringUtil.isEmpty(courseName) && !StringUtil.isEmpty(courseDetail) && !StringUtil.isEmpty(bookSeq)) {
					course.setCourseName(courseName);
					course.setCourseDetail(courseDetail);
					course.setCourseDetail(courseDetail);
					course.setUserId(cookieUserId);
					course.setBookSeq(bookSeq);

					int count = teachService.courseInsert(course);

					if (count > 0) {
						ajaxResponse.setResponse(0, "success");
					}
				} else {
					ajaxResponse.setResponse(-401, "parameter error");
				}
			} else {
				ajaxResponse.setResponse(-101, "user error");
			}
		} else {
			ajaxResponse.setResponse(100, "login error");
		}

		return ajaxResponse;
	}

	/*===================================================
	*   코스 삭제
	===================================================*/
	@RequestMapping(value = "/teach/courseDelete")
	@ResponseBody
	public Response<Object> courseDelete(ModelMap model, HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		long courseCode = HttpUtil.get(request, "courseCode", (long) 0);

		logger.debug("courseCode : " + courseCode);
		logger.debug("cookieUserId!! " + cookieUserId);

		Course course = new Course();

		if (!StringUtil.isEmpty(cookieUserId)) {

			if (courseCode > 0) {
				if (!StringUtil.isEmpty(courseCode)) {
					course = teachService.courseSelect(courseCode);

					if (course != null) {
						if (teachService.courseDel(course.getCourseCode()) > 0) {
							ajaxResponse.setResponse(0, "success");
						}
					} else {
						ajaxResponse.setResponse(40, "no course");
					}
				} else {
					ajaxResponse.setResponse(-401, "parameter error");
				}
			} else {
				ajaxResponse.setResponse(-400, "parameter error2");
			}
		} else {
			ajaxResponse.setResponse(-101, "login error1");
		}

		return ajaxResponse;
	}
}
