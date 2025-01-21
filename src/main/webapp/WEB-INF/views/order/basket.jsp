<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>

<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/order/basket.css" rel="stylesheet">

<style>
.header {
   background-color: #64B9B2;
}
</style>

<script>
   $(document).ready(function() {
      /* $("input[type='checkbox'][name='check']").on("change", function(){
         fn_getTotalCount();
      }); */
      // 전체선택 버튼 클릭 시 동작
      /* document.querySelector('.select-all').addEventListener('click', () => {
          const checkboxes = document.querySelectorAll('.item-checkbox');
          const allChecked = Array.from(checkboxes).every(checkbox => checkbox.checked); // 모든 체크박스가 선택되어 있는지 확인

          if (allChecked) {
              // 모든 체크박스가 선택된 상태라면 전체 선택 해제
              checkboxes.forEach(checkbox => {
                  checkbox.checked = false;
              });
          } else {
              // 하나라도 선택되지 않은 경우 전체 선택
              checkboxes.forEach(checkbox => {
                  checkbox.checked = true;
              });
          }
      }); */
   });
   
   function fn_pageMove(bookSeq) {
      document.cartForm.action = "/order/payment"
      document.cartForm.listType.value = bookSeq;
      document.cartForm.submit();
   }
   
   function fn_cntChange(bookSeq){
      var str = document.getElementById("prdCnt" + bookSeq);
      var prdCnt = str.options[str.selectedIndex].value;
      
      $.ajax({
         type:"POST",
         url:"/order/cartCntUpdate",
         data:{
            bookSeq:bookSeq,
            prdCnt:prdCnt
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
                  document.getElementById("product-price" + bookSeq).innerText = parseInt(res.data).toLocaleString();
                  fn_getTotalCount();
               }
               else{
                  Swal.fire({
                        position: "center", 
                        title: res.msg, 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
            }
            else{
               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "오류가 발생하였습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

            }
         },
         error:function(xhr, status, error){
            icia.common.error(error);
         }
      });
   }
   function fn_getTotalCount(){
      $.ajax({
         type:"POST",
         url:"/order/totalPrice",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(res){
            document.getElementById("totalPrice").innerText = parseInt(res.data).toLocaleString() + "원";
            document.getElementById("totalRealPrice").innerText = parseInt(res.data + 3000).toLocaleString() + "원";
         },
         error:function(xhr, status, error){
            icia.common.error(error);
         }
      });
   }
   function fn_checkedUpdate(bookSeq){
      $.ajax({
         type:"POST",
         url:"/order/checkedUpdate",
         data:{
            bookSeq:bookSeq
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(res){
            fn_getTotalCount();
         },
         error:function(xhr, status, error){
            icia.common.error(error);
         }
      })
   }
   function fn_cartDelete(bookSeq){
      $.ajax({
         type:"POST",
         url:"/order/cartDelete",
         data:{
            bookSeq:bookSeq
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(res){
            location.href = "";
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

   <section class="notice-section">
      <div class="notice-content">
         <div class="notice-text">
            <h1 class="mainTitle">Basket</h1>
            <p class="mainContent">장바구니</p>
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
               <span class="basket-title">장바구니</span> <span class="basket-sub-title">(<!-- 강좌 <span class="number">3</span> / -->교재 <span class="number">${bookCount }</span>)
               </span>
            </div>
            <div class="progress-container">
               <div class="step active">
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
               <div class="step">
                  <div class="icon">
                     <img src="https://img.icons8.com/ios/50/aaaaaa/money.png" alt="결제완료">
                  </div>
                  <p>결제완료</p>
               </div>
            </div>
         </div>


         <div class="table">
            <table class="cart-table">
               <thead>
                  <tr>
                     <th style="width: 10%;">선택</th>
                     <th style="width: 30%;">상품정보</th>
                     <th style="width: 30%;">상품가격</th>
                     <th style="width: 10%;">수량</th>
                     <th style="width: 20%;">주문/삭제</th>
                  </tr>
               </thead>
               <tbody>
               <c:if test="${!empty list }">               
                  <c:forEach var="cart" items="${list}" varStatus="status">
                  <tr>
                     <c:if test='${cart.checked eq "Y" && cart.book.invenQtt eq 0}'>
                     <script>
                        fn_checkedUpdate(${cart.bookSeq});
                     </script>
                     </c:if>
                     
                     <td><input type="checkbox" onclick="fn_checkedUpdate(${cart.bookSeq})"class="item-checkbox" name="check"
                     <c:if test="${cart.checked eq 'Y' && cart.book.invenQtt > 0}"> checked</c:if> 
                     <c:if test='${cart.book.invenQtt eq 0}'>disabled</c:if> ></td>
                     
                     <td class="product-price">${cart.book.bookTitle}</td>
                     <td><span class="product-price" id="product-price${cart.bookSeq}">
                     <c:choose>
                     <c:when test='${cart.book.invenQtt ne 0}'>
                     <fmt:formatNumber value="${cart.book.bookPayPrice * cart.prdCnt }" type="number" pattern="#,###"/>
                     </c:when>
                     <c:otherwise>
                     -----
                     </c:otherwise>
                     </c:choose>
                     </span>원</td>
                     
                     
                     <td>
                        <c:choose>
                        <c:when test='${cart.book.invenQtt > 0 }'>
                        <div class="quantity-container">
                           <select class="quantity-select" id="prdCnt${cart.bookSeq}">
                           <c:choose>
                              <c:when test='${cart.book.invenQtt < 5 }'>
                                 <c:set var="cnt" value="${cart.book.invenQtt}"/>
                              </c:when>
                              <c:otherwise>
                                 <c:set var="cnt" value="5"/>
                              </c:otherwise>
                           </c:choose>
                           <c:forEach var="index" begin="1" end="${cnt}">
                              <option value="${index}" <c:if test="${cart.prdCnt == index }">selected</c:if>>${index}</option>
                           </c:forEach>
                           </select>
                           <button class="change-button" onclick="fn_cntChange(${cart.bookSeq})">변경</button>
                           <c:if test='${cart.book.invenQtt < cart.prdCnt }'>
                              <script>
                                 fn_cntChange(${cart.bookSeq});
                              </script>
                           </c:if>
                        </div>
                        </c:when>
                        <c:otherwise>
                        <span>품절</span>
                        </c:otherwise>
                        </c:choose>
                     </td>
                     <td>
                        <div class="button-container">
                        <c:if test='${cart.book.invenQtt > 0}'>
                           <button type="button" class="pay-button" onclick="fn_pageMove(${cart.bookSeq})">바로결제</button>
                        </c:if>
                           <button class="delete-button" onclick="fn_cartDelete(${cart.bookSeq})">삭제</button>
                        </div>
                     </td>
                  </tr>
                  </c:forEach>
               </c:if>
            <c:if test="${empty list }">               
               <tr>
                  <td colspan="5">장바구니에 담긴 상품이 없습니다.</td>
               </tr>
            </c:if>
               </tbody>
            </table>
         </div>

         <div class="selection-buttons">
            <!-- <button class="select-all">전체선택</button> -->
            <button class="delete-selected" onclick="fn_cartDelete(0)">선택삭제</button>
         </div>


         <div class="summary-container">
            <table class="summary-table">
               <tr>
                  <td class="summary-total">
                     <div class="total-label">총 주문금액</div>
                     <div class="total-sub-value" id="totalPrice">
                     <fmt:formatNumber value="${totalPrice}" type="number" pattern="#,###"/>원
                     </div>
                  </td>
                  <td class="summary-symbol">+</td>
                  <td class="summary-total">
                     <div class="total-label">배송비</div>
                     <div class="total-sub-value">
                     
                  <c:choose>
                     <c:when test="${!empty list }">
                     3,000원
                     </c:when>      
                     <c:otherwise>
                     0원
                     </c:otherwise>
                  </c:choose>      
                     </div>
                  </td>
                  <td class="summary-symbol">=</td>
                  <td class="summary-total">
                     <div class="total-label">총 결제예정금액</div>
                     <div class="total-value" id="totalRealPrice">
                  <c:choose>
                     <c:when test="${!empty list }">   
                     <fmt:formatNumber value="${totalPrice + 3000 }" type="number" pattern="#,###"/>원
                     </c:when>
                     <c:otherwise>
                     0원
                     </c:otherwise>
                  </c:choose>
                     </div>
                  </td>
               </tr>
            </table>
         </div>

         <p class="info-text">
            * 총 결제예상 금액 및 추가 할인 혜택, 적립 포인트, 배송비 등은 실 결제단계에서 상품 특성 및 할인권 적용 등에 따라 차이가 발생할 수 있습니다.<br> * 장바구니에 담긴 상품은 보관기한이 만료되기 전 관리자에 의해 품절처리될 수 있습니다.
         </p>

         <div class="order-buttons">
            <button type="button" class="select-order" onclick="fn_pageMove(0)">선택상품주문</button>
            <button type="button" class="all-order" onclick="fn_pageMove(-1)">전체상품주문</button>
         </div>

      </div>
      
      <form id="cartForm" name="cartForm" method="post">
         <input name="listType" type="hidden" value="">
      </form>


   </section>
</body>
</html>
