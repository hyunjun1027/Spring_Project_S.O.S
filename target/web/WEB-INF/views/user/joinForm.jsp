<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- JoinForm CSS File -->
<link href="/resources/css/joinForm.css" rel="stylesheet">

<!-- =======================================================
* Template Name: Personal
* Template URL: https://bootstrapmade.com/personal-free-resume-bootstrap-template/
* Updated: Nov 04 2024 with Bootstrap v5.3.3
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
======================================================== -->
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
		<h1 style="color: white;">회원가입</h1>
		<form name="loginForm" id="loginForm" method="post" action="/loginProc.jsp" class="form-signin">
			<div class="footer-innerBox">
				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="userId" name="userId" class="form_input" maxlength="20" required>
						<label class="sub_cont" for="userId">ID *</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<input type="button" value="아이디 중복 체크" id="idBtn" class="checkBtn">
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userId_msg">이미 사용 중인 아이디입니다.</span>
				</div>

				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="userEmail" name="userEmail" class="form_input" maxlength="20" required>
						<label class="sub_cont" for="userEmail">EMAIL *</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<input type="button" value="인증번호 전송" id="emailBtn" class="checkBtn">
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userEmail_msg"></span>
				</div>

				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="emailCode" name="emailCode" class="form_input" maxlength="20" required>
						<label class="sub_cont" for="emailCode">CODE *</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<input type="button" value="인증번호 확인" id="emailCodeBtn" class="checkBtn">
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userEmail_msg"></span>
				</div>

				<div class="input_box">
					<input type="password" id="userPwd1" name="userPwd1" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="userPwd1">PASSWORD *</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userPwd1_msg"></span>
				</div>

				<div class="input_box">
					<input type="password" id="userPwd2" name="userPwd2" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="userPwd2">PASSWORD CHECK *</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userPwd2_msg"></span>
				</div>

				<div class="input_box">
					<input type="password" id="userName" name="userName" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="userName">NAME *</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="userName_msg"></span>
				</div>

				<div class="input_outBox">
					<div class="input_box">
						<input type="text" id="addrCode" name="addrCode" class="form_input" maxlength="20" required>
						<label class="sub_cont" for="addrCode">POSTAL CODE</label>
						<span class="under_bar"></span>
					</div>
					<div class="btn_box">
						<input type="button" value="우편번호 검색" id="addrCodeBtn" class="checkBtn">
					</div>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrCode_msg"></span>
				</div>

				<div class="input_box">
					<input type="password" id="addrBase" name="addrBase" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="addrBase">ADDRESS</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrBase_msg"></span>
				</div>

				<div class="input_box">
					<input type="password" id="addrDetail" name="addrDetail" class="form_input" maxlength="20" required>
					<label class="sub_cont" for="addrDetail">ADDRESS DETAIL</label>
					<span class="under_bar"></span>
				</div>
				<div class="msg_box">
					<span class="info_msg" id="addrDetail_msg"></span>
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

	<!-- Main JS File -->
	<script src="/resources/js/main.js"></script>

</body>

</html>