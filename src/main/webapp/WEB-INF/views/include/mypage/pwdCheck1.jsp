<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 비밀번호 변경 -->

<link href="/resources/css/mypage/pwdCheck1.css" rel="stylesheet">

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
	<div class="changePwdContainer">
		<h1 class="secondtitle">비밀번호 확인</h1>
		<p class="content">개인정보 보호를 위해 <br /> 비밀번호를 입력해 주세요.</p>
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
	
	<p class="sub-content" style="text-align:center;">
		회원님의 개인정보를 신중희 취급하며, 회원님의 동의 없이는<br/>기재하신 회원정보를 공개 및 변경하지 않습니다.
	</p>
	
	<div class="find-btn">
    	<button type="button" class="ok-btn" onclick="fn_pageMove('changePwd')">확인</button>
    	<button type="button" class="cencle-btn" >취소</button>
	</div>
	
	<p class="guid-content" style="text-align:center;">
		개인정보처리방침 | 이용약관 | ⒸSOS All Right Reserved
	</p>
	
	
	
	
</div>