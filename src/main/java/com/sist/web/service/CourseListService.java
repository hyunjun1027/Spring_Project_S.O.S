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
import com.sist.common.util.StringUtil;
import com.sist.web.dao.AccountDao;
import com.sist.web.dao.CourseListDao;
import com.sist.web.model.CourseList;
import com.sist.web.model.CourseListFile;
import com.sist.web.model.User;

@Service("courseListService")
public class CourseListService {

	private static Logger logger = LoggerFactory.getLogger(CourseListService.class);

	@Autowired
	private AccountDao accountDao;

	@Autowired
	private CourseListDao courseListDao;

	// 파일 저장 경로
	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;

	// 코스 공지 게시판 조회
	public List<CourseList> courseNoticeList(CourseList courseList) {
		List<CourseList> list = null;

		try {
			list = courseListDao.courseNoticeList(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeList SQLException", e);
		}

		return list;
	}

	// 코스 공지 게시판 글 수 조회
	public long courseNoticeListCount(CourseList courseList) {
		long totalCount = 0;

		try {
			totalCount = courseListDao.courseNoticeListCount(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeListCount SQLException", e);
		}

		return totalCount;
	}

	// 코스 공지 게시판 게시글 상세조회 (이전글/다음글 포함)
	public Map<String, Object> courseNoticeViewResult(CourseList courseLit) {
		CourseList list = null;
		CourseList prevList = null;
		CourseList nextList = null;

		try {
			list = courseListDao.courseNoticeView(courseLit);

			if (list != null) {
				// 조회수 증가
				courseNoticeReadCntPlus(courseLit.getBrdSeq());

				// 이전글 조회
				prevList = courseListDao.courseNoticePrevView(courseLit);

				// 다음글 조회
				nextList = courseListDao.courseNoticeNextView(courseLit);
			}

		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeViewResult SQLException", e);
		}

		// 게시물, 이전글, 다음글 정보 리턴
		Map<String, Object> result = new HashMap<>();
		result.put("list", list);
		result.put("prevList", prevList);
		result.put("nextList", nextList);

		return result;

	}

	// 코스 공지 게시판 게시글 상세조회
	public CourseList courseNoticeView(CourseList courseList) {

		CourseList list = null;

		try {
			list = courseListDao.courseNoticeView(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeView SQLException", e);
		}

		return list;
	}

	// 코스 공지 게시판 게시글 조회수 증가
	public int courseNoticeReadCntPlus(long brdSeq) {
		int count = 0;

		try {
			count = courseListDao.courseNoticeReadCntPlus(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeReadCntPlus SQLException", e);
		}

		return count;
	}

	// 코스 공지 게시판 이전글 조회
	public CourseList courseNoticePrevView(CourseList courseList) {
		CourseList list = null;

		try {
			list = courseListDao.courseNoticePrevView(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticePrevView SQLException", e);
		}

		return list;
	}

	// 코스 공지 게시판 다음글 조회
	public CourseList courseNoticeNextView(CourseList courseList) {
		CourseList list = null;

		try {
			list = courseListDao.courseNoticeNextView(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeNextView SQLException", e);
		}

		return list;
	}

	// 코스 공지 게시글 등록
	public int courseNoticeWrite(CourseList courseList) {
		int count = 0;

		try {
			count = courseListDao.courseNoticeWrite(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeNextView SQLException", e);
		}

		return count;
	}

	// 코스 공지 게시글 수정
	public int courseNoticeUpdate(CourseList courseList) {
		int count = 0;

		try {
			count = courseListDao.courseNoticeUpdate(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeNextView SQLException", e);
		}

		return count;
	}

	// 코스 공지 게시글 삭제
	public int courseNoticeDelete(long brdSeq) {
		int count = 0;

		try {
			count = courseListDao.courseNoticeDelete(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeNextView SQLException", e);
		}

		return count;
	}

	// 코스 수강후기 게시글 수정 조회
	public CourseList courseNoticeViewUpdate(CourseList c) {
		CourseList cl = null;

		try {
			cl = courseListDao.courseNoticeView(c);
		} catch (Exception e) {
			logger.error("[CourseListService] courseNoticeViewUpdate SQLException", e);
		}

		return cl;
	}

	// 강사 공지 게시판 글 6개 조회
	public List<CourseList> teachNoticeRec(String teacherId) {
		List<CourseList> cl = null;

		try {
			cl = courseListDao.teachNoticeRec(teacherId);
		} catch (Exception e) {
			logger.error("[CourseListService] teachNoticeRec SQLException", e);
		}

		return cl;
	}

	// 과목별 최신 공지 4개 조회
	public List<CourseList> classNotcieRec(int classCode) {
		List<CourseList> cl = null;

		try {
			cl = courseListDao.classNotcieRec(classCode);
		} catch (Exception e) {
			logger.error("[CourseListService] classNotcieRec SQLException", e);
		}

		return cl;

	}

	// =================================================================================================================================
	// //

	// 코스 QnA 게시판 조회
	public List<CourseList> courseQnAList(CourseList courseList) {
		List<CourseList> list = null;

		try {
			list = courseListDao.courseQnAList(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAList SQLException", e);
		}

		return list;
	}

	// 코스 QnA 게시판 글 수 조회
	public long courseQnAListCount(CourseList courseList) {
		long totalCount = 0;

		try {
			totalCount = courseListDao.courseQnAListCount(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAListCount SQLException", e);
		}

		return totalCount;
	}

	// 코스 QnA 게시판 내가 쓴 글 조회
	public List<CourseList> courseQnAMyBrdList(CourseList courseList) {
		List<CourseList> list = null;

		try {
			list = courseListDao.courseQnAMyBrdList(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAMyBrdList SQLException", e);
		}

		return list;
	}

	// 마이페이지 QnA 댓글조회
	public int myPageQnACommentSelect(long brdSeq) {
		int count = 0;

		try {
			count = courseListDao.myPageQnACommentSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] myPageQnACommentSelect SQLException", e);
		}

		return count;
	}

///////////////////////////////////////////////////////////////////////////////////////////
	// 마이페이지 QnA 게시판 내가 쓴 글 조회
	public List<CourseList> courseMyPageQnaList(CourseList courseList) {
		List<CourseList> list = null;

		try {
			list = courseListDao.courseMyPageQnaList(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseMyPageQnaList SQLException", e);
		}

		return list;
	}

	// 문의사항 답글 유무 확인
	public boolean hasReplies(long brdSeq) {
		boolean hasReplies = false;

		try {
			int replyCount = courseListDao.countRepliesMyPageBrdSeq(brdSeq);
			hasReplies = replyCount > 0;
		} catch (Exception e) {
			logger.error("[CourseListService] hasReplies Exception", e);
		}

		return hasReplies;
	}

////////////////////////////////////////////////////////////////////////////////

	public long courseQnAMyBrdListCount(CourseList courseList) {
		long totalCount = 0;

		try {
			totalCount = courseListDao.courseQnAMyBrdListCount(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAMyBrdListCount SQLException", e);
		}

		return totalCount;
	}

	// 코스 QnA 게시판 게시글 상세조회
	public List<CourseList> courseNoticeQnAViewList(CourseList courseList) {
		List<CourseList> list = null;

		try {
			courseQnAReadCntPlus(courseList.getBrdSeq());
			list = courseListDao.courseNoticeQnAViewList(courseList);

			CourseListFile clf = null;

			for (int i = 0; i < list.size(); i++) {
				clf = courseListDao.courseQnAFileSelect(list.get(i).getBrdSeq());
				// 파일이 있을 때
				if (clf != null) {
					list.get(i).setCourseListFile(clf);
				}
			}

		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAMyBrdList SQLException", e);
		}

		return list;
	}

	// 코스 QnA 게시판 게시글 조회수 증가
	public int courseQnAReadCntPlus(long brdSeq) {
		int count = 0;

		try {
			count = courseListDao.courseQnAReadCntPlus(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAMyBrdList SQLException", e);
		}

		return count;
	}

	// 코스 QnA 게시판 글 등록
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int courseListQnAInsert(CourseList courseList) throws Exception {
		int count = 0;

		// 여기서 강사인지 학생인지 판별 (글 작성 OR 답글 작성)
		User who = accountDao.userOrTeacher(courseList.getUserId());

		// 학생이라면
		if (StringUtil.equals(who.getRating(), "U")) {
			count = courseListDao.courseQnAWrite(courseList);
		}
		// 강사라면
		else if (StringUtil.equals(who.getRating(), "T")) {
			courseListDao.courseQnAGroupOrderUpdate(courseList);
			count = courseListDao.courseQnAReplyInsert(courseList);
		}

		// 파일이 있다면
		if (count > 0 && courseList.getCourseListFile() != null) {
			CourseListFile courseListFile = courseList.getCourseListFile();

			courseListFile.setBrdSeq(courseList.getBrdSeq());
			courseListFile.setFileSeq((short) 1);
			courseListFile.setCourseCode(courseList.getCourseCode());

			courseListDao.courseQnAFileInsert(courseListFile);
		}

		return count;
	}

	// 코스 QnA 게시판 파일 조회
	public CourseListFile courseQnAFileSelect(long brdSeq) {
		CourseListFile clf = null;

		try {
			clf = courseListDao.courseQnAFileSelect(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAFileSelect SQLException", e);
		}

		return clf;
	}

	// 코스 QnA 게시글 1개 조회
	public CourseList courseQnASelect(long brdseq) {
		CourseList cl = null;

		try {
			cl = courseListDao.courseQnASelect(brdseq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnASelect SQLException", e);
		}

		return cl;
	}

	// 코스 QnA 게시판 수정폼 조회 (첨부파일 포함)
	public CourseList courseListQnAViewUpdate(long brdSeq) {
		CourseList cl = null;

		try {
			cl = courseListDao.courseQnASelect(brdSeq);

			if (cl != null) {

				CourseListFile clf = courseListDao.courseQnAFileSelect(brdSeq);

				if (clf != null) {
					cl.setCourseListFile(clf);
				}

			}

		} catch (Exception e) {
			logger.error("[CourseListService] courseListQnAViewUpdate SQLException", e);
		}

		return cl;
	}

	// 코스 QnA 게시판 게시글 삭제 (첨부파일이 있으면 함께 삭제)
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int courseQnADelete(long brdSeq) throws Exception {
		int count = 0;

		CourseList cl = courseListQnAViewUpdate(brdSeq);

		if (cl != null) {

			if (cl.getCourseListFile() != null) {
				if (courseListDao.courseQnAFileDelete(brdSeq) > 0) {
					// 첨부 파일도 함께 삭제
					FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + cl.getCourseListFile().getFileName());
				}
			}

			count = courseListDao.courseQnADelete(brdSeq);
		}

		return count;
	}

	// 코스 QnA 게시판 게시글 수정
	@Transactional(propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
	public int courseQnAUpdate(CourseList courseList) throws Exception {
		int count = 0;

		count = courseListDao.courseQnAUpdate(courseList);

		// 첨부파일이 있을 때
		if (count > 0 && courseList.getCourseListFile() != null) {

			CourseListFile delClf = courseListDao.courseQnAFileSelect(courseList.getBrdSeq());

			if (delClf != null) {
				FileUtil.deleteFile(UPLOAD_SAVE_DIR + FileUtil.getFileSeparator() + delClf.getFileName());
				courseListDao.courseQnAFileDelete(courseList.getBrdSeq());
			}

			courseList.getCourseListFile().setBrdSeq(courseList.getBrdSeq());
			courseList.getCourseListFile().setFileSeq((short) 1);

			courseListDao.courseQnAFileInsert(courseList.getCourseListFile());
		}

		return count;
	}

	public int courseQnAListCountM(CourseList courseList) {
		int count = 0;
		try {
			count = courseListDao.courseQnAListCountM(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseQnAListCountM SQLException", e);
		}
		return count;
	}
	// =======================================================================================================================================
	// //

	// 코스 수강후기 게시판 글 조회
	public List<CourseList> courseReviewList(CourseList courseList) {
		List<CourseList> list = null;

		try {
			list = courseListDao.courseReviewList(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewList SQLException", e);
		}

		return list;
	}

	// 코스 수강후기 게시판 글 수 조회
	public long courseReviewListCount(CourseList courseList) {
		long totalCount = 0;

		try {
			totalCount = courseListDao.courseReviewListCount(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewListCount SQLException", e);
		}

		return totalCount;
	}

	// 코스 수강후기 게시글 상세조회
	public CourseList courseReviewView(CourseList courseList) {
		CourseList list = null;

		try {
			list = courseListDao.courseReviewView(courseList.getBrdSeq());

			if (list != null) {
				courseReviewReadCntPlus(list.getBrdSeq());
			}
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewView SQLException", e);
		}

		return list;
	}

	// 코스 수강후기 게시글 조회수 증가
	public int courseReviewReadCntPlus(long brdSeq) {
		int count = 0;

		try {
			count = courseListDao.courseReviewReadCntPlus(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewReadCntPlus SQLException", e);
		}

		return count;

	}

	// 코스 수강후기 작성 여부 조회
	public int courseReviewWriteCheck(String userId, long courseCode) {
		int count = 0;

		try {
			count = courseListDao.courseReviewWriteCheck(userId, courseCode);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewWriteCheck SQLException", e);
		}

		return count;
	}

	// 코스 수강후기 게시글 등록
	public int courseReviewInsert(CourseList courseList) {
		int count = 0;

		try {
			count = courseListDao.courseReviewInsert(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewInsert SQLException", e);
		}

		return count;
	}

	// 코스 수강후기 게시글 수정
	public int courseReviewUpdate(CourseList courseList) {
		int count = 0;

		try {
			count = courseListDao.courseReviewUpdate(courseList);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewUpdate SQLException", e);
		}

		return count;
	}

	// 코스 수강후기 게시글 삭제
	public int courseReviewDelete(long brdSeq) {
		int count = 0;

		try {
			count = courseListDao.courseReviewDelete(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewUpdate SQLException", e);
		}

		return count;
	}

	// 코스 수강후기 게시글 상세조회
	public CourseList courseReviewViewUpdate(long brdSeq) {
		CourseList cl = null;

		try {
			cl = courseListDao.courseReviewView(brdSeq);
		} catch (Exception e) {
			logger.error("[CourseListService] courseReviewViewUpdate SQLException", e);
		}

		return cl;
	}

	// 베스트 수강후기 3개 뽑기
	public List<CourseList> teachBestReview(String teacherId) {
		List<CourseList> cl = null;

		try {
			cl = courseListDao.teachBestReview(teacherId);
		} catch (Exception e) {
			logger.error("[CourseListService] teachBestReview SQLException", e);
		}

		return cl;
	}

}
