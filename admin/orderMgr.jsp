<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<link rel="stylesheet" href="/resources/css/admin/orderMgr.css">
<style>
</style>

<script>
    
    $(function() {
       
       
       // 검색 버튼 클릭시
       $("#btnSearch").on("click", function() {
          
              // 날짜 입력값 가져오기
           const orderDateFrom = document.getElementById('orderDateFrom').value;
           const orderDateTo = document.getElementById('orderDateTo').value;

           // 값이 비어있지 않은지 확인
           if (orderDateFrom && orderDateTo) {
               const fromDate = new Date(orderDateFrom);
               const toDate = new Date(orderDateTo);

               // 비교: orderDateTo가 orderDateFrom보다 이전인지 확인
               if (toDate < fromDate) {
                  Swal.fire({
                      position: "center", 
                      icon: "warning",
                      title: '시작날짜보다 이후의 날짜를 선택해주세요.', 
                      showConfirmButton: false, 
                      timer: 1500 
                      });

                   return false;
               }
           }
           
           console.log("orderDateFrom:", orderDateFrom); 
           console.log("orderDateTo:", orderDateTo);

           console.log("Hidden field - searchStartDate:", document.bbsForm.searchStartDate.value);
           console.log("Hidden field - searchEndDate:", document.bbsForm.searchEndDate.value);
           
           
           document.bbsForm.orderSeq.value = "";
           document.bbsForm.searchOrderStatus.value = $("#_searchOrderStatus").val();
           document.bbsForm.searchOrderSeq.value = $("#_searchOrderSeq").val();
           document.bbsForm.searchStartDate.value = orderDateFrom;
           document.bbsForm.searchEndDate.value = orderDateTo;
           document.bbsForm.curPage.value = "1";
           document.bbsForm.action = "/admin/orderMgr";
           document.bbsForm.submit();
           
       });
       
    });
    
    
    
    
    function fn_list(curPage) {
       
          // 날짜 입력값 가져오기
       const orderDateFrom = document.getElementById('orderDateFrom').value;
       const orderDateTo = document.getElementById('orderDateTo').value;
       
      document.bbsForm.curPage.value = curPage;
       document.bbsForm.orderSeq.value = "";
       document.bbsForm.searchOrderStatus.value = $("#_searchOrderStatus").val();
       document.bbsForm.searchOrderSeq.value = $("#_searchOrderSeq").val();
       document.bbsForm.searchStartDate.value = orderDateFrom;
       document.bbsForm.searchEndDate.value = orderDateTo;
      document.bbsForm.action = "/admin/orderMgr";
      document.bbsForm.submit();
   }   
    </script>
</head>

