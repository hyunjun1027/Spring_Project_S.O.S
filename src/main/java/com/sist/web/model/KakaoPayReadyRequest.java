package com.sist.web.model;

import java.io.Serializable;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

public class KakaoPayReadyRequest implements Serializable {

	private static final long serialVersionUID = 1L;

	private String cid;						// (필수) 가맹점 코드, 10자
	private String cid_secret;				// 가맹점 코드 인증키, 24자, 숫자와 영문 소문자 조합
	private String partner_order_id;		// (필수) 가맹점 주문번호, 최대 100자
	private String partner_user_id; 		//  (필수) 가맹점 회원 id, 최대 100자
	private String item_name;				// (필수) 상품명 최대 100자
	private String item_code;				// 상품코드, 최대 100자
	private int quantity;					// (필수) 상품 수량
	private int total_amount;				// (필수) 상품 총액
	private int tax_free_amount;			// (필수) 상품 비과세 금액
	private int vat_amount;					// 상품 부가세 금액
	private int green_deposit;				// 컵 보증금
	private String approval_url;			// (필수) 결제 성공 시 redirect url, 최대 255자
	private String cancel_url;				// (필수) 결제 취소 시 redirect url, 최대 255자
	private String fail_url;				// (필수) 결제 실패 시 redirect url, 최대 255자
	private JsonArray available_cards;		// 결제 수단으로써 사용 허가할 카드사를 지정해야 하는 경우 사용
	private String payment_method_type;		// 사용 허가할 결제 수단, 지정하지 않으면 모든 결제 수단 허용
	private int install_month;				// 카드 할부개월, 0~12
	private String use_share_installment;	// 분담무이자 설정 (Y/N), 사용 시 사전 협의 필요
	private JsonObject custom_json;			/* 사전에 정의된 기능
											1. 결제 화면에 보여줄 사용자 정의 문구, 카카오페이와 사전 협의 필요
											2. iOS에서 사용자 인증 완료 후 가맹점 앱으로 자동 전환 기능(iOS만 처리가능, 안드로이드 동작불가) */
	
	
	// 생성자
	public KakaoPayReadyRequest() {
		cid = "";					
		cid_secret = "";				
		partner_order_id = "";	
		partner_user_id = "";		
		item_name = "";			
		item_code = "";					
		quantity = 0;			
		total_amount = 0;			
		tax_free_amount = 0;		
		vat_amount = 0;				
		green_deposit = 0;			
		approval_url = "";			
		cancel_url = "";	
		fail_url = "";		
		available_cards = null;	
		payment_method_type = "";		
		install_month = 0;			
		use_share_installment = "";
		custom_json = null;		
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


	public String getPartner_order_id() {
		return partner_order_id;
	}


	public void setPartner_order_id(String partner_order_id) {
		this.partner_order_id = partner_order_id;
	}


	public String getPartner_user_id() {
		return partner_user_id;
	}


	public void setPartner_user_id(String partner_user_id) {
		this.partner_user_id = partner_user_id;
	}


	public String getItem_name() {
		return item_name;
	}


	public void setItem_name(String item_name) {
		this.item_name = item_name;
	}


	public String getItem_code() {
		return item_code;
	}


	public void setItem_code(String item_code) {
		this.item_code = item_code;
	}


	public int getQuantity() {
		return quantity;
	}


	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}


	public int getTotal_amount() {
		return total_amount;
	}


	public void setTotal_amount(int total_amount) {
		this.total_amount = total_amount;
	}


	public int getTax_free_amount() {
		return tax_free_amount;
	}


	public void setTax_free_amount(int tax_free_amount) {
		this.tax_free_amount = tax_free_amount;
	}


	public int getVat_amount() {
		return vat_amount;
	}


	public void setVat_amount(int vat_amount) {
		this.vat_amount = vat_amount;
	}


	public int getGreen_deposit() {
		return green_deposit;
	}


	public void setGreen_deposit(int green_deposit) {
		this.green_deposit = green_deposit;
	}


	public String getApproval_url() {
		return approval_url;
	}


	public void setApproval_url(String approval_url) {
		this.approval_url = approval_url;
	}


	public String getCancel_url() {
		return cancel_url;
	}


	public void setCancel_url(String cancel_url) {
		this.cancel_url = cancel_url;
	}


	public String getFail_url() {
		return fail_url;
	}


	public void setFail_url(String fail_url) {
		this.fail_url = fail_url;
	}


	public JsonArray getAvailable_cards() {
		return available_cards;
	}


	public void setAvailable_cards(JsonArray available_cards) {
		this.available_cards = available_cards;
	}


	public String getPayment_method_type() {
		return payment_method_type;
	}


	public void setPayment_method_type(String payment_method_type) {
		this.payment_method_type = payment_method_type;
	}


	public int getInstall_month() {
		return install_month;
	}


	public void setInstall_month(int install_month) {
		this.install_month = install_month;
	}


	public String getUse_share_installment() {
		return use_share_installment;
	}


	public void setUse_share_installment(String use_share_installment) {
		this.use_share_installment = use_share_installment;
	}


	public JsonObject getCustom_json() {
		return custom_json;
	}


	public void setCustom_json(JsonObject custom_json) {
		this.custom_json = custom_json;
	}
	
   @Override
   public String toString()
   {
      StringBuilder sb = new StringBuilder();
      
      sb.append("\n------------------------------------------------------------------");
      sb.append("\n- KakaoPayReadyRequest                                           -");
      sb.append("\n------------------------------------------------------------------");
      sb.append("\n cid                   : [" + cid + "]");
      sb.append("\n cid_secret            : [" + cid_secret + "]");
      sb.append("\n partner_order_id      : [" + partner_order_id + "]");
      sb.append("\n partner_user_id       : [" + partner_user_id + "]");
      sb.append("\n item_name             : [" + item_name + "]");
      sb.append("\n item_code             : [" + item_code + "]");
      sb.append("\n quantity              : [" + quantity + "]");
      sb.append("\n total_amount          : [" + total_amount + "]");
      sb.append("\n tax_free_amount       : [" + tax_free_amount + "]");
      sb.append("\n vat_amount            : [" + vat_amount + "]");
      sb.append("\n green_deposit         : [" + green_deposit + "]");
      sb.append("\n approval_url          : [" + approval_url + "]");
      sb.append("\n cancel_url            : [" + cancel_url + "]");
      sb.append("\n fail_url              : [" + fail_url + "]");
      sb.append("\n available_cards       : [" + (available_cards != null ? available_cards.toString() : "") + "]");
      sb.append("\n payment_method_type   : [" + payment_method_type + "]");
      sb.append("\n install_month         : [" + install_month + "]");
      sb.append("\n use_share_installment : [" + use_share_installment + "]");
      sb.append("\n custom_json           : [" + (custom_json != null ? custom_json.toString() : "") + "]");
      sb.append("\n------------------------------------------------------------------");      
      
      return sb.toString();
   }
	
	
}
