package com.sist.web.model;

import java.io.Serializable;

public class BoardNoticeFile implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private short fileSeq;		//파일번호(HIBBS_SEQ MAX+1)
	private long brdSeq;		//게시물 번호(TBL_HIBOARD:HIBBS_SEQ)
	private String fileName;	//파일명
	private String fileOrgName;	//원본파일명
	private String fileExt;		//파일 확장자
	private long fileSize;		//파일 크기
	private String regDate;		//등록일
	
	public BoardNoticeFile() {
		fileSeq = 0;
		brdSeq = 0;
		fileName = "";	
		fileOrgName = "";
		fileExt = "";	
		fileSize = 0;	
		regDate = "";
	}

	public short getFileSeq() {
		return fileSeq;
	}

	public void setFileSeq(short fileSeq) {
		this.fileSeq = fileSeq;
	}

	public long getBrdSeq() {
		return brdSeq;
	}

	public void setBrdSeq(long brdSeq) {
		this.brdSeq = brdSeq;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public String getFileOrgName() {
		return fileOrgName;
	}

	public void setFileOrgName(String fileOrgName) {
		this.fileOrgName = fileOrgName;
	}

	public String getFileExt() {
		return fileExt;
	}

	public void setFileExt(String fileExt) {
		this.fileExt = fileExt;
	}

	public long getFileSize() {
		return fileSize;
	}

	public void setFileSize(long fileSize) {
		this.fileSize = fileSize;
	}

	public String getRegDate() {
		return regDate;
	}

	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	
	
		
}
