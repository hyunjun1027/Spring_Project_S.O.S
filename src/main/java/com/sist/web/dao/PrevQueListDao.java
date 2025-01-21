package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.PrevQue;
import com.sist.web.model.PrevQue_Easy_Hard;

@Repository("prevQueListDao")
public interface PrevQueListDao {
	
	public long seqSelect();
	
	public int prevQueInsert (PrevQue prevQue);
	
	public int prevQueDelete (long examSeq);
	
	public List<PrevQue> prevQueList(PrevQue prevQue);

	public long prevQueListCount(PrevQue prevQue);

	public PrevQue prevQueSelect(long examSeq);

	public List<PrevQue_Easy_Hard> easyHardSelect(PrevQue_Easy_Hard prevQue_Easy_Hard);

	public long easyHardSelect2(long examSeq);

	public int easyHardInsert(PrevQue_Easy_Hard prevQue_Easy_Hard);

	public int easyHardDelete(PrevQue_Easy_Hard prevQue_Easy_Hard);

	public long easyCnt(long examSeq);

	public long hardCnt(long examSeq);
}
