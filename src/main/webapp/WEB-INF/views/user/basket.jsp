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

<link href="/resources/css/mypage/mypageBasket.css" rel="stylesheet">
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div">
					<h2 class="first-title">장바구니</h2>
				</div>

				<div class="boardContainer">
					<table>
						<thead>
							<tr>
								<th style="width: 10%;">선택</th>
								<th style="width: 50%;">상품정보</th>
								<th style="width: 15%;">상품가격</th>
								<th style="width: 10%;">수량</th>
								<th style="width: 15%;">주문/삭제</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td><input type="checkbox"></td>
								<td>[수학Ⅰ] 2025 개념에센스 (공통)</td>
								<td>92,000원</td>
								<td>1</td>
								<td>
									<div class="button-container">
										<button type="button" id="paymentBtn" class="inputBtn" onclick="fn_pageMove('payment')">
											<span>바로결제</span>
										</button>
										<button type="button" id="deleteBtn" class="inputBtn" onclick="">
											<span>삭제</span>
										</button>
									</div>
								</td>
							</tr>

							<tr>
								<td><input type="checkbox"></td>
								<td>[수학Ⅰ] 2025 개념에센스 (공통)</td>
								<td>92,000원</td>
								<td>1</td>
								<td>
									<div class="button-container">
										<button type="button" id="paymentBtn" class="inputBtn" onclick="fn_pageMove('payment')">
											<span>바로결제</span>
										</button>
										<button type="button" id="deleteBtn" class="inputBtn" onclick="">
											<span>삭제</span>
										</button>
									</div>
								</td>
							</tr>


							<tr>
								<td><input type="checkbox"></td>
								<td>[수학Ⅰ] 2025 개념에센스 (공통)</td>
								<td>92,000원</td>
								<td>1</td>
								<td>
									<div class="button-container">
										<button type="button" id="paymentBtn" class="inputBtn" onclick="fn_pageMove('payment')">
											<span>바로결제</span>
										</button>
										<button type="button" id="deleteBtn" class="inputBtn" onclick="">
											<span>삭제</span>
										</button>
									</div>
								</td>
							</tr>

						</tbody>
					</table>

					<div class="select-all">
						<label><input type="checkbox"> 전체선택</label>
						<button class="btn-select-delete">선택삭제</button>
					</div>

					<div class="table-container">


						<div class="pay-container">
							<div>
								<h3>총 상품금액</h3>
								<span class="pay">0</span>&nbsp;원
							</div>

							<div>
								<h3>배송비</h3>
								<span class="pay">0</span>&nbsp;원
							</div>

							<div>
								<h3>총 결제예정금액</h3>
								<span class="pay-green">0</span>&nbsp;원
							</div>
						</div>

						<div class="btnContainer">
							<button type="button" id="selectOrderBtn" class="inputBtn" onclick="fn_pageMove('payment')">
								<span>선택상품주문</span>
							</button>
							<button type="button" id="allOrderBtn" class="inputBtn" onclick="fn_pageMove('payment')">
								<span>전체상품주문</span>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>