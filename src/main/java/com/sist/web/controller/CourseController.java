package com.sist.web.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.sist.common.model.FileData;
import com.sist.common.util.StringUtil;
import com.sist.web.model.Account;
import com.sist.web.model.Book;
import com.sist.web.model.Course;
import com.sist.web.model.Lecture;
import com.sist.web.model.Paging;
import com.sist.web.model.Response;
import com.sist.web.model.Teacher;
import com.sist.web.model.WatchTimeRequest;
import com.sist.web.service.AccountService;
import com.sist.web.service.BookService;
import com.sist.web.service.CartService;
import com.sist.web.service.CourseService;
import com.sist.web.service.TeachService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("courseController")
public class CourseController {

	private static Logger logger = LoggerFactory.getLogger(CourseController.class);

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	@Value("#{env['auth.cookie.rate']}")
	private String AUTH_COOKIE_RATE;

	@Value("#{env['lecture.save.dir']}")
	private String LECTURE_SAVE_DIR;

	@Autowired
	private AccountService accountService;

	@Autowired
	private BookService bookService;

	@Autowired
	private TeachService teachService;

	@Autowired
	private CourseService courseService;

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
	 *	강좌소개 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseMain")
	public String courseMain(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

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

				// 교재 객체
				Book book = bookService.lectureBookSelect(courseCode);
				classCode = Integer.parseInt(teacher.getClassCode());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);
				model.addAttribute("book", book);

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

				// 수강 여부 조회
				int myCourse = courseService.myCourseSelect(cookieUserId, courseCode);

