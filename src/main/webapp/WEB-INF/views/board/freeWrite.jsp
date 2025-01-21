<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/freeWrite.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<title>자유게시판 글쓰기</title>
<style>
.header {
   background-color: #DDC5E1;
}
</style>
<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(3)>a").addClass("active");
      
      //취소 버튼 클릭 시
      $("#cancelBtn").on("click", function() {
         document.bbsForm.action = "/board/freeList";
         document.bbsForm.submit();
      });
      
      //글쓰기 버튼 클릭 시
      $("#writeBtn").on("click", function() {
       fn_write();
      });
      
      // 첨부파일 첨부 시
      $('#file').on('change', function() {
          var fileName = $(this).prop('files')[0].name;
          $('.upload-name').val(fileName);
      });
   });
   
      //글쓰기
      function fn_write()
      {
    	const contentHtml = quill.root.innerHTML;
    	  
        if($("#category").val() == "")
        {
        	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: '분류를 선택하세요.', 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

                  $("#category").val("");
                  $("#category").focus();
                  
           return;
        }
         
         if($.trim($("#title").val()).length <= 0)
        {
        	 Swal.fire({
         		position: "center", 
         		icon: "warning",
         		title: '제목을 입력하세요.', 
         		showConfirmButton: false, 
         		timer: 1500 
         		});

            $("#title").val("");
            $("#title").focus();
            
            return;
        }
         
         if($.trim(contentHtml).length <= 0 || contentHtml === "<p><br></p>")
         {
        	 Swal.fire({
         		position: "center", 
         		icon: "warning",
         		title: '내용을 입력하세요.', 
         		showConfirmButton: false, 
         		timer: 1500 
         		});

            quill.focus();
            
            return;
         }
         
         var form = $("#board-form")[0];
         var formData = new FormData(form);
         
         formData.append("contentHtml", contentHtml);
            
         $.ajax({
         type:"POST",
         enctype:"multipart/form-data",
         url:"/board/freeWriteProc",
         data:formData,
         processData:false,               
         contentType:false,               
         cache:false,
         beforeSend:function(xhr)
         {
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(response)
         {
            if(response.code == 0)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "success",
            		title: '게시물이 등록되었습니다.',
            		showConfirmButton: false, 
            		timer: 1500 
            		}).then(function() {
            			document.bbsForm.action = "/board/freeList";
                        document.bbsForm.submit();
            		});

            }   
            else if(response.code == 400)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '파라미터 값이 올바르지 않습니다.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

               $("#title").focus();
            }
            else if(response.code == 999)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '로그인 후 이용 가능합니다', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

               $("#title").focus();
            }
            else
            {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '게시물 등록 중 오류가 발생했습니다.2', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

               $("#title").focus();
            }
         },
         error:function(error)
         {
            icia.common.error(error);
            Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: '게시물 등록 중 오류가 발생하였습니다.', 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

         }
      });
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
         <div class="exam-date" id="d-day-display">
            2026 수능 <span class="days"></span>
         </div>
         <ul class="menu">
            <li><a href="/board/noticeList">공지사항</a></li>
            <li><a href="/board/qnaList">문의사항</a></li>
            <li><a href="/board/freeList" class="highlight">자유게시판</a></li>
            <li><a href="/board/faqList">자주 묻는 질문</a></li>
         </ul>
      </div>
      <div class="table-container">
         <h2 class="subTitle">자유게시판 > 게시글 쓰기</h2>
         <div class="header-line"></div>
         <section class="board-container">
            <form class="board-form" id="board-form" name="board-form" method="post" enctype="multipart/form-data">
               <div class="form-group">
                  <label for="category">분류</label> <select id="category" name="category">
                     <option value="">분류 선택</option>
                     <option value="1">일상/생각</option>
                     <option value="2">학습고민</option>
                     <option value="3">입시</option>
                     <option value="4">진로</option>
                  </select>
               </div>
               <div class="form-group">
                  <label for="title">제목</label>
                  <input type="text" id="title" name="title" placeholder="제목을 입력해주세요.">
               </div>
               <label for="content">내용</label>
               <div class="form-group-editor">
		            <div id="editor-container"></div>
		         </div>
               <div class="filebox">
                      <input class="upload-name" value="첨부파일" placeholder="첨부파일" readonly>
                            <label for="file">파일찾기</label> 
                      <input type="file" id="file" name="file">
                  </div>

               <p class="notice">
                  * 게시판에 개인정보(전화번호, 이메일 등)를 입력하시면 의무 노출의 위험이 있으므로 작성하지 말아주세요.<br> * 개인정보 작성 시 관리 요청 또는 삭제될 수 있습니다.
               </p>
               <div class="form-buttons">
                  <button type="button" id="cancelBtn" class="cancel">취소</button>
                  <button type="button" id="writeBtn" class="submit">등록</button>
               </div>
            </form>
         </section>
      </div>
   </section>
   
   <%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

   <form name="bbsForm" id="bbsForm" method="POST">
         <input type="hidden" name="brdSeq" value="" />
         <input type="hidden" name="searchType" value="${searchType}" />
         <input type="hidden" name="searchValue" value="${searchValue}" />
         <input type="hidden" name="curPage" value="${curPage}"/>
         <input type="hidden" name="category" value="${category}"/>
   </form>

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