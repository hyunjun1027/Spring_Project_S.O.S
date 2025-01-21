package com.sist.web.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.BoardDao;
import com.sist.web.model.Board;
import com.sist.web.model.BoardFile;
import com.sist.web.model.BoardLike;
import com.sist.web.model.BoardMark;
import com.sist.web.model.BoardNotice;
import com.sist.web.model.BoardNoticeFile;
import com.sist.web.model.BoardQna;
import com.sist.web.model.BoardQnaFile;

@Service("boardService")
public class BoardService {

	private static Logger logger = LoggerFactory.getLogger(BoardService.class);

	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;

	@Autowired
	private BoardDao boardDao;

//////////////////////////////////////////////////공지사항(시작)/////////////////////////////////////////////////

	// 공지사항 게시물 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noticeBoardInsert(BoardNotice boardNotice) throws Exception {

		int count = 0;

		count = boardDao.noticeBoardInsert(boardNotice);

		if (count > 0 && boardNotice.getBoardNoticeFile() != null) {

			BoardNoticeFile boardNoticeFile = boardNotice.getBoardNoticeFile();

			boardNoticeFile.setBrdSeq(boardNotice.getBrdSeq());
			boardNoticeFile.setFileSeq((short) 1);

			boardDao.noticeBoardFileInsert(boardNoticeFile);

		}

