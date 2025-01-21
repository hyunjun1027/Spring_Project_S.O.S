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

<link href="/resources/css/mypage/mypageQnaList.css" rel="stylesheet">


<script>

   //선생 or 내 리스트
   function fn_qnalist(type)
   {
      //선생
      if(type == 'teacher')
      {
         document.bbsForm.type.value='teacher';
         document.bbsForm.brdSeq.value = ""; 
         document.bbsForm.curPage.value = "1";
         document.bbsForm.action = "/user/qnaList";
         document.bbsForm.submit();
      }
      else if(type == 'student')
      {
         document.bbsForm.type.value='student';
         document.bbsForm.brdSeq.value = "";
         document.bbsForm.curPage.value = "1";
         document.bbsForm.action = "/user/qnaList";
         document.bbsForm.submit();
      }
   }
   /* 리스트 */
   function fn_listview(curPage) {
      document.bbsForm.type.value = "${type}";
      document.bbsForm.curPage.value = curPage;
      document.bbsForm.brdSeq.value = "";
      document.bbsForm.action = "/user/qnaList";
      document.bbsForm.submit();
   }
   
   $(document).ready(function () {
       // 삭제 버튼 클릭 이벤트
       $("#deleteBtn").on("click", function () {
           var selectedValues = [];
           var deleteUrl = "";
           var type = "${type}";  // 내 Q&A 또는 강사 Q&A에 따라 구분
           
           if (type == 'teacher') {
               deleteUrl = "/user/courseQnADelete"; // 강사 QnA 삭제
               $("input[name='checkbox1']:checked").each(function () {
                   selectedValues.push($(this).val());
               });
           } else if (type == 'student') {
               deleteUrl = "/user/qnaDelete"; // 내 QnA 삭제
               $("input[name='checkbox2']:checked").each(function () {
                   selectedValues.push($(this).val());
               });
           }

           if (selectedValues.length === 0) {
              
                Swal.fire({
                    title: "삭제할 항목을 선택하세요.",
                    icon: "error"
                });
              
               return;
           }

           
          Swal.fire({
               title: "삭제 하시겠습니까?",
               text: "삭제 후 되돌릴 수 없습니다!",
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
                      url: deleteUrl,
                      contentType: "application/json",
                      data: JSON.stringify(selectedValues),
                      dataType: "JSON",
                      success: function (response) {
                          if (response.code == 0) {
                             
                              Swal.fire({
                                  title: "삭제 완료",
                                  icon: "success"
                              }).then(() => {
                                 document.bbsForm.type.value = type;
                                 document.bbsForm.action = "/user/qnaList";
                                 document.bbsForm.submit();
                              });
                             
                          } else {
                              Swal.fire({
                                  title: "오류",
                                  text: "삭제 중 오류 발생: " + response.message,
                                  icon: "success"
                              });
                              
                          }
                      },
                      error: function (xhr, status, error) {
                           Swal.fire({
                               title: "오류",
                               text: "삭제 중 오류 발생하였습니다.",
                               icon: "success"
                           });

                      }
                  });
               }
           });

       });
   });




   
    // 비밀번호 확인
    async function fn_viewPwd(brdSeq, brdPwd) {
        console.log("비밀번호 확인 시작");

        if (brdPwd != null) {
            const { value: userPwd } = await Swal.fire({
                title: "비밀번호를 입력하세요",
                input: "password",
                inputLabel: "비밀번호",
                inputPlaceholder: "비밀번호를 입력하세요",
                inputAttributes: {
                    maxlength: "10",
                    autocapitalize: "off",
                    autocorrect: "off"
                },
                showCancelButton: true, 
                confirmButtonText: '확인',
                cancelButtonText: '취소'
            });

            console.log("입력된 비밀번호:", userPwd);

            if (userPwd) {
                const brdPwdStr = String(brdPwd).trim();
                if (brdPwdStr === userPwd.trim()) {
                    document.bbsForm.brdSeq.value = brdSeq;
                    document.bbsForm.action = "/board/qnaView";
                    document.bbsForm.submit();
                } else {
                    await Swal.fire({
                        title: "비밀번호가 틀렸습니다.",
                        icon: "error",
                        showConfirmButton: true,
                        timer: 3000,
                        timerProgressBar: true 
                    });
                }
            } else {
                Swal.fire("비밀번호 입력을 취소했습니다.");
            }
        } else {
            document.bbsForm.brdSeq.value = "";
            document.bbsForm.action = "/user/qnaList";
            document.bbsForm.submit();
        }
    }
    
    // 글 상세보기
    function fn_view2(brdSeq) {
        document.bbsForm.brdSeq.value = brdSeq;
        document.bbsForm.action = "/board/qnaView";
        document.bbsForm.submit();
    }
    
   // 글 상세보기
   function fn_view1(brdSeq, courseCode, classCode, userId) {
      document.bbsForm.type.value = "";
      document.bbsForm.brdSeq.value = brdSeq;
      document.bbsForm.classCode.value = classCode;
      document.bbsForm.courseCode.value = courseCode;
      document.bbsForm.teacherId.value = userId;
      document.bbsForm.action = "/course/courseQnAView";
      document.bbsForm.submit();
   }
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div board-header">
					<h2 class="first-title">나의 Q&A</h2>

					<%@ include file="/WEB-INF/views/include/mypage/mypageSelectBoxQna.jsp"%>

				</div>

				<div class="board-content" id="teacher-content">
					<c:if test='${type == "teacher"}'>
						<table class="board-table">
							<thead>
								<tr>
									<th style="width: 10%;">선택</th>
									<th style="width: 40%;">제목</th>
									<th style="width: 17%;">작성자</th>
									<th style="width: 18%;">작성일</th>
									<th style="width: 15%;">답변상태</th>
								</tr>
								<c:if test="${!empty list1}">
									<tbody>
										<c:forEach var="qna" items="${list1}" varStatus="status">

											<tr>
												<td><input type="checkbox" id="checkbox1" name="checkbox1" value="${qna.brdSeq}"></td>
												<td onclick="fn_view1('${qna.brdSeq}', ${qna.courseCode}, ${qna.classCode}, '${qna.userId}')" style="cursor: pointer">${qna.brdTitle}</td>
												<td>${user.userId}</td>
												<td>${qna.modDate}</td>
												<td><c:if test="${qna.hasReply}">
														<div class="circle" style="border: 2px solid #ccc; color: #ccc;">답변완료</div>
													</c:if> <c:if test="${!qna.hasReply}">
														<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
													</c:if></td>
											</tr>

										</c:forEach>
									</tbody>

								</c:if>
								<c:if test='${empty list1}'>
									<tbody>
										<tr>
											<td colspan="5">작성된 게시글이 없습니다.</td>
										</tr>
									</tbody>
								</c:if>
							</thead>
						</table>
					</c:if>
				</div>

				<!-- 내 -->
				<div class="board-content" id="student-content">
					<c:if test='${type == "student"}'>
						<table class="board-table">
							<thead>
								<tr>
									<th style="width: 10%;">선택</th>
									<th style="width: 40%;">제목</th>
									<th style="width: 17%;">작성자</th>
									<th style="width: 18%;">작성일</th>
									<th style="width: 15%;">답변상태</th>
								</tr>
								<c:if test="${!empty list2}">
									<tbody>
										<c:forEach var="qnaBoard" items="${list2}" varStatus="status">
											<c:if test="${empty qnaBoard.delDate and qnaBoard.brdParent eq '0'}">
												<c:if test='${!empty qnaBoard.brdPwd}'>
													<tr style="cursor: pointer;">
														<td><input type="checkbox" id="checkbox2" name="checkbox2" value="${qnaBoard.brdSeq}"></td>
														<%--                                              <td  onclick="fn_viewPwd('${qnaBoard.brdSeq}', '${qnaBoard.brdPwd}')">🔒 비밀글입니다</td> --%>
														<td onclick="fn_view2('${qnaBoard.brdSeq}')" style="cursor: pointer">🔒 ${qnaBoard.brdTitle}</td>
														<td>${qnaBoard.userId}</td>
														<td>${qnaBoard.modDate}</td>
														<td><c:if test="${qnaBoard.hasReply}">
																<div class="circle">답변완료</div>
															</c:if> <c:if test="${!qnaBoard.hasReply}">
																<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
															</c:if></td>
													</tr>
												</c:if>
												<c:if test='${empty qnaBoard.brdPwd}'>
													<tr>
														<td><input type="checkbox" id="checkbox2" name="checkbox2" value="${qnaBoard.brdSeq}"></td>
														<td onclick="fn_view2('${qnaBoard.brdSeq}')" style="cursor: pointer">${qnaBoard.brdTitle}</td>
														<td>${qnaBoard.userId}</td>
														<td>${qnaBoard.modDate}</td>
														<td><c:if test="${qnaBoard.hasReply}">
																<div class="circle" style="border: 2px solid #ccc; color: #ccc;">답변완료</div>
															</c:if> <c:if test="${!qnaBoard.hasReply}">
																<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
															</c:if></td>
													</tr>
												</c:if>
											</c:if>
										</c:forEach>
									</tbody>
								</c:if>
								<c:if test='${empty list2}'>
									<tbody>
										<tr>
											<td colspan="5">작성된 게시글이 없습니다.</td>
										</tr>
									</tbody>
								</c:if>
							</thead>
						</table>
					</c:if>
				</div>
				<!--                   </thead>
                  <tbody>
                     <tr>
                        <td><input type="checkbox"></td>
                        <td>질문있습니다1</td>
                        <td>user3</td>
                        <td>2024.11.30</td>
                        <td>미답변</td>
                     </tr>
                  </tbody> -->
			</div>

			<div class="btnContainer">

				<!-- 내 Q&A 삭제 버튼 -->
				<button type="button" name="deleteBtn" id="deleteBtn" class="inputBtn">
					<span>삭제</span>
				</button>

			</div>

			<div class="pagingContainer">
				<ul class="pagination">

					<c:if test="${!empty paging}">
						<c:if test="${paging.prevBlockPage gt 0}">
							<li class="page-item disabled"><a class="page-link" href="#" onclick="fn_listview(${paging.prevBlockPage})">&laquo;</a></li>
						</c:if>

						<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">

							<c:choose>

								<c:when test="${i ne curPage}">
									<li class="page-item"><a class="page-link" href="#" onclick="fn_listview(${i})">${i}</a></li>
								</c:when>

								<c:otherwise>
									<li class="page-item active"><a class="page-link" href="#" style="cursor: default;">${i}</a></li>
								</c:otherwise>

							</c:choose>

						</c:forEach>
						<c:if test="${paging.nextBlockPage gt 0}">
							<li class="page-item"><a class="page-link" href="#" onclick="fn_listview(${paging.nextBlockPage})">&raquo;</a></li>
						</c:if>
					</c:if>
				</ul>
			</div>

			<!--             <div class="pagingContainer">
               <ul class="pagination">
                  <li class="page-item"><a class="page-link" href="#" onclick="fn_listView()"> < </a></li>
                  <li class="page-item"><a class="page-link" href="#" onclick="fn_listView(1)">1</a></li>

                  <li class="page-item active"><a class="page-link" href="#" style="cursor: default;">2</a></li>

                  <li class="page-item"><a class="page-link" href="#" onclick="fn_listView()"> > </a></li>

               </ul>
            </div> -->
		</div>
	</div>

	<form name="bbsForm" id="bbsForm" method="POST">

		<input type="hidden" name="brdSeq" value="${brdSeq}">
		<input type="hidden" name="brdParent" value="${brdParent}">
		<input type="hidden" name="searchType" value="${searchType}">
		<input type="hidden" name="searchValue" value="${searchValue}">
		<input type="hidden" name="curPage" value="${curPage}">
		<input type="hidden" name="type" value="" />
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
		<input type="hidden" name="myBrdChk" id="myBrdChk" value="">

	</form>

</body>
</html>