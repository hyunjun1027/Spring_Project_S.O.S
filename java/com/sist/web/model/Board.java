package com.sist.web.model;

import java.io.Serializable;

public class Board implements Serializable 
{
   private static final long serialVersionUID = 1L;
   
   private long brdSeq;         //게시물 번호
   private String userId;         //회원 아이디
   private String brdTitle;      //게시물 제목
   private String brdContent;      //게시물 내용
   private int brdReadCnt;         //게시물 조회수
   private String brdSecret;      //비밀번호
   private String regDate;         //게시물 작성일
   private String modDate;         //게시물 수정일
   private String delDate;         //게시물 삭제일
   private int category;         //카테고리
   
   private String userName;         //사용자명
   private String userEmail;         //사용자 이메일
   
   private String searchType;         //검색타입 (1:이름, 2:제목, 3:내용)
   private String searchValue;         //검샏 값
   
   private long startRow;            //시작페이지 rownum
   private long endRow;            //끝페이지 rownum
   
   private BoardLike BoardLike;      //좋아요
   private BoardFile BoardFile;      //첨부파일
   private BoardMark BoardMark;      //북마크
   
   private int boardLikeCount;        // 좋아요 수
   private int boardCommCount;		  // 댓글 수
   private int options;
   private String userProfile;
   
   public Board()
   {
      brdSeq = 0;
      userId = "";
      brdTitle = "";
      brdContent = "";
      brdReadCnt = 0;
      brdSecret = "";
      regDate = "";
      modDate = "";
      delDate = "";
      category = 0;
      
      userName = "";
      userEmail = "";
      
      searchType = "";
      searchValue = "";
      
      startRow = 0;
      endRow = 0;
      
      BoardFile = null;
      BoardMark = null;
      
      boardLikeCount = 0;
      boardCommCount = 0;
      options = 0;
      userProfile = "";
   }

   public long getBrdSeq() {
      return brdSeq;
   }

   public void setBrdSeq(long brdSeq) {
      this.brdSeq = brdSeq;
   }

   public String getUserId() {
      return userId;
   }

   public void setUserId(String userId) {
      this.userId = userId;
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

   public String getBrdSecret() {
      return brdSecret;
   }

   public void setBrdSecret(String brdSecret) {
      this.brdSecret = brdSecret;
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

   public int getCategory() {
      return category;
   }

   public void setCategory(int category) {
      this.category = category;
   }

   public String getUserName() {
      return userName;
   }

   public void setUserName(String userName) {
      this.userName = userName;
   }

   public String getUserEmail() {
      return userEmail;
   }

   public void setUserEmail(String userEmail) {
      this.userEmail = userEmail;
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

   public BoardLike getBoardLike() {
      return BoardLike;
   }

   public void setBoardLike(BoardLike boardLike) {
      BoardLike = boardLike;
   }

   public BoardFile getBoardFile() {
      return BoardFile;
   }

   public void setBoardFile(BoardFile boardFile) {
      BoardFile = boardFile;
   }

   public BoardMark getBoardMark() {
      return BoardMark;
   }

   public void setBoardMark(BoardMark boardMark) {
      BoardMark = boardMark;
   }

   public int getBoardLikeCount() {
      return boardLikeCount;
   }

   public void setBoardLikeCount(int boardLikeCount) {
      this.boardLikeCount = boardLikeCount;
   }

   public int getOptions() {
      return options;
   }

   public void setOptions(int options) {
      this.options = options;
   }

	public String getUserProfile() {
		return userProfile;
	}
	
	public void setUserProfile(String userProfile) {
		this.userProfile = userProfile;
	}

	public int getBoardCommCount() {
		return boardCommCount;
	}

	public void setBoardCommCount(int boardCommCount) {
		this.boardCommCount = boardCommCount;
	}
	
	
   
}
