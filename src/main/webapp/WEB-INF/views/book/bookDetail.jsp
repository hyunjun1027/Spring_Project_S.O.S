<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>

<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">


<link href="/resources/css/book/bookDetail.css" rel="stylesheet">
<style>
.header {
   background-color: #f1d5a6;
}
</style>

<script>
$(document).ready(function() {
   $("#navmenu>ul>li:nth-child(5)>a").addClass("active");
   
    //목록 버튼 클릭 시
    $("#listBtn").on("click", function() {
       document.bbsForm.action = "/book/book";
       document.bbsForm.submit();
    });
});

   function fn_pageMove(url) {
      location.href = "/order/" + url;
   }
   
   //Navi 과목별 이동
   function fn_list(classCode)
   {
      document.bbsForm.curPage.value = "1";
      document.bbsForm.classCode.value = classCode;
       document.bbsForm.action = "/book/book";
       document.bbsForm.submit();
   }
   
   // 즉시 구매
   function fn_directPay(bookSeq) {
      
      // 수량 가져오기
      const quantityInput = document.querySelector('.quantity-input');
      const prdCnt = quantityInput.value;
      
       $.ajax({
         type:"POST",
         url:"/order/cartDirectPay",
         data:{
            bookSeq : bookSeq,
            prdCnt : prdCnt
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(res){
            if(!icia.common.isEmpty(res)){
               icia.common.log(res);
               var code = icia.common.objectValue(res, "code", -500);
               
               if(code == 0){
                  console.log("즉시결제 데이터 삽입 성공");
                  
                  // 데이터 결제 폼으로 전송
                  document.cartForm.listType.value = bookSeq;
                  document.cartForm.prdCnt.value = 1;
                  document.cartForm.action = "/order/payment";
                  document.cartForm.submit();
                  
               }
               else if(code == -1){
                        Swal.fire({
                            title: "Error",
                            text: "오류가 발생하였습니다. 다시 시도해주세요.",
                            icon: "error"
                        });

               }
               else if (code == 404) {
                        Swal.fire({
                            title: "Error",
                            text: "로그인 후 이용해주세요.",
                            icon: "error"
                        });

               }
               else if(code == 400){
                        Swal.fire({
                            title: "Error",
                            text: res.msg,
                            icon: "error"
                        });
                  location.reload();
               }
               else{
                        Swal.fire({
                            title: "Error",
                            text: "오류가 발생하였습니다. 다시 시도해주세요.",
                            icon: "error"
                        });

               }
            }
            else{
                    Swal.fire({
                        title: "Error",
                        text: "오류가 발생하였습니다. 다시 시도해주세요.",
                        icon: "error"
                    });
            }
         },
         error:function(xhr, status, error){
            icia.common.error(error);
         }
      }); 
   }
   
   //목록 버튼 클릭시
   //책 장바구니에 담기
   function fn_cart(bookSeq) {
      const imgRect = document.querySelector(".product-image img").getBoundingClientRect();
       const imgTop = imgRect.top;
       const imgLeft = imgRect.left;
       
       const keyframes = "@keyframes cartMove { "
          + " 0% { width: 300px; height: 400px; top: " + imgTop + "px; left: " + imgLeft + "px; }"
           + " 100% { width: 24px; height: 24px; top: 30px; left: 82.7%; } }";

       const styleSheet = document.createElement("style");
       styleSheet.type = "text/css";
       styleSheet.innerText = keyframes;
       document.head.appendChild(styleSheet);

      $.ajax({
         type:"POST",
         url:"/order/cartInsert",
         data:{
            bookSeq:bookSeq,
            prdCnt:$("#prdCnt").val()
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(res){
            if(!icia.common.isEmpty(res)){
               icia.common.log(res);
               var code = icia.common.objectValue(res, "code", -500);
               if(code == 0){
                  $("#backetImg").attr("src", "/resources/images/book/" + bookSeq + ".jpg")
                     $("#backetImg").css({
                          visibility: "visible",
                          animation: "cartMove 0.5s ease-in-out",
                      });
                     setTimeout(() => {
                        $("#backetImg").css({
                             visibility: "hidden",
                             animation: "",
                         });
                         $("#cartCount").html(res.data);
                         
                         Swal.fire({
                           title: "장바구니에 넣었습니다",
                           icon: "success",
                           text:"장바구니로 이동하시겠습니까?",
                           showCancelButton: true,
                           confirmButtonColor: "#3085d6",
                           cancelButtonColor: "#d33",
                           confirmButtonText: "이동",
                           cancelButtonText:"취소"
                           }).then((result) => {
                             if (result.isConfirmed) {
                               location.href = "/order/basket";
                             }
                           });
                  }, 470);
               }
               else if(code == -1){
                       Swal.fire({
                           title: "Error",
                           text: res.msg,
                           icon: "error"
                       }).then(function() {
                     location.href = "/order/basket";
                       });
               }
               else if(code == 400){
                       Swal.fire({
                           title: "Error",
                           text: res.msg,
                           icon: "error"
                       }).then(function() {
                     location.reload();
                       });
               }
               else{
                       Swal.fire({
                           title: "Error",
                           text: res.msg,
                           icon: "error"
                       });
               }
            }
            else{
                    Swal.fire({
                        title:"오류가 발생했습니다.",
                        icon: "error"
                    });
            }
         },
         error:function(xhr, status, error){
            icia.common.error(error);
         }
      });
   }
</script>


</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
   <img alt="" src="" id="backetImg">
   <section class="notice-section">
      <div class="notice-content">
         <div class="notice-text">
            <h1 class="mainTitle">Book</h1>
            <p class="mainContent">교재</p>
         </div>
         <div class="notice-image">
            <img src="/resources/img/girin.png" alt="Clover Image">
         </div>
      </div>
   </section>

   <section class="content-section">
      <div class="sidebar">
         <div class="exam-date" id="d-day-display">
            2026 수능 <span class="days"></span>
         </div>
         <ul class="menu">
            <li><a href=# class="${classCode == 1 ? 'highlight' : ''}" onclick="fn_list(1)">국어</a></li>
            <li><a href=# class="${classCode == 2 ? 'highlight' : ''}" onclick="fn_list(2)">영어</a></li>
            <li><a href=# class="${classCode == 3 ? 'highlight' : ''}" onclick="fn_list(3)">수학</a></li>
            <li><a href=# class="${classCode == 4 ? 'highlight' : ''}" onclick="fn_list(4)">사회</a></li>
            <li><a href=# class="${classCode == 5 ? 'highlight' : ''}" onclick="fn_list(5)">과학</a></li>
         </ul>
      </div>

      <div class="table-container">

         <!--    <div class="input-select-align">
            <div class="input-select">
               <input type="text" class="form-control" placeholder="검색할 단어를 입력하세요." aria-label="Recipient's username" aria-describedby="button-addon2">
               <button type="button" id="btnSearch" style="cursor: pointer">
                  <img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;">
               </button>
            </div>
         </div>
       -->


         <div class="product-page">

            <div class="product-container">
               <div class="product">
                  <div class="product-image">
                     <img src="/resources/images/book/${book.bookSeq}.jpg" alt="수능 국어 트레이닝북 GYM 독서">
                  </div>
                  <div class="product-details">
                     <h2>${book.bookTitle}</h2>
                     <p>${book.bookAuth}| ${book.bookPublisher}</p>
                     <p class="book-info">${book.bookInfo}</p>
                     <hr />
                     <div class="price-info">
                        <p>
                           판매가 <span class="price-original"><fmt:formatNumber value="${book.bookPrice}" type="number" pattern="#,###" />원</span> <span class="price-sale"><fmt:formatNumber value="${book.bookPayPrice}" type="number" pattern="#,###" />원</span>
                        </p>
                        <p>
                           배송비 <span class="shipping-fee">3,000원</span>
                        </p>
                     </div>
                  </div>
               </div>
               <hr class="divider" />
               <div class="order-section">
                  <div class="order-checkbox">
                     <span class="book-name">${book.bookTitle}</span>
                  </div>
                  <div class="order-summary">
                     <span class="price-sale-bottom"><fmt:formatNumber value="${book.bookPayPrice}" type="number" pattern="#,###" />원</span>


                     <c:choose>
                        <c:when test="${book.invenQtt eq 0 }">
                           <button class="cart-button">품절</button>
                        </c:when>
                        <c:otherwise>
                           <div class="quantity-selector">
                              <button class="quantity-btn decrease" onclick="decreaseQuantity()">-</button>
                              <input type="text" id="prdCnt" class="quantity-input" value="1" readonly />
                              <button class="quantity-btn increase" onclick="increaseQuantity()">+</button>
                           </div>
                        </c:otherwise>
                     </c:choose>
                  </div>
               </div>

               <div class="total-container">
                  <div class="total-summary">
                     <span>총 주문 금액</span> <span class="total-price" id="total-price"><fmt:formatNumber value="${book.bookPayPrice}" type="number" pattern="#,###" />원</span>
                  </div>
               </div>

               <div class="button-group">
                  <button type="button" id="listBtn" class="list-button">목록</button>
                  <div class="button-right">
                     <c:if test="${book.invenQtt ne 0 }">
                        <button class="cart-button" onclick="fn_cart(${book.bookSeq})">장바구니</button>
                        <button class="buy-button" onclick="fn_directPay(${book.bookSeq})">즉시구매</button>
                     </c:if>
                  </div>
               </div>

            </div>

         </div>
      </div>
   </section>

   <%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

   <form id="bbsForm" name="bbsForm" method="post">
      <input type="hidden" name="bookSeq" value="${bookSeq}">
      <input type="hidden" name="classCode" value="${classCode}">
      <input type="hidden" name="searchType" value="${searchType}">
      <input type="hidden" name="searchValue" value="${searchValue}">
      <input type="hidden" name="curPage" value="${curPage}" />
   </form>

   <form id="cartForm" name="cartForm" method="post">
      <input name="listType" type="hidden" value="">
      <input name="prdCnt" type="hidden" value="">
   </form>

</body>

<script>
   // 이 스크립트 맨 위로 올리면 정상적으로 실행 안 됩니다.......................

   // 기본 변수 설정
   const unitPrice = ${book.bookPayPrice}; // 개당 판매가
   const quantityInput = document.querySelector('.quantity-input');
   const totalPriceElement = document.getElementById('total-price');

   console.log(document.getElementById('total-price'));

   function increaseQuantity() {
      const input = document.querySelector('.quantity-input');
      let value = parseInt(input.value);
      if (value < <c:choose><c:when test='${book.invenQtt < 5}'>${book.invenQtt}</c:when><c:otherwise>5</c:otherwise></c:choose>) {
         input.value = value + 1; // 현재 값을 1 증가
         updateTotalPrice(input.value);
      }
   }

   function decreaseQuantity() {
      const input = document.querySelector('.quantity-input');
      let value = parseInt(input.value);
      if (value > 1) {
         input.value = value - 1; // 현재 값을 1 감소
         updateTotalPrice(input.value);
      }
   }

   // 총 주문 금액 업데이트 함수
   function updateTotalPrice(quantity) {
      const totalPrice = unitPrice * quantity; // 총 금액 계산
      console.log("totalPrice : " + totalPrice + ", totalPriceElement: "
            + totalPriceElement);
      totalPriceElement.textContent = totalPrice.toLocaleString() + "원"; // 천 단위 콤마 추가
   }
</script>

</html>
