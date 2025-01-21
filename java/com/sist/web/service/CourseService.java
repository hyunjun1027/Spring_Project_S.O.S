package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.CourseDao;
import com.sist.web.model.Course;
import com.sist.web.model.Lecture;

@Service("courseService")
public class CourseService {

	private static Logger logger = LoggerFactory.getLogger(CourseService.class);

	@Autowired
	private CourseDao courseDao;

	// 코스 상세조회
	public Course courseSelect(long courseCode) {
		Course course = null;

		try {
			course = courseDao.courseSelect(courseCode);
		} catch (Exception e) {
			logger.error("[CourseService] courseSelect Exception", e);
		}

		return course;
	}

	// 강의 목록 조회
	public List<Lecture> lectureListSelect(Lecture lecture) {
		List<Lecture> list = null;

		try {
			list = courseDao.lectureListSelect(lecture);
		} catch (Exception e) {
			logger.error("[CourseService] lectureListSelect Exception", e);
		}

		return list;
	}

	// 시청 중인 강의 select
	public Lecture myLectureSelect(Lecture search) {
		Lecture lecture = null;

		try {
			lecture = courseDao.myLectureSelect(search);
		} catch (Exception e) {
			logger.error("[CourseService] myLectureSelect Exception", e);
		}

		return lecture;
	}

	// 시청 중인 강의 select (존재 여부)
	public int myLectureCntSelect(Lecture lecture) {
		int count = 0;

		try {
			count = courseDao.myLectureCntSelect(lecture);
		} catch (Exception e) {
			logger.error("[CourseService] myLectureCntSelect Exception", e);
		}

		return count;
	}

	// 시청 중인 강의 insert
	public int myLectureInsert(Lecture lecture) {
		int count = 0;

		try {
			count = courseDao.myLectureInsert(lecture);
		} catch (Exception e) {
			logger.error("[CourseService] myLectureInsert Exception", e);
		}

		return count;
	}

	// 시청 중인 강의 update
	public int myLectureUpdate(Lecture lecture) {
		int count = 0;

		try {
			count = courseDao.myLectureUpdate(lecture);
		} catch (Exception e) {
			logger.error("[CourseService] myLectureUpdate Exception", e);
		}

		return count;
	}

	// 완료된 강의 수 조회
	public int finishLectureCntSelect(Lecture lecture) {
		int count = 0;

		try {
			count = courseDao.finishLectureCntSelect(lecture);
		} catch (Exception e) {
			logger.error("[CourseService] finishLectureCntSelect Exception", e);
		}

		return count;
	}

	// 코스 수강 여부 조회
	public int myCourseSelect(String userId, long courseCode) {
		int count = 0;

		try {
			count = courseDao.myCourseSelect(userId, courseCode);
		} catch (Exception e) {
			logger.error("[CourseService] myCourseSelect Exception", e);
		}

		return count;
	}

	// 모든 코스 수강 개수 조회
	public int myCourseAllSelect(String userId) {
		int count = 0;

		try {
			count = courseDao.myCourseAllSelect(userId);
		} catch (Exception e) {
			logger.error("[CourseService] myCourseAllSelect Exception", e);
		}

		return count;
	}

	// 코스 수강 목록 추가
	public int myCourseInsert(String userId, long courseCode) {
		int count = 0;

		try {
			count = courseDao.myCourseInsert(userId, courseCode);
		} catch (Exception e) {
			logger.error("[CourseService] myCourseInsert Exception", e);
		}

		return count;
	}

	// 수강 중인 코스 수 조회 (select)
	public int myCourseIngSelect(String userId) {
		int count = 0;

		try {
			count = courseDao.myCourseIngSelect(userId);
		} catch (Exception e) {
			logger.error("[CourseService] myCourseIngSelect Exception", e);
		}

		return count;
	}

	// 수강 완료 코스 수 조회 (select)
	public int myCourseFinSelect(String userId) {
		int count = 0;

		try {
			count = courseDao.myCourseFinSelect(userId);
		} catch (Exception e) {
			logger.error("[CourseService] myCourseFinSelect Exception", e);
		}

		return count;
	}

