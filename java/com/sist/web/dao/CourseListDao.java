package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.CourseList;
import com.sist.web.model.CourseListFile;

@Repository("courseListDao")
public interface CourseListDao {
	// 코스 공지 게시판 글 조회
	public List<CourseList> courseNoticeList(CourseList courseList);

	// 코스 공지 게시판 글 수 조회
	public long courseNoticeListCount(CourseList courseList);

	// 코스 공지 게시판 게시글 상세보기
	public CourseList courseNoticeView(CourseList courseList);

	// 코스 공지 게시판 조회수 증가
	public int courseNoticeReadCntPlus(long brdSeq);

	// 코스 공지 게시판 이전글 조회
	public CourseList courseNoticePrevView(CourseList courseList);

	// 코스 공지 게시판 다음글 조회
	public CourseList courseNoticeNextView(CourseList courseList);

	// 강사 페이지 강사별 공지 6개 조회
	public List<CourseList> teachNoticeRec(String teacherId);

	// 과목별 최신 공지 4개 조회
	public List<CourseList> classNotcieRec(int classCode);

	// 코스 공지 게시글 작성
	public int courseNoticeWrite(CourseList courseList);

	// 코스 공지 게시글 수정
	public int courseNoticeUpdate(CourseList courseList);

	// 코스 공지 게시글 삭제
	public int courseNoticeDelete(long brdSeq);

	// 코스 QnA 게시판 글 조회
	public List<CourseList> courseQnAList(CourseList courseList);

	// 코스 QnA 게시판 글 수 조회
	public long courseQnAListCount(CourseList courseList);

	// 코스 QnA 게시판 내가 쓴 글 조회
	public List<CourseList> courseQnAMyBrdList(CourseList courseList);

	/////////////////////////////////////////////////////////////////////////
	// 마이페이지 QnA 게시판 내가 쓴 글 조회
	public List<CourseList> courseMyPageQnaList(CourseList courseList);

	// 문의사항 답글 유무 확인
	public int countRepliesMyPageBrdSeq(long brdSeq);

	/////////////////////////////////////////////////////////////////////////
	// 코스 QnA 게시판 내가 쓴 글 개수 조회
	public long courseQnAMyBrdListCount(CourseList courseList);

	// 코스 QnA 게시판 게시글 상세보기
	public List<CourseList> courseNoticeQnAViewList(CourseList courseList);

	// 마이페이지 QnA 게시판 게시글 상세보기
	public int myPageQnACommentSelect(long brdSeq);

	// 코스 QnA 게시판 게시글 조회수 증가
	public int courseQnAReadCntPlus(long brdSeq);

	// 코스 QnA 게시판 글 등록
	public int courseQnAWrite(CourseList courseList);

	// 코스 QnA 게시판 파일 등록
	public int courseQnAFileInsert(CourseListFile courseListFile);

	// 코스 QnA 게시판 파일 조회
	public CourseListFile courseQnAFileSelect(long brdSeq);

	// 코스 QnA 게시글 1개 조회
	public CourseList courseQnASelect(long brdSeq);

	// 코스 QnA 게시글 첨부 파일 삭제
	public long courseQnAFileDelete(long brdSeq);

	// 코스 QnA 게시글 수정
	public int courseQnAUpdate(CourseList courseList);

	// 코스 QnA 게시글 삭제
	public int courseQnADelete(long brdSeq);

	// 코스 QnA 게시글 ORDER 업데이트
	public int courseQnAGroupOrderUpdate(CourseList courseList);

	// 코스 QnA 게시글 답변 등록
	public int courseQnAReplyInsert(CourseList courseList);

	// qna 개수
	public int courseQnAListCountM(CourseList courseList);

	// 코스 수강후기 게시판 글 조회
	public List<CourseList> courseReviewList(CourseList courseList);

	// 코스 수강후기 게시글 수 조회
	public long courseReviewListCount(CourseList courseList);

	// 코스 수강후기 게시글 상세조회
	public CourseList courseReviewView(long brdSeq);

	// 코스 수강후기 게시글 조회수 증가
	public int courseReviewReadCntPlus(long brdSeq);

	// 코스 수강후기 작성 여부 조회
	public int courseReviewWriteCheck(@Param("userId") String userId, @Param("courseCode") long courseCode);

	// 코스 수강후기 게시글 등록
	public int courseReviewInsert(CourseList courseList);

	// 코스 수강후기 게시글 수정
	public int courseReviewUpdate(CourseList courseList);

	// 코스 수강후기 게시글 삭제
	public int courseReviewDelete(long brdSeq);

	// 베스트 수강후기 3개 뽑기
	public List<CourseList> teachBestReview(String teacherId);

}
