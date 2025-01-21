<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<link href="/resources/css/admin/userMgr.css" rel="stylesheet">
<script>
    $(document).ready(function() {
    	var idCheckOk = false;
    	// 공백 체크
   		var emptCheck = /\s/g;
   		// 아이디 정규표현식(영문 대소문자, 숫자로만 이루어진 5~20자)
   		var idCheck = /^[a-zA-Z0-9]{5,20}$/;
    		
    	$("#select-all").click(function() {
    		if($("#select-all").is(":checked")) $("input[name=chk]").prop("checked", true);
    		else $("input[name=chk]").prop("checked", false);
    	});
    	
    	$("input[name=chk]").click(function(event) {
    		event.stopPropagation();
    	});
    	
    	//관리자 아이디 조회
    	$('#adminIdCheck').on('click', function() {
    		
    		fn_displayNone();
    		
    		if ($.trim($("#adminId").val()).length <= 0) {
    			$("#adminIdMsg").text("사용하실 아이디를 입력하세요.");
    			$("#adminIdMsg").css("display", "inline");
    			$("#adminIdMsg").css("color", "red");
    			$("#adminId").val("");
    			$("#adminId").focus();
    		}
    		
    		if (emptCheck.test($("#adminId").val())) {
    			$("#adminIdMsg").text("사용하실 아이디는 공백을 포함할 수 없습니다.");
    			$("#adminIdMsg").css("display", "inline");
    			$("#adminIdMsg").css("color", "red");
    			$("#adminId").val("");
    			$("#adminId").focus();
    			return;
    		}
    		
    		if (!idCheck.test($("#adminId").val())) {
    			$("#adminIdMsg").text("사용하실 아이디는 5~20자의 영문 대소문자와 숫자로만 입력 가능합니다.");
    			$("#adminIdMsg").css("display", "inline");
    			$("#adminIdMsg").css("color", "red");
    			$("#adminId").focus();
    			return;
    		}
    		
    		$.ajax({
    			type:"POST",
    			url:"/admin/adminSelect",
    			data:{
    				userId:$("#adminId").val()
    			},
    			datatype:"JSON",
    			beforeSend:function(xhr){
    				xhr.setRequestHeader("AJAX", "true");
    			},
    			success:function(response){
    				if(response.code == 0)
    				{
    					fn_displayNone();
    					idCheckOk = true;
    					
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "success",
    	            		title: '사용가능한 아이디입니다.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    				}
    				else if(response.code == 400)
    				{
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '중복 아이디입니다.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    	                return;
    				}
    				else if(response.code == 500)
    				{
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '서버 오류입니다.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    	                return;
    				}
    			},
    			error:function(xhr, status, error){
    				icia.common.error(error);
    			}
    		});
    	});
    	
    	//관리자 추가
    	$('#adminplus').on('click', function() { 
    		
    		if(idCheckOk == false) {
    			Swal.fire({
    				position: "center", 
    				icon: "warning",
    				title: '아이디 중복체크 후 이용가능합니다.',
    				showConfirmButton: false, 
    				timer: 1500 
    				}).then(function() {
    					fn_displayNone();
    				});

    		}
    		
    		if ($.trim($("#adminPwd").val()).length <= 0) {
    			$("#adminPwdMsg").text("사용하실 비밀번호를 입력하세요.");
    			$("#adminPwdMsg").css("display", "inline");
    			$("#adminPwdMsg").css("color", "red");
    			$("#adminPwd").val("");
    			$("#adminPwd").focus();
    		}
    		
    		if (emptCheck.test($("#adminPwd").val())) {
    			$("#adminPwdMsg").text("사용하실 비밀번호는 공백을 포함할 수 없습니다.");
    			$("#adminPwdMsg").css("display", "inline");
    			$("#adminPwdMsg").css("color", "red");
    			$("#adminPwd").val("");
    			$("#adminPwd").focus();
    			return;
    		}
    		
    		$.ajax({
    			type:"POST",
    			url:"/admin/adminInsert",
    			data:{
    				userId: $("#adminId").val(),
    				userPwd: $("#adminPwd").val()
    			},
    			datatype:"JSON",
    			beforeSend:function(xhr){
    				xhr.setRequestHeader("AJAX", "true");
    			},
    			success:function(response){
    				if(response.code == 0)
    				{
    					Swal.fire({
    						position: "center", 
    						icon: "success",
    						title: '관리자가 추가되었습니다.',
    						showConfirmButton: false, 
    						timer: 1500 
    						}).then(function() {
    							$('#myModal').hide();
    						});

    				}
    				if(response.code == 300)
    				{
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '등록중 오류가 발생했습니다.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    	            	
    	                return;
    				}
    				if(response.code == 400)
    				{
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '중복된 아이디입니다.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    	            	
    	                return;	
    				}
    				if(response.code == 500)
    				{
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '서버 오류입니다.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

		            	
		                return;
    				}
    				if(response.code == 404)
    				{
    					Swal.fire({
    	            		position: "center", 
    	            		icon: "warning",
    	            		title: '정확한 값을 입력해주세요.', 
    	            		showConfirmButton: false, 
    	            		timer: 1500 
    	            		});

    	                return;
    				}
    			},
    			error:function(xhr, status, error){
    				icia.common.error(error);
    			}
    		});
    	});
    	
    	/*강사가입 승인*/
    	$("#updateBtn").click(function(){
    		var selectedValues = [];
    		
            $("input[name='chk']:checked").each(function () {
                selectedValues.push($(this).val());
            });
            
            if (selectedValues.length === 0) {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '승인할 항목을 선택하세요.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

                return;
            }
            
            Swal.fire({
            	  title: "선택한 유저를 승인하시겠습니까?",
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
    				url:"/admin/noTeacherOk",
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
    			            	 document.adminForm.rating.value = document.getElementById("rating").value;
    			         		document.adminForm.status.value = document.getElementById("status").value;
    			         		document.adminForm.classCode.value = document.getElementById("classCode").value;
    			         		document.adminForm.action = "/admin/userMgr";
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
    	
    	/*강사가입 반려*/
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
            	  title: "선택한 유저를 반려하시겠습니까?",
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
    				url:"/admin/noTeacherNo",
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
    			            	 document.adminForm.rating.value = document.getElementById("rating").value;
    			         		document.adminForm.status.value = document.getElementById("status").value;
    			         		document.adminForm.classCode.value = document.getElementById("classCode").value;
    			         		document.adminForm.action = "/admin/userMgr";
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
    
	//분류
	function rating(value) {
		document.adminForm.rating.value = value;
		document.adminForm.status.value = document.getElementById("status").value;
		document.adminForm.action = "/admin/userMgr";
		document.adminForm.submit();
	}
	
	//상태
	function status(value) {
		document.adminForm.rating.value = document.getElementById("rating").value;
		document.adminForm.status.value = value;
		document.adminForm.action = "/admin/userMgr";
		document.adminForm.submit();
	}
	
	//상태 변경
	function updateStatus(userId, rating) {
		userStatus = document.getElementById("updateStatus").value; 
		$.ajax({
          url: "/admin/userChange",
          type: "POST",
          data: {
              userId: userId,
         	 rating: rating,
         	 status: userStatus
          },
          datatype:"JSON",
          success: function(response) 
          {
         	 if(response.code === 0)
             {
         		Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '상태 수정이 완료되었습니다.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

             }
         	 else if (response.code === 500) 
             {
         		Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '수정중 오류가 발생했습니다.', 
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
	
	//상태
	function classCode(value) {
		document.adminForm.rating.value = document.getElementById("rating").value;
		document.adminForm.status.value = document.getElementById("status").value;
		document.adminForm.classCode.value = value;
		document.adminForm.action = "/admin/userMgr";
		document.adminForm.submit();
	}
	
	//알림메세지 초기화
	function fn_displayNone() {
		$("#adminIdMsg").css("display", "none");
		$("#adminPwdMsg").css("display", "none");
	}
	
	//모달 비밀번호 눈
	function togglePasswordVisibility(inputId, icon) {
        var input = document.getElementById(inputId);
        var iconImage = icon.querySelector("img");
        
        if (input.type === "password") {
            input.type = "text";
            iconImage.src = "/resources/img/eye-open-icon.png";
        } else {
            input.type = "password";
            iconImage.src = "/resources/img/eye-icon.png";
        }
    }
	
	$(document).ready(function () {
        $("#addAdminBtn").click(function () {
            $("#myModal").show();
        });

        $(".close").click(function () {
        	$('#adminId').val('');
            $('#adminPwd').val('');
            $('#adminIdMsg').text('');
            $('#adminPwdMsg').text('');
            idCheckOk = false;
            $('#adminPwd').attr('type', 'password');
            $('.eye_icon').attr('src', '/resources/img/eye-icon.png');
            $("#myModal").hide();
        });

        $(window).click(function (event) {
        	if ($(event.target).is('#myModal')) {
                $('#adminId').val('');
                $('#adminPwd').val('');
                $('#adminIdMsg').text('');
                $('#adminPwdMsg').text('');
                idCheckOk = false;
                $('#adminPwd').attr('type', 'password');
                $('.eye_icon').attr('src', '/resources/img/eye-icon.png'); 
                $('#myModal').hide();
            }
        });
    });
    </script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/admin/nav.jsp"%>
	<div class="content">
		<div class="table-section">
			<div class="table-section-header">
				<h4>유저정보</h4>
			</div>
			<div class="table-scroll-container">
				<table>
					<thead>
						<tr>
							<th style="width: 37%;">아이디</th>
							<th style="width: 20%;">이메일</th>
							<th style="width: 10%;">이름</th>
							<th style="width: 10%;">분류 <select id="rating" onchange="rating(this.value)">
									<option value="">전체</option>
									<option value="T" <c:if test='${rating eq "T"}'>selected</c:if>>강사</option>
									<option value="U" <c:if test='${rating eq "U"}'>selected</c:if>>학생</option>
							</select>
							</th>
							<th style="width: 10%;">상태 <select id="status" onchange="status(this.value)">
									<option value="">전체</option>
									<option value="Y" <c:if test='${status eq "Y"}'>selected</c:if>>정상</option>
									<option value="N" <c:if test='${status eq "N"}'>selected</c:if>>정지</option>
							</select>
							</th>
							<th style="width: 13%;">가입일시</th>

						</tr>
					</thead>
					<tbody>
						<c:if test="${!empty list}">
							<c:forEach var="user" items="${list}" varStatus="status">
								<c:if test='${user.status ne "W"}'>
									<tr>
										<td>${user.userId}</td>
										<td>${user.userEmail}</td>
										<td>${user.userName}</td>
										<c:if test='${user.rating eq "T"}'>
											<td>강사</td>
										</c:if>
										<c:if test='${user.rating eq "U"}'>
											<td>학생</td>
										</c:if>
	
										<td><select id="updateStatus" onchange="updateStatus('${user.userId}', '${user.rating}')">
												<c:if test='${user.status eq "Y"}'>
													<option value="Y">정상</option>
													<option value="N">정지</option>
												</c:if>
												<c:if test='${user.status eq "N"}'>
													<option value="N">정지</option>
													<option value="Y">정상</option>
												</c:if>
										</select></td>
										<td>${user.regDate}</td>
									</tr>
								</c:if>
							</c:forEach>
						</c:if>
						<c:if test="${empty list}">
							<tr>
								<td colspan="7">내역이 없습니다.</td>
							</tr>
						</c:if>
					</tbody>
				</table>
			</div>
			<div class="btn-group-container">
				<button id="addAdminBtn" class="btn">관리자추가</button>
			</div>

			<div class="table-section-header">
				<h4>강사 회원가입</h4>
			</div>
			<table>
				<thead>
					<tr>
						<th style="width: 10%;">선택</th>
						<th style="width: 10%;">이름</th>
						<th style="width: 10%;">과목 <select id="classCode" onchange="classCode(this.value)">
								<option value="">전체</option>
								<option value="1" <c:if test='${classCode eq "1"}'>selected</c:if>>국어</option>
								<option value="2" <c:if test='${classCode eq "2"}'>selected</c:if>>영어</option>
								<option value="3" <c:if test='${classCode eq "3"}'>selected</c:if>>수학</option>
								<option value="4" <c:if test='${classCode eq "4"}'>selected</c:if>>사회</option>
								<option value="5" <c:if test='${classCode eq "5"}'>selected</c:if>>과학</option>
						</select>
						</th>
						<th style="width: 10%;">아이디</th>
						<th style="width: 20%;">이메일</th>
						<th style="width: 20%;">전화번호</th>
						<th style="width: 20%;">신청일</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty noTeacherList}">
						<c:forEach var="teacher" items="${noTeacherList}" varStatus="status">
							<tr>
								<td><input type="checkbox" id="chk" name="chk" value="${teacher.userId}"></td>
								<td>${teacher.userName}</td>
								<c:if test='${teacher.classCode eq "1"}'>
									<td>국어</td>
								</c:if>
								<c:if test='${teacher.classCode eq "2"}'>
									<td>영어</td>
								</c:if>
								<c:if test='${teacher.classCode eq "3"}'>
									<td>수학</td>
								</c:if>
								<c:if test='${teacher.classCode eq "4"}'>
									<td>사회</td>
								</c:if>
								<c:if test='${teacher.classCode eq "5"}'>
									<td>과학</td>
								</c:if>
								<td>${teacher.userId}</td>
								<td>${teacher.userEmail}</td>
								<td>${teacher.userPhone}</td>
								<td>${teacher.regDate}</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty noTeacherList}">
						<tr>
							<td colspan="6">처리할 내역이 없습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>
			<div class="btn-group-container">
				<div>
					<input type="checkbox" id="select-all" class="select-all" />
					전체선택
				</div>
				<div>
					<button type="button" id="updateBtn" class="btn">승인</button>
					<button type="button" id="deleteBtn" class="btn">반려</button>
				</div>
			</div>
		</div>
	</div>

	<div id="myModal" class="modal">
		<div class="modal-content">
			<span class="close">&times;</span>
			<h4 class="head">관리자 추가</h4>
			<div>
				<label for="adminId" class="textBody">아이디:</label>
				<input type="text" id="adminId" name="adminId" class="inputBody">
				<button type="button" class="modal-button" id="adminIdCheck">중복체크</button>
			</div>
			<div class="msg_box">
				<span class="info_msg" id="adminIdMsg"></span>
			</div>
			<div class="input-container">
				<label for="adminPwd" class="textBody">비밀번호:</label>
				<input type="password" id="adminPwd" name="adminPwd" class="inputBody">
				<button type="button" class="togglePwdBtn" onclick="togglePasswordVisibility('adminPwd', this)">
					<img src="/resources/img/eye-icon.png" alt="Show Password" class="eye_icon">
				</button>
			</div>
			<div class="msg_box">
				<span class="info_msg" id="adminPwdMsg"></span>
			</div>
			<div>
				<button type="button" class="modal-button" id="adminplus">추가</button>
			</div>
		</div>
	</div>

	<form name="adminForm" id="adminForm" method="POST">
		<input type="hidden" name="rating" value="${rating}" />
		<input type="hidden" name="status" value="${status}" />
		<input type="hidden" name="userId" value="${userId}" />
		<input type="hidden" name="classCode" value="${classCode}" />
		<input type="hidden" name="teacherId" value="${teacherId}" />
	</form>

</body>
</html>
