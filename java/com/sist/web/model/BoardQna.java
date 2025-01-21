package com.sist.web.model;

import java.io.Serializable;

public class BoardQna implements Serializable {

    private static final long serialVersionUID = 1L;

    private long brdSeq;             // 게시물 번호
    private String brdTitle;         // 게시물 제목
    private String brdContent;       // 게시물 내용
    private int brdReadCnt;          // 게시물 조회수
    private long brdParent;          // 부모 게시물 번호
    private String regDate;          // 게시물 작성일
    private String modDate;          // 게시물 수정일
    private String delDate;          // 게시물 삭제일
    private String brdPwd;           // 게시물 비밀번호
    private String userId;           // 유저 아이디
    private String userName;         // 유저 이름
    private String userEmail;        // 유저 이메일
    private String searchType;       // 검색타입 (1:이름, 2:제목, 3:내용)
    private String searchValue;      // 검색값
    private boolean hasReply;        // 답변 여부
    private String fileOrgName;      // 원본파일명
    private String fileName;         // 서버파일명
    private long startRow;           // 시작페이지 rownum
    private long endRow;             // 끝페이지 rownum

    private BoardQnaFile boardQnaFile;
    private BoardQnaFile boardCommQnaFile; // 답글 이미지


    // 기본 생성자
    public BoardQna() {
        brdSeq = 0;                  
        brdTitle = "";               
        brdContent = "";             
        brdReadCnt = 0;              
        brdParent = 0;               
        regDate = "";                
        modDate = "";                
        delDate = "";                
        brdPwd = "";                 
        userId = "";                 
        userName = "";               
        userEmail = "";              
        hasReply = false;            
        searchType = "";             
        searchValue = "";            
        fileOrgName = "";            
        fileName = "";               
        startRow = 0;                
        endRow = 0;                  
        boardQnaFile = null;         
        boardCommQnaFile = null;     
    }


    public BoardQnaFile getBoardCommQnaFile() {
        return boardCommQnaFile;
    }

    public void setBoardCommQnaFile(BoardQnaFile boardCommQnaFile) {
        this.boardCommQnaFile = boardCommQnaFile;
    }

    public void setHasReply(boolean hasReply) {
        this.hasReply = hasReply;
    }

    public boolean isHasReply() {
        return hasReply;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public long getBrdSeq() {
        return brdSeq;
    }

    public void setBrdSeq(long brdSeq) {
        this.brdSeq = brdSeq;
    }

    public String getBrdTitle() {
        return brdTitle;
    }

    public void setBrdTitle(String brdTitle) {
        this.brdTitle = brdTitle;
    }

    public String getBrdContent() {
        return brdContent;
    }

    public void setBrdContent(String brdContent) {
        this.brdContent = brdContent;
    }

    public int getBrdReadCnt() {
        return brdReadCnt;
    }

    public void setBrdReadCnt(int brdReadCnt) {
        this.brdReadCnt = brdReadCnt;
    }

    public long getBrdParent() {
        return brdParent;
    }

    public void setBrdParent(long brdParent) {
        this.brdParent = brdParent;
    }

    public String getRegDate() {
        return regDate;
    }

    public void setRegDate(String regDate) {
        this.regDate = regDate;
    }

    public String getModDate() {
        return modDate;
    }

    public void setModDate(String modDate) {
        this.modDate = modDate;
    }

    public String getDelDate() {
        return delDate;
    }

    public void setDelDate(String delDate) {
        this.delDate = delDate;
    }

    public String getBrdPwd() {
        return brdPwd;
    }

    public void setBrdPwd(String brdPwd) {
        this.brdPwd = brdPwd;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
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

    public String getFileOrgName() {
        return fileOrgName;
    }

    public void setFileOrgName(String fileOrgName) {
        this.fileOrgName = fileOrgName;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
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

    public BoardQnaFile getBoardQnaFile() {
        return boardQnaFile;
    }

    public void setBoardQnaFile(BoardQnaFile boardQnaFile) {
        this.boardQnaFile = boardQnaFile;
    }
}
