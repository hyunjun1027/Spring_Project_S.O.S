package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Course;
import com.sist.web.model.Teacher;

@Repository("teachDao")
public interface TeachDao {
	// 강사 조회(select)
	public List<Teacher> teacherListSelect(int classCode);

	// 강사 수 조회(select)
	public long teacherListCount(int classCode);

	// 강사 조회(select)
	public Teacher teacherSelect(String teacherId);

	// 강사 코스 수 조회(select)
	public int teacherCourseCnt(String teacherId);

	// 강사 코스 리스트 조회(select)
	public List<Course> teacherCourseListSelect(Course search);

	// 강사 최신 코스 리스트 조회(select)
	public List<Course> teacherRecentCourseListSelect(String teacherId);

	// 강사 인기 코스 리스트 조회(select)
	public List<Course> teacherPopularCourseListSelect(String teacherId);

	// 강사 정보 수정
	public int teachUpdate(Teacher teacher);

	// 강사 코스 등록
	public int courseInsert(Course course);

	// 강사 코스 삭제
	public int courseDel(long courseCode);

	// 코스 조회
	public Course courseSelect(long courseCode);
}
