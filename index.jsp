<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">

<!-- =======================================================
* Template Name: Personal
* Template URL: https://bootstrapmade.com/personal-free-resume-bootstrap-template/
* Updated: Nov 04 2024 with Bootstrap v5.3.3
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
======================================================== -->

<script>
//책 상세보기
function fn_bookSelect(bookSeq)
{
   document.bbsForm.bookSeq.value = bookSeq;
   document.bbsForm.action = "/user/bookDetail";
   document.bbsForm.submit();
}

function clickBox1() {
	document.bbsForm.action = "/teach/teachList";
	document.bbsForm.submit();
}
function clickBox2() {
	document.bbsForm.action = "/book/book";
	document.bbsForm.submit();
}
function clickBox3() {
	document.bbsForm.action = "/course/allCourse";
	document.bbsForm.submit();
}

function clickBox4() {
	document.bbsForm.action = "/board/qnaList";
	document.bbsForm.submit();
}
function clickBox5() {
	document.bbsForm.action = "/board/freeList";
	document.bbsForm.submit();
}
function clickBox6() {
	document.bbsForm.action = "/dataroom/prevQueList";
	document.bbsForm.submit();
}

function fn_teachMove(teacherId, classCode) {
	document.teacherTypeForm.classCode.value = classCode;
	document.teacherTypeForm.teacherId.value = teacherId;
	document.teacherTypeForm.action = "/teach/teachPage";
	document.teacherTypeForm.submit(); 
}

//후기 올라오기
document.addEventListener("DOMContentLoaded", function () {
	  const reviews = document.querySelectorAll('.review');

	  
	  const observerOptions = {
	    root: null, 
	    rootMargin: '0px',
	    threshold: 0.1 
	  };

	  const reviewObserver = new IntersectionObserver((entries, observer) => {
	    entries.forEach(entry => {
	      if (entry.isIntersecting) {
	        entry.target.classList.add('is-visible');
	        observer.unobserve(entry.target); 
	      }
	    });
	  }, observerOptions);

	  reviews.forEach(review => {
	    reviewObserver.observe(review);
	  });
	});
</script>



</head>