		return count;

	}

	// 게시물 리스트
	public List<BoardNotice> noticeBoardList(BoardNotice boardNotice) {
		List<BoardNotice> list = null;

		try {
			list = boardDao.noticeBoardList(boardNotice);

		} catch (Exception e) {
			logger.error("[BoardService] noticeBoardList Exception", e);
		}

		return list;
	}

	// 총 게시물 수
	public long noticeBoardListCount(BoardNotice boardNotice) {

		long count = 0;

		try {

			count = boardDao.noticeBoardListCount(boardNotice);

		} catch (Exception e) {
			logger.error("[BoardService] noticeBoardListCount Exception", e);
		}

		return count;

	}
	
	// 삭제된 게시물 리스트
	public List<BoardNotice> noticeDelBoardList(BoardNotice boardNotice) {
		List<BoardNotice> list = null;
		
		try {
			list = boardDao.noticeDelBoardList(boardNotice);
			
		} catch (Exception e) {
			logger.error("[BoardService] noticeDelBoardList Exception", e);
		}
		
		return list;
	}
	
	// 삭제된 총 게시물 수
	public long noticeDelBoardListCount(BoardNotice boardNotice) {
		
		long count = 0;
		
		try {
			
			count = boardDao.noticeDelBoardListCount(boardNotice);
			
		} catch (Exception e) {
			logger.error("[BoardService] noticeDelBoardListCount Exception", e);
		}
		
		return count;
		
	}

	// 게시물 보기(조회)(조회수 증가 포함)
	public Map<String, Object> noticeBoardView(long brdSeq) {

		BoardNotice boardNotice = null;
		BoardNotice prevNotice = null;
		BoardNotice nextNotice = null;

		try {

			// 게시물 조회
			boardNotice = boardDao.noticeBoardSelect(brdSeq);

			if (boardNotice != null) {

				// 조회수 증가
				boardDao.noticeReadCntPlus(brdSeq);

				// 이전글 조회
				prevNotice = boardDao.getPrevNotice(brdSeq);

				// 다음글 조회
				nextNotice = boardDao.getNextNotice(brdSeq);

				// 이전글과 다음글 정보 로그
				logger.info("게시물 조회: " + brdSeq + " 제목: " + boardNotice.getBrdTitle());
				if (prevNotice != null) {
					logger.info("이전글: " + prevNotice.getBrdSeq() + " 제목: " + prevNotice.getBrdTitle());
				}
				if (nextNotice != null) {
					logger.info("다음글: " + nextNotice.getBrdSeq() + " 제목: " + nextNotice.getBrdTitle());
				}

				BoardNoticeFile boardNoticeFile = boardDao.noticeBoardFileSelect(brdSeq);

				if (boardNoticeFile != null) {
					boardNotice.setBoardNoticeFile(boardNoticeFile);
				}
			} else {
				logger.warn("게시물을 찾을 수 없습니다. BRD_SEQ: " + brdSeq);
			}

		} catch (Exception e) {
			logger.error("[BoardService] noticeBoardView Exception", e);
		}

		// 게시물, 이전글, 다음글 정보 리턴
		Map<String, Object> result = new HashMap<>();
		result.put("boardNotice", boardNotice);
		result.put("prevNotice", prevNotice);
		result.put("nextNotice", nextNotice);

		return result;
	}

	// 공지사항 게시물 조회
	public BoardNotice noticeBoardSelect(long brdSeq) {

		BoardNotice boardNotice = null;

		try {

			boardNotice = boardDao.noticeBoardSelect(brdSeq);

		} catch (Exception e) {
			logger.error("[HiBoardService] boardSelect Exception", e);
		}

		return boardNotice;

	}

	// 공지사항 게시물 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noticeBoardUpdate(BoardNotice boardNotice) throws Exception {
		int count = 0;

		count = boardDao.noticeBoardUpdate(boardNotice);

		if (count > 0 && boardNotice.getBoardNoticeFile() != null) {

			BoardNoticeFile delHiBoardFile = boardDao.noticeBoardFileSelect(boardNotice.getBrdSeq());

			// 기존 파일이 있으면 삭제
			if (delHiBoardFile != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delHiBoardFile.getFileName());
				boardDao.noticeBoardFileDelete(boardNotice.getBrdSeq());
			}

			BoardNoticeFile boardNoticeFile = boardNotice.getBoardNoticeFile();
			boardNoticeFile.setBrdSeq(boardNotice.getBrdSeq());
			boardNoticeFile.setFileSeq((short) 1);

			boardDao.noticeBoardFileInsert(boardNoticeFile);

		}

		return count;
	}

	// 공지사항 게시물 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noticeBoardDelete(long brdSeq) throws Exception {

		int count = 0;

		BoardNotice boardNotice = noticeBoardViewUpdate(brdSeq);

		if (boardNotice != null) {

			count = boardDao.noticeBoardDelete(boardNotice);

		}

		return count;

	}
	
	// 공지사항 게시물 완전 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int noticeRealBoardDelete(long brdSeq) throws Exception {
		
		int count = 0;
		
		BoardNotice boardNotice = noticeBoardViewUpdate(brdSeq);
		
		if(boardNotice != null) {
			
			if(boardNotice.getBoardNoticeFile() != null) {
				
				if(boardDao.noticeRealBoardFileDelete(brdSeq) > 0){
					
					//첨부파일도 함께 삭제 처리
					FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator()
												+ boardNotice.getBoardNoticeFile().getFileName());
					
				}
				
			}
			
			count = boardDao.noticeRealBoardDelete(brdSeq);
			
		}
			
		

		
		return count;
		
	}

	// 공지사항 게시물 수정폼 조회
	public BoardNotice noticeBoardViewUpdate(long brdSeq) {

		BoardNotice boardNotice = null;

		try {

			boardNotice = boardDao.noticeBoardSelect(brdSeq);

		} catch (Exception e) {
			logger.error("[BoardService] noticeBoardViewUpdate Exception", e);
		}

		return boardNotice;

	}

	// ismust가 "Y"인 공지사항 리스트
	public List<BoardNotice> noticeBoardListByIsMust(BoardNotice search, String ismust) {
		List<BoardNotice> mustList = null;
		try {
			mustList = boardDao.noticeBoardListByIsMust(search, ismust);
		} catch (Exception e) {
			logger.error("[BoardService] noticeBoardListByIsMust Exception", e);
		}
		return mustList;
	}
