<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 강좌 선택 버튼 UI 추가 -->
<div class="tab-container">
	<div class="tab ${type == 'recent' ? 'active' : ''}" id="recent-tab" onclick="fn_studyList('recent')">최신 수강순</div>
	<div class="tab ${type == 'teach' ? 'active' : ''}" id="teach-tab" onclick="fn_studyList('teach')">강사 이름순</div>
</div>

<style>
.tab-container {
	display: flex;
	border-radius: 2px;
	overflow: hidden;
}

.tab {
	padding: 12px 0;
	cursor: pointer;
	background-color: #222;
	color: white;
	text-align: center;
	font-size: 18px;
	font-weight: 550;
	flex: 1;
	transition: background-color 0.3s, color 0.3s;
}

.tab.active {
	background-color: white;
	color: #222;
}
</style>

<script>
    const tabs = document.querySelectorAll('.tab');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // 모든 탭에서 active 클래스 제거
            tabs.forEach(t => t.classList.remove('active'));
            
            // 클릭한 탭에 active 클래스 추가
            tab.classList.add('active');
        });
    });
</script>