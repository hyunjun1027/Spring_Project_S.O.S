package com.sist.web.dao;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.sist.web.model.Account;
import com.sist.web.model.Board;
import com.sist.web.model.Teacher;
import com.sist.web.model.User;

@Repository("accountDao")
public interface AccountDao {
	// 회원 선택 return 각 객체
	public User userSelect(String userId);

	public Teacher teacherSelect(String userId);

	public User userOrTeacher(String userId);

	// 아이디 찾기 return String 아이디
	public String userIdSearch(String userName, String userEmail, String userPhone);

	public String teacherIdSearch(String userName, String userEmail, String userPhone);

	// 이메일 중복 체크
	public int userEmailCheck(String userEmail);

	public int teacherEmailCheck(String userEmail);

	// 회원가입
	public int userInsert(User user);

	public int teacherInsert(Teacher teacher);

	// 비밀번호 변경
	public int userPwdChange(String userId, String userPwd);

	public int teacherPwdChange(String userId, String userPwd);

	// status 변경
	public int userStatusUpdate(String userId, String status);

	public int teacherStatusUpdate(String userId, String status);

	// modDate update
	public int userModDateUpdate(String userId);

	public int teacherModDateUpdate(String userId);

	// 회원정보 수정
	public int userInfoUpdate(Account user);
	public int teacherInfoUpdate(Account teacher);
	public int userProfileUpdate(String userId, String userProfile);
	public int teacherProfileUpdate(String userId, String userProfile);


	public List<User> userNameSearch(String userName);
	
	// 내가 저장한 글 조회
	public List<Board> BookMarkList(Board board);

	// 내가 저장한 글수
	public long bookMarkListCount(Board board);

	// 내가 쓴 글
	public List<Board> selectboardList(Board board);

	// 내가 저장한 글수
	public long selectboardListCount(Board board);
}
