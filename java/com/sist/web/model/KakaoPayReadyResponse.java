package com.sist.web.model;

import java.io.Serializable;

import com.sist.web.util.JsonUtil;

public class KakaoPayReadyResponse implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String tid;                        // 결제 고유 번호, 20자
    private String next_redirect_app_url;      // 모바일 앱 결제 페이지 Redirect URL
    private String next_redirect_mobile_url;   // 모바일 웹 결제 페이지 Redirect URL
    private String next_redirect_pc_url;       // PC 웹 결제 페이지 Redirect URL
    private String android_app_scheme;         // Android 앱 스킴
    private String ios_app_scheme;             // iOS 앱 스킴
    private String created_at;                 // 결제 준비 요청 시간

    public KakaoPayReadyResponse() {
        tid = "";
        next_redirect_app_url = "";
        next_redirect_mobile_url = "";
        next_redirect_pc_url = "";
        android_app_scheme = "";
        ios_app_scheme = "";
        created_at = "";
    }

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public String getNext_redirect_app_url() {
		return next_redirect_app_url;
	}

	public void setNext_redirect_app_url(String next_redirect_app_url) {
		this.next_redirect_app_url = next_redirect_app_url;
	}

	public String getNext_redirect_mobile_url() {
		return next_redirect_mobile_url;
	}

	public void setNext_redirect_mobile_url(String next_redirect_mobile_url) {
		this.next_redirect_mobile_url = next_redirect_mobile_url;
	}

	public String getNext_redirect_pc_url() {
		return next_redirect_pc_url;
	}

	public void setNext_redirect_pc_url(String next_redirect_pc_url) {
		this.next_redirect_pc_url = next_redirect_pc_url;
	}

	public String getAndroid_app_scheme() {
		return android_app_scheme;
	}

	public void setAndroid_app_scheme(String android_app_scheme) {
		this.android_app_scheme = android_app_scheme;
	}

	public String getIos_app_scheme() {
		return ios_app_scheme;
	}

	public void setIos_app_scheme(String ios_app_scheme) {
		this.ios_app_scheme = ios_app_scheme;
	}

	public String getCreated_at() {
		return created_at;
	}

	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}
    
   @Override
   public String toString()
   {
      return JsonUtil.toJsonPretty(this);
   }

    
}

