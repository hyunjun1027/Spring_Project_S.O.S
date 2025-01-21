<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<link href="/resources/css/teach/teachBookSearch.css" rel="stylesheet">

<title>도서 검색</title>
<script>

$(document).ready(function(){
   
   //검색 버튼 클릭 시
   $("#btnSearch").on("click", function() {
      document.bbsForm.searchValue.value = $("#_searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.action = "/teach/teachBookSearch";
      document.bbsForm.submit();
   });
   
});



function selectBook(bookSeq, bookTitle) {
    // 부모창의 입력 필드에 값을 설정
    if (window.opener && !window.opener.closed) {
        // 부모창의 bookDetail input에 도서명(bookTitle) 설정
        window.opener.document.getElementById("bookDetail").value = bookTitle;
        
        // 부모창의 hidden input에 bookSeq 값을 설정
        window.opener.document.getElementById("bookSeq").value = bookSeq;
        
        
        // 자식창 닫기
        window.close(); 
    } else {
       Swal.fire({
          position: "center", 
          icon: "warning",
          title: "부모창이 닫혔거나 접근할 수 없습니다.", 
          showConfirmButton: false, 
          timer: 1500 
          });

    }
}

function fn_Page2(curPage)
{
    document.bbsForm.searchValue.value = $("#_searchValue").val();
    document.bbsForm.curPage.value = curPage;
    document.bbsForm.action = "/teach/teachBookSearch";
    document.bbsForm.submit();
   
}
</script>



</head>
<body>


    <!-- 타이틀 -->
    <div class="title">도서 검색</div>
    
    <!-- 메인 컨테이너 -->
    <div class="container">
        
        <!-- 검색 영역 -->
        <div class="search-area">
            <label class="search-label" for="searchInput">도서명 검색</label>
            <input type="text" id="_searchValue" name="_searchValue" class="search-input" value="" placeholder="도서명을 입력하세요">
            <button class="search-button" id="btnSearch">검색</button>
        </div>

        <!-- 검색 결과 영역 -->
        <div class="result-area">
         <div class="result-header-container">
             <div class="result-header">검색 결과</div>
             <h2 class="total-count-header">
                 총 <span class="total-count">${totalCount}</span>권
             </h2>
         </div>
            
            <!-- 도서 리스트 -->
            <div class="book-list">
               <c:if test='${!empty list}'>
               <c:forEach var="Book" items="${list}" varStatus="status" >
            
                   <div class="book-item" onClick="selectBook(${Book.bookSeq}, '${Book.bookTitle}')">
                       <div class="book-image">
                           <img src="/resources/images/book/${Book.bookSeq}.jpg" alt="도서 img" class="product-img">
                       </div>
                       <div class="book-details">
                           <h3 class="book-title" >${Book.bookTitle}</h3>
                           <p class="book-meta">저자: ${Book.bookAuth} | 출판사: ${Book.bookPublisher}</p>
                           <p class="book-price">가격: <fmt:formatNumber value="${Book.bookPrice}" type="number" pattern="#,###"/>원</p>
                       </div>
                   </div>
                
                   </c:forEach>
            </c:if>
                
            </div>

        <!-- 페이지네이션 -->
      <div class="pagination">
         <c:if test="${!empty paging}">
         
         <c:if test="${paging.prevBlockPage gt 0}">
            <button class="pagination-button" href="#" onclick="fn_Page2(${paging.prevBlockPage})">&laquo;</button>
         </c:if>   
         
         
         <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">   
             <c:choose>
                 <c:when test="${i eq curPage}">
                       <span class="pagination-number active">${i}</span>
                 </c:when>
                 <c:otherwise>
                     <span class="pagination-number"><a class="page-link" href="#" onclick="fn_Page2(${i})">${i}</a></span>
                 </c:otherwise>
             </c:choose>
             <c:if test="${i lt paging.endPage}">
                 <span class="pagination-separator">|</span>
             </c:if>
         </c:forEach>   
            
                  
         <c:if test="${paging.nextBlockPage gt 0}">
            <button class="pagination-button" href="#" onclick="fn_Page2(${paging.nextBlockPage})">&raquo;</button>
         </c:if>
         
         </c:if>
      </div>
      
      
      
      
        </div>
        
       <form id="bbsForm" name="bbsForm" method="post">
          <input type="hidden" name="bookSeq" value="${bookSeq}">
         <input type="hidden" name="searchValue" value="${searchValue}">
         <input type="hidden" name="curPage" value="${curPage}" />
          <input type="hidden" name="classCode" value="">
      </form>
        
    </div>
</body>
</html>