//////////////////////////////////////////////////공지사항(끝)//////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////

	////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////문의사항(시작)/////////////////////////////////////////////////	

	// 문의사항 게시물 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int qnaBoardInsert(BoardQna boardQna) throws Exception {

		int count = 0;

		count = boardDao.qnaBoardInsert(boardQna);

		if (count > 0 && boardQna.getBoardQnaFile() != null) {

			BoardQnaFile boardQnaFile = boardQna.getBoardQnaFile();

			boardQnaFile.setBrdSeq(boardQna.getBrdSeq());
			boardQnaFile.setFileSeq((short) 1);

			boardDao.qnaBoardFileInsert(boardQnaFile);

		}

		return count;

	}

	// 문의사항 게시물 리스트
	public List<BoardQna> qnaBoardList(BoardQna boardQna) {
		List<BoardQna> list = null;

		try {
			list = boardDao.qnaBoardList(boardQna);

		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardList Exception", e);
		}

		return list;
	}
	
	// 문의사항 삭제된 게시물 리스트
	public List<BoardQna> qnaDelBoardList(BoardQna boardQna) {
		List<BoardQna> list = null;
		
		try {
			list = boardDao.qnaDelBoardList(boardQna);
			
		} catch (Exception e) {
			logger.error("[BoardService] qnaDelBoardList Exception", e);
		}
		
		return list;
	}

	// 마이페이지 문의사항 리스트
	public List<BoardQna> myPageQnaList(BoardQna boardQna) {
		List<BoardQna> list = null;

		try {
			list = boardDao.myPageQnaList(boardQna);

		} catch (Exception e) {
			logger.error("[BoardService] myPageQnaList Exception", e);
		}

		return list;
	}

	// 문의사항 총 게시물 수
	public long qnaBoardListCount(BoardQna boardQna) {

		long count = 0;

		try {

			count = boardDao.qnaBoardListCount(boardQna);

		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardListCount Exception", e);
		}

		return count;

	}
	// 문의사항 삭제된 총 게시물 수
	public long qnaDelBoardListCount(BoardQna boardQna) {
		
		long count = 0;
		
		try {
			
			count = boardDao.qnaDelBoardListCount(boardQna);
			
		} catch (Exception e) {
			logger.error("[BoardService] qnaDelBoardListCount Exception", e);
		}
		
		return count;
		
	}

	// 문의사항 마이페이지 총 게시물 수
	public long qnaMyPageListCount(String userId) {

		long count = 0;

		try {

			count = boardDao.qnaMyPageListCount(userId);

		} catch (Exception e) {
			logger.error("[BoardService] qnaMyPageListCount Exception", e);
		}

		return count;

	}

	// 게시물 보기(조회)(조회수 증가 포함)
	public BoardQna qnaBoardView(long brdSeq) {
		BoardQna boardQna = null;

		try {
			boardQna = boardDao.qnaBoardSelect(brdSeq);

			if (boardQna != null) {
				boardDao.qnaReadCntPlus(brdSeq);

				// 게시글 이미지 설정
				BoardQnaFile boardQnaFile = boardDao.qnaBoardFileSelect(brdSeq);
				if (boardQnaFile != null) {
					boardQna.setBoardQnaFile(boardQnaFile);
				}

				// 답글 이미지 설정
//	            BoardQnaFile boardCommQnaFile = boardDao.qnaCommBoardFileSelect(brdSeq);
//	            if (boardCommQnaFile != null) {
//	                boardQna.setBoardCommQnaFile(boardCommQnaFile);
//	            }
			}
		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardView Exception", e);
		}

		return boardQna;
	}

	// 게시물 보기(조회)(조회수 증가 포함)
	public BoardQna qnaBoardReplyView(long brdSeq) {
		BoardQna boardQna = null;

		try {
			boardQna = boardDao.qnaCommBoardSelect(brdSeq);

			if (boardQna != null) {
				// 답글 이미지 설정
				BoardQnaFile boardCommQnaFile = boardDao.qnaCommBoardFileSelect(boardQna.getBrdSeq());
				if (boardCommQnaFile != null) {
					boardQna.setBoardCommQnaFile(boardCommQnaFile);
				}
			}
		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardReplyView Exception", e);
		}

		return boardQna;
	}

	// 문의사항 게시물 조회
	public BoardQna qnaBoardSelect(long brdSeq) {

		BoardQna boardQna = null;

		try {

			boardQna = boardDao.qnaBoardSelect(brdSeq);

		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardSelect Exception", e);
		}

		return boardQna;

	}

	// 문의사항 게시물 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int qnaBoardUpdate(BoardQna boardQna) throws Exception {
		int count = 0;

		count = boardDao.qnaBoardUpdate(boardQna);

		if (count > 0 && boardQna.getBoardQnaFile() != null) {

			BoardQnaFile delqnaBoardFile = boardDao.qnaBoardFileSelect(boardQna.getBrdSeq());

			// 기존 파일이 있으면 삭제
			if (delqnaBoardFile != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delqnaBoardFile.getFileName());
				boardDao.qnaBoardFileDelete(boardQna.getBrdSeq());
			}

			BoardQnaFile boardQnaFile = boardQna.getBoardQnaFile();
			boardQnaFile.setBrdSeq(boardQna.getBrdSeq());
			boardQnaFile.setFileSeq((short) 1);

			boardDao.qnaBoardFileInsert(boardQnaFile);

		}

		return count;
	}

	// 문의사항 게시물 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int qnaBoardDelete(long brdSeq) throws Exception {

		int count = 0;

		BoardQna boardQna = qnaBoardViewUpdate(brdSeq);

		if (boardQna != null) {

			count = boardDao.qnaBoardDelete(boardQna);

		}

		return count;

	}
	
	// 문의사항 게시물 완전 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int qnaRealBoardDelete(long brdSeq) throws Exception {
	    int count = 0;

	    try {
	        // 게시글 조회 및 댓글 조회
	        BoardQna boardQna = qnaBoardViewUpdate(brdSeq);
	        BoardQna boardQna2 = qnaBoardCommViewUpdate(brdSeq);

	        // 댓글이 존재하고, 첨부파일이 있을 경우에만 삭제
	        if (boardQna2 != null) {
	            // 댓글 첨부파일이 존재하면 삭제
	            if (boardQna2.getBoardCommQnaFile() != null) {
	                String filePath = UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() 
	                                  + boardQna2.getBoardCommQnaFile().getFileName();
	                FileUtil.deleteFile(filePath);
	                logger.info("Deleted comment file: {}", filePath);

	                // 댓글에 첨부된 파일 삭제
	                count += boardDao.qnaRealBoardCommFileDelete(brdSeq);  
	                logger.info("Deleted comment files for board seq: {}", brdSeq);
	            }
	            // 댓글 삭제 (부모 댓글)
	            count += boardDao.qnaRealBoardDeleteParent(brdSeq); 
	            logger.info("Deleted parent comment for board seq: {}", brdSeq);
	        }

	        // 게시글이 존재하고, 첨부파일이 있을 경우에만 삭제
	        if (boardQna != null) {
	            // 게시글 첨부파일이 존재하면 삭제
	            if (boardQna.getBoardQnaFile() != null) {
	                String filePath = UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() 
	                                  + boardQna.getBoardQnaFile().getFileName();
	                FileUtil.deleteFile(filePath);
	                logger.info("Deleted board file: {}", filePath);

	                // 게시글에 첨부된 파일 삭제
	                count += boardDao.qnaRealBoardFileDelete(brdSeq);  
	                logger.info("Deleted board files for board seq: {}", brdSeq);
	            }
	            // 게시글 삭제
	            count += boardDao.qnaRealBoardDeleteQna(brdSeq); // 게시글 삭제
	            logger.info("Deleted board seq: {}", brdSeq);
	        }

	    } catch (Exception e) {
	        logger.error("Error during board delete operation", e);
	        throw e;  // 예외 발생 시 롤백
	    }

	    return count;
	}










	// 문의사항 게시물 수정폼 조회
	public BoardQna qnaBoardViewUpdate(long brdSeq) {

		BoardQna boardQna = null;

		try {

			boardQna = boardDao.qnaBoardSelect(brdSeq);

		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardViewUpdate Exception", e);
		}

		return boardQna;

	}

	// 문의사항 게시물 수정폼
	public BoardQna qnaBoardViewComm(long brdSeq) {

		BoardQna boardQna = null;

		try {

			boardQna = boardDao.qnaBoardSelect(brdSeq);

		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardViewUpdate Exception", e);
		}

		return boardQna;

	}

	// 문의사항 게시물 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int qnaBoardCommInsert(BoardQna boardQna) throws Exception {

		int count = 0;

		count = boardDao.boardCommInsert(boardQna);

		if (count > 0 && boardQna.getBoardQnaFile() != null) {

			BoardQnaFile boardQnaFile = boardQna.getBoardQnaFile();

			boardQnaFile.setBrdSeq(boardQna.getBrdSeq());
			boardQnaFile.setFileSeq((short) 1);

			boardDao.qnaBoardFileInsert(boardQnaFile);

		}

		return count;

	}

	// 문의사항 답글 조회
	public BoardQna qnaCommBoardSelect(long brdParent) {

		BoardQna boardQna = null;

		try {

			boardQna = boardDao.qnaCommBoardSelect(brdParent);

		} catch (Exception e) {
			logger.error("[BoardService] qnaCommBoardSelect Exception", e);
		}

		return boardQna;

	}

	// 문의사항 답글 유무 확인
	public boolean hasReplies(long brdSeq) {
		boolean hasReplies = false;

		try {
			int replyCount = boardDao.countRepliesByBrdSeq(brdSeq);
			hasReplies = replyCount > 0;
		} catch (Exception e) {
			logger.error("[BoardService] hasReplies Exception", e);
		}

		return hasReplies;
	}

	// 문의사항 게시물 답변 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int qnaCommBoardUpdate(BoardQna boardQna) throws Exception {
		int count = 0;

		count = boardDao.qnaCommBoardUpdate(boardQna);

		if (count > 0 && boardQna.getBoardQnaFile() != null) {

			BoardQnaFile delqnaBoardFile = boardDao.qnaCommBoardFileSelect(boardQna.getBrdSeq());

			// 기존 파일이 있으면 삭제
			if (delqnaBoardFile != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delqnaBoardFile.getFileName());
				boardDao.qnaBoardFileDelete(boardQna.getBrdSeq());
			}

			BoardQnaFile boardQnaFile = boardQna.getBoardQnaFile();
			boardQnaFile.setBrdSeq(boardQna.getBrdSeq());
			boardQnaFile.setFileSeq((short) 1);

			boardDao.qnaBoardFileInsert(boardQnaFile);

		}

		return count;
	}

	// 문의사항 게시물 답변 수정폼 조회
	public BoardQna qnaBoardCommViewUpdate(long brdParent) {

		BoardQna boardQna = null;

		try {

			boardQna = boardDao.qnaCommBoardSelect(brdParent);

		} catch (Exception e) {
			logger.error("[BoardService] qnaBoardViewUpdate Exception", e);
		}

		return boardQna;

	}

