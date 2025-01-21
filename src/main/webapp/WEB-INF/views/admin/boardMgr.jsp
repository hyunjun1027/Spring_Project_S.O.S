<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<link href="/resources/css/admin/boardMgr.css" rel="stylesheet">
<script>

       function fn_noticeList(curPage) {
          
          document.bbsForm.brdSeq.value = "";
          document.bbsForm.noticeCurPage.value = curPage; // 공지사항 전용 변수
           document.bbsForm.qnaCurPage.value = document.bbsForm.qnaCurPage.value || 1; // 유지
           document.bbsForm.freeCurPage.value = document.bbsForm.freeCurPage.value || 1; // 유지
           document.bbsForm.action = '/admin/boardMgr';
           document.bbsForm.submit();
       }
   
       function fn_qnaList(curPage) {
          document.bbsForm.brdSeq.value = "";
           document.bbsForm.qnaCurPage.value = curPage; // 문의사항 전용 변수
           document.bbsForm.noticeCurPage.value = document.bbsForm.noticeCurPage.value || 1; // 유지
           document.bbsForm.freeCurPage.value = document.bbsForm.freeCurPage.value || 1; // 유지
           document.bbsForm.action = '/admin/boardMgr';
           document.bbsForm.submit();
       }
   
       function fn_freeList(curPage) {
          document.bbsForm.brdSeq.value = "";
           document.bbsForm.freeCurPage.value = curPage; // 자유게시판 전용 변수
           document.bbsForm.noticeCurPage.value = document.bbsForm.noticeCurPage.value || 1; // 유지
           document.bbsForm.qnaCurPage.value = document.bbsForm.qnaCurPage.value || 1; // 유지
           document.bbsForm.action = '/admin/boardMgr';
           document.bbsForm.submit();
       }
       
       function fn_noticeDelList(curPage) {
          
           document.bbsForm.brdSeq.value = "";
           document.bbsForm.noticeDelCurPage.value = curPage; // 공지사항 전용 변수
           document.bbsForm.qnaDelCurPage.value = document.bbsForm.qnaCurDelPage.value || 1; // 유지
           document.bbsForm.freeDelCurPage.value = document.bbsForm.freeCurDelPage.value || 1; // 유지
           document.bbsForm.action = '/admin/boardMgr';
           document.bbsForm.submit();
       }
   
       function fn_qnaDelList(curPage) {
           document.bbsForm.brdSeq.value = "";
           document.bbsForm.qnaDelCurPage.value = curPage; // 문의사항 전용 변수
           document.bbsForm.noticeDelCurPage.value = document.bbsForm.noticeDelCurPage.value || 1; // 유지
           document.bbsForm.freeDelCurPage.value = document.bbsForm.freeDelCurPage.value || 1; // 유지
           document.bbsForm.action = '/admin/boardMgr';
           document.bbsForm.submit();
       }
   
       function fn_freeDelList(curPage) {
           document.bbsForm.brdSeq.value = "";
           document.bbsForm.freeDelCurPage.value = curPage; // 자유게시판 전용 변수
           document.bbsForm.noticeDelCurPage.value = document.bbsForm.noticeDelCurPage.value || 1; // 유지
           document.bbsForm.qnaDelCurPage.value = document.bbsForm.qnaDelCurPage.value || 1; // 유지
           document.bbsForm.action = '/admin/boardMgr';
           document.bbsForm.submit();
       }
       
       function fn_noticeView(brdSeq){
          document.bbsForm.brdSeq.value = brdSeq;
          document.bbsForm.action = "/board/noticeView";
          document.bbsForm.submit();
       }
       function fn_qnaView(brdSeq){
          document.bbsForm.brdSeq.value = brdSeq;
          document.bbsForm.action = "/board/qnaView";
          document.bbsForm.submit();
       }
       function fn_freeView(brdSeq){
          document.bbsForm.brdSeq.value = brdSeq;
          document.bbsForm.action = "/board/freeView";
          document.bbsForm.submit();
       }
       
      /* 공지사항 글작성 */
      function fn_noticeWrite(boardType){

         document.bbsForm.brdSeq.value = "";
         document.bbsForm.action = "/board/noticeWrite";
         document.bbsForm.submit();
      
      }

      
       function fn_noticeDelete(){
           var selectedValues = [];
           var deleteUrl = "";

            deleteUrl = "/admin/noticeDelete";
            $("input[name='noticeCheckbox']:checked").each(function () {
                selectedValues.push($(this).val());
            });


           if (selectedValues.length === 0) {
        	   Swal.fire({
           		position: "center", 
           		icon: "warning",
           		title: "삭제할 항목을 선택하세요.", 
           		showConfirmButton: false, 
           		timer: 1500 
           		});

               return;
           }

           Swal.fire({
        	   title: "선택한 게시물을 삭제 하시겠습니까?",
        	   icon: "warning",
        	   showCancelButton: true,
        	   confirmButtonColor: "#3085d6",
        	   cancelButtonColor: "#d33",
        	   confirmButtonText: "삭제",
        	 cancelButtonText:"취소"
        	 }).then((result) => {
        	   if (result.isConfirmed) {

               $.ajax({
                   type: "POST",
                   url: deleteUrl,
                   contentType: "application/json",
                   data: JSON.stringify(selectedValues),
                   dataType: "JSON",
                   success: function (response) {
                       if (response.code == 0) {
                    	   Swal.fire({
                    		   position: "center", 
                    		   icon: "success",
                    		   title: "선택한 게시글이 삭제되었습니다.",
                    		   showConfirmButton: false, 
                    		   timer: 1500 
                    		   }).then(function() {
                    		   		document.bbsForm.action = "/admin/boardMgr";
                           			document.bbsForm.submit();
                    		   });

                       } else {
                    	   Swal.fire({
                       		position: "center", 
                       		icon: "warning",
                       		title: "삭제 중 오류 발생: " + response.message, 
                       		showConfirmButton: false, 
                       		timer: 1500 
                       		});

                       }
                   },
                   error: function (xhr, status, error) {
                	   Swal.fire({
                   		position: "center", 
                   		icon: "warning",
                   		title: "삭제 중 오류가 발생하였습니다: " + error, 
                   		showConfirmButton: false, 
                   		timer: 1500 
                   		});

                   }
               });
           }
       	});
       }
       function fn_qnaDelete(){
           var selectedValues = [];
           var deleteUrl = "";

            deleteUrl = "/admin/qnaDelete";
            $("input[name='qnaCheckbox']:checked").each(function () {
                selectedValues.push($(this).val());
            });


           if (selectedValues.length === 0) {
        	   Swal.fire({
           		position: "center", 
           		icon: "warning",
           		title: "삭제할 항목을 선택하세요.", 
           		showConfirmButton: false, 
           		timer: 1500 
           		});

               return;
           }

           Swal.fire({
        	   title: "선택한 게시물을 삭제 하시겠습니까?",
        	   icon: "warning",
        	   showCancelButton: true,
        	   confirmButtonColor: "#3085d6",
        	   cancelButtonColor: "#d33",
        	   confirmButtonText: "삭제",
        	 cancelButtonText:"취소"
        	 }).then((result) => {
        	   if (result.isConfirmed) {

               $.ajax({
                   type: "POST",
                   url: deleteUrl,
                   contentType: "application/json",
                   data: JSON.stringify(selectedValues),
                   dataType: "JSON",
                   success: function (response) {
                       if (response.code == 0) {
                    	   Swal.fire({
                    		   position: "center", 
                    		   icon: "success",
                    		   title: "선택한 게시글이 삭제되었습니다.",
                    		   showConfirmButton: false, 
                    		   timer: 1500 
                    		   }).then(function() {
                    		   		document.bbsForm.action = "/admin/boardMgr";
                           			document.bbsForm.submit();
                    		   });

                       } else {
                    	   Swal.fire({
                       		position: "center", 
                       		icon: "warning",
                       		title: "삭제 중 오류 발생: " + response.message, 
                       		showConfirmButton: false, 
                       		timer: 1500 
                       		});

                       }
                   },
                   error: function (xhr, status, error) {
                	   Swal.fire({
                   		position: "center", 
                   		icon: "warning",
                   		title: "삭제 중 오류가 발생하였습니다: " + error, 
                   		showConfirmButton: false, 
                   		timer: 1500 
                   		});

                   }
               });
           }
       	});
       }
       function fn_freeDelete(){
           var selectedValues = [];
           var deleteUrl = "";

            deleteUrl = "/admin/freeDelete";
            $("input[name='freeCheckbox']:checked").each(function () {
                selectedValues.push($(this).val());
            });


           if (selectedValues.length === 0) {
        	   Swal.fire({
           		position: "center", 
           		icon: "warning",
           		title: "삭제할 항목을 선택하세요.", 
           		showConfirmButton: false, 
           		timer: 1500 
           		});

               return;
           }
           Swal.fire({
        	   title: "선택한 게시물을 삭제 하시겠습니까?",
        	   icon: "warning",
        	   showCancelButton: true,
        	   confirmButtonColor: "#3085d6",
        	   cancelButtonColor: "#d33",
        	   confirmButtonText: "삭제",
        	 cancelButtonText:"취소"
        	 }).then((result) => {
        	   if (result.isConfirmed) {

               $.ajax({
                   type: "POST",
                   url: deleteUrl,
                   contentType: "application/json",
                   data: JSON.stringify(selectedValues),
                   dataType: "JSON",
                   success: function (response) {
                       if (response.code == 0) {
                    	   Swal.fire({
                    		   position: "center", 
                    		   icon: "success",
                    		   title: "선택한 게시글이 삭제되었습니다.",
                    		   showConfirmButton: false, 
                    		   timer: 1500 
                    		   }).then(function() {
                    		   		document.bbsForm.action = "/admin/boardMgr";
                           			document.bbsForm.submit();
                    		   });

                       } else {
                    	   Swal.fire({
                       		position: "center", 
                       		icon: "warning",
                       		title: "삭제 중 오류 발생: " + response.message, 
                       		showConfirmButton: false, 
                       		timer: 1500 
                       		});

                       }
                   },
                   error: function (xhr, status, error) {
                	   Swal.fire({
                   		position: "center", 
                   		icon: "warning",
                   		title: "삭제 중 오류가 발생하였습니다: " + error, 
                   		showConfirmButton: false, 
                   		timer: 1500 
                   		});

                   }
               });
           }
       	});
       }
       
       
       function fn_noticeRealDelete(){
           var selectedValues = [];
           var deleteUrl = "";

            deleteUrl = "/admin/noticeRealDelete";
            $("input[name='noticeDelCheckbox']:checked").each(function () {
                selectedValues.push($(this).val());
            });


           if (selectedValues.length === 0) {
        	   Swal.fire({
           		position: "center", 
           		icon: "warning",
           		title: "삭제할 항목을 선택하세요.", 
           		showConfirmButton: false, 
           		timer: 1500 
           		});

               return;
           }

           Swal.fire({
        	   title: "선택한 게시물을 완전히 삭제 하시겠습니까?",
        	   icon: "warning",
        	   showCancelButton: true,
        	   confirmButtonColor: "#3085d6",
        	   cancelButtonColor: "#d33",
        	   confirmButtonText: "삭제",
        	 cancelButtonText:"취소"
        	 }).then((result) => {
        	   if (result.isConfirmed) {

               $.ajax({
                   type: "POST",
                   url: deleteUrl,
                   contentType: "application/json",
                   data: JSON.stringify(selectedValues),
                   dataType: "JSON",
                   success: function (response) {
                       if (response.code == 0) {
                    	   Swal.fire({
                    		   position: "center", 
                    		   icon: "success",
                    		   title: "선택한 게시글이 삭제되었습니다.",
                    		   showConfirmButton: false, 
                    		   timer: 1500 
                    		   }).then(function() {
                    		   		document.bbsForm.action = "/admin/boardMgr";
                           			document.bbsForm.submit();
                    		   });

                       } else {
                    	   Swal.fire({
                       		position: "center", 
                       		icon: "warning",
                       		title: "삭제 중 오류 발생: " + response.message, 
                       		showConfirmButton: false, 
                       		timer: 1500 
                       		});

                       }
                   },
                   error: function (xhr, status, error) {
                	   Swal.fire({
                   		position: "center", 
                   		icon: "warning",
                   		title: "삭제 중 오류가 발생하였습니다: " + error, 
                   		showConfirmButton: false, 
                   		timer: 1500 
                   		});

                   }
               });
           }
       	});
       }
       function fn_qnaRealDelete(){
           var selectedValues = [];
           var deleteUrl = "";

            deleteUrl = "/admin/qnaRealDelete";
            $("input[name='qnaDelCheckbox']:checked").each(function () {
                selectedValues.push($(this).val());
            });


           if (selectedValues.length === 0) {
        	   Swal.fire({
           		position: "center", 
           		icon: "warning",
           		title: "삭제할 항목을 선택하세요.", 
           		showConfirmButton: false, 
           		timer: 1500 
           		});

               return;
           }

           Swal.fire({
        	   title: "선택한 게시물을 완전히 삭제 하시겠습니까?",
        	   icon: "warning",
        	   showCancelButton: true,
        	   confirmButtonColor: "#3085d6",
        	   cancelButtonColor: "#d33",
        	   confirmButtonText: "삭제",
        	 cancelButtonText:"취소"
        	 }).then((result) => {
        	   if (result.isConfirmed) {

               $.ajax({
                   type: "POST",
                   url: deleteUrl,
                   contentType: "application/json",
                   data: JSON.stringify(selectedValues),
                   dataType: "JSON",
                   success: function (response) {
                       if (response.code == 0) {
                    	   Swal.fire({
                    		   position: "center", 
                    		   icon: "success",
                    		   title: "선택한 게시글이 삭제되었습니다.",
                    		   showConfirmButton: false, 
                    		   timer: 1500 
                    		   }).then(function() {
                    		   		document.bbsForm.action = "/admin/boardMgr";
                           			document.bbsForm.submit();
                    		   });

                       } else {
                    	   Swal.fire({
                       		position: "center", 
                       		icon: "warning",
                       		title: "삭제 중 오류 발생: " + response.msg, 
                       		showConfirmButton: false, 
                       		timer: 1500
                       		});

                       }
                   },
                   error: function (xhr, status, error) {
                	   Swal.fire({
                   		position: "center", 
                   		icon: "warning",
                   		title: "삭제 중 오류가 발생하였습니다: " + error, 
                   		showConfirmButton: false, 
                   		timer: 1500 
                   		});

                   }
               });
           }
       	});
       }
       function fn_freeRealDelete(){
           var selectedValues = [];
           var deleteUrl = "";

            deleteUrl = "/admin/freeRealDelete";
            $("input[name='freeDelCheckbox']:checked").each(function () {
                selectedValues.push($(this).val());
            });


           if (selectedValues.length === 0) {
        	   Swal.fire({
           		position: "center", 
           		icon: "warning",
           		title: "삭제할 항목을 선택하세요.", 
           		showConfirmButton: false, 
           		timer: 1500 
           		});

               return;
           }
           Swal.fire({
        	   title: "선택한 게시물을 완전히 삭제 하시겠습니까?",
        	   icon: "warning",
        	   showCancelButton: true,
        	   confirmButtonColor: "#3085d6",
        	   cancelButtonColor: "#d33",
        	   confirmButtonText: "삭제",
        	 cancelButtonText:"취소"
        	 }).then((result) => {
        	   if (result.isConfirmed) {

               $.ajax({
                   type: "POST",
                   url: deleteUrl,
                   contentType: "application/json",
                   data: JSON.stringify(selectedValues),
                   dataType: "JSON",
                   success: function (response) {
                       if (response.code == 0) {
                    	   Swal.fire({
                    		   position: "center", 
                    		   icon: "success",
                    		   title: "선택한 게시글이 삭제되었습니다.",
                    		   showConfirmButton: false, 
                    		   timer: 1500 
                    		   }).then(function() {
                    		   		document.bbsForm.action = "/admin/boardMgr";
                           			document.bbsForm.submit();
                    		   });

                       } else {
                    	   Swal.fire({
                       		position: "center", 
                       		icon: "warning",
                       		title: "삭제 중 오류 발생: " + response.message, 
                       		showConfirmButton: false, 
                       		timer: 1500 
                       		});

                       }
                   },
                   error: function (xhr, status, error) {
                	   Swal.fire({
                   		position: "center", 
                   		icon: "warning",
                   		title: "삭제 중 오류가 발생하였습니다: " + error, 
                   		showConfirmButton: false, 
                   		timer: 1500 
                   		});

                   }
               });
           }
       	});
       }

       
       document.addEventListener("DOMContentLoaded", function() {
           // 각 게시판의 전체 선택 체크박스를 가져옵니다.
           const chkAllNotice = document.getElementById("chkAllNotice"); // 공지사항 전체 선택
           const chkAllQna = document.getElementById("chkAllQna"); // Q&A 전체 선택
           const chkAllFree = document.getElementById("chkAllFree"); // 자유게시판 전체 선택
           const chkAllDelNotice = document.getElementById("chkAllDelNotice"); // 삭제공지사항 전체 선택
           const chkAllDelQna = document.getElementById("chkAllDelQna"); // 삭제Q&A 전체 선택
           const chkAllDelFree = document.getElementById("chkAllDelFree"); // 삭제자유게시판 전체 선택


           // 각 게시판의 체크박스를 가져옵니다.
           const noticeCheckboxes = document.querySelectorAll("#noticeCheckbox"); // 공지사항 체크박스
           const qnaCheckboxes = document.querySelectorAll("#qnaCheckbox"); // Q&A 체크박스
           const freeCheckboxes = document.querySelectorAll("#freeCheckbox"); // 자유게시판 체크박스
           const noticeDelCheckboxes = document.querySelectorAll("#noticeDelCheckbox"); // 삭제공지사항 체크박스
           const qnaDelCheckboxes = document.querySelectorAll("#qnaDelCheckbox"); // 삭제Q&A 체크박스
           const freeDelCheckboxes = document.querySelectorAll("#freeDelCheckbox"); // 삭제자유게시판 체크박스

           // 공지사항 전체 선택 체크박스 클릭 이벤트
           chkAllNotice.addEventListener("click", function() {
               const isChecked = chkAllNotice.checked;
               noticeCheckboxes.forEach(function(checkbox) {
                   checkbox.checked = isChecked;
               });
           });

           // Q&A 전체 선택 체크박스 클릭 이벤트
           chkAllQna.addEventListener("click", function() {
               const isChecked = chkAllQna.checked;
               qnaCheckboxes.forEach(function(checkbox) {
                   checkbox.checked = isChecked;
               });
           });

           // 자유게시판 전체 선택 체크박스 클릭 이벤트
           chkAllFree.addEventListener("click", function() {
               const isChecked = chkAllFree.checked;
               freeCheckboxes.forEach(function(checkbox) {
                   checkbox.checked = isChecked;
               });
           });
           
           // 공지사항 전체 선택 체크박스 클릭 이벤트
           chkAllDelNotice.addEventListener("click", function() {
               const isChecked = chkAllDelNotice.checked;
               noticeDelCheckboxes.forEach(function(checkbox) {
                   checkbox.checked = isChecked;
               });
           });

           // Q&A 전체 선택 체크박스 클릭 이벤트
           chkAllDelQna.addEventListener("click", function() {
               const isChecked = chkAllDelQna.checked;
               qnaDelCheckboxes.forEach(function(checkbox) {
                   checkbox.checked = isChecked;
               });
           });

           // 자유게시판 전체 선택 체크박스 클릭 이벤트
           chkAllDelFree.addEventListener("click", function() {
               const isChecked = chkAllDelFree.checked;
               freeDelCheckboxes.forEach(function(checkbox) {
                   checkbox.checked = isChecked;
               });
           });

       });


    
       
    </script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/admin/nav.jsp"%>
	<div class="content">
		<div class="table-section">
			<div class="table-section-header">
				<h4>공지사항</h4>
				<p style="font-size: 14px; margin-top: 5px; margin-left: 5px;">(${noticeTotalCount})</p>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 10%">선택</th>
						<th style="width: 10%">번호</th>
						<th style="width: 40%">제목</th>
						<th style="width: 30%">작성일</th>
						<th style="width: 10%">조회수</th>
					</tr>
				</thead>
				<tbody>
					<!-- 일반 공지사항 -->
					<c:if test='${!empty noticeList}'>
						<c:forEach var="noticeBoard" items="${noticeList}" varStatus="status">
							<c:if test="${empty noticeBoard.delDate}">
								<tr>
									<td><input type="checkbox" id="noticeCheckbox" name="noticeCheckbox" value="${noticeBoard.brdSeq}"></td>
									<td>${noticeBoard.brdSeq}</td>
									<td onclick="fn_noticeView(${noticeBoard.brdSeq})" style="cursor: pointer">${noticeBoard.brdTitle}</td>
									<td>${noticeBoard.modDate}</td>
									<td>${noticeBoard.brdReadCnt}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>

					<!-- 공지글이 없을 경우 -->
					<c:if test='${empty noticeList}'>
						<tr>
							<td colspan="5">작성된 공지글이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="btn-group-container">

				<div class="choose-all">
					<div class="select-all-container">
						<input type="checkbox" id="chkAllNotice" class="select-all" />
						<label for="chkAllNotice">전체 선택</label>
					</div>
				</div>

				<div>

					<div class="pagination-wrapper">
						<div class="pagination">
							<c:if test="${!empty noticePaging }">
								<c:if test="${noticePaging.prevBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_noticeList(${noticePaging.prevBlockPage})">&laquo;</a>
								</c:if>

								<c:forEach var="i" begin="${noticePaging.startPage}" end="${noticePaging.endPage}">
									<c:choose>
										<c:when test="${i eq noticePaging.curPage}">
											<span class="page-link active">${i }</span>
										</c:when>
										<c:otherwise>
											<span class="page-link" onclick="fn_noticeList(${i})"><a href="#">${i}</a></span>
										</c:otherwise>
									</c:choose>
								</c:forEach>

								<c:if test="${noticePaging.nextBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_noticeList(${noticePaging.nextBlockPage})">&raquo;</a>
								</c:if>
							</c:if>
						</div>
					</div>
				</div>
				<div>
					<button type="button" class="btn" onclick="fn_noticeWrite()">글쓰기</button>
					<button type="button" onclick="fn_noticeDelete()" name="noticeDeleteBtn" id="noticeDeleteBtn" class="btn">삭제</button>
				</div>
			</div>
			
			<div class="table-section-header">
				<h4>삭제된 공지사항</h4>
				<p style="font-size: 14px; margin-top: 5px; margin-left: 5px;">(${noticeDelTotalCount})</p>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 10%">선택</th>
						<th style="width: 10%">번호</th>
						<th style="width: 40%">제목</th>
						<th style="width: 30%">작성일</th>
						<th style="width: 10%">조회수</th>
					</tr>
				</thead>
				<tbody>
					<!-- 일반 공지사항 -->
					<c:if test='${!empty noticeDelList}'>
						<c:forEach var="noticeBoard" items="${noticeDelList}" varStatus="status">
							<c:if test="${!empty noticeBoard.delDate}">
								<tr>
									<td><input type="checkbox" id="noticeDelCheckbox" name="noticeDelCheckbox" value="${noticeBoard.brdSeq}"></td>
									<td>${noticeBoard.brdSeq}</td>
									<td onclick="fn_noticeView(${noticeBoard.brdSeq})" style="cursor: pointer">${noticeBoard.brdTitle}</td>
									<td>${noticeBoard.modDate}</td>
									<td>${noticeBoard.brdReadCnt}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>

					<!-- 공지글이 없을 경우 -->
					<c:if test='${empty noticeDelList}'>
						<tr>
							<td colspan="5">삭제된 공지글이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="btn-group-container">

				<div class="choose-all">
					<div class="select-all-container">
						<input type="checkbox" id="chkAllDelNotice" class="select-all" />
						<label for="chkAllDelNotice">전체 선택</label>
					</div>
				</div>

				<div>

					<div class="pagination-wrapper">
						<div class="pagination">
							<c:if test="${!empty noticeDelPaging }">
								<c:if test="${noticeDelPaging.prevBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_noticeDelList(${noticeDelPaging.prevBlockPage})">&laquo;</a>
								</c:if>

								<c:forEach var="i" begin="${noticeDelPaging.startPage}" end="${noticeDelPaging.endPage}">
									<c:choose>
										<c:when test="${i eq noticeDelPaging.curPage}">
											<span class="page-link active">${i }</span>
										</c:when>
										<c:otherwise>
											<span class="page-link" onclick="fn_noticeDelList(${i})"><a href="#">${i}</a></span>
										</c:otherwise>
									</c:choose>
								</c:forEach>

								<c:if test="${noticeDelPaging.nextBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_noticeDelList(${noticeDelPaging.nextBlockPage})">&raquo;</a>
								</c:if>
							</c:if>
						</div>
					</div>
				</div>
				<div>
					<button type="button" onclick="fn_noticeRealDelete()" name="noticeDeleteBtn" id="noticeDeleteBtn" class="btn">삭제</button>
				</div>
			</div>

			<div class="table-section-header">
				<h4>문의사항</h4>
				<p style="font-size: 14px; margin-top: 5px; margin-left: 5px;">(${qnaTotalCount})</p>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 10%">선택</th>
						<th style="width: 10%">번호</th>
						<th style="width: 40%">제목</th>
						<th style="width: 10%">작성자</th>
						<th style="width: 20%">작성일</th>
						<th style="width: 10%">답변상태</th>
					</tr>
				</thead>
				<c:if test="${!empty qnaList}">
					<tbody>
						<c:forEach var="qnaBoard" items="${qnaList}" varStatus="status">
							<c:if test="${empty qnaBoard.delDate and qnaBoard.brdParent eq '0'}">

								<c:if test='${!empty qnaBoard.brdPwd}'>

									<tr>
										<td><input type="checkbox" id="qnaCheckbox" name="qnaCheckbox" value="${qnaBoard.brdSeq}"></td>
										<td>${qnaBoard.brdSeq}</td>
										<td onclick="fn_qnaView('${qnaBoard.brdSeq}')" style="cursor: pointer">🔒 ${qnaBoard.brdTitle}</td>
										<td>${qnaBoard.userId}</td>
										<td>${qnaBoard.modDate}</td>
										<td><c:if test="${qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #78B1CD; color: #78B1CD;">답변완료</div>
											</c:if> <c:if test="${!qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
											</c:if></td>
									</tr>

								</c:if>
								<c:if test='${empty qnaBoard.brdPwd}'>
									<tr>
										<td><input type="checkbox" id="qnaCheckbox" name="qnaCheckbox" value="${qnaBoard.brdSeq}"></td>
										<td>${qnaBoard.brdSeq}</td>
										<td onclick="fn_qnaView('${qnaBoard.brdSeq}')" style="cursor: pointer">${qnaBoard.brdTitle}</td>
										<td>${qnaBoard.userId}</td>
										<td>${qnaBoard.modDate}</td>
										<td><c:if test="${qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #78B1CD; color: #78B1CD;">답변완료</div>
											</c:if> <c:if test="${!qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
											</c:if></td>
									</tr>
								</c:if>
							</c:if>
						</c:forEach>
					</tbody>
				</c:if>
				<c:if test='${empty qnaList}'>
					<tbody>
						<tr>
							<td colspan="6">작성된 게시글이 없습니다.</td>
						</tr>
					</tbody>
				</c:if>
			</table>
			<div class="btn-group-container">
				<div class="choose-all">
					<div class="select-all-container">
						<input type="checkbox" id="chkAllQna" class="select-all" />
						<label for="chkAllQna">전체 선택</label>
					</div>
				</div>


				<div>
					<div class="pagination-wrapper">
						<div class="pagination">
							<c:if test="${!empty qnaPaging }">
								<c:if test="${qnaPaging.prevBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_qnaList(${qnaPaging.prevBlockPage})">&laquo;</a>
								</c:if>

								<c:forEach var="i" begin="${qnaPaging.startPage}" end="${qnaPaging.endPage}">
									<c:choose>
										<c:when test="${i eq qnaPaging.curPage}">
											<span class="page-link active">${i }</span>
										</c:when>
										<c:otherwise>
											<span class="page-link" onclick="fn_qnaList(${i})"><a href="#">${i}</a></span>
										</c:otherwise>
									</c:choose>
								</c:forEach>

								<c:if test="${qnaPaging.nextBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_qnaList(${qnaPaging.nextBlockPage})">&raquo;</a>
								</c:if>
							</c:if>
						</div>
					</div>
				</div>

				<div>
					<button type="button" onclick="fn_qnaDelete()" name="qnaDeleteBtn" id="qnaDeleteBtn" class="btn">삭제</button>
				</div>
			</div>
			
			
			<div class="table-section-header">
				<h4>삭제된 문의사항</h4>
				<p style="font-size: 14px; margin-top: 5px; margin-left: 5px;">(${qnaDelTotalCount})</p>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 10%">선택</th>
						<th style="width: 10%">번호</th>
						<th style="width: 40%">제목</th>
						<th style="width: 10%">작성자</th>
						<th style="width: 20%">작성일</th>
						<th style="width: 10%">답변상태</th>
					</tr>
				</thead>
				<c:if test="${!empty qnaDelList}">
					<tbody>
						<c:forEach var="qnaBoard" items="${qnaDelList}" varStatus="status">
							<c:if test="${!empty qnaBoard.delDate and qnaBoard.brdParent eq '0'}">

								<c:if test='${!empty qnaBoard.brdPwd}'>

									<tr>
										<td><input type="checkbox" id="qnaCheckbox" name="qnaCheckbox" value="${qnaBoard.brdSeq}"></td>
										<td>${qnaBoard.brdSeq}</td>
										<td onclick="fn_qnaView('${qnaBoard.brdSeq}')" style="cursor: pointer">🔒 ${qnaBoard.brdTitle}</td>
										<td>${qnaBoard.userId}</td>
										<td>${qnaBoard.modDate}</td>
										<td><c:if test="${qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #78B1CD; color: #78B1CD;">답변완료</div>
											</c:if> <c:if test="${!qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
											</c:if></td>
									</tr>

								</c:if>
								<c:if test='${empty qnaBoard.brdPwd}'>
									<tr>
										<td><input type="checkbox" id="qnaDelCheckbox" name="qnaDelCheckbox" value="${qnaBoard.brdSeq}"></td>
										<td>${qnaBoard.brdSeq}</td>
										<td onclick="fn_qnaView('${qnaBoard.brdSeq}')" style="cursor: pointer">${qnaBoard.brdTitle}</td>
										<td>${qnaBoard.userId}</td>
										<td>${qnaBoard.modDate}</td>
										<td><c:if test="${qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #78B1CD; color: #78B1CD;">답변완료</div>
											</c:if> <c:if test="${!qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
											</c:if></td>
									</tr>
								</c:if>
							</c:if>
						</c:forEach>
					</tbody>
				</c:if>
				<c:if test='${empty qnaDelList}'>
					<tbody>
						<tr>
							<td colspan="6">삭제된 문의 글이 없습니다.</td>
						</tr>
					</tbody>
				</c:if>
			</table>
			<div class="btn-group-container">
				<div class="choose-all">
					<div class="select-all-container">
						<input type="checkbox" id="chkAllDelQna" class="select-all" />
						<label for="chkAllDelQna">전체 선택</label>
					</div>
				</div>


				<div>
					<div class="pagination-wrapper">
						<div class="pagination">
							<c:if test="${!empty qnaDelPaging }">
								<c:if test="${qnaDelPaging.prevBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_qnaDelList(${qnaDelPaging.prevBlockPage})">&laquo;</a>
								</c:if>

								<c:forEach var="i" begin="${qnaDelPaging.startPage}" end="${qnaDelPaging.endPage}">
									<c:choose>
										<c:when test="${i eq qnaDelPaging.curPage}">
											<span class="page-link active">${i }</span>
										</c:when>
										<c:otherwise>
											<span class="page-link" onclick="fn_qnaDelList(${i})"><a href="#">${i}</a></span>
										</c:otherwise>
									</c:choose>
								</c:forEach>

								<c:if test="${qnaDelPaging.nextBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_qnaDelList(${qnaDelPaging.nextBlockPage})">&raquo;</a>
								</c:if>
							</c:if>
						</div>
					</div>
				</div>

				<div>
					<button type="button" onclick="fn_qnaRealDelete()" name="qnaDeleteBtn" id="qnaDeleteBtn" class="btn">삭제</button>
				</div>
			</div>

			<div class="table-section-header">
				<h4>자유게시판</h4>
				<p style="font-size: 14px; margin-top: 5px; margin-left: 5px;">(${freeTotalCount})</p>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 5%">선택</th>
						<th style="width: 5%">번호</th>
						<th style="width: 10%">분류</th>
						<th style="width: 10%">작성자</th>
						<th style="width: 30%">제목</th>
						<th style="width: 20%">등록일</th>
						<th style="width: 10%">조회수</th>
						<th style="width: 10%">공감수</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty freeList}">
						<c:forEach var="board" items="${freeList}" varStatus="status">
							<tr>
								<td><input type="checkbox" id="freeCheckbox" name="freeCheckbox" value="${board.brdSeq}"></td>
								<td>${board.brdSeq}</td>
								<td><c:if test="${board.category eq '1'}">일상/생각</c:if> <c:if test="${board.category eq '2'}">학습고민</c:if> <c:if test="${board.category eq '3'}">입시</c:if> <c:if test="${board.category eq '4'}">진로</c:if></td>
								<td>${board.userId}</td>
								<td onclick="fn_freeView(${board.brdSeq})" style="cursor: pointer;">${board.brdTitle}</td>
								<td>${board.regDate}</td>
								<td>${board.brdReadCnt}</td>
								<td>${board.boardLikeCount}</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test='${empty freeList}'>
						<tbody>
							<tr>
								<td colspan="8">작성된 게시글이 없습니다.</td>
							</tr>
						</tbody>
					</c:if>
				</tbody>
			</table>
			<div class="btn-group-container">
				<div class="choose-all">
					<div class="select-all-container">
						<input type="checkbox" id="chkAllFree" class="select-all" />
						<label for="chkAllFree">전체 선택</label>
					</div>
				</div>

				<div>
					<div class="pagination-wrapper">
						<div class="pagination">
							<c:if test="${!empty freePaging }">
								<c:if test="${freePaging.prevBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_freeList(${freePaging.prevBlockPage})">&laquo;</a>
								</c:if>

								<c:forEach var="i" begin="${freePaging.startPage}" end="${freePaging.endPage}">
									<c:choose>
										<c:when test="${i eq freePaging.curPage}">
											<span class="page-link active">${i }</span>
										</c:when>
										<c:otherwise>
											<span class="page-link" onclick="fn_freeList(${i})"><a href="#">${i}</a></span>
										</c:otherwise>
									</c:choose>
								</c:forEach>

								<c:if test="${freePaging.nextBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_freeList(${freePaging.nextBlockPage})">&raquo;</a>
								</c:if>
							</c:if>
						</div>
					</div>
				</div>

				<div>
					<button type="button" onclick="fn_freeDelete()" name="freeDeleteBtn" id="freeDeleteBtn" class="btn">삭제</button>
				</div>
			</div>
			
			<div class="table-section-header">
				<h4>삭제된 자유게시판</h4>
				<p style="font-size: 14px; margin-top: 5px; margin-left: 5px;">(${freeDelTotalCount})</p>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 5%">선택</th>
						<th style="width: 5%">번호</th>
						<th style="width: 10%">분류</th>
						<th style="width: 10%">작성자</th>
						<th style="width: 30%">제목</th>
						<th style="width: 20%">등록일</th>
						<th style="width: 10%">조회수</th>
						<th style="width: 10%">공감수</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty freeDelList}">
						<c:forEach var="board" items="${freeDelList}" varStatus="status">
							<c:if test="${!empty board.delDate}">
								<tr>
									<td><input type="checkbox" id="freeDelCheckbox" name="freeDelCheckbox" value="${board.brdSeq}"></td>
									<td>${board.brdSeq}</td>
									<td><c:if test="${board.category eq '1'}">일상/생각</c:if> <c:if test="${board.category eq '2'}">학습고민</c:if> <c:if test="${board.category eq '3'}">입시</c:if> <c:if test="${board.category eq '4'}">진로</c:if></td>
									<td>${board.userId}</td>
									<td onclick="fn_freeView(${board.brdSeq})" style="cursor: pointer;">${board.brdTitle}</td>
									<td>${board.regDate}</td>
									<td>${board.brdReadCnt}</td>
									<td>${board.boardLikeCount}</td>
								</tr>
							</c:if>
						</c:forEach>
					</c:if>
					<c:if test='${empty freeDelList}'>
						<tbody>
							<tr>
								<td colspan="8">삭제된 게시글이 없습니다.</td>
							</tr>
						</tbody>
					</c:if>
				</tbody>
			</table>
			<div class="btn-group-container">
				<div class="choose-all">
					<div class="select-all-container">
						<input type="checkbox" id="chkAllDelFree" class="select-all" />
						<label for="chkAllDelFree">전체 선택</label>
					</div>
				</div>

				<div>
					<div class="pagination-wrapper">
						<div class="pagination">
							<c:if test="${!empty freeDelPaging }">
								<c:if test="${freeDelPaging.prevBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_freeDelList(${freeDelPaging.prevBlockPage})">&laquo;</a>
								</c:if>

								<c:forEach var="i" begin="${freeDelPaging.startPage}" end="${freeDelPaging.endPage}">
									<c:choose>
										<c:when test="${i eq freeDelPaging.curPage}">
											<span class="page-link active">${i }</span>
										</c:when>
										<c:otherwise>
											<span class="page-link" onclick="fn_freeDelList(${i})"><a href="#">${i}</a></span>
										</c:otherwise>
									</c:choose>
								</c:forEach>

								<c:if test="${freeDelPaging.nextBlockPage gt 0}">
									<a href="#" class="page-link" onclick="fn_freeDelList(${freeDelPaging.nextBlockPage})">&raquo;</a>
								</c:if>
							</c:if>
						</div>
					</div>
				</div>

				<div>
					<button type="button" onclick="fn_freeRealDelete()" name="freeDeleteBtn" id="freeDeleteBtn" class="btn">삭제</button>
				</div>
			</div>
		</div>
	</div>

	<form name="bbsForm" id="bbsForm" method="POST">

		<input type="hidden" name="brdSeq" value="" />
		
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		
		<input type="hidden" name="noticeCurPage" value="${noticePaging.curPage}">
		<input type="hidden" name="qnaCurPage" value="${qnaPaging.curPage}">
		<input type="hidden" name="freeCurPage" value="${freePaging.curPage}">
		
		<input type="hidden" name="noticeDelCurPage" value="${noticeDelPaging.curPage}">
		<input type="hidden" name="qnaDelCurPage" value="${qnaDelPaging.curPage}">
		<input type="hidden" name="freeDelCurPage" value="${freeDelPaging.curPage}">
		
		<input type="hidden" name="category" value="${category}" />
		<input type="hidden" name="listCount" value="${listCount}" />
		<input type="hidden" name="options" value="${options}" />

	</form>


</body>
</html>
