package com.sist.web.model;

import java.io.Serializable;

public class CourseList implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long brdSeq;
	private String brdTitle;
	private String brdContent;
	private int brdReadCnt;
	private String regDate;
	private String modDate;
	private String delDate;
	private long courseCode;
	private String userId;
	
	private String userName;
	private String courseName;
	private String status;
	private String rating;
	private String userEmail;
	
	private long brdParent;
	private long brdRating;				// 평점
	
	private long brdOrder;
	private long brdGroup;
	
	private long startRow;				// 시작 페이지 번호 rownum
	private long endRow;				// 마지막 페이지 번호 rownum
	
	private String searchType;			// 검색 타입 (1 : 이름, 2 : 제목, 3 : 내용)
	private String searchValue;			// 검색 값 
	
	private String myBrdChk;			// 내가 쓴 글 확인
	private String loginUserId;			// 로그인 유저 아이디
	private String teacherId;
	
	private boolean hasReply;        // 답변 여부
	
	private int classCode;
	
	
	private CourseListFile courseListFile;	// 파일
	private String userProfile;
	
	public CourseList() {
		brdSeq = 0;
		brdTitle = "";
		brdContent = "";
		brdReadCnt = 0;
		regDate = "";
		modDate = "";
		delDate = "";
		courseCode = 0;
		userId = "";
		
		userName = "";
			
		brdParent = 0;
		brdRating = 0;
		userEmail = "";
		
		startRow = 0;
		endRow = 0;
		
		searchType = "";
		searchValue = "";
		
		myBrdChk = "";
		loginUserId = "";
		teacherId = "";
		
		classCode = 0;
		
		courseListFile = null;
		userProfile = "";
		hasReply = false; 
	}
	
	
	public String getUserProfile() {
		return userProfile;
	}

	public void setUserProfile(String userProfile) {
		this.userProfile = userProfile;
	}

	public int getClassCode() {
		return classCode;
	}




	public void setClassCode(int classCode) {
		this.classCode = classCode;
	}




	public boolean isHasReply() {
		return hasReply;
	}



	public void setHasReply(boolean hasReply) {
		this.hasReply = hasReply;
	}



	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	public String getBrdTitle() {
		return brdTitle;
	}

	public void setBrdTitle(String brdTitle) {
		this.brdTitle = brdTitle;
	}

	public String getBrdContent() {
		return brdContent;
	}

	public void setBrdContent(String brdContent) {
		this.brdContent = brdContent;
	}

	public int getBrdReadCnt() {
		return brdReadCnt;
	}

	public void setBrdReadCnt(int brdReadCnt) {
		this.brdReadCnt = brdReadCnt;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getModDate() {
		return modDate;
	}

	public void setModDate(String modDate) {
		this.modDate = modDate;
	}

	public String getDelDate() {
		return delDate;
	}

	public void setDelDate(String delDate) {
		this.delDate = delDate;
	}

	public long getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(long courseCode) {
		this.courseCode = courseCode;
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

	public long getBrdParent() {
		return brdParent;
	}

	public void setBrdParent(long brdParent) {
		this.brdParent = brdParent;
	}

	public long getBrdRating() {
		return brdRating;
	}

	public void setBrdRating(long brdRating) {
		this.brdRating = brdRating;
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

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public String getCourseName() {
		return courseName;
	}

	public void setCourseName(String courseName) {
		this.courseName = courseName;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getMyBrdChk() {
		return myBrdChk;
	}

	public void setMyBrdChk(String myBrdChk) {
		this.myBrdChk = myBrdChk;
	}

	public String getLoginUserId() {
		return loginUserId;
	}

	public void setLoginUserId(String loginUserId) {
		this.loginUserId = loginUserId;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public CourseListFile getCourseListFile() {
		return courseListFile;
	}

	public void setCourseListFile(CourseListFile courseListFile) {
		this.courseListFile = courseListFile;
	}

	public String getTeacherId() {
		return teacherId;
	}

	public void setTeacherId(String teacherId) {
		this.teacherId = teacherId;
	}

	public long getBrdOrder() {
		return brdOrder;
	}

	public long getBrdGroup() {
		return brdGroup;
	}

	public void setBrdOrder(long brdOrder) {
		this.brdOrder = brdOrder;
	}

	public void setBrdGroup(long brdGroup) {
		this.brdGroup = brdGroup;
	}

	


	
	
	
	
	
		
}
