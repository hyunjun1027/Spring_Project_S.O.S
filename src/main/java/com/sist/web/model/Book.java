package com.sist.web.model;

import java.io.Serializable;

public class Book implements Serializable {

   private static final long serialVersionUID = 1L;

   private long bookSeq;
   private String bookTitle;
   private String bookInfo;
   private String bookAuth;
   private String bookPublisher;
   private int bookPrice;
   private int bookPayPrice;
   private int invenQtt;
   private String regDate;
   private String issueDate;
   private String bookStatus;
   private String classCode;
   
   private String searchType;   //검색타입
   private String searchValue;   //검색값
   
   //페이징 처리
    private long startRow;   //시작페이지 rownum
    private long endRow;   //끝페이지 rownum
    
    private String qttMgrChk;	// 재고관리 +/- 구분 (1:감소, 2:증가)
    private int qttVal;			// 관리할 재고 수량

   public Book() {
      bookSeq = 0;
      bookTitle = "";
      bookInfo = "";
      bookAuth = "";
      bookPublisher = "";
      bookPrice = 0;
      bookPayPrice = 0;
      invenQtt = 0;
      regDate = "";
      issueDate = "";
      bookStatus = "N";
      classCode = "1";
      searchType = "";
      searchValue = "";
      startRow = 0;
      endRow = 0;
      
      qttMgrChk = "";
      qttVal = 0;
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



   public long getBookSeq() {
      return bookSeq;
   }

   public void setBookSeq(long bookSeq) {
      this.bookSeq = bookSeq;
   }

   public String getBookTitle() {
      return bookTitle;
   }

   public void setBookTitle(String bookTitle) {
      this.bookTitle = bookTitle;
   }

   public String getBookInfo() {
      return bookInfo;
   }

   public void setBookInfo(String bookInfo) {
      this.bookInfo = bookInfo;
   }

   public String getBookAuth() {
      return bookAuth;
   }

   public void setBookAuth(String bookAuth) {
      this.bookAuth = bookAuth;
   }

   public String getBookPublisher() {
      return bookPublisher;
   }

   public void setBookPublisher(String bookPublisher) {
      this.bookPublisher = bookPublisher;
   }

   public int getBookPrice() {
      return bookPrice;
   }

   public void setBookPrice(int bookPrice) {
      this.bookPrice = bookPrice;
   }

   public int getBookPayPrice() {
      return bookPayPrice;
   }

   public void setBookPayPrice(int bookPayPrice) {
      this.bookPayPrice = bookPayPrice;
   }

   public int getInvenQtt() {
      return invenQtt;
   }

   public void setInvenQtt(int invenQtt) {
      this.invenQtt = invenQtt;
   }

   public String getRegDate() {
      return regDate;
   }

   public void setRegDate(String regDate) {
      this.regDate = regDate;
   }

   public String getIssueDate() {
      return issueDate;
   }

   public void setIssueDate(String issueDate) {
      this.issueDate = issueDate;
   }

   public String getBookStatus() {
      return bookStatus;
   }

   public void setBookStatus(String bookStatus) {
      this.bookStatus = bookStatus;
   }

   public String getClassCode() {
      return classCode;
   }

   public void setClassCode(String classCode) {
      this.classCode = classCode;
   }


	public String getQttMgrChk() {
		return qttMgrChk;
	}
	
	
	
	public int getQttVal() {
		return qttVal;
	}
	
	
	
	public void setQttMgrChk(String qttMgrChk) {
		this.qttMgrChk = qttMgrChk;
	}
	
	
	
	public void setQttVal(int qttVal) {
		this.qttVal = qttVal;
	}
   
   

}
