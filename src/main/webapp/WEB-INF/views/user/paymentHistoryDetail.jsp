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

<link href="/resources/css/mypage/mypagePaymentHDS.css" rel="stylesheet">


<script>
let kakaoPayPopup = null;

function fn_pay(orderSeq) {
	// ################ 구매 처리 시작 ################
	 $.ajax({
		  type: "POST",
		    url: "/kakao/readyAjax",
		    data: JSON.stringify({ orderSeq: orderSeq }),
		    contentType: "application/json; charset=utf-8", // JSON 요청임을 명시
		    dataType: "json", // 서버 응답을 JSON으로 파싱
		    beforeSend: function(xhr) {
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
	         }
	         else
	         {
	            alert(res.msg);
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
      alert(msg);
   }
}
// ################ 구매 처리 끝 ################

// 주문 취소
function fn_orderCancel(orderSeq) {
	
	Swal.fire({
        title: "주문을 취소하시겠습니까?",
        text: "취소 후 되돌릴 수 없습니다!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "확인",
        cancelButtonText: "돌아가기"
    }).then((result) => {
        if (result.isConfirmed) {
            // AJAX 요청
    		$.ajax({
    		    type: "POST",
    		    url: "/order/orderDelete",
    		    contentType: "application/json",
    		    dataType: "JSON",
    		    data: JSON.stringify({ orderSeq: orderSeq }),
    		    success: function(res) {
    		        if (res.code === 0) 
    		        {
                        Swal.fire({
                            title: "취소 완료!",
                            text: "주문이 취소되었습니다.",
                            icon: "success"
                        }).then(() => {
                        	location.href = "/user/paymentHistory";
                        });
    		        } 
    		        else 
    		        {
                        Swal.fire({
                            title: "실패!",
                            text: "오류가 발생하였습니다. 다시 시도해주세요.",
                            icon: "error"
                        });
    		            
    		        }
    		    },
    		    error: function(xhr, status, error) {
                    Swal.fire({
                        title: "Error!",
                        text: "삭제 중 오류가 발생했습니다2",
                        icon: "error"
                    });
    		    }
    		});
        }
    });
	
	
}


// 결제 취소 (환불신청)
function fn_payCancel(orderSeq) {
	
	Swal.fire({
        title: "환불하시겠습니까?",
        text: "환불을 신청하시면 철회가 불가능합니다.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "확인",
        cancelButtonText: "돌아가기"
    }).then((result) => {
        if (result.isConfirmed) {
            // AJAX 요청
    		$.ajax ({
    			type : "POST",
    			url : "/order/payCancleApply",
    			data : {
    				orderSeq : orderSeq
    			},
    			dataType : "JSON",
    			beforeSend:function(xhr)
    	        {
    	        	 xhr.setRequestHeader("AJAX", "true");
    	        },
    	        success:function(res)
    	        {
    	    	  	if (res.code == 0) 
    	    	  	{
                        Swal.fire({
                            title: "환불 완료!",
                            text: "환불 신청이 완료되었습니다.",
                            icon: "success"
                        }).then(() => {
                        	location.href = "/user/paymentHistory";
                        });

    	    	  	}
    	    	  	else {
                        Swal.fire({
                            title: "실패!",
                            text: "오류가 발생하였습니다. 다시 시도해주세요.",
                            icon: "error"
                        });
    	    	  	}
    	        },
    	        error:function(error)
    	        {
    	        	 icia.common.error(error);
    	        }
    		});
        }
    });
	
	

	
}






</script>



</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div">
					<h2 class="first-title">주문/배송 상세조회</h2>
				</div>
				
			
				<div class="boardContainer">
					<div class="paymentTopContainer">
						<div class="topInfo orderStatus">
							주문번호<span>${order.orderSeq }</span>
						</div>
						<div class="topInfo orderStatus">
							주문날짜<span>${order.orderDate }</span>
						</div>
						<div class="topInfo orderStatus">
							주문상태<span>${viewStatus }</span>
						</div>
					</div>
					
<c:if test="${viewStatus eq '입금대기' }">					
				<div class="cancle-comment">
					<h4 style="text-align: center;"><b style="color: red">30분</b> 이내 미입금시 주문이 자동 취소됩니다.</h4>
				</div>
</c:if>


					<div class="title-div paymentInfo">
						<h2 class="first-title subTitle">결제정보</h2>
						<div>
							<div class="payment-Item">
								총 상품 금액
								<span>
								<fmt:formatNumber value="${order.payPrice - 3000 }" type="number" pattern="#,###" />원
								</span>
							</div>
							<div class="payment-Item">
								배송비<span>3,000원</span>
							</div>
							<div class="payment-Item">
								총 결제 금액
								<span>
								<fmt:formatNumber value="${order.payPrice}" type="number" pattern="#,###" />원
								</span>
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
							
<c:if test="${!empty orderDetailList }">	
	<c:forEach var="od" items="${orderDetailList }" varStatus="status">						
								<tr>
									<td>${od.proName}</td>
									<td>${od.orderCnt }</td>
									<td>
									<fmt:formatNumber value="${od.payPrice}" type="number" pattern="#,###" />원
									</td>
								</tr>
	</c:forEach>							
</c:if>								
								
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
									<td>${deliInfo.dlvName }</td>
								</tr>
								<tr>
									<td>전화번호</td>
									<td>
									<c:set var="phone" value="${deliInfo.userPhone}" />
									<c:set var="formattedPhone" value="${fn:substring(phone, 0, 3)}-${fn:substring(phone, 3, 7)}-${fn:substring(phone, 7, fn:length(phone))}" />
									${formattedPhone}
									</td>
								</tr>
								<tr>
									<td>배송주소</td>
									<td>[${deliInfo.addrCode }] ${deliInfo.addrBase } ${deliInfo.addrDetail }</td>
								</tr>
								<tr>
									<td>배송메세지</td>
									<td>${deliInfo.dlvRequest }</td>
								</tr>
							</tbody>
						</table>
					</div>

					<div class="btnContainer">
					
<c:if test="${viewStatus eq '입금대기' }">					
						<button type="button" id="payBtn" class="inputBtn" onclick="fn_pay('${orderSeq}')">
							<span>결제하기</span>
						</button>
						
						<button type="button" id="myClassBtn" class="inputBtn" onclick="fn_orderCancel('${orderSeq}')">
							<span>주문취소</span>
						</button>
</c:if>		

						<!--  취소완료 상태가 아니면 보여주기 -->
<c:if test="${viewStatus ne '주문취소'  && viewStatus ne '취소요청' && viewStatus ne '입금대기'}">						
						<button type="button" id="myClassBtn" class="inputBtn" onclick="fn_payCancel('${orderSeq}')">
							<span>환불신청</span>
						</button>
</c:if>
						
						<button type="button" id="breakDownBtn" class="inputBtn" onclick="fn_pageMove('paymentHistory')">
							<span>주문/배송내역 보기</span>
						</button>
						
						
					</div>
				</div>
			</div>
		</div>
	</div>
</body>


<form name="orderForm" id="orderForm">
	<input type="hidden" name="orderSeq" value="${orderSeq }">
</form>



</html>