<body class="index-page" style="background: white;">
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<!-- 팝업 배너 -->
	<!-- <div id="popup-banner" class="popup-banner">
		<div class="popup-content">
			<span id="close-btn" class="close-btn">&times;</span>
			<div>
				<img src="/resources/img/pop.png" width="100%">
			</div>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<h3>특별 할인 이벤트!</h3>
			<p>반값같은 할인!! 하루빨리 구매하세요.</p>
			<a href="/book/book" class="popup-link">자세히 보기</a>
		</div>
	</div>
 -->
	<main class="main">

		<!-- Hero Section -->
		<section id="hero" class="hero front section dark-background" style="background: white;">

			<!--  <img src="/resources/img/test-bg.jpg" alt="" data-aos="fade-in"> -->
			<div class="moving-background-1"></div>
			<!-- 좌 공 -->
			<div class="moving-background-2"></div>
			<!-- 우 하 공 -->
			<div class="moving-background-3"></div>
			<!-- 우 상 공 -->
			<div class="moving-background-4"></div>

			<div class="container main-banner-title" data-aos="zoom-out" data-aos-delay="100">
				<h2 style="color: black;">All we have is now.</h2>
				<p style="color: black;">
					나는 <span class="typed typeFront" data-typed-items="변화한다, 실현한다, 이끈다, 개선한다, 추구한다"></span><span class="typed-cursor typed-cursor--blink"></span>
				</p>
			</div>

		</section>
		<section id="hero" class="hero back section dark-background" style="background: black;">

			<!--  <img src="/resources/img/test-bg.jpg" alt="" data-aos="fade-in"> -->
			<div class="moving-background-1"></div>
			<!-- 좌 공 -->
			<div class="moving-background-2"></div>
			<!-- 우 하 공 -->
			<div class="moving-background-3"></div>
			<!-- 우 상 공 -->
			<div class="moving-background-4"></div>

			<div class="container main-banner-title" data-aos="zoom-out" data-aos-delay="100">
				<h2 style="color: white;">All we have is now.</h2>
				<p style="color: white;">
					나는 <span class="typed typeBack"></span><span class="typed-cursor typed-cursor--blink"></span>
				</p>
			</div>

		</section>
		<!-- /Hero Section -->

	</main>
	<br>
	<br>
	<br>
	<br>
	<footer id="footer" class="footer dark-background">
		<div class="mid-container">
			<h3 class="sitename">S.O.S</h3>
			<br>
			<h2>
				명실상부 <span id="emph">대한민국 대표 고등인강 SOS!</span> <br>여러분은 그저 믿고 따라오시면 됩니다.
			</h2>

			<!-- Services Section -->
			<section id="services" class="services section">

				<div class="container">

					<div class="row gy-4">

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
							<div class="service-item  position-relative">
								<div class="icon">
									<i class="bi bi-activity"></i>
								</div>
								<a href="#" onclick="clickBox1()" class="stretched-link">
									<h3>체계적인 커리큘럼</h3>
								</a>
								<p>
									각 분야의 강사진이 설계한 커리큘럼으로, <br>학생들이 단계별로 실력을 쌓아가며 성장할 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-broadcast"></i>
								</div>
								<a href="#" onclick="clickBox2()" class="stretched-link">
									<h3>교재로 즐기는 학습의 재미</h3>
								</a>
								<p>
									다양한 교재와 학습 도구를 통해,<br>지루함 없이 재미있고 효과적으로 배울 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-easel"></i>
								</div>
								<a href="#" onclick="clickBox3()" class="stretched-link">
									<h3>모든 강좌에서 누리는 학습의 자유</h3>
								</a>
								<p>
									PC에서 접근 가능한 강좌로, <br>시간과 장소에 구애받지 않고 자유롭게 학습할 수 있는 <br>기회를 제공합니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="400">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-bounding-box-circles"></i>
								</div>
								<a href="#" onclick="clickBox4()" class="stretched-link">
									<h3>Q&A로 해결하는 궁금증</h3>
								</a>
								<p>
									Q&A에서 직접 소통하며,<br>궁금한 점을 빠르게 해결할 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="500">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-calendar4-week"></i>
								</div>
								<a href="#" onclick="clickBox5()" class="stretched-link">
									<h3>커뮤니티에서 함께하는 소통</h3>
								</a>
								<p>
									커뮤니티를 통해 다양한 사람들과 정보를 공유하며,<br>서로의 학습 동기를 자극하고 도움을 주고받을 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="600">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-chat-square-text"></i>
								</div>
								<a href="#" onclick="clickBox6()" class="stretched-link">
									<h3>기출 문제로 다지는 실력</h3>
								</a>
								<p>
									기출 문제 풀이를 통해,<br>실전 경험을 쌓고 문제 유형에 익숙해져 <br>자신감을 키울 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

					</div>

				</div>

			</section>
			<!-- /Services Section -->

			<h3 class="sitename">STUDY 선생님</h3>

			<!-- Portfolio Section -->
			<section id="portfolio" class="portfolio section">

				<div class="container">

					<div class="isotope-layout" data-default-filter="*" data-layout="masonry" data-sort="original-order">

						<ul class="portfolio-filters isotope-filters" data-aos="fade-up" data-aos-delay="100">
							<li data-filter=".filter-app">국어</li>
							<li data-filter=".filter-product">영어</li>
							<li data-filter=".filter-branding">수학</li>
							<li data-filter=".filter-books">사회</li>
							<li data-filter=".filter-science">과학</li>
						</ul>
						<!-- End Portfolio Filters -->

						<div class="row gy-4 isotope-container" data-aos="fade-up" data-aos-delay="200">
							<c:forEach var="math" items="${math}" varStatus="status">
								<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-branding">
									<div class="portfolio-content h-100" onclick="fn_teachMove('${math.userId}', '${math.classCode }')" style="cursor: pointer;">
										<img src="/resources/images/teacher/${math.userId}.png" class="img-fluid" alt="">
										<p>${math.userName }</p>
									</div>
								</div>
							</c:forEach>
							<c:forEach var="kor" items="${kor}" varStatus="status">
								<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-app">
									<div class="portfolio-content h-100" onclick="fn_teachMove('${kor.userId}', '${kor.classCode }')" style="cursor: pointer;">
										<img src="/resources/images/teacher/${kor.userId}.png" class="img-fluid" alt="">
										<p>${kor.userName }</p>
									</div>
								</div>
							</c:forEach>
							<c:forEach var="eng" items="${eng}" varStatus="status">
								<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-product">
									<div class="portfolio-content h-100" onclick="fn_teachMove('${eng.userId}', '${eng.classCode }')" style="cursor: pointer;">
										<img src="/resources/images/teacher/${eng.userId }.png" class="img-fluid" alt="">
										<p>${eng.userName }</p>
									</div>
								</div>
							</c:forEach>
							<c:forEach var="social" items="${social}" varStatus="status">
								<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-books">
									<div class="portfolio-content h-100" onclick="fn_teachMove('${social.userId}', '${social.classCode }')" style="cursor: pointer;">
										<img src="/resources/images/teacher/${social.userId }.png" class="img-fluid" alt="">
										<p>${social.userName }</p>
									</div>
								</div>
							</c:forEach>
							<c:forEach var="science" items="${science}" varStatus="status">
								<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-science">
									<div class="portfolio-content h-100" onclick="fn_teachMove('${science.userId}', '${science.classCode }')" style="cursor: pointer;">
										<img src="/resources/images/teacher/${science.userId }.png" class="img-fluid" alt="">
										<p>${science.userName }</p>
									</div>
								</div>
							</c:forEach>


						</div>
						<!-- End Portfolio Container -->

					</div>

				</div>


			</section>
			<!-- /Portfolio Section -->

			<h3 class="sitename">
				지금 당신의 경쟁자가 보고 있는 책, <span id="emph">S.O.S 북</span>
			</h3>

			<!-- Portfolio Section -->
			<section id="books" class="books_section">
				<div class="books-all">
					<c:forEach var="Book" items="${list}" varStatus="status">

						<div class="books" style="cursor: pointer;">
							<img src="/resources/images/book/${Book.bookSeq}.jpg" class="img-fluid" alt="" onclick="fn_bookSelect(${Book.bookSeq})">
							<h5 class="book-title">
								<span class="titleShort">${Book.bookTitle}</span>
							</h5>
						</div>

					</c:forEach>
					<c:forEach var="Book" items="${list}" varStatus="status">

						<div class="books" style="cursor: pointer;">
							<img src="/resources/images/book/${Book.bookSeq}.jpg" class="img-fluid" alt="" onclick="fn_bookSelect(${Book.bookSeq})">
							<h5 class="book-title">
								<span class="titleShort">${Book.bookTitle}</span>
							</h5>
						</div>

					</c:forEach>


				</div>
			</section>

			<h3 class="sitename">
				왜, <span id="emph">SOS</span>인가요?<br> 교육담당자들의 생생한 <span id="emph">후기</span>
			</h3>

			<section>
				<div class="reviewBox">
					<div class="reviewContainer">
						<div class="reviews">
							<div class="review">
								<img src="/resources/img/건민2.png">
								<div>
									<h3>고*민</h3>
									<p>팀장을 맡으면서 부담감도 크고 걱정이 많이 되었지만 좋은 팀원들 덕분에 프로젝트를 진행하는 내내 걱정이 되기는 커녕 정말 든든하고 믿음직스러웠습니다. 누구 하나 뒤쳐지지 않고 모든 팀원들이 함께 노력하고 만들었기에 이렇게 좋은 작품이 나온 것이라고 생각이 들며, 프로젝트 마무리까지 완벽하게 해준 팀원들께 감사합니다!</p>
								</div>
							</div>
							<div class="review">
								<img src="/resources/img/순일2.png">
								<div>
									<h3>권*일</h3>
									<p>하나의 사이트를 만드는 게 어떻게 가능하지라고 생각을 했는데 서버를 열고 DB를 설계하고 프로그래밍 하는 걸 직접 해보니 생각보다 잘돼서 신기했습니다. 팀원들과 소통이 정말 중요하단걸 느꼈습니다. 감사합니다.</p>
								</div>
							</div>
							<div class="review">
								<img src="/resources/img/현준2.png">
								<div>
									<h3>김*준</h3>
									<p>이번 프로젝트를 통해 학원에서 배운 지식을 더욱 체계적으로 내 것으로 만들 수 있었습니다. 또한 실무와 가까운 경험을 쌓으며 문제 해결 능력과 협업의 중요성을 깊이 깨달었습니다. 좋은 팀원들과 함께하며 즐겁고 의미 있는 시간을 보낼 수 있었던 점이 특히 기억에 남습니다. 작은 아이디어에서 시작된 프로젝트가 결과물로 완성되는 과정을 통해 큰 성취감을 느꼈습니다. 이 경험을 바탕으로 앞으로도 성장하는 개발자가 되기 위해 더욱 노력하겠습니다. 감사합니다.</p>
								</div>
							</div>
							<div class="review">
								<img src="/resources/img/우진2.png">
								<div>
									<h3>이*진</h3>
									<p>팀 프로젝트를 통해 학원에서 배운 언어를 활용하고 적용할 수 있어 좋았습니다. 좋은 팀원들 덕분에 기한 내에 프로젝트를 원활하게 마무리할 수 있었고, 잘 몰랐던 부분에 대해 알아가는 의미 있는 경험이었습니다. 다들 감사했습니다!</p>
								</div>
							</div>
							<div class="review">
								<img src="/resources/img/지수2.png">
								<div>
									<h3>이*수</h3>
									<p>프로젝트 기능 설계부터 기능을 구현하기 위해서 필요한 DB 테이블과 컬럼 간의 관계를 정의하고 디자인, 백엔드 기능 구현까지 직접 제작해보면서 실무적인 경험을 해볼 수 있었습니다. 그리고  이유 없이 지체되고 중복 일 처리 되는 것을 방지하기 위해서는 팀원들과 활발한 소통이 중요하다는 것을 느꼈습니다. 좋은 분위기에서 의견도 많이 나눌 수 있고 배울 수 있는 기회를 갖게 해준 팀원들에게 고맙습니다!</p>
								</div>
							</div>
							<div class="review">
								<img src="/resources/img/웅기2.png">
								<div>
									<h3>민*기</h3>
									<p>이번 프로젝트를 통해 HTML, Java, Spring, CSS를 정리하고 실습할 수 있는 기회를 가졌습니다. 팀원들과 협력하여 프로젝트를 완성하며 큰 보람을 느꼈고, 많은 것을 배울 수 있었습니다. 함께 해 주신 모든 분들께 감사드리며, 앞으로도 계속 성장할 수 있도록 노력하겠습니다.</p>
								</div>
							</div>
						</div>
					</div>
				</div>
			</section>

			<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
		</div>
	</footer>

	<!-- Scroll Top -->
	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

	<!-- Preloader -->
	<div id="preloader"></div>

	<!-- Vendor JS Files -->
	<script src="/resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	<script src="/resources/vendor/php-email-form/validate.js"></script>
	<script src="/resources/vendor/aos/aos.js"></script>
	<script src="/resources/vendor/typed.js/typed.umd.js"></script>
	<script src="/resources/vendor/purecounter/purecounter_vanilla.js"></script>
	<script src="/resources/vendor/waypoints/noframework.waypoints.js"></script>
	<script src="/resources/vendor/swiper/swiper-bundle.min.js"></script>
	<script src="/resources/vendor/glightbox/js/glightbox.min.js"></script>
	<script src="/resources/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
	<script src="/resources/vendor/isotope-layout/isotope.pkgd.min.js"></script>

	<!-- Main JS File -->
	<script src="/resources/js/main.js"></script>


	<form id="bbsForm" name="bbsForm" method="post">
		<input type="hidden" name="bookSeq" value="${bookSeq}">
	</form>
	<form id="teacherTypeForm" name="teacherTypeForm" method="post">
		<input type="hidden" name="classCode" value="">
		<input type="hidden" name="teacherId" value="">
	</form>
</body>

</html>