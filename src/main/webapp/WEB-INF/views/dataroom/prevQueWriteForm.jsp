<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/dataroom/prevQueList.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.4.10/dist/sweetalert2.min.js"></script>
<title>자유게시판 글쓰기</title>
<style>
.header {
   background-color: #9ABF80;
}

/* 게시판 컨테이너 */
.board-container {
    width: 100%;
    background-color: #f0f0f0;
    border: 1px solid #ddd;
    border-radius: 8px;
    padding: 30px 100px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    margin: 20px auto; /* 추가된 부분 */
}

/* 제목 영역 */
.board-header {
    margin-bottom: 10px;
    display: flex; /* 플렉스 박스 활성화 */
    align-items: center; /* 요소를 수직 중앙 정렬 */
    gap: 10px; /* 글자와 이미지 사이 간격 */
}

.board-header h1 {
    font-size: 30px;
    color: #4b2d68;
    font-weight: bold;
    margin: 0;
    text-align: left;
}

.table-container img {
    width: 50px;
    height: 40px;
    margin-top: 0px;
    margin-right: 100px;
}

.header-line {
    width: 100%;
    height: 2px;
    background-color: #4b2d68;
    margin-top: -3px;
}

/* 폼 영역 */
.board-form {
    margin-top: 10px;
}

.form-group {
	margin-top: 10px;
    margin-bottom: 20px;
}

label {
    display: block;
    font-size: 18px;
    font-weight: bold;
    margin-bottom: 8px;
    color: #333;
}

input[type="text"],
textarea,
select {
    width: 100%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 14px;
    color: #333;
    box-sizing: border-box;
}

textarea {
    resize: none;
    height: 300px;
}

/* 버튼 스타일 */
.form-buttons {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}

button {
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    font-size: 14px;
    cursor: pointer;
}

button.cancel {
    background-color: #ddd;
    color: #333;
}

button.submit {
    background-color: #F96366;
    color: #fff;
}

/* 공지 사항 */
.notice {
    font-size: 12px;
    color: #666;
    margin-top: 20px;
    line-height: 1.6;
}


/***********************************/
/* Content Section */
.content-section {
    display: flex;
    padding: 30px 300px;
    background: #fff;
}

.sidebar {
    width: 20%;
    padding: 0px 20px 30px 0px;
    background: #ffffff;

}

.sidebar .exam-date {
    font-size: 18px;
    font-weight: 700;
    margin-bottom: 18px;
    text-align: center;
    border-bottom: 2px solid #000;
    border-top: 2px solid #000;
    padding: 18px 0 18px 0;
    color: #000;
}

 .sidebar .exam-date .days {
     color: red;
     font-weight: bold;
 }

 .sidebar .menu {
     list-style-type: none;
     padding-left: 0; 
 }

 .sidebar .menu li {
   margin-bottom: 18px;
   border-bottom: 1px solid #000;
   padding-bottom: 18px;
   text-align: center;
 }


 .sidebar .menu a:first-child {
     text-decoration: none;
     font-size: 18px;
     font-weight: 900;
     margin: 0;
 }

 .sidebar .menu a {
     text-decoration: none;
     color: black;
     font-size: 15px;
 }
 .sidebar .menu a:nth-child(3) {
   margin-top: 6px;
   display: inline-block;
 }

 .sidebar .menu .highlight {
     color: #10c062;
     font-weight: bold;
 }

 .table-container {
     width: 80%;
     padding: 10px;
     color: #000;
 }

 .table-container .subTitle {
     margin-top: 12px;
     margin-bottom: 18px;
     font-size: 25px;
     margin-left: 10px;
     color: #000;
     font-weight: bolder;
 }
 
  .filebox .exam-upload-name, .filebox .ans-upload-name {
	width: 84.3%;
    padding: 10px;
    border: 1px solid #ccc;
    border-radius: 4px;
    font-size: 14px;
    color: #333;
    box-sizing: border-box;
    outline:none;
}



.filebox label {
    display: inline-block;
    padding: 8px 20px;
    color: #fff;
    vertical-align: middle;
    background-color: #999999;
    cursor: pointer;
    height: 44px;
    margin-left: 10px;
    border-radius: 4px;
    margin-bottom: 4px;
}

.filebox input[type="file"] {
    position: absolute;
    width: 0;
    height: 0;
    padding: 0;
    overflow: hidden;
    border: 0;
}

