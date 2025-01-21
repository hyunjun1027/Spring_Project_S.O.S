<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/qnaCommUpdate.css" rel="stylesheet">
<title>문의사항 답변 수정</title>

<style>
.header {
	background-color: #539ED8;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(3)>a").addClass("active");
	});
	
	$(document).ready(function () {
		
    	$("#file").on('change',function(){
			var fileName = $("#file").val();
			$(".upload-name").val(fileName);
    	});
    	
    	$("#brdTitle").focus();
    	
	    $("#btnUpdate").on("click", function (event) {
	        // 기본 동작 방지 (새로고침 차단)
	        event.preventDefault();

	        // 버튼 비활성화
	        $("#btnUpdate").prop("disabled", true);

	        // 제목 확인
	        if ($.trim($("#brdTitle").val()).length <= 0) {
	        	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "제목을 입력하세요.", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

	            $("#brdTitle").val("");
	            $("#brdTitle").focus(); // 제목 입력창에 포커스 이동
	            $("#btnUpdate").prop("disabled", false);
	            return;
	        }

	        // 내용 확인
	        if ($.trim($("#brdContent").val()).length <= 0) {
	        	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "내용을 입력하세요.", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

	            $("#brdContent").val("");
	            $("#brdContent").focus(); // 내용 입력창에 포커스 이동
	            $("#btnUpdate").prop("disabled", false);
	            return;
	        }


	        // 폼 데이터 생성 및 AJAX 요청
	        var form = $("#board-form")[0];
	        var formData = new FormData(form);

	        $.ajax({
	            type: "POST",
	            enctype: "multipart/form-data",
	            url: "/board/qnaCommUpdateProc",
	            data: formData,
	            processData: false,
	            contentType: false,
	            cache: false,
	            beforeSend: function (xhr) {
	                xhr.setRequestHeader("AJAX", "true");
	            },
	            success: function (response) {
	                if (response.code == 0) {
	                	Swal.fire({
	                		position: "center", 
	                		icon: "success",
	                		title: "답글이 수정되었습니다.",
	                		showConfirmButton: false, 
	                		timer: 1500 
	                		}).then(function() {
	                			document.bbsForm.action = "/board/qnaView";
	                			document.bbsForm.brdSeq.value = "${boardQnaReply.brdParent}";
	    	        			document.bbsForm.submit();
	                		});

	                } else if (response.code == 400) {
	                	Swal.fire({
	                		position: "center", 
	                		icon: "warning",
	                		title: "파라미터 값이 올바르지 않습니다.", 
	                		showConfirmButton: false, 
	                		timer: 1500 
	                		});

	                    $("#btnUpdate").prop("disabled", false);
	                } else if (response.code == 403) {
	                	Swal.fire({
	                		position: "center", 
	                		icon: "warning",
	                		title: "본인 게시물이 아닙니다.", 
	                		showConfirmButton: false, 
	                		timer: 1500 
	                		});

	                    $("#btnUpdate").prop("disabled", false);
	                } else if (response.code == 404) {
	                	Swal.fire({
	                		position: "center", 
	                		icon: "warning",
	                		title: "게시물을 찾을 수 없습니다.",
	                		showConfirmButton: false, 
	                		timer: 1500 
	                		}).then(function() {
	                			location.href = "/board/qnaView";
	                		});

	                } else {
	                	Swal.fire({
	                		position: "center", 
	                		icon: "warning",
	                		title: "게시물 수정 중 오류가 발생하였습니다.", 
	                		showConfirmButton: false, 
	                		timer: 1500 
	                		});

	                    $("#btnUpdate").prop("disabled", false);
	                }
	            },
	            error: function (error) {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "게시물 수정 중 오류가 발생했습니다.", 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	                $("#btnUpdate").prop("disabled", false);
	            }
	        });
	    });

	    $("#btnList").on("click", function () {
	    	document.bbsForm.brdSeq.value = "${boardQnaReply.brdParent}";
			document.bbsForm.action = "/board/qnaView";
			document.bbsForm.submit();
	    });
    	
	});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<section class="notice-section">
		<div class="notice-content"></div>
	</section>
	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days"></span>
			</div>
			<ul class="menu">
				<li><a href="/board/noticeList">공지사항</a></li>
				<li><a href="/board/qnaList" class="highlight">문의사항</a></li>
				<li><a href="/board/freeList">자유게시판</a><br></li>
				<li><a href="/board/faqList">자주 묻는 질문</a></li>
			</ul>
		</div>
		<div class="table-container">
			<h2 class="subTitle">문의사항 > 문의 답변 수정</h2>
			<div class="header-line"></div>
			<section class="board-container">
				<form class="board-form" id="board-form">
					<div class="form-group">
						<label for="title">제목</label>
						<input type="text" id="brdTitle" name="brdTitle" placeholder="회원가입중 계속 오류가 발생합니다." value="${boardQnaReply.brdTitle}">
					</div>
					<div class="form-group">
						<label for="content">내용</label>
						<textarea id="brdContent" name="brdContent" placeholder="계속 몇번씩이나 회원가입 하고있는데 안됩니다. 도와주세요.">${boardQnaReply.brdContent}</textarea>
					</div>
					
					
					<div class="filebox">
					    <input class="upload-name" id="brdFile" name="brdFile" value="${boardQnaReply.fileOrgName}"placeholder="첨부파일" readonly>
					    <label for="file">파일찾기</label>
					    <input type="file" id="file" name="brdFile">
					</div>


					<div class="form-group-inline">
						<div class="inline-buttons">
							<button type="button" id="btnList" class="cancel">취소</button>
							<button type="submit" id="btnUpdate" class="submit">등록</button>
						</div>
					</div>
					
					
					<input type="hidden" name="brdSeq" value="${boardQnaReply.brdSeq}" />
					<input type="hidden" name="searchType" value="${searchType}" />
					<input type="hidden" name="searchValue" value="${searchValue}" />
					<input type="hidden" name="curPage" value="${curPage}" />
				</form>
			</section>
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	<form name="bbsForm" id="bbsForm" method="post">
		<input type="hidden" name="brdSeq" value="${boardQnaReply.brdSeq}" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage" value="${curPage}" />
	</form>

</body>
</html>

