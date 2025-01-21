<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>

<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
<link href="/resources/css/board/freeView.css" rel="stylesheet">
<title>자유게시판 게시글 보기</title>
<style>
.header {
   background-color: #DDC5E1;
}
</style>
<script>
   $(function() {
      $("#navmenu>ul>li:nth-child(3)>a").addClass("active");
      
      //목록 버튼 클릭 시
      $("#listBtn").on("click", function() {
       document.bbsForm.action = "/board/freeList";
       document.bbsForm.submit();
      });
      
      //좋아요 버튼 클릭 시
         $("#likeBtn").on("click", function() {
            
             $.ajax({
                 url: "/board/freeLike",
                 type: "POST",
                 data: {
                     brdSeq: ${brdSeq}
                 },
                 datatype:"JSON",
                 success: function(response) 
                 {
                      if(response.code === 201)
                      {
                    	  Swal.fire({
                      		position: "center", 
                      		icon: "success",
                      		title: '좋아요가 감소했습니다.', 
                      		showConfirmButton: false, 
                      		timer: 1500 
                      		});

                          var newCommentsHTML = '';
                          newCommentsHTML += '<img src="/resources/img/likey.jpg" alt="like Image">';
                          document.getElementById("likeBtn").innerHTML = newCommentsHTML;
                         document.getElementById("recom").innerHTML = "공감수 " + response.data;
                      }
                    else if (response.code === 200) 
                     {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "success",
                    		title: '좋아요가 증가했습니다.', 
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		});

                       var newCommentsHTML = '';
                          newCommentsHTML += '<img src="/resources/img/like.jpg" alt="like Image">';
                       document.getElementById("likeBtn").innerHTML = newCommentsHTML;
                         document.getElementById("recom").innerHTML = "공감수 " + response.data;
                     } 
                    else if (response.code === 999) 
                     {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "warning",
                    		title: '로그인 후 이용 가능합니다', 
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		});

                         document.getElementById("recom").innerHTML = "공감수 " + response.data;
                     } 
                     else if (response.code === 404) 
                     {
                    	 Swal.fire({
                     		position: "center", 
                     		icon: "warning",
                     		title: '찾으시는 게시물이 없습니다.', 
                     		showConfirmButton: false, 
                     		timer: 1500 
                     		});

                     } 
                     else 
                     {
                    	 Swal.fire({
                     		position: "center", 
                     		icon: "warning",
                     		title: '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.(500)', 
                     		showConfirmButton: false, 
                     		timer: 1500 
                     		});

                     }
                 },
                 error: function(xhr, status, error) 
                 {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "warning",
                 		title: "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.", 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

                 }
             });
         });
      
      //북마크 버튼 클릭 시
         $("#bookMarkBtn").on("click", function() {
            
             $.ajax({
                 url: "/board/freeBookMark",
                 type: "POST",
                 data: {
                     brdSeq: ${brdSeq}
                 },
                 datatype:"JSON",
                 success: function(response) 
                 {
                      if(response.code === 201)
                      {
                    	  Swal.fire({
                      		position: "center", 
                      		icon: "success",
                      		title: '북마크를 취소했습니다.', 
                      		showConfirmButton: false, 
                      		timer: 1500 
                      		});

                        var newCommentsHTML = '';
                          newCommentsHTML += '<img src="/resources/img/bookMark_dark.png" alt="bookMark Image">';
                       document.getElementById("bookMarkBtn").innerHTML = newCommentsHTML;
                      }
                    else if (response.code === 200) 
                     {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "success",
                    		title: '북마크에 추가했습니다.', 
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		});

                       var newCommentsHTML = '';
                       newCommentsHTML += '<img src="/resources/img/bookMark.png" alt="bookMark Image">';
                        document.getElementById("bookMarkBtn").innerHTML = newCommentsHTML;
                          
                     } 
                    else if (response.code === 999) 
                     {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "warning",
                    		title: '로그인 후 이용 가능합니다', 
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		});

                     } 
                     else if (response.code === 404) 
                     {
                    	 Swal.fire({
                     		position: "center", 
                     		icon: "warning",
                     		title: '찾으시는 게시물이 없습니다.', 
                     		showConfirmButton: false, 
                     		timer: 1500 
                     		});

                     } 
                     else 
                     {
                    	 Swal.fire({
                     		position: "center", 
                     		icon: "warning",
                     		title: '서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.(500)', 
                     		showConfirmButton: false, 
                     		timer: 1500 
                     		});

                     }
                 },
                 error: function(xhr, status, error) 
                 {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "warning",
                 		title: "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.", 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

                 }
             });
         });

<c:if test="${boardMe eq 'Y'}">

      //수정 버튼 클릭 시
      $("#modifyBtn").on("click", function() {
         document.bbsForm.brdSeq.value = ${brdSeq};
         document.bbsForm.curPage.value = ${curPage};
         document.bbsForm.action = "/board/freeUpdate";
         document.bbsForm.submit();
      });
      
      //삭제 버튼 클릭 시
         $("#deleteBtn").on("click", function() {
        	 Swal.fire({
        		  title: "해당 게시물을 삭제 하시겠습니까?",
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
                 url:"/board/freeDelete",
                 data:{
                    brdSeq: ${brdSeq}
                 },
                 datatype:"JSON",
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
                    		title: '게시물이 삭제 되었습니다.',
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		}).then(function() {
                    			location.href = "/board/freeList";
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

                    }
                    else if(response.code == 403)
                    {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "warning",
                    		title: '본인글만 수정 가능합니다.', 
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		});

                    }
                    else if(response.code == 404)
                    {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "warning",
                    		title: '해당 게시물을 찾을수 없습니다.',
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		}).then(function() {
                    			 location.href = "/board/list";
                    		});

                    }
                    else
                    {
                    	Swal.fire({
                    		position: "center", 
                    		icon: "warning",
                    		title: '게시물 삭제시 오류가 발생하였습니다.', 
                    		showConfirmButton: false, 
                    		timer: 1500 
                    		});

                    }
                 },
                 error:function(xhr, status, error)
                 {
                    icia.common.error(error);
                 }
              });
           }
         });
          document.bbsForm.boardType.value = boardType;  
           document.bbsForm.action = "/board/list";
           document.bbsForm.submit();
        });
