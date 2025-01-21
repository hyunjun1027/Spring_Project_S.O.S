package com.sist.web.model;

import java.io.Serializable;

public class OrderStatus implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String orderStatus;
	private String payStatus;
	private String dlvStatus;
	
	public OrderStatus() {
		orderStatus = "";
		payStatus = "";
		dlvStatus = "";
	}

	public String getOrderStatus() {
		return orderStatus;
	}

	public String getPayStatus() {
		return payStatus;
	}

	public String getDlvStatus() {
		return dlvStatus;
	}

	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}

	public void setDlvStatus(String dlvStatus) {
		this.dlvStatus = dlvStatus;
	}


}
