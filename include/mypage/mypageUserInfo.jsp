<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- Tag Library -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<script type="text/javascript">
$(function() {
	let photo_path = $('.profile-photo').attr('src');
	    let my_photo; //회원이 업로드할 이미지 담을 변수
	    $('#userFile').change(function(){
	    	// 새로운 프로필 이미지가 담기면 my_photo에 저장
	        my_photo = this.files[0];
	    	var formData = new FormData();
	    	formData.append("file", my_photo);
	    	
	        if(!my_photo){
	            $('.profile-photo').attr('src', photo_path);
	            return
	        }
	        if(my_photo.size > 1024*1024){
	            alert(Math.round(my_photo.size/1024/1024) + 'MB(1MB까지만 업로드 가능)');
	            $('.profile-photo').attr('src',photo_path);
	            $(this).val('');
	            return;			
	        }
	        fn_profileUpload(formData)
	        //이미지 미리보기 처리
	        let reader = new FileReader();
	        reader.readAsDataURL(my_photo);

	        reader.onload = function(){
	            $('.profile-photo').attr('src', reader.result);
	        };
	    }); 
});

function fn_pageMove(url) {
	location.href = url;
}

function fn_profileUpload(formData){
	$.ajax({
		type:"POST",
		url:"/user/profileUpload",
		data : formData,
		processData:false,
		contentType:false,
		cache:false,
    	timeout:600000,
    	beforeSend:function(xhr){
    		xhr.setRequestHeader("AJAX", "true");
    	},
    	success:function(res){
    		if(res.code == 0){
    			alert("프로필 사진이 변경되었습니다.");
    		}
    		else{
    			alert("[" + res.code + "] : " + res.msg);
    		}
    	},
    	error:function(xhr, status, error){
			icia.common.error(error);
		}
	});
}

// 강사페이지 이동
function fn_teachMove(teacherId, classCode, url) {
	document.teacherTypeForm.classCode.value = classCode;
	document.teacherTypeForm.teacherId.value = teacherId;
	document.teacherTypeForm.action = "/teach/" + url;
	document.teacherTypeForm.submit(); 
}

// 비밀번호 확인
async function fn_withdrawPw() {
    console.log("비밀번호 확인 시작");


    const { value: userPwd } = await Swal.fire({
        title: "비밀번호를 입력하세요",
        input: "password",
        inputLabel: "비밀번호",
        inputPlaceholder: "비밀번호를 입력하세요",
        inputAttributes: {
            maxlength: "20",
            autocapitalize: "off",
            autocorrect: "off"
        },
        showCancelButton: true, 
        confirmButtonText: '확인',
        cancelButtonText: '취소'
    });

    console.log("입력된 비밀번호:", userPwd);

    if (userPwd) {
    	
    	$.ajax({
			type : "POST",
			url : "/user/pwdCheckProc",
			data : {
				userPwd : userPwd
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
                    	fn_withdraw();
                    });
					
				}
				else {
					
                    Swal.fire({
                        title: "오류!",
                        text: response.msg,
                        icon: "error"
                    });
					
				}
			},
			error : function(xhr, status, error) {
				alert("오류발생...");
				icia.common.error(error);
			}
		});
    }
}

function fn_withdraw(){
	if(confirm("정말 탈퇴하시겠습니까?")){
	$.ajax({
		type : "POST",
		url : "/user/withdraw",
		dataType : "JSON",
		beforeSend : function(xhr) {
			xhr.setRequestHeader("AJAX", "true");
		},
		success : function(response) {
			if (response.code == 0) {
                Swal.fire({
                    title: "회원탈퇴가 완료되었습니다.",
                    icon: "success"
                }).then(() => {
                	location.href = "/";
                });
				
			} else {
				
                Swal.fire({
                    title: "오류!",
                    text: response.msg,
                    icon: "error"
                });
				return;
			}
		},
		error : function(xhr, status, error) {
			alert("오류발생...");
			icia.common.error(error);
		}
	});
	}
	else{
		
	}
}

</script>

