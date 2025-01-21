package com.sist.web.model;

import java.io.Serializable;

public class OrderDetail implements Serializable {

	private static final long serialVersionUID = 1L;

	private long orderDtSeq;
	private long orderSeq;
	private long bookSeq;
	private int prdPrice;
	private int orderCnt;
	private int payPrice;	// 실제 결제 금액
	private String proName;	// 주문 상품명
	
	
	public OrderDetail() {
		orderDtSeq = 0;
		orderSeq = 0;
		bookSeq = 0;
		prdPrice = 0;
		orderCnt = 0;
		payPrice = 0;
		proName = "";
	}


	public long getOrderDtSeq() {
		return orderDtSeq;
	}


	public long getOrderSeq() {
		return orderSeq;
	}


	public long getBookSeq() {
		return bookSeq;
	}


	public int getPrdPrice() {
		return prdPrice;
	}


	public int getOrderCnt() {
		return orderCnt;
	}


	public int getPayPrice() {
		return payPrice;
	}


	public void setOrderDtSeq(long orderDtSeq) {
		this.orderDtSeq = orderDtSeq;
	}


	public void setOrderSeq(long orderSeq) {
		this.orderSeq = orderSeq;
	}


	public void setBookSeq(long bookSeq) {
		this.bookSeq = bookSeq;
	}


	public void setPrdPrice(int prdPrice) {
		this.prdPrice = prdPrice;
	}


	public void setOrderCnt(int orderCnt) {
		this.orderCnt = orderCnt;
	}


	public void setPayPrice(int payPrice) {
		this.payPrice = payPrice;
	}


	public String getProName() {
		return proName;
	}

	public void setProName(String proName) {
		this.proName = proName;
	}
	
	
	
}