</c:if>

   //댓글 버튼 클릭시
   $("#comBtn").on("click", function() {
      
        if ($.trim($("#commentT").val()).length <= 0)
      {
        	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: '내용을 입력하세요.', 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

         $("#commentT").val("");
         $("#commentT").focus();
         return;
      } 
        
        $.ajax({
         type:"POST",
         url:"/writeProc/comment",
         data:{
            brdSeq: ${brdSeq},
            comContent:$("#commentT").val()
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(response){
            if(response.code === 0)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "success",
            		title: '댓글등록이 완료되었습니다.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

               
               $("#commentT").val("").focus();
               var newCommentsHTML = '';
               
               for (var i = 0; i < response.data.length; i++) {
                   var comment = response.data[i];
                   newCommentsHTML +=
                       '<div class="com-item-container" style="clear:both; padding-left:' + comment.comIndent * 3 + 'em">' +
                           '<div class="com-info">' +
                               '<span class="com-user">' +
                                   '<img src="/resources/profile/' + comment.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
                                   comment.userName + ' (' +
                                   (comment.userId.length > 10 ? comment.userId.substring(0, 9) + '...' : comment.userId) +
                                   ')</span> | <span class="com-date">' + comment.regDate + '</span>' +
                           '</div>' +
                           '<div class="com-content" id="com-content-' + comment.comSeq + '">' +
                               '<pre style="margin-left:' + comment.comIndent + 'em">' + comment.comContent + '</pre>' +
                           '</div>' +
                           '<div id="com-content-updt-' + comment.comSeq + '" style="display:none;">' +
                               '<input type="text" id="updt-contect-' + comment.comSeq + '" class="updt-contect" style="margin-left:' + comment.comIndent + 'em" value="' + comment.comContent + '">' +
                               '<button type="button" id="updt-submit-' + comment.comSeq + '" onClick="fn_updt_submit(' + comment.comSeq + ')" class="updt-submit" data-comseq="' + comment.comSeq + '">확인</button>' +
                           '</div>' +
                           '<div class="com-reply-add">';
                           
                           if(comment.replies != null && comment.replies.length > 0) {
                           	newCommentsHTML +=
                           		'<span id="replyToggleButton' + comment.comSeq + '" onClick="fn_replycom(' + comment.comSeq + ', ' + comment.replyCount + ')">답글 보기(' + comment.replyCount + ')</span>' +
                           		'<span onClick="fn_comcom(' + comment.comSeq + ')"> | 답글 달기</span>';
                           }
                           else {
                           	newCommentsHTML +=
                           		'<span onClick="fn_comcom(' + comment.comSeq + ')">답글 달기</span>';
                           }

                   if(comment.userId == "${cookieUserId}") {
                       newCommentsHTML +=
                           '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + comment.comSeq + ')"> | 수정</span>' +
                           '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + comment.comSeq + ')"> | 삭제 </span>';
                   }

                   newCommentsHTML +=
                           '</div>' +
                           '<div class="com-reply" id="comcomWrite' + comment.comSeq + '" style="clear:both; display:none;">' +
                               '<input type="text" id="comContent' + comment.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
                               '<input type="button" onClick="fn_comWBtn(' + comment.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
                           '</div>' +
                           '<div id="comcomReplies' + comment.comSeq + '" class="com-reply-item-container" style="clear:both; display:none;">';

                   if(comment.replies.length > 0) {
                       for(var j = 0; j < comment.replies.length; j++) {
                           var reply = comment.replies[j];
                           newCommentsHTML +=
                               '<div class="com-reply-item-container" style="clear:both; padding-left:' + reply.comIndent * 3 + 'em">' +
                                   '<div class="com-info">' + 
                                       '<img src="/resources/images/icon_reply.gif" />' +
                                       '@' + reply.replyUserId + '<span class="com-user"> | ' +
                                       '<img src="/resources/profile/' + reply.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
                                       reply.userName + ' (' +
                                       (reply.userId.length > 10 ? reply.userId.substring(0, 9) + '...' : reply.userId) +
                                       ')</span> | <span class="com-date">' + reply.regDate + '</span>' + 
                                   '</div>' +
                                   '<div class="com-content" id="com-content-' + reply.comSeq + '">' +
                                       '<pre style="margin-left:' + reply.comIndent + 'em">' + reply.comContent + '</pre>' +
                                   '</div>' +
                                   '<div id="com-content-updt-' + reply.comSeq + '" style="display:none;">' +
                                       '<input type="text" id="updt-contect-' + reply.comSeq + '" class="updt-contect" style="margin-left:' + reply.comIndent + 'em" value="' + reply.comContent + '">' +
                                       '<button type="button" id="updt-submit-' + reply.comSeq + '" onClick="fn_updt_submit(' + reply.comSeq + ')" class="updt-submit" data-comseq="' + reply.comSeq + '">확인</button>' +
                                   '</div>' +
                                   '<div class="com-reply-add">' +
                                       '<span onClick="fn_comcom(' + reply.comSeq + ')">답글 달기</span>';
                           if(reply.userId == "${cookieUserId}") {
                               newCommentsHTML +=
                                   '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + reply.comSeq + ')"> | 수정</span>' +
                                   '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + reply.comSeq + ')"> | 삭제</span>';
                           }
                           newCommentsHTML +=
                                   '</div>' +
                                   '<div class="com-reply" id="comcomWrite' + reply.comSeq + '" style="clear:both; display:none;">' +
                                       '<input type="text" id="comContent' + reply.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
                                       '<input type="button" onClick="fn_comWBtn(' + reply.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
                                   '</div>' +
                               '</div>';
                       }
                   }

                   if(comment.replies.length > 2) {
                       newCommentsHTML +=
                           '<button id="moreRepliesButton' + comment.comSeq + '" onclick="loadMoreReplies(' + comment.comSeq + ')" class="btn-more-replies">더보기</button>';
                   }

                   newCommentsHTML += '<input type="hidden" id="comSeq" value="' + comment.comSeq + '"></div></div>';
               }

               document.getElementById("commentRe").innerHTML = newCommentsHTML;
               fn_comCount();
            }
   
            if(response.code === 500)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '댓글등록중 오류가 발생하였습니다.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

            }
            if(response.code === 400)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: '로그인 후 이용가능합니다.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

            }
         },
         error:function(xhr, status, error)
         {
            icia.common.error(error);
         }
       });
     });
   
   
});

   //댓글삭제
   function fn_comDel(comSeq)
   {
      $.ajax({
         type:"POST",
         url:"/delete/comment",
         data:{
            brdSeq:${brdSeq},
            comSeq:comSeq
         },
         datatype:"JSON",
         beforeSend:function(xhr){
            xhr.setRequestHeader("AJAX", "true");
         },
         success:function(response){
            if(response.code === 0)
            {
            	Swal.fire({
            		position: "center", 
            		icon: "success",
            		title: '댓글삭제가 완료되었습니다.', 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

               
               $("#commentT").val("").focus();

               var newCommentsHTML = '';
               
               for (var i = 0; i < response.data.length; i++) {
                   var comment = response.data[i];
                   newCommentsHTML +=
                       '<div class="com-item-container" style="clear:both; padding-left:' + comment.comIndent * 3 + 'em">' +
                           '<div class="com-info">' +
                               '<span class="com-user">' +
                                   '<img src="/resources/profile/' + comment.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
                                   comment.userName + ' (' +
                                   (comment.userId.length > 10 ? comment.userId.substring(0, 9) + '...' : comment.userId) +
                                   ')</span> | <span class="com-date">' + comment.regDate + '</span>' +
                           '</div>' +
                           '<div class="com-content" id="com-content-' + comment.comSeq + '">' +
                               '<pre style="margin-left:' + comment.comIndent + 'em">' + comment.comContent + '</pre>' +
                           '</div>' +
                           '<div id="com-content-updt-' + comment.comSeq + '" style="display:none;">' +
                               '<input type="text" id="updt-contect-' + comment.comSeq + '" class="updt-contect" style="margin-left:' + comment.comIndent + 'em" value="' + comment.comContent + '">' +
                               '<button type="button" id="updt-submit-' + comment.comSeq + '" onClick="fn_updt_submit(' + comment.comSeq + ')" class="updt-submit" data-comseq="' + comment.comSeq + '">확인</button>' +
                           '</div>' +
                           '<div class="com-reply-add">';
                           
                           if(comment.replies != null && comment.replies.length > 0) {
                           	newCommentsHTML +=
                           		'<span id="replyToggleButton' + comment.comSeq + '" onClick="fn_replycom(' + comment.comSeq + ', ' + comment.replyCount + ')">답글 보기(' + comment.replyCount + ')</span>' +
                           		'<span onClick="fn_comcom(' + comment.comSeq + ')"> | 답글 달기</span>';
                           }
                           else {
                           	newCommentsHTML +=
                           		'<span onClick="fn_comcom(' + comment.comSeq + ')">답글 달기</span>';
                           }

                   if(comment.userId == "${cookieUserId}") {
                       newCommentsHTML +=
                           '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + comment.comSeq + ')"> | 수정</span>' +
                           '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + comment.comSeq + ')"> | 삭제 </span>';
                   }

                   newCommentsHTML +=
                           '</div>' +
                           '<div class="com-reply" id="comcomWrite' + comment.comSeq + '" style="clear:both; display:none;">' +
                               '<input type="text" id="comContent' + comment.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
                               '<input type="button" onClick="fn_comWBtn(' + comment.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
                           '</div>' +
                           '<div id="comcomReplies' + comment.comSeq + '" class="com-reply-item-container" style="clear:both; display:none;">';

                   if(comment.replies.length > 0) {
                       for(var j = 0; j < comment.replies.length; j++) {
                           var reply = comment.replies[j];
                           newCommentsHTML +=
                               '<div class="com-reply-item-container" style="clear:both; padding-left:' + reply.comIndent * 3 + 'em">' +
                                   '<div class="com-info">' + 
                                       '<img src="/resources/images/icon_reply.gif" />' +
                                       '@' + reply.replyUserId + '<span class="com-user"> | ' +
                                       '<img src="/resources/profile/' + reply.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
                                       reply.userName + ' (' +
                                       (reply.userId.length > 10 ? reply.userId.substring(0, 9) + '...' : reply.userId) +
                                       ')</span> | <span class="com-date">' + reply.regDate + '</span>' + 
                                   '</div>' +
                                   '<div class="com-content" id="com-content-' + reply.comSeq + '">' +
                                       '<pre style="margin-left:' + reply.comIndent + 'em">' + reply.comContent + '</pre>' +
                                   '</div>' +
                                   '<div id="com-content-updt-' + reply.comSeq + '" style="display:none;">' +
                                       '<input type="text" id="updt-contect-' + reply.comSeq + '" class="updt-contect" style="margin-left:' + reply.comIndent + 'em" value="' + reply.comContent + '">' +
                                       '<button type="button" id="updt-submit-' + reply.comSeq + '" onClick="fn_updt_submit(' + reply.comSeq + ')" class="updt-submit" data-comseq="' + reply.comSeq + '">확인</button>' +
                                   '</div>' +
                                   '<div class="com-reply-add">' +
                                       '<span onClick="fn_comcom(' + reply.comSeq + ')">답글 달기</span>';
                           if(reply.userId == "${cookieUserId}") {
                               newCommentsHTML +=
                                   '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + reply.comSeq + ')"> | 수정</span>' +
                                   '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + reply.comSeq + ')"> | 삭제</span>';
                           }
                           newCommentsHTML +=
                                   '</div>' +
                                   '<div class="com-reply" id="comcomWrite' + reply.comSeq + '" style="clear:both; display:none;">' +
                                       '<input type="text" id="comContent' + reply.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
                                       '<input type="button" onClick="fn_comWBtn(' + reply.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
                                   '</div>' +
                               '</div>';
                       }
                   }

                   if(comment.replies.length > 2) {
                       newCommentsHTML +=
                           '<button id="moreRepliesButton' + comment.comSeq + '" onclick="loadMoreReplies(' + comment.comSeq + ')" class="btn-more-replies">더보기</button>';
                   }

                   newCommentsHTML += '<input type="hidden" id="comSeq" value="' + comment.comSeq + '"></div></div>';
               }

               document.getElementById("commentRe").innerHTML = newCommentsHTML;
               fn_comCount();
            }
             if(response.code === 500)
            {
            	 Swal.fire({
             		position: "center", 
             		icon: "warning",
             		title: '댓글삭제중 오류가 발생하였습니다.', 
             		showConfirmButton: false, 
             		timer: 1500 
             		});

            }
             
          },
          error:function(xhr, status, error)
          {
             icia.common.error(error);
          }
          });
   }
   
   //대댓글 작성
      function fn_comWBtn(comcomSeq)
      {
        if ($.trim($("#comContent" + comcomSeq).val()).length <= 0)
         {
        	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: '내용을 입력하세요.', 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

            $("#comContent" + comcomSeq).val("");
            $("#comContent" + comcomSeq).focus();
            return;
         }
           
           $.ajax({
              type:"POST",
              url:"/replyProc/comment",
              data:{
                 brdSeq:${brdSeq},
                 comContent:$("#comContent" + comcomSeq).val(),
                 comSeq:comcomSeq
              },
              datatype:"JSON",
              beforeSend:function(xhr){
                 xhr.setRequestHeader("AJAX", "true");
              },
              success:function(response)
              {
                 if(response.code === 0)
               {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "success",
                 		title: '대댓글이 작성되었습니다.', 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

                    
                    $("#commentT").val("").focus();
                      
					var newCommentsHTML = '';
	                
	                for (var i = 0; i < response.data.length; i++) {
	                    var comment = response.data[i];
	                    newCommentsHTML +=
	                        '<div class="com-item-container" style="clear:both; padding-left:' + comment.comIndent * 3 + 'em">' +
	                            '<div class="com-info">' +
	                                '<span class="com-user">' +
	                                    '<img src="/resources/profile/' + comment.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
	                                    comment.userName + ' (' +
	                                    (comment.userId.length > 10 ? comment.userId.substring(0, 9) + '...' : comment.userId) +
	                                    ')</span> | <span class="com-date">' + comment.regDate + '</span>' +
	                            '</div>' +
	                            '<div class="com-content" id="com-content-' + comment.comSeq + '">' +
	                                '<pre style="margin-left:' + comment.comIndent + 'em">' + comment.comContent + '</pre>' +
	                            '</div>' +
	                            '<div id="com-content-updt-' + comment.comSeq + '" style="display:none;">' +
	                                '<input type="text" id="updt-contect-' + comment.comSeq + '" class="updt-contect" style="margin-left:' + comment.comIndent + 'em" value="' + comment.comContent + '">' +
	                                '<button type="button" id="updt-submit-' + comment.comSeq + '" onClick="fn_updt_submit(' + comment.comSeq + ')" class="updt-submit" data-comseq="' + comment.comSeq + '">확인</button>' +
	                            '</div>' +
	                            '<div class="com-reply-add">';
	                            
	                            if(comment.replies != null && comment.replies.length > 0) {
	                            	newCommentsHTML +=
	                            		'<span id="replyToggleButton' + comment.comSeq + '" onClick="fn_replycom(' + comment.comSeq + ', ' + comment.replyCount + ')">답글 보기(' + comment.replyCount + ')</span>' +
	                            		'<span onClick="fn_comcom(' + comment.comSeq + ')"> | 답글 달기</span>';
	                            }
	                            else {
	                            	newCommentsHTML +=
	                            		'<span onClick="fn_comcom(' + comment.comSeq + ')">답글 달기</span>';
	                            }

	                    if(comment.userId == "${cookieUserId}") {
	                        newCommentsHTML +=
	                            '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + comment.comSeq + ')"> | 수정</span>' +
	                            '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + comment.comSeq + ')"> | 삭제 </span>';
	                    }

	                    newCommentsHTML +=
	                            '</div>' +
	                            '<div class="com-reply" id="comcomWrite' + comment.comSeq + '" style="clear:both; display:none;">' +
	                                '<input type="text" id="comContent' + comment.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
	                                '<input type="button" onClick="fn_comWBtn(' + comment.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
	                            '</div>' +
	                            '<div id="comcomReplies' + comment.comSeq + '" class="com-reply-item-container" style="clear:both; display:none;">';

	                    if(comment.replies.length > 0) {
	                        for(var j = 0; j < comment.replies.length; j++) {
	                            var reply = comment.replies[j];
	                            newCommentsHTML +=
	                                '<div class="com-reply-item-container" style="clear:both; padding-left:' + reply.comIndent * 3 + 'em">' +
	                                    '<div class="com-info">' + 
	                                        '<img src="/resources/images/icon_reply.gif" />' +
	                                        '@' + reply.replyUserId + '<span class="com-user"> | ' +
	                                        '<img src="/resources/profile/' + reply.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
	                                        reply.userName + ' (' +
	                                        (reply.userId.length > 10 ? reply.userId.substring(0, 9) + '...' : reply.userId) +
	                                        ')</span> | <span class="com-date">' + reply.regDate + '</span>' + 
	                                    '</div>' +
	                                    '<div class="com-content" id="com-content-' + reply.comSeq + '">' +
	                                        '<pre style="margin-left:' + reply.comIndent + 'em">' + reply.comContent + '</pre>' +
	                                    '</div>' +
	                                    '<div id="com-content-updt-' + reply.comSeq + '" style="display:none;">' +
	                                        '<input type="text" id="updt-contect-' + reply.comSeq + '" class="updt-contect" style="margin-left:' + reply.comIndent + 'em" value="' + reply.comContent + '">' +
	                                        '<button type="button" id="updt-submit-' + reply.comSeq + '" onClick="fn_updt_submit(' + reply.comSeq + ')" class="updt-submit" data-comseq="' + reply.comSeq + '">확인</button>' +
	                                    '</div>' +
	                                    '<div class="com-reply-add">' +
	                                        '<span onClick="fn_comcom(' + reply.comSeq + ')">답글 달기</span>';
	                            if(reply.userId == "${cookieUserId}") {
	                                newCommentsHTML +=
	                                    '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + reply.comSeq + ')"> | 수정</span>' +
	                                    '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + reply.comSeq + ')"> | 삭제</span>';
	                            }
	                            newCommentsHTML +=
	                                    '</div>' +
	                                    '<div class="com-reply" id="comcomWrite' + reply.comSeq + '" style="clear:both; display:none;">' +
	                                        '<input type="text" id="comContent' + reply.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
	                                        '<input type="button" onClick="fn_comWBtn(' + reply.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
	                                    '</div>' +
	                                '</div>';
	                        }
	                    }

	                    if(comment.replies.length > 2) {
	                        newCommentsHTML +=
	                            '<button id="moreRepliesButton' + comment.comSeq + '" onclick="loadMoreReplies(' + comment.comSeq + ')" class="btn-more-replies">더보기</button>';
	                    }

	                    newCommentsHTML += '<input type="hidden" id="comSeq" value="' + comment.comSeq + '"></div></div>';
	                }

	                document.getElementById("commentRe").innerHTML = newCommentsHTML;
	                fn_comCount();
               }
                 if(response.code === 500)
               {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "warning",
                 		title: '대댓글등록중 오류가 발생하였습니다.', 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

               }
                 
                 if(response.code === 404)
               {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "warning",
                 		title: '원글이 없습니다.', 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

               }
                 
                 if(response.code === 400)
               {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "warning",
                 		title: '게시글이 없습니다.', 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

               }
                 if(response.code === 999)
                   {
                	 Swal.fire({
                 		position: "center", 
                 		icon: "warning",
                 		title: '로그인 후 이용 가능합니다.', 
                 		showConfirmButton: false, 
                 		timer: 1500 
                 		});

                   }
              },
              error:function(xhr, status, error)
              {
                 icia.common.error(error);
              }
              });
 
     }
   	
   	function fn_comCount()
   	{
   		$.ajax({
            type:"POST",
            url:"/writeProc/commentCount",
            data:{
               brdSeq:${brdSeq}
            },
            datatype:"JSON",
            beforeSend:function(xhr){
               xhr.setRequestHeader("AJAX", "true");
            },
            success:function(response)
            {
            	if(response.code === 0)
		    	{
            		var newCommentsHTML = '';
            		
            		newCommentsHTML += '<span class="comment-title">댓글 ' + response.data + '</span>' + 
                    '<p class="notice">* 게시판의 취지와는 상관없는 욕설이나 비방 글, 도배 글 등의 경우에는 관리자가 사전에 통보 없이 삭제할 수 있습니다.</p>';
                    
            		 document.getElementById("commentCount").innerHTML = newCommentsHTML;
		    	}
            },
        	error:function(xhr, status, error)
            {
               icia.common.error(error);
            }
            });
   	}
   
    function fn_comcom(comSeq)
    {
    	var comContent = $("#comContent" + comSeq);
    	
       if($("#comcomWrite" + comSeq).css('display') == 'none') 
       {
            $("#comcomWrite" + comSeq).css('display', 'block');
            $("#comcomWrite" + comSeq).css('height', '100px');
        } 
       else
       {
            $("#comcomWrite" + comSeq).css('display', 'none');
            $("#comcomWrite" + comSeq).css('height', '0px');
            
            comContent.val("");
        }
    }
      
    function fn_replycom(comSeq, replyCount)
    {
        var replyContainer = $("#comcomReplies" + comSeq);  
        var replyToggleButton = $("#replyToggleButton" + comSeq);

        if (replyContainer.css('display') === 'none') {
            replyContainer.css('display', 'block');
            replyToggleButton.text("답글 숨기기");  
        } else {
            replyContainer.css('display', 'none');
            replyToggleButton.text("답글 보기(" + replyCount + ")");
        }
    }
      
    function loadMoreReplies(comSeq) 
    {
        var replyItems = $("#comcomReplies" + comSeq + " .com-reply-item-container");
        var visibleReplies = replyItems.filter(':visible').length;

        var nextReplies = replyItems.slice(visibleReplies, visibleReplies + 2);
        nextReplies.css('display', 'block');

        if (visibleReplies + nextReplies.length >= replyItems.length) 
        {
            $("#moreRepliesButton" + comSeq).hide();
        }
    }
    
    function fn_comUpdt(comSeq) 
    {
        var content = document.getElementById("com-content-" + comSeq);
        var contentUpdt = document.getElementById("com-content-updt-" + comSeq);
        var updtInput = document.getElementById("updt-contect-" + comSeq);
        var originalContent = content.textContent.trim();
        
        if (content && contentUpdt) {
            if (content.style.display === "none") {
                content.style.display = "block";
                contentUpdt.style.display = "none";
            } else {
                content.style.display = "none"; 
                contentUpdt.style.display = "block";
                
                updtInput.value = originalContent; 
            }
        }
    }
	
  	//댓글
    function fn_updt_submit(comSeq) {
	    const comContent = $.trim($("#updt-contect-" + comSeq).val());

	    if (comContent.length <= 0) {
	    	Swal.fire({
        		position: "center", 
        		icon: "warning",
        		title: '내용을 입력하세요.', 
        		showConfirmButton: false, 
        		timer: 1500 
        		});

	        return;
	    }
	
	    $.ajax({
	        url: "/update/comment",
	        type: "POST",
	        data: {
	            comContent: comContent,
	            comSeq: comSeq,
	            brdSeq: ${brdSeq}
	        },
	        dataType: "JSON",
	        success: function(response) {
	            if (response.code === 0) {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "success",
	            		title: '수정을 완료했습니다.', 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	                
	                var newCommentsHTML = '';
	                
	                for (var i = 0; i < response.data.length; i++) {
	                    var comment = response.data[i];
	                    newCommentsHTML +=
	                        '<div class="com-item-container" style="clear:both; padding-left:' + comment.comIndent * 3 + 'em">' +
	                            '<div class="com-info">' +
	                                '<span class="com-user">' +
	                                    '<img src="/resources/profile/' + comment.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
	                                    comment.userName + ' (' +
	                                    (comment.userId.length > 10 ? comment.userId.substring(0, 9) + '...' : comment.userId) +
	                                    ')</span> | <span class="com-date">' + comment.regDate + '</span>' +
	                            '</div>' +
	                            '<div class="com-content" id="com-content-' + comment.comSeq + '">' +
	                                '<pre style="margin-left:' + comment.comIndent + 'em">' + comment.comContent + '</pre>' +
	                            '</div>' +
	                            '<div id="com-content-updt-' + comment.comSeq + '" style="display:none;">' +
	                                '<input type="text" id="updt-contect-' + comment.comSeq + '" class="updt-contect" style="margin-left:' + comment.comIndent + 'em" value="' + comment.comContent + '">' +
	                                '<button type="button" id="updt-submit-' + comment.comSeq + '" onClick="fn_updt_submit(' + comment.comSeq + ')" class="updt-submit" data-comseq="' + comment.comSeq + '">확인</button>' +
	                            '</div>' +
	                            '<div class="com-reply-add">';
	                            
	                            if(comment.replies != null && comment.replies.length > 0) {
	                            	newCommentsHTML +=
	                            		'<span id="replyToggleButton' + comment.comSeq + '" onClick="fn_replycom(' + comment.comSeq + ', ' + comment.replyCount + ')">답글 보기(' + comment.replyCount + ')</span>' +
	                            		'<span onClick="fn_comcom(' + comment.comSeq + ')"> | 답글 달기</span>';
	                            }
	                            else {
	                            	newCommentsHTML +=
	                            		'<span onClick="fn_comcom(' + comment.comSeq + ')">답글 달기</span>';
	                            }

	                    if(comment.userId == "${cookieUserId}") {
	                        newCommentsHTML +=
	                            '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + comment.comSeq + ')"> | 수정</span>' +
	                            '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + comment.comSeq + ')"> | 삭제 </span>';
	                    }

	                    newCommentsHTML +=
	                            '</div>' +
	                            '<div class="com-reply" id="comcomWrite' + comment.comSeq + '" style="clear:both; display:none;">' +
	                                '<input type="text" id="comContent' + comment.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
	                                '<input type="button" onClick="fn_comWBtn(' + comment.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
	                            '</div>' +
	                            '<div id="comcomReplies' + comment.comSeq + '" class="com-reply-item-container" style="clear:both; display:none;">';

	                    if(comment.replies.length > 0) {
	                        for(var j = 0; j < comment.replies.length; j++) {
	                            var reply = comment.replies[j];
	                            newCommentsHTML +=
	                                '<div class="com-reply-item-container" style="clear:both; padding-left:' + reply.comIndent * 3 + 'em">' +
	                                    '<div class="com-info">' + 
	                                        '<img src="/resources/images/icon_reply.gif" />' +
	                                        '@' + reply.replyUserId + '<span class="com-user"> | ' +
	                                        '<img src="/resources/profile/' + reply.userProfile + '" onerror=\'this.src="/resources/images/default-profile.jpg"\' style="width:30px; height:30px; border-radius:50%;">&nbsp;' +
	                                        reply.userName + ' (' +
	                                        (reply.userId.length > 10 ? reply.userId.substring(0, 9) + '...' : reply.userId) +
	                                        ')</span> | <span class="com-date">' + reply.regDate + '</span>' + 
	                                    '</div>' +
	                                    '<div class="com-content" id="com-content-' + reply.comSeq + '">' +
	                                        '<pre style="margin-left:' + reply.comIndent + 'em">' + reply.comContent + '</pre>' +
	                                    '</div>' +
	                                    '<div id="com-content-updt-' + reply.comSeq + '" style="display:none;">' +
	                                        '<input type="text" id="updt-contect-' + reply.comSeq + '" class="updt-contect" style="margin-left:' + reply.comIndent + 'em" value="' + reply.comContent + '">' +
	                                        '<button type="button" id="updt-submit-' + reply.comSeq + '" onClick="fn_updt_submit(' + reply.comSeq + ')" class="updt-submit" data-comseq="' + reply.comSeq + '">확인</button>' +
	                                    '</div>' +
	                                    '<div class="com-reply-add">' +
	                                        '<span onClick="fn_comcom(' + reply.comSeq + ')">답글 달기</span>';
	                            if(reply.userId == "${cookieUserId}") {
	                                newCommentsHTML +=
	                                    '<span class="com-updt" id="comupdt" onClick="fn_comUpdt(' + reply.comSeq + ')"> | 수정</span>' +
	                                    '<span class="com-delt" id="comdelt" onClick="fn_comDel(' + reply.comSeq + ')"> | 삭제</span>';
	                            }
	                            newCommentsHTML +=
	                                    '</div>' +
	                                    '<div class="com-reply" id="comcomWrite' + reply.comSeq + '" style="clear:both; display:none;">' +
	                                        '<input type="text" id="comContent' + reply.comSeq + '" class="com-reply-input" placeholder="내용을 입력하세요">' +
	                                        '<input type="button" onClick="fn_comWBtn(' + reply.comSeq + ')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">' +
	                                    '</div>' +
	                                '</div>';
	                        }
	                    }

	                    if(comment.replies.length > 2) {
	                        newCommentsHTML +=
	                            '<button id="moreRepliesButton' + comment.comSeq + '" onclick="loadMoreReplies(' + comment.comSeq + ')" class="btn-more-replies">더보기</button>';
	                    }

	                    newCommentsHTML += '<input type="hidden" id="comSeq" value="' + comment.comSeq + '"></div></div>';
	                }

	                document.getElementById("commentRe").innerHTML = newCommentsHTML;
	                fn_comCount();
	            } 
	            else if (response.code === 400) {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: '연결 중 오류가 발생했습니다.', 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	            } 
	            else {
	            	Swal.fire({
	            		position: "center", 
	            		icon: "warning",
	            		title: '수정 중 오류가 발생했습니다.', 
	            		showConfirmButton: false, 
	            		timer: 1500 
	            		});

	            }
	        },
	        error: function(xhr, status, error) {
	        	Swal.fire({
            		position: "center", 
            		icon: "warning",
            		title: "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요.", 
            		showConfirmButton: false, 
            		timer: 1500 
            		});

	        }
	    });
	}
    
