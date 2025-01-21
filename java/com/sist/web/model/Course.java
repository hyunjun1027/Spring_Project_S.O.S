package com.sist.web.model;

import java.io.Serializable;

public class Course implements Serializable {

	private static final long serialVersionUID = 1L;

	// 필드 선언
	private long courseCode; 		// 코스 코드
	private String courseName; 		// 코스명
	private String courseDetail; 	// 코스 상세 내용
	private int coursePrice; 		// 실제 코스 가격
	private int coursePayPrice; 	// 실제 결제 가격
	private String regDate; 		// 코스 등록일
	private String courseStatus; 	// 코스 상태
	private String userId; 			// 강사 아이디
	private String userName; 		// 강사 이름
	private long bookSeq; 			// 교재 번호
	private long lecCnt; 			// 강의 수

	private long finLecCnt; 		// 완료 강의 수
	private String playDate; 		// 마지막 수강일
	private double progress;		// 진행률
	private float reviewStar;		// 코스 평점
	private int reviewCnt;			// 코스 후기 개수

	private long startRow;			// 시작 Row
	private long endRow;			// 종료 Row
	private int classCode;
	private String className;

	private int myCourseChk;		// 로그인 한 사용자의 수강 중인 코스인지 체크

	// 기본 생성자
	public Course() {
		this.courseCode = 0;
		this.courseName = "";
		this.courseDetail = "";
		this.coursePrice = 0;
		this.coursePayPrice = 0;
		this.regDate = "";
		this.courseStatus = "";
		this.userId = "";
		this.userName = "";
		this.bookSeq = 0;
		this.lecCnt = 0;

		this.finLecCnt = 0;
		this.playDate = "";
		this.progress = 0;
		this.reviewStar = 0;
		this.reviewCnt = 0;

		this.startRow = 0;
		this.endRow = 0;
		this.classCode = 0;
		this.className = "";

		this.myCourseChk = 0;
	}

	public long getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(long courseCode) {
		this.courseCode = courseCode;
	}

	public String getCourseName() {
		return courseName;
	}

	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}

	public String getCourseDetail() {
		return courseDetail;
	}

	public void setCourseDetail(String courseDetail) {
		this.courseDetail = courseDetail;
	}

	public int getCoursePrice() {
		return coursePrice;
	}

	public void setCoursePrice(int coursePrice) {
		this.coursePrice = coursePrice;
	}

	public int getCoursePayPrice() {
		return coursePayPrice;
	}

	public void setCoursePayPrice(int coursePayPrice) {
		this.coursePayPrice = coursePayPrice;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getCourseStatus() {
		return courseStatus;
	}

	public void setCourseStatus(String courseStatus) {
		this.courseStatus = courseStatus;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public long getBookSeq() {
		return bookSeq;
	}

	public void setBookSeq(long bookSeq) {
		this.bookSeq = bookSeq;
	}

	public long getLecCnt() {
		return lecCnt;
	}

	public void setLecCnt(long lecCnt) {
		this.lecCnt = lecCnt;
	}

	public long getFinLecCnt() {
		return finLecCnt;
	}

	public void setFinLecCnt(long finLecCnt) {
		this.finLecCnt = finLecCnt;
	}

	public String getPlayDate() {
		return playDate;
	}

	public void setPlayDate(String playDate) {
		this.playDate = playDate;
	}

	public double getProgress() {
		return progress;
	}

	public void setProgress(double progress) {
		this.progress = progress;
	}

	public float getReviewStar() {
		return reviewStar;
	}

	public void setReviewStar(float reviewStar) {
		this.reviewStar = reviewStar;
	}

	public int getReviewCnt() {
		return reviewCnt;
	}

	public void setReviewCnt(int reviewCnt) {
		this.reviewCnt = reviewCnt;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}

	public int getClassCode() {
		return classCode;
	}

	public void setClassCode(int classCode) {
		this.classCode = classCode;
	}

	public String getClassName() {
		return className;
	}

	public void setClassName(String className) {
		this.className = className;
	}

	public int getMyCourseChk() {
		return myCourseChk;
	}

	public void setMyCourseChk(int myCourseChk) {
		this.myCourseChk = myCourseChk;
	}

}
