/**
* Template Name: Personal
* Template URL: https://bootstrapmade.com/personal-free-resume-bootstrap-template/
* Updated: Nov 04 2024 with Bootstrap v5.3.3
* Author: BootstrapMade.com
* License: https://bootstrapmade.com/license/
*/

(function() {
  "use strict";

  /**
   * Apply .scrolled class to the body as the page is scrolled down
   */
  function toggleScrolled() {
    const selectBody = document.querySelector('body');
    const selectHeader = document.querySelector('#header');
    if (!selectHeader.classList.contains('scroll-up-sticky') && !selectHeader.classList.contains('sticky-top') && !selectHeader.classList.contains('fixed-top')) return;
    window.scrollY > 50 ? selectBody.classList.add('scrolled') : selectBody.classList.remove('scrolled');
  }
 window.addEventListener('scroll', function () {
       var box = document.querySelector('.footer');
       var nav = document.querySelector('.navmenu'); 
       var main = document.querySelector('.main');
       var opacity = Math.min(window.scrollY / 500, 1);
       var gnbText = document.querySelectorAll('.navmenu li'); 
   
       // 네비게이션 배경 투명도 변
       /* nav.style.backgroundColor = 'rgba(255, 255, 255, ' + opacity + ')'; */
   
       // box 표시 및 숨기기
       if (window.scrollY > 50) {
           box.style.display = 'flex';
           setTimeout(function () {
               box.style.transform = 'translateY(0vh)';
           }, 10);
       } else {
           box.style.transform = 'translateY(100%)';
       }
       
       
       //글자색
       if (window.scrollY >= 50) {
           gnbText.forEach(function (text) {
               text.style.color = 'black';
           });
       } else {
           gnbText.forEach(function (text) {
               text.style.color = 'white';
           });
       }
       
   });
  document.addEventListener('scroll', toggleScrolled);
  window.addEventListener('load', toggleScrolled);

  /**
   * Mobile nav toggle
   */
  const mobileNavToggleBtn = document.querySelector('.mobile-nav-toggle');

  function mobileNavToogle() {
    document.querySelector('body').classList.toggle('mobile-nav-active');
    mobileNavToggleBtn.classList.toggle('bi-list');
    mobileNavToggleBtn.classList.toggle('bi-x');
  }
  if (mobileNavToggleBtn) {
    mobileNavToggleBtn.addEventListener('click', mobileNavToogle);
  }

  /**
   * Hide mobile nav on same-page/hash links
   */
  document.querySelectorAll('#navmenu a').forEach(navmenu => {
    navmenu.addEventListener('click', () => {
      if (document.querySelector('.mobile-nav-active')) {
        mobileNavToogle();
      }
    });

  });

  /**
   * Toggle mobile nav dropdowns
   */
  document.querySelectorAll('.navmenu .toggle-dropdown').forEach(navmenu => {
    navmenu.addEventListener('click', function(e) {
      e.preventDefault();
      this.parentNode.classList.toggle('active');
      this.parentNode.nextElementSibling.classList.toggle('dropdown-active');
      e.stopImmediatePropagation();
    });
  });

  /**
   * Preloader
   */
  const preloader = document.querySelector('#preloader');
  if (preloader) {
    window.addEventListener('load', () => {
      preloader.remove();
    });
  }

  /**
   * Scroll top button
   */
  let scrollTop = document.querySelector('.scroll-top');

  function toggleScrollTop() {
    if (scrollTop) {
      window.scrollY > 100 ? scrollTop.classList.add('active') : scrollTop.classList.remove('active');
    }
  }
  scrollTop.addEventListener('click', (e) => {
    e.preventDefault();
    window.scrollTo({
      top: 0,
      behavior: 'smooth'
    });
  });

  window.addEventListener('load', toggleScrollTop);
  document.addEventListener('scroll', toggleScrollTop);

  /**
   * Animation on scroll function and init
   */
  function aosInit() {
    AOS.init({
      duration: 600,
      easing: 'ease-in-out',
      once: true,
      mirror: false
    });
  }
  window.addEventListener('load', aosInit);

  /**
   * Init typed.js
   */
  const selectTypedF = document.querySelector('.typeFront');
  const selectTypedB = document.querySelector('.typeBack');
  if (selectTypedF && selectTypedB) {
    let typed_strings = selectTypedF.getAttribute('data-typed-items');
    typed_strings = typed_strings.split(',');
    new Typed('.typeFront', {
      strings: typed_strings,
      loop: true,
      typeSpeed: 100,
      backSpeed: 70,
      backDelay: 2000
    });
    new Typed('.typeBack', {
      strings: typed_strings,
      loop: true,
      typeSpeed: 100,
      backSpeed: 70,
      backDelay: 2000
    });
  }


  /**
   * Initiate Pure Counter
   */
  new PureCounter();

  /**
   * Animate the skills items on reveal
   */
  let skillsAnimation = document.querySelectorAll('.skills-animation');
  skillsAnimation.forEach((item) => {
    new Waypoint({
      element: item,
      offset: '80%',
      handler: function(direction) {
        let progress = item.querySelectorAll('.progress .progress-bar');
        progress.forEach(el => {
          el.style.width = el.getAttribute('aria-valuenow') + '%';
        });
      }
    });
  });

  /**
   * Init swiper sliders
   */
  function initSwiper() {
    document.querySelectorAll(".init-swiper").forEach(function(swiperElement) {
      let config = JSON.parse(
        swiperElement.querySelector(".swiper-config").innerHTML.trim()
      );

      if (swiperElement.classList.contains("swiper-tab")) {
        initSwiperWithCustomPagination(swiperElement, config);
      } else {
        new Swiper(swiperElement, config);
      }
    });
  }

  window.addEventListener("load", initSwiper);

  /**
   * Initiate glightbox
   */
  const glightbox = GLightbox({
    selector: '.glightbox'
  });

  /**
   * Init isotope layout and filters
   */
  
 
document.querySelectorAll('.isotope-layout').forEach(function(isotopeItem) {
    let layout = isotopeItem.getAttribute('data-layout') || 'masonry';
    let filter = isotopeItem.getAttribute('data-default-filter') || '*';
    let sort = isotopeItem.getAttribute('data-sort') || 'original-order';

    let initIsotope;
    imagesLoaded(isotopeItem.querySelector('.isotope-container'), function() {
        initIsotope = new Isotope(isotopeItem.querySelector('.isotope-container'), {
            itemSelector: '.isotope-item',
            layoutMode: layout,
            filter: filter,
            sortBy: sort
        });

        let isScrolled = false; // 스크롤이 한 번 발생했는지 체크
        const throttleDelay = 10; // 200ms마다 한 번씩만 호출
        let lastScrollTime = 0;
        let isFilterChanged = false; // 필터가 변경되었는지 확인하는 변수

        // 클릭 이벤트 후 필터 변경되지 않도록 설정
        const filterItems = isotopeItem.querySelectorAll('.isotope-filters li');
        filterItems.forEach(function(filters) {
            filters.addEventListener('click', function() {
                const activeFilter = isotopeItem.querySelector('.isotope-filters .filter-active');
                if (activeFilter) {
                    activeFilter.classList.remove('filter-active');
                }
                this.classList.add('filter-active');
                
                // 필터 변경된 상태로 설정
                isFilterChanged = true;

                // 필터 적용
                initIsotope.arrange({
                    filter: this.getAttribute('data-filter')
                });

                if (typeof aosInit === 'function') {
                    aosInit();
                }
            }, false);
        });

        // 스크롤 이벤트
        window.addEventListener('scroll', function () {
            // 클릭 이벤트 후 필터가 변경되었으면 더 이상 스크롤로 필터를 변경하지 않음
            if (isFilterChanged) {
                return; // 필터가 이미 변경된 상태에서는 아무 동작을 하지 않음
            }

            // 처음 스크롤이 발생했을 때만 "국어" 필터 활성화
            if (!isScrolled) {
                const koreanFilter = isotopeItem.querySelector('.isotope-filters li[data-filter=".filter-app"]');
                if (koreanFilter) {
                    koreanFilter.classList.add('filter-active'); // "국어" 필터를 초록색으로 활성화
                    isScrolled = true; // 스크롤이 한 번 발생했음을 표시
                }
            }

            // 일정 시간마다만 arrange() 호출
            const now = Date.now();
            if (now - lastScrollTime >= throttleDelay) {
                lastScrollTime = now;

                // "국어" 필터에 해당하는 클래스만 정렬
                initIsotope.arrange({
                    filter: '.filter-app' // "국어" 필터에 해당하는 클래스
                });
            }
        });

    });

    // 필터 클릭 처리
    isotopeItem.querySelectorAll('.isotope-filters li').forEach(function(filters) {
        filters.addEventListener('click', function() {
            const activeFilter = isotopeItem.querySelector('.isotope-filters .filter-active');
            if (activeFilter) {
                activeFilter.classList.remove('filter-active');
            }
            this.classList.add('filter-active');

            initIsotope.arrange({
                filter: this.getAttribute('data-filter')
            });

            if (typeof aosInit === 'function') {
                aosInit();
            }
        }, false);
    });
});


/* 화면전환 js */
// 처음 로딩 시 box 숨기기
   window.addEventListener('load', function () {
       var box = document.querySelector('.footer');
       box.style.display = 'none';
   });


// 메인 배너 스크롤 이벤트
document.addEventListener("scroll", () => {
	const backSection = document.querySelector(".hero.back");
	if (window.scrollY > 0) {
		backSection.classList.add("scrolled");
	} else {
		backSection.classList.remove("scrolled");
	}
});




})();


