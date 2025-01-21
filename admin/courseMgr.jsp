<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<link href="/resources/css/admin/courseMgr.css" rel="stylesheet">
<script>
	$(document).ready(function() {
		$("#select-all").click(function() {
    		if($("#select-all").is(":checked")) $("input[name=chk]").prop("checked", true);
    		else $("input[name=chk]").prop("checked", false);
    	});
		
		$("input[name=chk]").click(function(event) {
    		event.stopPropagation();
    	});
		
		//강좌 승인
		$("#updateBtn").click(function(){
    		var selectedValues = [];
    		
            $("input[name='chk']:checked").each(function () {
                selectedValues.push($(this).val());
            });
            
            if (selectedValues.length === 0) {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '승인할 강좌를 선택하세요.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

                return;
            }
            
            Swal.fire({
            	  title: "선택한 강좌를 승인하시겠습니까?",
            	  icon: "warning",
            	  showCancelButton: true,
            	  confirmButtonColor: "#3085d6",
            	  cancelButtonColor: "#d33",
            	  confirmButtonText: "승인",
            	cancelButtonText:"취소"
            	}).then((result) => {
            	  if (result.isConfirmed) {

            	$.ajax({
    				type:"POST",
    				url:"/admin/noCourseOk",
    				contentType: "application/json",
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
   			                Swal.fire({
   			                	position: "center", 
   			                	icon: "success",
   			                	title: '승인이 완료되었습니다.',
   			                	showConfirmButton: false, 
   			                	timer: 1500 
    						}).then(function() {
									document.adminForm.classCode.value = document.getElementById("classCode").value;
    				         		document.adminForm.action = "/admin/courseMgr";
    				         		document.adminForm.submit();
    			             });
    					}
    					else if(response.code == 300)
    					{
    						Swal.fire({
    		            		position: "center", 
    		            		icon: "warning",
    		            		title: '승인 중 서버오류발생', 
    		            		showConfirmButton: false, 
    		            		timer: 1500 
    		            		});

    					}
    					else if(response.code == 500)
    					{
    						Swal.fire({
    		            		position: "center", 
    		            		icon: "warning",
    		            		title: '승인 중 오류발생', 
    		            		showConfirmButton: false, 
    		            		timer: 1500 
    		            		});
    					}
    				},
    				error:function(xhr, status, error)
    				{
    					icia.common.error(error);
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '승인 중 오류가 발생하였습니다.!', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    				}
            	});
    		}
			});
    	});
    	
    	/*강좌 반려*/
    	$("#deleteBtn").click(function(){
    		var selectedValues = [];
    		
            $("input[name='chk']:checked").each(function () {
                selectedValues.push($(this).val());
            });
            
            if (selectedValues.length === 0) {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '반려할 항목을 선택하세요.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

                return;
            }
            
            Swal.fire({
            	  title: "선택한 강좌를 반려하시겠습니까?",
            	  icon: "warning",
            	  showCancelButton: true,
            	  confirmButtonColor: "#3085d6",
            	  cancelButtonColor: "#d33",
            	  confirmButtonText: "반려",
            	cancelButtonText:"취소"
            	}).then((result) => {
            	  if (result.isConfirmed) {

            	$.ajax({
    				type:"POST",
    				url:"/admin/noCourseNo",
    				contentType: "application/json",
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
   			                Swal.fire({
   			                	position: "center", 
   			                	icon: "success",
   			                	title: '반려가 완료되었습니다.',
   			                	showConfirmButton: false, 
   			                	timer: 1500 
    						}).then(function() {
									document.adminForm.classCode.value = document.getElementById("classCode").value;
	 				         		document.adminForm.action = "/admin/courseMgr";
	 				         		document.adminForm.submit();
    			             });
    					}
    					else if(response.code == 300)
    					{
    						Swal.fire({
    		            		position: "center", 
    		            		icon: "warning",
    		            		title: '반려 중 서버오류발생', 
    		            		showConfirmButton: false, 
    		            		timer: 1500 
    		            		});

    					}
    					else if(response.code == 500)
    					{
    						Swal.fire({
    		            		position: "center", 
    		            		icon: "warning",
    		            		title: '반려 중 오류발생', 
    		            		showConfirmButton: false, 
    		            		timer: 1500 
    		            		});

    					}
    				},
    				error:function(xhr, status, error)
    				{
    					icia.common.error(error);
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '반려 중 오류가 발생하였습니다.!', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});
    				}
            	});
    		}
    		});
    	});
	});

	//강좌 삭제
	function courseDelBtn(value) {
		$.ajax({
	          url: "/admin/courseDel",
	          type: "POST",
	          data: {
	        	  courseCode: value
	          },
	          datatype:"JSON",
	          success: function(response) 
	          {
	        	  if(response.code === 0)
        		  {
                      Swal.fire({
                    	  position: "center", 
                    	  icon: "success",
                    	  title: '강좌 삭제가 완료되었습니다.',
                    	  showConfirmButton: false, 
                    	  timer: 1500 
	        		  }).then(function() {
							document.adminForm.classCode.value = document.getElementById("classCode").value;
	                		document.adminForm.action = "/admin/courseMgr";
			         		document.adminForm.submit();
	                   });
        		  }
	        	  if(response.code === 400)
        		  {
	        		  Swal.fire({
	              		position: "center", 
	              		icon: "warning",
	              		title: '서버 오류입니다.', 
	              		showConfirmButton: false, 
	              		timer: 1500 
	              		});

        		  }
	        	  if(response.code === 404)
        		  {
	        		  Swal.fire({
	              		position: "center", 
	              		icon: "warning",
	              		title: '잘못된 접근입니다.', 
	              		showConfirmButton: false, 
	              		timer: 1500 
	              		});

        		  }
	          },
	          error: function(xhr, status, error) 
             {
	        	  Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.", 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

             }
		});
	}
	
	//과목별
	function classCode(value) {
		document.adminForm.classCode.value = value;
		document.adminForm.action = "/admin/courseMgr";
		document.adminForm.submit();
	}
	
	//코스 상세보기
	function showCourseBtn(value) {
		document.adminForm.courseCode.value = value;
		document.adminForm.action = "/course/courseMain";
		document.adminForm.submit();
	}
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/admin/nav.jsp"%>
	<div class="content">
		<div class="table-section">
			<div class="table-section-header">
				<h4>강좌 목록</h4>
			</div>
			<div class="table-scroll-container" style="margin-bottom: 55px;">
				<table>
					<thead>
						<tr>
							<th style="width: 50%;">코스명 <select id="classCode" onchange="classCode(this.value)">
									<option value="">전체</option>
									<option value="1" <c:if test='${classCode eq "1"}'>selected</c:if>>국어</option>
									<option value="2" <c:if test='${classCode eq "2"}'>selected</c:if>>영어</option>
									<option value="3" <c:if test='${classCode eq "3"}'>selected</c:if>>수학</option>
									<option value="4" <c:if test='${classCode eq "4"}'>selected</c:if>>사회</option>
									<option value="5" <c:if test='${classCode eq "5"}'>selected</c:if>>과학</option>
							</select>
							</th>
							<th style="width: 20%;">강사아이디</th>
							<th style="width: 20%;">코스등록일</th>
							<th style="width: 10%;">비고</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${!empty courseList}">
							<c:forEach var="course" items="${courseList}" varStatus="status">
								<tr>
									<td>${course.courseName}</td>
									<td>${course.userId}</td>
									<td>${course.regDate}</td>
									<td><button onclick="courseDelBtn('${course.courseCode}')" class="btn">삭제</button></td>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty courseList}">
							<tr>
								<td colspan="4">강좌가 없습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>

			<div class="table-section-header">
				<h4>강좌 신청</h4>
			</div>
			<div class="table-scroll-container">
				<table>
					<thead>
						<tr>
							<th style="width: 5%;">선택</th>
							<th style="width: 40%;">코스명</th>
							<th style="width: 20%;">강사아이디</th>
							<th style="width: 20%;">코스등록일</th>
							<th style="width: 15%;">비고</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${!empty noCourseList}">
							<c:forEach var="noCourseList" items="${noCourseList}" varStatus="status">
								<tr>
									<td><input type="checkbox" id="chk" name="chk" value="${noCourseList.courseCode}"></td>
									<td>${noCourseList.courseName}</td>
									<td>${noCourseList.userId}</td>
									<td>${noCourseList.regDate}</td>
									<td><button onclick="showCourseBtn('${noCourseList.courseCode}')" class="btn">코스내용 상세보기</button>
								</tr>
							</c:forEach>
						</c:if>
						<c:if test="${empty noCourseList}">
							<tr>
								<td colspan="5">처리할 내역이 없습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<div class="btn-group-container">
				<div>
					<input type="checkbox" id="select-all" class="select-all" />전체 선택
				</div>
				<div>
					<button type="button" id="updateBtn" class="btn" >승인</button>
					<button type="button" id="deleteBtn" class="btn" >반려</button>
				</div>
			</div>
		</div>
	</div>

	<form name="adminForm" id="adminForm" method="POST">
		<input type="hidden" name="classCode" value="${classCode}" />
		<input type="hidden" name="courseCode" value="${courseCode}" />
	</form>
</body>
</html>