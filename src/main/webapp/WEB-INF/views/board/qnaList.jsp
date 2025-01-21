<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/qnaList.css" rel="stylesheet">
<style>
.header {
	background-color: #539ED8;
}
</style>

<!-- SweetAlert2 CSS and JS -->
<link href="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.4/dist/sweetalert2.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.5.4/dist/sweetalert2.all.min.js"></script>

<script>
    $(function() {
        $("#navmenu>ul>li:nth-child(3)>a").addClass("active");
    });

    // 검색 버튼 이벤트
    $(document).ready(function() {
        // 페이지 로드 시 저장된 값 복원
        if (localStorage.getItem("searchType")) {
            $("#_searchType").val(localStorage.getItem("searchType"));
        }
        if (localStorage.getItem("searchValue")) {
            $("#_searchValue").val(localStorage.getItem("searchValue"));
        }

        // 검색 버튼 이벤트
        $("#btnSearch").on("click", function () {
            // 검색 필드 값을 저장
            localStorage.setItem("searchType", $("#_searchType").val());
            localStorage.setItem("searchValue", $("#_searchValue").val());

            // 폼 처리
            document.bbsForm.brdSeq.value = "";
            document.bbsForm.searchType.value = $("#_searchType").val();
            document.bbsForm.searchValue.value = $("#_searchValue").val();
            document.bbsForm.curPage.value = "1";
            document.bbsForm.action = "/board/qnaList";
            document.bbsForm.submit();
        });
    });

    // 비밀번호 확인
    async function fn_viewPwd(brdSeq, brdPwd) {
        console.log("비밀번호 확인 시작");
        
        // 사용자 등급 확인
        if ("${admin.rating}" === "A") {
            document.bbsForm.brdSeq.value = brdSeq;
            document.bbsForm.action = "/board/qnaView";
            document.bbsForm.submit();
            return; // 등급이 U인 경우 비밀번호 입력 생략
        }

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
            document.bbsForm.action = "/board/qnaWrite";
            document.bbsForm.submit();
        }
    }

    // 글 상세보기
    function fn_view(brdSeq) {
        document.bbsForm.brdSeq.value = brdSeq;
        document.bbsForm.action = "/board/qnaView";
        document.bbsForm.submit();
    }

    // 글 작성
    function fn_write() {
       
      <c:choose>
         <c:when test="${empty user.userId}">
            Swal.fire({
               position: "center", 
               icon: "warning",
               title: "로그인 후 이용해 주세요.",
               showConfirmButton: false, 
               timer: 1500 
               }).then(function() {
                  location.href = "/board/qnaList";
               });

         </c:when>
         <c:otherwise>
           document.bbsForm.brdSeq.value = "";
           document.bbsForm.action = "/board/qnaWrite";
           document.bbsForm.submit();
         </c:otherwise>
      </c:choose>

    }
    
   /* 리스트 */
   function fn_listview(curPage) {
      document.bbsForm.curPage.value = curPage;
      document.bbsForm.brdSeq.value = "";
      document.bbsForm.action = "/board/qnaList";
      document.bbsForm.submit();
   }
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">Q & A</h1>
				<p class="mainContent">문의사항</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/faqboard.png" alt="Clover Image">
			</div>
		</div>
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
			<h2 class="subTitle">문의사항</h2>
			<table>
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>답변상태</th>
					</tr>
				</thead>

				<c:if test="${!empty list}">
					<c:set var="brdSeq" value="${paging.startNum + 1}" />
					<tbody>
						<c:forEach var="qnaBoard" items="${list}" varStatus="status">
							<c:set var="brdSeq" value="${brdSeq - 1}" />
							<c:if test="${empty qnaBoard.delDate and qnaBoard.brdParent eq '0'}">
								<c:if test='${!empty qnaBoard.brdPwd and admin.rating eq "A"}'>
									<tr style="cursor: pointer;" onclick="fn_viewPwd('${qnaBoard.brdSeq}', '${qnaBoard.brdPwd}')">
										<td>${brdSeq}</td>
										<td>🔒 ${qnaBoard.brdTitle}</td>
										<td>${qnaBoard.userName}<br>( <c:choose>
												<c:when test="${fn:length(qnaBoard.userId) gt 10}">
													<c:out value="${fn:substring(qnaBoard.userId, 0, 9)}...">
													</c:out>
												</c:when>
												<c:otherwise>
													<c:out value="${qnaBoard.userId}">
													</c:out>
												</c:otherwise>
											</c:choose> )
										</td>
										<td>${qnaBoard.modDate}</td>
										<td><c:if test="${qnaBoard.hasReply}">
												<div class="circle">답변완료</div>
											</c:if> <c:if test="${!qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
											</c:if></td>
									</tr>
								</c:if>
								<c:if test='${!empty qnaBoard.brdPwd and admin.rating ne "A"}'>
									<tr style="cursor: pointer;" onclick="fn_viewPwd('${qnaBoard.brdSeq}', '${qnaBoard.brdPwd}')">
										<td>${brdSeq}</td>
										<td>🔒 비밀글입니다</td>
										<td>${qnaBoard.userName}<br>( <c:choose>
												<c:when test="${fn:length(qnaBoard.userId) gt 10}">
													<c:out value="${fn:substring(qnaBoard.userId, 0, 9)}...">
													</c:out>
												</c:when>
												<c:otherwise>
													<c:out value="${qnaBoard.userId}">
													</c:out>
												</c:otherwise>
											</c:choose> )
										</td>
										<td>${qnaBoard.modDate}</td>
										<td><c:if test="${qnaBoard.hasReply}">
												<div class="circle">답변완료</div>
											</c:if> <c:if test="${!qnaBoard.hasReply}">
												<div class="circle" style="border: 2px solid #ccc; color: #ccc;">미답변</div>
											</c:if></td>
									</tr>
								</c:if>
								<c:if test='${empty qnaBoard.brdPwd}'>
									<tr onclick="fn_view('${qnaBoard.brdSeq}')" style="cursor: pointer">
										<td>${brdSeq}</td>
										<td>${qnaBoard.brdTitle}</td>
										<td>${qnaBoard.userName}<br>( <c:choose>
												<c:when test="${fn:length(qnaBoard.userId) gt 10}">
													<c:out value="${fn:substring(qnaBoard.userId, 0, 9)}...">
													</c:out>
												</c:when>
												<c:otherwise>
													<c:out value="${qnaBoard.userId}">
													</c:out>
												</c:otherwise>
											</c:choose> )
										</td>
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
				<c:if test='${empty list}'>
					<tbody>
						<tr>
							<td colspan="5">작성된 게시글이 없습니다.</td>
						</tr>
					</tbody>
				</c:if>
			</table>

			<c:if test="${user.rating eq 'U'}">
				<div class="freeWrite-container">
					<button class="free-write-button" onclick="fn_write()">글쓰기</button>
				</div>
			</c:if>




			<div class="pagination">
				<c:if test="${!empty paging}">

					<c:if test="${paging.prevBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_listview(${paging.prevBlockPage})">&laquo;</button>
					</c:if>


					<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
						<c:choose>
							<c:when test="${i eq curPage}">
								<span class="pagination-number active">${i}</span>
							</c:when>
							<c:otherwise>
								<span class="pagination-number"><a class="page-link" href="#" onclick="fn_listview(${i})">${i}</a></span>
							</c:otherwise>
						</c:choose>
						<c:if test="${i lt paging.endPage}">
							<span class="pagination-separator">|</span>
						</c:if>
					</c:forEach>


					<c:if test="${paging.nextBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_listview(${paging.nextBlockPage})">&raquo;</button>
					</c:if>

				</c:if>
			</div>




			<div class="search-container">
				<select class="form-select" name="_searchType" id="_searchType">
					<option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
					<option value="2" <c:if test='${searchType eq "2"}'>selected</c:if>>내용</option>
					<option value="3" <c:if test='${searchType eq "3"}'>selected</c:if>>작성자</option>
					<option value="author"></option>
				</select>
				<div class="input-select">
					<input type="text" name="_searchValue" id="_searchValue" class="form-control" placeholder="검색할 단어를 입력하세요." aria-label="검색어">
					<button type="button" id="btnSearch" style="cursor: pointer">
						<img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;">
					</button>
				</div>
			</div>
		</div>
	</section>

	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form name="bbsForm" id="bbsForm" method="POST">

		<input type="hidden" name="brdSeq" value="">
		<input type="hidden" name="searchType" value="${searchType}">
		<input type="hidden" name="searchValue" value="${searchValue}">
		<input type="hidden" name="curPage" value="${curPage}">

	</form>
</body>
</html>
