package com.sist.web.dao;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Mail;

@Repository("mailDao")
public interface MailDao {
	// 인증번호 조회(select)
	public Mail mailSelect(String userEmail);

	// 인증번호 발급(insert)
	public int mailInsert(Mail mail);

	// 인증번호 삭제(delete)
	public int mailDelete(String userEmail);

	// 인증번호 재발급(update)
	public int mailUpdate(Mail mail);
}
