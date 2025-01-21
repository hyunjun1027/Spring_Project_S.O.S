package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.sist.web.dao.CommentDao;
import com.sist.web.model.Comment;

@Service("CommentService")
public class CommentService {
	private static Logger logger = LoggerFactory.getLogger(CommentService.class);

	@Autowired
	private CommentDao CommentDao;

	// 댓글 리스트 조회
	public List<Comment> commentSelect(long brdSeq) {
		List<Comment> comment = null;

		try {
			comment = CommentDao.commentSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[CommentService] commentSelect Exception", e);
		}

		return comment;
	}

	// 대댓글 리스트 조회
	public List<Comment> comcommentSelect(long comSeq) {
		List<Comment> comment = null;

		try {
			comment = CommentDao.comcommentSelect(comSeq);
		} catch (Exception e) {
			logger.error("[CommentService] comcommentSelect Exception", e);
		}

		return comment;
	}

	// 댓글, 대댓글 리스트 조회
	public List<Comment> commentAllSelect(long brdSeq, long comSeq) {
		List<Comment> comment = null;

		try {
			comment = CommentDao.commentAllSelect(brdSeq, comSeq);
		} catch (Exception e) {
			logger.error("[CommentService] commentAllSelect Exception", e);
		}

		return comment;
	}

	// 댓글 삭제 조회
	public Comment commentDelSelect(long brdSeq, long commentNum) {
		Comment comment = new Comment();

		try {
			comment = CommentDao.commentDelSelect(brdSeq, commentNum);
		} catch (Exception e) {
			logger.error("[CommentService] commentDelSelect Exception", e);
		}

		return comment;
	}

	// 댓글 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int commentInsert(Comment comment) throws Exception {
		int count = 0;

		try {
			count = CommentDao.commentInsert(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commentInsert Exception", e);
		}

		return count;
	}

	// 댓글 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int commentDelete(Comment comment) throws Exception {
		int count = 0;

		try {
			count = CommentDao.commentDelete(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commentDelete Exception", e);
		}

		return count;
	}

	// 그룹 댓글 삭제
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int commentDeleteGroup(Comment comment) throws Exception {
		int count = 0;

		try {
			count = CommentDao.commentDeleteGroup(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commentDeleteGroup Exception", e);
		}

		return count;
	}

	// 댓글 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int commentUpdate(Comment comment) throws Exception {
		int count = 0;

		try {
			count = CommentDao.commentUpdate(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commentUpdate Exception", e);
		}

		return count;
	}

	// 댓글에 대댓글 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int commentReplyInsert(Comment comment) throws Exception {
		int count = 0;

		CommentDao.commentGroupOrderUpdate(comment);
		try {
			count = CommentDao.commentReplyInsert(comment);
		} catch (Exception e) {
			logger.error("[CommentService] commentReplyInsert Exception", e);
		}

		return count;
	}

	// 댓글 수 조회
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int commentCount(long brdSeq) {
		int count = 0;

		try {
			count = CommentDao.commentCount(brdSeq);
		} catch (Exception e) {
			logger.error("[BoardService] commentCount Exception", e);
		}

		return count;
	}

}