</script>
</head>

<body>
   <%@ include file="/WEB-INF/views/include/navigation.jsp"%>
   <section class="notice-section">
      <div class="notice-content"></div>
   </section>

   <section class="content-section">
      <div class="sidebar">
         <div class="exam-date" id="d-day-display">
            2026 수능 <span class="days"></span>
         </div>
         <ul class="menu">
            <li><a href="/board/noticeList">공지사항</a></li>
            <li><a href="/board/qnaList">문의사항</a></li>
            <li><a href="/board/freeList" class="highlight">자유게시판</a></li>
            <li><a href="/board/faqList">자주 묻는 질문</a></li>
         </ul>
      </div>
      <div class="table-container">
         <h2 class="subTitle">자유게시판 > 게시글 보기</h2>
         <div class="header-line"></div>
         <section class="board-container">

            <!-- 게시글 정보 -->
            <div class="board-info">
               <p>
                  <strong>
                     <c:if test="${board.category eq '1'}">일상/생각</c:if>
                     <c:if test="${board.category eq '2'}">학습고민</c:if>
                     <c:if test="${board.category eq '3'}">입시</c:if>
                     <c:if test="${board.category eq '4'}">진로</c:if>
                  </strong>
                  
                  <button id="bookMarkBtn" class="btn-bookMark">
                    <c:if test="${boardMarkStatus eq 1}">
                           <img src="/resources/img/bookMark.png" alt="bookMark Image">
                    </c:if>
                    <c:if test="${boardMarkStatus eq 0}">
                           <img src="/resources/img/bookMark_dark.png" alt="bookMark Image">
                    </c:if>
                        </button>
                        
               </p>
               <h2>${board.brdTitle}</h2>
               <div class="post-meta">
                  <span><img src="/resources/profile/${board.userProfile}" onerror='this.src="/resources/images/default-profile.jpg"' style="width:30px; height:30px; border-radius:50%;">
                   &nbsp;${board.userName}(
                           <c:choose>
							        <c:when test="${fn:length(board.userId) gt 10}">
							        <c:out value="${fn:substring(board.userId, 0, 9)}...">
							        </c:out></c:when>
							        <c:otherwise>
							        <c:out value="${board.userId}">
							        </c:out></c:otherwise>
							</c:choose>
                           )</span>
                  <span>${board.regDate}</span>
                  <span>조회수 ${board.brdReadCnt}</span>
                  <span id="recom">공감수 ${boardLikeCount}</span>
               </div>
               
            </div>

            <!-- 게시글 내용 -->
            <div class="board-content">
