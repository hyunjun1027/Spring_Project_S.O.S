<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style>

.teach-img, .teach-info {
	display: flex;
	justify-content: center;
	flex-direction: column;
	flex-basis: calc(50%);
}

.teach-img {
	text-align: center;
}

.teach-img img {
	margin-top: 90px;
	width: 100%;
	height: 450px;;
	object-fit: contain;
}

.teach-info {
	padding-right: 30px;
}

.teach-info>div:first-child {
	flex-basis: 15%;
	font-size: 18px;
	color: #333;
	position: relative;
	top: 50px;
}

.teach-info>div:nth-child(2) {
	flex-basis: 25%;
	font-size: 27px;
	font-weight: 600;
	line-height: 120%;
}

.teach-info>div:last-child {
	flex-basis: 60%;
}

.subTitle {
	font-size: 19px;
	font-weight: 550;
	margin-left: 10px;
	margin-bottom: 10px;
	color: #333;
}

.teach-notice .left-title {
	float: left;
}

.teach-notice .right-title {
	float: right;
}

.title-notice-table {
	clear: both;
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 20px;
}

.title-notice-table tbody tr {
	background: #f6f6f6;
	transition: 0.3s;
}

.title-notice-table tbody tr:hover {
	background: #f0f0f0;
	transition: 0.3s;
}

.title-notice-table tbody tr:hover .new-notice {
	background: #7e96e6;
	color: white;
	transition: 0.2s;
}

.title-notice-table td {
	text-align: center;
	font-size: 12px;
	border-top: 1px solid #ccc;
	border-left: none;
	border-right: none;
}

.title-notice-table td:last-child {
	padding: 15px 10px;
	text-align: left;
}

.title-notice-table th {
	font-weight: bold;
	width: 6%
}

.title-notice-table tbody tr:last-child td {
	border-bottom: 1px solid #ccc;
}

.title-notice-table tbody tr td:nth-child(2) {
	font-weight: 550;
}

.new-notice {
	margin: auto;
	padding: 3px;
	width: 80%;
	background: white;
	color: #7e96e6;
	border: 1px solid #7e96e6;
	border-radius: 20px;
	transition: 0.2s;
}


.Profile{
	background-color: #b5aaf2;
	color: white;
	font-size: 14px;
	padding: 5px 10px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s, transform 0.2s;
	position: absolute;
	transform: translate(10px, -3px);
	border: none;  
}

.Profile:hover {
    background-color: #9f8aeb;
}

.modal-profile {
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background: rgba(0, 0, 0, 0.5); 
	display: none; /* 처음에는 보이지 않도록 설정 */
	justify-content: center;
	align-items: center;
	z-index: 1000;
	transition: transform 0.5s ease; 
}

.modal-profile.flip .modal-content-front {
	transform: rotateY(180deg);  
	backface-visibility: hidden; 
}

.modal-profile.flip .modal-content-back {
	transform: rotateY(0deg); 
	backface-visibility: hidden; 
}

.modal-content-front{
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	width: 100%;
	max-width: 700px;
	max-height: 500px;
	height: 80%;
	padding: 40px 30px;
	border-radius: 12px;
	background: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	transition: transform 1s ease;
	backface-visibility: hidden;
}
.modal-content-back {
	position: absolute;
	top: 10%;
	left: 33%;
	transform: translate(-50%, -50%);
	width: 100%;
	max-width: 700px;
	max-height: 550px;
	height: 80%;
	padding: 40px 30px;
	border-radius: 12px;
	background: white;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
	transition: transform 1s ease;
	backface-visibility: hidden;
}

/* 처음에는 modal-content-back 숨기기 */
.modal-content-back {
	transform: rotateY(-180deg); 
	visibility: hidden;
	opacity: 0;
	transition: visibility 0s 0.5s, opacity 0.5s linear;
}

/* flip 상태에서 modal-content-back 보이게 */
.modal-profile.flip .modal-content-back {
	visibility: visible;
	opacity: 1;
	transition: visibility 0s 0s, opacity 0.5s linear;
}

/* 닫기 버튼 스타일 */
.close-btn {
	position: absolute;
	top: 1px;
	right: 10px;
	font-size: 40px;
	color: #333;
	cursor: pointer;
	transition: color 0.3s;
}

.close-btn:hover {
	color: #ff0000;
}

/* 팝업 텍스트 스타일 */
.h2 {
	font-size: 30px; 
	margin-bottom: 30px;
	color: black;
	font-weight: bold;
	border-bottom: 3px solid black;
}

.h3 {
	font-size: 25px;
	margin-bottom: 25px;
	color: black;
}

.h4 {
	font-size: 20px; 
	margin-bottom: 20px;
	color: black;
}

.p {
	font-size: 15px;
	margin-bottom: 10px;
	color: black;
}

.modal-content-back .h3 {
	font-size: 20px; 
	color: black;
	margin-bottom: 10px;
}

.modal-content-back .Tpw {
	width: 100%;
	margin-bottom: 10px;
}

.msg_box {
	font-size: 10px;
	color: red;
	margin-bottom: 10px;
}

