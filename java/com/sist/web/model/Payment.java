package com.sist.web.model;

import java.io.Serializable;

public class Payment implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long paySeq;
	private long orderSeq;
	private String userId;
	private int payPrice;
	private String payDate;
	private String tid;
	private String payStatus;
	
	public Payment() {
		paySeq = 0;
		orderSeq = 0;
		userId = "";
		payPrice = 0; 
		payDate = "";
		tid = "";
		payStatus = "";
	}

	public long getPaySeq() {
		return paySeq;
	}

	public long getOrderSeq() {
		return orderSeq;
	}

	public String getUserId() {
		return userId;
	}

	public int getPayPrice() {
		return payPrice;
	}

	public String getPayDate() {
		return payDate;
	}

	public String getTid() {
		return tid;
	}

	public String getPayStatus() {
		return payStatus;
	}

	public void setPaySeq(long paySeq) {
		this.paySeq = paySeq;
	}

	public void setOrderSeq(long orderSeq) {
		this.orderSeq = orderSeq;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setPayPrice(int payPrice) {
		this.payPrice = payPrice;
	}

	public void setPayDate(String payDate) {
		this.payDate = payDate;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}
	
	
	
}
