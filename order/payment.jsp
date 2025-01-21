<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>

<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/order/payment.css" rel="stylesheet">

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>

<style>
.header {
	background-color: #64B9B2;
}
</style>

<script>
   $(document).ready(function() {
      var list = '<c:out value="${list}" />';
      var qttChk = '<c:out value="${qttChk}"/>';

      if (list.length <= 2) {
         Swal.fire({
            position: "center", 
            icon: "warning",
            title: "결제할 상품이 존재하지 않습니다.",
            showConfirmButton: false, 
            timer: 1500 
         }).then(function() {
            location.href = "/order/basket";
         });
      }
      
      if (qttChk == 'N'){
         Swal.fire({
            position: "center", 
            icon: "warning",
            title: "재고가 모자랍니다. 다시 확인해주세요.",
            showConfirmButton: false, 
            timer: 1500 
         }).then(function() {
            location.href = "/order/basket";
         });
      }

            document.getElementById("delivery-option").addEventListener("change", function() {
                     const textarea = document.getElementById("custom-message");
                     if (this.value === "custom") {
                        textarea.disabled = false; // 직접입력을 선택하면 활성화
                     } else {
                        textarea.disabled = true; // 다른 옵션을 선택하면 비활성화
                        textarea.value = ""; // 입력 내용 초기화
                     }
            });
   });
   
   let kakaoPayPopup = null;
   let checkPopupInterval = null;

   function fn_pageMove(url) {
      location.href = "/order/" + url;
   }
   
   // 결제하기 버튼 눌렀을 때
   function fn_pay() {
      $("#payBtn").prop("disabled", true);
      
      if ($.trim($("#userName").val()).length <= 0) {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "이름을 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#userName").val("");
         $("#userName").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      if ($("#phone1").val() === "1") {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "연락처를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#phone1").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      if ($.trim($("#phone2").val()).length <= 3) {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "연락처를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#phone2").val("");
         $("#phone2").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      if ($.trim($("#phone3").val()).length <= 3) {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "연락처를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#phone3").val("");
         $("#phone3").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      if ($.trim($("#addrCode").val()).length <= 0) {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "주소를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#addrCode").val("");
         $("#addrCode").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      if ($.trim($("#addrBase").val()).length <= 0) {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "주소를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#addrBase").val("");
         $("#addrBase").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      if ($.trim($("#addrDetail").val()).length <= 0) {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "상세주소를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#addrDetail").val("");
         $("#addrDetail").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
      const selectedValue = $('#delivery-option').val();
        let deliveryMessage = '';
      
      if (selectedValue === "none") {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "배송 메시지를 선택해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#delivery-option").focus();
         $("#payBtn").prop("disabled", false);
         return;
      }
      
        if (selectedValue === "front-door" || selectedValue === "security") {
            deliveryMessage = $('#delivery-option option:selected').text(); // HTML 값 가져오기
            
        } else if (selectedValue === "custom") {
            deliveryMessage = $('#custom-message').val(); // Textarea 값 가져오기
            
            if (deliveryMessage <= 0) { // 길이가 0이면
               Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "요청사항을 입력해주세요", 
                  showConfirmButton: false, 
                  timer: 1500 
                  });

             $("#payBtn").prop("disabled", false);
                return; // 경고창 후 함수 종료
            }

        } else {
           Swal.fire({
              position: "center", 
              icon: "warning",
              title: "배송 요청사항을 선택해주세요", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#payBtn").prop("disabled", false);
            return;
        }
        
       const name = $("#userName").val(); 
       const phone = $("#phone1").val() + $("#phone2").val() + $("#phone3").val();
       const addrCode = $("#addrCode").val();
       const addrBase = $("#addrBase").val();
       const addrDetail = $("#addrDetail").val();
       const totalPrice = ${totalPrice + 3000 };
       
       // 모든 bookSeqList 값을 가져오기
       const bookSeqList = [];
       document.querySelectorAll('input[name="bookSeqList"]').forEach(input => {
           bookSeqList.push(input.value);
       });

       // bookSeqList 값 출력
       console.log(bookSeqList);
      
      let formData = {
            name,
            phone,
            addrCode,
            addrBase,
            addrDetail,
            deliveryMessage,
            bookSeqList,
            totalPrice
      }
      
       console.log("Form Data:", formData);
      
      // ################ 구매 처리 시작 ################
      
       $.ajax({
            type:"POST",
            url:"/kakao/readyAjax",
            data: JSON.stringify(formData),
            contentType: "application/json; charset=UTF-8", // Content-Type 명시
            datatype:"JSON",
            beforeSend:function(xhr)
            {
               xhr.setRequestHeader("AJAX", "true");
            },
            success:function(res)
            {
               icia.common.log(res);
               
               if(res.code == 0)
               {
                  let _width = 500;
                  let _height = 500;
                  
                  let _left = Math.ceil((window.screen.width - _width) / 2);
                  let _top = Math.ceil((window.screen.height - _height) / 2);
                  
                  kakaoPayPopup = window.open(res.data.next_redirect_pc_url, "카카오페이 결제", "width="+_width+", height="+_height+", left="+_left+", top="+_top+", resizable=false, scrollbars=false, status=false, titlebar=false, toolbar=false, menubar=false");
              
                  document.getElementById("payBtn").disabled = true; 
                  
              // 팝업 창이 닫혔는지 주기적으로 확인
                  checkPopupInterval = setInterval(function() {
                      if (kakaoPayPopup.closed) {
                          // 팝업 창이 닫혔다면 결제 취소로 처리
                          clearInterval(checkPopupInterval); // 인터벌 중지
                          Swal.fire({
                              position: "center", 
                              icon: "warning",
                              title: "결제가 취소되었습니다.",
                              text: "마이페이지에서 30분 이내 재결제시 구매 가능합니다",
                              showConfirmButton: true,
                          }).then(function() {
                              location.href = "/user/paymentHistory"; // 결제 취소 후 장바구니로 이동
                          });
                      }
                  }, 1000); // 1초마다 팝업 창 상태를 확인
                  
               }
               else
               {
                  Swal.fire({
                        position: "center", 
                        title: res.msg, 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
            },
            error:function(error)
            {
               icia.common.error(error);
            }
         });
      
   }
   
   function fn_kakaoPayResult(code, msg, orderId)
      {
         /*
         code : 0  -> 결제 완료
                -1 -> 결제 승인 실패
                -2 -> 결제 취소
                -3 -> 결제 실패
                -4 -> 결제 승인 리턴값 없음.
         */
         
         if(kakaoPayPopup != null)
         {
            if(icia.common.type(kakaoPayPopup) == "object" && !kakaoPayPopup.closed)
            {
               //카카오페이 팝업창이 객체이면서 닫히지 않았다면 창을 닫는다.
               kakaoPayPopup.close();
            }
            
            //카카오페이 팝업창 객체 초기화
            kakaoPayPopup = null;
         }
         
           icia.common.log("code : [" + code + "]");
           icia.common.log("msg : [" + msg + "]");
           icia.common.log("orderId : [" + orderId + "]");
                
         // 결제성공
         if(code == 0)
         {
            // 주문번호 값 받아서 저장
            document.orderForm.orderSeq.value = orderId;
            
            document.orderForm.action = "/order/paySuccess";
            document.orderForm.submit();
         }
         else
         {
            Swal.fire({
               position: "center", 
               icon: "warning",
               title: msg,
               showConfirmButton: false, 
               timer: 1500 
               }).then(function() {
                  location.href = "/order/basket";
               });
         }
      }
      // ################ 구매 처리 끝 ################
   
   
   
   
   
   
</script>


</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">Payment</h1>
				<p class="mainContent">결제</p>
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
					<span class="basket-title">주문결제</span>
				</div>

				<div class="progress-container">
					<div class="step">
						<div class="icon">
							<img src="https://img.icons8.com/ios-filled/50/ffffff/shopping-cart.png" alt="장바구니">
						</div>
						<p>장바구니</p>
					</div>
					<div class="arrow">&gt;</div>
					<div class="step active">
						<div class="icon">
							<img src="https://img.icons8.com/ios-filled/50/ffffff/cash-in-hand.png" alt="주문결제">
						</div>
						<p>주문결제</p>
					</div>
					<div class="arrow">&gt;</div>
					<div class="step">
						<div class="icon">
							<img src="https://img.icons8.com/ios/50/aaaaaa/money.png" alt="결제완료">
						</div>
						<p>결제완료</p>
					</div>
				</div>

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
							<c:forEach var="cart" items="${list }" varStatus="status">
								<tr>
									<td class="product-price">${cart.book.bookTitle }</td>
									<td>${cart.prdCnt }</td>
									<td><span class="product-price"> <fmt:formatNumber value="${cart.book.bookPayPrice * cart.prdCnt}" type="number" pattern="#,###" /></span>원</td>
									<input type="hidden" name="bookSeqList" id="bookSeqList" value="${cart.book.bookSeq }">
								</tr>
							</c:forEach>
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
							<td><input type="text" id="userName" name="userName" placeholder="이름을 입력해주세요"></td>
						</tr>
						<tr>
							<th>휴대폰번호</th>
							<td><select class="phone-select" id="phone1">
									<option value="1">선택</option>
									<option value="010">010</option>
									<option value="011">011</option>
							</select> - <input type="text" maxlength="4" id="phone2" placeholder="0000" style="width: 50px;"> - <input type="text" maxlength="4" id="phone3" placeholder="0000" style="width: 50px;"> <span class="description">- 주문/배송 정보를 안내드리오니 정확하게 입력해주세요.</span></td>
						</tr>
						<tr>
							<th>배송주소</th>
							<td><input type="text" id="addrCode" name="addrCode" maxlength="5" placeholder="우편번호를 입력해주세요" style="width: 30%;">
								<button type="button" class="find-address" id="addrCodeBtn" onclick="checkPost()">주소찾기</button> <br> <input type="text" id="addrBase" name="addrBase" placeholder="주소를 입력해주세요" style="margin-top: 5px; width: 90%;"> <input type="text" id="addrDetail" name="addrDetail" placeholder="상세주소를 입력해주세요" style="margin-top: 5px; width: 90%;"> <span class="description">- 원활한 배송을 위해 주소를 정확히 입력해주세요.</span></td>
						</tr>
						<tr>
							<th>배송메시지</th>
							<td>
								<div class="delivery-row">
									<select id="delivery-option" name="delOption">
										<option value="none">배송 요청사항을 선택해주세요</option>
										<option value="front-door">문 앞에 두고 가세요</option>
										<option value="security">경비실에 맡겨주세요</option>
										<option value="custom">직접 입력</option>
									</select>
									<textarea id="custom-message" id="customDel" placeholder="요청사항을 입력하세요" disabled></textarea>
								</div>
							</td>
						</tr>
					</table>
				</div>
			</div>


			<div class="summary-container">
				<table class="summary-table">
					<tr>
						<td class="summary-total">
							<div class="total-label">총 주문금액</div>
							<div class="total-sub-value">
								<fmt:formatNumber value="${totalPrice}" type="number" pattern="#,###" />
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
							<div class="total-label">총 결제예정금액</div>
							<div class="total-value" id="totalPrdPrice">
								<fmt:formatNumber value="${totalPrice + 3000 }" type="number" pattern="#,###" />
								원
							</div>
						</td>
					</tr>
				</table>
			</div>

			<div class="payment-method">
				<span class="sub-title">결제수단</span>
				<div class="radio-group">
					<label> <input type="radio" name="payment" checked /> 카카오페이
					</label>
				</div>
			</div>

			<div class="button-group">
				<button class="cart-button" onclick="fn_pageMove('basket')">장바구니 가기</button>
				<button class="pay-button" id="payBtn" onclick="fn_pay()">결제하기</button>
			</div>

		</div>

	</section>

	<form name="orderForm" method="post">
		<input type="hidden" name="orderSeq" value="">
	</form>

</body>
</html>
