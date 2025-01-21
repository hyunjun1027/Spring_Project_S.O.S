package com.sist.web.model;

import java.io.Serializable;

import com.sist.web.util.JsonUtil;

public class KakaoPayCardInfo implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	private String kakaopay_purchase_corp;        	// 카카오페이 매입사명
    private String kakaopay_purchase_corp_code;   	// 카카오페이 매입사 코드
    private String kakaopay_issuer_corp;          	// 카카오페이 발급사명
    private String kakaopay_issuer_corp_code;     	// 카카오페이 발급사 코드
    private String bin;                             // 카드 BIN
    private String card_type;                       // 카드 타입
    private String install_month;                   // 할부 개월 수
    private String approved_id;                     // 카드사 승인번호
    private String card_mid;                        // 카드사 가맹점 번호
    private String interest_free_install;           // 무이자할부 여부(Y/N)
    private String installment_type;                // 할부 유형(24.02.01일부터 제공)
                                                  	// - CARD_INSTALLMENT: 업종 무이자
                                                  	// - SHARE_INSTALLMENT: 분담 무이자
    private String card_item_code;                  // 카드 상품 코드

    public KakaoPayCardInfo() {
        kakaopay_purchase_corp = "";
        kakaopay_purchase_corp_code = "";
        kakaopay_issuer_corp = "";
        kakaopay_issuer_corp_code = "";
        bin = "";
        card_type = "";
        install_month = "";
        approved_id = "";
        card_mid = "";
        interest_free_install = "";
        installment_type = "";
        card_item_code = "";
    }

	public String getKakaopay_purchase_corp() {
		return kakaopay_purchase_corp;
	}

	public void setKakaopay_purchase_corp(String kakaopay_purchase_corp) {
		this.kakaopay_purchase_corp = kakaopay_purchase_corp;
	}

	public String getKakaopay_purchase_corp_code() {
		return kakaopay_purchase_corp_code;
	}

	public void setKakaopay_purchase_corp_code(String kakaopay_purchase_corp_code) {
		this.kakaopay_purchase_corp_code = kakaopay_purchase_corp_code;
	}

	public String getKakaopay_issuer_corp() {
		return kakaopay_issuer_corp;
	}

	public void setKakaopay_issuer_corp(String kakaopay_issuer_corp) {
		this.kakaopay_issuer_corp = kakaopay_issuer_corp;
	}

	public String getKakaopay_issuer_corp_code() {
		return kakaopay_issuer_corp_code;
	}

	public void setKakaopay_issuer_corp_code(String kakaopay_issuer_corp_code) {
		this.kakaopay_issuer_corp_code = kakaopay_issuer_corp_code;
	}

	public String getBin() {
		return bin;
	}

	public void setBin(String bin) {
		this.bin = bin;
	}

	public String getCard_type() {
		return card_type;
	}

	public void setCard_type(String card_type) {
		this.card_type = card_type;
	}

	public String getInstall_month() {
		return install_month;
	}

	public void setInstall_month(String install_month) {
		this.install_month = install_month;
	}

	public String getApproved_id() {
		return approved_id;
	}

	public void setApproved_id(String approved_id) {
		this.approved_id = approved_id;
	}

	public String getCard_mid() {
		return card_mid;
	}

	public void setCard_mid(String card_mid) {
		this.card_mid = card_mid;
	}

	public String getInterest_free_install() {
		return interest_free_install;
	}

	public void setInterest_free_install(String interest_free_install) {
		this.interest_free_install = interest_free_install;
	}

	public String getInstallment_type() {
		return installment_type;
	}

	public void setInstallment_type(String installment_type) {
		this.installment_type = installment_type;
	}

	public String getCard_item_code() {
		return card_item_code;
	}

	public void setCard_item_code(String card_item_code) {
		this.card_item_code = card_item_code;
	}
    
	@Override
	public String toString() {
		return JsonUtil.toJsonPretty(this);
	}

}
