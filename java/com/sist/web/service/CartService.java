package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.CartDao;
import com.sist.web.model.Cart;

@Service("cartService")
public class CartService {
	private static Logger logger = LoggerFactory.getLogger(CartService.class);

	@Autowired
	private CartDao cartDao;

	// 장바구니 리스트 가져오기
	public List<Cart> cartListSelect(Cart cart) {
		List<Cart> list = null;

		try {
			list = cartDao.cartListSelect(cart);
		} catch (Exception e) {
			logger.error("[cartService] cartListSelect exception", e);
		}

		return list;
	}

	// 장바구니 가져오기
	public Cart cartSelect(Cart search) {
		Cart cart = null;

		try {
			cart = cartDao.cartSelect(search);
		} catch (Exception e) {
			logger.error("[cartService] cartSelect exception", e);
		}

		return cart;
	}

	// 장바구니 생성
	public int cartInsert(Cart cart) {
		int count = 0;
		try {
			count = cartDao.cartInsert(cart);
		} catch (Exception e) {
			logger.error("[cartService] cartInsert exception", e);
		}
		return count;
	}

	// 장바구니에 있는 물건을 한번 더 넣으면 갯수 +1
	public int cartPrdCntPlus(Cart cart) {
		int count = 0;
		try {
			count = cartDao.cartPrdCntPlus(cart);
		} catch (Exception e) {
			logger.error("[cartService] cartPrdCntPlus exception", e);
		}
		return count;
	}

	// 장바구니 목록에서 갯수 한번에 바꾸기
	public int cartPrdCntUpdate(Cart cart) {
		int count = 0;
		try {
			count = cartDao.cartPrdCntUpdate(cart);
		} catch (Exception e) {
			logger.error("[cartService] cartPrdCntUpdate exception", e);
		}
		return count;
	}

	// 장바구니 목록에서 갯수 한번에 바꾸기
	public int cartCheckedUpdate(Cart cart) {
		int count = 0;
		try {
			count = cartDao.cartCheckedUpdate(cart);
		} catch (Exception e) {
			logger.error("[cartService] cartCheckedUpdate exception", e);
		}
		return count;
	}

	// 장바구니 지우기
	public int cartDelete(Cart cart) {
		int count = 0;
		try {
			count = cartDao.cartDelete(cart);
		} catch (Exception e) {
			logger.error("[cartService] cartDelete exception", e);
		}
		return count;
	}

	// 장바구니 개수
	public int cartCount(String userId) {
		int count = 0;
		try {
			count = cartDao.cartCount(userId);
		} catch (Exception e) {
			logger.error("[cartService] cartCount exception", e);
		}
		return count;
	}

}