<body>
   <%@ include file="/WEB-INF/views/include/admin/nav.jsp"%>
   <div id="wrapper">

      <div id="main_content">
         <h4>주문 관리</h4>
         <div class="search_section">
            <form>
               <label for="orderStatus">주문 상태:</label> <select id="_searchOrderStatus" name="_searchOrderStatus">
                  <option value="0" <c:if test='${searchOrderStatus eq "0" or searchOrderStatus == null}'> selected </c:if>>전체</option>
                  <option value="1" <c:if test='${searchOrderStatus eq "1"}'> selected </c:if>>주문접수</option>
                  <option value="2" <c:if test='${searchOrderStatus eq "2"}'> selected </c:if>>취소요청</option>
                  <option value="3" <c:if test='${searchOrderStatus eq "3"}'> selected </c:if>>주문취소</option>
                  <option value="4" <c:if test='${searchOrderStatus eq "4"}'> selected </c:if>>입금대기</option>
                  <option value="5" <c:if test='${searchOrderStatus eq "5"}'> selected </c:if>>배송준비중</option>
                  <option value="6" <c:if test='${searchOrderStatus eq "6"}'> selected </c:if>>배송중</option>
                  <option value="7" <c:if test='${searchOrderStatus eq "7"}'> selected </c:if>>배송완료</option>
               </select> <label for="orderDate">주문일:</label>
               <input type="date" id="orderDateFrom" value="${searchStartDate != null ? searchStartDate : ''}">
               ~
               <input type="date" id="orderDateTo" value="${searchEndDate != null ? searchEndDate : ''}">


               <label for="orderSearch">주문 번호:</label>
               <input type="text" name="_searchOrderSeq" id="_searchOrderSeq" value="<c:if test='${searchOrderSeq != 0}'> ${searchOrderSeq} </c:if>" placeholder="주문번호를 입력하세요.">
               <button type="button" id="btnSearch" class="btn">검색</button>
            </form>


         </div>
         <table class="data_table">
            <thead>
               <tr>
                  <th width="10%">주문번호</th>
                  <th width="10%">구매자ID</th>
                  <th width="10%">구매자명</th>
                  <th width="30%">주문명</th>
                  <th width="10%">결제금액</th>
                  <th width="10%">연락처</th>
                  <th width="10%">주문상태</th>
                  <th width="10%">주문일자</th>
               </tr>
            </thead>
            <tbody>


               <c:if test="${!empty ol }">
                  <c:forEach var="order" items="${ol }" varStatus="status">
                     <tr>
                        <td><a href="#" class="order-link" data-order-id="${order.orderSeq }">${order.orderSeq }</a></td>
                        <td>${order.userId }</td>
                        <td>${order.orderName }</td>
                        <td>${order.orderProName }</td>
                        <td><fmt:formatNumber value="${order.payPrice}" type="number" groupingUsed="true" />원</td>
                        <td><c:set var="phone" value="${order.viewOrderDate}" /> <c:set var="formattedPhone" value="${fn:substring(phone, 0, 3)}-${fn:substring(phone, 3, 7)}-${fn:substring(phone, 7, fn:length(phone))}" /> ${formattedPhone}</td>
                        <td>${order.viewStatus }</td>
                        <td>${order.orderDate }</td>
                     </tr>
                  </c:forEach>
               </c:if>

               <c:if test="${empty ol }">
                  <tr>
                     <td colspan="8">주문내역이 존재하지 않습니다.</td>
                  </tr>
               </c:if>
            </tbody>
         </table>



         <div class="pagination">

            <c:if test="${!empty orderPaging }">

               <c:if test="${orderPaging.prevBlockPage gt 0 }">
                  <a href="#" class="page-link">&laquo;</a>
                  <!-- 이전 페이지 -->
               </c:if>

               <c:forEach var="i" begin="${orderPaging.startPage }" end="${orderPaging.endPage }">
                  <c:choose>
                     <c:when test="${i ne curPage }">
                        <a href="#" class="page-link" onclick="fn_list(${i})">${i }</a>
                     </c:when>

                     <c:otherwise>
                        <a href="#" class="page-link active">${i }</a>
                     </c:otherwise>

                  </c:choose>
               </c:forEach>

               <c:if test="${orderPaging.nextBlockPage gt 0 }">
                  <a href="#" class="page-link">&raquo;</a>
                  <!-- 다음 페이지 -->
               </c:if>

            </c:if>

         </div>



      </div>
   </div>

   <form name="bbsForm" id="bbsForm" method="post">
      <input type="hidden" name="orderSeq" value="">
      <input type="hidden" name="searchOrderStatus" id="searchOrderStatus" value="${searchOrderStatus }">
      <input type="hidden" name="searchOrderSeq" id="searchOrderSeq" value="${searchOrderSeq }">
      <input type="hidden" name="searchStartDate" id="searchStartDate" value="${searchStartDate }">
      <input type="hidden" name="searchEndDate" id="searchEndDate" value="${searchEndDate }">
      <input type="hidden" name="curPage" id="curPage" value="${curPage }">
   </form>

   <!-- Modal -->
   <div class="modal" id="orderModal"></div>


   <script>
       // 주문번호 클릭했을 때
        document.querySelectorAll('.order-link').forEach(link => {
           
            link.addEventListener('click', function(e) {
                e.preventDefault();
                const orderId = this.dataset.orderId;
                
                // 주문상세정보 AJAX 요청
                $.ajax ({
                type : "POST",
                url : "/admin/orderDetailModal",
                data : {
                   orderSeq : orderId
                },
                dataType : "JSON",
                beforeSend : function(xhr) {
                   xhr.setRequestHeader("AJAX", "true");
                },
                success : function(res) {
                   if (res.code == 0) {
                      
                      const order = res.data.order;
                      const orderDetailList = res.data.orderDetailList;
                      const deliveryInfo = res.data.deliveryInfo;
                      
                       console.log(orderDetailList); 
                        console.log(deliveryInfo);
                        console.log(order);
                      
                       let modalHtml = '';
                       
                       // 전화번호 포맷팅 함수
                       function formatPhoneNumber(phoneNumber) {
                           if (phoneNumber.length === 11) {
                               return phoneNumber.replace(/(\d{3})(\d{4})(\d{4})/, '$1-$2-$3');
                           } else if (phoneNumber.length === 10) {
                               return phoneNumber.replace(/(\d{2})(\d{3})(\d{4})/, '$1-$2-$3');
                           }
                           return phoneNumber;
                       }
                       

                       // 모달 헤더
                       modalHtml += '<div class="modal_content">';
                       modalHtml += '    <div class="modal_header">';
                       modalHtml += '        주문상세정보';
                       modalHtml += '        <span class="close_modal" id="closeModal">&times;</span>';
                       modalHtml += '    </div>';

                       // 모달 바디 - 주문 정보
                       modalHtml += '    <div class="modal_body">';
                       modalHtml += '        <div class="modal_section">';
                       modalHtml += '            <h3>주문 정보</h3>';
                       modalHtml += '            <p><strong>주문번호 : </strong> <span id="modalOrderId"><b>' + order.orderSeq + '</b></span></p>';
                       modalHtml += '           <p><strong>구매자ID : </strong> <span id="modalOrderId"><b>' + order.userId + '</b></span></p>';
                       modalHtml += '        </div>';

                       // 모달 바디 - 구매 제품 목록
                       modalHtml += '        <div class="modal_section">';
                       modalHtml += '            <h3>구매 제품 목록</h3>';
                       modalHtml += '            <ul class="product_list">';

                       // 반복문으로 제품 정보 추가
                      for (let i = 0; i < orderDetailList.length; i++) {
                          const od = orderDetailList[i];
                          modalHtml += '                <li class="product_item">';
                          modalHtml += '                    <strong>상품명 : </strong>'  + od.proName + '<br>';
                          modalHtml += '                    <strong>수량 : </strong>' + od.orderCnt + '개<br>';
                          modalHtml += '                    <strong>가격 : </strong>' + od.payPrice.toLocaleString() + '원';
                          modalHtml += '                </li>';
                      }

                       modalHtml += '            </ul>';
                       modalHtml += '        </div>';

                       // 모달 바디 - 배송 정보
                       modalHtml += '        <div class="modal_section">';
                       modalHtml += '            <h3>배송 정보</h3>';
                       modalHtml += '            <p><strong>받는 사람 : </strong>' + deliveryInfo.dlvName + '</p>';
                       modalHtml += '            <p><strong>연락처 : </strong>' + formatPhoneNumber(deliveryInfo.userPhone) + '</p>';
                       modalHtml += '            <p><strong>주소 : </strong>[' + deliveryInfo.addrCode + '] ' + deliveryInfo.addrBase + deliveryInfo.addrDetail + '</p>';
                       modalHtml += '            <p><strong>배송 메시지 : </strong>' + deliveryInfo.dlvRequest + '</p>';
                       modalHtml += '        </div>';

                       // 모달 바디 - 주문 상태
                        modalHtml += '        <div class="modal_section">';
                       modalHtml += '            <h3>주문 상태</h3>';
                       modalHtml += '            <select id="modalOrderStatus" class="styled-select"';
                       
                       if (["주문취소", "배송완료"].includes(order.viewStatus)) {
                           modalHtml += ' disabled'; // 조건에 따라 disabled 속성 추가
                       }
                       modalHtml += '>';
                      
                       
                       var statuses = [
                           { value: "1", text: "주문접수", key: "주문접수" },
                           { value: "2", text: "취소요청", key: "취소요청" },
                           { value: "3", text: "주문취소", key: "주문취소" },
                           { value: "4", text: "입금대기", key: "입금대기" },
                           { value: "5", text: "배송준비중", key: "배송준비중" },
                           { value: "6", text: "배송중", key: "배송중" },
                           { value: "7", text: "배송완료", key: "배송완료" },
                           { value: "8", text: "주문삭제", key: "주문삭제" },
                       ];

                       // 숨길 상태 설정
                       var hiddenStatuses = [];
                       if (order.viewStatus === "취소요청") {
                           // '취소요청' 상태일 때는 '취소요청'과 '주문취소'만 표시
                           hiddenStatuses = statuses.map(function(status) {
                               return status.key;
                           }).filter(function(key) {
                               return key !== "취소요청" && key !== "주문취소";
                           });
                       } else if (order.viewStatus === "입금대기") {
                           // '입금대기' 상태일 때는 '입금대기'와 '주문삭제'만 표시
                           hiddenStatuses = statuses.map(function(status) {
                               return status.key;
                           }).filter(function(key) {
                               return key !== "입금대기" && key !== "주문삭제";
                           });
                       } else {
                           // '취소요청' 상태가 아닐 때는 '취소요청' 옵션 숨김
                           hiddenStatuses = ["취소요청"];
                           if (order.viewStatus === "배송중") {
                               hiddenStatuses = hiddenStatuses.concat(["주문접수", "주문취소", "입금대기", "배송준비중"]);
                           } else if (order.viewStatus === "배송완료") {
                               hiddenStatuses = hiddenStatuses.concat(["주문접수", "주문취소", "입금대기", "배송준비중", "배송중"]);
                           }
                       }

                       // 옵션 생성
                       for (var i = 0; i < statuses.length; i++) {
                           var status = statuses[i];
                           if (hiddenStatuses.indexOf(status.key) === -1) {
                               modalHtml += '<option value="' + status.value + '"';
                               if (order.viewStatus === status.key) {
                                   modalHtml += ' selected';
                               }
                               modalHtml += '>' + status.text + '</option>';
                           }
                       }

                       modalHtml += '            </select>';
                       modalHtml += '        </div>';
                       modalHtml += '    </div>';



                       

                       
                       // 모달 푸터
                       modalHtml += '    <div class="modal_footer">';
                       modalHtml += '        <button id="saveBtn' + order.orderSeq + '" class="modal_button save" data-user-id="' + order.userId + '">저장</button>';
                       modalHtml += '        <button id="cancelChanges" class="modal_button cancel">취소</button>';
                       modalHtml += '    </div>';
                       modalHtml += '</div>';

                       // 모달에 내용 삽입
                       const modalElement = document.getElementById('orderModal');
                       modalElement.innerHTML = modalHtml;
                       
                       // 모달 열기
                       modalElement.style.display = 'flex';

                        // 닫기 이벤트 추가
                        document.getElementById('closeModal').addEventListener('click', function () {
                            modalElement.style.display = 'none';
                        });

                        document.getElementById('cancelChanges').addEventListener('click', function () {
                            modalElement.style.display = 'none';
                        });
                        
                        document.addEventListener('click', function(event) {
                            const modal = document.getElementById('orderModal');
                            if (event.target === modal) {
                                modal.style.display = 'none';
                            }
                        });
                      
                   }
                   else {
                      Swal.fire({
                            position: "center", 
                            icon: "warning",
                            title: "주문 정보를 불러오는 데 실패했습니다. 다시 시도해주세요.", 
                            showConfirmButton: false, 
                            timer: 1500 
                            });

                   }
                },
                error : function(xhr, status, error) {
                   icia.common.error(error);
                }
             });
                
            });
        });
       
       // 저장 버튼 클릭시
        $(document).on("click", "[id^=saveBtn]", function() {
          // 클릭된 모달의 주문번호 추출
          var orderSeq = $(this).attr("id").replace("saveBtn", "");
          var userId = $(this).data("user-id"); // userId 가져오기
          var modiOrderStatus = document.querySelector('#modalOrderStatus').value;
          
          console.log(orderSeq, modiOrderStatus, userId);
          
          // 1. 주문접수
          // 2. 취소요청      
          // 3. 주문취소      --> 카카오페이 AJAX 호출
          // 4. 입금대기      
          // 5. 배송준비       
          // 6. 배송중      
          // 7. 배송완료
          // 8. 주문삭제
          
          
          // 주문취소로 변경했을 경우
          if (modiOrderStatus == 3) {
             Swal.fire({
                  title: "[주문취소]로 상태를 변경하시면 사용자에게 금액이 바로 환불됩니다.\n변경하시겠습니까?",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonColor: "#3085d6",
                  cancelButtonColor: "#d33",
                  confirmButtonText: "삭제",
                cancelButtonText:"취소"
                }).then((result) => {
                  if (result.isConfirmed) {

                fn_payCancle(orderSeq, modiOrderStatus, userId);
                return;
                }
             });
          }

          
          // 배송중 상태로 변경했을 경우
          if (modiOrderStatus == 6) {
             Swal.fire({
                  title: "[배송중]으로 상태를 변경하시면 [배송완료] 이외의 상태변경이 불가능합니다..\n변경하시겠습니까?",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonColor: "#3085d6",
                  cancelButtonColor: "#d33",
                  confirmButtonText: "삭제",
                cancelButtonText:"취소"
                }).then((result) => {
                  if (result.isConfirmed) {
                fn_statusUpdate (orderSeq, modiOrderStatus);
                return;
                }
             });
          }
          
          // 배송완료 상태로 변경했을 경우
          if (modiOrderStatus == 7) {
             Swal.fire({
                  title: "[배송완료]로 상태를 변경하시면 더이상의 상태변경이 불가능합니다.\n변경하시겠습니까?",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonColor: "#3085d6",
                  cancelButtonColor: "#d33",
                  confirmButtonText: "삭제",
                cancelButtonText:"취소"
                }).then((result) => {
                  if (result.isConfirmed) {

                fn_statusUpdate (orderSeq, modiOrderStatus);
                return;
                }
             });
          }
          
          
          // 주문삭제 상태로 변경했을 경우
          if (modiOrderStatus == 8) {
             Swal.fire({
                  title: "[주문삭제]로 상태를 변경하시면 주문내역이 삭제됩니다.\n변경하시겠습니까?",
                  icon: "warning",
                  showCancelButton: true,
                  confirmButtonColor: "#3085d6",
                  cancelButtonColor: "#d33",
                  confirmButtonText: "삭제",
                cancelButtonText:"취소"
                }).then((result) => {
                  if (result.isConfirmed) {

                fn_orderDelete(orderSeq);
                return;
                }
             });
          }
          
          if (modiOrderStatus != 3 && modiOrderStatus != 6 && modiOrderStatus != 7 && modiOrderStatus != 8) {
             fn_statusUpdate (orderSeq, modiOrderStatus, userId);
          }

       }); 
       
       // 상태 변경
       function fn_statusUpdate (orderSeq, modiOrderStatus, userId) {
          
          // 주문상태 변경 AJAX
           $.ajax ({
               type : "POST",
               url : "/admin/orderStatusChange",
               data : {
                  orderSeq : orderSeq,
                  modiOrderStatus : modiOrderStatus,
                  userId : userId
               },
               dataType : "JSON",
               beforeSend : function(xhr) {
                  xhr.setRequestHeader("AJAX", "true");
               },
               success : function(res) {
                  if (res.code == 0) {
                     Swal.fire({
                        position: "center", 
                        icon: "success",
                        title: "주문상태가 변경되었습니다.",
                        showConfirmButton: false, 
                        timer: 1500 
                        }).then(function() {
                           // location.href = "/admin/orderMgr";
                           document.orderMgrForm.action = "/admin/orderMgr";
                           document.orderMgrForm.submit();
                        });

                  }
                  else {
                     Swal.fire({
                           position: "center", 
                           icon: "warning",
                           title: "처리 과정 중 오류가 발생하였습니다. 다시 시도해주세요.", 
                           showConfirmButton: false, 
                           timer: 1500 
                           });

                  }
               },
               error : function(xhr, status, error) {
                  icia.common.error(error);
               }
           }); 
          
       }
       
       
       // 결제 취소
       // fn_payCancle() -> fn_statusUpdate
       function fn_payCancle(orderSeq, modiOrderStatus, userId) {
          
          $.ajax ({
             type : "POST",
            url : "/order/kakaoPay/cancel",
            data : {
               orderSeq : orderSeq,
               userId : userId
            },
            dataType : "JSON",
            beforeSend:function(xhr)
              {
                  xhr.setRequestHeader("AJAX", "true");
              },
              success:function(res)
              {
                  if (res.code == 0) {
                     Swal.fire({
                        position: "center", 
                        title: res.msg, 
                        showConfirmButton: false, 
                        timer: 1500 
                        }).then(function() {
                           // location.href = "/admin/orderMgr";
                           document.orderMgrForm.action = "/admin/orderMgr";
                           document.orderMgrForm.submit();
                        });
                  }
                  else {
                     Swal.fire({
                        position: "center", 
                        title: res.msg, 
                        showConfirmButton: false, 
                        timer: 1500 
                        });

                  }
              },
              error:function(error)
              {
                  icia.common.error(error);
              }
          });

       }
       
       
       // 주문 삭제
       function fn_orderDelete (orderSeq) {
          $.ajax({
              type: "POST",
              url: "/order/orderDelete",
              contentType: "application/json",
              dataType: "JSON",
              data: JSON.stringify({ orderSeq: orderSeq }),
              success: function(res) {
                  if (res.code === 0) {
                     Swal.fire({
                        position: "center", 
                        icon: "success",
                        title: "주문이 삭제되었습니다.",
                        showConfirmButton: false, 
                        timer: 1500 
                        }).then(function() {
                            // location.href = "/admin/orderMgr";
                           document.orderMgrForm.action = "/admin/orderMgr";
                           document.orderMgrForm.submit();
                        });

                  } else {
                     Swal.fire({
                         position: "center", 
                         icon: "warning",
                         title: "오류가 발생하였습니다. 다시 시도해주세요!", 
                         showConfirmButton: false, 
                         timer: 1500 
                         });

                  }
              },
              error: function(xhr, status, error) {
                  console.error("Error: ", error);
                  Swal.fire({
                      position: "center", 
                      icon: "warning",
                      title: "오류가 발생하였습니다. 다시 시도해주세요!", 
                      showConfirmButton: false, 
                      timer: 1500 
                      });

              }
          });
       }

    </script>
    
    <form name="orderMgrForm" method="post">
       <input type="hidden" name="searchOrderStatus" value="${searchOrderStatus }">
       <input type="hidden" name="searchStartDate" value="${searchStartDate }">
       <input type="hidden" name="searchEndDate" value="${searchEndDate }">
       <input type="hidden" name="searchOrderSeq" value="${searchOrderSeq }">
    </form>
</body>
</html>
