<%@ page contentType="text/html; charset=UTF-8" language="java"%>

<style>
#gnb {
	width: 300px;
	background-color: #1e1e2f;
	color: #fff;
	display: flex;
	flex-direction: column;
	padding: 30px 20px;
	position: fixed;
	height: 100%;
}

#gnb h2 {
	font-size: 22px;
	font-weight: 600;
	text-align: center;
	padding-bottom: 25px;
	margin-bottom: 10px;
	border-bottom: 2px solid #777;
	color: #d1d1e9;
}

#gnb_1dul {
	list-style-type: none;
	padding: 0;
	margin: 0;
}

.gnb_1dli {
	margin-bottom: 15px;
}

.gnb_1da {
	display: flex;
	align-items: center;
	padding: 10px 15px;
	color: #d1d1e9;
	text-decoration: none;
	border-radius: 5px;
	font-size: 15px;
	transition: background-color 0.3s ease, color 0.3s ease;
}

.gnb_1da.active {
	background-color: #6a74c9;
	color: #fff;
	font-weight: bold;
}

.logout-btn {
    position: absolute;
    bottom: 20px;
    right: 20px; 
}

.logout-btn img {
    width: 35px;
    height: 35px;
    filter: invert(100%) brightness(70%);
}
.logout-btn::marker {
  display: none;
}

</style>


<!-- Navigation Sidebar -->
<nav id="gnb">
	<h2>관리자 주메뉴</h2>
	<ul id="gnb_1dul">
		<li class="gnb_1dli"><a class="gnb_1da" href="/admin/index" onclick="setActive(this)">전체보기</a></li>
		<li class="gnb_1dli"><a class="gnb_1da" href="/admin/userMgr" onclick="setActive(this)">회원 관리</a></li>
		<li class="gnb_1dli"><a class="gnb_1da" href="/admin/boardMgr" onclick="setActive(this)">게시판 관리</a></li>
		<li class="gnb_1dli"><a class="gnb_1da" href="/admin/courseMgr" onclick="setActive(this)">강좌 관리</a></li>
		<li class="gnb_1dli"><a class="gnb_1da" href="/admin/bookMgr" onclick="setActive(this)">교재 관리</a></li>
		<li class="gnb_1dli"><a class="gnb_1da" href="/admin/orderMgr" onclick="setActive(this)">주문 관리</a></li>
	</ul>
	
	<ul id="logout-btn" class="logout-btn">
        <li style="list-style: none;"><a href="/account/adminLogoutProc" class="modal-logout-btn" id="modal-logout-btn">
            <img src="/resources/img/log_out.png" alt="Logout Icon">
        </a></li>
    </ul>
</nav>

<script>
	window.onload = function() {
		var currentUrl = window.location.pathname;
		var menuItems = document.querySelectorAll('.gnb_1da');

		menuItems.forEach(function(item) {
			if (item.getAttribute('href') === currentUrl) {
				item.classList.add('active');
			} else {
				item.classList.remove('active');
			}
		});
	}

	function setActive(element) {
		var menuItems = document.querySelectorAll('.gnb_1da');
		menuItems.forEach(function(item) {
			item.classList.remove('active');
		});

		element.classList.add('active');
	}
</script>