<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/prevQueList.css" rel="stylesheet">
<style>
	.header{
		background-color: rgba(0, 0, 0, 0.0);
	}
</style>


</head>
<body>
<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
    
    <section class="notice-section">
       <div class="notice-content">
           <div class="notice-text">
               <h1 class="mainTitle">A Previous Question</h1>
               <p class="mainContent">기출문제</p>
           </div>
           <div class="notice-image">
               <img src="/resources/img/Clover.png" alt="Clover Image">
           </div>
       </div>
   </section>

    <section class="content-section">
        <div class="sidebar">
            <div class="exam-date">2026 수능 <span class="days">D-287</span></div>
            <ul class="menu">
                <li><a href="#">모의고사</a></li>
<!--                 <li>
                   <a href="#" class="highlight">기출문제</a><br>
                   <a href="#">대학수학능력시험</a><br>
                   <a href="#">수능(2004년 이전)</a><br>
                   <a href="#">수능 모의평가</a><br>
                </li> -->
            </ul>
            <ul class="menu2">
            	<li><a href="#" class="highlight">기출문제</a></li>
                <li><a href="#">대학수학능력시험</a></li>
                <li><a href="#">수능(2004년 이전)</a></li>
                <li><a href="#">수능 모의평가</a></li>
            </ul>
        </div>
        <div class="table-container">
            <h2 class="subTitle">기출문제</h2>
            <table>
                <thead>
                    <tr>
                        <th>번호</th>
                        <th>학년도</th>
                        <th>영역</th>
                        <th>제목</th>
                        <th>등록일</th>
                        <th>조회</th>
                        <th>파일</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>국어</td>
                        <td>문제 및 정답</td>
                        <td>2024.11.18</td>
                        <td>24444</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>수학</td>
                        <td>문제 및 정답</td>
                        <td>2024.11.18</td>
                        <td>24444</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>영어</td>
                        <td>문제 및 정답</td>
                        <td>2024.12.02</td>
                        <td>181818</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>영어</td>
                        <td>문제 및 정답</td>
                        <td>2024.12.02</td>
                        <td>181818</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>영어</td>
                        <td>문제 및 정답</td>
                        <td>2024.12.02</td>
                        <td>181818</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>영어</td>
                        <td>문제 및 정답</td>
                        <td>2024.12.02</td>
                        <td>181818</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <tr>
                        <td>508372</td>
                        <td>2025</td>
                        <td>영어</td>
                        <td>문제 및 정답</td>
                        <td>2024.12.02</td>
                        <td>181818</td>
                        <td><a href="#">📄</a></td>
                    </tr>
                    <!-- Add more rows as needed -->
                </tbody>
            </table>
            <div>
           <ul class="pagination pagination-sm">
             <li class="page-item disabled">
               <a class="page-link" href="#">&laquo;</a>
             </li>
             <li class="page-item active">
               <a class="page-link" href="#">1</a>
             </li>
             <li class="page-item">
               <a class="page-link" href="#">2</a>
             </li>
             <li class="page-item">
               <a class="page-link" href="#">3</a>
             </li>
             <li class="page-item">
               <a class="page-link" href="#">4</a>
             </li>
             <li class="page-item">
               <a class="page-link" href="#">5</a>
             </li>
             <li class="page-item">
               <a class="page-link" href="#">&raquo;</a>
             </li>
           </ul>
         </div>
         
         <div class="search-container">   
	      <select class="form-select">
	        <option>제목</option>
	        <option>1</option>
	        <option>2</option>
	        <option>3</option>
	        <option>4</option>
	        <option>5</option>
	      </select>
	       <div class="input-select">
	         <input type="text" class="form-control" placeholder="검색할 단어를 입력하세요." aria-label="Recipient's username" aria-describedby="button-addon2">
	         <button type="button" id="btnSearch" style="cursor: pointer"><img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;"></button>
	       </div>
   		</div>
        </div>
    </section>
    
    <%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
    
</body>
</html>