				model.addAttribute("myCourse", myCourse);
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		return "/course/courseMain";
	}

	/*===================================================
	 *	강의 목록 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/course/courseList")
	public String courseList(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);
		// 강의 리스트
		List<Lecture> list = null;

		if (courseCode > 0) {
			Course course = courseService.courseSelect(courseCode);

			if (course != null) {
				Teacher teacher = teachService.teacherSelect(course.getUserId());

				model.addAttribute("course", course);
				model.addAttribute("teacher", teacher);

				// 완료된 강의 수 조회
				Lecture searchLec = new Lecture();
				searchLec.setUserId(cookieUserId);
				searchLec.setCourseCode(courseCode);

				int finishLecCnt = courseService.finishLectureCntSelect(searchLec);

				model.addAttribute("finishLecCnt", finishLecCnt);

				// 총 학습 진도율
				double totalProgress = 0;

				if (course.getLecCnt() > 0 && finishLecCnt > 0) {
					totalProgress = ((double) finishLecCnt / course.getLecCnt()) * 100;

					totalProgress = Math.round(totalProgress * 100) / 100.0;
				}

				model.addAttribute("totalProgress", totalProgress);

				if (course.getLecCnt() > 0) {
					Lecture lecture = new Lecture();

					lecture.setUserId(cookieUserId);
					lecture.setCourseCode(courseCode);

					list = courseService.lectureListSelect(lecture);

					model.addAttribute("list", list);
				}
			}
		}

		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));
		model.addAttribute("courseCode", courseCode);
		model.addAttribute("cookieUserId", cookieUserId);
		return "/course/courseList";
	}

	/*===================================================
	 *	코스 수강 목록 추가
	 ===================================================*/
	@RequestMapping(value = "/course/myCourseSelect")
	@ResponseBody
	public Response<Object> myCourseSelect(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		// 사용자 아이디
		String cookieUserId = HttpUtil.get(request, "userId", "");
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		if (!StringUtil.isEmpty(cookieUserId) && courseCode != 0) {
			if (courseService.myCourseSelect(cookieUserId, courseCode) == 0) {
				res.setResponse(0, "error");
			} else if (courseService.myCourseSelect(cookieUserId, courseCode) == 1) {
				res.setResponse(1, "error");
			} else
				res.setResponse(-99, "error");
		} else
			res.setResponse(-99, "error");

		return res;
	}

	/*===================================================
	 *	코스 수강 목록 추가
	 ===================================================*/
	@RequestMapping(value = "/course/myCourseInsert")
	@ResponseBody
	public Response<Object> myCourseInsert(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> res = new Response<Object>();
		// 사용자 아이디
		String cookieUserId = HttpUtil.get(request, "userId", "");
		// 코스 번호
		long courseCode = HttpUtil.get(request, "courseCode", 0);

		if (!StringUtil.isEmpty(cookieUserId) && courseCode != 0) {
			if (courseService.myCourseSelect(cookieUserId, courseCode) <= 0) {
				if (courseService.myCourseInsert(cookieUserId, courseCode) > 0)
					res.setResponse(0, "success");
				else
					res.setResponse(-99, "error");
			} else
				res.setResponse(-99, "error");
		} else
			res.setResponse(-99, "error");

		return res;
	}

	/*===================================================
	 *	강의 페이지 화면
	 ===================================================*/
	@RequestMapping(value = "/course/lecturePlay")
	public String lecturePlay(ModelMap model, HttpServletRequest request, HttpServletResponse response, @RequestParam String fileName) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 사용자 등급
		String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");

		// 쿠키값이 존재하는 사용자인지 확인
		Account account = null;

		if (StringUtil.equals(cookieRating, "U")) {
			account = accountService.userSelect(cookieUserId);

			if (account != null && !StringUtil.isEmpty(fileName)) {
				// 시청 중인 강의인지 확인
				Lecture search = new Lecture();
				search.setUserId(cookieUserId);
				search.setFileName(fileName);

				if (courseService.myLectureCntSelect(search) > 0) {
					// 시청 중인 강의라면 해당 정보를 가져옴
					Lecture lecture = courseService.myLectureSelect(search);

					model.addAttribute("lecture", lecture);
				}
			}
		}

		return "/course/lecturePlay";
	}

	/*===================================================
	 *	강의 시간 저장
	 ===================================================*/
	@RequestMapping(value = "/course/saveWatchTime")
	public ResponseEntity<String> saveWatchTime(@RequestBody WatchTimeRequest watchTimeRequest, HttpServletRequest request,
			HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 사용자 등급
		String cookieRating = CookieUtil.getHexValue(request, AUTH_COOKIE_RATE, "");
		// 강의명
		String fileName = watchTimeRequest.getFileName();
		// 총 강의 시간
		double currentTime = watchTimeRequest.getCurrentTime();
		// 시청한 시간
		double durationTime = watchTimeRequest.getDuration();

		// 쿠키값이 존재하는 사용자인지 확인
		Account account = null;

		if (StringUtil.equals(cookieRating, "U")) {
			account = accountService.userSelect(cookieUserId);

			if (account != null) {
				Lecture lecture = new Lecture();

				lecture.setUserId(cookieUserId);
				lecture.setFileName(fileName);
				lecture.setCurrentTime(currentTime);
				lecture.setDurationTime(durationTime);
				lecture.setProgress((int) ((lecture.getCurrentTime() / lecture.getDurationTime()) * 100));

				if (courseService.myLectureCntSelect(lecture) > 0)
					courseService.myLectureUpdate(lecture);
				else
					courseService.myLectureInsert(lecture);
			}
		}

		// 시청 시간
		System.out.println("File: " + fileName + ", Watched: " + currentTime + " / " + durationTime);

		// 성공적으로 처리된 경우 200 상태 코드 반환
		return ResponseEntity.ok("Watch time saved");
	}

	/*===================================================
	 *	코스 수강 목록 추가
	 *  (참고 사이트 : https://www.digitalocean.com/community/tutorials/java-zip-file-folder-example)
	 ===================================================*/
	@RequestMapping(value = "/course/downloadSelectedFiles")
	@ResponseBody
	public void downloadSelectedFiles(@RequestBody List<String> fileNames, HttpServletRequest request, HttpServletResponse response) {

		String zipFile = "lecture.zip";

		try {
			// HTTP 응답 헤더 설정
			response.setContentType("application/zip");
			response.setHeader("Content-Disposition", "attachment; filename=\"" + URLEncoder.encode(zipFile, "UTF-8") + "\"");

			// ZIP 파일 생성
			try (OutputStream out = response.getOutputStream(); ZipOutputStream zipOut = new ZipOutputStream(out)) {

				for (String fileName : fileNames) {
					File file = new File(LECTURE_SAVE_DIR + fileName + ".mp4");
					logger.debug(":::" + file);

					if (file.exists()) {
						try (FileInputStream fis = new FileInputStream(file)) {
							ZipEntry zipEntry = new ZipEntry(fileName + ".mp4");
							zipOut.putNextEntry(zipEntry);

							// 파일 내용을 ZIP에 쓰기
							byte[] buffer = new byte[1024];
							int length;
							while ((length = fis.read(buffer)) >= 0) {
								zipOut.write(buffer, 0, length);
							}
							zipOut.closeEntry();
							fis.close();
						}
					} else {
						System.out.println("파일이 존재하지 않습니다: " + fileName);
					}
				}
				zipOut.finish(); // ZIP 파일 종료
				zipOut.close();
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/*===================================================
		 *	강의 등록
		 ===================================================*/
	@RequestMapping(value = "/course/lectureInsert")
	@ResponseBody
	public Response<Object> lectureInsert(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String teacherId = HttpUtil.get(request, "teacherId", "");
		String lectureName = HttpUtil.get(request, "lectureName", "");
		long courseCode = HttpUtil.get(request, "courseCode", (long) 1);
		int fileCount = courseService.insertedLectureCnt(courseCode);

		String fileName = courseCode + String.format("%02d", fileCount + 1);

		FileData fileData = HttpUtil.getFile(request, "fileName", 1, fileName, LECTURE_SAVE_DIR);

		if (!StringUtil.isEmpty(cookieUserId)) {
			if (StringUtil.equals(teacherId, cookieUserId)) {
				if (!StringUtil.isEmpty(courseCode) && !StringUtil.isEmpty(lectureName) && fileData != null && fileData.getFileSize() > 0) {
					int count = courseService.insertLecture(courseCode, lectureName, fileName);

					if (count > 0) {
						ajaxResponse.setResponse(0, "success");
					} else {
						ajaxResponse.setResponse(100, "insert error");
					}
				} else {
					ajaxResponse.setResponse(-401, "parameter error");
				}
			} else {
				ajaxResponse.setResponse(-400, "no access");
			}
		} else {
			ajaxResponse.setResponse(-101, "login first");
		}

		return ajaxResponse;
	}

	/*===================================================
	 *	강의 삭제
	 
	@RequestMapping(value="/course/lectureDel")
	@ResponseBody
	public Response<Object> lectureDel(@RequestBody List<String> lectureList, HttpServletRequest request)
	{
		Response<Object> ajaxResponse = new Response<Object>();
		
		boolean allDeleted = true;
		StringBuilder failedfileName = new StringBuilder();
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String teacherId = HttpUtil.get(request, "teacherId", "");
		
		//업로드된 파일의 경로 설정
		String uploadDir =  "/WEB-INF/views/resources/video/lecture/";
		String realPath = request.getServletContext().getRealPath(uploadDir); //실제파일경로
		
		if(!StringUtil.isEmpty(cookieUserId))
		{
			
			
			
					for(String fileName : lectureList)
					{
						//DB에서 삭제
						int result = courseService.delLecture(fileName);
						
						//첨부파일 삭제
						File file = new File(realPath + fileName + ".mp4");
						boolean fileDeleted = false;
						
			            try 
			            {
			                if (file.exists()) 
			                {
			                    fileDeleted = file.delete();
			                    if (!fileDeleted) 
			                    {
			                        throw new IOException("파일 삭제 실패: " + file.getAbsolutePath());
			                    }
			                } 
			                else 
			                {
			                    logger.debug("파일이 존재하지 않음");
			                }
			            } 
			            catch (Exception e) 
			            {
			                allDeleted = false;
			                logger.debug("첨부파일 삭제 오류");
			            }
						
						if(result == 0 || !fileDeleted)
						{
							allDeleted = false;
							failedfileName.append(fileName).append(", ");
						}
					}
			
					
					
					
					
			if(allDeleted)
			{
				ajaxResponse.setResponse(0, "success");
			}
			else
			{
				ajaxResponse.setResponse(100, "일부 쪽지 삭제" + failedfileName);
			}
		}
		else
		{
			ajaxResponse.setResponse(-400, "삭제권한 없음");
		}
	
		
		
		return ajaxResponse;
	}
	
	===================================================*/

	/*===================================================
	 *	강의 수정
	 ===================================================*/
	@RequestMapping(value = "/course/lectureUpdate")
	@ResponseBody
	public Response<Object> lectureUpdate(MultipartHttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		String teacherId = HttpUtil.get(request, "teacherId", "");
		String lectureName = HttpUtil.get(request, "lectureName1", "");
		long courseCode = HttpUtil.get(request, "courseCode", (long) 1);
		String fileName = HttpUtil.get(request, "_fileName2", ""); // 저장해야햘 파일 이름

		FileData fileData = HttpUtil.getFile(request, "_fileName", 1, fileName, LECTURE_SAVE_DIR);

		logger.debug("fileName : " + fileName);
		logger.debug("lectureName : " + lectureName);

		Lecture lecture = new Lecture();

		if (!StringUtil.isEmpty(cookieUserId)) {
			if (StringUtil.equals(teacherId, cookieUserId)) {
				if (!StringUtil.isEmpty(courseCode) && !StringUtil.isEmpty(lectureName) && fileData != null && fileData.getFileSize() > 0) {
					lecture.setCourseCode(courseCode);
					lecture.setLectureName(lectureName);
					lecture.setFileName(fileName);

					int count = courseService.updateLec(lecture);

					if (count > 0) {
						ajaxResponse.setResponse(0, "success");
					} else {
						ajaxResponse.setResponse(100, "update error");
					}
				} else {
					ajaxResponse.setResponse(-401, "parameter error");
				}
			} else {
				ajaxResponse.setResponse(-400, "no access");
			}
		} else {
			ajaxResponse.setResponse(-101, "login first");
		}

		return ajaxResponse;
	}

	// 모든 강좌 페이지로 이동
	@RequestMapping(value = "/course/allCourse")
	public String allCourse(ModelMap model, HttpServletRequest request, HttpServletResponse response) {

		// 사용자 아이디
		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME, "");
		// 과목 코드
		int classCode = HttpUtil.get(request, "classCode", 1);
		// 현재 페이지
		int curPage = HttpUtil.get(request, "curPage", 1);
		// 인기 코스 리스트 객체
		List<Course> listPopular = null;
		// 후기 코스 리스트 객체
		List<Course> listReview = null;
		// 모든 강좌 리스트 객체
		List<Course> list = null;
		// 모든 강좌 수
		long totalCount = 0;
		// 코스 검색 객체
		Course search = new Course();
		// 페이징 객체
		Paging paging = null;

		// 로그인 여부 확인
		Account account;

		if (!StringUtil.isEmpty(cookieUserId)) {
			account = accountService.userSelect(cookieUserId);
		} else {
			account = null;
		}

		model.addAttribute("account", account);

		search.setStartRow(1);
		search.setEndRow(5);

		// 인기 코스 리스트
		search.setCourseStatus("popular");
		listPopular = courseService.allCourseListSelect(search);
		for (int i = 0; i < listPopular.size(); i++) {
			listPopular.get(i).setClassName(className(listPopular.get(i).getClassCode()));
		}

		// 후기 코스 리스트
		search.setCourseStatus("review");
		listReview = courseService.allCourseListSelect(search);
		for (int i = 0; i < listReview.size(); i++) {
			listReview.get(i).setClassName(className(listReview.get(i).getClassCode()));
		}

		// 모든 강좌 리스트
		totalCount = courseService.allCourseClassListCntSelect(classCode);

		if (totalCount > 0) {
			paging = new Paging("/course/allCourse", totalCount, 10, 5, curPage, "curPage");

			search.setStartRow(paging.getStartRow());
			search.setEndRow(paging.getEndRow());
			search.setClassCode(classCode);

			list = courseService.allCourseClassListSelect(search);
		}

		model.addAttribute("listPopular", listPopular);
		model.addAttribute("listReview", listReview);
		model.addAttribute("list", list);
		model.addAttribute("paging", paging);
		model.addAttribute("curPage", curPage);
		model.addAttribute("classCode", classCode);
		model.addAttribute("className", className(classCode));

		return "/course/allCourse";
	}
}