</style>
<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(3)>a").addClass("active");
      
      //취소 버튼 클릭 시
      $("#cancelBtn").on("click", function() {
         document.bbsForm.action = "/dataroom/prevQueList";
         document.bbsForm.submit();
      });
      
      //글쓰기 버튼 클릭 시
      $("#writeBtn").on("click", function() {
       fn_write();
      });
      
      // 첨부파일 첨부 시
      $('#examFile').on('change', function() {
          var fileName = $(this).prop('files')[0].name;
          $('.exam-upload-name').val(fileName);
      });
      
      $('#ansFile').on('change', function() {
          var fileName = $(this).prop('files')[0].name;
          $('.ans-upload-name').val(fileName);
      });
   });
   
      //글쓰기
      function fn_write()
      {
    	
    	  
        if($("#category").val() == "")
        {
        	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: '분류를 선택하세요.', 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

                  $("#category").val("");
                  $("#category").focus();
                  
           return;
        }
         
         if($.trim($("#title").val()).length <= 0)
        {
        	 Swal.fire({
         		position: "center", 
         		icon: "warning",
         		title: '제목을 입력하세요.', 
         		showConfirmButton: false, 
         		timer: 1500 
         		});

            $("#title").val("");
            $("#title").focus();
            
            return;
        }
         
         if (($("#qcnt").val()).length <= 0) {
        	 Swal.fire({
          		position: "center", 
          		icon: "warning",
          		title: '문항수를 입력해주세요.', 
          		showConfirmButton: false, 
          		timer: 1500 
          		});

             $("#qcnt").val("");
             $("#qcnt").focus();
             
             return;
         }
         
         
         // 1 이상의 숫자인지 체크
         if (!/^[1-9]\d*$/.test($("#qcnt").val())) {
        	 Swal.fire({
          		position: "center", 
          		icon: "warning",
          		title: '1 이상의 [숫자]만 입력 가능합니다.', 
          		showConfirmButton: false, 
          		timer: 1500 
          		});

             $("#qcnt").val("");
             $("#qcnt").focus();
             
             return;
         }
         
         
         if ($("#examFile")[0].files.length === 0) {
        	    Swal.fire({
        	        position: "center", 
        	        icon: "warning",
        	        title: '시험 문제를 업로드 해주세요.', 
        	        showConfirmButton: false, 
        	        timer: 1500 
        	    });
        	    
        	    return;
        }
         
         
         if($("#ansFile")[0].files.length === 0)
         {
        	 Swal.fire({
         		position: "center", 
         		icon: "warning",
         		title: '문제 답안을 업로드 해주세요.', 
         		showConfirmButton: false, 
         		timer: 1500 
         	});
            
            return;
         }
         
         var form = $("#board-form")[0];
         var formData = new FormData(form);
            
         $.ajax({
	         type:"POST",
	         enctype:"multipart/form-data",
	         url:"/dataroom/prevQueWriteProc",
	         data:formData,
	         processData:false,               
	         contentType:false,               
	         cache:false,
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
	            		title: '게시물이 등록되었습니다.',
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		}).then(function() {
	            			document.bbsForm.action = "/dataroom/prevQueList";
	                        document.bbsForm.submit();
	            		});
	
	            }   
	            else if(response.code == 400)
	            {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: '파라미터 값이 올바르지 않습니다.', 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});
	
	               $("#title").focus();
	            }
	            else if(response.code == 999)
	            {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: '로그인 후 이용 가능합니다', 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});
	
	               $("#title").focus();
	            }
	            else
	            {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: '게시물 등록 중 오류가 발생했습니다.2', 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});
	
	               $("#title").focus();
	            }
	         },
	         error:function(error)
	         {
	            icia.common.error(error);
	            Swal.fire({
	        		position: "center", 
	        		icon: "warning",
	        		title: '게시물 등록 중 오류가 발생하였습니다.', 
	        		showConfirmButton: false, 
	        		timer: 1500 
	        		});
	
	         }
	     }); 
   }
      
    function fn_list(classCode) {
   	    document.bbsForm.curPage.value = "1";
   	    document.bbsForm.searchType.value = $("#sort").val();
   	    document.bbsForm.searchValue.value = "";
   	    document.bbsForm.classCode.value = classCode;
   	    document.bbsForm.action = "/dataroom/prevQueList";
   	    document.bbsForm.submit();
   	}
    
</script>
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
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
         <h2 class="subTitle">기출문제 > 게시글 쓰기</h2>
         <div class="header-line"></div>
         <section class="board-container">
            <form class="board-form" id="board-form" name="board-form" method="post" enctype="multipart/form-data">
               <div class="form-group">
                  <label for="category">과목</label> <select id="category" name="category">
                     <option value="">분류 선택</option>
                     <option value="1" <c:if test="${classCode == 1}">selected</c:if>>국어</option>
                     <option value="2" <c:if test="${classCode == 2}">selected</c:if>>영어</option>
                     <option value="3" <c:if test="${classCode == 3}">selected</c:if>>수학</option>
                     <option value="4" <c:if test="${classCode == 4}">selected</c:if>>사회</option>
                     <option value="5" <c:if test="${classCode == 5}">selected</c:if>>과학</option>
                  </select>
               </div>
               
               <div class="form-group">
                  <label for="title">제목</label>
                  <input type="text" id="title" name="title" placeholder="제목을 입력해주세요.">
               </div>
               
               <div class="form-group">
              		 <label for="qcnt">문항수</label>
		             <input type="text" id="qcnt" name="qcnt" placeholder="문항수를 입력해주세요.">
		        </div>
		         
		       <label for="exam">문제</label>
               <div class="filebox">
                      <input class="exam-upload-name" value="첨부파일" placeholder="첨부파일" readonly>
                            <label for="examFile">파일찾기</label> 
                      <input type="file" id="examFile" name="examFile">
                </div>
                <br>
                
               <label for="ans">답안</label>
               <div class="filebox">
                      <input class="ans-upload-name" value="첨부파일" placeholder="첨부파일" readonly>
                            <label for="ansFile">파일찾기</label> 
                      <input type="file" id="ansFile" name="ansFile">
                </div>
				<br>
				
               
               <div class="form-buttons">
                  <button type="button" id="cancelBtn" class="cancel">취소</button>
                  <button type="button" id="writeBtn" class="submit">등록</button>
               </div>
               
            </form>
         </section>
      </div>
   </section>

   <form id="bbsForm" name="bbsForm" method="post">
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