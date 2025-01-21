<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<%@ include file="/WEB-INF/views/include/head.jsp"%>
<style>
body {
	display: flex;
	justify-content: center;
	height: 100vh;
	margin: 0;
	background-color: #000;
}

video {
	max-width: 100%;
	max-height: 100%;
}
</style>
</head>
<body>
	<!-- 동영상 플레이어 -->
	<video id="videoPlayer" controls autoplay>
		<source id="videoSource" type="video/mp4">
	</video>

	<script>
		// URL에서 파일명을 가져옴
		const params = new URLSearchParams(window.location.search);
		const fileName = params.get('fileName');

		// 동영상 경로 설정
		const videoPath = '/resources/video/lecture/' + fileName + '.mp4';
		const videoSource = document.getElementById('videoSource');
		videoSource.src = videoPath;

		// 플레이어 로드
		const videoPlayer = document.getElementById('videoPlayer');
		videoPlayer.load();
		
		// 서버에서 전달된 시청 시간 값
	    let currentTime = ${lecture.currentTime != null ? lecture.currentTime : 0};

	    if(currentTime > 0) {
	    	videoPlayer.pause();

	    	console.log("Swal.fire 호출됨");
			Swal.fire({
		        title: "마지막으로 시청했던 시간부터 재생하시겠습니까?",
		        icon: "warning",
		        showCancelButton: true,
		        confirmButtonColor: "#3085d6",
		        cancelButtonColor: "#d33",
		        confirmButtonText: "확인",
		        cancelButtonText: "돌아가기"
		    }).then((result) => {
		    	console.log("Swal 결과:", result);
		        if (!result.isConfirmed) {
		        	videoPlayer.currentTime = 0;
		        	console.log("isConfirmed가 false입니다. currentTime을 초기화합니다.");
		        }

				videoPlayer.play();
		    });
	    }
	    
		videoPlayer.currentTime = currentTime;

		// 일정 간격으로 시청 시간 서버에 전송
		const sendWatchTime = () => {
			const currentTime = videoPlayer.currentTime; // 현재 시청 시간 (초)
			const videoDuration = videoPlayer.duration; // 동영상 전체 길이 (초)

			fetch('/course/saveWatchTime', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/json'
				},
				body: JSON.stringify({
					fileName: fileName,
					currentTime: currentTime,
					duration: videoDuration
				})
			}).then(response => {
				if (!response.ok) {
					console.error('Watch time update failed:', response.statusText);
				}
			}).catch(error => {
				console.error('Error while sending watch time:', error);
			});
		};

		// 일정 간격마다 서버로 시청 시간 전송
		setInterval(sendWatchTime, 3000);
	</script>
</body>
</html>
