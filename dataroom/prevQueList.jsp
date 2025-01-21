<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/dataroom/prevQueList.css" rel="stylesheet">
<style>
.header {
   background-color: #9ABF80;
}

.freeWrite-container {
  display: flex;
  align-items: center;
}

.free-write-button {
  background: #7ab961;
  border: 1px solid #ddd;
  border-radius: 4px;
  color: white;
  padding: 5px 10px;
  cursor: pointer;
  margin-left: auto;
}

.middle-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px;
}

.upd-del-btn {
    position: relative;
}

.hamburger-btn {
    cursor: pointer;
    font-size: 24px;
    border: none;
    background: none;
    padding: 5px;
}

.dropdown-menu {
    display: none;
    position: absolute;
    right: 0;
    top: 100%;
    background: white;
    border: 1px solid #ddd;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    overflow: hidden;
    z-index: 1000;
    animation: fadeIn 0.3s ease-in-out;
}

.dropdown-menu button {
    display: flex;
    align-items: center;
    width: 100%;
    padding: 10px 15px; /* 최소 여백 */
    margin: 0; /* 불필요한 간격 제거 */
    text-align: left;
    background: white;
    border: none;
    cursor: pointer;
    font-size: 14px;
    color: #333;
    gap: 10px;
    white-space: nowrap; /* 텍스트 줄바꿈 방지 */
    transition: background-color 0.2s;
}

.dropdown-menu button:hover {
    background: #f1f1f1;
}

.dropdown-menu button i {
    font-size: 18px;
    color: #555;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(-10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}


</style>
<script>
$(function() {
    $("#navmenu>ul>li:nth-child(4)>a").addClass("active");
    
    // 햄버거 버튼 클릭 시 드롭다운 메뉴 토글
    $('.hamburger-btn').on('click', function() {
        $(this).siblings('.dropdown-menu').toggle();
    });

    // 문서 클릭 시 드롭다운 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.upd-del-btn').length) {
            $('.dropdown-menu').hide();
        }
    });
    
});

(function( $ ) {
    "use strict";
    $(function() {
        function animated_contents() {
            $(".easy-bar > div, .hard-bar > div").each(function (i) {
                var $this  = $(this),
                    skills = $this.data('width');
 
                $this.css({'width' : skills + '%'});
            });
        }
        
        // if appear.js is available
        if(jQuery().appear) {
            // Applying appear event to both .easy-bar and .hard-bar
            $('.easy-bar, .hard-bar').appear().on('appear', function() {
                animated_contents();
            });
        } else {
            // Fallback for non-appear.js environments
            animated_contents();
        }

        // Optional: Use scroll event directly if you want to handle scroll manually
        $(window).on('scroll', function() {
            $('.hard-bar, .easy-bar').each(function() {
                var $this = $(this);
                if ($this.is(":in-viewport")) {
                    animated_contents();
                }
            });
        });
    });
}(jQuery));



// 글쓰기
function fn_write() {
   document.bbsForm.action = "/dataroom/prevQueWriteForm";
   document.bbsForm.submit();
}