.profile-edit-btn {
	display: block;
	margin-left: auto;
	margin-top: 20px;
	padding: 10px 20px;
	background-color: #b5aaf2;
	color: white;
	font-size: 16px;
	border: none;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s, transform 0.2s;
}

.profile-edit-btn:hover {
	background-color: ##b5aaf3;
	transform: scale(1.05);
}

.modal-content-front .Tpw {
	width: 100%;
	margin-bottom: 15px;
	resize: none;
	border: none;
}

.Tpw {
	width: 100%;
	margin-bottom: 15px;
	resize: none;
}

.modal-content-back .button-container {
	display: flex; 
	justify-content: flex-end; 
	gap: 10px; 
	margin-top: 20px; 
}

.profile-cel-btn, .profile-updt-btn {
	padding: 10px 20px;
	font-size: 16px;
	border-radius: 5px;
	cursor: pointer;
	transition: background-color 0.3s, transform 0.2s;
	border: none;
}

.profile-cel-btn {
  background-color: #CC3300;
  color: white;
}

.profile-cel-btn:hover {
  background-color: #CC3301;
  transform: scale(1.05);
}

.profile-updt-btn {
  background-color: #05ad53;
  color: white;
}

.profile-updt-btn:hover {
  background-color: #05ad54;
  transform: scale(1.05);
}
</style>

<script type="text/javascript">

function fn_pageMove() {
	document.bbsForm.brdSeq.value = "";
	document.bbsForm.curPage.value = 1;
	document.bbsForm.classCode = ${classCode};
	document.bbsForm.teacherId.value = "${teacher.userId}";
	document.bbsForm.action = "/teach/teachNotice";
	document.bbsForm.submit();
}	// 강사 페이지 메뉴 이동

function fn_noticeMove(brdSeq, courseCode) {
	document.bbsForm.brdSeq.value = brdSeq;
	document.bbsForm.classCode.value = ${classCode};
	document.bbsForm.teacherId.value = "${teacher.userId }";
	document.bbsForm.courseCode.value = courseCode;
	document.bbsForm.action = "/teach/teachNoticeView";
	document.bbsForm.submit();
}

