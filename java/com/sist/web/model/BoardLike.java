package com.sist.web.model;

import java.io.Serializable;

public class BoardLike implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long brdSeq;				//게시물 번호
	private String userId;				//아이디
	private int likeCount;				//좋아요 수
	
	public BoardLike()
	{
		brdSeq = 0;
		userId = "";
		likeCount = 0;
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

	public int getLikeCount() {
		return likeCount;
	}

	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	
	
}