// 기출문제 삭제
function fn_delete(examSeq) {
   
   Swal.fire({
       title: "해당 게시물을 삭제 하시겠습니까?",
       icon: "warning",
       showCancelButton: true,
       confirmButtonColor: "#3085d6",
       cancelButtonColor: "#d33",
       confirmButtonText: "삭제",
       cancelButtonText: "취소"
   }).then((result) => {
       if (result.isConfirmed) {
           $.ajax({
               type: "POST",
               url: "/dataroom/prevQueDelete",
               data: {
                   examSeq : examSeq
               },
               datatype: "JSON",
               beforeSend: function(xhr) {
                   xhr.setRequestHeader("AJAX", "true");
               },
               success: function(response) {
                   if (response.code == 0) {
                       Swal.fire({
                           position: "center",
                           icon: "success",
                           title: '게시물이 삭제 되었습니다.',
                           showConfirmButton: false,
                           timer: 1500
                       }).then(function() {
                          document.bbsForm.action = "/dataroom/prevQueList";
                          document.bbsForm.submit();
                       });
                   } else if (response.code == 400) {
                       Swal.fire({
                           position: "center",
                           icon: "warning",
                           title: '파라미터 값이 올바르지 않습니다.',
                           showConfirmButton: false,
                           timer: 1500
                       });
                   } else if (response.code == 999) {
                       Swal.fire({
                           position: "center",
                           icon: "warning",
                           title: '로그인 후 이용 가능합니다',
                           showConfirmButton: false,
                           timer: 1500
                       });
                   } else if (response.code == 403) {
                       Swal.fire({
                           position: "center",
                           icon: "warning",
                           title: '본인글만 수정 가능합니다.',
                           showConfirmButton: false,
                           timer: 1500
                       });
                   } else if (response.code == 404) {
                       Swal.fire({
                           position: "center",
                           icon: "warning",
                           title: '해당 게시물을 찾을수 없습니다.',
                           showConfirmButton: false,
                           timer: 1500
                       }).then(function() {
                          document.bbsForm.action = "/dataroom/prevQueList";
                          document.bbsForm.submit();
                       });
                   } else {
                       Swal.fire({
                           position: "center",
                           icon: "warning",
                           title: '게시물 삭제시 오류가 발생하였습니다.',
                           showConfirmButton: false,
                           timer: 1500
                       });
                   }
               },
               error: function(xhr, status, error) {
                   icia.common.error(error);
               }
           });
       }
   });

   
   
}


function fn_listview(curPage) {
    document.bbsForm.curPage.value = curPage; // curPage 값 설정
    document.bbsForm.action = "/dataroom/prevQueList";
    document.bbsForm.submit(); // 폼 제출
}

/*옵션 버튼*/
function setOptions(value) {
    document.bbsForm.examSeq.value = "";
    document.bbsForm.searchType.value = $("#_searchType").val();
    document.bbsForm.searchValue.value = $("#_searchValue").val();
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
    
    document.bbsForm.action = "/dataroom/prevQueList";
    document.bbsForm.submit();
}

function getOptionsName(value) {
    switch(value) {
        case '1': return '최신순';
        case '2': return '오래된순';
        default: return '';
    }
}

function fn_list(classCode) {
    document.bbsForm.curPage.value = "1";
    document.bbsForm.searchType.value = $("#sort").val();
    document.bbsForm.searchValue.value = "";
    document.bbsForm.classCode.value = classCode;
    document.bbsForm.action = "/dataroom/prevQueList";
    document.bbsForm.submit();
}

/* 알파개씩 보기*/
function listCount(value) {
    document.bbsForm.examSeq.value = "";
    document.bbsForm.searchType.value = $("#_searchType").val();
    document.bbsForm.searchValue.value = $("#_searchValue").val();
    document.bbsForm.curPage.value = "1";
    document.bbsForm.listCount.value = value;
    document.bbsForm.action = "/dataroom/prevQueList";
    document.bbsForm.submit();
}

function animated_contents() {
    $(".easy-bar > div, .hard-bar > div").each(function (i) {
        var $this  = $(this),
            skills = $this.data('width');
        $this.css({'width' : skills + '%'});
    });
}

