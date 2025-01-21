<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/noticeUpdate.css" rel="stylesheet">
<title>공지사항 수정화면</title>
<style>
.header {
   background-color: #CF99C7;
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
       
       const brdContent = `${boardNotice.brdContent}`;
       quill.root.innerHTML = brdContent;
       
       $("#btnUpdate").on("click", function (event) {
           // 기본 동작 방지 (새로고침 차단)
           event.preventDefault();
         
           const contentHtml = quill.root.innerHTML;
           
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
           if ($.trim(contentHtml).length <= 0 || contentHtml === "<p><br></p>") {
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

           // 분류 선택 확인
           if ($.trim($("#category").val()) === "") {
              Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "분류를 선택해주세요.", 
                  showConfirmButton: false, 
                  timer: 1500 
                  });

               $("#category").focus(); // 분류 드롭다운에 포커스 이동
               $("#btnUpdate").prop("disabled", false);
               return;
           }

           // `isMust` 값 설정
           var selectedCategory = $("#category").val();
           if (selectedCategory === "necessary") {
               $("#isMust").val("Y"); // 필독 설정
           } else {
               $("#isMust").val("N"); // 일반 설정
           }

           // 폼 데이터 생성 및 AJAX 요청
           var form = $("#board-form")[0];
           var formData = new FormData(form);
           formData.append("contentHtml", contentHtml);

           $.ajax({
               type: "POST",
               enctype: "multipart/form-data",
               url: "/board/noticeUpdateProc",
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
                         title: "게시물이 수정되었습니다.",
                         showConfirmButton: false, 
                         timer: 1500 
                         }).then(function() {
                            document.bbsForm.action = "/board/noticeView";
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
                            location.href = "/board/noticeList";
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
         document.bbsForm.action = "/board/noticeView";
         document.bbsForm.submit();
       });
   });

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
            <li><a href="/board/noticeList" class="highlight">공지사항</a></li>
            <li><a href="/board/qnaList">문의사항</a></li>
            <li><a href="/board/freeList">자유게시판</a><br></li>
            <li><a href="/board/faqList">자주 묻는 질문</a></li>
         </ul>
      </div>
      <div class="table-container">
         <h2 class="subTitle">공지사항 > 게시글 수정</h2>
         <div class="header-line"></div>
         <section class="board-container">
            <form class="board-form"  id="board-form" method="post" enctype="multipart/form-data">
               <div class="form-group">
                  <label for="category">분류</label>
                  <select id="category" name="category">
                     <option value="">분류 선택</option>
                     <option value="necessary">필독🚨</option>
                     <option value="normal">일반</option>
                  </select>
               </div>
               <div class="form-group">
                  <label for="title">제목</label>
                  <input type="text" id="brdTitle" name="brdTitle" placeholder="제목을 입력해주세요."  value="${boardNotice.brdTitle}">
               </div>
               
               <label for="content">내용</label>
               <div class="form-group-editor">
                     <div id="editor-container"></div>
               </div>   

               <div class="filebox">
                   <input class="upload-name" id="brdFile" name="brdFile" value="${boardNotice.fileOrgName}" placeholder="첨부파일" readonly>
                   <label for="file">파일찾기</label>
                   <input type="file" id="file" name="brdFile" >
               </div>


               <div class="form-buttons">
                  <button type="button" id="btnList" class="cancel">취소</button>
                  <button type="submit" id="btnUpdate" class="submit">등록</button>
               </div>
               
               
               <input type="hidden" name="brdSeq" value="${boardNotice.brdSeq}" />
               <input type="hidden" name="searchType" value="${searchType}" />
               <input type="hidden" name="searchValue" value="${searchValue}" />
               <input type="hidden" name="curPage" value="${curPage}" />
               <input type="hidden" id="isMust" name="isMust" value="N" />
            </form>
         </section>
      </div>
   </section>
   
   <%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
   
   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="brdSeq" value="${boardNotice.brdSeq}" />
      <input type="hidden" name="searchType" value="${searchType}" />
      <input type="hidden" name="searchValue" value="${searchValue}" />
      <input type="hidden" name="curPage" value="${curPage}" />
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