//////////////////////////////////////////////////문의사항(끝)//////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////

	////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////자유게시판(시작)///////////////////////////////////////////
	// 게시물 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeBoardInsert(Board board) throws Exception {
		int count = 0;

		count = boardDao.freeBoardInsert(board);

		if (count > 0 && board.getBoardFile() != null) {
			BoardFile boardFile = board.getBoardFile();

			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short) 1);

			boardDao.freeBoardFileInsert(boardFile);
		}

		return count;
	}

	// 게시물 리스트
	public List<Board> freeBoardList(Board board) {
		List<Board> list = null;

		try {
			list = boardDao.freeBoardList(board);
		} catch (Exception e) {
			logger.error("[BoardService] freeBoardList Exception", e);
		}

		return list;
	}

	// 총 게시물 수
	public long freeBoardListCount(Board board) {
		long count = 0;

		try {
			count = boardDao.freeBoardListCount(board);
		} catch (Exception e) {
			logger.error("[BoardService] freeBoardListCount Exception", e);
		}

		return count;
	}
	// 삭제된 게시물 리스트
	public List<Board> freeDelBoardList(Board board) {
		List<Board> list = null;
		
		try {
			list = boardDao.freeDelBoardList(board);
		} catch (Exception e) {
			logger.error("[BoardService] freeDelBoardList Exception", e);
		}
		
		return list;
	}
	
	// 삭제된 총 게시물 수
	public long freeDelBoardListCount(Board board) {
		long count = 0;
		
		try {
			count = boardDao.freeDelBoardListCount(board);
		} catch (Exception e) {
			logger.error("[BoardService] freeDelBoardListCount Exception", e);
		}
		
		return count;
	}

	// 게시물 보기(조회수 증가 포함)
	public Board freeBoardView(long brdSeq) {
		Board board = null;

		try {
			board = boardDao.freeBoardSelect(brdSeq);

			if (board != null) {
				// 조회수 증가
				boardDao.freeBoardReadCntPlus(brdSeq);

				BoardFile boardFile = boardDao.freeBoardFileSelect(brdSeq);

				if (boardFile != null) {
					board.setBoardFile(boardFile);
				}
			}
		} catch (Exception e) {
			logger.error("[BoardService] freeBoardView Exception", e);
		}

		return board;
	}

	// 게시물 조회
	public Board freeBoardSelect(long brdSeq) {
		Board board = null;

		try {
			board = boardDao.freeBoardSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[BoardService] freeBoardSelect Exception", e);
		}

		return board;
	}

	// 게시물 수정폼 조회????
	public Board freeBoardViewUpdate(long brdSeq) {
		Board board = null;

		try {
			board = boardDao.freeBoardSelect(brdSeq);

			if (board != null) {
				BoardFile boardFile = boardDao.freeBoardFileSelect(brdSeq);

				if (boardFile != null) {
					board.setBoardFile(boardFile);
				}
			}
		} catch (Exception e) {
			logger.error("[BoardService] freeBoardViewUpdate Exception", e);
		}

		return board;
	}

	// 게시물 첨부파일 조회
	public BoardFile freeBoardFileSelect(long brdSeq) {
		BoardFile boardFile = null;

		try {
			boardFile = boardDao.freeBoardFileSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[BoardService] freeBoardFileSelect Exception", e);
		}

		return boardFile;
	}

	// 게시물 삭제(첨부파일이 있으면 함께 삭제)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeBoardDelete(long brdSeq) throws Exception {
		int count = 0;

		Board board = freeBoardViewUpdate(brdSeq);

		if (board != null) {
			/*if(board.getBoardFile() != null)
			{
			   if(boardDao.freeBoardFileDelete(brdSeq) > 0)
			   {
			      //첨부파일도 함께 삭제
			      FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator()
			      + board.getBoardFile().getFileName());
			   }
			}*/

			count = boardDao.freeBoardDelete(brdSeq);
		}

		return count;
	}
	
	// 자유게시판 게시물 완전 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeRealBoardDelete(long brdSeq) throws Exception {
		
		int count = 0;

			
		count = boardDao.freeRealBoardDelete(brdSeq);

		
		return count;
		
	}

	// 게시물 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeBoardUpdate(Board board) throws Exception {
		int count = 0;

		count = boardDao.freeBoardUpdate(board);

		if (count > 0 && board.getBoardFile() != null) {
			BoardFile delBoardFile = boardDao.freeBoardFileSelect(board.getBrdSeq());

			// 기존 파일이 있으면 삭제
			if (delBoardFile != null) {
				logger.debug("3333333333333333");
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delBoardFile.getFileName());
				boardDao.freeBoardFileDelete(board.getBrdSeq());
			}

			BoardFile boardFile = board.getBoardFile();
			boardFile.setBrdSeq(board.getBrdSeq());
			boardFile.setFileSeq((short) 1);

			boardDao.freeBoardFileInsert(board.getBoardFile());
		}

		return count;
	}

	// 좋아요 조회
	public BoardLike freeSelectLike(long brdSeq, String userId) {
		BoardLike boardLike = null;

		try {
			boardLike = boardDao.freeSelectLike(brdSeq, userId);
		} catch (Exception e) {
			logger.error("[BoardService] freeSelectLike Exception", e);
		}

		return boardLike;
	}

	// 좋아요 증가
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeInsertLike(long brdSeq, String userId) throws Exception {
		int count = 0;

		try {
			count = boardDao.freeInsertLike(brdSeq, userId);
		} catch (Exception e) {
			logger.error("[BoardService] freeInsertLike Exception", e);
		}

		return count;
	}

	// 좋아요 감소
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeDeleteLike(long brdSeq, String userId) throws Exception {
		int count = 0;

		try {
			count = boardDao.freeDeleteLike(brdSeq, userId);
		} catch (Exception e) {
			logger.error("[BoardService] freeDeleteLike Exception", e);
		}

		return count;
	}

	// 좋아요 수 조회
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeSelectLikeCount(long brdSeq) {
		int count = 0;

		try {
			count = boardDao.freeSelectLikeCount(brdSeq);
		} catch (Exception e) {
			logger.error("[BoardService] freeSelectLikeCount Exception", e);
		}

		return count;
	}

	// 북마크 조회
	public BoardMark freeSelectMark(long brdSeq, String userId) {
		BoardMark boardMark = null;

		try {
			boardMark = boardDao.freeSelectMark(brdSeq, userId);
		} catch (Exception e) {
			logger.error("[BoardService] freeSelectMark Exception", e);
		}

		return boardMark;
	}

	// 북마크 증가
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeInsertMark(long brdSeq, String userId) throws Exception {
		int count = 0;

		try {
			count = boardDao.freeInsertMark(brdSeq, userId);
		} catch (Exception e) {
			logger.error("[BoardService] freeInsertMark Exception", e);
		}

		return count;
	}

	// 북마크 감소
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int freeDeleteMark(long brdSeq, String userId) throws Exception {
		int count = 0;

		try {
			count = boardDao.freeDeleteMark(brdSeq, userId);
		} catch (Exception e) {
			logger.error("[BoardService] freeDeleteMark Exception", e);
		}

		return count;
	}

/////////////////////////////////////////////////자유게시판(끝)/////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////

}
