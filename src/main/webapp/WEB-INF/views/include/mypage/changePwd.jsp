<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/mypage/changePwd.css" rel="stylesheet">

<script>
//비밀번호 표시
function togglePasswordVisibility(inputId, button) {
    const input = document.getElementById(inputId);
    const isPassword = input.type === "password";
    
    // 비밀번호 입력창 타입 변경
    input.type = isPassword ? "text" : "password";

    // 아이콘 변경 (예: 열려 있는 눈/닫힌 눈)
    const img = button.querySelector('img');
    img.src = isPassword ? "/resources/img/eye-open-icon.png" : "/resources/img/eye-icon.png";
    img.alt = isPassword ? "Hide Password" : "Show Password";
}
</script>




<div class="contentBoardContainer">
	<div class="title-div">
		<h2 class="first-title">비밀번호 변경</h2>
	</div>
	
	<div class="background-dark">
		<h2 class="subTitle">***님께서 2024년 11월 29일 회원정보를 최종 변경하셨습니다.</h2>
	</div>
	
	<div class="main-backgroung-dark">
		<form name="joinForm" id="joinForm" method="post" action="/joinProc.jsp" class="form-signin">
			<div class="footer-innerBox">
				<div class="maintext">
					<h1 class="mainTitle">새로운 비밀번호 입력</h1>
					<h4 class="mainsubTitle">비밀번호 설정안내</h4>
					<p class="mainContent">다른 사람이 알기 쉬운 아이디, 전화번호, 생일 등 개인정보와 관련된것,<br/>연속된 문자/숫자는 사용을 피해주세요.</p>
				</div>
			
				<div class="input_box">
					<input type="password" id="userPwd1" name="userPwd1" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="userPwd1">PASSWORD</label>
					<span class="under_bar"></span>
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
					<label class="sub_cont" for="userPwd2">PASSWORD CHECK</label>
					<span class="under_bar"></span>
				    <!-- 눈 아이콘 추가 -->
				    <button type="button" class="togglePwdBtn" onclick="togglePasswordVisibility('userPwd2', this)">
				        <img src="/resources/img/eye-icon.png" alt="Show Password" class="eye_icon">
				    </button>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userPwd2Msg"></span>
				</div>
				
				<div class="change-btn">
			    	<button type="button" class="ok-btn" onclick="fn_pageMove('changePwd')">저장</button>
			    	<button type="button" class="cencle-btn" >취소</button>
				</div>
			</div>
		</form>
	</div>
	<p class="guid-content" style="text-align:center;">
		개인정보처리방침 | 이용약관 | ⒸSOS All Right Reserved
	</p>
	
	
</div>