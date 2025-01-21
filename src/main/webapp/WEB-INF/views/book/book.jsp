<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>

<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/book/book.css" rel="stylesheet">
<style>
.header {
   background-color: #f1d5a6;
}
</style>
<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(5)>a").addClass("active");
   });
   
   function fn_list(classCode)
   {
      document.bbsForm.curPage.value = "1";
      document.bbsForm.searchType.value = "";
      document.bbsForm.searchValue.value = "";
      document.bbsForm.classCode.value = classCode;
       document.bbsForm.action = "/book/book";
       document.bbsForm.submit();
   }
   
   function fn_relist(searchType)
   {
      document.bbsForm.searchType.value = searchType;
      document.bbsForm.searchValue.value = $("#_searchValue").val();
      document.bbsForm.curPage.value = "";
      document.bbsForm.classCode.value = ${classCode};
       document.bbsForm.action = "/book/book";
       document.bbsForm.submit();
   }
   
   //페이지 이동
   function fn_Page(curPage)
   {
      document.bbsForm.classCode.value = ${classCode};
      document.bbsForm.curPage.value = curPage;
       document.bbsForm.action = "/book/book";
       document.bbsForm.submit();
   }
   
   //글 상세보기
   function fn_view(bookSeq)
   {
      document.bbsForm.classCode.value = ${classCode};
      document.bbsForm.curPage.value = ${curPage};
      document.bbsForm.bookSeq.value = bookSeq;
      document.bbsForm.action = "/book/bookDetail";
      document.bbsForm.submit();
   }
   
   //즉시 결제
   function fn_directPay(bookSeq) {
      $.ajax({
         type:"POST",
         url:"/order/cartDirectPay",
         data:{
            bookSeq : bookSeq,
            prdCnt : 1
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(res){
            if(!icia.common.isEmpty(res)){
               icia.common.log(res);
               var code = icia.common.objectValue(res, "code", -500);
               
               if(code == 0)
               {
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
               else if (code == 400){
                      Swal.fire({
                            title: "Error",
                            text: "재고가 부족합니다. 다시 확인해주세요.",
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
   
   //책 장바구니에 담기
   function fn_cart(bookSeq) {
      const imgRect = document.querySelector(".product-" + bookSeq + " img").getBoundingClientRect();
       const imgTop = imgRect.top;
       const imgLeft = imgRect.left;

       const keyframes = "@keyframes cartMove { "
          + " 0% { width: 120px; height: 150px; top: " + imgTop + "px; left: " + imgLeft + "px; }"
           + " 100% { width: 24px; height: 24px; top: 30px; left: 82.7%; } }";

       const styleSheet = document.createElement("style");
       styleSheet.type = "text/css";
       styleSheet.innerText = keyframes;
       document.head.appendChild(styleSheet);

      $.ajax({
         type:"POST",
         url:"/order/cartInsert",
         data:{
            bookSeq:bookSeq
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
                        title: "Error",
                        text: "오류가 발생하였습니다",
                        icon: "error"
                    });
            }
         },
         error:function(xhr, status, error){
            icia.common.error(error);
         }
      });
   }


$(document).ready(function(){
   
   //검색 버튼 클릭 시
   $("#btnSearch").on("click", function() {
      document.bbsForm.bookSeq.value = ""; //여러개의 게시물 받기위해 초기화.
      document.bbsForm.searchType.value = $("#sort").val();
      document.bbsForm.searchValue.value = $("#_searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.classCode.value = ${classCode};
      document.bbsForm.action = "/book/book";
      document.bbsForm.submit();
   });
   
});

   
   
   
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

         <div class="input-select-align">
            <div class="input-select">
               <input type="text" name="_searchValue" id="_searchValue" class="form-control" value="${searchValue }" placeholder="검색할 단어를 입력하세요." aria-label="Recipient's username" aria-describedby="button-addon2">

               <button type="button" id="btnSearch" style="cursor: pointer">
                  <img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;">
               </button>
            </div>
         </div>

         <!-- --------------------------------------------------- -->

         <div class="product-page">


            <div class="parent-container">
               <h2 style="color: black; font-weight: bold;">

                  총 <span class="total-count">${totalCount}</span>권
               </h2>

               <div class="select-container">
                  <select name="sort" id="sort" onchange="fn_relist(this.value)">
                     <option value="1" <c:if test='${searchType eq "1"}'> selected </c:if>>최신순</option>
                     <option value="2" <c:if test='${searchType eq "2"}'> selected </c:if>>가격 낮은순</option>
                  </select>
               </div>
            </div>

            <hr class="bold-hr" />
            <div class="product-list">
               <c:if test='${!empty list}'>
                  <c:forEach var="Book" items="${list}" varStatus="status">


                     <div class="product-item">

                        <div style="position: relative;" class="product-${Book.bookSeq }">
                           <img src="/resources/images/book/${Book.bookSeq}.jpg" alt="GYM Book" class="product-img">
                           <c:if test="${Book.invenQtt eq 0}">
                              <div style="position: absolute; top: 0%; color: white; margin-left: 30px; margin-right: 20px; width: 120px; height: 100%; background-color: black; opacity: 0.6;">
                                 <span style="position: absolute; top: 30%; text-align: center; width: 100%; font-size: 30px; color: white;">품절</span>
                              </div>
                           </c:if>
                        </div>
                        <div class="product-info">
                           <a class="product-title" style="cursor: pointer;" onclick="fn_view(${Book.bookSeq})">${Book.bookTitle}</a> <span class="product-desc">${Book.bookInfo}</span>
                        </div>

                        <div class="product-price">
                           <span class="original-price"><fmt:formatNumber value="${Book.bookPrice}" type="number" pattern="#,###" />원</span><br> <span class="sale-price"><fmt:formatNumber value="${Book.bookPayPrice}" type="number" pattern="#,###" />원</span>
                        </div>

                        <div class="product-buttons">
                           <c:if test="${Book.invenQtt ne 0}">
                              <button class="cart-button" onclick="fn_cart(${Book.bookSeq})">장바구니</button>
                              <button class="buy-now-button" onclick="fn_directPay(${Book.bookSeq})">즉시구매</button>
                           </c:if>
                           <c:if test="${Book.invenQtt eq 0}">
                              <button class="cart-button" onclick="">품절</button>
                           </c:if>
                        </div>

                     </div>
                  </c:forEach>
               </c:if>
            </div>
         </div>
         <!-- --------------------------------------------------- -->

         <div class="pagination">
            <c:if test="${!empty paging}">

               <c:if test="${paging.prevBlockPage gt 0}">
                  <button class="pagination-button" href="#" onclick="fn_Page(${paging.prevBlockPage})">&laquo;</button>
               </c:if>


               <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                  <c:choose>
                     <c:when test="${i eq curPage}">
                        <span class="pagination-number active">${i}</span>
                     </c:when>
                     <c:otherwise>
                        <span class="pagination-number"><a class="page-link" href="#" onclick="fn_Page(${i})">${i}</a></span>
                     </c:otherwise>
                  </c:choose>
                  <c:if test="${i lt paging.endPage}">
                     <span class="pagination-separator">|</span>
                  </c:if>
               </c:forEach>


               <c:if test="${paging.nextBlockPage gt 0}">
                  <button class="pagination-button" href="#" onclick="fn_Page(${paging.nextBlockPage})">&raquo;</button>
               </c:if>

            </c:if>
         </div>

         <!-- --------------------------------------------------- -->

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
</html>
