package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.AdminDao;
import com.sist.web.model.Admin;
import com.sist.web.model.BoardNotice;
import com.sist.web.model.Course;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.OrderStatus;

@Service("adminService")
public class AdminService {
	private static Logger logger = LoggerFactory.getLogger(AdminService.class);

	@Autowired
	private AdminDao adminDao;

	// 관리자 조회
	public Admin AdminSelect(String userId) {
		Admin admin = null;

		try {
			admin = adminDao.adminSelect(userId);
		} catch (Exception e) {
			logger.error("[AdminService] AdminDao Exception", e);
		}

		return admin;
	}

	// 이번달 주문건수
	public int monthOrderCnt() {
		int count = 0;

		try {
			count = adminDao.monthOrderCnt();
		} catch (Exception e) {
			logger.error("[AdminService] monthOrderCnt Exception", e);
		}

		return count;
	}

	// 이번달 주문금액
	public int monthOrderPrice() {
		int count = 0;

		try {
			count = adminDao.monthOrderPrice();
		} catch (Exception e) {
			logger.error("[AdminService] monthOrderPrice Exception", e);
		}

		return count;
	}

	// 이번달 주문상태
	public List<OrderStatus> monthOrderStatus() {
		List<OrderStatus> os = null;

		try {
			os = adminDao.monthOrderStatus();
		} catch (Exception e) {
			logger.error("[AdminService] monthOrderStatus Exception", e);
		}

		return os;
	}

	// 최근 6개월 주문내역 조회
	public int getOrderCount(int count) {
		int orderCount = 0;

		try {
			orderCount = adminDao.getOrderCount(count);
		} catch (Exception e) {
			logger.error("[AdminService] getOrderCount Exception", e);
		}

		return orderCount;
	}

	// 최근 회원가입 정보
	public List<User> userSelectAll(String rating, String status) {
		List<User> list = null;

		try {
			list = adminDao.userSelectAll(rating, status);
		} catch (Exception e) {
			logger.error("[AdminService] userSelectAll Exception", e);
		}

		return list;
	}

	// 강사 승인 조회
	public List<Teacher> selectNoTeacher(String classCode) {
		List<Teacher> list = null;

		try {
			list = adminDao.selectNoTeacher(classCode);
		} catch (Exception e) {
			logger.error("[AdminService] selectNoTeacher Exception", e);
		}

		return list;
	}

	// 강사신청 승인
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noTeacherOk(String teacherId) throws Exception {
		int count = 0;

		count = adminDao.noTeacherOk(teacherId);

		return count;
	}

	// 강사신청 거절
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noTeacherNo(String teacherId) throws Exception {
		int count = 0;

		count = adminDao.noTeacherNo(teacherId);

		return count;
	}

	// 관리자 아이디 조회
	public Admin adminSelect(String userId) {
		Admin admin = null;

		try {
			admin = adminDao.adminSelect(userId);
		} catch (Exception e) {
			logger.error("[adminService] adminSelect Exception", e);
		}

		return admin;
	}

	// 관리자 등록
	public int adminInsert(Admin admin) {
		int count = 0;
		try {
			count = adminDao.adminInsert(admin);
		} catch (Exception e) {
			logger.error("[adminService] adminInsert Exception", e);
		}

		return count;
	}

	// 주문 조회
	public List<Order> adminOrderList(Order order) {
		List<Order> orderList = null;

		try {
			orderList = adminDao.adminOrderList(order);
		} catch (Exception e) {
			logger.error("[AdminService] orderSelectList Exception", e);
		}

		return orderList;
	}

	// 주문 개수 조회
	public int adminOrderListCount(Order order) {
		int count = 0;

		try {
			count = adminDao.adminOrderListCount(order);
		} catch (Exception e) {
			logger.error("[AdminService] adminOrderListCount Exception", e);
		}

		return count;
	}

	// 주문 1건 조회
	public Order adminOrderSelect(long orderSeq) {
		Order order = null;

		try {
			order = adminDao.adminOrderSelect(orderSeq);
		} catch (Exception e) {
			logger.error("[AdminService] adminOrderSelect Exception", e);
		}

		return order;
	}

	// 주문/결제 상태 변경 (배송+주문 테이블)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int statusUpdate(Order order) {
		int count = 0;

		count = adminDao.orderStatusUpdate(order);

		if (count > 0) {
			// 배송준비/배송중/배송완료 --> 배송 테이블 건드려야 함
			if (order.getOrderStatus().equals("5") || order.getOrderStatus().equals("6") || order.getOrderStatus().equals("7")) {
				adminDao.deliStatusUpdate(order);
			}
		}

		return count;
	}

	// 주문/결제 상태 변경 (주문 테이블)
	public int orderStatusUpdate(Order order) {
		int count = 0;

		try {
			count = adminDao.orderStatusUpdate(order);
		} catch (Exception e) {
			logger.error("[AdminService] orderStatusUpdate Exception", e);
		}

		return count;
	}

	// 배송 상태 변경 (배송 테이블)
	public int deliStatusUpdate(Order order) {
		int count = 0;

		try {
			count = adminDao.deliStatusUpdate(order);
		} catch (Exception e) {
			logger.error("[AdminService] deliStatusUpdate Exception", e);
		}

		return count;
	}

	// 주문 상세 조회
	public List<OrderDetail> adminOrderDetailSelect(long orderSeq) {
		List<OrderDetail> odl = null;

		try {
			odl = adminDao.adminOrderDetailSelect(orderSeq);
		} catch (Exception e) {
			logger.error("[AdminService] adminOrderDetailSelect Exception", e);
		}

		return odl;
	}

	// 배송 상세 조회
	public DeliveryInfo adminDeliInfoSelect(long ordrSeq) {
		DeliveryInfo di = null;

		try {
			di = adminDao.adminDeliInfoSelect(ordrSeq);
		} catch (Exception e) {
			logger.error("[AdminService] adminOrderDetailSelect Exception", e);
		}

		return di;
	}

	// 강좌목록 리스트
	public List<Course> getCourseListSelect(long classCode, String courseStatus) {
		List<Course> courseList = null;

		try {
			courseList = adminDao.getCourseListSelect(classCode, courseStatus);
		} catch (Exception e) {
			logger.error("[AdminService] getCourseListSelect Exception", e);
		}

		return courseList;
	}

	// 강좌삭제
	public int getcourseDel(long courseCode) {
		int count = 0;

		try {
			count = adminDao.getcourseDel(courseCode);
		} catch (Exception e) {
			logger.error("[AdminService] getcourseDel Exception", e);
		}

		return count;
	}

	// 강좌신청 승인
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noCourseOk(long courseCode) throws Exception {
		int count = 0;

		count = adminDao.noCourseOk(courseCode);

		return count;
	}

	// 강좌신청 반려
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noCourseNo(long courseCode) throws Exception {
		int count = 0;

		count = adminDao.noCourseNo(courseCode);

		return count;
	}

}
