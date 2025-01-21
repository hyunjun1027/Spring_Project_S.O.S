package com.sist.web.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardLike;
import com.sist.web.model.BoardMark;
import com.sist.web.model.BoardNotice;
import com.sist.web.model.BoardNoticeFile;
import com.sist.web.model.BoardQna;
import com.sist.web.model.BoardQnaFile;

@Repository("boardDao")
public interface BoardDao {
//////////////////////////////////////////////////공지사항(시작)/////////////////////////////////////////////////
	// 공지사항 게시물 등록
	public int noticeBoardInsert(BoardNotice boardNotice);

	// 공지사항 첨부파일 등록
	public int noticeBoardFileInsert(BoardNoticeFile boardNoticeFile);

	// 공지사항 게시물 리스트
	public List<BoardNotice> noticeBoardList(BoardNotice boardNotice);

	// 공지사항 총 게시물 수
	public long noticeBoardListCount(BoardNotice boardNotice);
	
	// 공지사항 삭제된 게시물 리스트
	public List<BoardNotice> noticeDelBoardList(BoardNotice boardNotice);
	
	// 공지사항 삭제된 총 게시물 수
	public long noticeDelBoardListCount(BoardNotice boardNotice);

	// 공지사항 게시물 조회
	public BoardNotice noticeBoardSelect(long brdSeq);

	// 공지사항 게시물 첨부파일 조회
	public BoardNoticeFile noticeBoardFileSelect(long brdSeq);

	// 공지사항 게시물 조회수 증가
	public int noticeReadCntPlus(long brdSeq);

	// 공지사항 게시물 삭제
	public int noticeBoardDelete(BoardNotice boardNotice);
	
	// 공지사항 게시물 완전 삭제
	public int noticeRealBoardDelete(long brdSeq);
	
	// 공지사항 게시물 첨부파일 완전 삭제
	public int noticeRealBoardFileDelete(long brdSeq);

	// 공지사항 게시물 수정
	public int noticeBoardUpdate(BoardNotice boardNotice);

	// 공지사항 게시물 첨부파일 삭제
	public int noticeBoardFileDelete(long brdSeq);

	// 이전글 조회
	public BoardNotice getPrevNotice(long brdSeq);

	// 다음글 조회
	public BoardNotice getNextNotice(long brdSeq);

	// ismust가 "Y"인 공지사항 리스트
	public List<BoardNotice> noticeBoardListByIsMust(@Param("search") BoardNotice search, @Param("isMust") String ismust);
//////////////////////////////////////////////////공지사항(끝)//////////////////////////////////////////////////

//////////////////////////////////////////////////문의사항(시작)/////////////////////////////////////////////////

	// 문의사항 게시물 등록
	public int qnaBoardInsert(BoardQna boardQna);

	// 문의사항 첨부파일 등록
	public int qnaBoardFileInsert(BoardQnaFile boardQnaFile);

	// 문의사항 게시물 리스트
	public List<BoardQna> qnaBoardList(BoardQna boardQna);
	
	// 문의사항 삭제된 게시물 리스트
	public List<BoardQna> qnaDelBoardList(BoardQna boardQna);

	// 마이페이지 문의사항 게시물 리스트
	public List<BoardQna> myPageQnaList(BoardQna boardQna);

	// 문의사항 총 게시물 수
	public long qnaBoardListCount(BoardQna boardQna);
	
	// 문의사항 삭제된 총 게시물 수
	public long qnaDelBoardListCount(BoardQna boardQna);

	// 문의사항 마이페이지 총 게시물 수
	public long qnaMyPageListCount(String userId);

	// 문의사항 게시물 조회
	public BoardQna qnaBoardSelect(long brdSeq);

	// 문의사항 게시물 첨부파일 조회
	public BoardQnaFile qnaBoardFileSelect(long brdSeq);

	// 문의사항 게시물 조회수 증가
	public int qnaReadCntPlus(long brdSeq);

	// 문의사항 게시물 삭제
	public int qnaBoardDelete(BoardQna boardQna);
	
	// 문의사항 게시물 답글 첨부파일 삭제
	public int qnaRealBoardCommFileDelete(long brdSeq);
	// 문의사항 게시물 답글 삭제
	public int qnaRealBoardDeleteParent(long brdSeq);
	// 문의사항 게시물 삭제
	public int qnaRealBoardDeleteQna(long brdSeq);
	// 문의사항 게시물 첨부파일 삭제
	public int qnaRealBoardFileDelete(long brdSeq);

	// 문의사항 게시물 수정
	public int qnaBoardUpdate(BoardQna boardQna);

	// 문의사항 게시물 첨부파일 삭제
	public int qnaBoardFileDelete(long brdSeq);

	// 문의사항 답글 등록
	public int boardCommInsert(BoardQna boardQna);

	// 문의사항 답글 조회
	public BoardQna qnaCommBoardSelect(long brdParent);

	// 문의사항 답글 유무 확인
	public int countRepliesByBrdSeq(long brdSeq);

	// 문의사항 답변 수정
	public int qnaCommBoardUpdate(BoardQna boardQna);

	// 문의사항 답변 첨부파일 조회
	public BoardQnaFile qnaCommBoardFileSelect(long brdSeq);

//////////////////////////////////////////////////문의사항(끝)//////////////////////////////////////////////////

//////////////////////////////////////////////////자유게시판(시작)///////////////////////////////////////////

	// 게시물 등록
	public int freeBoardInsert(Board board);

	// 게시물 리스트
	public List<Board> freeBoardList(Board board);

	// 게시물 총수
	public long freeBoardListCount(Board board);
	
	// 삭제된 게시물 리스트
	public List<Board> freeDelBoardList(Board board);
	
	// 삭제된 게시물 총수
	public long freeDelBoardListCount(Board board);

	// 게시물 보기
	public Board freeBoardSelect(@Param("brdSeq") long brdSeq);

	// 조회수 증가
	public int freeBoardReadCntPlus(@Param("brdSeq") long brdSeq);

	// 게시물 삭제
	public int freeBoardDelete(@Param("brdSeq") long brdSeq);
	
	// 게시물 완전 삭제
	public int freeRealBoardDelete(long brdSeq);

	// 게시물 수정
	public int freeBoardUpdate(Board board);

	// 좋아요 조회
	public BoardLike freeSelectLike(@Param("brdSeq") long brdSeq, @Param("userId") String userId);

	// 좋아요 추가
	public int freeInsertLike(@Param("brdSeq") long brdSeq, @Param("userId") String userId);

	// 좋아요 삭제
	public int freeDeleteLike(@Param("brdSeq") long brdSeq, @Param("userId") String userId);

	// 좋아요 수 조회
	public int freeSelectLikeCount(@Param("brdSeq") long brdSeq);

	// 게시물 첨부파일 등록
	public int freeBoardFileInsert(BoardFile boardFile);

	// 첨부파일 조회
	public BoardFile freeBoardFileSelect(@Param("brdSeq") long brdSeq);

	// 게시물 첨부파일 삭제
	public int freeBoardFileDelete(@Param("brdSeq") long brdSeq);

	// 북마크 조회
	public BoardMark freeSelectMark(@Param("brdSeq") long brdSeq, @Param("userId") String userId);

	// 북마크 추가
	public int freeInsertMark(@Param("brdSeq") long brdSeq, @Param("userId") String userId);

	// 북마크 삭제
	public int freeDeleteMark(@Param("brdSeq") long brdSeq, @Param("userId") String userId);

//////////////////////////////////////////////////자유게시판(끝)////////////////////////////////////////////
}
