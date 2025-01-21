package com.sist.web.model;

import java.io.Serializable;

public class BoardNotice implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private long brdSeq;		//게시물 번호
	private String brdTitle;	//게시물 제목
	private String brdContent;	//게시물 내용
	private int brdReadCnt;		//게시물 조회수
	private String regDate;		//게시물 작성일
	private String modDate;		//게시물 수정일
	private String delDate;		//게시물 삭제일
	private String userId;		//관리자 아이디
	private String isMust;		//필독 여부
	
	private String searchType;		//검색타입 (1:이름, 2:제목, 3:내용)
	private String searchValue;		//검색값
	
	private String fileOrgName;		//원본파일명
	private String fileName;	    //서버파일명
	
	private long startRow;			//시작페이지 rownum
	private long endRow;			//끝페이지 rownum
	
	private String rating;
	
	private BoardNoticeFile boardNoticeFile;
	
	
	public BoardNotice() {
		brdSeq = 0;			//게시물 번호
		brdTitle = "";		//게시물 제목
		brdContent = "";	//게시물 내용
		brdReadCnt = 0;		//게시물 조회수
		regDate = "";		//게시물 작성일
		modDate = "";		//게시물 수정일
		delDate = "";		//게시물 삭제일
		userId = "";		//관리자 아이디
		isMust = "Y";		//필독 여부
		
		searchType = "";	//검색타입 (1:이름, 2:제목, 3:내용)
		searchValue = "";	//검색값
		
		fileOrgName = "";
		fileName = "";
		
		startRow = 0;		//시작페이지 rownum
		endRow = 0;			//끝페이지 rownum
		
		rating = "";
		
		boardNoticeFile = null;
		
	}
	
	
	

	public String getRating() {
		return rating;
	}




	public void setRating(String rating) {
		this.rating = rating;
	}




	public String getFileOrgName() {
		return fileOrgName;
	}



	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}



	public String getFileName() {
		return fileName;
	}



	public void setFileName(String fileName) {
		this.fileName = fileName;
	}



	public BoardNoticeFile getBoardNoticeFile() {
		return boardNoticeFile;
	}




	public void setBoardNoticeFile(BoardNoticeFile boardNoticeFile) {
		this.boardNoticeFile = boardNoticeFile;
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


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getIsMust() {
		return isMust;
	}


	public void setIsMust(String isMust) {
		this.isMust = isMust;
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
	
	
	
}
