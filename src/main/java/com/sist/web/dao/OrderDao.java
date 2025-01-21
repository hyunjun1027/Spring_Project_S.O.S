package com.sist.web.dao;

import java.util.List;

import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.Refund;

@ResponseBody
public interface OrderDao {
	// 입금대기 30분 지난 것들 조회
	public List<Order> orderMinuteSelect ();
	
	// 미결제건 조회
	public int noPayCount (String userId);
	
	// 주문 INSERT
	public int orderInsert(Order order);

	// 주문 UPDATE (결제상태: 결제완료)
	public int orderComUpdate(Order order);

	// 주문 SELECT
	public Order orderSelect(long orderSeq);

	// 내가 주문한 내역조회 SELECT
	public List<Order> myOrderList(Order order);

	// 내가 주문한 내역 개수 조회 SELECT
	public int myOrderListCount(Order order);

	// 주문삭제
	public int orderDelete(long orderSeq);

	// 주문상세 INSERT
	public int orderDetailInsert(OrderDetail orderDetail);

	// 주문상세 SELECT
	public List<OrderDetail> orderDetailSelect(long orderSeq);

	// 배송 INSERT
	public int deliInfoInsert(DeliveryInfo deliveryInfo);

	// 배송조회 SELECT
	public DeliveryInfo deliInfoSelect(long orderSeq);

	// 환불 INSERT
	public int refundInsert(Refund refund);

	// 환불 UPDATE
	public int refundComp(Refund refund);

	// 환불 SELECT
	public Refund refundSelect(long orderSeq);

}
