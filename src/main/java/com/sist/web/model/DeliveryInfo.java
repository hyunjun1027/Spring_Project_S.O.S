package com.sist.web.model;

import java.io.Serializable;

public class DeliveryInfo implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long deliverySeq;		// 배송 번호
	private long orderSeq;			// 주문 번호
	private String userId;			// 회원 아이디
	private String userPhone;		// 회원 전화번호
	private String addrCode;		// 회원 우편번호
	private String addrBase;		// 회원 주소
	private String addrDetail;		// 회원 상세주소	
	private String dlvRequest;		// 배송 요청사항
	private String dlvStatus;		// 배송 상태
	private String dlvStartDate;	// 배송 시작 날짜
	private String dlvEndDate;		// 배송 완료 날짜
	private String dlvName;			// 수취인명
	
	public DeliveryInfo() {
		deliverySeq = 0;
		orderSeq = 0;
		userId = "";
		userPhone = "";
		addrCode = "";
		addrBase = "";
		addrDetail = "";
		dlvRequest = "";
		dlvStatus = "";
		dlvStartDate = "";
		dlvEndDate = "";
		dlvName = "";
	}

	public long getDeliverySeq() {
		return deliverySeq;
	}

	public long getOrderSeq() {
		return orderSeq;
	}

	public String getUserId() {
		return userId;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public String getAddrCode() {
		return addrCode;
	}

	public String getAddrBase() {
		return addrBase;
	}

	public String getAddrDetail() {
		return addrDetail;
	}

	public String getDlvRequest() {
		return dlvRequest;
	}

	public String getDlvStatus() {
		return dlvStatus;
	}

	public String getDlvStartDate() {
		return dlvStartDate;
	}

	public String getDlvEndDate() {
		return dlvEndDate;
	}

	public void setDeliverySeq(long deliverySeq) {
		this.deliverySeq = deliverySeq;
	}

	public void setOrderSeq(long orderSeq) {
		this.orderSeq = orderSeq;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public void setAddrCode(String addrCode) {
		this.addrCode = addrCode;
	}

	public void setAddrBase(String addrBase) {
		this.addrBase = addrBase;
	}

	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}

	public void setDlvRequest(String dlvRequest) {
		this.dlvRequest = dlvRequest;
	}

	public void setDlvStatus(String dlvStatus) {
		this.dlvStatus = dlvStatus;
	}

	public void setDlvStartDate(String dlvStartDate) {
		this.dlvStartDate = dlvStartDate;
	}

	public void setDlvEndDate(String dlvEndDate) {
		this.dlvEndDate = dlvEndDate;
	}

	public String getDlvName() {
		return dlvName;
	}

	public void setDlvName(String dlvName) {
		this.dlvName = dlvName;
	}
	
	
	
	
	
	
}
