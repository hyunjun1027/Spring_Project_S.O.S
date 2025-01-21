<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<!-- Main CSS File -->
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/teach/teachCourse.css" rel="stylesheet">
<style>
.header {
   background: #b5aaf2;
}
</style>
<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(2)>a").addClass("active");
   });

   // 페이징 버튼 클릭 시 실행
   function fn_listView(curPage) {
      document.teacherTypeForm.curPage.value = curPage;
       document.teacherTypeForm.teacherId.value = "${teacher.userId }";
       document.teacherTypeForm.classCode.value = ${classCode};
      document.teacherTypeForm.action = "/teach/teachCourse";
      document.teacherTypeForm.submit();
   }

   // 강사페이지 메뉴바 이동
   function fn_teachMove(url) {
       document.teacherTypeForm.classCode.value = ${classCode};
       document.teacherTypeForm.teacherId.value = "${teacher.userId }";
       document.teacherTypeForm.curPage.value = 1;
      document.teacherTypeForm.action = "/teach/" + url;
      document.teacherTypeForm.submit(); 
   }

   //코스 메인페이지 이동
   function fn_courseMove(courseCode,myCourseChk)
   {
      if(myCourseChk == 1)
      {
          document.teacherTypeForm.classCode.value = ${classCode};
          document.teacherTypeForm.teacherId.value = "${teacher.userId }";
          document.teacherTypeForm.curPage.value = 1;
          document.teacherTypeForm.courseCode.value = courseCode;
         document.teacherTypeForm.action = "/course/courseMain";
         document.teacherTypeForm.submit(); 
      }
      else if(myCourseChk == 0)
      {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "수강신청을 먼저 진행해주세요", 
              showConfirmButton: false, 
              timer: 1500 
              });

      }
         
   }
   
   
   // 강사페이지 사이드바 이동
   function fn_subjectType(index) {
       document.teacherTypeForm.classCode.value = index;
      document.teacherTypeForm.action = "/teach/teachList";
      document.teacherTypeForm.submit(); 
   }
   
   // 코스 상세보기 이동
   function fn_coursePage(courseCode) {
       if ("${account}" != null && "${account}" != "") {
          $.ajax({
               type: "POST",
               url: "/course/myCourseSelect",
               data: {
                   userId: '${account.userId}',
                   courseCode: courseCode
               },
               dataType: "JSON",
               beforeSend: function (xhr) {
                   xhr.setRequestHeader("AJAX", "true");
               },
               success: function (res) {
                   if (res.code == 0) {
                      Swal.fire({
                           title: "수강신청하시겠습니까?",
                           icon: "warning",
                           showCancelButton: true,
                           confirmButtonColor: "#3085d6",
                           cancelButtonColor: "#d33",
                           confirmButtonText: "확인",
                         cancelButtonText:"취소"
                         }).then((result) => {
                           if (result.isConfirmed) {

                           $.ajax({
                               type: "POST",
                               url: "/course/myCourseInsert",
                               data: {
                                   userId: '${account.userId}',
                                   courseCode: courseCode
                               },
                               dataType: "JSON",
                               beforeSend: function (xhr) {
                                   xhr.setRequestHeader("AJAX", "true");
                               },
                               success: function (res) {
                                   if (res.code == 0) {
                                       document.teacherTypeForm.classCode.value = ${classCode};
                                       document.teacherTypeForm.courseCode.value = courseCode;
                                       document.teacherTypeForm.action = "/course/courseMain";
                                       document.teacherTypeForm.submit();
                                   } else {
                                      Swal.fire({
                                         position: "center", 
                                         icon: "warning",
                                         title: "오류 발생", 
                                         showConfirmButton: false, 
                                         timer: 1500 
                                         });

                                   }
                               },
                               error: function (xhr, status, error) {
                                  Swal.fire({
                                     position: "center", 
                                     icon: "warning",
                                     title: "오류 발생...", 
                                     showConfirmButton: false, 
                                     timer: 1500 
                                     });

                                   console.error(error);
                               }
                           });
                       }
                   });
                   } else if(res.code == 1) {
                       document.teacherTypeForm.classCode.value = ${classCode};
                       document.teacherTypeForm.courseCode.value = courseCode;
                       document.teacherTypeForm.action = "/course/courseMain";
                       document.teacherTypeForm.submit();
                   } else {
                      Swal.fire({
                          position: "center", 
                          icon: "warning",
                          title: "오류 발생", 
                          showConfirmButton: false, 
                          timer: 1500 
                          });
                   }
               },
               error: function (xhr, status, error) {
                  Swal.fire({
                      position: "center", 
                      icon: "warning",
                      title: "오류 발생...", 
                      showConfirmButton: false, 
                      timer: 1500 
                      });
                   console.error(error);
               }
           });
       } else {
          Swal.fire({
              position: "center", 
              icon: "warning",
              title: "로그인을 먼저 진행해주세요", 
              showConfirmButton: false, 
              timer: 1500 
              });

       }
   }
   
   /*********모달********/
   // 교재 찾기 새창 열기
   function openSearchWindow(event) 
   {
       // 클릭 이벤트 전파 방지
       if (event) {
           event.stopPropagation();
           event.preventDefault();
       }

       // 새 창 열기
       const searchUrl = `http://localhost:8088/teach/teachBookSearch`;
       const newWindow = window.open(searchUrl, "_blank", "width=1000, height=700, scrollbars=yes");

       // 새 창 열기가 차단되었을 경우 경고
       if (!newWindow) {
          Swal.fire({
              position: "center", 
              icon: "warning",
              title: "팝업이 차단되었습니다. 팝업 차단 설정을 확인하세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

       }
   }
   

   
   //모달 열기
   function fn_registerCourse() {
       const modal = document.getElementById("courseModal");
       modal.style.display = "block";

   }
   
   //모달 닫기
   function closeModal() {
       const modal = document.getElementById("courseModal");
       modal.style.display = "none";

       $("#courseName").val("");
       $("#bookDetail").val("");
       $("#bookSeq").val("");
       $("#courseDetail").val("");
   }
   
   // Esc 키 입력 방지
   document.addEventListener("keydown", function (event) {
       if (event.key === "Escape") {
           event.preventDefault(); // 기본 동작 방지
       }
   });

   
   // 모달 배경 클릭 방지
   document.getElementById("courseModal").addEventListener("click", function (event) {
       if (event.target === this) {
           // 모달의 배경을 클릭해도 닫히지 않도록 전파 중단
           event.stopPropagation();
       }
   });
   

   
   //코스 등록 버튼 클릭시
   function submitCourse()
   {
      
      $("#writeBtn").prop("disabled", true);
      
       if (event) {
           event.stopPropagation();
           event.preventDefault();
       }
       
      if($.trim($("#courseName").val()).length <= 0)
      {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "코스명을 입력하세요", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#courseName").val("");
         $("#courseName").focus();
         $("#writeBtn").prop("disabled", false);

         return;
      }
      
      if($.trim($("#courseDetail").val()).length <= 0)
      {
         Swal.fire({
              position: "center", 
              icon: "warning",
              title: "코스상세내용을 입력하세요", 
              showConfirmButton: false, 
              timer: 1500 
              });

         $("#courseDetail").val("");
         $("#courseDetail").focus();
         $("#writeBtn").prop("disabled", false);

         return;
      }
      

      
      var form = $("#courseForm")[0];
      var formData = new FormData(form); //자바스크립트에서 폼 데이터를 다루는 객체
      
      $.ajax({
         type:"POST",
         enctype:"multipart/form-data",
         url:"/teach/courseInsert",
         data:formData,
         processData:false,         
         contentType:false,         
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
               $("#writeBtn").prop("disabled", false);
               
               Swal.fire({
                     position: "center", 
                     icon: "success",
                     title: "코스 등록 완료", 
                     showConfirmButton: false, 
                     timer: 1500 
               }).then(function() {
                   closeModal();
                   document.courseForm.submit();
                   document.courseForm.acion="/teach/teachCourse";
               });

            }
            else if(response.code == -401)
            {
               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "파라미터 오류", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#writeBtn").prop("disabled", false);
            }
            else if(response.code == -101)
            {
               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "권한이 없습니다1.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#writeBtn").prop("disabled", false);
            }
            else if(response.code == 100)
            {
               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "사용자 권한이 없습니다.", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

               $("#writeBtn").prop("disabled", false);
            }
         },
         error:function(error)
         {
            icia.common.error(error);
            Swal.fire({
                  position: "center", 
                  icon: "warning",
                  title: "코스 등록 중 오류 발생", 
                  showConfirmButton: false, 
                  timer: 1500 
                  });

            $("#writeBtn").prop("disabled", false);
         }
         
      });

   }
   
   //코스 삭제
   function fn_courseDel(courseCode)
   {
      Swal.fire({
           title: "해당 코스를 삭제하시겠습니까?",
           icon: "warning",
           showCancelButton: true,
           confirmButtonColor: "#3085d6",
           cancelButtonColor: "#d33",
           confirmButtonText: "삭제",
         cancelButtonText:"취소"
         }).then((result) => {
           if (result.isConfirmed) {

         $.ajax({
            type:"POST",
            url:"/teach/courseDelete",
            dataType:"JSON",
            data:{
               courseCode:courseCode
            },
            beforeSend:function(xhr){
               xhr.setRequestHeader("AJAX", "true");
            },
            success:function(response){
               if(response.code == 0)
               {
                  Swal.fire({
                        position: "center", 
                        icon: "success",
                        title: "해당 코스 삭제 완료", 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

                  document.teacherTypeForm.action = "/teach/teachCourse";
                  document.teacherTypeForm.submit();
               }
               else if(response.code == -401)
               {
                  Swal.fire({
                        position: "center", 
                        icon: "warning",
                        title: "파라메타 오류", 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
               else if(response.code == -400)
               {
                  Swal.fire({
                        position: "center", 
                        icon: "warning",
                        title: "파라메타 오류2", 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
               else if(response.code == -100)
               {
                  Swal.fire({
                        position: "center", 
                        icon: "warning",
                        title: "로그인을 먼저 진행해주세요", 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
               else if(response.code == -101)
               {
                  Swal.fire({
                        position: "center", 
                        icon: "warning",
                        title: "삭제권한이 없습니다.", 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
               else if(response.code == 40)
               {
                  Swal.fire({
                        position: "center", 
                        icon: "warning",
                        title: "코스가 없습니다.", 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

               }
            },
            error:function(xhr, status, error)
            {
               icia.common.error(error);
               Swal.fire({
                     position: "center", 
                     icon: "warning",
                     title: "코스 삭제 중 중 오류가 발생하였습니다.!", 
                     showConfirmButton: false, 
                     timer: 1500 
                     });

            }
         });
      }
   });
   }

</script>

</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <section class="notice-section">
      <div class="notice-content">
         <div class="notice-text">
            <h1 class="mainTitle">Teacher</h1>
            <p class="mainContent">선생님</p>
         </div>
         <div class="notice-image">
            <img src="/resources/img/teach_heart.png" alt="Duck Image">
         </div>
      </div>
   </section>

   <section class="content-section">
      <%@ include file="/WEB-INF/views/include/teach/teachSideBar.jsp"%>
      <div class="table-container">
         <div class="teach-container">
            <%@ include file="/WEB-INF/views/include/teach/teachContainer.jsp"%>
         </div>

         <div class="">
            <div class="course-page">
               <ul class="tab-menu">
                  <li onclick="fn_teachMove('teachPage')">HOME</li>
                  <li class="active" onclick="fn_teachMove('teachCourse')">강좌목록</li>
                  <li onclick="fn_teachMove('teachNotice')">공지사항</li>
                  <li onclick="fn_teachMove('teachQna')">학습Q&A</li>
                  <li onclick="fn_teachMove('teachReview')">수강후기</li>
               </ul>

               <div class="content">
                  <div class="lecture-list-container">
                     <div class="select-lecture">

                        <!-- 선생님이고, 선생님이 일치할때만 등록버튼 띄움 -->
                        <div class="left-button">
                           <c:if test="${cookieRating == 'T' && teacher.userId == cookieUserId}">
                              <button type="button" class="register-course" onclick="fn_registerCourse()">코스 등록</button>
                              
                           </c:if>
                        </div>
                        <div class="right-menu">
                           <span class="active">최신강좌</span>
                        </div>
                     </div>

                     <div class="subjectClassList">
                        <c:if test="${!empty list }">
                           <!-- -------------------------------------------------------------------------------------------------- -->
                           <c:if test="${cookieUserId == teacher.userId}">
                              <c:forEach var="courseList" items="${list}" varStatus="status">
                                 <div class="subjectClassItem">
                                    <div>
                                       <img src="/resources/img/subjectCover${classCode }.png" class="profile-photo">
                                    </div>
                                    <div>
                                       <div>
                                          <span class="teach-subject">[${className }]</span> <span class="teach-name">${teacher.userName }</span> 선생님 🏠
                                       </div>
                                       <div class="middle-container">
                                          <span class="teach-subject-title" onclick="fn_courseMove(${courseList.courseCode},1)">${courseList.courseName }</span>
                                       </div>
                                       <div class="item-bottom">
                                          <div class="classCnt">강의 수 ${courseList.lecCnt }/${courseList.lecCnt }강</div>

                                          <button type="button" id=courseDel name="courseDel" onclick="fn_courseDel(${courseList.courseCode})">코스 삭제</button>

                                       </div>
                                    </div>
                                 </div>
                              </c:forEach>
                           </c:if>
                           <!-- -------------------------------------------------------------------------------------------------- -->
                           <c:if test="${cookieUserId != teacher.userId}">
                              <c:forEach var="courseList" items="${list}" varStatus="status">
                                 <c:if test="${courseList.courseStatus == 'Y'}">
                                    <div class="subjectClassItem">
                                       <div>
                                          <img src="/resources/img/subjectCover${classCode }.png" class="profile-photo">
                                       </div>
                                       <div>
                                          <div>
                                             <span class="teach-subject">[${className }]</span> <span class="teach-name">${teacher.userName }</span> 선생님 🏠
                                          </div>
                                          <div class="middle-container">
                                             <span class="teach-subject-title" onclick="fn_courseMove(${courseList.courseCode},${courseList.myCourseChk })">${courseList.courseName }</span>
                                          </div>
                                          <div class="item-bottom">
                                             <div class="classCnt">강의 수 ${courseList.lecCnt }/${courseList.lecCnt }강</div>
                                             <c:if test="${account.rating != 'T' }">
                                                <c:if test="${courseList.myCourseChk eq 0}">
                                                   <button type="button" onclick="fn_coursePage(${courseList.courseCode})">수강신청</button>
                                                </c:if>
                                                <c:if test="${courseList.myCourseChk eq 1}">
                                                   <button type="button" onclick="fn_coursePage(${courseList.courseCode})" style="background: #cf4848; padding: 5px 35px;">수강 중</button>
                                                </c:if>
                                             </c:if>
                                          </div>
                                       </div>
                                    </div>
                                 </c:if>
                              </c:forEach>
                           </c:if>
                        </c:if>
                     </div>
                  </div>
               </div>
               <!--  페이징 버튼 -->

               
               <div class="pagination">
                  <c:if test="${!empty paging}">
      
                     <c:if test="${paging.prevBlockPage gt 0}">
                        <button class="pagination-button" href="#" onclick="fn_listView(${paging.prevBlockPage})">&laquo;</button>
                     </c:if>
      
      
                     <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                        <c:choose>
                           <c:when test="${i eq curPage}">
                              <span class="pagination-number active">${i}</span>
                           </c:when>
                           <c:otherwise>
                              <span class="pagination-number"><a class="page-link" href="#" onclick="fn_listView(${i})">${i}</a></span>
                           </c:otherwise>
                        </c:choose>
                        <c:if test="${i lt paging.endPage}">
                           <span class="pagination-separator">|</span>
                        </c:if>
                     </c:forEach>
      
      
                     <c:if test="${paging.nextBlockPage gt 0}">
                        <button class="pagination-button" href="#" onclick="fn_listView(${paging.nextBlockPage})">&raquo;</button>
                     </c:if>
      
                  </c:if>
               </div>
               
               
               
            </div>
         </div>

         <!-- 모달창 -->
         <form name="courseForm" id="courseForm" method="post" enctype="multipart/form-data">
            <div id="courseModal" class="modal-course">
               <div class="modal-content-course">
                  <span class="close" onclick="closeModal()">&times;</span>
                  <h2 class="modal-title">코스등록</h2>
                  <div class="modal-section">
                     <label class="modal-label">코스명</label>
                     <input type="text" id="courseName" name="courseName" class="modal-input" placeholder="코스명을 입력하세요" />
                  </div>
                  <div class="modal-section">
                     <label class="modal-label">코스 정보</label>
                     <div class="input-with-search">
                        <input type="text" id="bookDetail" class="modal-input" name="bookDetail" placeholder="교재를 검색해주세요" value="" />
                        <input type="hidden" id="bookSeq" name="bookSeq" value="">
                        <button class="search-btn" id="bookBtn" name="bookBtn" onclick="openSearchWindow(event)">🔍</button>
                     </div>
                  </div>
                  <div class="modal-section">
                     <label class="modal-label">코스 설명</label>
                     <textarea class="modal-textarea" id="courseDetail" name="courseDetail" placeholder="상세 내용을 입력하세요"></textarea>
                  </div>
                  <div class="modal-buttons">
                     <button class="modal-btn add-btn" id="writeBtn" onclick="submitCourse()">등록</button>
                     <button class="modal-btn cancel-btn" id="cancelBtn" onclick="closeModal()">취소</button>
                  </div>
               </div>

               <input type="hidden" name="classCode" value="${classCode}">
               <input type="hidden" name="courseCode" value="">
               <input type="hidden" name="teacherId" value="${teacher.userId}">
               <input type="hidden" name="curPage" value="">
            </div>
         </form>



      </div>
   </section>
   
   <%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

   <form id="teacherTypeForm" name="teacherTypeForm" method="post">
      <input type="hidden" name="classCode" value="${classCode}">
      <input type="hidden" name="courseCode" value="">
      <input type="hidden" name="teacherId" value="${teacher.userId}">
      <input type="hidden" name="curPage" value="${curPage }">
   </form>

   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="brdSeq" value="">
      <input type="hidden" name="searchType" id="searchType" value="">
      <input type="hidden" name="searchValue" id="searchValue" value="">
      <input type="hidden" name="curPage" id="curPage" value="">
      <input type="hidden" name="classCode" value="">
      <input type="hidden" name="courseCode" value="">
      <input type="hidden" name="teacherId" value="">
   </form>
</body>
</html>
