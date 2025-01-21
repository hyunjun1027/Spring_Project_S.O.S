<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Quill CSS -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/course/courseMain.css" rel="stylesheet">
<link href="/resources/css/course/courseNoticeView.css" rel="stylesheet">
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
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
		
		// 목록 버튼 클릭시
		$("#btnList").on("click", function() {
			document.bbsForm.classCode.value = ${classCode};
			document.bbsForm.courseCode.value = ${course.courseCode};
			document.bbsForm.action = "/course/courseNotice";
			document.bbsForm.submit();
		});
	});

	//수정 버튼 클릭시
	function fn_update() {
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.action = "/course/courseNoticeUpdate";
		document.bbsForm.submit();
	}

	// 삭제 버튼 클릭시
	function fn_delete() {
		
		Swal.fire({
	        title: "게시글을 삭제하시겠습니까?",
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
					type : "POST",
					url : "/course/courseNoticeDelete",
					data : {
						brdSeq : ${brdSeq}
					},
					dataType : "JSON",
					beforeSend : function(xhr) {
						xhr.setRequestHeader("AJAX", "true");	
					},
					success : function (response) {
						if (response.code == 0) 
						{
	                        Swal.fire({
	                            title: "삭제 완료",
	                            text: "게시글이 삭제되었습니다.",
	                            icon: "success"
	                        }).then(() => {
								document.bbsForm.classCode.value = ${classCode};
								document.bbsForm.courseCode.value = ${course.courseCode};
								document.bbsForm.action = "/course/courseNotice";
								document.bbsForm.submit();
	                        });
		
						}
						else {
                            Swal.fire({
                                title: "Error!",
                                text: "게시글 삭제 중 오류가 발생하였습니다.",
                                icon: "error"
                            });

						}
					},
					error : function (xhr, status, error) {
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
	<%@ include file="/WEB-INF/views/include/course/courseMainInfo.jsp"%>

	<div class="course-page">
		<ul class="tab-menu">
			<li onclick="fn_pageMove('courseMain')">강좌소개</li>
			<li onclick="fn_pageMove('courseList')">강의목록</li>
			<li class="active" onclick="fn_pageMove('courseNotice')">공지사항</li>
			<li onclick="fn_pageMove('courseQnA')">학습Q&A</li>
			<li onclick="fn_pageMove('courseReview')">수강후기</li>
		</ul>


		<div class="content">

		<div class="notice-table-container">
			<section class="board-container">

						<%@ include file="/WEB-INF/views/include/course/courseNoticeViewIn.jsp"%>
						
						<c:if test="${boardMe eq 'Y' }">
							<button class="btn-delete" onclick="fn_delete()">삭제</button>
							<button class="btn-modify" onclick="fn_update()">수정</button>
						</c:if>
						<button class="btn-list" id="btnList">목록</button>
					</div>

				</div>
			</section>

			<!-- 이전글, 다음글 추가 -->
			<div class="post-navigation">
				<c:if test="${!empty nextList }">
					<div class="next-post">
						<span>다음글</span> 
						<a href="/course/courseNoticeView?brdSeq=${nextList.brdSeq}&courseCode=${course.courseCode}&classCode=${classCode}">
						${nextList.brdTitle }</a>
					</div>
				</c:if>
				
				<c:if test="${!empty prevList }">
					<div class="prev-post">
						<span>이전글</span> 
						<a href="/course/courseNoticeView?brdSeq=${prevList.brdSeq}&courseCode=${course.courseCode}&classCode=${classCode}">
						${prevList.brdTitle }</a>
					</div>
				</c:if>
			</div>


		</div>

		</div>
	</div>


	</div>

	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	
	<form name="bbsForm" id="bbsForm" method="post">
   		<input type="hidden" name="brdSeq" value="${brdSeq }">
   		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
   		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
   		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
		<input type="hidden" name="classCode" value="${classCode }">
		<input type="hidden" name="courseCode" value="${courseCode }">
		<input type="hidden" name="teacherId" value="${teacherId }">
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
	
</body>
</html>
