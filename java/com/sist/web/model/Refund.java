package com.sist.web.model;

import java.io.Serializable;

public class Refund implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long refSeq;
	private long orderSeq;
	private String userId;
	private int refPrice;
	private String refDate;
	private String refCompDate;
	private String refStatus;		// N : 환불미완료, Y : 환불완료
	
	public Refund() {
		refSeq = 0;
		orderSeq = 0;
		userId = "";
		refPrice = 0;
		refDate = "";
		refCompDate = "";
		refStatus = "";
	}

	public long getRefSeq() {
		return refSeq;
	}

	public long getOrderSeq() {
		return orderSeq;
	}

	public String getUserId() {
		return userId;
	}

	public int getRefPrice() {
		return refPrice;
	}

	public String getRefDate() {
		return refDate;
	}

	public String getRefCompDate() {
		return refCompDate;
	}

	public String getRefStatus() {
		return refStatus;
	}

	public void setRefSeq(long refSeq) {
		this.refSeq = refSeq;
	}

	public void setOrderSeq(long orderSeq) {
		this.orderSeq = orderSeq;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setRefPrice(int refPrice) {
		this.refPrice = refPrice;
	}

	public void setRefDate(String refDate) {
		this.refDate = refDate;
	}

	public void setRefCompDate(String refCompDate) {
		this.refCompDate = refCompDate;
	}

	public void setRefStatus(String refStatus) {
		this.refStatus = refStatus;
	}
	
	

}
