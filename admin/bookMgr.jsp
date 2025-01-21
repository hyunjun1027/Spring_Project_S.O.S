<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<link href="/resources/css/admin/bookMgr.css" rel="stylesheet">
<script>
	
	/********** 등록 모달 ***********/
	//모달열기
	function fn_registerBook() {
        const modal = document.getElementById("bookModal1");
        modal.style.display = "block";
        document.getElementById("bookModal1").style.display = "flex";

	}
	
	//모달닫기
	function closeModal1() {
	    const modal = document.getElementById("bookModal1");
	    modal.style.display = "none";

	    //값 초기화
		$("#bookTitle").val("");
        $("#bookclassCode").val("");
        $("#bookInfo").val("");
        $("#bookAuth").val("");
        $("#bookPublisher").val("");
        $("#bookPrice").val("");
        $("#bookPayPrice").val("");
        $("#issueDate").val("");
        $("#invenQtt").val("");
	    
	}
	
	//등록 입력
	//강의 등록 버튼 클릭시
	function bookWrite()
	{
		$("#writeBtn").prop("disabled", true);
		
	    if (event) {
	        event.stopPropagation();
	        event.preventDefault();
	    }
	    
	    // 이미지 파일 검사 (JPG만 허용)
	    const fileInput = $("#bookImg1")[0];
	    
	    // 파일이 선택되지 않은 경우
	    if (fileInput.files.length === 0) {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "교재 이미지를 첨부하세요.", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	        $("#writeBtn").prop("disabled", false);
	        return;
	    }
	    
	    
	    const file = fileInput.files[0];
	    const fileType = file.type.toLowerCase(); // 소문자로 변환하여 검사
	    if (!fileType.includes("jpeg")) {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "JPG 파일만 업로드 가능합니다!", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	        $("#writeBtn").prop("disabled", false);
	        return;
	    }
	    

	    
	    
	    if($.trim($("#bookclassCode1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "과목코드를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookclassCode1").val("");
	    	$("#bookclassCode1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    if($.trim($("#bookTitle1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "교재명을 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookTitle1").val("");
	    	$("#bookTitle1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    if($.trim($("#bookInfo1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "교재정보를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookInfo1").val("");
	    	$("#bookInfo1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    
	    if($.trim($("#bookAuth1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "저자를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookAuth1").val("");
	    	$("#bookAuth1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    
	    if($.trim($("#bookPublisher1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "출판사를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookPublisher1").val("");
	    	$("#bookPublisher1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    
	    if($.trim($("#bookPrice1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "정가를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookPrice1").val("");
	    	$("#bookPrice1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    if($.trim($("#bookPayPrice1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "소비자가(실판매가격) 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookPayPrice1").val("");
	    	$("#bookPayPrice1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    if($.trim($("#issueDate1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "발행일을 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#issueDate1").val("");
	    	$("#issueDate1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    if($.trim($("#invenQtt1").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "재고수량을 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#invenQtt1").val("");
	    	$("#invenQtt1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    // 선택된 파일을 FormData에 추가
	    var formData = new FormData($("#bookAdminForm1")[0]);
	    
	    // 파일을 FormData에 추가
	    var selectedFile = $("#bookImg1")[0].files[0];
	    if (selectedFile) {
	        formData.append("file", selectedFile);
	    }

	    
	    
	    $.ajax({
			type:"POST",
			enctype:"multipart/form-data",
			url:"/admin/bookInsert",
			data:formData,
			processData:false,			
			contentType:false,			
			cache:false,
			timeout:600000,
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
	            if (response.code == 0) 
	            {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "success",
	            		title: "교재가 성공적으로 수정되었습니다.",
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		}).then(function() {
	            			document.bookAdminForm1.action="/admin/bookMgr";
							document.bookAdminForm1.submit();
	            		});

	            } else {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "[" + response.code + "] : " + response.msg, 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	            }

			},
			error:function(error)
			{
				icia.common.error(error);
				Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "등록 실패", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

				$("#writeBtn").prop("disabled", false);
			}
			
		});
	}
	
	
	
	
	
	
	
	
	
	
	
	
	/********** 수정 모달 ***********/
	//모달 열기
	function fn_adminBookUpdate(bookSeq, classCode) {
		$.ajax({
			type:"POST",
			url:"/admin/getBookDetails",
			data: {
				bookSeq: bookSeq,
				classCode: classCode
			},
			dataType:"JSON",
	        success: function(response) 
	        {
	        	console.log(response.data.bookSeq);
	        	console.log(response.data.classCode);
	        	
	        	
				$("#bookSeq").val(response.data.bookSeq);
				$("#bookTitle").val(response.data.bookTitle);
	            $("#bookclassCode").val(response.data.classCode);
	            $("#bookInfo").val(response.data.bookInfo);
	            $("#bookAuth").val(response.data.bookAuth);
	            $("#bookPublisher").val(response.data.bookPublisher);
	            $("#bookPrice").val(response.data.bookPrice);
	            $("#bookPayPrice").val(response.data.bookPayPrice);
	            $("#issueDate").val(response.data.issueDate);
	            $("#invenQtt").val(response.data.invenQtt);
	            $("#bookStatus").val(response.data.bookStatus);
	            
	            
	            
				
				// 이미지 미리보기 설정
	            const bookImgPreview = document.getElementById("bookImgPreview");
				bookImgPreview.src = '/resources/images/book/' + response.data.bookSeq + '.jpg'; // 이미지 경로
				bookImgPreview.style.display = "block"; // 이미지 표시
	            


	            // 모달 열기
	            const modal = document.getElementById("bookModal");
	            modal.style.display = "block";
	            document.getElementById("bookModal").style.display = "flex";

	        },
			error:function(error)
			{
				icia.common.error(error);
				console.log("Error fetching book details:", error);
			}
			
			
		});

	}


	//모달닫기
	function closeModal() {
	    const modal = document.getElementById("bookModal");
	    modal.style.display = "none";

		$("#bookSeq").val("");
        $("#bookclassCode").val("");
        $("#bookInfo").val("");
        $("#bookAuth").val("");
        $("#bookPublisher").val("");
        $("#bookPrice").val("");
        $("#bookPayPrice").val("");
        $("#issueDate").val("");
        $("#invenQtt").val("");
		$("#bookImgPreview").val("");
	    
	}

	// Esc 키 입력 방지
	document.addEventListener("keydown", function (event) {
	    if (event.key === "Escape") {
	        event.preventDefault(); // 기본 동작 방지
	    }
	});
	
	// 모달 배경 클릭 방지
	document.getElementById("bookModal").addEventListener("click", function (event) {
	    if (event.target === this) {
	        // 모달의 배경을 클릭해도 닫히지 않도록 전파 중단
	        event.stopPropagation();
	    }
	});
	
	
	// 이미지 파일 선택 후 미리보기 설정 함수
	function previewImage1(event) {
	    const file = event.target.files[0]; // 선택한 파일을 가져옴
	    const reader = new FileReader();

	    // 이미지 파일 형식 검사 (JPG만 허용)
	    const fileType = file.type.toLowerCase(); // 소문자로 변환하여 검사
	    if (fileType !== "image/jpeg" && fileType !== "image/jpg") {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "JPG 파일만 업로드 가능합니다!", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	        return; // JPG 파일이 아니면 미리보기 및 데이터 저장을 하지 않음
	    }

	    reader.onload = function(e) {
	        // 이미지 미리보기 표시
	        const bookImgPreview = document.getElementById("bookImgPreview1");
	        bookImgPreview.src = e.target.result; // 파일을 이미지로 표시
	        bookImgPreview.style.display = "block"; // 이미지 표시
	    }

	    if (file) {
	        reader.readAsDataURL(file); // 파일을 읽어 데이터 URL로 변환
	        $("#bookImg1").data('file', file);  // 선택된 파일을 임시로 저장
	    }
	}
	
	
	
	// 이미지 파일 선택 후 미리보기 설정 함수
	function previewImage(event) {
	    const file = event.target.files[0]; // 선택한 파일을 가져옴
	    const reader = new FileReader();

	    // 이미지 파일 형식 검사 (JPG만 허용)
	    const fileType = file.type.toLowerCase(); // 소문자로 변환하여 검사
	    if (fileType !== "image/jpeg" && fileType !== "image/jpg") {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "JPG 파일만 업로드 가능합니다!", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	        return; // JPG 파일이 아니면 미리보기 및 데이터 저장을 하지 않음
	    }

	    reader.onload = function(e) {
	        // 이미지 미리보기 표시
	        const bookImgPreview = document.getElementById("bookImgPreview");
	        bookImgPreview.src = e.target.result; // 파일을 이미지로 표시
	        bookImgPreview.style.display = "block"; // 이미지 표시
	    }

	    if (file) {
	        reader.readAsDataURL(file); // 파일을 읽어 데이터 URL로 변환
	        $("#bookImg").data('file', file);  // 선택된 파일을 임시로 저장
	    }
	}

	// 이미지 클릭 시 파일 선택 창 열기
	document.getElementById('bookImgPreview').addEventListener('click', function() {
	    document.getElementById('bookImg').click(); // 파일 선택 창 열기
	});

	
	
	
	//교재 수정 등록
	function updateAdmin()
	{
		$("#writeBtn").prop("disabled", true);
		
	    if (event) {
	        event.stopPropagation();
	        event.preventDefault();
	    }
	    
	    if($("#bookImgPreview").attr("src") == null || $("#bookImgPreview").attr("src") == "")
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "파일을 선택해주세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#writeBtn").prop("disabled", true);
	    }
	    else
	    {
	    	$("#writeBtn").prop("disabled", false);
	    }
	    
	    
	    
	    
	    
	    if($.trim($("#bookclassCode").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "과목코드를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookclassCode").val("");
	    	$("#bookclassCode").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    if($.trim($("#bookTitle").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "교재명을 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookTitle").val("");
	    	$("#bookTitle").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    if($.trim($("#bookInfo").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "교재정보를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookInfo").val("");
	    	$("#bookInfo").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    
	    if($.trim($("#bookAuth").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "저자를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookAuth").val("");
	    	$("#bookAuth").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    
	    if($.trim($("#bookPublisher").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "출판사를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookPublisher").val("");
	    	$("#bookPublisher").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    
	    if($.trim($("#bookPrice").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "정가를 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookPrice").val("");
	    	$("#bookPrice").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    if($.trim($("#bookPayPrice").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "소비자가(실판매가격) 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#bookPayPrice").val("");
	    	$("#bookPayPrice").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    if($.trim($("#issueDate").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "발행일을 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#issueDate").val("");
	    	$("#issueDate").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    if($.trim($("#invenQtt").val()).length <= 0)
	    {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: "재고수량을 입력하세요", 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	    	$("#invenQtt").val("");
	    	$("#invenQtt").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    var form = $("#bookAdminForm")[0];
		var formData = new FormData(form); 
	    
	    // 파일이 선택되었을 경우, 해당 파일을 FormData에 추가하여 서버에 업로드
	    // 선택된 파일 가져오기
	    var selectedFile = $("#bookImg").data('file');
	    if (selectedFile) {
	        formData.append("file", selectedFile); // 새로 선택된 파일 추가
	    } else {
	        // 기존 이미지를 보내기 위해 bookImgPreview의 src에서 경로 추출
	        const currentImgSrc = $("#bookImgPreview").attr("src");
	        if (currentImgSrc) {
	            const existingFileName = currentImgSrc.split('/').pop(); // 경로에서 파일명만 추출
	            formData.append("existingFile", existingFileName); // 기존 파일명 추가
	        }
	    }
	    
	    
	    $.ajax({
			type:"POST",
			enctype:"multipart/form-data",
			url:"/admin/bookUpdate",
			data:formData,
			processData:false,			
			contentType:false,			
			cache:false,
			timeout:600000,
			beforeSend:function(xhr)
			{
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(response)
			{
	            if (response.code == 0) 
	            {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "success",
	            		title: "교재가 성공적으로 수정되었습니다.",
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		}).then(function() {
	            			document.bookAdminForm.action="/admin/bookMgr";
							document.bookAdminForm.submit();
	            		});


	            } else {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "[" + response.code + "] : " + response.msg, 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	            }

			},
			error:function(error)
			{
				icia.common.error(error);
				Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "수정 실패", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

				$("#writeBtn").prop("disabled", false);
			}
			
		});
	    
	    
	}
	/******************************************************/
	
	
	$(document).ready(function(){
		
		//검색 버튼 클릭 시
	   $("#btnSearch").on("click", function() {
		   document.bbsForm.bookSeq.value = ""; //여러개의 게시물 받아야해서 초기화 해야함.
		   document.bbsForm.searchType.value = $("#searchType").val();
		   document.bbsForm.searchValue.value = $("#searchValue").val();
		   document.bbsForm.curPage.value = "1";
		   document.bbsForm.classCode.value = $("#classCode").val();
		   document.bbsForm.action = "/admin/bookMgr";
		   document.bbsForm.submit();
	   });
		
	});
	
	//교재 승인상태 선택
	function fn_repage(searchType)
	{
		document.bbsForm.searchType.value = searchType;
		document.bbsForm.searchValue.value = $("#searchValue").val();
		document.bbsForm.curPage.value = "1";
		document.bbsForm.classCode.value = $("#classCode").val();
		document.bbsForm.action = "/admin/bookMgr";
		document.bbsForm.submit();
	}
	
	//과목 선택
	function fn_relist(classCode)
	{
	   document.bbsForm.searchType.value = $("#searchType").val();
	   document.bbsForm.searchValue.value = $("#searchValue").val();
	   document.bbsForm.curPage.value = "1";
	   document.bbsForm.classCode.value = classCode;
	   document.bbsForm.action = "/admin/bookMgr";
	   document.bbsForm.submit();
	}
	
	//페이지 이동
	function fn_Page1(curPage)
	{
		document.bbsForm.searchType.value = $("#searchType").val();
		document.bbsForm.searchValue.value = $("#searchValue").val();
		document.bbsForm.classCode.value = $("#classCode").val();
		document.bbsForm.curPage.value = curPage;
	    document.bbsForm.action = "/admin/bookMgr";
	    document.bbsForm.submit();
	}
    </script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/admin/nav.jsp"%>
	<div id="wrapper">
		<div id="main_content">
			<h4>교재 관리</h4>
			<div class="search_section">
				<form name="bbsForm" method="post">
					<label for="searchType">등록 상태:</label> <select id="searchType" name="searchType" onchange="fn_repage(this.value)">
						<option value="" ${searchType == ''  ? 'selected' : ''}>전체</option>
						<option value="3" ${searchType == '3' ? 'selected' : ''}>승인 완료</option>
						<option value="4" ${searchType == '4' ? 'selected' : ''}>승인 대기</option>
					</select> <label for="classCode">과목:</label> <select id="classCode" name="classCode" onchange="fn_relist(this.value)">
						<option value="" ${classCode == ''  ? 'selected' : ''}>전체</option>
						<option value="1" ${classCode == '1' ? 'selected' : ''}>국어</option>
						<option value="2" ${classCode == '2' ? 'selected' : ''}>영어</option>
						<option value="3" ${classCode == '3' ? 'selected' : ''}>수학</option>
						<option value="4" ${classCode == '4' ? 'selected' : ''}>사회</option>
						<option value="5" ${classCode == '5' ? 'selected' : ''}>과학</option>
					</select> <label for="searchValue">책 제목:</label>
					<input type="text" id="searchValue" name="searchValue" value="${searchValue}" placeholder="책 제목을 입력하세요.">
					<button type="submit" id="btnSearch" class="btn">검색</button>

					<input type="hidden" name="bookSeq" value="${bookSeq}">
					<input type="hidden" name="curPage" value="${curPage}" />

				</form>
			</div>
			<table class="data_table">
				<thead>
					<tr>
						<th>이미지</th>
						<th>교재 번호</th>
						<th>과목 코드</th>
						<th>교재 제목</th>
						<th>교재 정보</th>
						<th>저자</th>
						<th>출판사</th>
						<th>정가</th>
						<th>소비자가</th>
						<th>상품등록일</th>
						<th>발행일</th>
						<th>재고 수량</th>
						<th>수정</th>
						<!-- <th>교재<br>승인상태</th> -->

					</tr>
				</thead>
				<tbody>
					<c:if test='${!empty list}'>
						<c:forEach var="Book" items="${list}" varStatus="status">
							<tr>

								<td><img src="/resources/images/book/${Book.bookSeq}.jpg" alt="GYM Book" class="product-img"></td>
								<td>${Book.bookSeq }</td>
								<c:if test='${Book.classCode eq "1"}'>
									<td>국어</td>
								</c:if>
								<c:if test='${Book.classCode eq "2"}'>
									<td>영어</td>
								</c:if>
								<c:if test='${Book.classCode eq "3"}'>
									<td>수학</td>
								</c:if>
								<c:if test='${Book.classCode eq "4"}'>
									<td>사회</td>
								</c:if>
								<c:if test='${Book.classCode eq "5"}'>
									<td>과학</td>
								</c:if>
								<td>${Book.bookTitle }</td>
								<td style="text-overflow: ellipsis; overflow: hidden; white-space: nowrap;">${Book.bookInfo }</td>
								<td>${Book.bookAuth }</td>
								<td>${Book.bookPublisher }</td>
								<td><fmt:formatNumber value="${Book.bookPrice}" type="number" pattern="#,###" />원</td>
								<td><fmt:formatNumber value="${Book.bookPayPrice}" type="number" pattern="#,###" />원</td>
								<td>${Book.regDate }</td>
								<td>${Book.issueDate }</td>
								<td>${Book.invenQtt }</td>
								<td><button type="button" class="order-link btn" onclick="fn_adminBookUpdate(${Book.bookSeq},'${Book.classCode}')">상세 정보</button></td>
								<%-- <c:if test='${Book.bookStatus eq "Y"}'>
								<td>승인</td>
								</c:if>
								<c:if test='${Book.bookStatus eq "N"}'>
								<td>승인 대기</td>
								</c:if> --%>

							</tr>
						</c:forEach>
					</c:if>

				</tbody>
			</table>

			<!-- -------------------------------------------------------------------------- -->
			<div class="pagination-wrapper">
				<div class="pagination">
					<c:if test="${!empty paging }">
						<c:if test="${paging.prevBlockPage gt 0}">
							<a href="#" class="page-link" onclick="fn_page1(${paging.prevBlockPage})">&laquo;</a>
						</c:if>

						<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
							<c:choose>
								<c:when test="${i eq curPage}">
									<span class="page-link active">${i }</span>
								</c:when>
								<c:otherwise>
									<span class="page-link"><a href="#" onclick="fn_Page1(${i})">${i}</a></span>
								</c:otherwise>
							</c:choose>
						</c:forEach>

						<c:if test="${paging.nextBlockPage gt 0}">
							<a href="#" class="page-link" onclick="fn_Page1(${paging.nextBlockPage})">&raquo;</a>
						</c:if>
					</c:if>
				</div>
				<button type="button" id="btnRegister" onclick="fn_registerBook()">등록</button>
			</div>



			<!-- -------------------------------------------------------------------------- -->

		</div>
	</div>

	<!-- 수정 Modal -->
	<form name="bookAdminForm" id="bookAdminForm" method="post" enctype="multipart/form-data">
		<div id="bookModal" class="modal">
			<div class="modal-content">

				<div class="modal-header">
					<h2 class="modal-title">교재 관리</h2>
					<span class="close" onclick="closeModal()">&times;</span>
				</div>

				<div class="modal-body">
					<div class="modal-section">
						<label class="modal-label">교재 이미지</label>
						<div class="modal-section">
							<!-- 숨겨진 파일 입력 -->
							<input type="file" id="bookImg" name="bookImg" class="modal-input" style="display: none;" accept="image/jpg" onchange="previewImage(event)" />
							<!-- 이미지를 클릭하면 파일 선택 창이 열림 -->
							<img id="bookImgPreview" src="" class="modal-img" style="width: 150px; height: auto; margin-bottom: 10px; cursor: pointer;" onclick="document.getElementById('bookImg').click();" />


						</div>
					</div>

					<input type="hidden" id="bookSeq" name="bookSeq" value="">

					<div class="modal-section">
						<label class="modal-label">교재명</label>
						<input type="text" id="bookTitle" name="bookTitle" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">과목 코드</label>
						<input type="text" id="bookclassCode" name="bookclassCode" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">교재 정보</label>
						<input type="text" id="bookInfo" name="bookInfo" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">저자</label>
						<input type="text" id="bookAuth" name="bookAuth" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">출판사</label>
						<input type="text" id="bookPublisher" name="bookPublisher" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">정가</label>
						<input type="text" id="bookPrice" name="bookPrice" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">소비자가</label>
						<input type="text" id="bookPayPrice" name="bookPayPrice" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">발행일</label>
						<input type="text" id="issueDate" name="issueDate" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">재고수량</label>
						<input type="text" id="invenQtt" name="invenQtt" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<h3>주문 상태</h3>
						<select id="bookStatus" name="bookStatus" class="styled-select">
							<option value="N" ${bookStatus == 'N' ? 'selected' : ''}>승인 대기</option>
							<option value="Y" ${bookStatus == 'Y' ? 'selected' : ''}>승인 완료</option>
						</select>
					</div>

					<div class="modal_footer">
						<button class="modal-btn add-btn" id="writeBtn" onclick="updateAdmin()">수정</button>
						<button class="modal-btn cancel-btn" id="cancelBtn" onclick="closeModal()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</form>



	<!-- 등록 Modal -->
	<form name="bookAdminForm1" id="bookAdminForm1" method="post" enctype="multipart/form-data">
		<div id="bookModal1" class="modal">
			<div class="modal-content">

				<div class="modal-header">
					<h2 class="modal-title">교재 관리</h2>
					<span class="close" onclick="closeModal1()">&times;</span>
				</div>

				<div class="modal-body">
					<div class="modal-section">
						<label class="modal-label">교재 이미지</label>
						<div class="modal-section">
							<!-- 이미지를 클릭하면 파일 선택 창이 열림 -->
							<img id="bookImgPreview1" src="" class="modal-img" style="width: 150px; height: auto; margin-bottom: 10px; cursor: pointer;" onclick="document.getElementById('bookImg').click();" />
							<!-- 숨겨진 파일 입력 -->
							<input type="file" id="bookImg1" name="bookImg1" class="modal-input" accept="image/jpg" onchange="previewImage1(event)" />


						</div>
					</div>



					<div class="modal-section">
						<label class="modal-label">교재명</label>
						<input type="text" id="bookTitle1" name="bookTitle1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">과목 코드</label>
						<input type="text" id="bookclassCode1" name="bookclassCode1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">교재 정보</label>
						<input type="text" id="bookInfo1" name="bookInfo1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">저자</label>
						<input type="text" id="bookAuth1" name="bookAuth1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">출판사</label>
						<input type="text" id="bookPublisher1" name="bookPublisher1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">정가</label>
						<input type="text" id="bookPrice1" name="bookPrice1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">소비자가</label>
						<input type="text" id="bookPayPrice1" name="bookPayPrice1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">발행일</label>
						<input type="date" id="issueDate1" name="issueDate1" class="modal-input" value="" />
					</div>
					<div class="modal-section">
						<label class="modal-label">재고수량</label>
						<input type="text" id="invenQtt1" name="invenQtt1" class="modal-input" value="" />
					</div>

					<div class="modal_footer">
						<button class="modal-btn add-btn" id="writeBtn" onclick="bookWrite()">등록</button>
						<button class="modal-btn cancel-btn" id="cancelBtn" onclick="closeModal1()">취소</button>
					</div>
				</div>
			</div>
		</div>
	</form>











</body>
</html>