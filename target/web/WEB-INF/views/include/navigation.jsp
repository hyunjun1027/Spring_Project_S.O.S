<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="/resources/css/navigation.css" rel="stylesheet">

<header id="header" class="header d-flex align-items-center fixed-top">
	<div class="container-fluid container-xl position-relative d-flex align-items-center justify-content-between">

		<a href="/index" class="logo d-flex align-items-center"> <!-- Uncomment the line below if you also wish to use an image logo --> <!-- <img src="assets/img/logo.png" alt=""> -->
			<h1 class="sitename">WEGA STUDY</h1>
		</a>

		<nav id="navmenu" class="navmenu">
			<ul>
				<li><a href="index.html" class="active">Home</a></li>
				<li><a href="about.html">About</a></li>
				<li><a href="resume.html">Resume</a></li>
				<li><a href="services.html">Services</a></li>
				<li><a href="portfolio.html">Portfolio</a></li>
				<li class="dropdown"><a href="#"><span>Dropdown</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
					<ul>
						<li><a href="#">Dropdown 1</a></li>
						<li class="dropdown"><a href="#"><span>Deep Dropdown</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
							<ul>
								<li><a href="#">Deep Dropdown 1</a></li>
								<li><a href="#">Deep Dropdown 2</a></li>
								<li><a href="#">Deep Dropdown 3</a></li>
								<li><a href="#">Deep Dropdown 4</a></li>
								<li><a href="#">Deep Dropdown 5</a></li>
							</ul></li>
						<li><a href="#">Dropdown 2</a></li>
						<li><a href="#">Dropdown 3</a></li>
						<li><a href="#">Dropdown 4</a></li>
					</ul></li>
				<li><a href="contact.html">Contact</a></li>
				<li><a href="/user/joinForm">회원가입</a></li>
			</ul>
			<i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
		</nav>
	</div>
</header>