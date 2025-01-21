package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Admin;
import com.sist.web.model.Course;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;
import com.sist.web.model.DeliveryInfo;
import com.sist.web.model.Order;
import com.sist.web.model.OrderDetail;
import com.sist.web.model.OrderStatus;

@Repository("adminDao")
public interface AdminDao {

	// 이번달 주문건수
	public int monthOrderCnt();

	// 이번달 주문금액
	public int monthOrderPrice();

	// 이번달 주문상태
	public List<OrderStatus> monthOrderStatus();

	// 최근 6개월 주문내역 조회
	public int getOrderCount(int count);

	// 관리자 조회
	public Admin adminSelect(String userId);

	// 최근 회원가입 정보
	public List<User> userSelectAll(@Param("rating") String rating, @Param("status") String status);

	// 최근 회원가입 정보
	public List<Teacher> selectNoTeacher(@Param("classCode") String classCode);

	// 강사신청 승인
	public int noTeacherOk(String teacherId);

	// 강사신청 거절
	public int noTeacherNo(String teacherId);

	// 관리자 등록
	public int adminInsert(Admin admin);

	// 주문 조회
	public List<Order> adminOrderList(Order order);

	// 주문 개수 조회
	public int adminOrderListCount(Order order);

	// 주문 1건 조회
	public Order adminOrderSelect(long orderSeq);

	// 주문/결제/배송 상태 변경 (주문 테이블)
	public int orderStatusUpdate(Order order);

	// 주문/결제 배송 상태 변경 (배송 테이블)
	public int deliStatusUpdate(Order order);

	// 주문 상세 조회
	public List<OrderDetail> adminOrderDetailSelect(long orderSeq);

	// 배송 정보 조회
	public DeliveryInfo adminDeliInfoSelect(long orderSeq);

	// 강좌목록 리스트
	public List<Course> getCourseListSelect(@Param("classCode") long classCode, @Param("courseStatus") String courseStatus);

	// 강좌삭제
	public int getcourseDel(long courseCode);

	// 강좌승인
	public int noCourseOk(long courseCode);

	// 강좌반려
	public int noCourseNo(long courseCode);
	
}
