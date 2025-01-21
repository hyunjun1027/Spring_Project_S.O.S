<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/mypage/saveList.css" rel="stylesheet">

<script>
$(document).ready(function() {
	function toggleBookmark(element) {
		  element.classList.toggle("active");
		}
}
</script>

<div class="contentBoardContainer">
	<div class="board-header">
	  <h2 class="first-title">내가 저장한 글</h2>
	  <div class="board-stats">
	    총 게시글 
	    <strong><span class="stats-highlight"> 4개</span></strong>

		  <select class="dropdown-btn">전체 <span class="triangle"> ▼</span>
		  <ul class="dropdown-menu">
		    <option value="all">전체</option>
		    <option value="korean">국어</option>
		    <option value="english">영어</option>
		    <option value="math">수학</option>
		    <option value="society">사회</option>
		    <option value="science">과학</option>
		    <option value="history">역사</option>
		  </ul>
		  </select>
		  
	  </div>
	  
	</div>
  
  <div class="board-content">
    <table class="board-table">
      <thead>
        <tr>
          <th>선택</th>
          <th>제목</th>
          <th>작성자</th>
          <th>작성일</th>
          <th>조회수</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><div class="bookmark"></div></td>
          <td>게시글 제목1</td>
          <td>user1</td>
          <td>2024.11.30</td>
          <td>10</td>
        </tr>
        <tr>
          <td><div class="bookmark"></div></td>
          <td>게시글 제목2</td>
          <td>user2</td>
          <td>2024.11.29</td>
          <td>25</td>
        </tr>
        <tr>
          <td><div class="bookmark"></div></td>
          <td>게시글 제목3</td>
          <td>user3</td>
          <td>2024.11.28</td>
          <td>40</td>
        </tr>
        <tr>
          <td><div class="bookmark"></div></td>
          <td>게시글 제목4</td>
          <td>user3</td>
          <td>2024.11.28</td>
          <td>30</td>
        </tr>
        <tr>
          <td><div class="bookmark"></div></td>
          <td>게시글 제목5</td>
          <td>user3</td>
          <td>2024.11.28</td>
          <td>28</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="board-footer">

    <button class="delete-btn">삭제</button>
  </div>
  
   <div class="pagination">
     <button class="page-btn">1</button>
     <button class="page-btn">2</button>
     <button class="page-btn">3</button>
   </div>
    
  
</div>
