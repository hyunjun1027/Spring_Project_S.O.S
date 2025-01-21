package com.sist.web.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.web.dao.AccountDao;
import com.sist.web.model.Account;
import com.sist.web.model.Board;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;

@Service("accountService")
public class AccountService {
	private static Logger logger = LoggerFactory.getLogger(AccountService.class);

	@Autowired
	private AccountDao accountDao;

	// 학생인지 강사인지 판별하기 위한 조회
	public User userOrTeacher(String userId) {
		User user = null;

		try {
			user = accountDao.userOrTeacher(userId);
		} catch (Exception e) {
			logger.error("[accountService] userSelect Exception", e);
		}

		return user;
	}

	// 일반 유저 조회
	public User userSelect(String userId) {
		User user = null;

		try {
			user = accountDao.userSelect(userId);
		} catch (Exception e) {
			logger.error("[accountService] userSelect Exception", e);
		}

		return user;
	}

	// 강사 조회
	public Teacher teacherSelect(String userId) {
		Teacher teacher = null;

		try {
			teacher = accountDao.teacherSelect(userId);
		} catch (Exception e) {
			logger.error("[accountService] teacherSelect Exception", e);
			;
		}

		return teacher;
	}

	// 일반 유저 아이디 찾기
	public String userIdSearch(String userName, String userEmail, String userPhone) {
		String userId = "";

		try {
			userId = accountDao.userIdSearch(userName, userEmail, userPhone);
		} catch (Exception e) {
			logger.error("[accountService] userIdSearch Exception", e);
		}

		return userId;
	}

	// 강사 아이디 찾기
	public String teacherIdSearch(String userName, String userEmail, String userPhone) {
		String userId = "";

		try {
			userId = accountDao.teacherIdSearch(userName, userEmail, userPhone);
		} catch (Exception e) {
			logger.error("[accountService] teacherIdSearch Exception", e);
		}

		return userId;
	}

	// 일반 유저 이메일 중복체크
	public int userEmailCheck(String userEmail) {
		int count = 0;

		try {
			count = accountDao.userEmailCheck(userEmail);
		} catch (Exception e) {
			logger.error("[accountService] userEmailCheck Exception", e);
		}

		return count;
	}

	// 강사 이메일 중복체크
	public int teacherEmailCheck(String userEmail) {
		int count = 0;

		try {
			count = accountDao.teacherEmailCheck(userEmail);
		} catch (Exception e) {
			logger.error("[accountService] teacherEmailCheck Exception", e);
		}

		return count;
	}

	// 일반회원 회원가입
	public int userInsert(User user) {
		int count = 0;
		try {
			count = accountDao.userInsert(user);
		} catch (Exception e) {
			logger.error("[accountService] userInsert Exception", e);
		}
		return count;
	}

	// 강사 회원가입
	public int teacherInsert(Teacher teacher) {
		int count = 0;
		try {
			count = accountDao.teacherInsert(teacher);
		} catch (Exception e) {
			logger.error("[accountService] teacherInsert Exception", e);
		}
		return count;
	}

	// 일반회원 비밀번호 변경
	public int userPwdChange(String userId, String userPwd) {
		int count = 0;
		try {
			count = accountDao.userPwdChange(userId, userPwd);
		} catch (Exception e) {
			logger.error("[accountService] userPwdChange Exception", e);
		}
		return count;
	}

	// 강사 비밀번호 변경
	public int teacherPwdChange(String userId, String userPwd) {
		int count = 0;
		try {
			count = accountDao.teacherPwdChange(userId, userPwd);
		} catch (Exception e) {
			logger.error("[accountService] teacherPwdChange Exception", e);
		}
		return count;
	}

	// 일반회원 status 변경
	public int userStatusupdate(String userId, String status) {
		int count = 0;
		try {
			count = accountDao.userStatusUpdate(userId, status);
		} catch (Exception e) {
			logger.error("[accountService] userStatusupdate Exception", e);
		}
		return count;
	}

	// 강사 status 변경
	public int teacherStatusupdate(String userId, String status) {
		int count = 0;
		try {
			count = accountDao.teacherStatusUpdate(userId, status);
		} catch (Exception e) {
			logger.error("[accountService] teacherStatusupdate Exception", e);
		}
		return count;
	}

	// modDate update
	public int userModDateUpdate(String userId) {
		int count = 0;
		try {
			count = accountDao.userModDateUpdate(userId);
		} catch (Exception e) {
			logger.error("[accountService] userModDateUpdate Exception", e);
		}
		return count;
	}

	public int teacherModDateUpdate(String userId) {
		int count = 0;
		try {
			count = accountDao.teacherModDateUpdate(userId);
		} catch (Exception e) {
			logger.error("[accountService] teacherModDateUpdate Exception", e);
		}
		return count;
	}

	// 일반회원정보 변경
	public int userInfoUpdate(Account user) {
		int count = 0;
		try {
			count = accountDao.userInfoUpdate(user);
		} catch (Exception e) {
			logger.error("[accountService] userInfoUpdate Exception", e);
		}

		return count;
	}
	// 강사정보 변경
		public int teacherInfoUpdate(Account teacher) {
			int count = 0;
			try {
				count = accountDao.teacherInfoUpdate(teacher);
			} catch (Exception e) {
				logger.error("[accountService] teacherInfoUpdate Exception", e);
			}

			return count;
		}

	public int userProfileUpdate(String userId, String userProfile) {
		int count = 0;
		try {
			count = accountDao.userProfileUpdate(userId, userProfile);
		} catch (Exception e) {
			logger.error("[accountService] userProfileUpdate Exception", e);
		}

		return count;
	}
	public int teacherProfileUpdate(String userId, String userProfile) {
		int count = 0;
		try {
			count = accountDao.teacherProfileUpdate(userId, userProfile);
		} catch (Exception e) {
			logger.error("[accountService] teacherProfileUpdate Exception", e);
		}

		return count;
	}
	
	//쪽지에서 받는사람 아이디 찾기
	public List<User> userNameSearch(String userName){
		List<User> list = null;

		try {
			list = accountDao.userNameSearch(userName);
		} catch (Exception e) {
			logger.error("[accountService] userNameSearch Exception", e);
		}

		return list;
	}

	// 내가 저장한 글 조회
	public List<Board> BookMarkList(Board board) {
		List<Board> list = null;

		try {
			list = accountDao.BookMarkList(board);
		} catch (Exception e) {
			logger.error("[accountService] BookMarkList Exception", e);
		}

		return list;
	}

	// 내가 저장한 글수
	public long bookMarkListCount(Board board) {
		long count = 0;

		try {
			count = accountDao.bookMarkListCount(board);
		} catch (Exception e) {
			logger.error("[accountService] bookMarkListCount Exception", e);
		}

		return count;
	}

	// 내가 쓴 글
	public List<Board> selectboardList(Board board) {
		List<Board> list = null;

		try {
			list = accountDao.selectboardList(board);
		} catch (Exception e) {
			logger.error("[accountService] selectboardList Exception", e);
		}

		return list;
	}

	// 내가 저장한 글수
	public long selectboardListCount(Board board) {
		long count = 0;

		try {
			count = accountDao.selectboardListCount(board);
		} catch (Exception e) {
			logger.error("[accountService] selectboardListCount Exception", e);
		}

		return count;
	}

}
