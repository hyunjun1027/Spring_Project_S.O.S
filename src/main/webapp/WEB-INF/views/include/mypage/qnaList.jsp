<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/mypage/writeList.css" rel="stylesheet">

<div class="contentBoardContainer">
	<div class="board-header">
	  <h2 class="first-title">나의 Q&A</h2>
	
	<%@ include file="/WEB-INF/views/include/mypage/mypageSelectBoxQna.jsp"%>
	  
	</div>
  
  <div class="board-content">
    <table class="board-table">
      <thead>
        <tr>
          <th>선택</th>
          <th>제목</th>
          <th>작성자</th>
          <th>작성일</th>
          <th>답변상태</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><input type="checkbox"></td>
          <td>질문있습니다1</td>
          <td>user3</td>
          <td>2024.11.30</td>
          <td>미답변</td>
        </tr>
        <tr>
          <td><input type="checkbox"></td>
          <td>질문있습니다2</td>
          <td>user2</td>
          <td>2024.11.29</td>
          <td>답변완료</td>
        </tr>
        <tr>
          <td><input type="checkbox"></td>
          <td>질문있습니다3</td>
          <td>user3</td>
          <td>2024.11.28</td>
          <td>답변완료</td>
        </tr>
        <tr>
          <td><input type="checkbox"></td>
          <td>질문있습니다4</td>
          <td>user3</td>
          <td>2024.11.28</td>
          <td>답변완료</td>
        </tr>
        <tr>
          <td><input type="checkbox"></td>
          <td>질문있습니다5</td>
          <td>user3</td>
          <td>2024.11.28</td>
          <td>답변완료</td>
        </tr>
      </tbody>
    </table>
  </div>

  <div class="board-footer">
  	<div class="choose-all">
	    <div class="select-all-container">
			<input type="checkbox" id="select-all" />
			<label for="select-all">전체 선택</label>
	  	</div>
  	</div>
    <button class="delete-btn">삭제</button>
  </div>
  
   <div class="pagination">
     <button class="page-btn">1</button>
     <button class="page-btn">2</button>
     <button class="page-btn">3</button>
   </div>
    
  
</div>
