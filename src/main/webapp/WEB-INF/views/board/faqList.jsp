<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<link href="/resources/css/main.css" rel="stylesheet">
<!-- Navigation CSS File -->
<link href="/resources/css/navigation.css" rel="stylesheet">
<link href="/resources/css/board/faqList.css" rel="stylesheet">
<style>
.header {
	background-color: #539ED8;
}
</style>
<script>
	$(function() {
		$("#navmenu>ul>li:nth-child(3)>a").addClass("active");
	});
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/include/navigation.jsp"%>

	<section class="notice-section">
		<div class="notice-content">
			<div class="notice-text">
				<h1 class="mainTitle">FAQ</h1>
				<p class="mainContent">자주 묻는 질문</p>
			</div>
			<div class="notice-image">
				<img src="/resources/img/faqboard.png" alt="Clover Image">
			</div>
		</div>
	</section>

	<section class="content-section">
		<div class="sidebar">
			<div class="exam-date" id="d-day-display">
				2026 수능 <span class="days"></span>
			</div>
			<ul class="menu">
				<li><a href="/board/noticeList">공지사항</a></li>
				<li><a href="/board/qnaList">문의사항</a></li>
				<li><a href="/board/freeList">자유게시판</a><br></li>
				<li><a href="/board/faqList" class="highlight">자주 묻는 질문</a></li>
			</ul>
		</div>
		<div class="table-container">
			<h2 class="subTitle">자주 묻는 질문</h2>

			<div class="freeboard-container">
				<div class="search-category">
					<div class="faqCategories">
						<button class="faqCategory-button" data-content="top10">
							<img alt="메달" src="/resources/img/medal.png"> <span>TOP 10</span>
						</button>
						<button class="faqCategory-button" data-content="userinfo">
							<img alt="사람" src="/resources/img/person.png"> <span>회원정보</span>
						</button>
						<button class="faqCategory-button" data-content="course">
							<img alt="모니터" src="/resources/img/monitor.png"> <span>강좌이용</span>
						</button>
						<button class="faqCategory-button" data-content="player">
							<img alt="플레이" src="/resources/img/play.png"> <span>학습플레이어</span>
						</button>
						<button class="faqCategory-button" data-content="download">
							<img alt="다운로드" src="/resources/img/download.png"> <span>강의 다운로드</span>
						</button>
						<button class="faqCategory-button" data-content="sos">
							<img alt="책" src="/resources/img/book.png"> <span>SOS교재</span>
						</button>
						<button class="faqCategory-button" data-content="admission">
							<img alt="학사모" src="/resources/img/mortarboard.png"> <span>입시정보</span>
						</button>
					</div>
				</div>
			</div>

			<div id="faq-content">
				<div id="top10" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>1년 이상 미접속자로 인해 탈퇴 처리가 되었어요. 재가입 할 수 있나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 1년 이상 미접속자 회원의 경우 아래와 같은 이유로 자동 탈퇴되며, 재가입시 아이디의 재사용은 불가하여 신규 회원가입이 필요합니다. * 관계 법령 개인정보 보호법 [시행 2020. 8. 5.] [법률 제16930호, 2020. 2. 4., 일부개정] 제21조(개인정보의 파기) ① 개인정보처리자는 보유기간의 경과, 개인정보의 처리 목적 달성 등 그 개인정보가 불필요하게 되었을 때에는 지체 없이 그 개인정보를 파기하여야 한다. 다만, 다른 법령에 따라 보존하여야 하는 경우에는 그러하지 아니하다. ② 개인정보처리자가 제1항에 따라 개인정보를 파기할 때에는 복구 또는 재생되지 아니하도록 조치하여야 한다. ③ 개인정보처리자가 제1항 단서에 따라 개인정보를 파기하지 아니하고 보존하여야 하는 경우에는 해당 개인정보 또는 개인정보파일을 다른 개인정보와 분리하여서 저장ㆍ관리하여야 한다. ④ 개인정보의 파기방법 및 절차 등에 필요한 사항은 대통령령으로 정한다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>동영상 소리가 들리지 않아요.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 동영상 실행 시 음성이 들리지 않으시는 경우 아래의 안내에 따른 확인을 부탁드립니다. 1. PC 사운드카드 문제 확인 가지고 계신 MP3파일이나 동영상 파일을 재생하여 PC 사운드에 문제가 없는지 확인해 주시기 바랍니다. 만일, 재생 시 소리가 나오지 않는다면 이용하시는 PC AS 센터로 문의해 주시기 바랍니다. 2. PC 마스터 볼륨 설정 확인 시작 >> 설정 >> 제어판 >> 사운드 및 오디오 장치 실행 장치 볼륨을 조정하여 확인 3. 강의를 재생하여 플레이어가 생성되면 플레이어 음소거 버튼을 여러 번 클릭하여 소리 설정을 확인해 주시기 바랍니다. 혹시라도 증상이 계속 발생하면, 고객센터로 유선 문의 부탁드립니다. [SOS 고객센터] 대표번호: 1205-1205 (내선1-1번)
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>MP3파일 다운로드는 어디서 이용하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 교재 MP3 다운로드는 아래의 경로를 통하여 이용이 가능합니다. 1. SOS HOME 접속 후, 상단의 [교재] 선택 2. 좌측 카테고리에서 [교재 자료실 > 영어 MP3 다운로드]선택
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>교재 구입은 어디서 하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 교재 구입은 아래의 경로를 통하여 이용이 가능합니다. 1. SOS HOME 접속 후, 상단의 [교재] 선택 2. 좌측 카테고리에서 [장바구니] 또는 [구입]선택
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>교재 파본 환불/교환은 어떻게 해야되나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 파본 교재는 1차적으로 구입하신 곳에서 교환해 드리고 있습니다. 번거로우시겠지만, 파본 교재를 구입한 서점을 통하여 문의해 주시기 바라며, 교재 이용에 불편함을 드려 대단히 죄송합니다. 구입하신 서점을 통해 교환이 어려울 경우 아래 고객센터로 직접 문의해 주시면 확인해 보도록 하겠습니다. [SOS 고객센터] 대표번호: 2024-1205 (내선1-1번)
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>모바일에서 SOS를 어떻게 이용할 수 있나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 현재 모바일은 지원하지 않습니다. 이용에 불편함을 드려 대단히 죄송합니다. 바른 시일내에 모바일 기능을 추가하겠습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>해피머니/도서상품권/문화상품권으로 결제가 가능한가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 구매 시 기타 상품권은 사용 불가합니다. 현재 아래 결제 수단으로 이용 가능합니다. 1. 신용카드(해외발급신용카드 가능) 2. 휴대폰 3. 카카오페이
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="userinfo" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>회원가입 중인데 인증번호가 오지 않습니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 회원가입 중인데 인증번호가 오지 않습니다. 1) 회원가입 시 팝업 차단이 되어 있는지 확인 부탁드립니다.(차단이 되어 있으면 문자인증 관련 팝업이 뜨지 않음) 2) 휴대폰 인증을 위한 휴대폰 문자발송은 1일 3회만 발송됩니다. 발송 건수 초과하셨는지 확인부탁드립니다. 3) 휴대폰에서 2024 문자 차단이 되어 있는지 확인바랍니다.(통신사로 확인요청) 4) 문자 인증이 안되실 경우 이메일 인증을 권장합니다. 5) 회원가입 진행 시 빨간색 메시지를 확인바랍니다. * 위 사항을 확인하셨는데도 계속된 오류 시 고객센터(2024-1205)으로 문의 부탁드립니다." [SOS 고객센터] 대표번호: 2024-1205 (내선1-1번)
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>SNS 연동 계정 비번을 분실하였습니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> SNS 연동 아이디는 해당 SNS 사이트에서 관리되고, SOS에서는 비밀번호가 저장되지 않으니, 해당 SNS를 통해 확인하시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>개인정보 보유기간은 언제까지인가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 부가정보를 포함한 모든 수집항목의 보유기간은 회원탈퇴 시까지이며, 개인정보처리방침에 따라 안전하게 보호되며, 회원님의 명백한 동의 없이 공개 또는 제 3자에게 제공되지 않습니다. * 단 이벤트를 포함한 특정서비스의 경우 개인정보는 이벤트의 목적달성시 즉시 파기됩니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>회원 가입을 한 개인정보는 안전하게 보호되나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 모든 회원정보는 정책에 의하여 보관되며 절대 다른 곳으로 유출되지 않습니다. 또한, 회원님의 사이트 이용 목적 이외의 다른 목적으로 사용되지 않습니다. 회원가입 시 또는 사이트 이용 중에 회원님께서 입력하신 모든 정보는 "정보통신망이용촉진 및 정보보호 등에 관한 법률"을 준수하여 안전하게 관리됩니다. SOS 사이트는 안전한 회원정보 관리를 위해 항상 노력하고 있습니다. * 회원 본인의 잘못으로 인한 개인정보의 유출 및 이용은 저희가 책임을 지지 않으니 회원 본인 스스로 개인정보보호에 주의하셔야 합니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>아이디(ID)를 변경하고 싶은데 가능한가요</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 한번 가입된 아이디(ID)는 변경이 불가능합니다. 이에 아이디(ID)를 변경하시려면 EBS 인터넷 사이트의 회원 탈퇴 후 다시 [회원 가입] 을 하셔야 합니다. 또한 한번 탈퇴된 아이디는 재사용이 불가능하오니, 신중한 결정 후 진행해 주시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>1년 이상 미접속자로 인해 탈퇴 처리가 되었어요. 재가입 할 수 있나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 1년 이상 미접속자 회원의 경우 개인정보 보호법과 같은 이유로 자동 탈퇴되며, 재가입시 아이디의 재사용은 불가하여 신규 회원가입이 필요합니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>탈퇴는 어떻게 하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 회원 탈퇴 방법은 아래와 같습니다. 1.SOS 홈페이지 로그인 2.상단에 [마이페이지] 클릭하기 3.[회원탈퇴] 클릭하기
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="course" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>기능이 오류가 나거나 동작을 안해서, 이용을 할 수가 없습니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 사용하시는 웹 브라우저의 임시파일(캐시)를 삭제하고, 웹 브라우저를 닫았다가 재실행 부탁드립니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>다운로드 받은 자료 내용이 보이지 않아요.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 자료실 페이지에서 필요하신 자료를 다운로드 하여 이용시 자료의 내용이 보이지 않는 경우에는 해당 자료를 읽을 수 있는 프로그램이 설치되어 있는지 확인해 주시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>지난 연도 강좌는 어떻게 이용하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 강좌명을 알고 있다면 통합검색을 이용하여 찾으실 수 있으며, 그 밖에도 강좌카테고리 경로를 통해 지난 년도 강좌를 이용하실 수 있습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>강의를 들었는데 학습완료가 되지 않습니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 강의 학습완료 기준을 안내드립니다. 1. 강의 다운로드 이용 – 즉시 학습완료 2. 강의 스트리밍 이용 – 강의 시간의 50% 이상 학습 시 학습완료 ※ 2배속으로 강의 수강시, 건너뛰기를 한번이라도 하시면, 학습완료가 되지 않습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>Q&A 질문하기 버튼이 없습니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 서비스 질 향상과 신속한 답변을 위하여 1. 같은 시리즈의 신규 강좌가 오픈(오픈 예정 포함)한 경우 과년도 강좌 Q&A 게시판 2. 교육과정에 맞지 않은 강좌 Q&A 게시판 3. 과년도 학모평 강좌 Q&A 게시판 위의 내용을 비롯하여 일부 강좌는 학습 Q&A 를 제공하지 않습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>학습에 관련된 상담은 어느 경로를 통해서 하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 강의내용이나 교재에 나와있는 학습 내용 관련 질문사항은 해당 강좌내에 학습Q&A 게시판을 이용하여 질의응답 서비스를 받으실 수 있습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>수강중인 강좌 수강취소는 어떻게 하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 현재 수강중인 강좌 수강취소는 [마이페이지] 를 통해 직접 취소가 가능합니다.
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="player" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>강의 학습완료 기준이 무엇인가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 학습완료의 기준은, VOD로 50% 이상 학습하거나, 다운로드하여 학습완료한 상태입니다. *2배속 이상으로 학습하실 경우 강의 시간이 충족되지 않아 '학습완료'가 되지 않을 수 있습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>학습 플레이어 실행시 SOS 로고가 나옵니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 학습 플레이어 실행 시 EBSi로고만 확인되는 경우, 음성 출력 장치가 정상적으로 실행되지 않을 때 발생할 수 있습니다. PC 우측 하단 트레이영역에 위치한 볼륨 설정이 음소거로 적용되어 있을 경우 음소거를 해지하여 다시 확인하거나 스피커 및 이어폰 등 음성 출력 장치 연결도 함께 확인 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>화면과 소리가 일치하지 않는 끊김이 발생합니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> SOS에서 동영상 강의가 끊기거나 소리와 영상이 불일치 되는 등 정상적인 이용이 어려운 경우 PC 최소 사양, Windows Update를 확인해 주시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>최소 사양은 어떻게 되나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> CPU : 인텔 i3 혹은 AMD 라이젠3 이상(이와 유사한 성능을 가진 CPU) VG A: 64MB 이상의 NVidia 또는 동급의 그래픽 카드 OS : windows 7이상 /macOS 10.12 이상(Sierra) RAM : 4GByte 이상
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>동영상 소리가 들리지 않아요.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 동영상 실행 시 음성이 들리지 않으시는 경우 아래의 안내에 따른 확인을 부탁드립니다. 1. PC 사운드카드 문제 확인 2. PC 마스터 볼륨 설정 확인 3. 강의를 재생하여 플레이어가 생성되면 플레이어 음소거 버튼을 여러 번 클릭하여 소리 설정을 확인해 주시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="download" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>다운로더 창에 아무것도 뜨지 않아요.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 다운로더 창에 다운로드 목록이 보이지 않는 경우 아래 두가지 방법으로 해결할 수 있습니다. 방법(1) Interner Explorer의 설정을 초기화 할 수 있습니다. 시작 돋보기 → '인터넷'검색 → 인터넷 속성 창에서 '고급'→ '원래대로' → '확인' 후 재부팅 방법(2) Internet Explorer앱이 삭제된 경우 추가할 수 있습니다. 시작 버튼에 우측 마우스 클릭 → 앱 및 기능→ 선택적 기능 → 기능 추가에 'Internet Explorer'를 추가 후 재부팅
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>강의 다운로드 체크 박스가 확인되지 않아요</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 다운로드 체크 박스가 확인되지 않는 경우는 아래와 같습니다. 1. 해당 강좌를 수강신청하지 않은 상태(수강신청 후 다운로드 이용 가능) 2. 저작권 문제로 다운로드 서비스를 제공하지 않는 일부 강좌에 해당하는 경우
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>다운로더 프로그램 설치는 어떻게 하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 1. 수강중인 강좌의 강의목록에서 체크박스 선택 > 목록 상단의 [다운로드] 버튼 클릭 2. 레이어 팝업에서 [다운로더 설치] 버튼 클릭 > 파일 설치 진행 3. "이 앱이 디바이스를 변경할 수 있도록 허용하시겠어요?"에서 [예] 버튼 클릭 4. EBS Downloader 설치 폴더 경로 확인 후 [설치] 버튼 클릭 5. EBS Downloader 설치 완료 [닫음] 클릭
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>다운로더 설치 시 Internet Explorer가 종료됩니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 신규 다운로더 프로그램 설치 시 Internet Explorer 브라우저가 강제로 종료되는 경우 아래 안내에 따라 관련 프로그램 삭제 후 다시 확인해 보시기 바랍니다. ■ 신규 다운로더 프로그램 삭제 ■ 바이러스 및 악성코드 감염 여부 확인
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>지정된 경로를 찾을 수 없습니다.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 다운로드 시 'Cannot Create file ~. 지정된 경로를 찾을 수 없습니다' 또는 '접근 권한이 없거나 다운로드 경로가 잘못되었습니다.' 오류가 발생될 경우, 삼성 노트북 또는 넷북에 기본 설치되어 있는 Software Launcher 프로그램에 있는 internet Explorer(권한 문제) 실행으로 발생한 문제로 확인됩니다. 번거로우시더라도 윈도우에서 제공하는 internet Explorer로 실행 시 정상으로 다운로드 가능하오니 참고 바랍니다.
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="sos" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>해피머니/도서상품권/문화상품권으로 결제가 가능한가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 구매 시 기타 상품권은 사용 불가합니다. 현재 아래 결제 수단으로 이용 가능합니다. 1. 신용카드(해외발급신용카드 가능) 2. 휴대폰 3. 카카오페이
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>아직 사용 전인데 환불 가능한가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> [환불신청]의 경우, 개봉 및 사용전인 상태에 한 해 환불이 가능합니다. 결제 취소 및 환불은 환불 신청 접수 후 처리까지 최대 7일이 소요될 수 있습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>신용카드로 결제 후 취소했는데 이번 달 청구서에 금액이 청구되었어요.</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 승인 취소는 접수되었으나 카드사에서 처리가 되기 전 청구서가 작성된 경우입니다. 해당 금액은 실제 인출 시에는 제외됩니다. 혹시라도 이미 금액이 인출된 후 승인 취소가 완료될 경우에는 다음 달 청구서에 해당 금액만큼 마이너스(-) 청구 방식으로 반영됩니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>구매한 책의 영수증을 받고 싶어요</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 결제 내역에 대한 영수증은 결제 내역의 주문번호 선택 후 결제 상세 내역 하단 [영수증출력] 버튼을 이용하여 주시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>환불 내역은 어디에서 확인할 수 있나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> [환불신청]의 경우, 개봉 및 사용전인 상태에 한 해 환불이 가능합니다. [마이페이지]에서 확인할 수 있습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>환불 완료까지 시간은 며칠 정도 걸리나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 결제 취소 및 환불은 환불 신청 접수 후 처리까지 최대 7일이 소요될 수 있습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>인터넷 연결 없이도 사용할 수 있나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 열람과 나만의 학습노트, 학습계획표 기능은 오프라인에서도 언제든지 사용할 수 있습니다. (단, 최종 온라인 상태에서 로그인 상태를 유지 필수)
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div id="admission" class="faq-detail">
					<table>
						<thead>
							<tr>
								<th>질문</th>
								<th>제목</th>
							</tr>
						</thead>
						<tbody>
							<tr class="table-row">
								<td>Q .</td>
								<td>지난 풀서비스 어디서 확인하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 지난 수능 및 학모평 시험의 문제/정답/해설 다운로드, 해설강의, 시험지 응시하기는 기출문제 메뉴에서 확인 가능합니다. 지난 수능 및 학모평 시험의 오답률, 등급컷은 풀서비스 메뉴의 역대 등급컷/오답률에서 확인 가능합니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>수능/학모지 문제, 정답지, 해설지 다운로드 언제 가능한가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 각 시/도 교육청에서 주관하는 학력평가의 경우, 시험이 종료된 이후 문제, 정답, 해설지가 탑재됩니다. 평가원에서 주관하는 모의평가 및 수능의 경우,평가원에서 과목별 문제, 정답, 해설지가 공개된 후 탑재됩니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>표준점수란 무엇인가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 표준점수는 수험생의 능력이나 특성이 정규분포를 이룬다는 가정 하에 수험생의 원점수에 해당하는 하는 상대적 서열을 나타내는 점수입니다. 언어·수리·외국어(영어) 영역은 평균이 100점, 표준편차가 20점인 분포로, 탐구영역은 각 과목 평균이 50점이고 표준편차가 10점인 분포로 바뀝니다. 이는 시험의 난이도(평균과 표준편차)를 고려해 계산되는 수치로, 수험생 개개인이 평균점수로부터 얼마나 떨어져 있는지 알 수 있는 기준입니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>모집요강 검색의 검색결과가 실제 모집요강과 다릅니다. 왜 그런가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> 모집요강 및 전형계획 검색은 연초에 발표되는 한국대학교육협의회의 대학입학 전형계획 주요사항과 대학별 모집요강을 참고로 데이터가 구축됩니다. 그런데 데이터 구축 이후에도 각 대학별 전형 방법이 달라지는 경우가 자주 있어 처음 입력한 내용이 나중에는 틀린 것이 되는 경우가 발생 합니다. 특히 전형계획의 경우 수시2나 정시에 가서는 큰 틀까지 바뀌는 경우가 발생하기도 합니다. 혹여 대학에서 발표한 최신 모집요강과 저희 EBSi 모집요강 검색 결과가 서로 일치하지 않는 경우 오류수정신고를 통하여 알려주시면 신속히 확인하여 정정 하겠습니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>표준점수와 백분위 산출 방법은 무엇인가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> ■ 표준점수 산출 방법 언어, 수리, 외국어영역의 표준점수 = [(자신의 원점수 - 전체 평균점수) / 표준편차 × 20] 100 탐구영역, 제2외국어 / 한문의 표준점수 = [(자신의 원점수 - 전체 평균점수) / 표준편차 × 10] 50 대학수학능력시험 성적표에는 위에서 산출된 표준점수를 소수 첫째자리에서 반올림하여 정수로 제공하고 있습니다. ■ 백분위점수 산출 방법 백분위점수 = {(수험생의 표준점수보다 표준점수가 낮은 수험생의 수) (동점자수) ÷ 2 / 해당 영역 과목의 수험생수 )}×100
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>SOS에서 제공하는 입시자료는 가장 최신의 정확한 정보 자료인가요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> SOS에서 제공해 드리는 입시 관련 자료는 매일 주요 뉴스, 대학 홈페이지,교육기관 홈페이지 등에 등록된 중요 내용을 선별하여 업데이트 합니다. 늘 최신의 정확한 정보를 제공해 드리고자 노력하고 있으나 각 대학별 모집 요강 상세 내용 등은 수시로 변경될 수 있으므로 목표하시는 대학의 모집요강은 반드시 관련 대학 홈페이지에서 최종 확인해 주시기 바랍니다.
										</p>
									</div>
								</td>
							</tr>
							<tr class="table-row">
								<td>Q .</td>
								<td>오프라인 입시설명회 어떻게 신청하나요?</td>
							</tr>
							<tr class="answer-row">
								<td colspan="2">
									<div class="answer-content">
										<p>
											<span class="answer-heading">A.</span> SOS는 학생들에게 대입정보, 학습법 등을 제공하기 위해 여러 지역을 방문하여 설명회를 개최하고 있습니다. 각 교육청마다 다르지만 오프라인에서 실시하는 설명회의 경우, 통상적으로 별도의 신청없이 행사장으로 오시면 설명회 참석이 가능합니다. 각 교육청마다 상이할 수 있으니 자세한 사항은 지역 교육청에 문의바랍니다.
										</p>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>


		</div>
	</section>

	<script>
    // 페이지 로드 시, 첫 번째 버튼에 'active' 클래스 추가
    document.addEventListener('DOMContentLoaded', function() {
        const firstButton = document.querySelector('.faqCategory-button');
        if (firstButton) {
            firstButton.classList.add('active');
            // 첫 번째 버튼에 해당하는 콘텐츠 표시
            const contentId = firstButton.getAttribute('data-content');
            document.getElementById(contentId).style.display = 'block';
            
            // 첫 번째 버튼의 글자와 이미지를 흰색으로 변경
            const span = firstButton.querySelector('span');
            if (span) {
                span.style.color = 'white';  // 글자 색을 흰색으로 변경
            }
            const image = firstButton.querySelector('img');
            if (image) {
                image.style.filter = 'brightness(0) invert(1)';  // 이미지 흰색으로 변경
            }
        }
    });

    // 카테고리 클릭 시
    document.querySelectorAll('.faqCategory-button').forEach(button => {
        button.addEventListener('click', function() {
            // 모든 버튼에서 'active' 클래스 제거 및 기본 스타일로 복원
            document.querySelectorAll('.faqCategory-button').forEach(b => {
                b.classList.remove('active');
                const span = b.querySelector('span');
                if (span) {
                    span.style.color = '';  // 기본 글자 색으로 복원
                }
                const img = b.querySelector('img');
                if (img) {
                    img.style.filter = '';  // 기본 이미지 색상으로 복원
                }
            });

            // 클릭된 버튼에 'active' 클래스 추가
            this.classList.add('active');
            // 클릭된 버튼의 글자와 이미지를 흰색으로 변경
            const span = this.querySelector('span');
            if (span) {
                span.style.color = 'white';  // 글자 색을 흰색으로 변경
            }
            const image = this.querySelector('img');
            if (image) {
                image.style.filter = 'brightness(0) invert(1)';  // 이미지 흰색으로 변경
            }

            // 모든 콘텐츠 숨기기
            document.querySelectorAll('.faq-detail').forEach(content => content.style.display = 'none');

            // 클릭된 버튼에 해당하는 콘텐츠 표시
            const contentId = this.getAttribute('data-content');
            document.getElementById(contentId).style.display = 'block';
        });
    });

    // 답변 행 클릭 시
    document.querySelectorAll('.table-row').forEach(row => {
        row.addEventListener('click', function() {
            const answerRow = this.nextElementSibling;
            const isVisible = answerRow.style.display === 'table-row'; 

            // 모든 답변 행 숨기기
            document.querySelectorAll('.answer-row').forEach(r => r.style.display = 'none');

            // 클릭한 행의 답변만 보이도록 토글
            if (!isVisible) {
                answerRow.style.display = 'table-row';
            }
        });
    });
</script>


<%@ include file="/WEB-INF/views/include/footfooter.jsp"%>
</body>
</html>
