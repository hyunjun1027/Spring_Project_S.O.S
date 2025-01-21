package com.sist.web.model;

import java.io.Serializable;

import com.sist.web.util.JsonUtil;

public class KakaoPayApproveErrorExtras implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String method_result_code = "";
    private String method_result_message = "";
    
    public KakaoPayApproveErrorExtras() {
    	method_result_code = "";
    	method_result_message = "";
    }

	public String getMethod_result_code() {
		return method_result_code;
	}

	public void setMethod_result_code(String method_result_code) {
		this.method_result_code = method_result_code;
	}

	public String getMethod_result_message() {
		return method_result_message;
	}

	public void setMethod_result_message(String method_result_message) {
		this.method_result_message = method_result_message;
	}
    
	@Override
	public String toString() {
		return JsonUtil.toJsonPretty(this);
	}

}
