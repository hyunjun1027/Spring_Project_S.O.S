<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="/resources/css/admin/adminLogin.css" rel="stylesheet">
<style>
*, ::after, ::before {
   box-sizing: unset;
}

.btn_img {
   position: relative;
}
</style>
<script type="text/javascript">
   $(document).ready(function() {
      adminLoginCheck();
      
      $("#admId").keyup(function(e) {
         if (e.which == 13) {
            fn_loginCheck();
         }
      });

      $("#admPwd").keyup(function(e) {
         if (e.which == 13) {
            fn_loginCheck();
         }
      });

      $("#admId").focus();
   });

   function fn_loginCheck() {
      if ($.trim($("#admId").val()).length <= 0) {

         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "아이디를 입력하세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#admId").val("");
         $("#admId").focus();
         return;

      }

      if ($.trim($("#admPwd").val()).length <= 0) {

         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "비밀번호를 입력하세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#admPwd").val("");
         $("#admPwd").focus();
         return;

      }

      $.ajax({
         type : "POST",
         url : "/admin/adminLogin",
         data : {
            admId : $("#admId").val(),
            admPwd : $("#admPwd").val()
         },
         dataType : "JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(res) {

            if (res.code == 0) {

               location.href = "/admin/index";

            } else if (res.code == -1) {

               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "비밀번호가 일치하지 않습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#admPwd").focus();

            } else if (res.code == 400) {

               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "파라미터가 올바르지 않습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#admId").focus();

            } else if (res.code == 403) {

               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "관리자 아이디를 사용할 수 없습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#admId").focus();

            } else if (res.code == 404) {

               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "관리자 정보가 존재하지 않습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#admId").focus();

            } else {

               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "로그인에 실패 하였습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#admId").focus();

            }

         },
         error : function(error) {

            Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "오류가 발생하였습니다.", 
                  showConfirmButton: false, 
                  timer: 1500 
                  });

            icia.common.error(error);
         }
      });

   }
   
   function adminLoginCheck() {
      $.ajax({
         type : "POST",
         url : "/admin/adminLoginCheck",
         data : {
            admId : $("#admId").val()
         },
         dataType : "JSON",
         beforeSend : function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
         },
         success : function(res) {

            if (res.code == 1) {
               Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "이미 로그인 하셨습니다.",
                  showConfirmButton: false, 
                  timer: 1500 
                  }).then(function() {
                  location.href = "/admin/index";
                  });

            }
            if (res.code == -999) {
               Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "접근 불가능한 사용자입니다.",
                  showConfirmButton: true, 
                  }).then(function() {
                  location.href = "/index";
                  });
            }
         },
         error : function(error) {

            Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "오류가 발생하였습니다.", 
                  showConfirmButton: false, 
                  timer: 1500 
                  });

            icia.common.error(error);
         }
      });
   }
</script>
</head>
<body id="adminLogin" style="background-color: #E6EBEE;">
   <div id="login" style="position: relative; top: 30%;">
      <div class="login-contents" style="">
         <div class="user-input">
            <form name="loginForm" id="loginForm" method="post" onsubmit="return false" style="height: 100%;">
               <div class="login_block">
                  <h2 style="margin-top: 5%; margin-bottom: 5%; font-size: 30px;">ADMIN LOGIN</h2>
               </div>
               <div class="input-id">
                  <!--  <label for="admId" style="position:relative; left: .4rem; top:-.1rem; height:3rem"><img src="/resources/img/account_icon.png" style="height:3.4rem;"></label> -->
                  <input type="text" id="admId" name="admId" style="font-size: 1rem; width: 70%; height: 3rem; margin-bottom: 3%;" maxlength="50" title="아이디 입력" placeholder="아이디 입력" value="ADMIN" />
               </div>
               <div class="input-password">
                  <!--  <label for="admPwd" style="position:relative; left: .4rem; top:-.1rem; height:3rem"><img src="/resources/img/password_icon.png" style="height:3.4rem;"></label> -->
                  <input type="password" id="admPwd" name="admPwd" style="font-size: 1rem; width: 70%; height: 3rem; margin-bottom: 3%;" maxlength="50" title="비밀번호 입력" placeholder="비밀번호 입력" value="1234" />
               </div>
            </form>
         </div>
         <a href="javascript:void(0)" onclick="fn_loginCheck()" class="btn_img"><img src="/resources/img/system_manager_login_btn.png" style="width: 30%; height: 15%;"><span class="image_text">LOGIN</span></a>
      </div>
   </div>
</body>
</html>