package com.sist.web.model;

public interface Account {
	
	
	
	public String getUserId();

	public String getUserPwd();

	public String getUserEmail();

	public String getUserName();

	public String getUserPhone();

	public String getAddrCode();

	public String getAddrBase();

	public String getAddrDetail();

	public String getStatus();

	public String getRating();

	public String getRegDate();

	public String getUserProfile();
	
	public String getModDate();
	
	public void setModDate(String modDate);

	public void setUserId(String userId);

	public void setUserPwd(String userPwd);

	public void setUserEmail(String userEmail);

	public void setUserName(String userName);

	public void setUserPhone(String userPhone);

	public void setAddrCode(String addrCode);

	public void setAddrBase(String addrBase);

	public void setAddrDetail(String addrDetail);

	public void setStatus(String status);

	public void setRating(String rating);

	public void setRegDate(String regDate);

	public void setUserProfile(String userProfile);

}
