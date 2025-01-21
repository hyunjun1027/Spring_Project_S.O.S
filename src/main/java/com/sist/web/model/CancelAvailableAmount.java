package com.sist.web.model;

import java.io.Serializable;

public class CancelAvailableAmount implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private int total;			// 전체 취소 가능 금액
	private int tax_free;		// 취소 가능한 비과세 금액
	private int vat;			// 취소 가능한 부가세 금액
	private int point;			// 취소 가능한 포인트 금액
	private int discount;		// 취소 가능한 할인 금액
	private int green_deposit;	// 취소 가능한 컵 보증금
	
	public CancelAvailableAmount() {
		total = 0;
		tax_free = 0;
		vat = 0;
		point = 0;
		discount = 0;
		green_deposit = 0;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getTax_free() {
		return tax_free;
	}

	public void setTax_free(int tax_free) {
		this.tax_free = tax_free;
	}

	public int getVat() {
		return vat;
	}

	public void setVat(int vat) {
		this.vat = vat;
	}

	public int getPoint() {
		return point;
	}

	public void setPoint(int point) {
		this.point = point;
	}

	public int getDiscount() {
		return discount;
	}

	public void setDiscount(int discount) {
		this.discount = discount;
	}

	public int getGreen_deposit() {
		return green_deposit;
	}

	public void setGreen_deposit(int green_deposit) {
		this.green_deposit = green_deposit;
	}
	
	

}
