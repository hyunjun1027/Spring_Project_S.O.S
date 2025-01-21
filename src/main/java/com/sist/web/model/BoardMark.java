package com.sist.web.model;

import java.io.Serializable;

public class BoardMark implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long brdSeq;				//게시물 번호
	private String userId;				//아이디
	
	public BoardMark()
	{
		brdSeq = 0;
		userId = "";
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	
}
