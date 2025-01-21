package com.sist.web.model;

import java.io.Serializable;

public class Mail implements Serializable {

	private static final long serialVersionUID = 1L;

	private String userEmail;
	private String authNum;

	public Mail() {
		userEmail = "";
		authNum = "";
	}

	public String getUserEmail() {
		return userEmail;
	}

	public void setUserEmail(String userEmail) {
		this.userEmail = userEmail;
	}

	public String getAuthNum() {
		return authNum;
	}

	public void setAuthNum(String authNum) {
		this.authNum = authNum;
	}

}
