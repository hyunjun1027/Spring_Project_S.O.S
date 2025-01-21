package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Note;

@Repository("noteDao")
public interface NoteDao {
	// 쪽지 보내기
	public int noteInsert(Note note);

	// 보낸 쪽지 리스트
	public List<Note> noteSendList(Note note);

	// 받은 쪽지 리스트
	public List<Note> noteGetList(Note note);

	// 쪽지 조회
	public Note noteSelect(long noteSeq);

	// 쪽지 삭제
	public int noteDelete(long noteSeq);

	// 보낸쪽지 수 카운트
	public int sendListCount(String userId);

	// 받은쪽지 수 카운트
	public int getListCount(String userIdGet);

	// 받은 쪽지 클릭시 읽음상태 변경
	public int readChange(Note note);

	// 받은 쪽지 중 안읽은 쪽지 카운트
	public int noreadCount(String userIdGet);
}