function fn_easyCheck(examSeq, userId, status) {
    console.log("examSeq: ", examSeq);
    console.log("userId: ", userId);
    console.log("status: ", status);

    $.ajax({
        type: "POST",
        url: "/dataroom/easyHardInsert",
        data: {
            examSeq: examSeq,
            userId: userId,
            status: status
        },
        datatype: "JSON",
        beforeSend: function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
        },
        success: function(response) {
            console.log(response);
            if (response.code == 0) {
               Swal.fire({
                     position: "center",
                   icon: "success",
                     title: "쉬워요 등록 완료!",
                     showConfirmButton: false,
                     timer: 1500
                });
                var newCommentsHTML = '';
                newCommentsHTML += '<div class="easyCnt" data-width="' + (20 + (response.data / 10))  + '" style="">' +
                                 '<img style="width:auto; height: 24px;" src="/resources/img/ico_face_good.png" class="grap-photo">' +
                                 '<span>';
            if(response.data == 0){
               newCommentsHTML += '0';}
            if(response.data != 0){   
               newCommentsHTML += Math.ceil(response.data / 10);}
               
            newCommentsHTML += '%</span>' +
                             '</div>' +
                             '<p style="transform: translate(37px, -26px); color: black; font-weight: 700;">쉬워요!</p>';
                document.getElementById("easyCount" + examSeq).innerHTML = newCommentsHTML;
                animated_contents();
    
            } else if (response.code == -1) {
               Swal.fire({
                     position: "center",
                   icon: "success",
                     title: "쉬워요 취소 완료!",
                     showConfirmButton: false,
                     timer: 1500
                });
                var newCommentsHTML = '';
                newCommentsHTML += '<div class="easyCnt" data-width="' + (20 + (response.data / 10))  + '" style="">' +
                                 '<img style="width:auto; height: 24px;" src="/resources/img/ico_face_good.png" class="grap-photo">' +
                                 '<span>';
            if(response.data == 0){
               newCommentsHTML += '0';}
            if(response.data != 0){   
               newCommentsHTML += Math.ceil(response.data / 10);}
               
            newCommentsHTML += '%</span>' +
                             '</div>' +
                             '<p style="transform: translate(37px, -26px); color: black; font-weight: 700;">쉬워요!</p>';
                document.getElementById("easyCount" + examSeq).innerHTML = newCommentsHTML;
                animated_contents();
            } else if (response.code == -3) {
              Swal.fire({
                 icon: "error",
                 title: "쉬워요와 어려워요를 동시에 선택할 수 없습니다."
              });
            } else if (response.code == 400) {
                Swal.fire({
                   icon: "warning",
                   title: "로그인 후 이용이 가능합니다."
                });
            } else {
               Swal.fire({
                 icon: "question",
                 title: "처리 중 오류가 발생했습니다."
               });
            }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
        }
    });
}

function fn_hardCheck(examSeq, userId, status) {
    console.log("examSeq: ", examSeq);
    console.log("userId: ", userId);
    console.log("status: ", status);

    $.ajax({
        type: "POST",
        url: "/dataroom/easyHardInsert",
        data: {
            examSeq: examSeq,
            userId: userId,
            status: status
        },
        datatype: "JSON",
        beforeSend: function(xhr) {
            xhr.setRequestHeader("AJAX", "true");
        },
        success: function(response) {
            console.log(response);
            if (response.code == 0) {
               Swal.fire({
                     position: "center",
                   icon: "success",
                     title: "어려워요 등록 완료!",
                     showConfirmButton: false,
                     timer: 1500
                });
                
                var newCommentsHTML = '';
                newCommentsHTML += '<div class="hardCnt" data-width="' + (20 + (response.data / 10))  + '" style="">' +
                                 '<img style="width:auto; height: 24px;" src="/resources/img/ico_face_bad.png" class="grap-photo">' +
                                 '<span>';
            if(response.data == 0){
               newCommentsHTML += '0';}
            if(response.data != 0){   
               newCommentsHTML += Math.ceil(response.data / 10);}
               
            newCommentsHTML += '%</span>' +
                             '</div>' +
                             '<p style="transform: translate(37px, -26px); color: black; font-weight: 700;">어려워요!</p>';
                document.getElementById("hardCount" + examSeq).innerHTML = newCommentsHTML;
                animated_contents();
                
            } else if (response.code == -1) {
               Swal.fire({
                     position: "center",
                   icon: "success",
                     title: "어려워요 취소 완료!",
                     showConfirmButton: false,
                     timer: 1500
                });
                
                var newCommentsHTML = '';
                newCommentsHTML += '<div class="hardCnt" data-width="' + (20 + (response.data / 10))  + '" style="">' +
                                 '<img style="width:auto; height: 24px;" src="/resources/img/ico_face_bad.png" class="grap-photo">' +
                                 '<span>';
            if(response.data == 0){
               newCommentsHTML += '0';}
            if(response.data != 0){   
               newCommentsHTML +=  Math.ceil(response.data / 10);}
               
            newCommentsHTML += '%</span>' +
                             '</div>' +
                             '<p style="transform: translate(37px, -26px); color: black; font-weight: 700;">어려워요!</p>';
                document.getElementById("hardCount" + examSeq).innerHTML = newCommentsHTML;
                animated_contents();
            } else if (response.code == -3) {
                Swal.fire({
                   icon: "error",
                   title: "쉬워요와 어려워요를 동시에 선택할 수 없습니다."
                });
              } else if (response.code == 400) {
                  Swal.fire({
                     icon: "warning",
                     title: "로그인 후 이용이 가능합니다."
                  });
              } else {
                 Swal.fire({
                   icon: "question",
                   title: "처리 중 오류가 발생했습니다."
                 });
              }
        },
        error: function(xhr, status, error) {
            console.error("AJAX Error:", error);
        }
    });
}

