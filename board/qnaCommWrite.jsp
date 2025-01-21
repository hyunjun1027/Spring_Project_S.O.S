<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/qnaCommWrite.css" rel="stylesheet">

<!-- SweetAlert2 CSS -->
<link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.4/dist/sweetalert2.min.css" rel="stylesheet">

<!-- SweetAlert2 JS -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.4/dist/sweetalert2.all.min.js"></script>

<style>
.header {
	background-color: #539ED8;
}
</style>
<script>
$(function () {
    $("#navmenu>ul>li:nth-child(3)>a").addClass("active");
});

$(document).ready(function () {
    $("#file").on("change", function () {
        var fileName = $("#file").val();
        $(".upload-name").val(fileName);
    });

    $("#brdTitle").focus();

    // 완료 버튼 클릭 시
    $("#writeBtn").on("click", function () {
        // 버튼 중복 클릭 방지
        const $button = $(this);
        if ($button.prop("disabled")) return;

        $button.prop("disabled", true);

        // 제목 검증
        if ($.trim($("#brdTitle").val()).length <= 0) {
            Swal.fire({
                position: "center",
                icon: "warning",
                title: "제목을 입력하세요.",
                showConfirmButton: true,
            }).then(() => {
                $("#brdTitle").val("");
                $("#brdTitle").focus();
                $button.prop("disabled", false); // 버튼 다시 활성화
            });
            return;
        }

        // 내용 검증
        if ($.trim($("#brdContent").val()).length <= 0) {
            Swal.fire({
                position: "center",
                icon: "warning",
                title: "내용을 입력하세요.",
                showConfirmButton: true,
            }).then(() => {
                $("#brdContent").val("");
                $("#brdContent").focus();
                $button.prop("disabled", false); // 버튼 다시 활성화
            });
            return;
        }

        var form = $("#board-form")[0];
        var formData = new FormData(form);

        $.ajax({
            type: "POST",
            enctype: "multipart/form-data",
            url: "/board/qnaCommWriteProc",
            data: formData,
            processData: false,
            contentType: false,
            cache: false,
            timeout: 600000,
            beforeSend: function (xhr) {
                xhr.setRequestHeader("AJAX", "true");
            },
            success: function (response) {
                if (response.code == 0) {
                    Swal.fire({
                        position: "center",
                        icon: "success",
                        title: "답글이 등록 되었습니다.",
                        showConfirmButton: false,
                        timer: 1500,
                    }).then(function () {
                        document.bbsForm.action = "/board/qnaView";
                        document.bbsForm.submit();
                    });
                } else {
                    Swal.fire({
                        position: "center",
                        icon: "warning",
                        title: "파라미터 값이 올바르지 않습니다.",
                        showConfirmButton: true,
                    }).then(() => {
                        $button.prop("disabled", false); // 버튼 다시 활성화
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error(error);
                Swal.fire({
                    position: "center",
                    icon: "warning",
                    title: "답글 등록 중 오류가 발생하였습니다.",
                    showConfirmButton: true,
                }).then(() => {
                    $button.prop("disabled", false); // 버튼 다시 활성화
                });
            },
        });
    });
});

function fn_list() {
    document.bbsForm.action = "/board/qnaView";
    document.bbsForm.submit();
}



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
			<h2 class="subTitle">문의사항 > 문의 답글 쓰기</h2>
			<div class="header-line"></div>
			<section class="board-container">
				<form class="board-form" id="board-form" enctype="multipart/form-data">
					<div class="form-group">
						<label for="title">문의 제목</label>
						<input type="text" id="title" name="title" placeholder="문의 제목" value="${boardQna.brdTitle}">
					</div>
					<div class="form-group">
						<label for="title">답변 제목</label>
						<input type="text" id="brdTitle" name="brdTitle" placeholder="제목을 입력해주세요.">
					</div>
					<div class="form-group">
						<label for="content">답변 내용</label>
						<textarea id="brdContent" name="brdContent" placeholder="내용을 입력해주세요."></textarea>
					</div>
					
					<div class="filebox">
					    <input class="upload-name" id="brdFile" name="brdFile" value="첨부파일" placeholder="첨부파일" readonly>
					    <label for="file">파일찾기</label>
					    <input type="file" id="file" name="brdFile" >
					</div>



					<div class="form-group-inline">
						<div class="inline-buttons">
							<button type="button" class="cancel" onclick="fn_list()">취소</button>
							<button type="submit" class="submit" id="writeBtn" >등록</button>
						</div>
					</div>
					
			        <input type="hidden" name="brdSeq" value="${boardQna.brdSeq}">
			        <input type="hidden" name="searchType" value="${searchType}">
			        <input type="hidden" name="searchValue" value="${searchValue}">
			        <input type="hidden" name="curPage" value="${curPage}">
				</form>
			</section>
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>	
	
   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="brdSeq" value="${boardQna.brdSeq}">
      <input type="hidden" name="searchType" value="${searchType}">
      <input type="hidden" name="searchValue" value="${searchValue}">
      <input type="hidden" name="curPage" value="${curPage}">
   </form>

</body>
</html>