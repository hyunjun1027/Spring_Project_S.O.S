<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

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

<link href="/resources/css/mypage/mypageUpdateForm.css" rel="stylesheet">
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" src="/resources/js/memberAddr.js"></script>

<script>
	//체크 후 다음 값 진행
	//var emailCheckVal = false;
	//var eCodeCheckVal = false;

	var postCodeVal = false;
	var addressVal = false;
	var addressDetailVal = false;

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

	$(function() {

		//휴대폰 인증버튼
		$("#phoneBtn").on("click", function() {
			fn_phoneSend();
		});
		//휴대폰 인증번호 확인
		$("#phoneCodeBtn").on("click", function() {
			fn_pCodeCheck();
		});
		//우편번호 검색버튼

		//회원정보 저장 버튼 클릭
		$("#updateSave").on("click", function() {
			fn_userUpdateProc();
		});

		//취소 버튼 클릭
		$("#cancel").on("click", function() {
			location.href = "/user/mypage";
		});
	});

	//input 하단의 안내 메세지 숨기기
	function fn_displayNone() {
		//$("#emailCheckMsg").css("display", "none"); //이메일 인증전송
		//$("#userEmailMsg").css("display", "none"); //메일 유효성
		//$("#emailCodeMsg").css("display", "none");//이메일 인증번호 확인
		$("#userNameMsg").css("display", "none"); //사용자 이름
		$("#phoneSendMsg").css("display", "none"); //핸드폰 인증전송
		$("#userPhoneMsg").css("display", "none"); //사용자 핸드폰
		$("#addrCodeMsg").css("display", "none");
		$("#addrBaseMsg").css("display", "none");
		$("#addrDetailMsg").css("display", "none");

	}

	//이메일 형식
	function fn_validateEmail(value) {
		var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;

		return emailReg.test(value);
	}

	//회원정보 수정
	function fn_userUpdateProc() {
		fn_displayNone();

		//공백체크
		var emptCheck = /\s/g;

		//핸드폰 유효성
		const phonePattern = /^\d{3}-\d{3,4}-\d{4}$/;

		//이름 유효성 검사
		var mixedName = /^[가-힣a-zA-Z]+$/; // 한글 또는 영문만 포함
		var korName = /^[가-힣]+$/; // 한글만
		var engName = /^[a-zA-Z]+$/; // 영문만

		//이름 공백
		if ($.trim($("#userName").val()).length <= 0) {
			$("#userNameMsg").text("사용자 이름을 검색하세요.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		//이름 공백 체크
		if (emptCheck.test($("#userName").val())) {
			$("#userNameMsg").text("사용자 이름은 공백을 포함할 수 없습니다.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		var userName = $("#userName").val();

		// 한글과 영문 외의 문자가 포함된 경우
		if (!mixedName.test(userName)) {
			$("#userNameMsg").text("사용자 이름은 한글이나 영문으로만 작성 가능합니다.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		// 한글과 영문이 섞여 있는 경우
		if (!(korName.test(userName) || engName.test(userName))) {

			$("#userNameMsg").text("사용자 이름은 한글만 또는 영문만 입력해야 합니다.");
			$("#userNameMsg").css("display", "inline");
			$("#userName").val("");
			$("#userName").focus();
			return;
		}

		//핸드폰 공백
		if ($.trim($("#userPhone").val()).length <= 0) {
			$("#userPhoneMsg").text("사용자 전화번호를 입력하세요.");
			$("#userPhoneMsg").css("display", "inline");
			$("#userPhone").val("");
			$("#userPhone").focus();
			return;
		}

		//핸드폰 공백 체크
		if (emptCheck.test($("#userPhone").val())) {
			$("#userPhoneMsg").text("공백 포함 없이(-)을 포함한 전화번호 형식에 맞춰 작성해주세요.");
			$("#userPhoneMsg").css("display", "inline");
			$("#userPhone").val("");
			$("#userPhone").focus();
			return;
		}

		//핸드폰 유효성 검사
		/* if (!phonePattern.test($("#userPhone").val())) {
			$("#userPhoneMsg").text("(-)을 포함한 전화번호 형식에 맞춰 작성해주세요");
			$("#userPhoneMsg").css("display", "inline");
			$("#userPhone").focus();
			return;
		} */

		//우편번호
		/* if ($.trim($("#addrCode").val()).length <= 0) {
			$("#addrCodeMsg").text("우편번호를 입력하세요.");
			$("#addrCodeMsg").css("display", "inline");
			$("#addrCode").val("");
			$("#addrCode").focus();
			return;
		} */

		postCodeVal = true;

		//주소
		/* if ($.trim($("#addrBase").val()).length <= 0) {
			$("#addrBaseMsg").text("회원주소를 입력하세요.");
			$("#addrBaseMsg").css("display", "inline");
			$("#addrBase").val("");
			$("#addrBase").focus();
			return;
		} */

		addressVal = true;

		//상세주소
		/* if ($.trim($("#addrDetail").val()).length <= 0) {
			$("#addrDetailMsg").text("상세주소를 입력하세요.");
			$("#addrDetailMsg").css("display", "inline");
			$("#addrDetail").val("");
			$("#addrDetail").focus();
			return;
		} */

		addressDetailVal = true;

		//최종 회원정보 수정 ajax
		$.ajax({
			type : "POST",
			url : "/user/updateProc",
			data : {
				userEmail:$("#userEmail").val(),
				userName : $("#userName").val(),
				userPhone : $("#userPhone").val(),
				addrCode : $("#addrCode").val(),
				addrBase : $("#addrBase").val(),
				addrDetail : $("#addrDetail").val()
			},
			dataType : "JSON",
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				if (response.code == 0) {
                    Swal.fire({
                        title: "수정 완료",
                        text: "회원정보가 수정되었습니다.",
                        icon: "success"
                    }).then(() => {
                    	location.href = "/user/mypage";
                    });
                    
				} else if (response.code == 100) {
                    Swal.fire({
                        title: "Error",
                        text: "회원정보 수정 중 오류발생",
                        icon: "error"
                    });
                    
					return;
				} else if (response.code == -400) {
                    Swal.fire({
                        title: "Error",
                        text: "값을 확인하세요",
                        icon: "error"
                    });

					return;
				} else {
                    Swal.fire({
                        title: "Error",
                        text: "오류 발생",
                        icon: "error"
                    });

					return;
				}
			},
			error : function(xhr, status, error) {
                Swal.fire({
                    title: "Error",
                    text: "오류 발생",
                    icon: "error"
                });
                
				icia.common.error(error);
			}
		});

	}

	//메일 전송
	function fn_authSend() {
		if ($.trim($("#userEmail").val()).length <= 0) {
			$("#userEmailMsg").text("사용자 이메일을 입력하세요.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}

		if (!fn_validateEmail($("#userEmail").val())) {
			$("#userEmailMsg").text("사용자 이메일 형식이 올바르지 않습니다.");
			$("#userEmailMsg").css("display", "inline");
			$("#userEmail").val("");
			$("#userEmail").focus();
			return;
		}

		const userEmail = $("#userEmail").val().trim(); // 이메일 입력값

		// AJAX 요청
		$.ajax({
			type : "POST",
			url : "/mail/sendMail",
			dataType : "JSON",
			data : {
				userEmail : userEmail
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				console.log("서버 응답: ", response);

				if (response.code === 0) {
				    Swal.fire({
				        title: "인증번호 발송 완료!",
				        text: "인증번호가 이메일로 발송되었습니다. 이메일을 확인하세요.",
				        icon: "success"
				    }).then(() => {
				        $("#emailCode").prop("disabled", false); // 인증번호 입력 가능
				        emailCheckVal = true; // 인증번호 요청 성공 상태로 설정
				    });
				} else {
				    Swal.fire({
				        title: "메일 전송 실패",
				        text: response.message,
				        icon: "error"
				    });
				}
			},
			error : function(xhr, status, error) {
				console.error("AJAX 요청 실패:", error);
				alert("메일 전송 중 오류가 발생했습니다.");
			}
		});

	}

	//메일 인증코드 비교
	function fn_authCheck() {
		const userEmail = $("#userEmail").val().trim();
		const authNum = $("#emailCode").val().trim();

		//알림 메시지 초기화
		fn_displayNone();

		if (!authNum) {
			$("#emailCodeMsg").text("인증번호를 입력하세요.");
			$("#emailCodeMsg").css("display", "inline");
			$("#emailCode").focus();
			return;
		}

		// AJAX 요청
		$.ajax({
			type : "POST",
			url : "/mail/authCheck",
			dataType : "JSON",
			data : {
				userEmail : userEmail,
				authNum : authNum
			},
			beforeSend : function(xhr) {
				xhr.setRequestHeader("AJAX", "true");
			},
			success : function(response) {
				console.log("서버 응답: ", response);

				if (response.code === 0) { // 인증 성공
					alert("인증번호가 일치합니다.");
					$("#emailCodeMsg").text("인증 성공").css("color", "green").css(
							"display", "inline");
					$("#emailCode").prop("disabled", true); // 인증번호 입력 비활성화
					$("#userEmail").prop("readonly", true); // 이메일 입력 비활성화
					$("#updateSave").prop("disabled", false); // 다음 단계 버튼 활성화

					eCodeCheckVal = true;

				} else if (response.code === 100) { // 인증번호 불일치
					alert("인증번호가 일치하지 않습니다. 다시 확인해주세요.");
					$("#emailCodeMsg").text("인증번호가 일치하지 않습니다.").css("color",
							"red").css("display", "inline");
				} else if (response.code === 404) { // 인증번호 없음
					alert("인증번호가 만료되었거나 존재하지 않습니다.");
					$("#emailCodeMsg").text("인증번호가 만료되었거나 존재하지 않습니다.").css(
							"color", "red").css("display", "inline");
				} else { // 기타 오류
					alert("오류가 발생했습니다: " + response.message);
					console.error("서버 오류: ", response.message);
				}
			},
			error : function(xhr, status, error) {
				console.error("AJAX 요청 실패:", error);
				alert("인증번호 확인 중 오류가 발생했습니다.");
			}
		});

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
					<h2 class="first-title">회원정보 관리</h2>
				</div>

				<div class="background-dark">
					<h2 class="subTitle">
						<c:choose>
							<c:when test="${!empty user.modDate}">
		               			${user.userName}님께서 ${user.modDate}에 회원정보를 최종 변경하셨습니다.
							</c:when>
							<c:otherwise>
		               			${user.userName}님 환영합니다!
							</c:otherwise>
						</c:choose>
					</h2>
				</div>

				<div class="main-backgroung-dark">
					<form name="joinForm" id="joinForm" method="post" action="/joinProc.jsp" class="form-signin">
						<div class="footer-innerBox">

							<div class="input_box">
								<input type="text" id="userEmail" name="userEmail" class="form_input" value="${user.userEmail}" readonly>
								<label class="sub_cont" for="userEmail">EMAIL</label> <span class="under_bar"></span>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="userEmailMsg"></span>
							</div>

							<div class="input_box">
								<input type="text" id="userName" name="userName" class="form_input" maxlength="20" value="${user.userName}" required>
								<label class="sub_cont" for="userName">NAME</label> <span class="under_bar"></span>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="userNameMsg"></span>
							</div>

							<div class="input_box">
								<input type="text" id="userPhone" name="userPhone" class="form_input" value="${user.userPhone}" required>
								<label class="sub_cont" for="userPhone">PHONE</label> <span class="under_bar"></span>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="userPhoneMsg"></span>
							</div>

							<div class="input_outBox">
								<div class="input_box">
									<input type="text" id="addrCode" name="addrCode" class="form_input" maxlength="5" value="${user.addrCode}" required>
									<label class="sub_cont" for="addrCode">POSTAL CODE</label> <span class="under_bar"></span>
								</div>
								<div class="btn_box">
									<button type="button" id="addrCodeBtn" class="checkBtn" onclick="checkPost()">우편번호 검색</button>
								</div>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="addrCodeMsg"></span>
							</div>

							<div class="input_box">
								<input type="text" id="addrBase" name="addrBase" class="form_input" maxlength="20" value="${user.addrBase}" required>
								<label class="sub_cont" for="addrBase">ADDRESS</label> <span class="under_bar"></span>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="addrBaseMsg"></span>
							</div>

							<div class="input_box">
								<input type="text" id="addrDetail" name="addrDetail" class="form_input" maxlength="20" value="${user.addrDetail}" required>
								<label class="sub_cont" for="addrDetail">ADDRESS DETAIL</label> <span class="under_bar"></span>
							</div>
							<div class="msg_box">
								<span class="info_msg" id="addrDetailMsg"></span>
							</div>

							<input type="hidden" id="userPwd" name="userPwd" value="">

							<div class="update-btn">
								<!-- <button type="button" class="ok-btn" onclick="fn_pageMove('changePwd')">저장</button> -->
								<button type="button" class="ok-btn" id="updateSave">저장</button>
								<button type="button" class="cencle-btn" id="cancel">취소</button>
							</div>
						</div>
					</form>
				</div>

				<p class="guid-content" style="text-align: center;">개인정보처리방침 | 이용약관 | ⒸSOS All Right Reserved</p>
			</div>
		</div>
	</div>
</body>
</html>