<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<!-- JoinForm CSS File -->
<link href="/resources/css/account.css" rel="stylesheet">
<!-- 우편번호 검색 -->
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>
<!-- =======================================================
* Template Name: Personal
* Template URL: https://bootstrapmade.com/personal-free-resume-bootstrap-template/
* Updated: Nov 04 2024 with Bootstrap v5.3.3
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
======================================================== -->
<script type="text/javascript">
	var idDupCheck = false; //아이디 중복 체크
	var emailDupCheck = false; //이메일 중복 체크
	var sendCheck = false; //인증번호 전송 체크
	var authCheck = false; //인증번호 일치 체크
	
	// 공백 체크
	var emptCheck = /\s/g;
	// 아이디 정규표현식(영문 대소문자, 숫자로만 이루어진 8~20자)
	var idCheck = /^[a-zA-Z0-9]{8,20}$/;
	// 비밀번호 정규표현식(영문 대소문자, 숫자, 특수문자만 이루어진 8~20자)
	var pwdCheck = /^[a-zA-Z0-9!@#$%^&*]{8,20}$/;
	var phoneCheck = /^(010)[0-9]{4}[0-9]{4}$/
	/* $(document).ready(function(){
		$("input[name='rating']").change(function(){
			var rating = $("input[name='rating']:checked").val();
			if(rating == "T"){
				document.getElementById("classCode").style.display = "block";
			}
			else if(rating == "U"){
				document.getElementById("classCode").style.display = "none";
			}
		});
	}); */
	
	//##################################################################################
	//#           	 					 아이디 중복 체크				   					   #
	//##################################################################################
	function fn_idCheck() {
		// 알림 메시지 초기화
		fn_displayNone();

		if ($.trim($("#userId").val()).length <= 0) {
			$("#userIdMsg").text("사용하실 아이디를 입력하세요.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}

		if (emptCheck.test($("#userId").val())) {
			$("#userIdMsg").text("사용하실 아이디는 공백을 포함할 수 없습니다.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}

		if (!idCheck.test($("#userId").val())) {
			$("#userIdMsg").text("사용하실 아이디는 8~20자의 영문 대소문자와 숫자로만 입력 가능합니다.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").focus();
			return;
		}
		

		$.ajax({
			type:"POST",
			url:"/account/idCheck",
			data:{
				userId:$("#userId").val()
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
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "success", // alert창에 뜨는 아이콘
							title: "사용 가능한 아이디입니다!", // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						});
						idDupCheck = true;
					}
					else{
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "warning", // alert창에 뜨는 아이콘
							title: res.msg, // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						});
					}
				}
				else{
					Swal.fire({
						position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
						icon: "error", // alert창에 뜨는 아이콘
						title: "오류가 발생했습니다", // alert창에 뜨는 제목
						showConfirmButton: false, // confirm 버튼 여부
						timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
					});
					$("#userId").focus();
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}
	//##################################################################################
	//#           	 					  이메일 보내기				   					   #
	//##################################################################################
	function fn_sendMail(){
		$.ajax({
			type:"POST",
			url:"/mail/sendMail",
			data:{
				userEmail:$("#userEmail").val()
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
						$("#authSendMsg").text("전송완료");
						sendCheck = true;
					}
					else{
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "warning", // alert창에 뜨는 아이콘
							title: res.msg, // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						});
						$("#userEmail").attr("readonly", false);
						$("#emailBtn").attr("disabled", false);
					}
				}
				else{
					Swal.fire({
						position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
						icon: "error", // alert창에 뜨는 아이콘
						title: "오류가 발생했습ㅂ니다", // alert창에 뜨는 제목
						showConfirmButton: false, // confirm 버튼 여부
						timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
					});
					$("#userEmail").attr("readonly", false);
					$("#emailBtn").attr("disabled", false);
					$("#userEmail").focus();
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}
	
	
	//##################################################################################
	//#           	 					  인증번호 전송				   					   #
	//##################################################################################
	function fn_authSend() {
		//알림 메시지 초기화
		fn_displayNone();

		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("사용하실 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}

		if (emptCheck.test($("#userEmail").val())) {
			$("#userEmailMsg").text("사용자 이메일은 공백을 포함할 수 없습니다.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}

		if (!fn_validateEmail($("#userEmail").val())) {
			$("#userEmailMsg").text("사용자 이메일 형식에 알맞지 않습니다.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").focus();
			return;
		}


		// 인증번호 전송 후 중복 전송 방지를 위한 input, button 비활성화
		$("#userEmail").attr("readonly", true);
		$("#emailBtn").attr("disabled", true);

		$.ajax({
			type:"POST",
			url:"/account/emailCheck",
			data:{
				userEmail:$("#userEmail").val()
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
						emailDupCheck = true;
						$("#authSendMsg").text("전송 중..");
						fn_sendMail();
					}
					else{
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "warning", // alert창에 뜨는 아이콘
							title: res.msg, // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						});
						$("#userEmail").attr("readonly", false);
						$("#emailBtn").attr("disabled", false);
					}
				}
				else{
					Swal.fire({
						position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
						icon: "error", // alert창에 뜨는 아이콘
						title: "오류가 발생했습니다", // alert창에 뜨는 제목
						showConfirmButton: false, // confirm 버튼 여부
						timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
					});
					$("#userId").focus();
					$("#userEmail").attr("readonly", false);
					$("#emailBtn").attr("disabled", false);

				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}

	//##################################################################################
	//#           	 					  인증번호 확인				   					   #
	//##################################################################################
	function fn_authCheck() {
		//알림 메시지 초기화
		fn_displayNone();

		if(!sendCheck) {
			$("#emailCodeMsg").text("인증번호 요청을 해주세요.");
			$("#emailCodeMsg").css("display", "inline");
			$("#userEmail").focus();
			return
		}

		if($("#emailCode").val().length != 6) {
			$("#emailCodeMsg").text("인증번호가 정확하지 않습니다.");
			$("#emailCodeMsg").css("display", "inline");
			$("#emailCode").focus();
			return;
		}

		//인증번호 체크 중일 때 오류 발생 방지를 위한 input, button 비활성화
		$("#authNum").attr("readonly", true);
		$("#authBtn").attr("disabled", true);
		$.ajax({
			type:"POST",
			url:"/mail/authCheck",
			data:{
				userEmail:$("#userEmail").val(),
				authNum:$("#emailCode").val()
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
						$("#authCheckMsg").text("인증 완료");
						authCheck = true;
					}
					else{
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "success", // alert창에 뜨는 아이콘
							title: res.msg, // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						});
						$("#authNum").attr("readonly", false);
						$("#authBtn").attr("disabled", false);
					}
				}
				else{
					Swal.fire({
						position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
						icon: "success", // alert창에 뜨는 아이콘
						title: "오류가 발생하였습니다", // alert창에 뜨는 제목
						showConfirmButton: false, // confirm 버튼 여부
						timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
					});
					$("#userId").focus();
					$("#authNum").attr("readonly", false);
					$("#authBtn").attr("disabled", false);

				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
		
	}

	//##################################################################################
	//#           	 					 	회원가입				   					   #
	//##################################################################################
	function fn_join() {
		//알림 메시지 초기화
		fn_displayNone()

		if ($.trim($("#userId").val()).length <= 0) {
			$("#userIdMsg").text("사용하실 아이디를 입력하세요.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").val("");
			$("#userId").focus();
			return;
		}

		if(!idDupCheck) {
			$("#userIdMsg").text("아이디 중복 체크 여부를 확인해주세요.");
			$("#userIdMsg").css("display", "inline");
			$("#userId").focus();
			return;
		}

		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("사용하실 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			location.href="#userId";
			return;
		}

		if(!authCheck) {
			$("#emailCodeMsg").text("인증번호 체크 여부를 확인해주세요.");
			$("#emailCodeMsg").css("display", "inline");
			$("#emailCode").focus();
			return;
		}

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

		if ($.trim($("#userName").val()).length <= 0) {
			$("#userNameMsg").text("사용자 이름을 입력하세요.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		if ($.trim($("#userPhone").val()).length <= 0) {
			$("#userPhoneMsg").text("사용자 전화번호를 입력하세요.");
			$("#userPhoneMsg").css("display", "inline");
			$("#userPhone").val("");
			$("#userPhone").focus();
			return;
		}		
		

		// 회원가입 form
		var form = $("#joinForm")[0];
		var formData = new FormData(form);

		$.ajax({
			type:"POST",
			url:"/account/joinProc",
			data:formData,
			processData:false,
			contentType:false,
			cache:false,
			timeout:600000,
			beforeSend:function(xhr){
				xhr.setRequestHeader("AJAX","true");
			},
			success:function(res){
				if(!icia.common.isEmpty(res)){
					icia.common.log(res);
					var code = icia.common.objectValue(res, "code", -500);
					if(code == 0){
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "success", // alert창에 뜨는 아이콘
							title: "회원가입 완료!", // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						}).then(function() {
							location.href = "/";
						});
					} else if(code == 1){
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "success", // alert창에 뜨는 아이콘
							title: "회원가입 신청 완료!", // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						}).then(function() {
							location.href = "/";
						});
					} else{
						Swal.fire({
							position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
							icon: "warning", // alert창에 뜨는 아이콘
							title: res.msg, // alert창에 뜨는 제목
							showConfirmButton: false, // confirm 버튼 여부
							timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
						});
					}
				}
				else{
					Swal.fire({
						position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
						icon: "success", // alert창에 뜨는 아이콘
						title: "오류가 발생하였습니다", // alert창에 뜨는 제목
						showConfirmButton: false, // confirm 버튼 여부
						timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
					});
				}
			},
			error:function(xhr, status, error){
				icia.common.error(error);
			}
		});
	}

	//##################################################################################
	//#           	 				    이메일 형식 체크				   					   #
	//##################################################################################
	function fn_validateEmail(value) {
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

		return emailReg.test(value);
	}

	//##################################################################################
	//#           	 				    알림 메시지 초기화				   					   #
	//##################################################################################
	function fn_displayNone() {
		$("#userIdMsg").css("display", "none");
		$("#userEmailMsg").css("display", "none");
		$("#emailCodeMsg").css("display", "none");
		$("#userPwd1Msg").css("display", "none");
		$("#userPwd2Msg").css("display", "none");
		$("#userNameMsg").css("display", "none");
		$("#userPhoneMsg").css("display", "none");
		$("#addrCodeMsg").css("display", "none");
		$("#addrBaseMsg").css("display", "none");
		$("#addrDetailMsg").css("display", "none");
	}
</script>
</head>

<body class="index-page">
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<main class="main">
		<!-- Hero Section -->
		<section id="hero" class="hero section dark-background">
			<!--  <img src="/resources/img/test-bg.jpg" alt="" data-aos="fade-in"> -->
			<div class="moving-background-1"></div>

			<!-- 좌 공 -->
			<div class="moving-background-2"></div>

			<!-- 우 하 공 -->
			<div class="moving-background-3"></div>

			<!-- 우 상 공 -->
			<div class="moving-background-4"></div>
		</section>
	</main>

	<footer id="footer" class="footerBox dark-background">
		<h1 style="color: white;">CREATE ACCOUNT</h1>
		<form name="joinForm" id="joinForm" method="post" action="/joinProc.jsp" class="form-signin">
			<div class="footer-innerBox">
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="userId" name="userId" class="form_input" maxlength="20" required value="">
						<label class="sub_cont" for="userId">ID</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="idBtn" class="checkBtn" onclick="fn_idCheck()"><span id="idCheckMsg">아이디 중복 체크</span></button>
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userIdMsg"></span>
				</div>

				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="userEmail" name="userEmail" class="form_input" required value="">
						<label class="sub_cont" for="userEmail">EMAIL</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<button type="button" id="emailBtn" class="checkBtn" onclick="fn_authSend()"><span id="authSendMsg">인증번호 전송</span></button>
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
					<input type="password" id="userPwd1" name="userPwd1" class="form_input" maxlength="20" required value="">
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
					<input type="password" id="userPwd2" name="userPwd2" class="form_input" maxlength="20" required required value="">
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

				<div class="input_box">
					<input type="text" id="userName" name="userName" class="form_input" maxlength="20" required value="">
					<label class="sub_cont" for="userName">NAME</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userNameMsg"></span>
				</div>

				<div class="input_box">
					<input type="text" id="userPhone" name="userPhone" class="form_input" maxlength="11" required value="">
					<label class="sub_cont" for="userPhone">PHONE</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userPhoneMsg"></span>
				</div>

				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="addrCode" name="addrCode" class="form_input" maxlength="5" required value="">
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
					<input type="text" id="addrBase" name="addrBase" class="form_input" maxlength="20" required value="">
					<label class="sub_cont" for="addrBase">ADDRESS</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrBaseMsg"></span>
				</div>

				<div class="input_box">
					<input type="text" id="addrDetail" name="addrDetail" class="form_input" maxlength="20" required value="">
					<label class="sub_cont" for="addrDetail">ADDRESS DETAIL</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrDetailMsg"></span>
				</div>

				<div class="input_box">
					<div class="left-box radio-box">
						<input type="radio" id="userCheck" name="rating" value="U" checked>
						<label for="userCheck">학생</label>
					</div>
					<div class="right-box radio-box">
						<input type="radio" id="taachCheck" name="rating" value="T">
						<label for="taachCheck">강사</label>
					</div>
				</div>
				<div id="classCode" class="input_box left-box" style="display:none;">
					<select class="classCode" name="classCode" id="classCode">
                        <option value="1">국어</option>
                        <option value="2">영어</option>
                        <option value="3">수학</option>
                        <option value="4">사회</option>
                        <option value="5">과학</option>
                     </select>
				</div>

				<input type="hidden" id="userPwd" name="userPwd" value="" >

				<div class="input_box btn-box">
					<button type="button" id="joinBtn" name="joinBtn" class="submitBtn" onclick="fn_join()"><span>SIGN UP</span></button>
				</div>
			</div>
		</form>
	</footer>

	<!-- Scroll Top -->
	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

	<!-- Preloader -->
	<div id="preloader"></div>

	<!-- Vendor JS Files -->
	<script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="/resources/vendor/php-email-form/validate.js"></script>
	<script src="/resources/vendor/aos/aos.js"></script>
	<script src="/resources/vendor/typed.js/typed.umd.js"></script>
	<script src="/resources/vendor/purecounter/purecounter_vanilla.js"></script>
	<script src="/resources/vendor/waypoints/noframework.waypoints.js"></script>
	<script src="/resources/vendor/swiper/swiper-bundle.min.js"></script>
	<script src="/resources/vendor/glightbox/js/glightbox.min.js"></script>
	<script src="/resources/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
	<script src="/resources/vendor/isotope-layout/isotope.pkgd.min.js"></script>

	<!-- Account JS File -->
	<script src="/resources/js/account.js"></script>

</body>

</html>