<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 강좌 선택 버튼 UI 추가 -->
<div class="tab-container">
   <div class="tab ${type == 'sent' ? 'tab active' : 'tab'}" onclick="fn_notelist('sent')" id="sent-tab">보낸 쪽지</div>
   <div class="tab ${type == 'get' ? 'tab active' : 'tab'}" onclick="fn_notelist('get')" id="received-tab">받은 쪽지</div>
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
// 탭 클릭 시 활성화 상태 변경
const tabs = document.querySelectorAll('.tab');  // 모든 탭을 가져옴

tabs.forEach(tab => {
    tab.addEventListener('click', () => {
        // 모든 탭에서 active 클래스 제거
        tabs.forEach(t => t.classList.remove('active'));

        // 클릭한 탭에 active 클래스 추가
        tab.classList.add('active');

        // 보낸 쪽지와 받은 쪽지 내용을 표시하거나 숨김
        const sentContent = document.getElementById('sent-content'); // 보낸 쪽지
        const receivedContent = document.getElementById('received-content'); // 받은 쪽지

        // 탭에 따라 보낸 쪽지 또는 받은 쪽지 보여주기
        if (tab.id === 'sent-tab') {
            sentContent.style.display = 'block';
            receivedContent.style.display = 'none';
        } else if (tab.id === 'received-tab') {
            sentContent.style.display = 'none';
            receivedContent.style.display = 'block';
        }
    });
});
</script>