package com.sist.web.model;

import java.io.Serializable;

public class Note implements Serializable {

	private static final long serialVersionUID = 1L;

	private long noteSeq; 		// 쪽지번호
	private String userId; 		// 회원 아이디
	private String userName; 	// 회원 이름
	private String rating; 		// 회원 등급
	private String userIdGet; 	// 수신자
	private String userNameGet; // 수신자 이름
	private String ratingGet; 	// 수신자 회원 등급
	private String noteTitle; 	// 쪽지 제목
	private String noteContent; // 쪽지 내용
	private String regDate; 	// 쪽지 작성일
	private String delDate; 	// 쪽지 삭제일
	private String read; 		// 쪽지 읽음여부

	// 페이징 처리
	private long startRow; 		// 시작페이지 rownum
	private long endRow; 		// 끝페이지 rownum

	public Note() {
		noteSeq = 0;
		userId = "";
		userName = "";
		rating = "";
		userIdGet = "";
		userNameGet = "";
		ratingGet = "";
		noteTitle = "";
		noteContent = "";
		regDate = "";
		delDate = "";
		startRow = 0;
		endRow = 0;
		read = "N";
	}

	public String getRead() {
		return read;
	}

	public void setRead(String read) {
		this.read = read;
	}

	public String getDelDate() {
		return delDate;
	}

	public void setDelDate(String delDate) {
		this.delDate = delDate;
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

	public long getNoteSeq() {
		return noteSeq;
	}

	public void setNoteSeq(long noteSeq) {
		this.noteSeq = noteSeq;
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

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
	}

	public String getUserIdGet() {
		return userIdGet;
	}

	public void setUserIdGet(String userIdGet) {
		this.userIdGet = userIdGet;
	}

	public String getUserNameGet() {
		return userNameGet;
	}

	public void setUserNameGet(String userNameGet) {
		this.userNameGet = userNameGet;
	}

	public String getRatingGet() {
		return ratingGet;
	}

	public void setRatingGet(String ratingGet) {
		this.ratingGet = ratingGet;
	}

	public String getNoteTitle() {
		return noteTitle;
	}

	public void setNoteTitle(String noteTitle) {
		this.noteTitle = noteTitle;
	}

	public String getNoteContent() {
		return noteContent;
	}

	public void setNoteContent(String noteContent) {
		this.noteContent = noteContent;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}

}
