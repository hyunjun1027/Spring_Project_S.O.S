package com.sist.web.model;

import java.io.Serializable;

public class Lecture implements Serializable {

	private static final long serialVersionUID = 1L;

	// 필드 선언
    private String fileName;    // 파일명
    private long courseCode;    // 코스 코드
    private String lectureName; // 강의명
    private String regDate;     // 등록일

    // 시청 중인 강의 정보
    private String userId;		// 사용자 아이디
    private double currentTime;	// 시청 시간
    private double durationTime;// 강의 시간
    private String playDate;	// 시청 날짜
    private int progress;		// 진행도

	// 기본 생성자
	public Lecture() {
		this.fileName = "";
		this.courseCode = 0;
		this.lectureName = "";
		this.regDate = "";
		
		this.userId = "";
		this.currentTime = 0;
		this.durationTime = 0;
		this.playDate = "";
		this.progress = 0;
	}

	public long getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(long courseCode) {
		this.courseCode = courseCode;
	}

	public String getLectureName() {
		return lectureName;
	}

	public void setLectureName(String lectureName) {
		this.lectureName = lectureName;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public double getCurrentTime() {
		return currentTime;
	}

	public void setCurrentTime(double currentTime) {
		this.currentTime = currentTime;
	}

	public double getDurationTime() {
		return durationTime;
	}

	public void setDurationTime(double durationTime) {
		this.durationTime = durationTime;
	}

	public String getPlayDate() {
		return playDate;
	}

	public void setPlayDate(String playDate) {
		this.playDate = playDate;
	}

	public int getProgress() {
		return progress;
	}

	public void setProgress(int progress) {
		this.progress = progress;
	}

}
