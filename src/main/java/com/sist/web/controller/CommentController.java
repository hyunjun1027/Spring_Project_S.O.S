package com.sist.web.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sist.common.util.StringUtil;
import com.sist.web.model.Comment;
import com.sist.web.model.Response;
import com.sist.web.service.CommentService;
import com.sist.web.util.CookieUtil;
import com.sist.web.util.HttpUtil;

@Controller("CommentController")
public class CommentController {
	private static Logger logger = LoggerFactory.getLogger(BoardController.class);

	@Autowired
	private CommentService commentService;

	@Value("#{env['auth.cookie.name']}")
	private String AUTH_COOKIE_NAME;

	// 댓글 수 조회
	@RequestMapping(value = "/writeProc/commentCount", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProcCommentCount(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);

		int commentCount = commentService.commentCount(brdSeq);

		if (commentCount > 0) {
			ajaxResponse.setResponse(0, "success", commentCount);
		} else {
			ajaxResponse.setResponse(400, "bad request");
		}

		return ajaxResponse;
	}

	// 댓글 등록
	@RequestMapping(value = "/writeProc/comment", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> writeProcComment(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String comContent = HttpUtil.get(request, "comContent", "");

		if (!StringUtil.isEmpty(cookieUserId)) {
			Comment comment = new Comment();

			comment.setUserId(cookieUserId);
			comment.setComContent(comContent);
			comment.setBrdSeq(brdSeq);

			try {
				if (commentService.commentInsert(comment) > 0) {
					List<Comment> searchCmt = commentService.commentSelect(brdSeq);

					for (Comment com : searchCmt) {
						Long comSeq = com.getComSeq();
						List<Comment> replies = commentService.comcommentSelect(comSeq);
						com.setReplies(replies);
						com.setReplyCount(replies.size());
					}

					ajaxResponse.setResponse(0, "success", searchCmt);
				} else {
					ajaxResponse.setResponse(500, "internal server error");
				}
			} catch (Exception e) {
				logger.error("[CommentController] writeProcComment Exception", e);
				ajaxResponse.setResponse(500, "internal server error2");
			}
		} else {
			ajaxResponse.setResponse(400, "bad request");
		}

		return ajaxResponse;
	}

	// 댓글 삭제
	@RequestMapping(value = "/delete/comment", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> delete(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		long comSeq = HttpUtil.get(request, "comSeq", (long) 0);

		if (brdSeq > 0) {
			Comment comment = commentService.commentDelSelect(brdSeq, comSeq);

			if (comment != null) {
				if (StringUtil.equals(cookieUserId, comment.getUserId())) {
					Comment delete = new Comment();

					delete.setBrdSeq(brdSeq);
					delete.setComSeq(comSeq);
					delete.setComGroup(comment.getComGroup());

					if (comment.getComParent() == 0) {
						try {
							if (commentService.commentDeleteGroup(delete) > 0) {
								List<Comment> searchCmt = commentService.commentSelect(brdSeq);

								for (Comment com : searchCmt) {
									comSeq = com.getComSeq();
									List<Comment> replies = commentService.comcommentSelect(comSeq);
									com.setReplies(replies);
									com.setReplyCount(replies.size());
								}

								ajaxResponse.setResponse(0, "success", searchCmt);
							} else {
								ajaxResponse.setResponse(500, "service error2");
							}
						} catch (Exception e) {
							logger.error("[CommentController] delete Exception", e);
							ajaxResponse.setResponse(500, "service error1");
						}
					} else {
						try {
							if (commentService.commentDelete(delete) > 0) {
								List<Comment> searchCmt = commentService.commentSelect(brdSeq);

								for (Comment com : searchCmt) {
									Long comSeqCopy = com.getComSeq();
									List<Comment> replies = commentService.comcommentSelect(comSeqCopy);
									com.setReplies(replies);
								}

								ajaxResponse.setResponse(0, "success", searchCmt);
							} else {
								ajaxResponse.setResponse(500, "service error2");
							}
						} catch (Exception e) {
							logger.error("[CommentController] delete Exception", e);
							ajaxResponse.setResponse(500, "service error1");
						}
					}
				}
			}
		}
		return ajaxResponse;
	}

	// 댓글 수정
	@RequestMapping(value = "/update/comment", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> commentUpdate(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		String comContent = HttpUtil.get(request, "comContent", (String) "");
		long comSeq = HttpUtil.get(request, "comSeq", (long) 0);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);

		logger.debug(comContent + "|||||" + comSeq);

		Comment comment = new Comment();

		if (cookieUserId == null || cookieUserId == "") {
			ajaxResponse.setResponse(999, "login plz");
		} else {
			if (comSeq > 0 && !StringUtil.isEmpty(comContent)) {
				try {
					comment.setComSeq(comSeq);
					comment.setComContent(comContent);

					if (commentService.commentUpdate(comment) > 0) {
						List<Comment> searchCmt = commentService.commentSelect(brdSeq);

						for (Comment com : searchCmt) {
							Long comSeqCopy = com.getComSeq();
							List<Comment> replies = commentService.comcommentSelect(comSeqCopy);
							com.setReplies(replies);
							com.setReplyCount(replies.size());
						}

						ajaxResponse.setResponse(0, "bad request", searchCmt);
					} else {
						ajaxResponse.setResponse(500, "error");
					}
				} catch (Exception e) {
					logger.error("[CommentController] commentUpdate Exception", e);
					ajaxResponse.setResponse(501, "service error1");
				}
			} else {
				ajaxResponse.setResponse(400, "bad request");
			}
		}

		return ajaxResponse;
	}

	// 댓글에 대댓글
	@RequestMapping(value = "/replyProc/comment", method = RequestMethod.POST)
	@ResponseBody
	public Response<Object> replyProc(HttpServletRequest request, HttpServletResponse response) {
		Response<Object> ajaxResponse = new Response<Object>();

		String cookieUserId = CookieUtil.getHexValue(request, AUTH_COOKIE_NAME);
		long brdSeq = HttpUtil.get(request, "brdSeq", (long) 0);
		String comContent = HttpUtil.get(request, "comContent", "");
		long comSeq = HttpUtil.get(request, "comSeq", (long) 0);

		if (cookieUserId == null || cookieUserId == "") {
			ajaxResponse.setResponse(999, "login plz");
		} else {
			if (brdSeq > 0 && !StringUtil.isEmpty(comContent)) {
				List<Comment> searchComment = commentService.commentAllSelect(brdSeq, comSeq);

				Comment parent = new Comment();

				for (int i = 0; i < searchComment.size(); i++) {
					if (comSeq == searchComment.get(i).getComSeq()) {
						parent = searchComment.get(i);
						break;
					}
				}

				if (parent != null) {
					Comment comment = new Comment();

					comment.setUserId(cookieUserId);
					comment.setComContent(comContent);
					comment.setComGroup(parent.getComGroup());
					comment.setComOrder(parent.getComOrder() + 1);

					if (parent.getComIndent() == 0) {
						comment.setComIndent(parent.getComIndent() + 1);
					}
					if (parent.getComIndent() == 1) {
						comment.setComIndent(parent.getComIndent());
					}

					comment.setComParent(comSeq);
					comment.setBrdSeq(brdSeq);
					try {
						if (commentService.commentReplyInsert(comment) > 0) {
							List<Comment> searchCmt = commentService.commentSelect(brdSeq);

							for (Comment com : searchCmt) {
								Long comSeqCopy = com.getComSeq();
								List<Comment> replies = commentService.comcommentSelect(comSeqCopy);
								com.setReplies(replies);
								com.setReplyCount(replies.size());
							}

							ajaxResponse.setResponse(0, "success", searchCmt);
						} else {
							ajaxResponse.setResponse(500, "internal server error2");
						}
					} catch (Exception e) {
						logger.error("[CommentController] replyProc Exception", e);
						ajaxResponse.setResponse(500, "internal server error");
					}

				} else {
					// 부모댓글이 없을 경우
					ajaxResponse.setResponse(404, "not found");
				}
			} else {
				ajaxResponse.setResponse(400, "bad request");
			}
		}

		return ajaxResponse;
	}

}
