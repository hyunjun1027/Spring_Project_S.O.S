package com.sist.web.controller;

import java.time.LocalDateTime;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.sist.web.model.Book;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.service.BookService;
import com.sist.web.service.OrderService;

@Component
@EnableScheduling
public class OrderSchedule {
	private static final Logger logger = LoggerFactory.getLogger(OrderSchedule.class);

	@Autowired
	private OrderService orderService;

	@Autowired
	private BookService bookService;

	public OrderSchedule(OrderService orderService) {
		this.orderService = orderService;
	}

	@Scheduled(cron = "0 0/1 * * * ?") // 매 1분마다 실행
	public void cancelUnpaidOrders() {
		logger.debug("스케줄러 시작!!!!!!!");

		LocalDateTime now = LocalDateTime.now();
		logger.info("Started cancelUnpaidOrders at {}", now);

		// 30분 이상 지난 주문 조회
		List<Order> orderSeqList = orderService.orderMinuteSelect();
		logger.info("Found {} unpaid orders to cancel", orderSeqList.size());

		// 주문 삭제 실행
		if (orderSeqList != null) {
			for (Order order : orderSeqList) {

				List<OrderDetail> orderDetailList = orderService.orderDetailSelect(order.getOrderSeq());

				for (OrderDetail od : orderDetailList) {
					Book qttBook = bookService.bookSelect("", od.getBookSeq());

					qttBook.setQttMgrChk("2");
					qttBook.setQttVal(od.getOrderCnt());

					try {
						if (bookService.bookQttMgr(qttBook) > 0) {
							logger.debug("재고 업데이트 성공~");

							orderService.orderDelete(order.getOrderSeq());
							logger.info("Order {} canceled.", order.getOrderSeq());
						}
					} catch (Exception e) {
						logger.error("DB 설정 에러 222222222222", e);
					}
				}

			}
		}

		logger.debug("스케줄러 끝!!!!!!!");
	}
}
