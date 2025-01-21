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

<link href="/resources/css/mypage/mypagePwdCheck1.css" rel="stylesheet">

<script>
	$(function() {
		$("#submit-btn").on("click", function() {
			//공백 체크
			var emptCheck = /\s/g;

			if($.trim($("#userPwd").val()).length <= 0){
                Swal.fire({
                    title: "Error",
                    text: "비밀번호를 입력하세요.",
                    icon: "error"
                });
                
				$("#userPwd").val("");
				$("#userPwd").focus();
				return;
			}

			if(emptCheck.test($("#userPwd").val())){
                Swal.fire({
                    title: "Error",
                    text: "비밀번호는 공백을 포함할 수 없습니다.",
                    icon: "error"
                });

				$("#userPwd").val("");
				$("#userPwd").focus();
				return;
			}

			//최종 회원정보 수정 ajax
			$.ajax({
				type : "POST",
				url : "/user/pwdCheckProc",
				data : {
					userPwd : $("#userPwd").val()
				},
				dataType : "JSON",
				beforeSend : function(xhr) {
					xhr.setRequestHeader("AJAX", "true");
				},
				success : function(response) {
					if (response.code == 0) {
						
                        Swal.fire({
                            title: "비밀번호 일치!",
                            icon: "success"
                        }).then(() => {
                        	location.href = "/user/changePwd";
                        });
						
					} else if (response.code == 100) {
						
                        Swal.fire({
                            title: "오류!",
                            text: "로그인 후 진행해주세요",
                            icon: "error"
                        }).then(() => {
                        	location.href = "/";
                        });
						return;
					} else if (response.code == 404) {
						
                        Swal.fire({
                            title: "오류!",
                            text: "존재하지 않는 사용자입니다",
                            icon: "error"
                        }).then(() => {
                        	location.href = "/";
                        });
						return;

					} else if (response.code == 408) {
						
                        Swal.fire({
                            title: "오류!",
                            text: "사용자 에러!",
                            icon: "error"
                        }).then(() => {
                        	location.href = "/";
                        });
						return;

					} else {
						
                        Swal.fire({
                            title: "오류!",
                            text: "비밀번호가 일치하지 않습니다.",
                            icon: "error"
                        });
						
					}
				},
				error : function(xhr, status, error) {
					alert("오류발생...");
					icia.common.error(error);
				}
			});
			
			
			
			
			
			
		});
	});

	//비밀번호 표시
	function togglePasswordVisibility(inputId, button) {
		const input = document.getElementById(inputId);
		const isPassword = input.type === "password";

		// 비밀번호 입력창 타입 변경
		input.type = isPassword ? "text" : "password";

		// 아이콘 변경 (예: 열려 있는 눈/닫힌 눈)
		const img = button.querySelector('img');
		img.src = isPassword ? "/resources/img/eye-open-icon.png"
				: "/resources/img/eye-icon.png";
		img.alt = isPassword ? "Hide Password" : "Show Password";
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div">
					<h2 class="first-title">비밀번호 변경</h2>
				</div>
				<div class="changePwdContainer">
					<h1 class="secondtitle">비밀번호 확인</h1>
					<p class="content">
						개인정보 보호를 위해 <br /> 비밀번호를 입력해 주세요.
					</p>
				</div>

				<form name="pwdCheckForm" action="pwdCheckProc" method="post" onsubmit="return false;">
					<div class="input_box">
						<input type="password" id="userPwd" name="userPwd" class="form_input" maxlength="20" required>
						<label class="sub_cont" for="userPwd">PASSWORD</label> <span class="under_bar"></span>
						<!-- 눈 아이콘 추가 -->
						<button type="button" class="togglePwdBtn" onclick="togglePasswordVisibility('userPwd', this)">
							<img src="/resources/img/eye-icon.png" alt="Show Password" class="eye_icon">
						</button>
					</div>
					<div class="msg_box">
						<span class="info_msg" id="userPwdMsg"></span>
					</div>

					<p class="sub-content" style="text-align: center;">
						회원님의 개인정보를 신중하게 취급하며, 회원님의 동의 없이는<br />기재하신 회원정보를 공개 및 변경하지 않습니다.
					</p>

					<div class="find-btn">
						<button type="submit" class="ok-btn" id="submit-btn">확인</button>
						<button type="button" class="cencle-btn" onclick="location.href='/user/mypage'">취소</button>
					</div>
				</form>

				<p class="guid-content" style="text-align: center;">개인정보처리방침 | 이용약관 | ⒸSOS All Right Reserved</p>
			</div>
		</div>
	</div>
</body>
</html>