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

<link href="/resources/css/mypage/mypagePayment.css" rel="stylesheet">

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div">
					<h2 class="first-title">결제</h2>
				</div>
				<div class="boardContainer">
					<div class="table-container">

						<div class="payment-order-product">
							<table>
								<thead>
									<tr>
										<th>상품정보</th>
										<th>수량</th>
										<th>상품가격</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>[교재번호]2026 기본 유형 독해</td>
										<td>1</td>
										<td>23,000원</td>
									</tr>
									<tr>
										<td>[수학] 2025 개념에센스 (공통)</td>
										<td>1</td>
										<td>23,000원</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>

					<div class="second-div title-div" style="border: none;">
						<h2 class="second-title first-title">배송정보</h2>
					</div>
					<div class="deli-info-container">
						<table>
							<tbody>
								<tr>
									<td>받으시는 분</td>
									<td><input type="text" class="input-field" size="10" /></td>
								</tr>
								<tr>
									<td>전화번호</td>
									<td><select id="phone-prefix" class="select-field">
											<option value="선택">선택</option>
											<option value="010">010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="018">018</option>
											<option value="019">019</option>
									</select> <span>-</span> <input type="text" class="input-field short" size="4" /> <span>-</span> <input type="text" class="input-field" size="4" /></td>
								</tr>
								<tr>
									<td>배송주소</td>
									<td>
										<div class="addr-div">
											<input type="text" id="addrCode" class="input-field long" size="20" maxlength="5" required />
											<button type="button" id="addrCodeBtn" class="addrCodeBtn" onclick="checkPost()">우편번호 검색</button>
											<br>
											<input type="text" id="addrBase" class="input-field long" size="50" required />
											<br>
											<input type="text" class="input-field long" size="50" />
										</div>
									</td>
								</tr>
								<tr>
									<td>배송메시지</td>
									<td><input type="text" class="input-field long" size="50" /></td>
								</tr>
							</tbody>
						</table>
					</div>


					<div class="second-div title-div">
						<h2 class="second-title first-title">결제정보</h2>
					</div>
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


					<div class="second-div title-div">
						<h2 class="second-title first-title">결제수단</h2>
					</div>

					<div class="payment-method">
						<label for="product_a"> <input type="radio" name="product" id="product_a" value="A" checked> <span class="kakaopay-span">카카오페이</span>
						</label>
					</div>

					<div class="button-container">
						<button type="button" id="paymentBtn" class="inputBtn" onclick="fn_pageMove('paymentResult')">
							<span>결제하기</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>