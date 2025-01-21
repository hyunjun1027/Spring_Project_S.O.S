<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>

<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/order/paySuccess.css" rel="stylesheet">

<style>
.header {
	background-color: #64B9B2;
}
</style>

<script>
	$(document).ready(function() {

	});

	function fn_pageMove(url) {
		location.href = url;
	}
</script>


</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">Pay Success!</h1>
				<p class="mainContent">결제완료</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/cart.png" alt="Clover Image">
			</div>
		</div>
	</section>

	<section class="content-section">

		<div class="cart-container">

			<div class="header-container">
				<div class="title-container">
					<span class="basket-title">결제완료</span>
				</div>

				<div class="progress-container">
					<div class="step">
						<div class="icon">
							<img src="https://img.icons8.com/ios-filled/50/ffffff/shopping-cart.png" alt="장바구니">
						</div>
						<p>장바구니</p>
					</div>
					<div class="arrow">&gt;</div>
					<div class="step">
						<div class="icon">
							<img src="https://img.icons8.com/ios/50/aaaaaa/cash-in-hand.png" alt="주문결제">
						</div>
						<p>주문결제</p>
					</div>
					<div class="arrow">&gt;</div>
					<div class="step active">
						<div class="icon">
							<img src="https://img.icons8.com/ios-filled/50/ffffff/money.png" alt="결제완료">
						</div>
						<p>결제완료</p>
					</div>
				</div>


			</div>

			<div class="order-confirmation">
				<p class="message">정상적으로 주문이 처리되었습니다.</p>
				<p class="order-number">
					주문번호: <span class="number">${order.orderSeq }</span>
				</p>
			</div>


			<span class="sub-title">결제정보</span>
			<div class="summary-container">
				<table class="summary-table">
					<tr>
						<td class="summary-total">
							<div class="total-label">총 주문금액</div>
							<div class="total-sub-value">
								<fmt:formatNumber value="${order.payPrice - 3000 }" type="number" pattern="#,###" />
								원
							</div>
						</td>
						<td class="summary-symbol">+</td>
						<td class="summary-total">
							<div class="total-label">배송비</div>
							<div class="total-sub-value">3,000원</div>
						</td>
						<td class="summary-symbol">=</td>
						<td class="summary-total">
							<div class="total-label">총 결제 금액</div>
							<div class="total-value">
								<fmt:formatNumber value="${order.payPrice}" type="number" pattern="#,###" />
								원
							</div>
						</td>
					</tr>
				</table>
			</div>



			<div class="order-product">
				<span class="sub-title">주문상품</span>
				<div class="table">
					<table class="cart-table">
						<thead>
							<tr>
								<th>상품정보</th>
								<th>수량</th>
								<th>상품가격</th>
							</tr>
						</thead>
						<tbody>

							<c:if test="${!empty orderDetailList }">
								<c:forEach var="od" items="${orderDetailList }" varStatus="status">

									<tr>
										<td class="product-price">${od.proName }</td>
										<td>${od.orderCnt }</td>
										<td><span class="product-price"> <fmt:formatNumber value="${od.payPrice}" type="number" pattern="#,###" />
										</span>원</td>
									</tr>

								</c:forEach>
							</c:if>

						</tbody>
					</table>
				</div>
			</div>


			<div class="deli-info">
				<span class="sub-title">배송정보</span>
				<div class="form-container">
					<table class="form-table">
						<tr>
							<th>받으시는 분</th>
							<td>${deliInfo.dlvName }</td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td><c:set var="phone" value="${deliInfo.userPhone}" /> <c:set var="formattedPhone" value="${fn:substring(phone, 0, 3)}-${fn:substring(phone, 3, 7)}-${fn:substring(phone, 7, fn:length(phone))}" /> ${formattedPhone}</td>
						</tr>
						<tr>
							<th>배송주소</th>
							<td>[${deliInfo.addrCode }] ${deliInfo.addrBase } ${deliInfo.addrDetail }</td>
						</tr>
						<tr>
							<th>배송메시지</th>
							<td>
								<div class="delivery-row">${deliInfo.dlvRequest }</div>
							</td>
						</tr>
					</table>
				</div>
			</div>

			<div class="button-group">
				<button class="green-button" onclick="fn_pageMove('/user/paymentHistory')">주문/배송내역 보기</button>
				<button class="blue-button" onclick="fn_pageMove('/user/studyList')">내 강의실 바로가기</button>
			</div>

		</div>

	</section>
</body>
</html>
