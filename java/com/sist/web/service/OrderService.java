package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.AdminDao;
import com.sist.web.dao.OrderDao;
import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.Refund;

@Service("orderService")
public class OrderService {

	private static Logger logger = LoggerFactory.getLogger(OrderService.class);

	@Autowired
	private OrderDao orderDao;

	@Autowired
	private AdminDao adminDao;
	
	// 미결제건 조회
	public int noPayCount (String userId) {
		int count = 0;
		
		try {
			count = orderDao.noPayCount(userId);
		} catch (Exception e) {
			logger.error("[OrderService] noPayCount SQLExcepton", e);
		}
		
		return count;
	}
	
	// 입금대기 30분 지난 것들 조회
	public List<Order> orderMinuteSelect () {
		List<Order> ol = null;
		
		try {
			ol = orderDao.orderMinuteSelect();
		} catch (Exception e) {
			logger.error("[OrderService] orderMinuteSelect SQLExcepton", e);
		}
		
		return ol;
	}

	// 주문 INSERT
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int orderInsert(Order order) throws Exception {
		int count = 0;

		orderDao.orderInsert(order);

		/*
		 * try { count = orderDao.orderInsert(order); } catch (Exception e) {
		 * logger.error("[OrderService] orderInsert SQLExcepton", e); }
		 */

		return count;
	}

	// 주문 UPDATE (입금대기 -> 결제완료)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int orderComUpdate(Order order) throws Exception {
		int count = 0;

		count = orderDao.orderComUpdate(order);

		/*
		 * try {
		 * count = orderDao.orderComUpdate(order);
		 * } catch (Exception e) {
		 * logger.error("[OrderService] orderComUpdate SQLExcepton", e); }
		 */

		return count;
	}

	// 주문조회 SELECT
	public Order orderSelect(long orderSeq) {
		Order order = null;

		logger.debug("service start ####################################");
		
		try {
			logger.debug("service try start ####################################");
			order = orderDao.orderSelect(orderSeq);
			logger.debug("service try end ####################################");
		} catch (Exception e) {
			logger.error("[OrderService] orderComUpdate SQLExcepton", e);
		}

		return order;
	}

	// 내가 주문한 내역 조회 SELECT
	public List<Order> myOrderList(Order order) {
		List<Order> orderList = null;

		try {
			orderList = orderDao.myOrderList(order);
		} catch (Exception e) {
			logger.error("[OrderService] orderComUpdate SQLExcepton", e);
		}

		return orderList;
	}

	// 내가 주문한 내역 개수조회 SELECT
	public int myOrderListCount(Order order) {
		int count = 0;

		try {
			count = orderDao.myOrderListCount(order);
		} catch (Exception e) {
			logger.error("[OrderService] orderComUpdate SQLExcepton", e);
		}

		return count;
	}

	// 주문 삭제
	public int orderDelete(long orderSeq) {
		int count = 0;

		try {
			count = orderDao.orderDelete(orderSeq);
		} catch (Exception e) {
			logger.error("[OrderService] orderComUpdate SQLExcepton", e);
		}

		return count;
	}

	// 주문상세 INSERT
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int orderDetailInsert(OrderDetail orderDetail) throws Exception {
		int count = 0;

		count = orderDao.orderDetailInsert(orderDetail);

		/*
		 * try { count = orderDao.orderDetailInsert(orderDetail); } catch (Exception e)
		 * { logger.error("[OrderService] orderComUpdate SQLExcepton", e); }
		 */

		return count;
	}

	// 주문상세조회 SELECT
	public List<OrderDetail> orderDetailSelect(long orderSeq) {
		List<OrderDetail> od = null;

		try {
			od = orderDao.orderDetailSelect(orderSeq);
		} catch (Exception e) {
			logger.error("[OrderService] orderComUpdate SQLExcepton", e);
		}

		return od;
	}

	// 배송 INSERT
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int deliInfoInsert(DeliveryInfo deliveryInfo) throws Exception {
		int count = 0;

		count = orderDao.deliInfoInsert(deliveryInfo);

		/*
		 * try { count = orderDao.deliInfoInsert(deliveryInfo); } catch (Exception e) {
		 * logger.error("[OrderService] deliInfoInsert SQLExcepton", e); }
		 */

		return count;
	}

	// 배송조회 SELECT
	public DeliveryInfo deliInfoSelect(long orderSeq) {
		DeliveryInfo di = null;

		try {
			di = orderDao.deliInfoSelect(orderSeq);
		} catch (Exception e) {
			logger.error("[OrderService] deliInfoSelect SQLExcepton", e);
		}
		return di;
	}

	// 환불신청 (환불 테이블 INSERT + 주문 테이블 UPDATE)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int refundApply(Order order, Refund refund) {
		int count = 0;

		// 주문 테이블 UPDATE
		// ORDER_STATUS --> '4'
		count = adminDao.orderStatusUpdate(order);

		if (count > 0) {
			orderDao.refundInsert(refund);
		}

		return count;
	}

	// 환불완료 (환불 테이블 UPDATE + 주문 테이블 UPDATE)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int refundComp(Order order, Refund refund) {
		int count = 0;

		// 주문 테이블 UPDATE
		// PAY_STATUS --> '5'
		count = adminDao.orderStatusUpdate(order);

		// 환불 테이블 UPDATE
		if (count > 0) {
			orderDao.refundComp(refund);
		}

		return count;
	}

	// 환불 조회
	public Refund refundSelect(long orderSeq) {
		Refund refund = null;

		try {
			refund = orderDao.refundSelect(orderSeq);
		} catch (Exception e) {
			logger.error("[OrderService] refundSelect SQLExcepton", e);
		}

		return refund;
	}

}
