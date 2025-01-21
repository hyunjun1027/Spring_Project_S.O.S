<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<!-- mypage CSS File -->
<link href="/resources/css/mypage/mypage.css" rel="stylesheet">

<link href="/resources/css/mypage/mypagePaymentHistory.css" rel="stylesheet">

<script>


//페이지 이동
function fn_listView(curPage)
{
   document.bbsForm.curPage.value = curPage;
   document.bbsForm.action = "/user/paymentHistory";
   document.bbsForm.submit();
}

// 주문상세조회 페이지 이동
function fn_orderView(orderSeq) {
	document.bbsForm.curPage.value = 1;
	document.bbsForm.orderSeq.value = orderSeq;
	
	//alert(document.bbsForm.curPage.value);
	//alert(document.bbsForm.orderSeq.value);
	
	//document.bbsForm.method = "post";
	
	alert(document.bbsForm.method);
	
	/* document.bbsForm.action = "/user/paymentHistoryDetail";
	document.bbsForm.submit(); */
	
	const form = document.getElementById("bbsForm");
	form.method = "post";
	form.submit();
}

</script>
</head>







<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div board-header">
					<h2 class="first-title">주문/배송 조회</h2>
				</div>

				<div class="board-content">
					<table class="board-table">
						<thead>
							<tr>
								<th style="width: 10%;">주문번호</th>
								<th style="width: 55%;">주문내역</th>
								<th style="width: 10%;">결제가</th>
								<th style="width: 10%;">결제일</th>
								<th style="width: 15%;">배송상태/조회</th>
							</tr>
						</thead>
						<tbody>
						
							<c:if test="${!empty ol }">
								<c:forEach var="order" items="${ol }" varStatus="status">
									<tr>
										<td>${order.orderSeq }</td>

										<td onclick="event.stopPropagation();" style="width: 55%;"><a href="/user/paymentHistoryDetail?orderSeq=${order.orderSeq }"> ${order.orderProName } </a></td>


										<td><fmt:formatNumber value="${order.payPrice}" type="number" pattern="#,###" />원</td>
										<td><c:if test="${order.viewStatus ne '입금대기' }">${order.orderDate }</c:if></td>
										<td>${order.viewStatus }</td>
									</tr>
								</c:forEach>
							</c:if>



						</tbody>
					</table>
				</div>

				<div class="board-footer"></div>

				<div class="pagingContainer">
					<ul class="pagination">
						<c:if test="${!empty paging}">

							<c:if test="${paging.prevBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${paging.prevBlockPage})"> < </a></li>
							</c:if>

							<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
								<c:choose>
									<c:when test="${i ne curPage}">
										<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${i})">${i}</a></li>
									</c:when>
									<c:otherwise>
										<li class="page-item active"><a class="page-link" href="#" style="cursor: default;">${i}</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>

							<c:if test="${paging.nextBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${paging.nextBlockPage})"> > </a></li>
							</c:if>

						</c:if>
					</ul>
				</div>


			</div>
		</div>
	</div>

	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="curPage" id="curPage" value="1">
		<input type="hidden" name="orderSeq" id="orderSeq" value="">
	</form>


</body>
</html>