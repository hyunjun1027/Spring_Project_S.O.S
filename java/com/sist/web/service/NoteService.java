package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.NoteDao;
import com.sist.web.model.Note;

@Service("noteService")
public class NoteService {

	private static Logger logger = LoggerFactory.getLogger(NoteService.class);

	@Autowired
	private NoteDao noteDao;

	// 쪽지 보내기
	public int noteInsert(Note note) {
		int count = 0;

		try {
			count = noteDao.noteInsert(note);
		} catch (Exception e) {
			logger.error("[NoteService] noteInsert Exception", e);
		}

		return count;
	}

	// 보낸 쪽지 리스트
	public List<Note> noteSendList(Note note) {
		List<Note> list = null;

		try {
			list = noteDao.noteSendList(note);
		} catch (Exception e) {
			logger.error("[NoteService] noteSendList Exception", e);
		}

		return list;
	}

	// 받은 쪽지 리스트
	public List<Note> noteGetList(Note note) {
		List<Note> list = null;

		try {
			list = noteDao.noteGetList(note);
		} catch (Exception e) {
			logger.error("[NoteService] noteGetList Exception", e);
		}

		return list;
	}

	// 보낸 쪽지 조회
	public Note noteSelect(long noteSeq) {
		Note note = null;

		try {
			note = noteDao.noteSelect(noteSeq);
		} catch (Exception e) {
			logger.error("[NoteService] noteSelect Exception", e);
		}

		return note;
	}

	// 쪽지 삭제
	public int noteDelete(long noteSeq) {
		int count = 0;

		try {
			count = noteDao.noteDelete(noteSeq);
		} catch (Exception e) {
			logger.error("[NoteService] noteDelete Exception", e);
		}

		return count;
	}

	// 보낸쪽지 수 카운트
	public int sendListCount(String userId) {
		int count = 0;

		try {
			count = noteDao.sendListCount(userId);
		} catch (Exception e) {
			logger.error("[NoteService] sendListCount Exception", e);
		}

		return count;
	}

	// 받은쪽지 수 카운트
	public int getListCount(String userIdGet) {
		int count = 0;

		try {
			count = noteDao.getListCount(userIdGet);
		} catch (Exception e) {
			logger.error("[NoteService] getListCount Exception", e);
		}

		return count;
	}

	// 받은 쪽지 클릭시 읽음상태 변경
	public int readChange(Note note) {
		int count = 0;

		try {
			count = noteDao.readChange(note);
		} catch (Exception e) {
			logger.error("[NoteService] readChange Exception", e);
		}

		return count;
	}

	// 받은 쪽지 중 안읽은 쪽지 카운트
	public int noreadCount(String userIdGet) {
		int count = 0;

		try {
			count = noteDao.noreadCount(userIdGet);
		} catch (Exception e) {
			logger.error("[NoteService] noreadCount Exception", e);
		}

		return count;
	}

}
