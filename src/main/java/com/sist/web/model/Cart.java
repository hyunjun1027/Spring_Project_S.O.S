package com.sist.web.model;

import java.io.Serializable;

public class Cart implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private String userId;
	private long bookSeq;
	private long prdCnt;
	private String checked;
	
	private Book book;
	
	public Cart() {
		userId = "";
		bookSeq = 0;
		prdCnt = 0;
		checked = "N";
		book = null;
	}
	
	public Book getBook() {
		return book;
	}

	public void setBook(Book book) {
		this.book = book;
	}

	public String getChecked() {
		return checked;
	}

	public void setChecked(String checked) {
		this.checked = checked;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public long getBookSeq() {
		return bookSeq;
	}

	public void setBookSeq(long bookSeq) {
		this.bookSeq = bookSeq;
	}

	public long getPrdCnt() {
		return prdCnt;
	}

	public void setPrdCnt(long prdCnt) {
		this.prdCnt = prdCnt;
	}
	
}
