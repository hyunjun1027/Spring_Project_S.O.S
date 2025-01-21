<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/mypage/paymentHDS.css" rel="stylesheet">

<div class="contentBoardContainer">
	<div class="boardContainer">
		<div class="paymentSTopContainer">
			<h2>정상적으로 주문이 처리되었습니다.</h2>
			<div class="topInfo orderSeq">
				주문번호<span>20241129109307</span>
			</div>
		</div>

		<div class="title-div paymentInfo">
			<h2 class="first-title subTitle">결제정보</h2>
			<div>
				<div class="payment-Item">
					총 상품 금액<span>0원</span>
				</div>
				<div class="payment-Item">
					배송비<span>0원</span>
				</div>
				<div class="payment-Item">
					총 결제 예정 금액<span>0원</span>
				</div>
			</div>
		</div>

		<div class="title-div orderInfo">
			<h2 class="first-title subTitle">주문정보</h2>
			<table>
				<thead>
					<tr>
						<th style="width: 50%;">상품정보</th>
						<th style="width: 20%;">수량</th>
						<th style="width: 30%;">상품가격</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>[교재번호] 2026 기본 유형 독해</td>
						<td>1</td>
						<td>23,000원</td>
					</tr>
					<tr>
						<td>[수학2] 2024 개념 에센스(공통)</td>
						<td>2</td>
						<td>23,000원</td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="title-div shippingInfo">
			<h2 class="first-title subTitle">배송정보</h2>
			<table>
				<tbody>
				<thead>
					<tr>
						<th style="width: 20%;"></th>
						<th style="width: 80%;"></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>받으시는 분</td>
						<td>김덕수
					</tr>
					<tr>
						<td>전화번호</td>
						<td>010-1234-5678
					</tr>
					<tr>
						<td>배송주소</td>
						<td>[12345] 서울특별시 마포구 동교동 랄라로 33 3층
					</tr>
					<tr>
						<td>배송메세지</td>
						<td>택배함에 넣어주세요
					</tr>
				</tbody>
			</table>
		</div>

		<div class="btnContainer">
			<button type="button" id="breakDownBtn" class="inputBtn" onclick="fn_pageMove('paymentHistory')"><span>주문/배송내역 보기</span></button>
			<button type="button" id="myClassBtn" class="inputBtn" onclick="fn_pageMove('studyList')"><span>내 강의실 바로가기</span></button>
		</div>
	</div>
</div>