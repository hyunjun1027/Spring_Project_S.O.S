package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Course;
import com.sist.web.model.Lecture;

@Repository("courseDao")
public interface CourseDao {
	// 코스 상세조회 (select)
	public Course courseSelect(long courseCode);

	// 강의 목록 조회 (select)
	public List<Lecture> lectureListSelect(Lecture lecture);

	// 시청 중인 강의 (select)
	public Lecture myLectureSelect(Lecture lecture);

	// 시청 중인 강의 (select) (존재 여부)
	public int myLectureCntSelect(Lecture lecture);

	// 시청 중인 강의 (insert)
	public int myLectureInsert(Lecture lecture);

	// 시청 중인 강의 (update)
	public int myLectureUpdate(Lecture lecture);

	// 완료된 강의 수 조회 (select)
	public int finishLectureCntSelect(Lecture lecture);

	// 코스 수강 여부 조회 (select)
	public int myCourseSelect(@Param("userId") String userId, @Param("courseCode") long courseCode);

	// 모든 코스 수강 개수 조회 (select)
	public int myCourseAllSelect(String userId);

	// 코스 수강 목록 추가 (insert)
	public int myCourseInsert(@Param("userId") String userId, @Param("courseCode") long courseCode);

	// 수강 중인 코스 수 조회 (select)
	public int myCourseIngSelect(String userId);

	// 수강 완료 코스 수 조회 (select)
	public int myCourseFinSelect(String userId);

	// 수강 코스 개수
	public int mypageCourseListCntSelect(String userId);

	// MyPage 메인 화면 list 조회
	public List<Course> mypageCourseListSelect(Course course);

	// 등록 강의 수
	public int insertedLectureCnt(long courseCode);

	// 강의 등록
	public int insertLecture(@Param("courseCode") long courseCode, @Param("lectureName") String lectureName, @Param("fileName") String fileName);

	// 강의 삭제
	public int delLecture(String fileName);

	// 강의 조회
	public Lecture selectLec(String fileName);

	// 강의 수정
	public int updateLec(Lecture lecture);

	// MAX 강의파일이름 구하기
	public Lecture maxFileName(long courseCode);

	// 수강신청한 코스 중 수강 중인 강의 수 조회
	public int mycourseLectureSelect(Course course);

	// 마이페이지 수강 취소
	public int mycourseDelete(Course course);

	// 모든 강좌 페이지 인기/후기순 LIST 조회
	public List<Course> allCourseListSelect(Course course);

	// 모든 강좌 LIST COUNT 조회
	public int allCourseClassListCntSelect(int classCode);

	// 모든 강좌 LIST 조회
	public List<Course> allCourseClassListSelect(Course course);

	// 강사의 총 강의 수 조회
	public int teachLectureCnt(String userId);
}
