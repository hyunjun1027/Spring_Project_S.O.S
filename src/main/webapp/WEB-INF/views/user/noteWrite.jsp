<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<!-- mypage CSS File -->
<link href="/resources/css/mypage/mypage.css" rel="stylesheet">

<link href="/resources/css/mypage/mypageNoteWrite.css" rel="stylesheet">
<script>
$(document).ready(function(){
   let userRatingGet = "";
   
   $("#noteContent").focus();
   
   // 강사인지 학생인지 판별
   document.getElementById('isTeacherCheck').addEventListener('change', function () {
      userRatingGet = this.checked ? 'T' : 'U';
      document.noteSendForm.userRatingGet.value = userRatingGet;
    });


   
   
   //전송버튼 클릭
   $("#writeBtn").on("click", function(){
      
      $("#writeBtn").prop("disabled", true);
      
      if($.trim($("#noteContent").val()).length <= 0)
      {
         alert("내용을 입력하세요");
         $("#noteContent").val("");
         $("#noteContent").focus();
         
         $("#writeBtn").prop("disabled", false);
         return;
      }
      
      var form = $("#noteSendForm")[0];
      var formData = new FormData(form); //자바스크립트에서 폼 데이터를 다루는 객체
      
      $.ajax({
         type:"POST",
         enctype:"multipart/form-data",
         url:"/user/noteWriteProc",
         data:formData,
         processData:false,         //formData를 String으로 변환하지 않음.
         contentType:false,         //content-type 헤더가 multipart/form-data 로 전송하기 위함.
         cache:false,
         timeout:600000,
         beforeSend:function(xhr)
         {
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(response)
         {
            if(response.code == 0)
            {
               Swal.fire({
                    position: "center", 
                    icon: "success",
                    title: response.msg, 
                    showConfirmButton: false, 
                    timer: 1500 
                    }).then(function(){
                       location.href="/user/noteList";
                    })

            }
            else
            {
               Swal.fire({
                    position: "center", 
                    icon: "warning",
                    title: response.msg, 
                    showConfirmButton: false, 
                    timer: 1500 
                    });
               $("#writeBtn").prop("disabled", false);
            }
            
         },
         error:function(error)
         {
            icia.common.error(error);
            alert("쪽지 전송중 중 오류가 발생하였습니다.");
            $("#writeBtn").prop("disabled", false);
         }
         
      });
   });
   
   //목록 버튼 클릭
   $("#listBtn").on("click", function(){
      document.noteForm.action = "/user/noteList";
      document.noteForm.submit();
   });
   
   //userid에 이름 입력시 검색
   $("#userIdGet").on("change keyup paste", function(){
     fn_modal();
     fn_searchUser(); 
   });
   
   document.querySelector("#userIdGet").onfocus = function(e){
      fn_modal();
   }

});
//리스트값 가져오기
function fn_searchUser(){
   $.ajax({
     type:"POST",
     url:"/user/noteUserSearch",
     data:{
        userName:$("#userIdGet").val()
     },
     datatype:"JSON",
     beforeSend:function(xhr)
      {
         xhr.setRequestHeader("AJAX", "true");
      },
      success:function(res)
      {
         $("#modal-user").empty();
         for(let i = 0; i < res.data.length; i++){
            let userId = res.data[i].userId;
             let userName = res.data[i].userName;
             let rating = res.data[i].rating;
             fn_getList(userId, userName, rating);
             if(i == 6){
                break;
             }         
           }
      },
      error:function(error)
      {
         icia.common.error(error);
      }
   });
}
//모달에 리스트 추가
function fn_getList(userId, userName, rating){
   
   let list = '<div class="userListList">' + 
            '<ul class="userList">' + 
            '<li class="userId">' + userId + '</li>' + 
            '<li class="userName">' + userName + '(' + rating + ')' + '</li>' + 
            '</ul>' + 
            '</div>';
   $(".modal-user").append(list);
      const userListList = document.querySelectorAll(".userListList");
      userListList.forEach(userList => {
         userList.addEventListener('click', (event) => {
          const user = userList.querySelector(".userList");
          const userId = user.querySelector(".userId").textContent;
          document.getElementById("userIdGet").value = userId;
          $("#modal-user").empty();
          fn_closeModal();
        }); 
      });
}

/*모달*/
function fn_modal() {
    var modal = document.getElementById("modal-user");
    modal.style.display = "block"; 
      window.onclick = function(event) {
        if (event.target != modal && event.target != document.getElementById("userIdGet")) {
            modal.style.display = "none";
        }
    }
}
function fn_closeModal(){
   var modal = document.getElementById("modal-user");
   modal.style.display = "none";
}

</script>
</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <div class="container">
      <%@ include file="/WEB-INF/views/include/mypage/mypageUserInfo.jsp"%>


      <div class="rightBox contentContainer">
         <div class="contentBoardContainer">
            <div class="title-div board-header">
               <h2 class="first-title">나의 쪽지</h2>
            </div>
         </div>
      <form name="noteSendForm" id="noteSendForm" method="post" enctype="multipart/form-data" onsubmit="return false">
         <div class="textContainer" style="position:relative;">
            <strong><span class="stats-highlight">받는 사람</span></strong>
            <input type="text" name="userIdGet" id="userIdGet" class="sendEmailBox" placeholder="받을 아이디를 입력하세요." autocomplete="off">
            <input type="checkbox" name="isTeacher" id="isTeacherCheck" value="">
            <label for="isTeacherCheck">강사</label>
            <input type="hidden" name="userRatingGet" id="userRatingGet" value="U" >
         <div id="modal-user" class="modal-user">
<!--             <ul class="userList" style="list-style-type:none; margin:10px 5px; padding:0">
               <li class="userId" style="display:inline-block; width:59%;">사용자 아이디</li>
               <li class="userName" style="display:inline-block; width:39%;">사용자 이름</li>
            </ul> -->
         </div>
         </div>

         <div class="board-content">
            <textarea name="noteContent" id="noteContent" class="note-textarea" placeholder="내용을 입력하세요."></textarea>
         </div>
      </form>   
      
         <div class="btnContainer">
            <button type="button" id="writeBtn" class="inputBtn">
               <span>전송</span>
            </button>
            <button type="button" id="listBtn" class="inputBtn" onclick="fn_pageMove('noteList')">
               <span>목록</span>
            </button>
         </div>
      </div>
   
   <form name="noteForm" id="noteForm" method="post">
      <input type="hidden" name="curPage" value="${curPage}" />
   </form>
   
   
</body>
</html>