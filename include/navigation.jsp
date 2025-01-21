<%@page import="java.io.Console"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page import="com.sist.web.util.CookieUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script>
   function handleCredentialResponse(response) {
      const responsePayload = parseJwt(response.credential);
         console.log("ID: " + responsePayload.sub);
       console.log('Full Name: ' + responsePayload.name);
       console.log('Given Name: ' + responsePayload.given_name);
       console.log('Family Name: ' + responsePayload.family_name);
       console.log("Image URL: " + responsePayload.picture);
       console.log("Email: " + responsePayload.email);

         $.ajax({
         type:"POST",
         url:"/social/loginProc",
         data:{
            userId:responsePayload.sub,
            userName:responsePayload.name,
            userEmail:responsePayload.email
         },
         datatype:"JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(res) {
            if (!icia.common.isEmpty(res)) {
               icia.common.log(res);
               var code = icia.common.objectValue(res, "code", -500);
               if (code == 0) {
                  Swal.fire({
                     position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
                     icon: "success", // alert창에 뜨는 아이콘
                     title: res.msg, // alert창에 뜨는 제목
                     showConfirmButton: false, // confirm 버튼 여부
                     timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
                  }).then(function() {
                     location.reload(); // alert창이 닫히면 이동할 페이지
                  });
               } else {
                  Swal.fire({
                     position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
                     icon: "warning", // alert창에 뜨는 아이콘
                     title: res.msg, // alert창에 뜨는 제목
                     showConfirmButton: false, // confirm 버튼 여부
                     timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
                  });
               }
            } else {
               Swal.fire({
                  position: "center", // alert창이 뜨는 위치 (화면 기준, ex: top-end : 오른쪽 상단) 
                  icon: "error", // alert창에 뜨는 아이콘
                  title: "오류가 발생했습니다", // alert창에 뜨는 제목
                  showConfirmButton: false, // confirm 버튼 여부
                  timer: 1000 // 자동으로 닫힐 때까지 걸리는 시간 (1초)
                 });
            }
         }
         
      });
   }
   function parseJwt (token) {
       var base64Url = token.split('.')[1];
       var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
       var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
           return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
       }).join(''));

       return JSON.parse(jsonPayload);
   };
   window.onload = function(){
      google.accounts.id.initialize({
         client_id:"635546929860-mvdqeh28gne9ogtlone6365fk4p6coep.apps.googleusercontent.com",
         callback: handleCredentialResponse,
         login_uri: "http://localhost:8088"
         
      });
      google.accounts.id.renderButton(
           document.getElementById("google-login-btn1"),
           {shape:"rectangular", theme: "outline", size: "middle", width:"300", opacity:"0"}  // customization attributes
       );
   }

      document.addEventListener('DOMContentLoaded', function () {
         
         calculateDDay();
         
         
          let lastScrollTop = 0; // 마지막 스크롤 위치 저장
          const navbar = document.querySelector('.header'); // 네비게이션 바 선택
      
          window.addEventListener('scroll', function () {
              const currentScroll = window.pageYOffset || document.documentElement.scrollTop;
      
              // 스크롤 방향에 따라 헤더 숨기기/보이기
              if (currentScroll > lastScrollTop) {
                  // 스크롤 다운: 네비게이션 바 숨기기
                  navbar.style.top = '-100px'; // 헤더 높이에 맞게 조정
              } else {
                  // 스크롤 업: 네비게이션 바 보이기
                  navbar.style.top = '0';
              }
      
              // 스크롤 위치 업데이트
              lastScrollTop = currentScroll <= 0 ? 0 : currentScroll; // 음수 방지
          });
      });

      document.addEventListener('DOMContentLoaded', function() {

      // 모달 관련 요소들
      const modal = document.getElementById('login-modal');
      const closeModal = document.getElementById('close-modal');
      const modalTitle = document.getElementById('modal-title');

      // 모달 내 섹션들
      const loginSection = document.getElementById('login-section');
      const findIdSection = document.getElementById('find-id-section');
      const findPwSection = document.getElementById('find-pw-section');

      // 각 링크 및 버튼들
      const findIdLink = document.getElementById('find-id-link');
      const findPwLink = document.getElementById('find-pw-link');
      const findIdLink2 = document.getElementById('find-id-link2');
      const findPwLink2 = document.getElementById('find-pw-link2');
      const loginModalBtn = document.getElementById('modal-login-btn');

      const loginBtn = document.getElementById('login-btn');
      const findIdBtn = document.getElementById('find-id-btn');
      const findPwBtn = document.getElementById('find-pw-btn');

     // 모달 리셋 함수
     function resetModal() {
        loginSection.style.display = 'block';
        findIdSection.style.display = 'none';
        findPwSection.style.display = 'none';
        $("#login-modal").find("input[type='text'], input[type='password']").each(function() {
           $(this).val(""); // 텍스트 및 비밀번호 필드 초기화
        });
        modalTitle.textContent = 'LOGIN';
     }


      // 모달 열기
      loginModalBtn.addEventListener('click', function(event) {
         event.preventDefault();
         resetModal(); // 모달 리셋
         modal.style.display = 'flex'; // 모달 표시
      });

      // 모달 닫기
      closeModal.addEventListener('click', function() {
         modal.style.display = 'none';
      });

      // 외부 클릭 시 모달 닫기
      window.addEventListener('click', function(event) {
         if (event.target === modal) {
            modal.style.display = 'none';
         }
      });

      // 아이디 찾기 모달 전환
      findIdLink.addEventListener('click', function(event) {
         event.preventDefault();
         loginSection.style.display = 'none';
         findIdSection.style.display = 'block';
         findPwSection.style.display = 'none';
         modalTitle.textContent = 'FIND ID';
      });

      findIdLink2.addEventListener('click', function(event) {
         event.preventDefault();
         loginSection.style.display = 'none';
         findIdSection.style.display = 'block';
         findPwSection.style.display = 'none';
         modalTitle.textContent = 'FIND ID';
      });

      // 비밀번호 찾기 모달 전환
      findPwLink.addEventListener('click', function(event) {
         event.preventDefault();
         loginSection.style.display = 'none';
         findIdSection.style.display = 'none';
         findPwSection.style.display = 'block';
         modalTitle.textContent = 'FIND PASSWORD';
      });
      findPwLink2.addEventListener('click', function(event) {
         event.preventDefault();
         loginSection.style.display = 'none';
         findIdSection.style.display = 'none';
         findPwSection.style.display = 'block';
         modalTitle.textContent = 'FIND PASSWORD';
      });

      // 로그인 버튼 클릭
      loginBtn.addEventListener('click', function(event) {
         event.preventDefault();
         fn_login();
      });

      // 아이디 찾기 버튼 클릭
      findIdBtn.addEventListener('click', function(event) {
         event.preventDefault();
         fn_findId();
      });

      // 비밀번호 찾기 버튼 클릭
      findPwBtn.addEventListener('click', function(event) {
         event.preventDefault();
         fn_findPwd();
      });

      function fn_login() {
         //공백 체크
         var emptCheck = /\s/g;
         if ($.trim($("#loginUserId").val()).length <= 0) {
            Swal.fire({
               position: "center",
               icon: "warning",
               title: "아이디를 입력하세요",
               showConfirmButton: false,
               timer: 1000
            }).then(function() {
               $("#loginUserId").val("");
               $("#loginUserId").focus();
               return;
            });
         }
         
         if (emptCheck.test($("#loginUserId").val())) {
            Swal.fire({
               position: "center",
               icon: "warning",
               title: "아이디는 공백을 포함할 수 없습니다",
               showConfirmButton: false,
               timer: 1000
            }).then(function() {
               $("#loginUserId").val("");
               $("#loginUserId").focus();
               return;
            });
         }
         
         if ($.trim($("#loginUserPwd").val()).length <= 0) {
            Swal.fire({
               position: "center",
               icon: "warning",
               title: "비밀번호를 입력하세요",
               showConfirmButton: false,
               timer: 1000
            }).then(function() {
               $("#loginUserPwd").val("");
               $("#loginUserPwd").focus();
               return;
            });
         }
         
         if (emptCheck.test($("#loginUserPwd").val())) {
            Swal.fire({
               position: "center",
               icon: "warning",
               title: "비밀번호는 공백을 포함할 수 없습니다",
               showConfirmButton: false,
               timer: 1000
            }).then(function() {
               $("#loginUserPwd").val("");
               $("#loginUserPwd").focus();
               return;
            });
         }
         
         var form = $("#loginForm")[0];
         var formData = new FormData(form);
         
         $.ajax({
            type : "POST",
            url : "/account/loginProc",
            data : formData,
            processData : false,
            contentType : false,
            beforeSend : function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success : function(res) {
               if (!icia.common.isEmpty(res)) {
                  icia.common.log(res);
                  var code = icia.common.objectValue(res, "code", -500);
                  if (code == 0) {
                     if (res.data == 'Y') {
                        location.reload();
                     } else if (res.data == 'P') {
                        location.href = "/user/changePwd";
                     }
                  } else {
                     Swal.fire({
                        position: "center",
                        icon: "warning",
                        title: res.msg,
                        showConfirmButton: false,
                        timer: 1500
                     }).then(function() {
                        $("#userId").focus();
                     });
                  }
               } else {
                  Swal.fire({
                     position: "center",
                     icon: "error",
                     title: "오류가 발생하였습니다",
                     showConfirmButton: false,
                     timer: 1500
                  }).then(function() {
                     $("#userIdLogin").focus();
                  });
               }
            }
         });
      }
      
      function fn_findId() {
         var form = $("#find-id-Form")[0];
         var formData = new FormData(form);

         $.ajax({
            type : "POST",
            url : "/account/idSearchProc",
            data : formData,
            processData : false,
            contentType : false,
            beforeSend : function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success : function(res) {
               if (!icia.common.isEmpty(res)) {
                  icia.common.log(res);
                  var code = icia.common.objectValue(res, "code", -500);
                  if (code == 0) {
                     Swal.fire({
                         title: res.data,
                          icon: "success",
                          draggable: true
                     }).then(function() {
                        location.href = "/";
                     });
                  } else {
                     Swal.fire({
                        position: "center",
                        icon: "warning",
                        title: res.msg,
                        showConfirmButton: false,
                        timer: 1000
                     }).then(function() {
                        $("#idUserName").focus();
                     });
                  }
               } else {
                  Swal.fire({
                     position: "center",
                     icon: "error",
                     title: "오류가 발생하였습니다",
                     showConfirmButton: false,
                     timer: 1000
                  }).then(function() {
                     $("#idUserName").focus();
                  });
               }
            }
         });
      }
      function fn_findPwd() {
         var form = $("#find-pw-Form")[0];
         var formData = new FormData(form);
         $.ajax({
            type : "POST",
            url : "/account/pwdSearchProc",
            data : formData,
            processData : false,
            contentType : false,
            beforeSend : function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success : function(res) {
               if (!icia.common.isEmpty(res)) {
                  icia.common.log(res);
                  var code = icia.common.objectValue(res, "code", -500);
                  if (code == 0) {
                     Swal.fire({
                        position: "center",
                        icon: "success",
                        title: "메일 보내기",
                        showConfirmButton: false,
                        timer: 1000
                     }).then(function() {
                        fn_sendPwMail();
                     });
                  } else {
                     Swal.fire({
                        position: "center",
                        icon: "warning",
                        title: res.msg,
                        showConfirmButton: false,
                        timer: 1000
                     }).then(function() {
                        $("#pwdUserId").focus();
                     });
                  }
               } else {
                  Swal.fire({
                     position: "center",
                     icon: "error",
                     title: "오류가 발생하였습니다",
                     showConfirmButton: false,
                     timer: 1000
                  }).then(function() {
                     $("#pwdUserId").focus();
                  });
               }
            }
         });
      }
      function fn_sendPwMail() {
         var form = $("#find-pw-Form")[0];
         var formData = new FormData(form);
         $.ajax({
            type : "POST",
            url : "/mail/sendMail",
            data : {
               userId : $("#pwUserId").val(),
               userEmail : $("#pwUserEmail").val(),
               rating : $(":input:radio[name=find-pw-rating]:checked").val()
            },
            datatype : "JSON",
            beforeSend : function(xhr) {
               xhr.setRequestHeader("AJAX", "true");
            },
            success : function(res) {
               if (!icia.common.isEmpty(res)) {
                  icia.common.log(res);
                  var code = icia.common.objectValue(res, "code", -500);
                  if (code == 0) {
                     Swal.fire({
                        position: "center",
                        icon: "success",
                        title: res.msg,
                        showConfirmButton: false,
                        timer: 1000
                     });
                  } else {
                     Swal.fire({
                        position: "center",
                        icon: "warning",
                        title: res.msg,
                        showConfirmButton: false,
                        timer: 1000
                     }).then(function() {
                        $("#pwdUserId").focus();
                     });
                  }
               } else {
                  Swal.fire({
                     position: "center",
                     icon: "error",
                     title: "오류가 발생하였습니다",
                     showConfirmButton: false,
                     timer: 1000
                  }).then(function() {
                     $("#pwdUserId").focus();
                  });
               }
            },
            error : function(xhr, status, error) {
               icia.common.error(error);
            }
         });
      }

   });

   // 선생님 페이지 이동 함수
   function fn_naviSubjectType(index) {
      document.naviTeacherTypeForm.classCode.value = index;
      document.naviTeacherTypeForm.action = "/teach/teachList";
      document.naviTeacherTypeForm.submit();
   }

   // 교재 과목별 이동 함수
   function fn_listBook(classCode) {
      document.naviTeacherTypeForm.curPage.value = "1";
      document.naviTeacherTypeForm.classCode.value = classCode;
      document.naviTeacherTypeForm.action = "/book/book";
      document.naviTeacherTypeForm.submit();
   }
   
   function fn_prevQueList() {
      document.naviTeacherTypeForm.curPage.value = "1";
      document.naviTeacherTypeForm.classCode.value = 1;
      document.naviTeacherTypeForm.action = "/dataroom/prevQueList";
      document.naviTeacherTypeForm.submit();
   }
   
   //D-day 계산
   function calculateDDay() {
      const dDayElement = document.getElementById('d-day-display');
       if (dDayElement) { // 요소가 존재할 때만 실행
         const today = new Date(); // 오늘 날짜
         const examDate = new Date("2025-11-13"); // 수능 날짜

         // 밀리초 단위 차이 계산
         const diff = examDate - today;

         // D-Day 계산 (일 단위로 변환)
         const dDay = Math.ceil(diff / (1000 * 60 * 60 * 24));

         const daysElement = document.querySelector(".days"); // class="days" 요소 가져오기
         daysElement.innerHTML = "D-" + dDay;
       }
   }
   
   //네이버 로그인
   function fn_naverLogin() {
      let _width = 500;
        let _height = 600;
        
        let _left = Math.ceil((window.screen.width - _width) / 2);
        let _top = Math.ceil((window.screen.height - _height) / 2);
        
        // 부모 페이지에 흐림 효과 추가
        document.querySelector('body').classList.add('blur-background');
     
        naverPopup = window.open("/login/naver", "네이버 로그인", "width="+_width+", height="+_height+", left="+_left+", top="+_top+", resizable=false, scrollbars=false, status=false, titlebar=false, toolbar=false, menubar=false");
      
      // 팝업 창이 닫히는지 감지하여 흐림 효과 제거
       const timer = setInterval(() => {
           if (naverPopup.closed) {
               clearInterval(timer);  // 타이머 정지
               document.querySelector('body').classList.remove('blur-background');  // 흐림 해제
           }
       }, 500);  // 0.5초마다 팝업 상태 체크
   }