<c:if test="${!empty board.boardFile}">
            <!-- 사진 -->
   <c:if test="${board.boardFile.fileExt == 'jpg' or board.boardFile.fileExt == 'jpeg' or board.boardFile.fileExt == 'png' or board.boardFile.fileExt == 'gif' or board.boardFile.fileExt == 'bmp'}">
               <img src="/resources/upload/${board.boardFile.fileName }" style="max-width: 50%; margin-bottom: 20px;">
   </c:if>
            <!-- 동영상 -->
    <c:if test="${board.boardFile.fileExt == 'mp4' or board.boardFile.fileExt == 'avi' or board.boardFile.fileExt == 'mov' or board.boardFile.fileExt == 'mkv'}">
        <video style="max-width: 100%; max-height: 500px;" controls>
            <source src="/resources/upload/${board.boardFile.fileName}" type="video/${board.boardFile.fileExt}">
        </video>
    </c:if>
             <!-- 텍스트 -->
    <c:if test="${board.boardFile.fileExt == 'txt' or board.boardFile.fileExt == 'csv' or board.boardFile.fileExt == 'pdf'}">
        <a href="/resources/upload/${board.boardFile.fileName}" download="${board.boardFile.fileOrgName}">
            다운로드 : ${board.boardFile.fileOrgName}
        </a>
    </c:if>
   