function fn_dawnload(userId, url){
    if(!userId){
       Swal.fire({
          position: "center", 
          icon: "warning",
          title: "로그인 후 이용이 가능합니다.", 
          showConfirmButton: false, 
          timer: 1500 
          });

        return;
    }
    // 로그인된 경우에만 다운로드 링크로 이동
    window.location.href = url;
}


$(document).ready(function() {
    $("#btnSearch").click(function() {
        console.log("Search button clicked");  // 클릭 확인용 로그
        var searchType = $("#_searchType").val();
        var searchValue = $("#_searchValue").val();
        
        // 검색어가 비어있는지 확인
        if (!searchValue.trim()) {
           Swal.fire({
              position: "center", 
              icon: "warning",
              title: "검색어를 입력해주세요.", 
              showConfirmButton: false, 
              timer: 1500 
              });

            return;
        }

        console.log("Search Type:", searchType);  // 검색 타입 출력
        console.log("Search Value:", searchValue);  // 검색 값 출력

        // 검색 처리
        document.bbsForm.examSeq.value = "";
        document.bbsForm.searchType.value = searchType;
        document.bbsForm.searchValue.value = searchValue;
        document.bbsForm.curPage.value = "1"; // 처음 페이지로 설정
        document.bbsForm.classCode.value = ${classCode};
        document.bbsForm.action = "/dataroom/prevQueList";
        document.bbsForm.submit(); // 폼 제출
    });
});






</script>

