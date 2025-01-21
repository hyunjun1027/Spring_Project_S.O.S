<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/admin/adminHead.jsp"%>
<link href="/resources/css/admin/index.css" rel="stylesheet">
</head>
<body>
<%@ include file="/WEB-INF/views/include/admin/nav.jsp"%>
    <div class="content">
        <div class="table-section">
            <div class="table-section-header">
                <h4>전체 주문통계</h4>
                <a href="/admin/orderMgr" class="btn">주문관리 바로가기</a>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>${currentMonth }월 주문현황</th>
                        <th>주문상태 현황</th>
                        <th>구매확정/클래임 현황</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                        	<table>
                        		<thead>
                        			<tr>
                        				<th>총 주문건수</th>
                        				<th>총 주문액</th>
                        			</tr>
                        		</thead>
                        		<tbody>
                        			<tr>
                        				<td>${monthOrderCnt }건</td>
                        				<td><fmt:formatNumber value="${monthOrderPrice}" type="number" />원</td>
                        			</tr>
                        		</tbody>
                        	</table>
                        </td>
                        <td>
                        	<table>
                        		<thead>
                        			<tr>
                        				<th>입금대기</th>
                        				<th>주문접수</th>
                        				<th>배송준비중</th>
                        				<th>배송중</th>
                        				<th>배송완료</th>
                        			</tr>
                        		</thead>
                        		<tbody>
                        			<tr>
                        				<td>${waitPay }</td>
                        				<td>${comPay }</td>
                        				<td>${waitDeli }</td>
                        				<td>${ingDeli }</td>
                        				<td>${comDeli }</td>
                        			</tr>
                        		</tbody>
                        	</table>
                        </td>
                        <td>
                        	<table>
                        		<thead>
                        			<tr>
                        				<th>취소요청</th>
                        				<th>취소완료</th>
                        			</tr>
                        		</thead>
                        		<tbody>
                        			<tr>
                        				<td>${appCancle }</td>
                        				<td>${comCancle }</td>
                        			</tr>
                        		</tbody>
                        	</table>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

		<div class="allChart">
			<div class="chart">
		        <div class="header">
					<h4>최근 6개월 주문내역</h4>
		        </div>
		        <div class="chartBox">
		    		<canvas id="myLineChart" class="line"></canvas>
		    	</div>
	    	</div>
			<div class="dounut">
				<div class="header">
					<h4>전체 과목별 코스 수강생</h4>
				</div>
				<div class="chartBox">
			    	<canvas id="myDoughnutChart" class="doughnut"></canvas> 
			    </div>
		    </div>
		</div>
		    	 
        <div class="table-section-header">
			<h4>최근 회원가입</h4>
			<a href="/admin/userMgr" class="btn">회원관리 바로가기</a>
        </div>
        <div class="table-scroll-container">
            <table>
                <thead>
                    <tr>
                        <th width="50%">아이디</th>
                        <th width="15%">이메일</th>
                        <th width="10%">이름</th>
                        <th width="10%">분류</th>
                        <th width="15%">가입일시</th>
                    </tr>
                </thead>
                <tbody>
                <c:if test="${!empty list}">
                	<c:forEach var="user" items="${list}" varStatus="status">
                		<tr>
	                		<td>${user.userId}</td>
	                		<td>${user.userEmail}</td>
	                		<td>${user.userName}</td>
	                <c:if test="${user.rating eq 'T'}">
	                	<td>강사</td>
	                </c:if>
	                <c:if test="${user.rating eq 'U'}">
	                	<td>학생</td>
	                </c:if>
	                		<td>${user.regDate}</td>
	                	</tr>
                	</c:forEach>
                </c:if>
                </tbody>
            </table>
		</div>
	</div>
	
	<script>
	// 주문량
	var orderCountList = ${orderCountList};

	// 월 변경
	var currentMonth = new Date().getMonth() + 1;
	var labels = [];
	for (var i = 5; i >= 0; i--) {
	    var month = (currentMonth - 1 - i + 12) % 12 + 1;
	    labels.push(month + '월');
	}

	// 차트 생성
	var ctx = document.getElementById('myLineChart').getContext('2d'); 

	// 그라데이션 효과 추가
	var gradient = ctx.createLinearGradient(0, 0, 0, 400);
	gradient.addColorStop(0, 'rgba(75,192,192,1)');
	gradient.addColorStop(1, 'rgba(75,192,192,0.1)');

	var myLineChart = new Chart(ctx, {
	    type: 'line',
	    data: {
	        labels: labels, // X축
	        datasets: [{
	            label: '주문량',
	            data: orderCountList, // Y축
	            fill: true,  // 영역 색상 채우기
	            backgroundColor: gradient, // 그라데이션 효과
	            borderColor: 'rgba(75,192,192,1)', // 선 색상
	            borderWidth: 2, // 선 두께
	            tension: 0.4,  // 곡선 부드러움
	            pointBackgroundColor: 'white', // 데이터 포인트 색상
	            pointBorderColor: 'rgba(75,192,192,1)', // 데이터 포인트 테두리
	            pointRadius: 5, // 데이터 포인트 크기
	            pointHoverRadius: 7, // 데이터 포인트 호버 크기
	        }]
	    },
	    options: {
	        responsive: true,  // 반응형
	        plugins: {
	            legend: {
	                position: 'top', // 범례 위치
	                labels: {
	                    color: '#333', // 범례 글자 색상
	                    font: {
	                        size: 14 // 범례 글자 크기
	                    }
	                }
	            },
	            tooltip: {
	                backgroundColor: 'rgba(0, 0, 0, 0.7)', // 툴팁 배경색
	                titleColor: 'white', // 툴팁 제목 색상
	                bodyColor: 'white', // 툴팁 내용 색상
	                titleFont: {
	                    size: 14 // 툴팁 제목 글자 크기
	                },
	                bodyFont: {
	                    size: 12 // 툴팁 내용 글자 크기
	                },
	                padding: 10, // 툴팁 패딩
	            },
	        },
	        scales: {
	            x: {
	                grid: {
	                    display: false // X축 그리드 숨김
	                },
	                ticks: {
	                    color: '#555', // X축 글자 색상
	                    font: {
	                        size: 12 // X축 글자 크기
	                    }
	                }
	            },
	            y: {
	                beginAtZero: true, // y축 최소값을 0으로 설정
	                grid: {
	                    color: 'rgba(200, 200, 200, 0.5)', // Y축 그리드 색상
	                    lineWidth: 1 // Y축 그리드 두께
	                },
	                ticks: {
	                    color: '#555', // Y축 글자 색상
	                    font: {
	                        size: 12 // Y축 글자 크기
	                    }
	                }
	            }
	        },
	        animation: {
	            duration: 1000, // 애니메이션 지속 시간
	            easing: 'easeOutBounce' // 애니메이션 효과
	        }
	    }
	});

        
	// 코스별 수강
	var courseCountList = ${courseCountList};

	// 차트 캔버스
	var ctx = document.getElementById('myDoughnutChart').getContext('2d');

	// 그라데이션 생성 (동적 컬러)
	var gradientPink = ctx.createLinearGradient(0, 0, 0, 400);
	gradientPink.addColorStop(0, 'rgba(255, 99, 132, 1)');
	gradientPink.addColorStop(1, 'rgba(255, 159, 192, 0.5)');

	var gradientBlue = ctx.createLinearGradient(0, 0, 0, 400);
	gradientBlue.addColorStop(0, 'rgba(54, 162, 235, 1)');
	gradientBlue.addColorStop(1, 'rgba(54, 162, 235, 0.5)');

	var gradientYellow = ctx.createLinearGradient(0, 0, 0, 400);
	gradientYellow.addColorStop(0, 'rgba(255, 206, 86, 1)');
	gradientYellow.addColorStop(1, 'rgba(255, 206, 86, 0.5)');

	var gradientTeal = ctx.createLinearGradient(0, 0, 0, 400);
	gradientTeal.addColorStop(0, 'rgba(75, 192, 192, 1)');
	gradientTeal.addColorStop(1, 'rgba(75, 192, 192, 0.5)');

	var gradientPurple = ctx.createLinearGradient(0, 0, 0, 400);
	gradientPurple.addColorStop(0, 'rgba(153, 102, 255, 1)');
	gradientPurple.addColorStop(1, 'rgba(153, 102, 255, 0.5)');

	// 도넛 차트
	var myDoughnutChart = new Chart(ctx, {
	    type: 'doughnut',
	    data: {
	        labels: ['국어', '영어', '수학', '사회', '과학'], // X축 레이블
	        datasets: [{
	            label: '코스 신청량',
	            data: courseCountList, // Y축 데이터
	            backgroundColor: [
	                gradientPink, // 국어
	                gradientBlue, // 영어
	                gradientYellow, // 수학
	                gradientTeal, // 사회
	                gradientPurple // 과학
	            ],
	            hoverOffset: 10, // 호버 시 돌출 효과
	            borderWidth: 3, // 경계선 두께
	            borderColor: '#fff' // 경계선 색상
	        }]
	    },
	    options: {
	        responsive: true,
	        plugins: {
	            legend: {
	                position: 'right', // 범례를 오른쪽으로 이동
	                labels: {
	                    color: '#444', // 범례 글자 색상
	                    font: {
	                        size: 14, // 범례 글자 크기
	                        weight: 'bold', // 글자 굵기
	                        family: 'Helvetica, Arial, sans-serif' // 범례 글꼴
	                    },
	                    padding: 20 // 범례 항목 간격
	                }
	            },
	            tooltip: {
	                backgroundColor: 'rgba(0, 0, 0, 0.9)', // 툴팁 배경
	                titleColor: '#fff', // 툴팁 제목 색상
	                bodyColor: '#fff', // 툴팁 내용 색상
	                bodyFont: {
	                    size: 14, // 툴팁 글자 크기
	                    weight: 'bold' // 툴팁 글자 굵기
	                },
	                padding: 15, // 툴팁 패딩
	                cornerRadius: 10, // 툴팁 모서리 곡선
	                caretSize: 8 // 툴팁 화살표 크기
	            }
	        },
	        cutout: '60%', // 도넛 구멍 크기
	        animation: {
	            animateRotate: true, // 회전 애니메이션
	            animateScale: true, // 크기 애니메이션
	            duration: 1500, // 애니메이션 지속 시간
	            easing: 'easeInOutQuint' // 애니메이션 속도 곡선
	        },
	        layout: {
	            padding: {
	                top: 20,
	                bottom: 20,
	                left: 20,
	                right: 20
	            }
	        }
	    }
	});


    </script>
</body>
</html>
