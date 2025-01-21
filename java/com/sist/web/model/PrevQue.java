package com.sist.web.model;

import java.io.Serializable;

public class PrevQue implements Serializable {

	private static final long serialVersionUID = 1L;
	
    private long examSeq; // 기출문제 시퀀스번호
    private String examTitle; // 기출문제 제목
    private int examQcnt; // 기출문제 문항 수
    private int classCode; // 기출문제 과목 코드
    private String examTestFileName; // 기출문제 파일 이름
    private String examAnsFileName; // 기출문제 정답 파일 이름
    
    private String searchType;         //검색타입 (1:이름, 2:제목, 3:내용)
    private String searchValue;         //검색 값
    
    private long startRow;            //시작페이지 rownum
    private long endRow;            //끝페이지 rownum
    
    private int options;
    private long easyCnt;
    private long hardCnt;
    private PrevQue_Easy_Hard prevQue_Easy_Hard;
    
    public PrevQue() {
    	examSeq = 0;
    	examTitle = "";
    	examQcnt = 0;
    	classCode = 0;
    	examTestFileName = "";
    	examAnsFileName = "";
    	
        searchType = "";
        searchValue = "";
        
        startRow = 0;
        endRow = 0;
        
        options = 0;
        
        prevQue_Easy_Hard = null;
        
        easyCnt = 0;
        hardCnt = 0;
    	
    }


	public long getEasyCnt() {
		return easyCnt;
	}


	public void setEasyCnt(long easyCnt) {
		this.easyCnt = easyCnt;
	}


	public long getHardCnt() {
		return hardCnt;
	}


	public void setHardCnt(long hardCnt) {
		this.hardCnt = hardCnt;
	}


	public PrevQue_Easy_Hard getPrevQue_Easy_Hard() {
		return prevQue_Easy_Hard;
	}

	public void setPrevQue_Easy_Hard(PrevQue_Easy_Hard prevQue_Easy_Hard) {
		this.prevQue_Easy_Hard = prevQue_Easy_Hard;
	}

	public int getOptions() {
		return options;
	}



	public void setOptions(int options) {
		this.options = options;
	}



	public long getExamSeq() {
		return examSeq;
	}

	public void setExamSeq(long examSeq) {
		this.examSeq = examSeq;
	}

	public String getExamTitle() {
		return examTitle;
	}

	public void setExamTitle(String examTitle) {
		this.examTitle = examTitle;
	}

	public int getExamQcnt() {
		return examQcnt;
	}

	public void setExamQcnt(int examQcnt) {
		this.examQcnt = examQcnt;
	}

	public int getClassCode() {
		return classCode;
	}

	public void setClassCode(int classCode) {
		this.classCode = classCode;
	}

	public String getExamTestFileName() {
		return examTestFileName;
	}

	public void setExamTestFileName(String examTestFileName) {
		this.examTestFileName = examTestFileName;
	}

	public String getExamAnsFileName() {
		return examAnsFileName;
	}

	public void setExamAnsFileName(String examAnsFileName) {
		this.examAnsFileName = examAnsFileName;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchValue() {
		return searchValue;
	}

	public void setSearchValue(String searchValue) {
		this.searchValue = searchValue;
	}

	public long getStartRow() {
		return startRow;
	}

	public void setStartRow(long startRow) {
		this.startRow = startRow;
	}

	public long getEndRow() {
		return endRow;
	}

	public void setEndRow(long endRow) {
		this.endRow = endRow;
	}
    
    
	
}
