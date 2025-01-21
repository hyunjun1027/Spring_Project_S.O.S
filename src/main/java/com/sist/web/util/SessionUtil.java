/**
 * <pre>
 * 프로젝트명 : 공통모듈
 * 패키지명    : com.daekk.common.utils
 * 파일명       : SessionUtil.java
 * 작성일       : 2024. 9. 11.
 * 작성자       : daekk
 * </pre>
 */
package com.sist.web.util;

import javax.servlet.http.HttpSession;

import com.sist.common.util.StringUtil;

/**
 * <pre>
 * 패키지명   : com.fw.common.utils
 * 파일명     : SessionUtil.java
 * 작성일     : 2024. 9. 11.
 * 작성자     : daekk
 * 설명       : 세션 유틸리티
 * </pre>
 */
public final class SessionUtil
{
	private SessionUtil() {}
	
	/**
	 * <pre>
	 * 메소드명   : setSession
	 * 작성일     : 2024. 9. 11.
	 * 작성자     : daekk
	 * 설명       : 세션 저장
	 * </pre>
	 * @param session HttpSession
	 * @param name    세션명
	 * @param value   세션값
	 * @return boolean
	 */
	public static boolean setSession(HttpSession session, String name, Object value)
	{
		if(session != null && !StringUtil.isEmpty(name) && value != null)
		{
			try
			{
				session.setAttribute(name, value);
				
				return true;
			}
			catch(Exception e)
			{
				return false;
			}
		}
		
		return false;
	}
	
	/**
	 * <pre>
	 * 메소드명   : getSession
	 * 작성일     : 2024. 9. 11.
	 * 작성자     : daekk
	 * 설명       : 세션 가져오기
	 * </pre>
	 * @param session HttpSession
	 * @param name    세션명
	 * @return Object
	 */
	public static Object getSession(HttpSession session, String name)
	{
		Object value = null;
		
		if(session != null && !StringUtil.isEmpty(name))
		{
			try
			{
				value = session.getAttribute(name);
			}
			catch(Exception e)
			{
				
			}
		}
		
		return value;
	}
	
	/**
	 * <pre>
	 * 메소드명   : removeSession
	 * 작성일     : 2024. 9. 11.
	 * 작성자     : daekk
	 * 설명       : 세션 삭제
	 * </pre>
	 * @param session HttpSession
	 * @param name    세션명
	 */
	public static void removeSession(HttpSession session, String name)
	{
		if(session != null && !StringUtil.isEmpty(name))
		{
			try
			{
				session.removeAttribute(name);
			}
			catch(Exception e)
			{
				
			}
		}
	}
	
	/**
	 * <pre>
	 * 메소드명   : invalidate
	 * 작성일     : 2024. 9. 11.
	 * 작성자     : daekk
	 * 설명       : 세션 모두 삭제
	 * </pre>
	 * @param session HttpSession
	 */
	public static void invalidate(HttpSession session)
	{
		if(session != null)
		{
			try
			{
				session.invalidate();
			}
			catch(Exception e)
			{
				
			}
		}
	}
}
