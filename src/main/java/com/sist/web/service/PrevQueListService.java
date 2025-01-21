package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.sist.common.util.FileUtil;
import com.sist.web.dao.PrevQueListDao;
import com.sist.web.model.PrevQue;
import com.sist.web.model.PrevQue_Easy_Hard;

@Service("prevQueListService")
public class PrevQueListService {

	private static Logger logger = LoggerFactory.getLogger(PrevQueListService.class);

	@Value("#{env['upload.save.dir']}")
	private String UPLOAD_SAVE_DIR;
	
	@Value("#{env['exam.save.dir']}")
	   private String EXAM_SAVE_DIR;

   @Value("#{env['ans.save.dir']}")
   private String ANS_SAVE_DIR;

	@Autowired
	private PrevQueListDao prevQueListDao;
	
	
	// 시퀀스 번호 선조회
	public long seqSelect() {
		long examSeq = 0;
		
		try {
			examSeq = prevQueListDao.seqSelect();
		} catch (Exception e) {
			logger.error("[PrevQueListService] seqSelect Exception", e);
		}
		
		return examSeq;
	}
	
	
	// 기출문제 등록
	public int prevQueInsert(PrevQue prevQue) {
		int count = 0;
		
		try {
			count = prevQueListDao.prevQueInsert(prevQue);
		} catch (Exception e) {
			logger.error("[PrevQueListService] seqSelect Exception", e);
		}
		
		return count;
	}
	
	// 기출문제 삭제
	public int prevQueDelete (long examSeq) {
		int count = 0;
		
		try {
			PrevQue pq = prevQueListDao.prevQueSelect(examSeq);
			
			if (pq != null) {
				
				FileUtil.deleteFile(EXAM_SAVE_DIR + FileUtil.getFileSeparator() + pq.getExamTestFileName());
				FileUtil.deleteFile(ANS_SAVE_DIR + FileUtil.getFileSeparator() + pq.getExamAnsFileName());
			
				count = prevQueListDao.prevQueDelete(examSeq);
			}
			
		} catch (Exception e) {
			logger.error("[PrevQueListService] prevQueDelete Exception", e);
		}
		
		return count;
	}
	
	

	// 게시물 리스트
	public List<PrevQue> prevQueList(PrevQue prevQue) {
		List<PrevQue> list = null;

		try {
			list = prevQueListDao.prevQueList(prevQue);

		} catch (Exception e) {
			logger.error("[PrevQueListService] prevQueList Exception", e);
		}

		return list;
	}

	// 총 게시물 수
	public long prevQueListCount(PrevQue prevQue) {

		long count = 0;

		try {

			count = prevQueListDao.prevQueListCount(prevQue);

		} catch (Exception e) {
			logger.error("[PrevQueListService] prevQueListCount Exception", e);
		}

		return count;

	}

	// 게시물 조회
	public PrevQue prevQueSelect(long examSeq) {

		PrevQue prevQue = null;

		try {

			prevQue = prevQueListDao.prevQueSelect(examSeq);

		} catch (Exception e) {
			logger.error("[PrevQueListService] PrevQueSelect Exception", e);
		}

		return prevQue;

	}

	//////////////////////////////////////////////////////////////////////////////

	public List<PrevQue_Easy_Hard> easyHardSelect(PrevQue_Easy_Hard prevQue_Easy_Hard) {

		List<PrevQue_Easy_Hard> list = null;

		try {

			list = prevQueListDao.easyHardSelect(prevQue_Easy_Hard);

		} catch (Exception e) {

			logger.error("[PrevQueListService] easyHardSelect Exception", e);

		}

		return list;

	}

	public long easyHardSelect2(long examSeq) {

		long count = 0;

		try {

			count = prevQueListDao.easyHardSelect2(examSeq);

		} catch (Exception e) {

			logger.error("[PrevQueListService] easyHardSelect2 Exception", e);

		}

		return count;

	}

	public int easyHardInsert(PrevQue_Easy_Hard prevQue_Easy_Hard) {

		int count = 0;

		try {

			count = prevQueListDao.easyHardInsert(prevQue_Easy_Hard);

		} catch (Exception e) {

			logger.error("[PrevQueListService] easyHardInsert Exception", e);

		}

		return count;

	}

	public int easyHardDelete(PrevQue_Easy_Hard prevQue_Easy_Hard) {

		int count = 0;

		try {

			count = prevQueListDao.easyHardDelete(prevQue_Easy_Hard);

		} catch (Exception e) {

			logger.error("[PrevQueListService] easyHardDelete Exception", e);

		}

		return count;

	}

	// 쉬워요 수
	public long easyCnt(long examSeq) {

		long count = 0;

		try {

			count = prevQueListDao.easyCnt(examSeq);

		} catch (Exception e) {
			logger.error("[PrevQueListService] easyCnt Exception", e);
		}

		return count;

	}

	// 어려워요 수
	public long hardCnt(long examSeq) {

		long count = 0;

		try {

			count = prevQueListDao.hardCnt(examSeq);

		} catch (Exception e) {
			logger.error("[PrevQueListService] hardCnt Exception", e);
		}

		return count;

	}

}