</head>
<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>

   <section class="notice-section">
      <div class="notice-content">
         <div class="notice-text">
            <h1 class="mainTitle">A Previous Question</h1>
            <p class="mainContent">기출문제</p>
         </div>
         <div class="notice-image">
            <img src="/resources/img/Clover.png" alt="Clover Image">
         </div>
      </div>
   </section>

   <section class="content-section">

      <div class="sidebar">
      <div class="exam-date" id="d-day-display">
         2026 수능 <span class="days"></span>
      </div>
         <ul class="menu">
            <li><a href=# class="${classCode == 1 ? 'highlight' : ''}" onclick="fn_list(1)">국어</a></li>
            <li><a href=# class="${classCode == 2 ? 'highlight' : ''}" onclick="fn_list(2)">영어</a></li>
            <li><a href=# class="${classCode == 3 ? 'highlight' : ''}" onclick="fn_list(3)">수학</a></li>
            <li><a href=# class="${classCode == 4 ? 'highlight' : ''}" onclick="fn_list(4)">사회</a></li>
            <li><a href=# class="${classCode == 5 ? 'highlight' : ''}" onclick="fn_list(5)">과학</a></li>
         </ul>
      </div>
      <div class="table-container">
         <h2 class="subTitle">기출문제</h2>
         

         
         <div class="stats">
            <span style="font-size: 12px;">검색결과 <strong style="color: #e98e95;">${totalCount}</strong>개</span>
            <div class="sorting-options">
               <button id="sort-button" class="sort-button <c:if test="${options eq 1}">active</c:if>" onclick="setOptions('1')">최신순</button>
               <button id="sort-button" class="sort-button <c:if test="${options eq 2}">active</c:if>" onclick="setOptions('2')">오래된순</button>

                   <select class="view-options" id="listCount" onchange="listCount(this.value)">
                       <option value="10" <c:if test="${listCount == 10}">selected</c:if>>10개씩 보기</option>
                       <option value="15" <c:if test="${listCount == 15}">selected</c:if>>15개씩 보기</option>
                       <option value="20" <c:if test="${listCount == 20}">selected</c:if>>20개씩 보기</option>
                   </select>
            </div>
         </div>
            
            <c:if test="${!empty list}">
             <div class="subjectClassList">
                 <c:forEach var="exam" items="${list}" varStatus="status">
                     <div class="subjectClassItem">
                     
                         <div>
                            <c:if test="${exam.classCode == 1}">
                                <img src="/resources/img/thumb_book_korean.png" class="profile-photo">
                            </c:if>
                            <c:if test="${exam.classCode == 2}">
                                <img src="/resources/img/thumb_book_english.png" class="profile-photo">
                            </c:if>
                            <c:if test="${exam.classCode == 3}">
                                <img src="/resources/img/thumb_book_math.png" class="profile-photo">
                            </c:if>
                            <c:if test="${exam.classCode == 4}">
                                <img src="/resources/img/thumb_book_social.png" class="profile-photo">
                            </c:if>
                            <c:if test="${exam.classCode == 5}">
                                <img src="/resources/img/thumb_book_science.png" class="profile-photo">
                            </c:if>
                         </div>
                         
                         
                         <div>
                         <c:if test="${rating ne 'A'}">
                             <div class="middle-container" style="margin-bottom: 0px;">
                                <div>
                                   <span class="teach-subject-title">${exam.examTitle}</span>
                                </div>
                                
                         <c:if test="${rating eq  'A'}">                                    
                                   <div class="upd-del-btn">
                                 <button class="hamburger-btn">☰</button>
                                 <div class="dropdown-menu">
                                     <button id="delete-btn" onclick="fn_delete(${exam.examSeq})">
                                         <i>🗑️</i> 삭제
                                     </button>
                                 </div>
                             </div>
                        </c:if>                       
                             </div>
                          </c:if>
                         <c:if test="${rating eq 'A'}">
                             <div class="middle-container" style="margin-bottom: 0px; padding: 0px 10px;">
                                <div>
                                   <span class="teach-subject-title">${exam.examTitle}</span>
                                </div>
                                
                         <c:if test="${rating eq  'A'}">                                    
                                   <div class="upd-del-btn">
                                 <button class="hamburger-btn">☰</button>
                                 <div class="dropdown-menu">
                                     <button id="delete-btn" onclick="fn_delete(${exam.examSeq})">
                                         <i>🗑️</i> 삭제
                                     </button>
                                 </div>
                             </div>
                        </c:if>                       
                             </div>
                          </c:if>
                          
                             <c:if test="${rating ne 'A'}">
                             <div class="middle-container" style="padding: 0px 10px;">
                                 <span class="teach-subject-content">${exam.examQcnt}문항</span>
                             </div>
                             </c:if>
                             <c:if test="${rating eq 'A'}">
                             <div class="middle-container" style="padding: 0px 10px;">
                                 <span class="teach-subject-content">${exam.examQcnt}문항</span>
                             </div>
                             </c:if>
                             
                             <div class="item-bottom">

                            <div class="leftwrap">
                                <div id="easyCount${exam.examSeq}" class="easy-bar" onclick="fn_easyCheck('${exam.examSeq}', '${userId}', 'E', this)">
                                    <div class="easyCnt" data-width="${20 + (exam.easyCnt / 10)}" style="">
                                        <img style="width:auto; height: 24px;" src="/resources/img/ico_face_good.png" class="grap-photo">
