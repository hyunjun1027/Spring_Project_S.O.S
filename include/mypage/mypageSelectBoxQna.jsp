<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!-- 강좌 선택 버튼 UI 추가 -->
<div class="tab-container">
    <div class="tab ${type == 'teacher' ? 'tab active' : 'tab'}" id="teacher-tab" onclick="fn_qnalist('teacher')">선생님 Q&A</div>
    <div class="tab ${type == 'student' ? 'tab active' : 'tab'}" id="student-tab" onclick="fn_qnalist('student')">1:1 QNA</div>
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
/*     const tabs = document.querySelectorAll('.tab');

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // 모든 탭에서 active 클래스 제거
            tabs.forEach(t => t.classList.remove('active'));
            
            // 클릭한 탭에 active 클래스 추가
            tab.classList.add('active');
        });
    }); */
    
   // 탭 클릭 시 활성화 상태 변경
    const tabs = document.querySelectorAll('.tab');  // 모든 탭을 가져옴
    const teacherContent = document.getElementById('teacher-content'); // 선생님 Q&A 콘텐츠
    const studentContent = document.getElementById('student-content'); // 1:1 Q&A 콘텐츠

    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // 모든 탭에서 active 클래스 제거
            tabs.forEach(t => t.classList.remove('active'));

            // 클릭한 탭에 active 클래스 추가
            tab.classList.add('active');

            // 탭에 따라 보이는 콘텐츠 변경
            if (tab.id === 'teacher-tab') {
                teacherContent.style.display = 'block';
                studentContent.style.display = 'none';
            } else if (tab.id === 'student-tab') {
                teacherContent.style.display = 'none';
                studentContent.style.display = 'block';
            }
        });
    });

</script>