</c:if>
				<div class="ql-editor">
               		<p>${board.brdContent}</p>
               </div>
            </div>


            <!-- 댓글 -->
            <div class="comment-section">
            
               <!-- 버튼 영역 -->
               <div class="comment-buttons">
               
                  <button id="likeBtn" class="btn-like">
                     <c:if test="${boardLikeStatus eq 1}">
                                 <img src="/resources/img/like.jpg" alt="like Image">
                          </c:if>
                          <c:if test="${boardLikeStatus eq 0}">
                                 <img src="/resources/img/likey.jpg" alt="bookMark Image">
                          </c:if>
                     
                  </button>
<c:if test="${boardMe eq 'Y'}">                  
                  <button id="deleteBtn" class="btn-delete">삭제</button>
                  <button id="modifyBtn" class="btn-modify">수정</button>
</c:if>
                  <button id="listBtn" class="btn-list">목록</button>
               </div>

               <!-- 댓글 헤더 -->
               <div id="commentCount" class="comment-header">
                  <span class="comment-title">댓글 ${commentCount}</span>
                  <p class="notice">* 게시판의 취지와는 상관없는 욕설이나 비방 글, 도배 글 등의 경우에는 관리자가 사전에 통보 없이 삭제할 수 있습니다.</p>
               </div>

               <!-- 댓글 입력 영역 -->
               <div class="comment-input-container">
                  <textarea id="commentT" class="comment-input" placeholder="댓글은 최대 1,000 byte까지 입력이 가능합니다."></textarea>
                  <button type="button" id="comBtn" class="comment-submit">등록</button>
               </div>
            </div>
            
            <div class="comment-list-container" id="commentRe">
