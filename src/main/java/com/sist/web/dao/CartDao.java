package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Cart;

@Repository("cartDao")
public interface CartDao {
	// 장바구니 리스트 가져오기
	public List<Cart> cartListSelect(Cart cart);

	public Cart cartSelect(Cart search);

	// 장바구니 생성
	public int cartInsert(Cart cart);

	// 장바구니에 있는 물건을 한번 더 넣으면 갯수 +1
	public int cartPrdCntPlus(Cart cart);

	// 장바구니 목록에서 갯수 한번에 바꾸기
	public int cartPrdCntUpdate(Cart cart);

	// 장바구니 checked 업데이트
	public int cartCheckedUpdate(Cart cart);

	// 장바구니 지우기
	public int cartDelete(Cart cart);

	// 장바구니 개수
	public int cartCount(String userId);

}