<%--                                         <span>${exam.easyCnt != null ? exam.easyCnt : 0}%</span> --%>
                                    <span>
                                        <c:choose>
                                            <c:when test="${exam.easyCnt != null}">
                                                <fmt:formatNumber value="${(exam.easyCnt / 10) + (exam.easyCnt % 10 > 0 ? 1 : 0)}" maxFractionDigits="0" />%
                                            </c:when>
                                            <c:otherwise>
                                                0%
                                            </c:otherwise>
                                        </c:choose>
                                    </span>

                                    </div>
                                    <p style="transform: translate(37px, -26px); color: black; font-weight: 700;">쉬워요!</p>
                                </div>
                                <div id="hardCount${exam.examSeq}" class="hard-bar" onclick="fn_hardCheck('${exam.examSeq}', '${userId}', 'H', this)">
                                    <div class="hardCnt" data-width="${20 + (exam.hardCnt / 10)}" style="">
                                        <img style="width:auto; height: 24px;" src="/resources/img/ico_face_bad.png" class="grap-photo">
                                    <span>
                                        <c:choose>
                                            <c:when test="${exam.hardCnt != null}">
                                                <fmt:formatNumber value="${(exam.hardCnt / 10) + (exam.hardCnt % 10 > 0 ? 1 : 0)}" maxFractionDigits="0" />%
                                            </c:when>
                                            <c:otherwise>
                                                0%
                                            </c:otherwise>
                                        </c:choose>
                                    </span>
                                    </div>
                                    <p style="transform: translate(37px, -26px); color: black; font-weight: 700;">어려워요!</p>
                                </div>
                            </div>



                           <div class="rightwrap">
                               <button type="button" onclick="fn_dawnload('${userId}', '/dataroom/examdownload?examSeq=${exam.examSeq}&fileType=pdf')">
                                   문제<img style="width:auto; height: 14px; margin-left: 5px;" src="/resources/img/ico_download4.png" class="profile-photo">
                               </button>
                           
                               <button type="button" onclick="fn_dawnload('${userId}', '/dataroom/ansdownload?examSeq=${exam.examSeq}&fileType=png')">
                                   답안<img style="width:auto; height: 14px; margin-left: 5px;" src="/resources/img/ico_download4.png" class="profile-photo">
                               </button>
                           </div>
                             </div>
                         </div>
                     </div>
                 </c:forEach>
             </div>
         </c:if>
         <c:if test="${empty list}">
             <div class="subjectClassList">
                 <div class="subjectClassItem">
                     <div>
                         <span style="text-align: center;">작성된 문제가 없습니다.</span>
                     </div>
                 </div>
             </div>
         </c:if>
         
<c:if test="${rating eq  'A'}">         
          <div class="freeWrite-container">
            <button class="free-write-button" onclick="fn_write()">글쓰기</button>
         </div>
 </c:if>          
         
         


         <div class="pagination">
            <c:if test="${!empty paging}">

               <c:if test="${paging.prevBlockPage gt 0}">
                  <button class="pagination-button" href="#" onclick="fn_listview(${paging.prevBlockPage})">&laquo;</button>
               </c:if>


               <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
                  <c:choose>
                     <c:when test="${i eq curPage}">
                        <span class="pagination-number active">${i}</span>
                     </c:when>
                     <c:otherwise>
                        <span class="pagination-number"><a class="page-link" href="#" onclick="fn_listview(${i})">${i}</a></span>
                     </c:otherwise>
                  </c:choose>
                  <c:if test="${i lt paging.endPage}">
                     <span class="pagination-separator">|</span>
                  </c:if>
               </c:forEach>


               <c:if test="${paging.nextBlockPage gt 0}">
                  <button class="pagination-button" href="#" onclick="fn_listview(${paging.nextBlockPage})">&raquo;</button>
               </c:if>

            </c:if>
         </div>





         <div class="search-container">
            <select class="form-select" id="_searchType">
               <option value="1" <c:if test='${searchType eq "1"}'>selected</c:if>>제목</option>
            </select>
            <div class="input-select">
               <input type="text" class="form-control" id="_searchValue" placeholder="검색할 단어를 입력하세요." value="${searchValue}" aria-label="Recipient's username" aria-describedby="button-addon2">
               <button type="button" id="btnSearch" style="cursor: pointer">
                  <img alt="검색 버튼" src="/resources/img/search.png" style="height: 22px;">
               </button>
            </div>
         </div>
      </div>
      

   </section>
   
   <form id="bbsForm" name="bbsForm" method="post">
      <input type="hidden" name="examSeq" value="">
      <input type="hidden" name="classCode" value="${classCode}">
      <input type="hidden" name="searchType" value="${searchType}">
      <input type="hidden" name="searchValue" value="${searchValue}">
      <input type="hidden" name="curPage" value="${curPage}">
      <input type="hidden" name="options" value="${options}">
      <input type="hidden" name="listCount" value="${listCount}"/>
       <input type="hidden" id="userId" value="${userId}">
       <input type="hidden" id="status" value="${status}">
   </form>

</body>
</html>