<c:if test="${!empty comment}">      
    <c:forEach var="comment" items="${comment}" varStatus="status">
        <div class="com-item-container" style="clear:both; padding-left:${comment.comIndent * 3}em">
            <div class="com-info">
                <span class="com-user">
                <img src="/resources/profile/${comment.userProfile}" onerror='this.src="/resources/images/default-profile.jpg"' style="width:30px; height:30px; border-radius:50%;">&nbsp;
                ${comment.userName}(
                <c:choose>
				        <c:when test="${fn:length(comment.userId) gt 10}">
				        <c:out value="${fn:substring(comment.userId, 0, 9)}...">
				        </c:out></c:when>
				        <c:otherwise>
				        <c:out value="${comment.userId}">
				        </c:out></c:otherwise>
				</c:choose>
                        )</span> | <span class="com-date">${comment.regDate}</span>
            </div>
            <div class="com-content" id="com-content-${comment.comSeq}">
                <pre style="margin-left:${comment.comIndent}em">${comment.comContent}</pre>
            </div>
            <div id="com-content-updt-${comment.comSeq}" style="display:none;">
            	<input type="text" id="updt-contect-${comment.comSeq }" class="updt-contect" style="margin-left:${comment.comIndent}em" value="${comment.comContent}">
            	<button type="button" id="updt-submit-${comment.comSeq }" onClick="fn_updt_submit('${comment.comSeq}')" class="updt-submit" data-comseq="${comment.comSeq}">확인</button>
            </div>

            <div class="com-reply-add">
            	<c:if test="${not empty comment.replies}">
	                <span id="replyToggleButton${comment.comSeq}" onClick="fn_replycom('${comment.comSeq}', '${comment.replyCount}')">답글 보기(${comment.replyCount})</span>
	            	<span onClick="fn_comcom('${comment.comSeq}')"> | 답글 달기</span>
	            </c:if>
	            <c:if test="${empty comment.replies}">
	                <span onClick="fn_comcom('${comment.comSeq}')">답글 달기</span>
	            </c:if>
                <c:if test="${comment.userId == cookieUserId}">
                    <span class="com-updt" id="comupdt" onClick="fn_comUpdt('${comment.comSeq}')"> | 수정</span>
                    <span class="com-delt" id="comdelt" onClick="fn_comDel('${comment.comSeq}')"> | 삭제 </span>
                </c:if>
            </div>

            <!-- 대댓글 입력 폼 -->
            <div class="com-reply" id="comcomWrite${comment.comSeq}" style="clear:both; display:none;">
                <input type="text" id="comContent${comment.comSeq}" class="com-reply-input" placeholder="내용을 입력하세요">
                <input type="button" onClick="fn_comWBtn('${comment.comSeq}')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">
            </div>

            <!-- 대댓글 목록 -->
         <div id="comcomReplies${comment.comSeq}" class="com-reply-item-container" style="clear:both; display:none;">
             <c:if test="${not empty comment.replies}">
                 <c:forEach var="reply" items="${comment.replies}" varStatus="replyStatus">
                     <div class="com-reply-item-container" style="clear:both; padding-left:${reply.comIndent * 3}em">
                         <div class="com-info">
                             <img src="/resources/images/icon_reply.gif" />
                             @${reply.replyUserId} <span class="com-user"> | <img src="/resources/profile/${reply.userProfile}" onerror='this.src="/resources/images/default-profile.jpg"' style="width:30px;height:30px; border-radius:50%;">&nbsp;
                             ${reply.userName}(
			                <c:choose>
							        <c:when test="${fn:length(reply.userId) gt 10}">
							        <c:out value="${fn:substring(reply.userId, 0, 9)}...">
							        </c:out></c:when>
							        <c:otherwise>
							        <c:out value="${reply.userId}">
							        </c:out></c:otherwise>
							</c:choose>
							)</span> | <span class="com-date">${reply.regDate}</span>
                         </div>
                         <div class="com-content" id="com-content-${reply.comSeq}">
			                <pre style="margin-left:${reply.comIndent}em">${reply.comContent}</pre>
			            </div>
			            <div id="com-content-updt-${reply.comSeq}" style="display:none;">
			            	<input type="text" id="updt-contect-${reply.comSeq}" class="updt-contect" style="margin-left:${reply.comIndent}em" value="${reply.comContent}">
			            	<button type="button" id="updt-submit-${reply.comSeq}" onClick="fn_updt_submit('${reply.comSeq}')" class="updt-submit" data-comseq="${reply.comSeq}">확인</button>
			            </div>

                         <div class="com-reply-add">
                             <span onClick="fn_comcom('${reply.comSeq}')">답글 달기</span>
                             <c:if test="${reply.userId == cookieUserId}">
                                 <span class="com-updt" id="comupdt" onClick="fn_comUpdt('${reply.comSeq}')"> | 수정</span>
                    			<span class="com-delt" id="comdelt" onClick="fn_comDel('${reply.comSeq}')"> | 삭제 </span>
                             </c:if>
                         </div>
                         <div class="com-reply" id="comcomWrite${reply.comSeq}" style="clear:both; display:none;">
                             <input type="text" id="comContent${reply.comSeq}" class="com-reply-input" placeholder="내용을 입력하세요">
                             <input type="button" onClick="fn_comWBtn('${reply.comSeq}')" class="com-reply-btn" value="대댓글 작성" style="background: #604f47;">
                         </div>
                     </div>
                 </c:forEach>
            </c:if>
			<c:if test="${comment.replies.size() > 2}">
            	<button id="moreRepliesButton${comment.comSeq}" onclick="loadMoreReplies('${comment.comSeq}')" class="btn-more-replies">더보기</button>
        	</c:if>
            <input type="hidden" id="comSeq" value="${comment.comSeq}">
        </div>
        </div>
    </c:forEach>     
</c:if>
             </div>
            
         </section>
      </div>
   </section>
   
   <%@ include file="/WEB-INF/views/include/footfooter.jsp"%>

   <form name="bbsForm" id="bbsForm" method="POST">
         <input type="hidden" name="brdSeq" value="${brdSeq}" />
         <input type="hidden" name="searchType" value="${searchType}" />
         <input type="hidden" name="searchValue" value="${searchValue}" />
         <input type="hidden" name="curPage" value="${curPage}"/>
         <input type="hidden" name="category" value="${category}"/>
   </form>
</body>

</html>



