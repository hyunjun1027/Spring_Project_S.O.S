<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link href="/resources/css/course/courseReview.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

<style>
.header {
   background: #b5aaf2;
}

.ql-editor {
   color: black;
   white-space: normal; /* pre-wrap 속성 덮어쓰기 */
   min-height: 250px;
}

.ql-editor p:empty,
.ql-editor div:empty {
    display: none; /* 빈 태그 숨기기 */
}

.board-content {
   padding: 0px;
}
</style>


<script>
// 수정 버튼 클릭시
function fn_update() {
   document.bbsForm.classCode.value = ${classCode};
   document.bbsForm.courseCode.value = ${course.courseCode};
   document.bbsForm.action = "/course/courseReviewUpdate";
   document.bbsForm.submit();
}

// 삭제 버튼 클릭시
function fn_delete() {
   if (confirm("게시글을 삭제하시겠습니까?")) {
      
         $.ajax({
            type : "POST",
            url : "/course/courseReviewDelete",
            data : {
               brdSeq : ${brdSeq}
            },
            dataType : "JSON",
            beforeSend : function(xhr) {
               xhr.setRequestHeader("AJAX", "true");   
            },
            success : function (response) {
               if (response.code == 0) {
                  alert("게시글이 삭제되었습니다.");
                  document.bbsForm.classCode.value = ${classCode};
                  document.bbsForm.courseCode.value = ${course.courseCode};
                  document.bbsForm.action = "/course/courseReview";
                  document.bbsForm.submit();
               }
               else {
                  alert("게시글 삭제 중 오류가 발생하였습니다.");
               }
            },
            error : function (xhr, status, error) {
               icia.common.error(error);
            }
         });
   }
}
</script>




         <section class="board-container">

            <!-- 게시글 정보 -->
            <div class="board-info">
            
               <div class="star-div" style="font-size: 20px;">
                   <c:forEach var="i" begin="1" end="5">
                     <c:choose>
                         <c:when test="${i <= review.brdRating}">
                             <i class="fas fa-star"></i>
                         </c:when>
                         <c:otherwise>
                             <i class="far fa-star"></i>
                         </c:otherwise>
                     </c:choose>
                   </c:forEach>
               </div>
               
               <h2>${review.brdTitle }</h2>
               <div class="post-meta">
                  <span>
                  <img src="/resources/profile/${review.userProfile}" onerror='this.src="/resources/images/default-profile.jpg"' style="width:30px; height:30px; border-radius:50%;">&nbsp;
                  ${review.userName }</span> 
                  <span>${review.userEmail }</span> 
                  <span>${review.regDate }</span> 
                  <span>조회수 ${review.brdReadCnt }</span>
               </div>
            </div>

            <!-- 게시글 내용 -->
<%--             <div class="board-content">
               <p>${review.brdContent }</p>
            </div>  --%>
   
             <div class="ql-editor">
                <c:out value="${review.brdContent}" escapeXml="false"/>
            </div> 
         
            <!-- 댓글 -->
            <div class="comment-section">

               <div class="comment-buttons">
               
                  <c:if test="${boardMe eq 'Y' }">
                     <button class="btn-delete" onclick="fn_delete()">삭제</button>
                     <button class="btn-modify" onclick="fn_update()">수정</button>
                  </c:if>
                  
