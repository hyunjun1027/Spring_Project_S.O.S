<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/mypage/updateForm.css" rel="stylesheet">

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
		<h2 class="first-title">회원정보 관리</h2>
	</div>
	
	<div class="background-dark">
		<h2 class="subTitle">***님께서 2024년 11월 29일 회원정보를 최종 변경하셨습니다.</h2>
	</div>
	
	<div class="main-backgroung-dark">
		<form name="joinForm" id="joinForm" method="post" action="/joinProc.jsp" class="form-signin">
			<div class="footer-innerBox">
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="userEmail" name="userEmail" class="form_input" required>
						<label class="sub_cont" for="userEmail">EMAIL</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="emailBtn" class="checkBtn" onclick="fn_authSend()"><span id="authSendMsg">이메일 인증</span></button>
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userEmailMsg"></span>
				</div>
	
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="emailCode" name="emailCode" class="form_input" maxlength="6" required>
						<label class="sub_cont" for="emailCode">CODE</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="emailCodeBtn" class="checkBtn" onclick="fn_authCheck()"><span id="authCheckMsg">인증번호 확인</span></button>
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="emailCodeMsg"></span>
				</div>
				
				<div class="input_box">
					<input type="text" id="userName" name="userName" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="userName">NAME</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userNameMsg"></span>
				</div>
				
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="userPhone" name="userPhone" class="form_input" required>
						<label class="sub_cont" for="userPhone">Phone</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="phoneBtn" class="checkBtn" onclick="fn_authSend()"><span id="authSendMsg">휴대폰 인증</span></button>
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userPhoneMsg"></span>
				</div>
				
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="phoneCode" name="phoneCode" class="form_input" maxlength="6" required>
						<label class="sub_cont" for="phoneCode">CODE</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="phoneCodeBtn" class="checkBtn" onclick="fn_authCheck()"><span id="authCheckMsg">인증번호 확인</span></button>
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="emailCodeMsg"></span>
				</div>
				
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="addrCode" name="addrCode" class="form_input" maxlength="5" required>
						<label class="sub_cont" for="addrCode">POSTAL CODE</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="addrCodeBtn" class="checkBtn" onclick="checkPost()">우편번호 검색</button>
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrCodeMsg"></span>
				</div>
	
				<div class="input_box">
					<input type="text" id="addrBase" name="addrBase" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="addrBase">ADDRESS</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrBaseMsg"></span>
				</div>
	
				<div class="input_box">
					<input type="text" id="addrDetail" name="addrDetail" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="addrDetail">ADDRESS DETAIL</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrDetailMsg"></span>
				</div>
	
				<input type="hidden" id="userPwd" name="userPwd" value="" >
	
				<div class="update-btn">
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