<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/qnaWrite.css" rel="stylesheet">

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
	$(function() {
		$("#navmenu>ul>li:nth-child(3)>a").addClass("active");
	});
	

	
	$(document).ready(function() {	
		
		$("#file").on('change',function(){
			var fileName = $("#file").val();
			$(".upload-name").val(fileName);
		});
		
		$("#brdTitle").focus();
	  
		//완료 버튼 클릭 시
		$("#writeBtn").on("click", function() {
			const contentHtml = quill.root.innerHTML;
	     
			$("#writeBtn").prop("disabled", true);
		  
	       	// 제목 검증
	       	if ($.trim($("#brdTitle").val()).length <= 0) {
	       		Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "제목을 입력하세요.", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

	           $("#brdTitle").val("");
	           $("#brdTitle").focus();
	           $("#btnWrite").prop("disabled", false);
	           return;
	        }
	
	        // 내용 검증
	        if ($.trim(contentHtml).length <= 0 || contentHtml === "<p><br></p>") {
	        	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "내용을 입력하세요.", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});
	        	quill.focus();
	            $("#btnWrite").prop("disabled", false);
	            return;
	        }
		
			var form = $("#board-form")[0];
			var formData = new FormData(form);
			formData.append("contentHtml", contentHtml);
			
		    $.ajax({
				  
		 	   type:"POST",
			   enctype:"multipart/form-data",
			   url:"/board/qnawriteProc",
			   data:formData,
			   processData:false,	
			   contentType:false,	
			   cache:false,
			   timeout:600000,		
			   beforeSend:function(xhr){
			  	   xhr.setRequestHeader("AJAX", "true");
			   },
			   success:function(response){
				  
				   if(response.code == 0){
					   Swal.fire({
						   position: "center", 
						   icon: "success",
						   title: "게시물이 등록 되었습니다.",
						   showConfirmButton: false, 
						   timer: 1500 
						   }).then(function() {
							   location.href = "/board/qnaList";
						   });
		
				   }else if(response.code == 400){
					   Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "파라미터 값이 올바르지 않습니다.", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});
					   $("#writeBtn").prop("disabled", false);
					   $("#brdTitle").focus();
				   }else{
					   Swal.fire({
		            		position: "center", 
		            		icon: "warning",
		            		title: "게시물 등록중 오류가 발생하였습니다.(2)", 
		            		showConfirmButton: false, 
		            		timer: 1500 
		            		});

					   $("#writeBtn").prop("disabled", false);
					   $("#brdTitle").focus();
				   }
				  
			   },
			   error:function(xhr, status, error){
				   icia.common.error(error);
				   Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "게시물 등록 중 오류가 발생하였습니다.", 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

				   $("#writeBtn").prop("disabled", false);
			   }
			   
		    });
		  
		});
	});
	
	function fn_list() {
	   document.bbsForm.action = "/board/qnaList";
	   document.bbsForm.submit();
	}
</script>
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<section class="notice-section">
		<div class="notice-content"></div>
	</section>
	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date">
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
			<h2 class="subTitle">문의사항 > 문의글 쓰기</h2>
			<div class="header-line"></div>
			<section class="board-container">
				<form class="board-form" id="board-form" enctype="multipart/form-data">
					<div class="form-group">
						<label for="title">아이디</label>
						<input type="text" id="userId" name="userId" placeholder="아이디" value="${user.userId}" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="title">이메일</label>
						<input type="text" id="userEmail" name="userEmail" placeholder="sist@gmail.com" value="${user.userEmail}" readonly="readonly">
					</div>
					<div class="form-group">
						<label for="title">제목</label>
						<input type="text" id="brdTitle" name="brdTitle" placeholder="제목을 입력해주세요.">
					</div>
					<label for="content">내용</label>
					<div class="form-group-editor">
			        	<div id="editor-container"></div>
			        </div>
					
					<div class="filebox">
					    <input class="upload-name" id="brdFile" name="brdFile" value="첨부파일" placeholder="첨부파일" readonly>
					    <label for="file">파일찾기</label>
					    <input type="file" id="file" name="brdFile" >
					</div>



					<div class="form-group-inline">
						<div class="inline-item">
							<label for="isPrivate">🔒비밀글 설정</label>
						</div>
						<div class="inline-item">
							<input type="password" id="brdPwd" name="brdPwd" placeholder="비밀번호를 입력해주세요.">
						</div>
						<div class="inline-buttons">
							<button type="button" class="cancel" onclick="fn_list()">취소</button>
							<button type="submit" class="submit" id="writeBtn" >등록</button>
						</div>
					</div>
				</form>
			</section>
		</div>
	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	
   <form id="bbsForm" name=bbsForm method="post">
      <input type="hidden" name="brdSeq" value="">
      <input type="hidden" name="searchType" value="${searchType}">
      <input type="hidden" name="searchValue" value="${searchValue}">
      <input type="hidden" name="curPage" value="${curPage}">
   </form>
	
	<!-- jQuery, Quill, quill-image-resize 플러그인 스크립트 -->
   <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
   <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>
   <script src="https://cdn.jsdelivr.net/npm/quill-image-resize-module@3.0.0/image-resize.min.js"></script>

   <script>
        // Quill 모듈에 이미지 리사이즈 플러그인 등록
        Quill.register('modules/imageResize', ImageResize.default);

        // Quill 에디터 초기화
		var quill = new Quill('#editor-container', {
		    theme: 'snow',
		    modules: {
		        toolbar: [
		            ['bold', 'italic', 'underline', 'strike'],          // 텍스트 스타일
		            [{ 'header': 1 }, { 'header': 2 }],                 // 헤더 스타일
		            [{ 'list': 'ordered' }, { 'list': 'bullet' }],      // 리스트 스타일
		            [{ 'indent': '-1' }, { 'indent': '+1' }],           // 들여쓰기
		            [{ 'size': ['small', false, 'large', 'huge'] }],    // 글자 크기
		            [{ 'align': [] }],                                  // 정렬
		            [{ 'color': [] }, { 'background': [] }],            // 글자색, 배경색 추가
		            ['image']                                           // 이미지 삽입
		        ],
		        imageResize: {
		            modules: [ 'Resize', 'DisplaySize', 'Toolbar' ]
		        }
		    }
		});

	</script>
</body>
</html>