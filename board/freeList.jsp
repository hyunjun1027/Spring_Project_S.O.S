<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/freeList.css" rel="stylesheet">
<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.4.0/p5.js"></script>
<style>
.header {
	background-color: #DDC5E1;
}
</style>

<script>
   document.addEventListener('DOMContentLoaded', function () {
      const canvas = document.getElementById("gameCanvas");
      const ctx = canvas.getContext("2d");

      let score = 0;
      let ball = { x: canvas.width / 2, y: canvas.height - 30, dx: 2, dy: -2, radius: 5, speed: 1 };
      let paddle = { height: 10, width: 50, x: (canvas.width - 50) / 2 };
      let rightPressed = false;
      let leftPressed = false;
      let isGameOver = false;

      // 벽돌 초기화
      const brickRowCount = 20;
      const brickColumnCount = 10;
      const brickWidth = 50;
      const brickHeight = 10;
      const brickPadding = 2;
      const brickOffsetTop = 30;
      const brickOffsetLeft = 0;
      let bricks = [];

      for (let c = 0; c < brickColumnCount; c++) {
          bricks[c] = [];
          for (let r = 0; r < brickRowCount; r++) {
              const colors = ['red', 'blue', 'yellow', 'green'];
              const color = colors[Math.floor(Math.random() * colors.length)];
              const points = color === 'red' ? 40 : color === 'blue' ? 30 : color === 'yellow' ? 20 : 10;
              bricks[c][r] = { x: 0, y: 0, status: 1, color: color, points: points };
          }
      }

      // 키보드 입력 핸들링
      document.addEventListener("keydown", keyDownHandler, false);
      document.addEventListener("keyup", keyUpHandler, false);

      // 키보드 입력 핸들러 함수
      function keyDownHandler(e) {
          if (e.key === "Right" || e.key === "ArrowRight") {
              rightPressed = true;
          } else if (e.key === "Left" || e.key === "ArrowLeft") {
              leftPressed = true;
          }
      }

      function keyUpHandler(e) {
          if (e.key === "Right" || e.key === "ArrowRight") {
              rightPressed = false;
          } else if (e.key === "Left" || e.key === "ArrowLeft") {
              leftPressed = false;
          }
      }

      // 충돌 감지 함수
      function collisionDetection() {
          for (let c = 0; c < brickColumnCount; c++) {
              for (let r = 0; r < brickRowCount; r++) {
                  const b = bricks[c][r];
                  if (b.status === 1) {
                      if (ball.x > b.x && ball.x < b.x + brickWidth && ball.y > b.y && ball.y < b.y + brickHeight) {
                          ball.dy = -ball.dy;
                          b.status = 0;
                          score += b.points;
                          document.getElementById("score").innerText = score;
                          updateBallSpeed();
                      }
                  }
              }
          }
      }

      // 점수에 따라 공의 속도를 업데이트하는 함수
      function updateBallSpeed() {
          ball.speed = 1 + Math.floor(score / 100) * 0.1;
          ball.dx = ball.dx > 0 ? ball.speed : -ball.speed;
          ball.dy = ball.dy > 0 ? ball.speed : -ball.speed;
      }

      // 공 그리기 함수
      function drawBall() {
          ctx.beginPath();
          ctx.arc(ball.x, ball.y, ball.radius, 0, Math.PI * 2);
          ctx.fillStyle = "#fff";
          ctx.fill();
          ctx.closePath();
      }

      // 바 그리기 함수
      function drawPaddle() {
          ctx.beginPath();
          ctx.rect(paddle.x, canvas.height - paddle.height - 10, paddle.width, paddle.height);
          ctx.fillStyle = "#fff";
          ctx.fill();
          ctx.closePath();
      }

      // 벽돌 그리기 함수
      function drawBricks() {
          for (let c = 0; c < brickColumnCount; c++) {
              for (let r = 0; r < brickRowCount; r++) {
                  if (bricks[c][r].status === 1) {
                      const brickX = c * (brickWidth + brickPadding) + brickOffsetLeft;
                      const brickY = r * (brickHeight + brickPadding) + brickOffsetTop;
                      bricks[c][r].x = brickX;
                      bricks[c][r].y = brickY;
                      ctx.beginPath();
                      ctx.rect(brickX, brickY, brickWidth, brickHeight);
                      ctx.fillStyle = bricks[c][r].color;
                      ctx.fill();
                      ctx.closePath();
                  }
              }
          }
      }

      // 게임 그리기 함수
      function draw() {
          if (isGameOver) return;

          ctx.clearRect(0, 0, canvas.width, canvas.height);
          drawBricks();
          drawBall();
          drawPaddle();
          collisionDetection();

          if (ball.x + ball.dx > canvas.width - ball.radius || ball.x + ball.dx < ball.radius) {
              ball.dx = -ball.dx;
          }
          if (ball.y + ball.dy < ball.radius) {
              ball.dy = -ball.dy;
          } else if (ball.y + ball.dy > canvas.height - ball.radius - paddle.height - 10) {
              if (ball.x > paddle.x && ball.x < paddle.x + paddle.width) {
                  ball.dy = -ball.dy;
              } else {
                  gameOver();
              }
          }

          ball.x += ball.dx;
          ball.y += ball.dy;

          if (rightPressed && paddle.x < canvas.width - paddle.width) {
              paddle.x += 7;
          } else if (leftPressed && paddle.x > 0) {
              paddle.x -= 7;
          }

          requestAnimationFrame(draw);
      }

      function startGame() {
          isGameOver = false;
          document.getElementById("gameOver").style.display = "none";
          draw();
      }

      function stopGame() {
          isGameOver = true;
          document.location.reload();
      }

      function gameOver() {
          isGameOver = true;
          document.getElementById("gameOver").style.display = "block";
      }

      // 게임 시작 및 종료 버튼 이벤트
      document.getElementById("startButton").addEventListener("click", startGame);
      document.getElementById("stopButton").addEventListener("click", stopGame);
   });