/*모달*/
function fn_modal() {
    var modal = document.getElementById("modal-profile");
    var closeBtn = document.getElementById("close-btn"); 

    modal.style.display = "block"; 

    closeBtn.onclick = function() {
        modal.style.display = "none";
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
}

function fn_profile() {
	$.ajax({
		type:"POST",
		url:"/teach/teachSelect",
		data:{
			teacherId : "${teacher.userId}"
		},
		dataType:"JSON",
		beforeSend:function(xhr)
		{
			xhr.setRequestHeader("AJAX", "true");
		},
		success:function(response)
		{ 
			if(response.code == 0)
			{
				var modal = document.getElementById("modal-profile");
			    modal.classList.toggle("flip");
				
			}
			else if(response.code == 400)
			{
				Swal.fire({
		               title: '로그인을 먼저 진행하세요.',
		               icon: 'info',
		               
		               showCancelButton: false,
		               showconfirmButton: true,
		               confirmButtonColor: '#3085d6',  
		               confirmButtonText: '확인',
		            });
			}
			else if(response.code == 100)
			{
				Swal.fire({
		               title: '강사진만 사용 가능합니다.',
		               icon: 'info',
		               
		               showCancelButton: false,
		               showconfirmButton: true,
		               confirmButtonColor: '#3085d6',  
		               confirmButtonText: '확인',
		            });
			}
			else if(response.code == 500)
			{
				Swal.fire({
		               title: '본인 프로필만 수정 가능합니다.',
		               icon: 'info',
		               
		               showCancelButton: false,
		               showconfirmButton: true,
		               confirmButtonColor: '#3085d6',  
		               confirmButtonText: '확인',
		            });
			}
		},
		error:function(xhr, status, error)
		{
			icia.common.error(error);
			Swal.fire({
	               title: '접속 중 오류가 발생하였습니다.!',
	               icon: 'info',
	               
	               showCancelButton: false,
	               showconfirmButton: true,
	               confirmButtonColor: '#3085d6',  
	               confirmButtonText: '확인',
	            });
		}
	});
}

function fn_profileCel() {
    var modal = document.getElementById("modal-profile");
    modal.classList.remove("flip");
	document.getElementById("profileForm").reset();
    
    $(".msg_box .info_msg").text("").hide();
}

function fn_profileUpdt() {
	$(".msg_box .info_msg").text("").hide();
	
    var emptCheck = /\s/g;
    var pwdCheck = /^[a-zA-Z0-9!@#$%^&*]{8,20}$/;
    
    if ($.trim($("#userIntro").val()).length <= 0) {
		$("#userIntroMsg").text("사용하실 인트로를 입력하세요.");
		$("#userIntroMsg").css("display", "inline");
		$("#userIntro").val("");
		$("#userIntro").focus();
		return;
	}
    
	var form = document.getElementById("profileForm");
	var formData = new FormData(form);
	
	$.ajax({
        type: "POST",
        url: "/teach/teachUpdate", 
        data: formData,  
        processData: false,
        contentType: false,
        dataType: "JSON",
        beforeSend: function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
        },
        success: function(response) {
            if (response.code == 0) {
                Swal.fire({
                    title: '수정이 완료되었습니다.',
                    icon: 'success',
                    confirmButtonText: '확인',
                    confirmButtonColor: '#3085d6',
                }).then((result) => {
                    if (result.isConfirmed) {
                    	
                    	var newCommentsHTML = '';
                    	newCommentsHTML +=	response.data.userIntro;
                    	document.getElementById("userIntroChange").innerHTML = newCommentsHTML;
                    	
                    	document.getElementById("userDegree").value = response.data.userDegree;
                        document.getElementById("userCareer").value = response.data.userCareer;
                    	document.getElementById("modal-profile").classList.remove("flip");
                    }
                });
            } else if (response.code == 500) {
                Swal.fire({
                    title: '수정 중 오류가 발생했습니다.',
                    icon: 'error',
                    confirmButtonText: '확인',
                    confirmButtonColor: '#3085d6',
                });
            }
        },
        error: function(xhr, status, error) {
            Swal.fire({
                title: '서버와 연결할 수 없습니다.',
                icon: 'error',
                confirmButtonText: '확인',
                confirmButtonColor: '#3085d6',
            });
        }
    });
}

</script>

<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<div class="teach-img">
	<div>
		<img alt="" src="/resources/images/teacher/${teacher.userId }.png">
	</div>
</div>
<div class="teach-info">
	<div>${className } ${teacher.userName } 선생님
		<button type="button" class="Profile" onclick="fn_modal()">Profile +</button>
	</div>
	<div id="userIntroChange">
		${teacher.userIntro }
	</div>
	<div class="teach-notice">
		<h2 class="left-title subTitle">새소식</h2>
		<h2 class="right-title subTitle"  onclick="fn_pageMove()" style="cursor: pointer;">더보기 +</h2>
		<table class="title-notice-table">
			<thead>
				<tr>
					<th style="width: 15%;"></th>
					<th style="width: 85%;"></th>
				</tr>
			</thead>
			<tbody>

	 <!-- 공지사항 출력 -->
	    <c:forEach var="notice" items="${teacherNotice}" varStatus="status">
	        <tr>
	            <td><div class="new-notice">공지</div></td>
	            <td>
	            <a style="color: black;" href="javascript:void(0)" onclick="fn_noticeMove(${notice.brdSeq}, ${notice.courseCode })">
	            ${notice.brdTitle}</a>
	            </td> <!-- 공지사항 제목 출력 -->
	        </tr>
	    </c:forEach>
	
	    <!-- 공백 행 추가 -->
	    <c:if test="${fn:length(teacherNotice) < 5}">
	        <c:forEach var="i" begin="1" end="${5 - fn:length(teacherNotice)}">
	            <tr>
	                <td><div class="new-notice">공지</div></td>
	                <td>&nbsp;</td> <!-- 공백 -->
	            </tr>
	        </c:forEach>
	    </c:if>	
	    
		
		
			</tbody>
		</table>
	</div>
	
	<!-- 모달 영역 -->
	<div id="modal-profile" class="modal-profile">
		<div class="modal-content-front">
		  <div class="h2">${className } ${teacher.userName } 선생님 프로필</div>
		  <span id="close-btn" class="close-btn">&times;</span>
		  <div class="h3">선생님 학력</div>
		  <div class="p">
		  	<textarea class="Tpw" id="userDegree" name="title" rows="3" cols="50" readonly>${teacher.userDegree }</textarea>
		  </div>
		  <div class="h3">선생님 경력</div>
		  <div class="p">
		  	<textarea class="Tpw" id="userCareer" name="title" rows="3" cols="50" readonly>${teacher.userCareer}</textarea>
		  </div>
		  <c:if test="${teacher.userId eq user.userId }">
		  	<button type="button" class="profile-edit-btn" onclick="fn_profile()">강사정보수정</button>
		  </c:if>
		</div>

		<div class="modal-content-back">
			<form id="profileForm"> 
				<div class="h3">선생님 학력</div>
				  <div class="p">
				  	<textarea class="Tpw" id="userDegree" name="userDegree" rows="4" cols="50">${teacher.userDegree }</textarea>
				  </div>
				<div class="h3">선생님 경력</div>
				  <div class="p">
				  	<textarea class="Tpw" id="userCareer" name="userCareer" rows="4" cols="50">${teacher.userCareer}</textarea>
				  </div>
				<div class="h3">인트로</div>
				  	<input type="text" id="userIntro" class="Tpw" name="userIntro" value="${teacher.userIntro }">
				  <div class="msg_box">
					<span class="info_msg" id="userIntroMsg"></span>
				  </div>
				  <div class="button-container">
				  	<button type="button" class="profile-cel-btn" onclick="fn_profileCel()">취소</button>
				  	<button type="button" class="profile-updt-btn" onclick="fn_profileUpdt()">수정</button>
				  </div>
			  </form>
		</div>
	</div>
	
</div>