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

<link href="/resources/css/mypage/mypageChangePwd.css" rel="stylesheet">

<script>
	//공백 체크
	var emptCheck = /\s/g;
	//비밀번호 정규표현식(영문 대소문자, 숫자, 특수문자만 이루어진 8~20자)
	var pwdCheck = /^[a-zA-Z0-9!@#$%^&*]{8,20}$/;
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
	//비밀번호 변경
	function changePwd(){
		fn_displayNone();
		if ($.trim($("#userPwd1").val()).length <= 0) {
			$("#userPwd1Msg").text("사용하실 비밀번호를 입력하세요.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}

		if (emptCheck.test($("#userPwd1").val())) {
			$("#userPwd1Msg").text("사용하실 비밀번호는 공백을 포함할 수 없습니다.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").val("");
			$("#userPwd1").focus();
			return;
		}

		if (!pwdCheck.test($("#userPwd1").val())) {
			$("#userPwd1Msg").text("사용하실 비밀번호는 8~20자의 영문 대소문자와 숫자로만 입력 가능합니다.");
			$("#userPwd1Msg").css("display", "inline");
			$("#userPwd1").focus();
			return;
		}

		if ($("#userPwd1").val() != $("#userPwd2").val()) {
			$("#userPwd2Msg").text("비밀번호가 일치하지 않습니다.");
			$("#userPwd2Msg").css("display", "inline");
			$("#userPwd2").val("");
			$("#userPwd2").focus();
			return;
		}

		$("#userPwd").val($("#userPwd1").val());
		$.ajax({
			type:"POST",
			url:"/user/changePwdProc",
			data:{
				userPwd:$("#userPwd").val()
			},
			datatype:"JSON",
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX", "true");
			},
			success:function(res){
				if(!icia.common.isEmpty(res)){
					icia.common.log(res);
					var code = icia.common.objectValue(res, "code", -500);
					if(code == 0){
	                    Swal.fire({
	                        title: "변경 완료",
	                        text: "비밀번호가 변경되었습니다.",
	                        icon: "success"
	                    });
						location.href = "/";
					}
					else{
		                Swal.fire({
		                    title: "Error",
		                    text: res.msg,
		                    icon: "error"
		                });

					}
				}
				else{
	                Swal.fire({
	                    title: "Error",
	                    text: "오류가 발생했습니다.",
	                    icon: "error"
	                });
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}
	function fn_displayNone() {
		$("#userPwd1Msg").css("display", "none");
		$("#userPwd2Msg").css("display", "none");
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

				<div class="background-dark">
					<h2 class="subTitle">
						<c:if test="${!empty modDate }">
							${userName}님께서 ${modDate} 에 회원정보를 최종 변경하셨습니다.
						</c:if>
						<c:if test="${empty modDate }">
							${userName}님 환영합니다.
						</c:if>
					</h2>
				</div>

				<div class="main-backgroung-dark">
					<form name="joinForm" id="joinForm" method="post" action="/joinProc.jsp" class="form-signin">
						<div class="footer-innerBox">
							<div class="maintext">
								<h1 class="mainTitle">새로운 비밀번호 입력</h1>
								<h4 class="mainsubTitle">비밀번호 설정안내</h4>
								<p class="mainContent">
									다른 사람이 알기 쉬운 아이디, 전화번호, 생일 등 개인정보와 관련된것,<br />연속된 문자/숫자는 사용을 피해주세요.
								</p>
							</div>

							<div class="input_box">
								<input type="password" id="userPwd1" name="userPwd1" class="form_input" maxlength="20" required>
								<label class="sub_cont" for="userPwd1">PASSWORD</label> <span class="under_bar"></span>
								<!-- 눈 아이콘 추가 -->
								<button type="button" class="togglePwdBtn" onclick="togglePasswordVisibility('userPwd1', this)">
									<img src="/resources/img/eye-icon.png" alt="Show Password" class="eye_icon">
								</button>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="userPwd1Msg"></span>
							</div>

							<div class="input_box">
								<input type="password" id="userPwd2" name="userPwd2" class="form_input" maxlength="20" required>
								<label class="sub_cont" for="userPwd2">PASSWORD CHECK</label> <span class="under_bar"></span>
								<!-- 눈 아이콘 추가 -->
								<button type="button" class="togglePwdBtn" onclick="togglePasswordVisibility('userPwd2', this)">
									<img src="/resources/img/eye-icon.png" alt="Show Password" class="eye_icon">
								</button>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="userPwd2Msg"></span>
							</div>

							<div class="change-btn">
								<button type="button" class="ok-btn" onclick="changePwd()">저장</button>
								<button type="button" class="cencle-btn" onclick="location.href='/user/mypage'">취소</button>
							</div>
							<input type="hidden" id="userPwd" name="userPwd" value=""> 
						</div>
					</form>
				</div>
				<p class="guid-content" style="text-align: center;">개인정보처리방침 | 이용약관 | ⒸSOS All Right Reserved</p>
			</div>
		</div>
	</div>
</body>
</html>