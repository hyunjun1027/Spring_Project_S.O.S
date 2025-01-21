package com.sist.web.model;

import java.io.Serializable;

import com.sist.web.util.JsonUtil;

public class KakaoPayCancelResponse implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private String aid;					// 요청 고유 번호
	private String tid;					// 결제 고유 번호
	private String cid;					// 가맹점 코드
	private String status;				// 결제 상태
	private String partner_order_id;	// 가맹점 주문번호
	private String partner_user_id;		// 가맹점 회원 id
	private String payment_method_type;	// 결제 수단 / CARD OR MONEY
	private Amount amount;				// 결제 금액
	private ApprovedCancelAmount approved_cancel_amount;	// 이번 요청으로 취소된 금액
	private CanceledAmount canceled_amount;	// 남은 취소 가능 금액
	private String item_name;			// 상품 이름
	private String item_code;			// 상품 코드
	private int quantity;				// 상품 수량
	private String created_at;			// 결제 준비 요청 시각
	private String approved_at;			// 결제 승인 시각
	private String canceled_at;			// 결제 취소 시각
	private String payload;				// 취소 요청 시 전달한 값
	
	// 결제 실패시
	private int error_code;
	private String error_message;
	private KakaoPayApproveErrorExtras extras;
	
	
	public KakaoPayCancelResponse() {
		aid = "";
		tid = "";
		cid = "";
		status = "";
		partner_order_id = "";
		partner_user_id = "";
		payment_method_type = "";
		amount = null;
		approved_cancel_amount = null;
		canceled_amount = null;
		item_name = "";
		item_code = "";
		quantity = 0;
		created_at = "";
		approved_at = "";
		canceled_at = "";
		payload = "";
		
		error_code = 0;
		error_message = "";
		extras = null;
	}


	public String getAid() {
		return aid;
	}


	public void setAid(String aid) {
		this.aid = aid;
	}


	public String getTid() {
		return tid;
	}


	public void setTid(String tid) {
		this.tid = tid;
	}


	public String getCid() {
		return cid;
	}


	public void setCid(String cid) {
		this.cid = cid;
	}


	public String getStatus() {
		return status;
	}


	public void setStatus(String status) {
		this.status = status;
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


	public String getPayment_method_type() {
		return payment_method_type;
	}


	public void setPayment_method_type(String payment_method_type) {
		this.payment_method_type = payment_method_type;
	}


	public Amount getAmount() {
		return amount;
	}


	public void setAmount(Amount amount) {
		this.amount = amount;
	}


	public ApprovedCancelAmount getApproved_cancel_amount() {
		return approved_cancel_amount;
	}


	public void setApproved_cancel_amount(ApprovedCancelAmount approved_cancel_amount) {
		this.approved_cancel_amount = approved_cancel_amount;
	}


	public CanceledAmount getCanceled_amount() {
		return canceled_amount;
	}


	public void setCanceled_amount(CanceledAmount canceled_amount) {
		this.canceled_amount = canceled_amount;
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


	public String getCreated_at() {
		return created_at;
	}


	public void setCreated_at(String created_at) {
		this.created_at = created_at;
	}


	public String getApproved_at() {
		return approved_at;
	}


	public void setApproved_at(String approved_at) {
		this.approved_at = approved_at;
	}


	public String getCanceled_at() {
		return canceled_at;
	}


	public void setCanceled_at(String canceled_at) {
		this.canceled_at = canceled_at;
	}


	public String getPayload() {
		return payload;
	}


	public void setPayload(String payload) {
		this.payload = payload;
	}
	
    public int getError_code() {
		return error_code;
	}


	public void setError_code(int error_code) {
		this.error_code = error_code;
	}


	public String getError_message() {
		return error_message;
	}


	public void setError_message(String error_message) {
		this.error_message = error_message;
	}


	public KakaoPayApproveErrorExtras getExtras() {
		return extras;
	}


	public void setExtras(KakaoPayApproveErrorExtras extras) {
		this.extras = extras;
	}


	@Override
	public String toString() {
		return JsonUtil.toJsonPretty(this);
	}
	
	
}
