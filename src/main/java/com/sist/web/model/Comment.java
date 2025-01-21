package com.sist.web.model;

import java.io.Serializable;
import java.util.List;

public class Comment implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private long comSeq;		//댓글 번호
	private long brdSeq;		//게시물 번호
	private String userId;		//회원 아이디
	private String replyUserId;	//본댓글 회원 아이디
	private String comContent;	//댓글 내용
	private long comParent;		//부모 댓글 번호
	private long comGroup;		//그룹 번호
	private int comOrder;		//그룹 내 순서
	private int comIndent;		//들여쓰기
	private String comSecret;	//비밀번호
	private String regDate;		//댓글 작성일
	private String modDate;		//댓글 수정일
	private String delDate;		//댓글 삭제일
	
	private String parentUserId;
	private List<Comment> replies;
	private String userProfile;
	private String userName;
	private int replyCount;
	
	public Comment()
	{
		comSeq = 0;
		brdSeq = 0;
		userId = "";
		replyUserId = "";
		comContent = "";
		comParent = 0;
		comGroup = 0;
		comOrder = 0;
		comIndent = 0;
		comSecret = "";
		regDate = "";
		modDate = "";
		delDate = "";
		
		parentUserId = "";
		replies = null;
		userProfile = "";
		userName = "";
		replyCount = 0;
	}

	public long getComSeq() {
		return comSeq;
	}

	public void setComSeq(long comSeq) {
		this.comSeq = comSeq;
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

	public String getReplyUserId() {
		return replyUserId;
	}

	public void setReplyUserId(String replyUserId) {
		this.replyUserId = replyUserId;
	}

	public String getComContent() {
		return comContent;
	}

	public void setComContent(String comContent) {
		this.comContent = comContent;
	}

	public long getComParent() {
		return comParent;
	}

	public void setComParent(long comParent) {
		this.comParent = comParent;
	}

	public long getComGroup() {
		return comGroup;
	}

	public void setComGroup(long comGroup) {
		this.comGroup = comGroup;
	}

	public int getComOrder() {
		return comOrder;
	}

	public void setComOrder(int comOrder) {
		this.comOrder = comOrder;
	}

	public int getComIndent() {
		return comIndent;
	}

	public void setComIndent(int comIndent) {
		this.comIndent = comIndent;
	}

	public String getComSecret() {
		return comSecret;
	}

	public void setComSecret(String comSecret) {
		this.comSecret = comSecret;
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

	public String getDelDate() {
		return delDate;
	}

	public void setDelDate(String delDate) {
		this.delDate = delDate;
	}

	public String getParentUserId() {
		return parentUserId;
	}

	public void setParentUserId(String parentUserId) {
		this.parentUserId = parentUserId;
	}

	public List<Comment> getReplies() {
		return replies;
	}

	public void setReplies(List<Comment> replies) {
		this.replies = replies;
	}

	public String getUserProfile() {
		return userProfile;
	}

	public void setUserProfile(String userProfile) {
		this.userProfile = userProfile;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public int getReplyCount() {
		return replyCount;
	}

	public void setReplyCount(int replyCount) {
		this.replyCount = replyCount;
	}
	
	
	
}