</script>

<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(3)>a").addClass("active");
      
      $("#btnSearch").on("click", function() {
         document.bbsForm.brdSeq.value = "";
         document.bbsForm.searchType.value = $("#searchType").val();
         document.bbsForm.searchValue.value = $("#searchValue").val();
         document.bbsForm.curPage.value = "1";
         document.bbsForm.action = "/board/freeList";
         document.bbsForm.submit();
      });
      
      let clickCount = 0;

      $("#starImage").on("click", function() {
         clickCount++;
         
         if (clickCount === 10) {
        	 Swal.fire({
        		 position: "center", 
        		 icon: "success",
        		 title: "이스터에그 발견을 축하드립니다!",
        		 showConfirmButton: false, 
        		 timer: 1500 
        		 }).then(function() {
        		 	fn_modal();
        		 });
            clickCount = 0;
         }
      });
   });
   
   /*모달*/
   function fn_modal() {
       var modal = document.getElementById("modal-game");
       var closeBtn = document.getElementById("close-btn"); 

       modal.style.display = "block"; 

       closeBtn.onclick = function() {
           modal.style.display = "none";
       }

       window.onclick = function(event) {
           if (event.target == modal) {
               modal.style.display = "none";
           }
       }
   }
   
   /* 글 상세보기 */
   function fn_view(brdSeq) {
      document.bbsForm.brdSeq.value = brdSeq;
      document.bbsForm.searchType.value = $("#searchType").val();
      document.bbsForm.searchValue.value = $("#searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.action = "/board/freeView";
      document.bbsForm.submit();
   }
   
   /* 글작성 */
   function fn_write() {
      <c:choose>
       <c:when test="${empty cookieUserId}">
          Swal.fire({
             position: "center", 
             icon: "warning",
             title: "로그인 후 이용해 주세요.",
             showConfirmButton: false, 
             timer: 1500 
             }).then(function() {
                location.href = "/board/freeList";
             });

       </c:when>
       <c:otherwise>
         location.href = "/board/freeWrite";
       </c:otherwise>
    </c:choose>
      
   }
   
   /* 페이징 */
   function fn_list(curPage) {
      document.bbsForm.brdSeq.value = "";
      document.bbsForm.curPage.value = curPage;
      document.bbsForm.action = "/board/freeList";
      document.bbsForm.submit();
   }
   
   /* 알파개씩 보기*/
   function listCount(value) {
      document.bbsForm.brdSeq.value = "";
      document.bbsForm.searchType.value = $("#searchType").val();
      document.bbsForm.searchValue.value = $("#searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.listCount.value = value;
      document.bbsForm.action = "/board/freeList";
      document.bbsForm.submit();
   }
   
   /*카테고리 버튼*/
   function setCategory(value) {
      document.bbsForm.brdSeq.value = "";
      document.bbsForm.searchType.value = $("#searchType").val();
      document.bbsForm.searchValue.value = $("#searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.category.value = value;
      
      $(".category-button").removeClass("active");
       
       if (value === '') {
           $(".category-button").first().addClass("active");
       } else {
           $(".category-button").each(function() {
               if ($(this).text() === getCategoryName(value)) {
                   $(this).addClass("active"); 
               }
           });
       }
       
      document.bbsForm.action = "/board/freeList";
      document.bbsForm.submit();
   }
   
   
   /*카테고리 반환*/
   function getCategoryName(value) {
       switch(value) {
           case '1': return '일상/생각';
           case '2': return '학습고민';
           case '3': return '입시';
           case '4': return '진로';
           default: return '';
       }
   }
   
   /*옵션 버튼*/
   function setOptions(value) {
      document.bbsForm.brdSeq.value = "";
      document.bbsForm.searchType.value = $("#searchType").val();
      document.bbsForm.searchValue.value = $("#searchValue").val();
      document.bbsForm.curPage.value = "1";
      document.bbsForm.options.value = value;
      
      $(".sort-button").removeClass("active");
       
       if (value === '') {
           $(".sort-button").first().addClass("active");
       } else {
           $(".sort-button").each(function() {
               if ($(this).text() === getOptionsName(value)) {
                   $(this).addClass("active"); 
               }
           });
       }
       
      document.bbsForm.action = "/board/freeList";
      document.bbsForm.submit();
   }
   
   
   /*옵션 반환*/
   function getOptionsName(value) {
       switch(value) {
           case '1': return '최신순';
           case '2': return '공감순';
           case '3': return '조회순';
           case '4': return '댓글순';
           default: return '';
       }
   }
   
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>
<div id="modal-game" class="modal-game">
<span id="close-btn" class="close-btn">&times;</span>
<div class="game-body">
	 <div class="game-container">
	        <h1>벽돌깨기 게임</h1>
	        <div class="score">점수: <span id="score">0</span></div>
	        <canvas id="gameCanvas" width="520" height="600"></canvas>
	        <div id="gameOver" class="game-over">GAME OVER</div>
	        <button id="startButton">시작</button>
	        <button id="stopButton">종료</button>
	    </div>
	    <script src="script.js"></script>
</div>
</div>

	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">Free Bulletin Board</h1>
				<p class="mainContent">자유게시판</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/star.png" alt="Clover Image" id="starImage">
			</div>
		</div>
	</section>

	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days"></span>
			</div>
			<ul class="menu">
				<li><a href="/board/noticeList">공지사항</a></li>
				<li><a href="/board/qnaList">문의사항</a></li>
				<li><a href="/board/freeList" class="highlight">자유게시판</a><br></li>
				<li><a href="/board/faqList">자주 묻는 질문</a></li>
			</ul>
		</div>
		<div class="table-container">
			<h2 class="subTitle">자유게시판</h2>

			<div class="freeboard-container">
				<div class="search-category">
					<div class="search-section">
						<div class="dropdown">
							<select class="dropdown-button" name="searchType" id="searchType">
								<option value="0">전체</option>
								<option value="1" <c:if test = "${searchType eq '1'}">selected</c:if>>작성자(아이디)</option>
								<option value="4" <c:if test = "${searchType eq '4'}">selected</c:if>>작성자(이름)</option>
								<option value="2" <c:if test = "${searchType eq '2'}">selected</c:if>>제목</option>
								<option value="3" <c:if test = "${searchType eq '3'}">selected</c:if>>내용</option>
							</select>
						</div>
						<input type="text" class="search-input" name="searchValue" id="searchValue" value="${searchValue}" placeholder="검색어를 입력하세요.">
						<button type="button" id="btnSearch" class="btnSearch" style="cursor: pointer">
							<img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;">
						</button>
					</div>
					<div class="categories" id="btnCategory">
						<button class="category-button <c:if test="${category eq ''}">active</c:if>" onclick="setCategory()">전체</button>
						<button class="category-button <c:if test="${category eq '1'}">active</c:if>" onclick="setCategory('1')">일상/생각</button>
						<button class="category-button <c:if test="${category eq '2'}">active</c:if>" onclick="setCategory('2')">학습고민</button>
						<button class="category-button <c:if test="${category eq '3'}">active</c:if>" onclick="setCategory('3')">입시</button>
						<button class="category-button <c:if test="${category eq '4'}">active</c:if>" onclick="setCategory('4')">진로</button>
					</div>
				</div>
			</div>
			<div class="stats">
				<span>게시글 <strong>${totalCount}</strong></span>
				<div class="sorting-options">
					<button class="sort-button <c:if test="${options eq '4'}">active</c:if>" onclick="setOptions('4')">댓글순</button>
					<button class="sort-button <c:if test="${options eq '3'}">active</c:if>" onclick="setOptions('3')">조회순</button>
					<button class="sort-button <c:if test="${options eq '2'}">active</c:if>" onclick="setOptions('2')">공감순</button>
					<button class="sort-button <c:if test="${options eq '1'}">active</c:if>" onclick="setOptions('1')">최신순</button>
					<select class="view-options" id="listCount" onchange="listCount(this.value)">
						<option value="10" <c:if test="${listCount == 10}">selected</c:if>>10개씩 보기</option>
						<option value="15" <c:if test="${listCount == 15}">selected</c:if>>15개씩 보기</option>
						<option value="20" <c:if test="${listCount == 20}">selected</c:if>>20개씩 보기</option>
						<option value="25" <c:if test="${listCount == 25}">selected</c:if>>25개씩 보기</option>
					</select>
				</div>
			</div>


			<table>
				<thead>
					<tr>
						<th>번호</th>
						<th>분류</th>
						<th>작성자</th>
						<th>제목</th>
						<th>등록일</th>
						<th>조회수</th>
						<th>공감수</th>
					</tr>
				</thead>
				<tbody>
					<c:if test="${!empty list}">
						<c:set var="brdSeq" value="${paging.startNum + 1}" />
						<c:forEach var="board" items="${list}" varStatus="status">
							<c:set var="brdSeq" value="${brdSeq - 1}" />
							<tr onclick="fn_view(${board.brdSeq})" style="cursor: pointer;">
								<td>${brdSeq}</td>
								<td><c:if test="${board.category eq '1'}">일상/생각</c:if> <c:if test="${board.category eq '2'}">학습고민</c:if> <c:if test="${board.category eq '3'}">입시</c:if> <c:if test="${board.category eq '4'}">진로</c:if></td>
								<td><img src="/resources/profile/${board.userProfile}" onerror='this.src="/resources/images/default-profile.jpg"' style="width: 30px; height: 30px; border-radius: 50%;"> &nbsp;${board.userName}<br>( <c:choose>
										<c:when test="${fn:length(board.userId) gt 10}">
											<c:out value="${fn:substring(board.userId, 0, 9)}...">
											</c:out>
										</c:when>
										<c:otherwise>
											<c:out value="${board.userId}">
											</c:out>
										</c:otherwise>
									</c:choose> )</td>
								<td>${board.brdTitle} [${board.boardCommCount }]</td>
								<td>${board.regDate}</td>
								<td>${board.brdReadCnt}</td>
								<td>${board.boardLikeCount}</td>
							</tr>
						</c:forEach>
					</c:if>
					<c:if test="${empty list }">
						<tr>
							<td colspan="7">해당하는 게시글이 존재하지 않습니다.</td>
						</tr>
					</c:if>
				</tbody>
			</table>

			<div class="freeWrite-container">
				<button class="free-write-button" onclick="fn_write()">글쓰기</button>
			</div>

			<div class="pagination">
				<c:if test="${!empty paging}">

					<c:if test="${paging.prevBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_Page(${paging.prevBlockPage})">&laquo;</button>
					</c:if>


					<c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
						<c:choose>
							<c:when test="${i eq curPage}">
								<span class="pagination-number active">${i}</span>
							</c:when>
							<c:otherwise>
								<span class="pagination-number"><a class="page-link" href="#" onclick="fn_list(${i})">${i}</a></span>
							</c:otherwise>
						</c:choose>
						<c:if test="${i lt paging.endPage}">
							<span class="pagination-separator">|</span>
						</c:if>
					</c:forEach>


					<c:if test="${paging.nextBlockPage gt 0}">
						<button class="pagination-button" href="#" onclick="fn_list(${paging.nextBlockPage})">&raquo;</button>
					</c:if>

				</c:if>
			</div>
		</div>
	</section>

	<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

	<form name="bbsForm" id="bbsForm" method="POST">
		<input type="hidden" name="brdSeq" value="" />
		<input type="hidden" name="searchType" value="${searchType}" />
		<input type="hidden" name="searchValue" value="${searchValue}" />
		<input type="hidden" name="curPage" value="${curPage}" />
		<input type="hidden" name="category" value="${category}" />
		<input type="hidden" name="listCount" value="${listCount}" />
		<input type="hidden" name="options" value="${options}" />
	</form>

</body>
</html>