/*팝업배너*/
// 팝업 배너 요소
const popupBanner = document.getElementById('popup-banner');
// 닫기 버튼
const closeBtn = document.getElementById('close-btn');

// 팝업 배너를 표시하는 함수
function showPopup() {
  popupBanner.style.display = 'flex';  // 팝업 배너 보이게 하기
}

// 닫기 버튼 클릭 시 팝업을 닫는 함수
closeBtn.addEventListener('click', function() {
  popupBanner.style.display = 'none';  // 팝업 배너 숨기기
});

// 페이지 로드 시 팝업 띄우기
window.addEventListener('load', function() {
  setTimeout(showPopup, 100);
});



/*후기*/
// 옵션 설정
const options = {
  root: null,
  rootMargin: '0px',
  threshold: 0.5 // 50%
};

const observerCallback = (entries, observer) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.classList.add('is-visible');
      observer.unobserve(entry.target);
    }
  });
};

const observer = new IntersectionObserver(observerCallback, options);

//옵저빙
document.querySelectorAll('.review').forEach(review => {
  observer.observe(review);
});


/* 이스터에그 귀여워서..*/
const animals = [
  `
(\\(\\           ʕ•ᴥ•ʔ              (\\__/) 
( -.-)           sist?            (o.o ) 
o_(")(")     Final Project!!      (> <)

  `
];

document.addEventListener('keydown', function(event) {
  if (event.key === 'F12') {
    const randomAnimal = animals[Math.floor(Math.random() * animals.length)];
    console.log(randomAnimal);
  }
});