	// 수강 코스 개수 조회
	public int mypageCourseListCntSelect(String userId) {
		int count = 0;

		try {
			count = courseDao.mypageCourseListCntSelect(userId);
		} catch (Exception e) {
			logger.error("[CourseService] mypageCourseListCntSelect Exception", e);
		}

		return count;
	}

	// 최신 수강한 코스 list 조회 (select)
	public List<Course> mypageCourseListSelect(Course search) {
		List<Course> course = null;

		try {
			course = courseDao.mypageCourseListSelect(search);
		} catch (Exception e) {
			logger.error("[CourseService] mypageCourseListSelect Exception", e);
		}

		return course;
	}

	// 등록 강의수 카운트
	public int insertedLectureCnt(long courseCode) {
		int count = 0;

		try {
			count = courseDao.insertedLectureCnt(courseCode);

		} catch (Exception e) {
			logger.error("[CourseService] insertedLectureCnt Exception", e);
		}

		return count;
	}

	// 강의 등록
	public int insertLecture(long courseCode, String lectureName, String fileName) {
		int count = 0;

		try {
			count = courseDao.insertLecture(courseCode, lectureName, fileName);
		} catch (Exception e) {
			logger.error("[CourseService] insertLecture Exception", e);
		}

		return count;
	}

	// 강의 삭제
	public int delLecture(String fileName) {
		int count = 0;

		try {
			count = courseDao.delLecture(fileName);
		} catch (Exception e) {
			logger.error("[CourseService] delLecture Exception", e);
		}

		return count;
	}

	// 강의 조회
	public Lecture selectLec(String fileName) {
		Lecture lecture = null;

		try {
			lecture = courseDao.selectLec(fileName);
		} catch (Exception e) {
			logger.error("[CourseService] selectLec Exception", e);
		}

		return lecture;
	}

	// 강의 수정
	public int updateLec(Lecture lecture) {
		int count = 0;

		try {
			count = courseDao.updateLec(lecture);
		} catch (Exception e) {
			logger.error("[CourseService] updateLec Exception", e);
		}

		return count;
	}

	// MAX 강의파일이름 구하기
	public Lecture maxFileName(long courseCode) {
		Lecture lecture = null;

		try {
			lecture = courseDao.maxFileName(courseCode);
		} catch (Exception e) {
			logger.error("[CourseService] maxFileName Exception", e);
		}

		return lecture;
	}

	// 수강신청한 코스 중 수강 중인 강의 수 조회
	public int mycourseLectureSelect(Course course) {
		int count = 0;

		try {
			count = courseDao.mycourseLectureSelect(course);
		} catch (Exception e) {
			logger.error("[CourseService] mycourseLectureSelect Exception", e);
		}

		return count;
	}

	// 마이페이지 수강 취소
	public int mycourseDelete(Course course) {
		int count = 0;

		try {
			count = courseDao.mycourseDelete(course);
		} catch (Exception e) {
			logger.error("[CourseService] mycourseDelete Exception", e);
		}

		return count;
	}

	// 모든 강좌 페이지 인기/후기순 LIST 조회
	public List<Course> allCourseListSelect(Course course) {
		List<Course> list = null;

		try {
			list = courseDao.allCourseListSelect(course);
		} catch (Exception e) {
			logger.error("[CourseService] allCourseListSelect Exception", e);
		}

		return list;
	}

	// 모든 강좌 LIST COUNT 조회
	public int allCourseClassListCntSelect(int classCode) {
		int count = 0;

		try {
			count = courseDao.allCourseClassListCntSelect(classCode);
		} catch (Exception e) {
			logger.error("[CourseService] allCourseClassListCntSelect Exception", e);
		}

		return count;
	}

	// 모든 강좌 LIST 조회
	public List<Course> allCourseClassListSelect(Course course) {
		List<Course> list = null;

		try {
			list = courseDao.allCourseClassListSelect(course);
		} catch (Exception e) {
			logger.error("[CourseService] allCourseClassListSelect Exception", e);
		}

		return list;
	}

	// 강사의 총 강의 수 조회
	public int teachLectureCnt(String userId) {
		int count = 0;

		try {
			count = courseDao.teachLectureCnt(userId);
		} catch (Exception e) {
			logger.error("[CourseService] teachLectureCnt Exception", e);
		}

		return count;
	}
}
