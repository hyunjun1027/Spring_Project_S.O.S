package com.sist.web.model;

import java.io.Serializable;

public class PrevQue_Easy_Hard implements Serializable {

	private static final long serialVersionUID = 1L;

	private long examSeq;
	private String userId;
	private String status;

	public PrevQue_Easy_Hard() {
		examSeq = 0;
		userId = "";
		status = "";
	}

	public long getExamSeq() {
		return examSeq;
	}

	public void setExamSeq(long examSeq) {
		this.examSeq = examSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

}
