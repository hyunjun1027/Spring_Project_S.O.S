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

<link href="/resources/css/mypage/mypageNoteView.css" rel="stylesheet">

<script>

function fn_noteDel(noteSeq)
{
    Swal.fire({
        title: "쪽지를 삭제하시겠습니까?",
        text: "삭제하면 되돌릴 수 없습니다!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "삭제",
        cancelButtonText: "취소"
    }).then((result) => {
        if (result.isConfirmed) {
            // AJAX 요청
            $.ajax({
				type:"POST",
				url:"/user/noteDel",
				data:{
					noteSeq:noteSeq
				},
				dataType:"JSON",
				beforeSend:function(xhr)
				{
					xhr.setRequestHeader("AJAX", "true");
				},
				success:function(response)
				{
                    if (response.code == 0) {
                        Swal.fire({
                            title: "삭제 완료!",
                            text: "쪽지가 삭제되었습니다.",
                            icon: "success"
                        }).then(() => {
        					document.bbsForm.type.value="${type}";
        					document.bbsForm.action = "/user/noteList";
        					document.bbsForm.submit();
                        });
                    } else if (response.code == -110) {
                        Swal.fire({
                            title: "Error",
                            text: "삭제 중 오류발생.",
                            icon: "error"
                        });
                    } else if (response.code == -10) {
                        Swal.fire({
                            title: "Error",
                            text: "이미 삭제된 게시물입니다.",
                            icon: "error"
                        });
                    } else if (response.code == 401) {
                        Swal.fire({
                            title: "Error",
                            text: "값을 입력하세요.",
                            icon: "error"
                        });
                    } else if (response.code == 100) {
                        Swal.fire({
                            title: "Error",
                            text: "로그인을 먼저 진행하세요.",
                            icon: "error"
                        });
                    }
                    
                },
                error: function(xhr, status, error) {
    				icia.common.error(error);
    	            Swal.fire({
                        title: "Error",
                        text: "쪽지 삭제중 중 오류가 발생하였습니다.",
                        icon: "error"
                    });
    				$("#deleteBtn").prop("disabled", false);
                }
            });
        }
    });
	

}

$(document).ready(function(){
	
	//목록버튼 클릭
	$("#listBtn").on("click", function(){
		document.bbsForm.type.value="${type}";
		document.bbsForm.action="/user/noteList";
		document.bbsForm.submit();
	});
	
	
});

</script>


</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

	<c:if test="${type =='sent'}">
		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div board-header">
					<h2 class="first-title">보낸 쪽지</h2>
				</div>
			</div>

			<div class="textContainer">
				<strong><span class="stats-highlight">받는 사람</span> : ${note.userNameGet }<c:if test="${note.ratingGet == 'T' }"> 선생님</c:if> (${note.userIdGet})	</strong> <strong><span class="stats-highlight">보낸 시간</span> : ${note.regDate }</strong>
			</div>

			<div class="note-content">${note.noteContent}</div>

			<div class="btnContainer">
				<button type="button" id="deleteBtn" class="inputBtn" onclick="fn_noteDel(${note.noteSeq})">
					<span>삭제</span>
				</button>
				<button type="button" id="listBtn" class="inputBtn">
					<span>목록</span>
				</button>
			</div>
		</div>
	</c:if>	
		
	<c:if test="${type =='get'}">
		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div board-header">
					<h2 class="first-title">받은 쪽지</h2>
				</div>
			</div>

			<div class="textContainer">
				<strong><span class="stats-highlight">보낸 사람</span> : ${note.userName }<c:if test="${note.rating == 'T' }"> 선생님</c:if> (${note.userId})	</strong> <strong><span class="stats-highlight">보낸 시간</span> : ${note.regDate }</strong>
			</div>

			<div class="note-content">${note.noteContent}</div>

			<div class="btnContainer">
				<button type="button" id="writeBtn" class="inputBtn" onclick="fn_pageMove('noteWrite')">
					<span>답장</span>
				</button>
				<button type="button" id="deleteBtn" class="inputBtn" onclick="fn_noteDel(${note.noteSeq})">
					<span>삭제</span>
				</button>
				<button type="button" id="listBtn" class="inputBtn">
					<span>목록</span>
				</button>
			</div>
		</div>
	</c:if>	
		
		
	<form id="bbsForm" name="bbsForm" method="post">
		<input type="hidden" name="noteSeq" value="${noteSeq}" />
		<input type="hidden" name="curPage" value="${curPage}" />
		<input type="hidden" name="type" value="" />
	</form>
		

	</div>
</body>
</html>