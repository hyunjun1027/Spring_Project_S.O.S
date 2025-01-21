package com.sist.web.model;

import java.io.Serializable;

public class Order implements Serializable {

	private static final long serialVersionUID = 1L;

	private long orderSeq;
	private String userId;
	private String orderName;
	private String orderPhone;
	private String orderDate;
	private String orderCancleDate;
	private int orderCnt;
	private int prdPrice;
	private int payPrice;
	private String orderStatus;
	private String payStatus;
	private String orderProName;
	private String tid;
	private String viewStatus;
	private String teacherId;
	private String userType;
	
	private long startRow;				
	private long endRow;

	private String searchOrderStatus;
	private String searchStartDate;
	private String searchEndDate;
	private long searchOrderSeq;
	private String dlvStatus;
	private String viewOrderDate;
	
	public Order() {
		orderSeq = 0;
		userId = "";
		orderName = "";
		orderPhone = "";
		orderDate = "";
		orderCancleDate = "";
		orderCnt = 0;
		prdPrice = 0;
		payPrice = 0;
		orderStatus = "";
		payStatus = "";
		orderProName = "";
		tid = "";
		viewStatus = "";
		teacherId = "";
		userType = "";
		
		startRow = 0;
		endRow = 0;
		
		searchOrderStatus = "";
		searchStartDate = "";
		searchEndDate = "";
		searchOrderSeq = 0;
		dlvStatus = "";
		viewOrderDate = "";
	}


	public long getOrderSeq() {
		return orderSeq;
	}


	public String getUserId() {
		return userId;
	}


	public String getOrderName() {
		return orderName;
	}


	public String getOrderPhone() {
		return orderPhone;
	}


	public String getOrderDate() {
		return orderDate;
	}


	public String getOrderCancleDate() {
		return orderCancleDate;
	}


	public int getOrderCnt() {
		return orderCnt;
	}


	public int getPrdPrice() {
		return prdPrice;
	}


	public int getPayPrice() {
		return payPrice;
	}


	public String getOrderStatus() {
		return orderStatus;
	}


	public String getPayStatus() {
		return payStatus;
	}


	public String getOrderProName() {
		return orderProName;
	}


	public void setOrderSeq(long orderSeq) {
		this.orderSeq = orderSeq;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public void setOrderName(String orderName) {
		this.orderName = orderName;
	}


	public void setOrderPhone(String orderPhone) {
		this.orderPhone = orderPhone;
	}


	public void setOrderDate(String orderDate) {
		this.orderDate = orderDate;
	}


	public void setOrderCancleDate(String orderCancleDate) {
		this.orderCancleDate = orderCancleDate;
	}


	public void setOrderCnt(int orderCnt) {
		this.orderCnt = orderCnt;
	}


	public void setPrdPrice(int prdPrice) {
		this.prdPrice = prdPrice;
	}


	public void setPayPrice(int payPrice) {
		this.payPrice = payPrice;
	}


	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}


	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}


	public void setOrderProName(String orderProName) {
		this.orderProName = orderProName;
	}


	public String getTid() {
		return tid;
	}


	public void setTid(String tid) {
		this.tid = tid;
	}


	public String getViewStatus() {
		return viewStatus;
	}


	public void setViewStatus(String viewStatus) {
		this.viewStatus = viewStatus;
	}

	public long getStartRow() {
		return startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}


	public String getTeacherId() {
		return teacherId;
	}


	public String getUserType() {
		return userType;
	}


	public void setTeacherId(String teacherId) {
		this.teacherId = teacherId;
	}


	public void setUserType(String userType) {
		this.userType = userType;
	}


	public String getSearchOrderStatus() {
		return searchOrderStatus;
	}


	public String getSearchStartDate() {
		return searchStartDate;
	}


	public String getSearchEndDate() {
		return searchEndDate;
	}


	public long getSearchOrderSeq() {
		return searchOrderSeq;
	}


	public void setSearchOrderStatus(String searchOrderStatus) {
		this.searchOrderStatus = searchOrderStatus;
	}


	public void setSearchStartDate(String searchStartDate) {
		this.searchStartDate = searchStartDate;
	}


	public void setSearchEndDate(String searchEndDate) {
		this.searchEndDate = searchEndDate;
	}


	public void setSearchOrderSeq(long searchOrderSeq) {
		this.searchOrderSeq = searchOrderSeq;
	}


	public String getDlvStatus() {
		return dlvStatus;
	}

	public void setDlvStatus(String dlvStatus) {
		this.dlvStatus = dlvStatus;
	}


	public String getViewOrderDate() {
		return viewOrderDate;
	}


	public void setViewOrderDate(String viewOrderDate) {
		this.viewOrderDate = viewOrderDate;
	}
	
	
	
}
