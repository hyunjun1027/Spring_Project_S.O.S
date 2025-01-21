package com.sist.web.model;

import java.io.Serializable;

public class KakaoPayCancelRequest implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String cid;					// * 가맹점 코드, 10자
	private String cid_secret;			// 가맹점 코드 인증키
	private String tid;					// * 결제 고유 번호
	private int cancel_amount;			// * 취소 금액
	private int cancel_tax_free_amount;	// * 취소 비과세 금액
	private int cancel_vat_amount;			// 취소 부가세 금액
	private int cancel_available_amount;		// 취소 가능 금액
	private String payload;				// 해당 요청에 대해 저장하고 싶은 값
	
	public KakaoPayCancelRequest() {
		cid = "";
		cid_secret = "";
		tid = "";
		cancel_amount = 0;
		cancel_tax_free_amount = 0;
		cancel_vat_amount = 0;
		cancel_available_amount = 0;
		payload = "";
	}

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	public String getCid_secret() {
		return cid_secret;
	}

	public void setCid_secret(String cid_secret) {
		this.cid_secret = cid_secret;
	}

	public String getTid() {
		return tid;
	}

	public void setTid(String tid) {
		this.tid = tid;
	}

	public int getCancel_amount() {
		return cancel_amount;
	}

	public void setCancel_amount(int cancel_amount) {
		this.cancel_amount = cancel_amount;
	}

	public int getCancel_tax_free_amount() {
		return cancel_tax_free_amount;
	}

	public void setCancel_tax_free_amount(int cancel_tax_free_amount) {
		this.cancel_tax_free_amount = cancel_tax_free_amount;
	}

	public int getCancel_vat_amount() {
		return cancel_vat_amount;
	}

	public void setCancel_vat_amount(int cancel_vat_amount) {
		this.cancel_vat_amount = cancel_vat_amount;
	}

	public int getCancel_available_amount() {
		return cancel_available_amount;
	}

	public void setCancel_available_amount(int cancel_available_amount) {
		this.cancel_available_amount = cancel_available_amount;
	}

	public String getPayload() {
		return payload;
	}

	public void setPayload(String payload) {
		this.payload = payload;
	}
	
    @Override
    public String toString()
    {
       StringBuilder sb = new StringBuilder();
       
       sb.append("\n------------------------------------------------------------------");
       sb.append("\n- KakaoPayCancelRequest                                         -");
       sb.append("\n------------------------------------------------------------------");
       sb.append("\n cid             					 : [" + cid + "]");
       sb.append("\n cid_secret      		 			 : [" + cid_secret + "]");
       sb.append("\n tid            				 	 : [" + tid + "]");
       sb.append("\n cancel_amount					     : [" + cancel_amount + "]");
       sb.append("\n cancel_tax_free_amount  			 : [" + cancel_tax_free_amount + "]");
       sb.append("\n cancel_vat_amount          		 : [" + cancel_vat_amount + "]");
       sb.append("\n cancel_available_amount         	 : [" + cancel_available_amount + "]");
       sb.append("\n payload    						 : [" + payload + "]");
       sb.append("\n------------------------------------------------------------------");
       
       return sb.toString();
    }
	

}
