package com.sist.web.model;

import java.io.Serializable;

public class CourseListFile implements Serializable {

	private static final long serialVersionUID = 1L;
	
	private long fileSeq;
	private long brdSeq;
	private String fileName;
	private String fileOrgName;
	private String fileExt;
	private long fileSize;
	private String regDate;
	private long courseCode;
	
	public CourseListFile() {
		fileSeq = 0;
		brdSeq = 0;
		fileName = "";
		fileOrgName = "";
		fileExt = "";
		fileSize = 0;
		regDate = "";
		courseCode = 0;
	}

	public long getFileSeq() {
		return fileSeq;
	}

	public void setFileSeq(long fileSeq) {
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

	public long getCourseCode() {
		return courseCode;
	}

	public void setCourseCode(long courseCode) {
		this.courseCode = courseCode;
	}
	
	
	

}
