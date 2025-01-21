<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/mypage/studyList.css" rel="stylesheet">

<div class="contentBoardContainer">
	<div class="title-div">
		<h2 class="first-title">수강 중 강좌</h2>
	</div>
	<div class="studyListContainer">
		<div class="mypage-selectBtn-box">
			<%@ include file="/WEB-INF/views/include/mypage/mypageSelectBox.jsp"%>

			<div class="tab-container2">
				<div class="tab2 active2" id="recent-tab">최신 수강순</div>
				<div class="tab2" id="new-tab">신규 강좌순</div>
				<div class="tab2" id="teach-tab">선생님순</div>
			</div>
		</div>
	</div>
	<div class="subjectClassList">
		<div>
			<label class="checkbox-label">
				<input type="checkbox" id="checkAll" class="custom-checkbox"> <span>전체 선택</span>
			</label>
		</div>

		<div class="subjectClassItem">
			<div>
				<input type="checkbox" class="custom-checkbox">
			</div>
			<div>
				<img src="/resources/images/default-profile.jpg" class="profile-photo">
			</div>
			<div>
				<div>
					<span class="teach-subject">[국어]</span> <span class="teach-name">류신</span> 선생님 🏠
				</div>
				<div class="middle-container">
					<span class="teach-subject-title">2025 수능특강 문학 [연계빨]</span>
				</div>
				<div>
					나의 학습 진도율<span style="margin-left: 100px;">0/15강</span><span class="my-ing">[0% 달성]</span>
				</div>
			</div>
		</div>
		<div class="subjectClassItem">
			<div>
				<input type="checkbox" class="custom-checkbox">
			</div>
			<div>
				<img src="/resources/images/default-profile.jpg" class="profile-photo">
			</div>
			<div>
				<div>
					<span class="teach-subject">[국어]</span> <span class="teach-name">류신</span> 선생님 🏠
				</div>
				<div class="middle-container">
					<span class="teach-subject-title">2025 수능특강 문학 [연계빨]</span>
				</div>
				<div>
					나의 학습 진도율<span style="margin-left: 100px;">0/15강</span><span class="my-ing">[0% 달성]</span>
				</div>
			</div>
		</div>
		<div class="subjectClassItem">
			<div>
				<input type="checkbox" class="custom-checkbox">
			</div>
			<div>
				<img src="/resources/images/default-profile.jpg" class="profile-photo">
			</div>
			<div>
				<div>
					<span class="teach-subject">[국어]</span> <span class="teach-name">류신</span> 선생님 🏠
				</div>
				<div class="middle-container">
					<span class="teach-subject-title">2025 수능특강 문학 [연계빨]</span>
				</div>
				<div>
					나의 학습 진도율<span style="margin-left: 100px;">0/15강</span><span class="my-ing">[0% 달성]</span>
				</div>
			</div>
		</div>
	</div>
	<div class="rightBottomBtn">
		<button type="button" id="cancelBtn" class="inputBtn" onclick="fn_cancel()"><span id="cancelBtn">수강 취소</span></button>
	</div>
	<div class="pagingContainer">
		<ul class="pagination">
			<li class="page-item"><a class="page-link" href="#" onclick="fn_listView()"> <
			</a></li>
			<li class="page-item"><a class="page-link" href="#" onclick="fn_listView(1)">1</a></li>

			<li class="page-item active"><a class="page-link" href="#" style="cursor: default;">2</a></li>

			<li class="page-item"><a class="page-link" href="#" onclick="fn_listView()"> >
			</a></li>

		</ul>
	</div>
</div>

<script>
document.querySelector('#checkAll');

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
}


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