<div class="leftBox userInfoContainer">
	<div class="userTopContainer">
		<div class="userFileContainer">
			<!--프로필사진-->
			<label for="userFile"> <c:choose>
					<c:when test='${empty user.userProfile }'>
						<img src="/resources/images/default-profile.jpg" class="profile-photo">
					</c:when>
					<c:otherwise>
							<img src="/resources/profile/${user.userProfile}"onerror="this.src='/resources/images/default-profile.jpg'"  class="profile-photo">
					</c:otherwise>
				</c:choose>
			</label>
			<input type="file" id="userFile" name="userFile" class="leftBox" accept="image/gif, image/png, image/jpeg" style="display: none;">
		</div>
		<div class="userNameContainer">
			<h3>${user.userName }</h3>
		</div>
		<div class="infoContainer">
			<div class="cntBox">
				<div onclick="fn_pageMove('/user/noteList')">
					<a href=#>쪽지</a>&nbsp;&nbsp;<span>${noteCnt}</span>
				</div>
			</div>
			<div class="cntBox">
			<c:if test="${user.rating == 'U' }">
				<div onclick="fn_pageMove('/user/qnaList')">
					<a href=#>Q&A</a>&nbsp;&nbsp;<span>${qnaCount }</span>
				</div>
			</c:if>
			<c:if test="${user.rating == 'T' }">
				<div onclick="fn_teachMove('${user.userId}', ${user.classCode }, 'teachQna')">
					<a href=#>Q&A</a>&nbsp;&nbsp;<span>${qnaCount }</span>
				</div>
			</c:if>
			</div>
			<div class="cntBox">
				<div onclick="fn_pageMove('/user/paymentHistory')">
					<a href=#>미결제</a>&nbsp;&nbsp;<span>${noPayCnt }</span>
				</div>
			</div>
			<div class="cntBox">
				<div onclick="fn_pageMove('/order/basket')">
					<a href=#>장바구니</a>&nbsp;&nbsp;<span>${cartCount }</span>
				</div>
			</div>
		</div>
	</div>

	<div class="userBottomContainer">
		<div class="menuList">
			<ul>
				<li><span>내 강의실</span>
					<ul>
						<c:if test="${user.rating == 'U' }">
							<li><a href=# onclick="fn_pageMove('/user/studyList')">수강중 강좌</a></li>
						</c:if>
						<c:if test="${user.rating == 'T' }">
							<li><a href=# onclick="fn_teachMove('${user.userId}', ${user.classCode }, 'teachPage')">내 강의실</a></li>
						</c:if>
					</ul></li>
				<li><span>내 글</span>
					<ul>
						<li><a href=# onclick="fn_pageMove('/user/writeList')">내가 쓴 글</a></li>
						<li><a href=# onclick="fn_pageMove('/user/saveList')">내가 저장한 글</a></li>
					</ul></li>
				<li><span>주문 · 결제</span>
					<ul>
						<li><a href=# onclick="fn_pageMove('/order/basket')">장바구니</a></li>
						<li><a href=# onclick="fn_pageMove('/user/paymentHistory')">주문/배송 조회</a></li>
					</ul></li>
				<li><span>나의 정보</span>
					<ul>
						<c:choose>
							<c:when test="${user.rating == 'U' }">
								<c:if test="${empty user.loginType }">
									<li><a href=# onclick="fn_pageMove('/user/pwdCheck1')">비밀번호 변경</a></li>
									<li><a href=# onclick="fn_pageMove('/user/pwdCheck2')">회원정보 수정</a></li>
									<li><a href=# onclick="fn_withdrawPw()">회원탈퇴</a></li>
								</c:if>
								<c:if test="${!empty user.loginType }">
									<li><a href=# onclick="fn_pageMove('/user/updateForm')">회원정보 수정</a></li>
								</c:if>
							</c:when>
							<c:otherwise>
								<li><a href=# onclick="fn_pageMove('/user/pwdCheck1')">비밀번호 변경</a></li>
								<li><a href=# onclick="fn_pageMove('/user/pwdCheck2')">회원정보 수정</a></li>
								<li><a href=# onclick="fn_withdrawPw()">회원탈퇴</a></li>
							</c:otherwise>
						</c:choose>
					</ul></li>
			</ul>
		</div>
	</div>
</div>

<form id="teacherTypeForm" name="teacherTypeForm" method="post">
	<input type="hidden" name="classCode" value="">
	<input type="hidden" name="courseCode" value="">
	<input type="hidden" name="teacherId" value="">
	<input type="hidden" name="curPage" value="">
</form>
