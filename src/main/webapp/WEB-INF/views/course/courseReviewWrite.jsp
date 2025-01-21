<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/course/courseMain.css" rel="stylesheet">
<link href="/resources/css/course/courseQnAWrite.css" rel="stylesheet">
<link href="/resources/css/course/courseReviewWrite.css" rel="stylesheet">
<style>
.header {
	background: #b5aaf2;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
		
		// 별점 처리
		document.querySelectorAll('.star-rating .star').forEach(star => {
		    star.addEventListener('click', function () {
		        const value = this.getAttribute('data-value'); // 클릭한 별의 값 가져오기
		        document.getElementById('ratingValue').value = value; // 숨겨진 input에 값 저장

		        // 모든 별 초기화
		        document.querySelectorAll('.star-rating .star').forEach(s => {
		            s.classList.remove('selected');
		        });

		        // 클릭한 별과 그 이전 별들 선택
		        for (let i = 0; i < value; i++) {
		            document.querySelectorAll('.star-rating .star')[i].classList.add('selected');
		        }
		    });
		});

		

		
	});
	
	// 취소 버튼 눌렀을 때
	function fn_cancle() {
		document.bbsForm.classCode.value = ${classCode};
		document.bbsForm.courseCode.value = ${course.courseCode};
		document.bbsForm.action = "/course/courseReview";
		document.bbsForm.submit();
	}
	
	// 등록 버튼 눌렀을 때
	function fn_submit() {
		
		const contentHtml = quill.root.innerHTML;  // 작성한 글 내용 HTML
        console.log(contentHtml);  // 글 내용 HTML이 콘솔에 출력됩니다.
        // 여기서 contentHtml을 서버로 전송하여 저장하는 로직을 추가할 수 있습니다.

        
        // 별점 값 가져오기
		const ratingValue = document.getElementById("ratingValue").value;
        
		if (ratingValue === "0" || ratingValue === "") {
            Swal.fire({
                title: "Error",
                text: "별점을 등록해주세요.",
                icon: "error"
            });

        	return;
        }
		
		if ($.trim($("#title").val()).length <= 0) {
            Swal.fire({
                title: "Error",
                text: "제목을 입력해주세요.",
                icon: "error"
            });

			$("#title").val("");
			$("#title").focus();
			return;
		}
		
		if ($.trim(contentHtml).length <= 0 || contentHtml === "<p><br></p>") {
            Swal.fire({
                title: "Error",
                text: "내용을 입력해주세요.",
                icon: "error"
            });
            
            quill.focus();
            return;
        }

		var form = $("#writeForm")[0];
		var formData = new FormData(form);
		
		// contentHtml을 FormData에 추가
		formData.append("contentHtml", contentHtml);
		// 별점을 formData에 추가
		formData.append("ratingValue", ratingValue);
		
 		$.ajax({
			type : "POST",
			enctype : "multipart/form-data",
			url : "/course/courseReviewWriteProc",
			data : formData,
			processData : false,			// formData를 String으로 변환 X
			contentType : false,			// content-Type 헤더가 multipart/form-data로 전송
			cache : false,
			timeout : 600000,				// 6초
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(res) {
				if (res.code == 0) {
                    Swal.fire({
                        title: "등록 완료",
                        text: "게시글이 등록되었습니다.",
                        icon: "success"
                    }).then(() => {
    					document.bbsForm.classCode.value = ${classCode};
    					document.bbsForm.courseCode.value = ${course.courseCode};
    					document.bbsForm.action = "/course/courseReview";
    					document.bbsForm.submit();
                    });
 
				}
				else {
	                Swal.fire({
	                    title: "Error",
	                    text: "오류가 발생하였습니다. 다시 시도해주세요",
	                    icon: "error"
	                });
				}
			},
			error : function(xhr, status, error) {
				icia.common.error(error);
                Swal.fire({
                    title: "Error",
                    text: "오류가 발생하였습니다. 다시 시도해주세요",
                    icon: "error"
                });
			}
		});  
		
	}

</script>

<!-- Quill 에디터 스타일 -->
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<%@ include file="/WEB-INF/views/include/course/courseMainInfo.jsp"%>

	<div class="course-page">
		<ul class="tab-menu">
			<li onclick="fn_pageMove('courseMain')">강좌소개</li>
			<li onclick="fn_pageMove('courseList')">강의목록</li>
			<li onclick="fn_pageMove('courseNotice')">공지사항</li>
			<li onclick="fn_pageMove('courseQnA')">학습Q&A</li>
			<li class="active" onclick="fn_pageMove('courseReview')">수강후기</li>
		</ul>


		<div class="content">
		<div class="table-container" style="width: 100%;">

			<section class="board-container">
				<form class="board-form" id="writeForm" name="writeForm">
					<div class="form-group">
						<label for="title_">아이디</label>
						<input type="text" id="userId"  placeholder="${user.userId }" readonly>
					</div>
					<div class="form-group">
						<label for="title_">이메일</label>
						<input type="text" id="userEmail"  placeholder="${user.userEmail }" readonly>
					</div>
					<div class="form-group">
						<label for="title_">제목</label>
						<input type="text" id="title" name="title" placeholder="제목을 입력해주세요.">
					</div>
					
<!-- 	              <div class="filebox">
	                  <input class="upload-name" value="첨부파일" placeholder="첨부파일" readonly>
	                  <label for="file">파일찾기</label> 
	                  <input type="file" id="file" name="file">
	              </div> -->
	              
				<div class="form-group">
				    <label for="rating" class="rating-label">별점</label>
				    <div class="star-rating" id="rating">
				        <span class="star" data-value="1">★</span>
				        <span class="star" data-value="2">★</span>
				        <span class="star" data-value="3">★</span>
				        <span class="star" data-value="4">★</span>
				        <span class="star" data-value="5">★</span>
				    </div>
				    <input type="hidden" id="ratingValue" name="rating" value="0"> <!-- 선택한 별점 값 -->
				</div>



	              
				
				<!--  에디터 -->
		         <div class="form-group-editor">
		            <div id="editor-container"></div>
		         </div>




					<div class="form-group-inline">
						<div class="inline-buttons">
							<button type="button" onclick="fn_cancle()" class="cancel">취소</button>
							<button type="button" onclick="fn_submit()" class="submit">등록</button>
						</div>
					</div>
					
					<input type="hidden" name="classCode" value="${classCode}">
					<input type="hidden" name="courseCode" value="${course.courseCode }">
					<input type="hidden" name="teacherId" value="${teacher.userId }">
		
				</form>
			</section>
		</div>

		</div>
	</div>


	</div>

	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
	
	<form name="bbsForm" id="bbsForm" method="post">
   		<input type="hidden" name="brdSeq" value="">
   		<input type="hidden" name="searchType" id="searchType" value="${searchType }">
   		<input type="hidden" name="searchValue" id="searchValue" value="${searchValue }">
   		<input type="hidden" name="curPage" id="curPage" value="${curPage }">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
	
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
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
