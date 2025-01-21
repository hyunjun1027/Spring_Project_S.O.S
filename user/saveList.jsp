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

<link href="/resources/css/mypage/mypageSaveList.css" rel="stylesheet">

<script>

/*북마크*/
function myBookMarkBtn(value) {
	event.stopPropagation();
	
	$.ajax({
        url: "/board/freeBookMark",
        type: "POST",
        data: {
            brdSeq: value
        },
        datatype:"JSON",
        success: function(response)
        {
             if(response.code === 201)
             {
              Swal.fire({
               title: '북마크를 취소했습니다.',
               icon: 'info',
               
               showCancelButton: false,
               showconfirmButton: true,
               confirmButtonColor: '#3085d6',  
               confirmButtonText: '확인',
            });
               var newCommentsHTML = '';
                 		newCommentsHTML += '<img src="/resources/img/bookMark_dark.png" alt="bookMark Image" style="width: 30px; height: 30px;">';
            	   document.getElementById("myBookMarkBtn_" + value).innerHTML = newCommentsHTML;
               }
             
           else if (response.code === 200) 
            {
              Swal.fire({
                title: '북마크에 추가했습니다.',
                icon: 'success',
                
                showCancelButton: false,
                showconfirmButton: true,
                confirmButtonColor: '#3085d6',  
                confirmButtonText: '확인',
             });
              var newCommentsHTML = '';
              newCommentsHTML += '<img src="/resources/img/bookMark.png" alt="bookMark Image" style="width: 30px; height: 30px;">';
               document.getElementById("myBookMarkBtn_" + value).innerHTML = newCommentsHTML;
                 
            } 
           else if (response.code === 999) 
            {
              Swal.fire({
                title: '로그인 후 이용 가능합니다',
                icon: 'success',
                
                showCancelButton: false,
                showconfirmButton: true,
                confirmButtonColor: '#3085d6',  
                confirmButtonText: '확인',
             });
            } 
            else if (response.code === 404) 
            {
               Swal.fire({
                title: '찾으시는 게시물이 없습니다.',
                icon: 'warning',
                
                showCancelButton: false,
                showconfirmButton: true,
                confirmButtonColor: '#3085d6',  
                confirmButtonText: '확인',
             });
            } 
            else 
            {
               Swal.fire({
                title: '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.(500)',
                icon: 'warning',
                
                showCancelButton: false,
                showconfirmButton: true,
                confirmButtonColor: '#3085d6',  
                confirmButtonText: '확인',
             });
            }
        },
        error: function(xhr, status, error) 
        {
            alert("서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
        }
    });
}

/*글 보기*/
function fn_view(brdSeq){
	document.myPageForm.brdSeq.value = brdSeq;
	document.myPageForm.curPage.value = "1";
	document.myPageForm.action = "/board/freeView";
    document.myPageForm.submit();
}


/*페이징*/
function fn_listView(curPage) {
	document.myPageForm.curPage.value = curPage;
	document.myPageForm.action = "/user/saveList";
	document.myPageForm.submit();
}

/* 카테고리별 보기*/
function category(value) {
   document.myPageForm.curPage.value = "1";
   document.myPageForm.category.value = value;
   document.myPageForm.action = "/user/saveList";
   document.myPageForm.submit();
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div board-header">
					<h2 class="first-title">내가 저장한 글</h2>
					<div class="board-stats">
						총 게시글 <strong><span class="stats-highlight"> ${totalCount}개</span></strong>
						<select class="dropdown-btn" id="category" onchange="category(this.value)">
								<option value="0" <c:if test="${category == 0}">selected</c:if>>전체</option>
								<option value="1" <c:if test="${category == 1}">selected</c:if>>일상/생각</option>
								<option value="2" <c:if test="${category == 2}">selected</c:if>>학습고민</option>
								<option value="3" <c:if test="${category == 3}">selected</c:if>>입시</option>
								<option value="4" <c:if test="${category == 4}">selected</c:if>>진로</option>
						</select>

					</div>

				</div>

				<div class="board-content">
					<table class="board-table">
						<thead>
							<tr>
								<th style="width: 10%;">북마크</th>
								<th style="width: 45%;">제목</th>
								<th style="width: 10%;">작성자</th>
								<th style="width: 25%;">작성일</th>
								<th style="width: 10%;">조회수</th>
							</tr>
						</thead>
						<tbody>
						<c:if test="${!empty list}">
							<c:forEach var="board" items="${list}" varStatus="status">
								<tr onclick="fn_view(${board.brdSeq}, event)" style="cursor: pointer;">
									<td>
										<button onclick="myBookMarkBtn(${board.brdSeq})" id="myBookMarkBtn_${board.brdSeq}" class="myBookMarkBtn" style="border: none; background-color: transparent;">
											<img src="/resources/img/bookMark.png" alt="bookMark Image" style="width: 25px; height: 25px;"></div>
										</button>
									</td>
									<td>${board.brdTitle}</td>
									<td>${board.userId}</td>
									<td>${board.regDate}</td>
									<td>${board.brdReadCnt}</td>
								</tr>
							</c:forEach>
						</c:if>
						
						<c:if test="${empty list}">
							<tr>
								<td colspan="5">저장한 글이 없습니다.</td>
							</tr>
						</c:if>
							
						</tbody>
					</table>
				</div>

				<div class="pagingContainer">
					<ul class="pagination">
						<c:if test="${!empty paging}">
         					<c:if test="${paging.prevBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_listView(${paging.prevBlockPage})"> < </a></li>
							</c:if>
							<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
					            <c:choose>
					               <c:when test="${i ne curPage}">
					               
								<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_listView(${i})">${i}</a></li>
									
									</c:when>
										<c:otherwise>
							
								<li class="page-item active"><a class="page-link" href="javascript:void(0)" style="cursor: default;">${i}</a></li>
							
										</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${paging.nextBlockPage gt 0}">	
								<li class="page-item"><a class="page-link" href="javascript:void(0)" onclick="fn_listView(${paging.nextBlockPage})"> > </a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	</div>
	
	<form name="myPageForm" id="myPageForm" method="POST">
         <input type="hidden" name="brdSeq" value="" />
         <input type="hidden" name="curPage" value="${curPage}"/>
         <input type="hidden" name="category" value="${category}"/>
   </form>
	
</body>
</html>