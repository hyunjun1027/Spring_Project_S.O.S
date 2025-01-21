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

<link href="/resources/css/mypage/mypageWriteList.css" rel="stylesheet">

<script>
$(document).ready(function() {
	$("#select-all").click(function() {
		if($("#select-all").is(":checked")) $("input[name=chk]").prop("checked", true);
		else $("input[name=chk]").prop("checked", false);
	});
	
	$("input[name=chk]").click(function(event) {
		event.stopPropagation();
	});
	
	/*게시글 삭제*/
	$("#deleteBtn").click(function(){
		
		var selectedValues = [];
		
        $("input[name='chk']:checked").each(function () {
            selectedValues.push($(this).val());
        });
        
        if (selectedValues.length === 0) {
            Swal.fire({
                title: "Error",
                text: "삭제할 항목을 선택하세요.",
                icon: "error"
            });

            return;
        }
		
        
        
        Swal.fire({
            title: "해당 게시물을 삭제하시겠습니까?",
            text: "삭제하면 되돌릴 수 없습니다!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: "삭제",
            cancelButtonText: "취소"
        }).then((result) => {
            if (result.isConfirmed) {
                // AJAX 요청
            	$.ajax({
    				type:"POST",
    				url:"/user/writeListDel",
    				contentType: "application/json",
    	            data: JSON.stringify(selectedValues),
    				dataType:"JSON",
    				beforeSend:function(xhr)
    				{
    					xhr.setRequestHeader("AJAX", "true");
    				},
    				success:function(response)
    				{ 
    					if(response.code == 0)
    					{
    						Swal.fire({
    			                title: '선택한 게시물이 삭제되었습니다.',
    			                icon: 'success',
    			                
    			                showCancelButton: false,
    			                showconfirmButton: true,
    			                confirmButtonColor: '#3085d6',  
    			                confirmButtonText: '확인',
    			             }).then((result) => {
    			            	document.myPageForm.curPage.value = "${curPage}";
    							document.myPageForm.category.value = "${category}";
    							document.myPageForm.action = "/user/writeList";
    							document.myPageForm.submit(); 
    			             });
    					}
    					else if(response.code == -400)
    					{
    						Swal.fire({
    				               title: '로그인을 먼저 진행하세요.',
    				               icon: 'info',
    				               
    				               showCancelButton: false,
    				               showconfirmButton: true,
    				               confirmButtonColor: '#3085d6',  
    				               confirmButtonText: '확인',
    				            });
    					}
    					else if(response.code == -100)
    					{
    						Swal.fire({
    				               title: '삭제 중 오류발생',
    				               icon: 'info',
    				               
    				               showCancelButton: false,
    				               showconfirmButton: true,
    				               confirmButtonColor: '#3085d6',  
    				               confirmButtonText: '확인',
    				            });
    					}
    				},
    				error:function(xhr, status, error)
    				{
    					icia.common.error(error);
    					Swal.fire({
    			               title: '게시글 삭제중 중 오류가 발생하였습니다.!',
    			               icon: 'info',
    			               
    			               showCancelButton: false,
    			               showconfirmButton: true,
    			               confirmButtonColor: '#3085d6',  
    			               confirmButtonText: '확인',
    			            });
    				}
    			});
            }
        });
        
        

		
	});
});

/*글 보기*/
function fn_view(brdSeq){
	document.myPageForm.brdSeq.value = brdSeq;
	document.myPageForm.curPage.value = "1";
	document.myPageForm.action = "/board/freeView";
    document.myPageForm.submit();
}

/* 카테고리별 보기*/
function category(value) {
   document.myPageForm.curPage.value = "1";
   document.myPageForm.category.value = value;
   document.myPageForm.action = "/user/writeList";
   document.myPageForm.submit();
}

/*페이징*/
function fn_listView(curPage) {
	document.myPageForm.curPage.value = curPage;
	document.myPageForm.action = "/user/writeList";
	document.myPageForm.submit();
}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer" style="padding: 0px;">
			<div class="contentBoardContainer">
				<div class="title-div board-header">
					<h2 class="first-title">내가 쓴 글</h2>
					<div class="board-stats">
						총 게시글 <strong><span class="stats-highlight"> ${totalCount}개</span></strong> <select class="dropdown-btn" id="category" onchange="category(this.value)">
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
								<th style="width: 10%;">선택</th>
								<th style="width: 45%;">제목</th>
								<th style="width: 30%;">작성일</th>
								<th style="width: 15%;">조회수</th>
							</tr>
						</thead>
						<tbody>
							<c:if test="${!empty list}">
								<c:forEach var="board" items="${list}" varStatus="status">
									<tr onclick="fn_view(${board.brdSeq})" style="cursor: pointer;">
										<td><input type="checkbox" name="chk" value="${board.brdSeq}"></td>
										<td>${board.brdTitle}</td>
										<td>${board.regDate}</td>
										<td>${board.brdReadCnt}</td>
									</tr>
								</c:forEach>
							</c:if>

							<c:if test="${empty list}">
								<tr>
									<td colspan="5">작성한 글이 없습니다.</td>
								</tr>
							</c:if>

						</tbody>
					</table>
				</div>

				<div class="board-footer">
					<div class="choose-all">
						<div class="select-all-container">
							<input type="checkbox" id="select-all" />
							<label for="select-all">전체 선택</label>
						</div>
					</div>
					<div class="btnContainer">
						<button type="button" id="deleteBtn" class="inputBtn">
							<span>삭제</span>
						</button>
					</div>
				</div>

				<div class="pagingContainer">
					<ul class="pagination">
						<c:if test="${!empty paging}">
							<c:if test="${paging.prevBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${paging.prevBlockPage})"> < </a></li>
							</c:if>
							<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
								<c:choose>
									<c:when test="${i ne curPage}">
										<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${i})">${i}</a></li>
									</c:when>
									<c:otherwise>
										<li class="page-item active"><a class="page-link" href="#" style="cursor: default;">${i}</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${paging.nextBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${paging.nextBlockPage})"> > </a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<form name="myPageForm" id="myPageForm" method="POST">
		<input type="hidden" name="brdSeq" value="" />
		<input type="hidden" name="curPage" value="${curPage}" />
		<input type="hidden" name="category" value="${category}" />
	</form>

</body>
</html>