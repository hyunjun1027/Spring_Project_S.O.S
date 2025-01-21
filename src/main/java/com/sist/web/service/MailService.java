package com.sist.web.service;

import java.io.File;

import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import com.sist.web.dao.MailDao;
import com.sist.web.model.Mail;

@Service("mailService")
public class MailService {

	private static Logger logger = LoggerFactory.getLogger(MailService.class);

	@Autowired
	private JavaMailSender mailSender;
	@Autowired
	private MailDao mailDao;
	
//	@Value("#{env['email.logo.dir']}")
//	private String emailLogoPath;
	
	@Value("classpath:/img/logo_black.png")
	private Resource logoResources;

	@Async
	public void sendMail(String to, String subject, String body) {
		MimeMessage message = mailSender.createMimeMessage();
		try {
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");

			// 메일 수신 시 표시될 이름 설정
			messageHelper.setFrom("ssangyong_study@gmail.com", "S.O.S");
			messageHelper.setSubject(subject);
			messageHelper.setTo(to);
			messageHelper.setText(body, true);
			
			FileSystemResource logo = new FileSystemResource("C:/project/webapps/sos/src/main/webapp/WEB-INF/views/resources/img/logo_black.png");
			messageHelper.addInline("logo", logo);
			
			mailSender.send(message);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ========================================================================================================================================================================================================
	// 인증번호 조회
	public Mail mailSelect(String userEmail) {
		Mail mail = null;

		try {
			mail = mailDao.mailSelect(userEmail);
		} catch (Exception e) {
			logger.error("[MailService] mailSelect Exception", e);
		}

		return mail;
	}

	// ========================================================================================================================================================================================================
	// 인증번호 발급
	public int mailInsert(Mail mail) {
		int count = 0;

		try {
			count = mailDao.mailInsert(mail);
		} catch (Exception e) {
			logger.error("[MailService] mailInsert Exception", e);
		}

		return count;
	}

	// ========================================================================================================================================================================================================
	// 인증번호 삭제
	public int mailDelete(String userEmail) {
		int count = 0;

		try {
			count = mailDao.mailDelete(userEmail);
		} catch (Exception e) {
			logger.error("[MailService] mailDelete Exception", e);
		}

		return count;
	}

	// ========================================================================================================================================================================================================
	// 인증번호 재발급
	public int mailUpdate(Mail mail) {
		int count = 0;

		try {
			count = mailDao.mailUpdate(mail);
		} catch (Exception e) {
			logger.error("[MailService] mailUpdate Exception", e);
		}

		return count;
	}

}
