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
<link href="/resources/css/course/courseList.css" rel="stylesheet">

<style>
.header {
	background: #b5aaf2;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(2)>a").addClass("active");
		
		// 전체 선택
		$("#cbx_chkAll").click(function() {
			if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
			else $("input[name=chk]").prop("checked", false);
		});
		
		//부분 선택
		$("input[name=chk]").click(function() {
			var total = $("input[name=chk]").length;
			var checked = $("input[name=chk]:checked").length;
			
			if(total != checked) $("#cbx_chkAll").prop("checked", false);
			else $("#cbx_chkAll").prop("checked", true); 
		});
		
		// 다운로드 버튼 클릭 시
		$("#download-btn").on("click", function() {
			// 선택된 파일명을 수집
			const selectedFiles = [];
			$("input[name=chk]:checked").each(function() {
				selectedFiles.push($(this).val());
			});

			// 선택된 파일이 없으면 경고
			if (selectedFiles.length == 0) {
                Swal.fire({
                    title: "Error!",
                    text: "다운로드할 파일을 선택하세요.",
                    icon: "error"
                });
				return;
			}


			Swal.fire({
				position: "center",
				icon: "info",
				title: "다운로드를 시작합니다",
				showConfirmButton: false,
				timer: 1000
			});
			
			$.ajax({
			    type: 'POST',
			    url: '/course/downloadSelectedFiles',
			    contentType: 'application/json',
			    data: JSON.stringify(selectedFiles),
			    xhrFields: {
			        responseType: 'blob' // 바이너리 데이터로 응답 받기
			    },
			    success: function(blob) {
					Swal.fire({
						position: "center",
						icon: "success",
						title: "파일 다운로드",
						showConfirmButton: false,
						timer: 1000
					});
			        const url = window.URL.createObjectURL(blob);
			        const a = document.createElement('a');
			        a.href = url;
			        a.download = 'lecture.zip'; // 다운로드 파일명
			        document.body.appendChild(a);
			        a.click();
			        a.remove();
			        window.URL.revokeObjectURL(url); // URL 해제
			    },
			    error: function(xhr, status, error) {
                    Swal.fire({
                        title: "Error!",
                        text: "다운로드 요청 중 오류가 발생했습니다.",
                        icon: "error"
                    });
                    
			        console.error(error);
			    }
			});

		});
		
		
		//삭제버튼
/* 		$("#delete-btn").click(function(){
			
			var selectedValues = [];
			
			$("input[name='chk']:checked").each(function(){
				selectedValues.push($(this).val());
			});
			
			if(selectedValues.length == 0)
			{
				alert("삭제할 항목을 선택하세요.");
				return;
			}
			
			   // 복수 선택 방지
		    if (selectedValues.length > 1) {
		        alert("단일 선택만 가능합니다.");
		        // 복수 선택 해제
		        $("input[name='chk']").prop("checked", false);
		        return;
		    }
			
 
			if(confirm("해당 강의를 삭제하시겠습니까?") == true)
			{
				$.ajax({
					type:"POST",
					url:"/course/lectureDel",
					contentType:"application/json",
					data: JSON.stringify(selectedValues),
					dataType:"JSON",
					beforeSend:function(xhr)
					{
						xhr.setRequestHeader("AJAX", "true");
					},
					success:function(response)
					{
						if(response.code == 0)
						{
							alert("성공적으로 삭제되었습니다.");
							document.teacherTypeForm.action = "/course/courseList";
							document.teacherTypeForm.submit();
						}
					},
					error:function(xhr, status, error)
					{
						icia.common.error(error);
						alert("강의 삭제 중 오류가 발생했습니다.");
					}
				});
			}

		}); */
		
	
});

	/********** 수정 모달 ***********/
	//모달 열기
	function fn_update(lectureName,fileName) {
		
		$("#lectureName1").val(lectureName);
		$("#_fileName2").val(fileName);
		//$("#_fileName").attr("placeholder", fileName);
	    const modal = document.getElementById("relectureModal");
	    modal.style.display = "block";
	    
	}
	
	//모달닫기
	function _closeModal() {
	    const modal = document.getElementById("relectureModal");
	    modal.style.display = "none";

	    //값 초기화
	    $("#lectureName").val("");
	    $("#fileName").val("");
	    
	}

	// Esc 키 입력 방지
	document.addEventListener("keydown", function (event) {
	    if (event.key === "Escape") {
	        event.preventDefault(); // 기본 동작 방지
	    }
	});
	
	// 모달 배경 클릭 방지
	document.getElementById("relectureModal").addEventListener("click", function (event) {
	    if (event.target === this) {
	        // 모달의 배경을 클릭해도 닫히지 않도록 전파 중단
	        event.stopPropagation();
	    }
	});
	
	
	//강의 수정 등록
	function updateLec()
	{
		$("#writeBtn").prop("disabled", true);
		
	    if (event) {
	        event.stopPropagation();
	        event.preventDefault();
	    }
	    
	    if($.trim($("#lectureName1").val()).length <= 0)
	    {
            Swal.fire({
                title: "Error!",
                text: "강의명을 입력하세요.",
                icon: "error"
            });
	    	$("#lectureName1").val("");
	    	$("#lectureName1").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    $("#_fileName").on("change", function() {
	        // 파일 입력값 확인
	        if ($(this).val() === "" || $(this).val() == null) {
	            Swal.fire({
	                title: "Error!",
	                text: "파일을 선택해주세요.",
	                icon: "error"
	            });
	            
	            $("#writeBtn").prop("disabled", true); // 등록 버튼 비활성화
	        } else {
	            $("#writeBtn").prop("disabled", false); // 등록 버튼 활성화
	        }
	    });
	    
	    var form = $("#relectureForm")[0];
		var formData = new FormData(form); 
		

			$.ajax({
				type:"POST",
				enctype:"multipart/form-data",
				url:"/course/lectureUpdate",
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
					if(response.code == 0)
					{
	                    Swal.fire({
	                        title: "등록 완료",
	                        icon: "success"
	                    }).then(() => {
							closeModal();
							document.lectureForm.submit();
							document.lectureForm.acion="/course/courseList";
	                    });

					}
					else if(response.code == 100)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "등록 중 문제 발생.",
		                    icon: "error"
		                });

						$("#writeBtn").prop("disabled", false);
					}
					else if(response.code == -401)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "값을 입력하세요.",
		                    icon: "error"
		                });

						$("#writeBtn").prop("disabled", false);
					}
					else if(response.code == -400)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "권한이 없습니다.",
		                    icon: "error"
		                });

						$("#writeBtn").prop("disabled", false);
					}
					else if(response.code == -101)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "로그인을 먼저 진행하세요.",
		                    icon: "error"
		                });
		                
						$("#writeBtn").prop("disabled", false);
					}
				},
				error:function(error)
				{
					icia.common.error(error);
	                Swal.fire({
	                    title: "Error",
	                    text: "오류 발생.",
	                    icon: "error"
	                });
					$("#writeBtn").prop("disabled", false);
				}
				
			});
	}
	

	// 강사 페이지 메뉴 이동
	function fn_pageMove(url) {
		document.teacherTypeForm.teacherId.value = "${teacher.userId }";
		document.teacherTypeForm.classCode.value = ${classCode};
		document.teacherTypeForm.courseCode.value = ${course.courseCode};
		document.teacherTypeForm.action = "/course/" + url;
		document.teacherTypeForm.submit();
	}
	
	// 비디오 플레이어 새창 열기
	function openVideoPlayer(fileName) {
	    const videoFile = encodeURIComponent(fileName); // 파일명을 안전하게 인코딩
	    const url = '/course/lecturePlay?fileName=' + videoFile;

	    // 새 창의 크기 설정
	    const _width = 1200;
	    const _height = 800;
	    const _left = (screen.width - _width) / 2;
	    const _top = (screen.height - _height) / 2;
	
	    // 새 창 열기
	    var popVideo = window.open(url, 'VideoPlayer', 'width=' + _width + ', height=' + _height + ', left=' + _left + ', top=' + _top);

	    // 새 창 닫히는지 감시
	    var timer = setInterval(() => {
			if(popVideo.closed) {
				// 새 창이 닫히면 새로고침
				clearInterval(timer);
				location.reload();
			} else {
				// code
			}
		}, 1000);
	}
	
	/********** 등록 모달 ***********/
	//모달 열기
	function fn_registerLecture() {
	    const modal = document.getElementById("lectureModal");
	    modal.style.display = "block";

	}
	
	//모달닫기
	function closeModal() {
	    const modal = document.getElementById("lectureModal");
	    modal.style.display = "none";

	    //값 초기화
	    $("#lectureName").val("");
	    $("#fileName").val("");
	    
	}

	// Esc 키 입력 방지
	document.addEventListener("keydown", function (event) {
	    if (event.key === "Escape") {
	        event.preventDefault(); // 기본 동작 방지
	    }
	});
	
	// 모달 배경 클릭 방지
	document.getElementById("lectureModal").addEventListener("click", function (event) {
	    if (event.target === this) {
	        // 모달의 배경을 클릭해도 닫히지 않도록 전파 중단
	        event.stopPropagation();
	    }
	});
	
	//강의 등록 버튼 클릭시
	function submitLecture()
	{
		$("#writeBtn").prop("disabled", true);
		
	    if (event) {
	        event.stopPropagation();
	        event.preventDefault();
	    }
	    
	    if($.trim($("#lectureName").val()).length <= 0)
	    {
            Swal.fire({
                title: "Error",
                text: "강의명을 입력하세요.",
                icon: "error"
            });

	    	$("#lectureName").val("");
	    	$("#lectureName").focus();
	    	$("#writeBtn").prop("disabled", false);
	    	
	    	return;
	    }
	    
	    $("#fileName").on("change", function() {
	        // 파일 입력값 확인
	        if ($(this).val() === "" || $(this).val() == null) {
	            Swal.fire({
	                title: "Error",
	                text: "파일을 선택해주세요.",
	                icon: "error"
	            });

	            $("#writeBtn").prop("disabled", true); // 등록 버튼 비활성화
	        } else {
	            $("#writeBtn").prop("disabled", false); // 등록 버튼 활성화
	        }
	    });
	    
	    var form = $("#lectureForm")[0];
		var formData = new FormData(form); 
		

			$.ajax({
				type:"POST",
				enctype:"multipart/form-data",
				url:"/course/lectureInsert",
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
					if(response.code == 0)
					{
	                    Swal.fire({
	                        title: "등록 완료",
	                        icon: "success"
	                    }).then(() => {
							closeModal();
							document.lectureForm.submit();
							document.lectureForm.acion="/course/courseList";
	                    });

					}
					else if(response.code == 100)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "등록 중 문제 발생.",
		                    icon: "error"
		                });

						$("#writeBtn").prop("disabled", false);
					}
					else if(response.code == -401)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "등록 파일을 선택해주세요.",
		                    icon: "error"
		                });
		                
						$("#writeBtn").prop("disabled", false);
					}
					else if(response.code == -400)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "권한 없음",
		                    icon: "error"
		                });

						$("#writeBtn").prop("disabled", false);
					}
					else if(response.code == -101)
					{
		                Swal.fire({
		                    title: "Error",
		                    text: "로그인 먼저 진행",
		                    icon: "error"
		                });
		                
						$("#writeBtn").prop("disabled", false);
					}
				},
				error:function(error)
				{
					icia.common.error(error);
	                Swal.fire({
	                    title: "Error",
	                    text: "오류 발생",
	                    icon: "error"
	                });
	                
					$("#writeBtn").prop("disabled", false);
				}
				
			});
	}
	
	
	
	
	
	
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
	<%@ include file="/WEB-INF/views/include/course/courseMainInfo.jsp"%>

	<div class="course-page">
		<ul class="tab-menu">
			<li onclick="fn_pageMove('courseMain')">강좌소개</li>
			<li class="active" onclick="fn_pageMove('courseList')">강의목록</li>
			<li onclick="fn_pageMove('courseNotice')">공지사항</li>
			<li onclick="fn_pageMove('courseQnA')">학습Q&A</li>
			<li onclick="fn_pageMove('courseReview')">수강후기</li>
		</ul>

		<div class="content">
			<div class="lecture-list-container">
				<!-- 전체선택, 다운로드 버튼 -->
								
				<div class="list-actions">
				    <div class="left-actions">

					        <label><input type="checkbox" id="cbx_chkAll" /> 전체선택</label>
					        <button id="download-btn" class="download-action">다운로드</button>


				    </div>
				    <c:if test="${cookieUserId == teacher.userId}">
				    	<button id="register-btn" class="register-action" onclick="fn_registerLecture()">강의등록</button>
					</c:if>
				</div>

				<!-- 강의 리스트 -->
				<c:if test="${!empty list }">
					<c:forEach var="lectureList" items="${list}" varStatus="status">
						<div class="lecture-item">
							<div class="lecture-checkbox">
								<input type="checkbox" id="chk" name="chk" value="${lectureList.fileName}"  />
							</div>

							<div class="lecture-info-list">
								<p class="lecture-list-title">${lectureList.lectureName }</p>
								<span class="lecture-meta">강의 탑재일 ${lectureList.regDate } 강의시간 12:24</span>
							</div>

							<div class="lecture-status">
								<button class="streaming-btn">스트리밍</button>
								<button class="download-btn">다운로드</button>
							</div>

						<c:if test="${cookieUserId == teacher.userId}">
							<button id="rewrite-btn" class="download-action" onclick="fn_update('${lectureList.lectureName}','${lectureList.fileName }')">수정</button>
						</c:if>

						<c:if test="${cookieUserId != teacher.userId}">
							<div class="lecture-progress">${lectureList.progress }%</div>
						</c:if>							
							
							
							<div class="lecture-date">${lectureList.playDate}</div>
							<div class="lecture-play">
							    <button class="play-btn" onclick="openVideoPlayer('${lectureList.fileName}')">▶</button>
							</div>
						</div>
					</c:forEach>
				</c:if>
			</div>
		</div>
	</div>

	<!-- 삭제 모달창 -->
		<form name="lectureForm" id="lectureForm" method="post" enctype="multipart/form-data">
			<div id="lectureModal" class="modal">
				  <div class="modal-content">
				    <span class="close" onclick="closeModal()">&times;</span>
				    <h2 class="modal-title">강의등록</h2>
				    <div class="modal-section">
				      <label class="modal-label">강의명</label>
				      <input type="text" id="lectureName" name="lectureName" class="modal-input" placeholder="강의 순서 (두자릿수+강) + 강의명" />
				    </div>
				    <div class="modal-section">
				      <label class="modal-label">강의파일</label>
				      <div class="input-with-search">
			      	    <input type="file" id="fileName" name="fileName" class="modal-input" placeholder="파일을 검색해주세요" required />
					    <button class="search-btn" id="fileBtn" name="fileBtn" onclick="">🔍</button>
				      </div>
				    </div>
				   
				    <div class="modal-buttons">
				      <button class="modal-btn add-btn" id="writeBtn" onclick="submitLecture()">등록</button>
				      <button class="modal-btn cancel-btn" id="cancelBtn" onclick="closeModal()">취소</button>
				    </div>
				  </div>
	
					<input type="hidden" name="classCode" value="${classCode}">
					<input type="hidden" name="courseCode" value="${courseCode}">
					<input type="hidden" name="teacherId" value="${teacher.userId}">
					<input type="hidden" name="curPage" value="">
			</div>
		</form>	
		
	<!-- 수정 모달창 -->
		<form name="relectureForm" id="relectureForm" method="post" enctype="multipart/form-data">
			<div id="relectureModal" class="modal">
				  <div class="modal-content">
				    <span class="close" onclick="_closeModal()">&times;</span>
				    <h2 class="modal-title">강의수정</h2>
				    <div class="modal-section">
				      <label class="modal-label">강의명</label>
				      <input type="text" id="lectureName1" name="lectureName1" class="modal-input" value=""	placeholder="강의 순서 (두자릿수+강) + 강의명" />
				    </div>
				    <div class="modal-section">
				      <label class="modal-label">강의파일</label>
				      <div class="input-with-search">
			      	    <input type="file" id="_fileName" name="_fileName" class="modal-input" placeholder="파일을 검색해주세요" required />
					    <input type="hidden" id="_fileName2" name="_fileName2" value="">
					    <button class="search-btn" id="fileBtn" name="fileBtn" onclick="">🔍</button>
				      </div>
				    </div>
				   
				    <div class="modal-buttons">
				      <button class="modal-btn add-btn" id="writeBtn" onclick="updateLec()">수정</button>
				      <button class="modal-btn cancel-btn" id="cancelBtn" onclick="_closeModal()">취소</button>
				    </div>
				  </div>
	
					<input type="hidden" name="classCode" value="${classCode}">
					<input type="hidden" name="courseCode" value="${courseCode}">
					<input type="hidden" name="teacherId" value="${teacher.userId}">
					<input type="hidden" name="curPage" value="">
			</div>
		</form>
		
		</div>

	</section>
	
	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="${classCode}">
		<input type="hidden" name="courseCode" value="${courseCode}">
		<input type="hidden" name="teacherId" value="${teacher.userId}">
		<input type="hidden" name="curPage" value="">
		<input type="hidden" name="fileName" value="">
	</form>
</body>

</html>


