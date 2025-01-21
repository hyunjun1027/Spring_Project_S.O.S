package com.sist.web.model;

import java.io.Serializable;

public class User implements Serializable, Account {

	private static final long serialVersionUID = 1L;

	private String userId;
	private String userPwd;
	private String userEmail;
	private String userName;
	private String userPhone;
	private String addrCode;
	private String addrBase;
	private String addrDetail;
	private String status;
	private String rating;
	private String regDate;
	private String modDate;
	private String userProfile;
	private String loginType;

	public User() {
		userId = "";
		userPwd = "";
		userEmail = "";
		userName = "";
		userPhone = "";
		addrCode = "";
		addrBase = "";
		addrDetail = "";
		status = "N";
		rating = "";
		regDate = "";
		modDate = "";
		userProfile = "";
		loginType = "";
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserPwd() {
		return userPwd;
	}

	public void setUserPwd(String userPwd) {
		this.userPwd = userPwd;
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPhone() {
		return userPhone;
	}

	public void setUserPhone(String userPhone) {
		this.userPhone = userPhone;
	}

	public String getAddrCode() {
		return addrCode;
	}

	public void setAddrCode(String addrCode) {
		this.addrCode = addrCode;
	}

	public String getAddrBase() {
		return addrBase;
	}

	public void setAddrBase(String addrBase) {
		this.addrBase = addrBase;
	}

	public String getAddrDetail() {
		return addrDetail;
	}

	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getRating() {
		return rating;
	}

	public void setRating(String rating) {
		this.rating = rating;
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

	public String getUserProfile() {
		return userProfile;
	}

	public void setUserProfile(String userProfile) {
		this.userProfile = userProfile;
	}

	public String getLoginType() {
		return loginType;
	}

	public void setLoginType(String loginType) {
		this.loginType = loginType;
	}

}
