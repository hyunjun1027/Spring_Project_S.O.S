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

<link href="/resources/css/mypage/mypageStudyList.css" rel="stylesheet">
<script>
// top bar 선택 시
function fn_studyList(type) {
	if(type == 'recent') {
		document.bbsForm.type.value = "recent";
		document.bbsForm.curPage.value = "1";
		document.bbsForm.action = "/user/studyList";
		document.bbsForm.submit();
	} else if(type == 'teach') {
		document.bbsForm.type.value = "teach";
		document.bbsForm.curPage.value = "1";
		document.bbsForm.action = "/user/studyList";
		document.bbsForm.submit();
	}
}

// 코스 상세보기 이동
function fn_coursePage(courseCode, classCode) {
    document.bbsForm.classCode.value = classCode;
    document.bbsForm.courseCode.value = courseCode;
    document.bbsForm.action = "/course/courseMain";
    document.bbsForm.submit();
}

// 강사 페이지 이동
function fn_teachMove(teacherId, classCode) {
	document.bbsForm.classCode.value = classCode;
	document.bbsForm.teacherId.value = teacherId;
	document.bbsForm.action = "/teach/teachPage";
	document.bbsForm.submit(); 
}

//페이지 이동
function fn_listView(curPage) {
	document.bbsForm.type.value = "${type}";
	document.bbsForm.curPage.value = curPage;
    document.bbsForm.action = "/user/studyList";
    document.bbsForm.submit();
}

$(function() {
	//전체 선택
	$("#cbx_chkAll").click(function() {
		if($("#cbx_chkAll").is(":checked")) $("input[name=chk]").prop("checked", true);
		else $("input[name=chk]").prop("checked", false);
	});

	$("input[name=chk]").click(function() {
		var total = $("input[name=chk]").length;
		var checked = $("input[name=chk]:checked").length;
		
		if(total != checked) $("#cbx_chkAll").prop("checked", false);
		else $("#cbx_chkAll").prop("checked", true); 
	});
	
	// 수강 취소 버튼 클릭 시
	$('#cancelBtn').on('click', function() {
	    const selectedCourseCodes = $('input[name="chk"]:checked').map(function() {
	        return $(this).val();
	    }).get();

	    $.ajax({
	        url: '/user/cancelCourse',
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify(selectedCourseCodes),
	        success: function(res) {
				if(res.code == 0)
                    Swal.fire({
                        title: "선택한 강의(들)이 취소되었습니다.",
                        text: res.msg,
                        icon: "success"
                    }).then(() => {
                    	location.reload();
                    });
				else {
                    Swal.fire({
                        title: "수강 취소 불가!",
                        text: res.msg,
                        icon: "error"
                    }).then(() => {
                    	location.reload();;
                    });
				}
	        },
	        error: function(err) {
	        	
                Swal.fire({
                    title: "오류!",
                    text: "에러 발생: " + err.statusText,
                    icon: "error"
                });
	        }
	    });
	});
	
});
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<div class="container">
		<%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>

		<div class="rightBox contentContainer">
			<div class="contentBoardContainer">
				<div class="title-div">
					<h2 class="first-title">수강 중 강좌</h2>
				</div>
				<div class="studyListContainer">
					<div class="mypage-selectBtn-box">
						<%@ include file="/WEB-INF/views/include/mypage/mypageSelectBox.jsp"%>
					</div>
				</div>
				<div class="subjectClassList">
					<div>
						<label class="checkbox-label"> <input type="checkbox" id="cbx_chkAll" class="custom-checkbox"> <span>전체 선택</span>
						</label>
					</div>

					<c:forEach var="course" items="${course}" varStatus="status">
						<div class="subjectClassItem">
							<div class="lecture-checkbox">
								<input type="checkbox" name="chk" value="${course.courseCode }" class="custom-checkbox" />
							</div>
							<div>
								<img src="/resources/images/teacher/${course.userId }.png" class="teacher-photo">
							</div>
							<div>
								<div onclick="fn_teachMove('${course.userId}', ${course.classCode })" style="cursor: pointer; width: 200px;">
									<span class="teach-subject">[${course.className }]</span> <span class="teach-name">${course.userName }</span> 선생님 🏠
								</div>
								<div class="middle-container">
									<span class="teach-subject-title" onclick="fn_coursePage(${course.courseCode}, ${course.classCode })" style="cursor: pointer;">${course.courseName }</span>
								</div>
								<div>
									나의 학습 진도율<span style="margin-left: 100px; margin-right: 10px;">${course.finLecCnt }/${course.lecCnt }강</span><span class="my-ing">[${course.progress }% 달성]</span>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
				<div class="rightBottomBtn">
					<button type="button" id="cancelBtn" class="inputBtn">
						<span id="cancelBtn">수강 취소</span>
					</button>
				</div>
				<div class="pagingContainer">
					<ul class="pagination">
						<c:if test="${!empty paging}">
							<c:if test="${paging.prevBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${paging.prevBlockPage})"> < </a></li>
							</c:if>
							<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
								<c:choose>
									<c:when test="${i ne curPage}">
										<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${i})">${i}</a></li>
									</c:when>
									<c:otherwise>
										<li class="page-item active"><a class="page-link" href="#" style="cursor: default;">${i}</a></li>
									</c:otherwise>
								</c:choose>
							</c:forEach>
							<c:if test="${paging.nextBlockPage gt 0}">
								<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(${paging.nextBlockPage})"> > </a></li>
							</c:if>
						</c:if>
					</ul>
				</div>
			</div>
		</div>
	</div>

	<form id="bbsForm" name="bbsForm" method="post">
		<input type="hidden" name="type" value="">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="searchType" value="${searchType}">
		<input type="hidden" name="searchValue" value="${searchValue}">
		<input type="hidden" name="curPage" value="${curPage}">
		<input type="hidden" name="courseCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
</body>

<script>
/* document.querySelector('#checkAll');

checkAll.addEventListener('click', function(){
    const isChecked = checkAll.checked;

    if(isChecked){
        const checkboxes = document.querySelectorAll('.custom-checkbox');
        for(const checkbox of checkboxes){
            checkbox.checked = true;
        }
    }
    else{
        const checkboxes = document.querySelectorAll('.custom-checkbox');
        for(const checkbox of checkboxes){
            checkbox.checked = false;
        }
    }
})

const checkboxes = document.querySelectorAll('.custom-checkbox');
for(const checkbox of checkboxes){
	checkbox.addEventListener('click',function(){
		const totalCnt = checkboxes.length;
		const checkedCnt = document.querySelectorAll('.custom-checkbox:checked').length;
  
		if(totalCnt == checkedCnt){
			document.querySelector('#checkAll').checked = true;
		}
		else{
			document.querySelector('#checkAll').checked = false;
		}
	});
} */


const tabs2 = document.querySelectorAll('.tab2');

tabs2.forEach(tab2 => {
    tab2.addEventListener('click', () => {
        // 모든 탭에서 active 클래스 제거
        tabs2.forEach(t2 => t2.classList.remove('active2'));
        
        // 클릭한 탭에 active 클래스 추가
        tab2.classList.add('active2');
    });
});
</script>
</html>