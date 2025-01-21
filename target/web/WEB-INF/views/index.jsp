<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">

<!-- =======================================================
* Template Name: Personal
* Template URL: https://bootstrapmade.com/personal-free-resume-bootstrap-template/
* Updated: Nov 04 2024 with Bootstrap v5.3.3
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
======================================================== -->
</head>

<body class="index-page">
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<main class="main">
		
		<!-- Hero Section -->
		<section id="hero" class="hero section dark-background">

			<!--  <img src="/resources/img/test-bg.jpg" alt="" data-aos="fade-in"> -->
			<div class="moving-background-1"></div>

			<!-- 좌 공 -->
			<div class="moving-background-2"></div>

			<!-- 우 하 공 -->
			<div class="moving-background-3"></div>

			<!-- 우 상 공 -->
			<div class="moving-background-4"></div>


			<div class="container" data-aos="zoom-out" data-aos-delay="100">
				<h2>All we have is now.</h2>
				<p>
					나는 <span class="typed" data-typed-items="변화한다, 실현한다, 이끈다, 개선한다">추구한다</span><span class="typed-cursor typed-cursor--blink"></span>
				</p>
				<div class="social-links">
					<a href="#"><i class="bi bi-twitter-x"></i></a> <a href="#"><i class="bi bi-facebook"></i></a> <a href="#"><i class="bi bi-instagram"></i></a> <a href="#"><i class="bi bi-linkedin"></i></a>
				</div>
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
					

			<h3 class="sitename">STUDY 선생님</h3>

			<!-- Portfolio Section -->
			<section id="portfolio" class="portfolio section">

				<div class="container">

					<div class="isotope-layout" data-default-filter="*" data-layout="masonry" data-sort="original-order">

						<ul class="portfolio-filters isotope-filters" data-aos="fade-up" data-aos-delay="100">
							<li data-filter=".filter-app">국어</li>
							<li data-filter=".filter-product">영어</li>
							<li data-filter=".filter-branding">수학</li>
							<li data-filter=".filter-books">탐구</li>
						</ul>
						<!-- End Portfolio Filters -->

						<div class="row gy-4 isotope-container" data-aos="fade-up" data-aos-delay="100">

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-branding">
								<div class="portfolio-content h-100">
									<img src="/resources/img/kor1.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Branding 1</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/branding-1.jpg" title="Branding 1" data-gallery="portfolio-gallery-branding" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-app">
								<div class="portfolio-content h-100">
									<img src="/resources/img/kor2.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Books 1</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/books-1.jpg" title="Branding 1" data-gallery="portfolio-gallery-book" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-app">
								<div class="portfolio-content h-100">
									<img src="/resources/img/kor3.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>App 2</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/app-2.jpg" title="App 2" data-gallery="portfolio-gallery-app" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-product">
								<div class="portfolio-content h-100">
									<img src="/resources/img/math1.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Product 2</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/product-2.jpg" title="Product 2" data-gallery="portfolio-gallery-product" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-branding">
								<div class="portfolio-content h-100">
									<img src="/resources/img/math2.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Branding 2</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/branding-2.jpg" title="Branding 2" data-gallery="portfolio-gallery-branding" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-books">
								<div class="portfolio-content h-100">
									<img src="/resources/img/math3.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Books 2</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/books-2.jpg" title="Branding 2" data-gallery="portfolio-gallery-book" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-app">
								<div class="portfolio-content h-100">
									<img src="/resources/img/eng1.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>App 3</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/app-3.jpg" title="App 3" data-gallery="portfolio-gallery-app" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-product">
								<div class="portfolio-content h-100">
									<img src="/resources/img/eng2.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Product 3</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/product-3.jpg" title="Product 3" data-gallery="portfolio-gallery-product" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-branding">
								<div class="portfolio-content h-100">
									<img src="/resources/img/eng3.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Branding 3</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/branding-3.jpg" title="Branding 2" data-gallery="portfolio-gallery-branding" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-product">
								<div class="portfolio-content h-100">
									<img src="/resources/img/etc1.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Books 3</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/books-3.jpg" title="Branding 3" data-gallery="portfolio-gallery-book" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-books">
								<div class="portfolio-content h-100">
									<img src="/resources/img/etc2.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Books 3</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/books-3.jpg" title="Branding 3" data-gallery="portfolio-gallery-book" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

							<div class="col-lg-4 col-md-6 portfolio-item isotope-item filter-books">
								<div class="portfolio-content h-100">
									<img src="/resources/img/etc3.JPG" class="img-fluid" alt="">
									<div class="portfolio-info">
										<h4>Books 3</h4>
										<p>Lorem ipsum, dolor sit amet consectetur</p>
										<a href="assets/img/portfolio/books-3.jpg" title="Branding 3" data-gallery="portfolio-gallery-book" class="glightbox preview-link"><i class="bi bi-zoom-in"></i></a> <a href="portfolio-details.html" title="More Details" class="details-link"><i class="bi bi-link-45deg"></i></a>
									</div>
								</div>
							</div>
							<!-- End Portfolio Item -->

						</div>
						<!-- End Portfolio Container -->

					</div>

				</div>


			</section>
			<!-- /Portfolio Section -->
		
		
			<h3 class="sitename">WEGA STUDY</h3>
			<br>
			<h2>
				명실상부 <span id="emph">대한민국 대표 고등인강 WEGA STUDY!</span> <br>여러분은 그저 믿고 따라오시면 됩니다.
			</h2>

			<!-- Services Section -->
			<section id="services" class="services section">

				<div class="container">

					<div class="row gy-4">

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
							<div class="service-item  position-relative">
								<div class="icon">
									<i class="bi bi-activity"></i>
								</div>
								<a href="service-details.html" class="stretched-link">
									<h3>체계적인 커리큘럼</h3>
								</a>
								<p>
									각 분야의 전문가들이 설계한 커리큘럼으로, <br>단계별로 실력을 쌓아갈 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-broadcast"></i>
								</div>
								<a href="service-details.html" class="stretched-link">
									<h3>학습의 즐거움</h3>
								</a>
								<p>
									인터렉티브한 콘텐츠와 다양한 학습 도구로,<br>지루함 없이 재미있게 배울 수 있습니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-easel"></i>
								</div>
								<a href="service-details.html" class="stretched-link">
									<h3>학습의 자유</h3>
								</a>
								<p>
									모바일과 PC에서 모두 접근 가능한 강의로,<br>바쁜 일상 속에서도 학습할 수 있는 기회를 제공합니다.
								</p>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="400">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-bounding-box-circles"></i>
								</div>
								<a href="service-details.html" class="stretched-link">
									<h3>효율적인 학습</h3>
								</a>
								<p>
									체계적인 학습 계획과 진단 테스트로,<br>자신의 실력을 정확히 파악하고 보완할 수 있습니다.
								</p>
								<a href="service-details.html" class="stretched-link"></a>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="500">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-calendar4-week"></i>
								</div>
								<a href="service-details.html" class="stretched-link">
									<h3>친구와 함께하는 학습</h3>
								</a>
								<p>
									스터디 그룹 기능으로, 친구들과 함께 공부하며<br>서로의 동기를 부여할 수 있습니다.
								</p>
								<a href="service-details.html" class="stretched-link"></a>
							</div>
						</div>
						<!-- End Service Item -->

						<div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="600">
							<div class="service-item position-relative">
								<div class="icon">
									<i class="bi bi-chat-square-text"></i>
								</div>
								<a href="service-details.html" class="stretched-link">
									<h3>합격의 길</h3>
								</a>
								<p>
									실전 모의고사와 기출 문제 풀이로,<br>수능의 흐름을 미리 경험하고 자신감을 키울 수 있습니다.
								</p>
								<a href="service-details.html" class="stretched-link"></a>
							</div>
						</div>
						<!-- End Service Item -->

					</div>

				</div>

			</section>
			<!-- /Services Section -->

			<h3 class="sitename">
				지금 당신의 경쟁자가 보고 있는 책, <span id="emph">웨가 북</span>
			</h3>

			<!-- Portfolio Section -->
			<section id="books" class="books_section">
				<div class="books-all">
					<div class="books">
						<img src="/resources/img/실모1.JPG" class="img-fluid" alt="">
						<h5 class="book-title">수학 실전 모의고사</h5>
						<p class="book-price">₩10,000</p>
					</div>
					<div class="books">
						<img src="/resources/img/실모2.JPG" class="img-fluid" alt="">
						<h5 class="book-title">파워 업 독해 실전편</h5>
						<p class="book-price">₩12,000</p>
					</div>
					<div class="books">
						<img src="/resources/img/실모3.JPG" class="img-fluid" alt="">
						<h5 class="book-title">어법 끝 실전 모의고사</h5>
						<p class="book-price">₩15,000</p>
					</div>
					<div class="books">
						<img src="/resources/img/실모4.JPG" class="img-fluid" alt="">
						<h5 class="book-title">ZERO GRAVITY</h5>
						<p class="book-price">₩8,000</p>
					</div>
					<div class="books">
						<img src="/resources/img/실모5.JPG" class="img-fluid" alt="">
						<h5 class="book-title">영어 독해 실전 모의고사</h5>
						<p class="book-price">₩9,500</p>
					</div>
				</div>
			</section>


			<div class="social-links d-flex justify-content-center">
				<a href=""><i class="bi bi-twitter-x"></i></a> <a href=""><i class="bi bi-facebook"></i></a> <a href=""><i class="bi bi-instagram"></i></a> <a href=""><i class="bi bi-skype"></i></a> <a href=""><i class="bi bi-linkedin"></i></a>
			</div>
			<div class="container">
				<div class="copyright">
					<span>Copyright</span> <strong class="px-1 sitename">WEGA STUDY</strong> <span>All Rights Reserved</span>
				</div>
				<div class="credits">
					<!-- All the links in the footer should remain intact. -->
					<!-- You can delete the links only if you've purchased the pro version. -->
					<!-- Licensing information: https://bootstrapmade.com/license/ -->
					<!-- Purchase the pro version with working PHP/AJAX contact form: [buy-url] -->
					Designed by <a href="https://bootstrapmade.com/">BootstrapMade</a>
				</div>
			</div>
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

</body>

</html>