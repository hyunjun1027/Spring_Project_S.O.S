package com.sist.web.service;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.TeachDao;
import com.sist.web.model.Course;
import com.sist.web.model.Teacher;

@Service("teachService")
public class TeachService {

	private static Logger logger = LoggerFactory.getLogger(TeachService.class);

	@Autowired
	private TeachDao teachDao;

	// 강사 목록 조회
	public List<Teacher> teacherListSelect(int classCode) {
		List<Teacher> list = new ArrayList<Teacher>();

		try {
			list = teachDao.teacherListSelect(classCode);
		} catch (Exception e) {
			logger.error("[TeachService] teacherListSelect Exception", e);
		}

		return list;
	}

	// 강사 수 조회
	public long teacherListCount(int classCode) {
		long totalCount = 0;

		try {
			totalCount = teachDao.teacherListCount(classCode);
		} catch (Exception e) {
			logger.error("[TeachService] teacherListCount Exception", e);
		}

		return totalCount;
	}

	// 강사 조회
	public Teacher teacherSelect(String teacherId) {
		Teacher teacher = new Teacher();

		try {
			teacher = teachDao.teacherSelect(teacherId);
		} catch (Exception e) {
			logger.error("[TeachService] teacherSelect Exception", e);
		}

		return teacher;
	}

	// 강사 코스 수 조회
	public int teacherCourseCnt(String teacherId) {
		int totalCount = 0;

		try {
			totalCount = teachDao.teacherCourseCnt(teacherId);
		} catch (Exception e) {
			logger.error("[TeachService] teacherCourseCnt Exception", e);
		}

		return totalCount;
	}

	// 강사 코스 리스트 조회
	public List<Course> teacherCourseListSelect(Course search) {
		List<Course> list = null;

		try {
			list = teachDao.teacherCourseListSelect(search);
		} catch (Exception e) {
			logger.error("[TeachService] teacherCourseListSelect Exception", e);
		}

		return list;
	}

	// 강사 최신 코스 리스트 조회
	public List<Course> teacherRecentCourseListSelect(String teacherId) {
		List<Course> list = null;

		try {
			list = teachDao.teacherRecentCourseListSelect(teacherId);
		} catch (Exception e) {
			logger.error("[TeachService] teacherRecentCourseListSelect Exception", e);
		}

		return list;
	}

	// 강사 인기 코스 리스트 조회
	public List<Course> teacherPopularCourseListSelect(String teacherId) {
		List<Course> list = null;

		try {
			list = teachDao.teacherPopularCourseListSelect(teacherId);
		} catch (Exception e) {
			logger.error("[TeachService] teacherPopularCourseListSelect Exception", e);
		}

		return list;
	}

	// 강사 정보 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int teachUpdate(Teacher teacher) throws Exception {
		int count = 0;

		count = teachDao.teachUpdate(teacher);

		return count;
	}

	// 강사 코스 등록
	public int courseInsert(Course course) {
		int count = 0;

		try {
			count = teachDao.courseInsert(course);
		} catch (Exception e) {
			logger.error("[TeachService] courseInsert Exception", e);
		}

		return count;
	}

	// 코스 삭제
	public int courseDel(long courseCode) {
		int count = 0;

		try {
			count = teachDao.courseDel(courseCode);
		} catch (Exception e) {
			logger.error("[TeachService] courseDel Exception", e);
		}

		return count;
	}

	// 코스 조회
	public Course courseSelect(long courseCode) {
		Course course = null;

		try {
			course = teachDao.courseSelect(courseCode);
		} catch (Exception e) {
			logger.error("[TeachService] courseSelect Exception", e);
		}

		return course;
	}

}