</script>



<header id="header" class="header d-flex align-items-center fixed-top">
   <div class="container-fluid container-xl position-relative d-flex align-items-center justify-content-between">

      <a href="/index" class="logo d-flex align-items-center"> <!-- Uncomment the line below if you also wish to use an image logo --> <!-- <img src="assets/img/logo.png" alt=""> -->
         <h1 class="sitename"><img alt="" src="/resources/img/logo_white.png"> </h1>
      </a>

      <nav id="navmenu" class="navmenu">
         <ul>
            <li><a href="/course/allCourse">모든 강좌</a></li>
            <li><a href="javascript:void(0)" onclick="fn_naviSubjectType(1)" >선생님</a></li>
            <li class="dropdown"><a href="#" style="cursor: auto;"><span>게시판</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
               <ul>
                  <li><a href="/board/noticeList">공지사항</a></li>
                  <li><a href="/board/qnaList">문의사항</a></li>
                  <li><a href="/board/freeList">자유게시판</a></li>
                  <li><a href="/board/faqList">자주 묻는 질문</a></li>
               </ul></li>

            <li class="dropdown"><a href="#" onclick="fn_prevQueList()"><span>기출문제</span></a>
            <li class="dropdown"><a href="#" style="cursor: auto;"><span>교재</span> <i class="bi bi-chevron-down toggle-dropdown"></i></a>
               <ul>
                  <li><a href=# onclick="fn_listBook(1)">국어</a></li>
                  <li><a href=# onclick="fn_listBook(2)">영어</a></li>
                  <li><a href=# onclick="fn_listBook(3)">수학</a></li>
                  <li><a href=# onclick="fn_listBook(4)">사회</a></li>
                  <li><a href=# onclick="fn_listBook(5)">과학</a></li>
               </ul></li>
            <!-- <li><a href="/user/mypage">마이페이지</a></li>
            <li><a href="" id="modal-login-btn">로그인</a></li> -->
               <%
                  if (com.sist.web.util.CookieUtil.getCookie(request, (String) request.getAttribute("AUTH_COOKIE_NAME")) == null) {
               %>
               <li><a href="" class="modal-login-btn" id="modal-login-btn"><img src="/resources/img/ico_user.png" alt="Clover Image"></a></li>
               <%
                  } else { 
               %>
               <li><a href="/account/logoutProc" class="modal-logout-btn" id="modal-logout-btn"><img src="/resources/img/log_out.png" alt="Clover Image"></a></li>
               <%
                  if ((com.sist.web.util.CookieUtil.getHexValue(request, "RATING")).equals("A")) {
               %>
                     <li><a href="/admin/index" class="modal-mypage-btn"><img src="/resources/img/my_page.png" alt="Clover Image"></a></li>
               <%
                  } else {
               %>
                     <li><a href="/user/mypage" class="modal-mypage-btn"><img src="/resources/img/my_page.png" alt="Clover Image"></a></li>
               <%
                  }
               %>
               <li><a href="/order/basket" class="modal-cart-btn" id="modal-cart-btn"><img src="/resources/img/pc_ic_cart.png" alt="Clover Image">
               <div id="cartCount" style="position:absolute; display:flex; align-items:center; justify-content:center; width:65%; height:75%; background-color:red; left:60%; top:50%; font-size:10px; border-radius:50%;"><b style="">${cartCount }</b></div>

               </a></li>
               <%} %>
         </ul>
         <i class="mobile-nav-toggle d-xl-none bi bi-list"></i>
      </nav>
   </div>

   <!-- 로그인 모달 -->
   <div id="login-modal" class="modal">
      <div class="modal-content">
         <h1 id="modal-title">LOGIN</h1>
         <form class="login-form" id="loginForm" name="loginForm" method="post" action="/account/loginProc">
            <!-- 로그인 섹션 -->
            <div id="login-section">
               <div class="input_box">
                  <div class="left-box radio-box">
                     <input type="radio" id="login-userCheck" name="login-rating" value="U" checked>
                     <label for="login-userCheck">학생</label>
                  </div>
                  <div class="right-box radio-box">
                     <input type="radio" id="login-teachCheck" name="login-rating" value="T">
                     <label for="login-teachCheck">강사</label>
                  </div>
               </div>
               <div class="input_box">
                  <input type="text" id="loginUserId" name="loginUserId" class="form_input" maxlength="20" required>
                  <label class="sub_cont" for="loginUserId">ID</label> <span class="under_bar"></span>
               </div>
               <div class="input_box">
                  <input type="password" id="loginUserPwd" name="loginUserPwd" class="form_input" maxlength="20" required>
                  <label class="sub_cont" for="loginUserPwd">PASSWORD</label> <span class="under_bar"></span>
               </div>
               <div class="input_box btn-box">
                  <button type="button" id="login-btn" name="login-btn" class="login-btn" style="margin-bottom: 0px">
                     <span>LOGIN</span>
                  </button>
                  <button type="button" id="naver-login-btn" name="login-btn" class="login-btn" style="margin-bottom: 0px" onclick="fn_naverLogin()">
                     <span>NAVER</span>
                  </button>
                  
                  <button type="button" id="google-login-btn" name="login-btn" class="login-btn" style="padding: 0px; position:relative; height:40px;">
                     <div id="google-login-btn1" style="opacity:0; position:absolute;" ></div>
                     <span>GOOGLE</span>
                  </button>
               </div>
               <div class="extra-options">
                  <div class="find-options">
                     <a href="#" id="find-id-link">아이디 찾기</a> · <a href="#" id="find-pw-link">비밀번호 찾기</a>
                  </div>
                  <a href="/account/joinForm">회원가입</a>
               </div>
            </div>
         </form>

         <form class="login-form" id="find-id-Form" name="find-id-Form" method="post">
            <!-- 아이디 찾기 섹션 -->
            <div id="find-id-section" style="display: none;">
               <div class="input_box">
                  <div class="left-box radio-box">
                     <input type="radio" id="find-id-userCheck" name="find-id-rating" value="U" checked>
                     <label for="find-id-userCheck">학생</label>
                  </div>
                  <div class="right-box radio-box">
                     <input type="radio" id="find-id-teachCheck" name="find-id-rating" value="T">
                     <label for="find-id-teachCheck">강사</label>
                  </div>
               </div>
               <div class="input_box">
                  <input type="text" id="idUserName" name="idUserName" class="form_input" maxlength="20" required>
                  <label class="sub_cont" for="idUserName">NAME</label> <span class="under_bar"></span>
               </div>
               <div class="input_box">
                  <input type="text" id="idUserEmail" name="idUserEmail" class="form_input" maxlength="50" required>
                  <label class="sub_cont" for="idUserEmail">EMAIL</label> <span class="under_bar"></span>
               </div>
               <div class="input_box">
                  <input type="text" id="idUserPhone" name="idUserPhone" class="form_input" maxlength="50" required>
                  <label class="sub_cont" for="idUserPhone">Phone</label> <span class="under_bar"></span>
               </div>
               <div class="input_box btn-box">
                  <button type="button" id="find-id-btn" name="find-id-btn" class="login-btn">
                     <span>FIND ID</span>
                  </button>
               </div>
               <div class="extra-options">
                  <div class="find-options">
                     <a href="#" id="find-pw-link2">비밀번호 찾기</a>
                  </div>
                  <a href="/account/joinForm">회원가입</a>
               </div>
            </div>
         </form>


         <form class="login-form" id="find-pw-Form" name="find-pw-Form" method="post">
            <!-- 비밀번호 찾기 섹션 -->
            <div id="find-pw-section" style="display: none;">
               <div class="input_box">
                  <div class="left-box radio-box">
                     <input type="radio" id="find-pw-userCheck" name="find-pw-rating" value="U" checked>
                     <label for="find-pw-userCheck">학생</label>
                  </div>
                  <div class="right-box radio-box">
                     <input type="radio" id="find-pw-teachCheck" name="find-pw-rating" value="T">
                     <label for="find-pw-teachCheck">강사</label>
                  </div>
               </div>
               <div class="input_box">
                  <input type="text" id="pwUserId" name="pwUserId" class="form_input" maxlength="20" required>
                  <label class="sub_cont" for="pwUserId">ID</label> <span class="under_bar"></span>
               </div>
               <div class="input_box">
                  <input type="text" id="pwUserName" name="pwUserName" class="form_input" maxlength="20" required>
                  <label class="sub_cont" for="pwUserName">NAME</label> <span class="under_bar"></span>
               </div>
               <div class="input_box">
                  <input type="text" id="pwUserEmail" name="pwUserEmail" class="form_input" maxlength="50" required>
                  <label class="sub_cont" for="pwUserEmail">EMAIL</label> <span class="under_bar"></span>
               </div>
               <div class="input_box">
                  <input type="text" id="pwUserPhone" name="pwUserPhone" class="form_input" maxlength="50" required>
                  <label class="sub_cont" for="pwUserPhone">Phone</label> <span class="under_bar"></span>
               </div>
               <div class="input_box btn-box">
                  <button type="button" id="find-pw-btn" name="find-pw-btn" class="login-btn">
                     <span>FIND PASSWORD</span>
                  </button>
               </div>
               <div class="extra-options">
                  <div class="find-options">
                     <a href="#" id="find-id-link2">아이디 찾기</a>
                  </div>
                  <a href="/account/joinForm">회원가입</a>
               </div>
            </div>
         </form>

         <input type="hidden" class="close-btn" id="close-modal">
      </div>
   </div>

   <form id="naviTeacherTypeForm" name="naviTeacherTypeForm" method="post">
      <input type="hidden" name="classCode" value="">
      <input type="hidden" name="curPage" value="">
   </form> 
</header>

