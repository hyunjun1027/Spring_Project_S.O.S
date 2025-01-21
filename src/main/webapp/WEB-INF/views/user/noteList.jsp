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

<link href="/resources/css/mypage/mypageNoteList.css" rel="stylesheet">
<script>

//보낸쪽지 or 받은쪽지 리스트
function fn_notelist(type)
{
	//보낸쪽지
	if(type == 'sent')
	{
		document.bbsForm.type.value='sent';
		document.bbsForm.noteSeq.value = ""; 
		document.bbsForm.curPage.value = "1";
		document.bbsForm.action = "/user/noteList";
		document.bbsForm.submit();
	}
	else if(type == 'get')
	{
		document.bbsForm.type.value='get';
		document.bbsForm.noteSeq.value = "";
		document.bbsForm.curPage.value = "1";
		document.bbsForm.action = "/user/noteList";
		document.bbsForm.submit();
	}
}

function fn_noteView(noteSeq)
{
	document.bbsForm.type.value="${type}";
	document.bbsForm.noteSeq.value = noteSeq;
	document.bbsForm.curPage.value=${curPage};
	document.bbsForm.action = "/user/noteView";
	document.bbsForm.submit();
}

$(document).ready(function() {
	
	$("#chkAll").click(function() {
		if($("#chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
		else $("input[name=chk]").prop("checked", false);
	});

	
	
	$("#deleteBtn").click(function(){
		
		var selectedValues = [];
		
        $("input[name='chk']:checked").each(function () {
            selectedValues.push($(this).val());
        });
        
        // 체크된 값이 없는 경우 처리
        if (selectedValues.length === 0) {
            Swal.fire({
                title: "Error",
                text: "삭제할 항목을 선택하세요.",
                icon: "error"
            });

            return;
        }
		
        Swal.fire({
            title: "쪽지를 삭제하시겠습니까?",
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
                    type: "POST",
                    url: "/user/noteListDel",
                    contentType: "application/json", // JSON 데이터 전송
                    data: JSON.stringify(selectedValues), // 배열을 JSON 문자열로 변환하여 전송
                    dataType: "JSON",
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader("AJAX", "true");
                    },
                    success: function(response) {
                        if (response.code == 0) {
                            Swal.fire({
                                title: "삭제 완료!",
                                text: "쪽지가 삭제되었습니다.",
                                icon: "success"
                            }).then(() => {
                                document.bbsForm.type.value = "${type}";
                                document.bbsForm.action = "/user/noteList";
                                document.bbsForm.submit();
                            });
                        } else if (response.code == -400) {
                            Swal.fire({
                                title: "실패!",
                                text: "로그인을 진행해주세요.",
                                icon: "error"
                            });
                        } else if (response.code == -100) {
                            Swal.fire({
                                title: "실패!",
                                text: "삭제중 오류가 발생했습니다.",
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

		
		
		
		
		
	});
});


//페이지 이동
function fn_listView(curPage)
{
	document.bbsForm.type.value = "${type}";
	document.bbsForm.curPage.value = curPage;
    document.bbsForm.action = "/user/noteList";
    document.bbsForm.submit();
}


</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer" style="padding: 0px;">
			<div class="contentBoardContainer">
				<div class="title-div">
					<h2 class="first-title">나의 쪽지</h2>
					<%@ include file="/WEB-INF/views/include/mypage/mypageSelectBoxNote.jsp"%>
					<br> 총<strong><span class="stats-highlight"> ${totalCount}</span></strong>개의 쪽지가 있습니다.
				</div>

				<div class="contentBoardContainer">

					<div class="board-content">

						<!-- 보낸쪽지 -->
						<div class="board-content" id="sent-content">
							<c:if test='${type == "sent"}'>
								<table class="board-table">
									<thead>
										<tr>
											<th style="width: 10%">선택</th>
											<th style="width: 40%">내용</th>
											<th style="width: 28%">받는사람</th>
											<th style="width: 22%">보낸날짜</th>
										</tr>
									</thead>
									<tbody>
										<c:if test='${!empty list }'>
											<c:forEach var="Note" items="${list}" varStatus="status">
												<tr>
													<td><input type="checkbox" name="chk" value="${Note.noteSeq}"></td>
													<td class="product-desc" onclick="fn_noteView('${Note.noteSeq}')"><span class="product-desc" style="cursor: pointer;">${Note.noteContent}</span></td>
													<td><span class="product-desc">${Note.userNameGet }<c:if test="${Note.ratingGet == 'T' }"> 선생님 </c:if>(${Note.userIdGet })
													</span></td>
													<td>${Note.regDate}</td>
												</tr>

											</c:forEach>
										</c:if>

										<c:if test='${totalCount == 0}'>
											<tr>
												<td colspan="4" style="text-align: center;">쪽지가 없습니다.</td>
											</tr>
										</c:if>

									</tbody>
								</table>
							</c:if>
						</div>

						<!-- 받은쪽지 -->

						<div class="board-content" id="received-content">
							<c:if test='${type == "get"}'>
								<table class="board-table">
									<thead>
										<tr>
											<th style="width: 10%">선택</th>
											<th style="width: 40%">내용</th>
											<th style="width: 28%">보낸사람</th>
											<th style="width: 22%">보낸날짜</th>
										</tr>
									</thead>
									<tbody>
										<c:if test='${! empty list}'>
											<c:forEach var="Note" items="${list}" varStatus="status">
												<c:choose>
													<c:when test="${Note.read eq 'N'}">
														<tr>
															<td><input type="checkbox" name="chk" value="${Note.noteSeq}"></td>
															<td onclick="fn_noteView('${Note.noteSeq}')"><span class="product-desc" style="cursor: pointer;">${Note.noteContent}</span></td>
															<td><span class="product-desc">${Note.userName}<c:if test="${Note.rating eq 'T'}"> 선생님 </c:if>(${Note.userId})
															</span></td>
															<td>${Note.regDate}</td>
														</tr>
													</c:when>

													<c:otherwise>
														<tr style="color: gray;">
															<td><input type="checkbox" name="chk" value="${Note.noteSeq}"></td>
															<td onclick="fn_noteView('${Note.noteSeq}')"><span class="product-desc">${Note.noteContent}</span></td>
															<td><span class="product-desc">${Note.userName}<c:if test="${Note.rating eq 'T'}"> 선생님 </c:if>(${Note.userId})
															</span></td>
															<td>${Note.regDate}</td>
														</tr>
													</c:otherwise>
												</c:choose>
											</c:forEach>
										</c:if>

										<c:if test='${totalCount == 0}'>
											<tr>

												<td colspan="4" style="text-align: center;">쪽지가 없습니다.</td>

											</tr>
										</c:if>
									</tbody>
								</table>
							</c:if>
						</div>
					</div>




					<div class="board-footer">
						<div class="choose-all">
							<div class="select-all-container">
								<input type="checkbox" id="chkAll" />
								<label for="chkAll">전체 선택</label>
							</div>
						</div>

						<div class="btnContainer">
							<button type="button" id="writeBtn" class="inputBtn" onclick="fn_pageMove('noteWrite')">
								<span>작성</span>
							</button>
							<button type="button" id="deleteBtn" class="inputBtn" onclick="">
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

			<form id="bbsForm" name="bbsForm" method="post">
				<input type="hidden" name="noteSeq" value="${noteSeq}" />
				<input type="hidden" name="curPage" value="${curPage}" />
				<input type="hidden" name="type" value="" />
			</form>
		</div>
	</div>






</body>
</html>