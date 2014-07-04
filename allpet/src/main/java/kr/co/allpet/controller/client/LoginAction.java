package kr.co.allpet.controller.client;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Codes;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.JSONSimpleBuilder;
import kr.co.allpet.utils.common.LogUtil;
import kr.co.allpet.utils.common.SMSUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class LoginAction {
	
	private static final Logger logger = LoggerFactory.getLogger(LoginAction.class);
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;
	
	/**
	 * Login
	 */
	@RequestMapping(value = "*/login.latte")
	public String login(	Model model, 
							HttpServletRequest request, 
							@RequestParam Map<String, String> params, 
							@RequestParam(required=false) String msg	
							) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - login : {}", Common.isNull(params.get("type"),"1") + " (rePage : " + Common.isNull(params.get("rePage"), "Not") + ")");
		
        SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
        
		if (sessionContext.isAuth() == true) {
			// 세션을 가지고 있다면 메인으로 점프
			String s = sessionContext.getUserMap().get("preLoginPage");
			if(Common.isValid(s))
				return "redirect:"+s;
		}
		
		try {
			if (params.get("s_user_id") != null && !params.get("s_user_id").equals("")) {
				model.addAttribute("s_user_id", params.get("s_user_id"));
			}
		} catch (NullPointerException e) {
			
		}
		
		// 홈페이지 링크 가져오기
		String domain = request.getRequestURL().toString();
		
		domain = domain.replace("http://", "");
		domain = domain.substring(0, domain.indexOf("/"));
		
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		if(hospitalInfo != null){
			model.addAttribute("homePage", "hospitalHome.latte?idx="+hospitalInfo.get("s_sid"));
		}
		
		model.addAttribute("msg", msg);
		model.addAttribute("prePage", Common.isNull(request.getHeader("Referer")));
		model.addAttribute("rePage", Common.isNull(params.get("rePage")));
		model.addAttribute("type", Common.isNull(params.get("type")));
		
		return "client/login/login";
	}
	
	/*
	 *  통합 계정 로그인
	 */
	@RequestMapping(value = "*/loginAccept.latte")
	public String loginAccept(Model model, HttpServletRequest request, SessionContext sessionContext, @RequestParam Map<String, String> params, RedirectAttributes redirectAttributes) {
		
		
		Map<String, String> sMap = SqlDao.getMap("getMemberInfo", params);

		try{
			try{
				params.put("rePage", URLDecoder.decode(params.get("rePage"), "UTF8"));
				
				if( redirectAttributes != null ){
					redirectAttributes.addAttribute("s_user_id", URLDecoder.decode(params.get("s_user_id"), "UTF8"));
					redirectAttributes.addAttribute("rePage", URLDecoder.decode(params.get("rePage"), "UTF8"));
				}
				
			}catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}catch(NullPointerException en){}
		
		String api = Common.isNull(params.get("api"));
		
		if (!api.equals("")) {
			api = "APP_BT";
		} else {
			api = "WEB_BT";
		}
		
		if (sMap != null) {

			if (sMap.get("s_status").equals("Y")) {
				/* 정상적으로 로그인 됐을 경우 */
				// 로그인 후 프로세스
				login_process(request, sessionContext, sMap);
				 
				//HttpSession session = request.getSession();
				
				//session.setAttribute("adminFlag", "N");
				
				/* 로그인 정보 LOG WRITE : 시작 ************************************************************************/
				
				try {
					sessionContext = (SessionContext) sessionContextFactory.getObject();
					
					if(Common.isValid(params.get("prePage")))
						sessionContext.getUserMap().put("preLoginPage", params.get("prePage"));
					
				} catch (Exception e) {				
					
				}
				
				if (Config.DEBUG) {
					LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_DEV, "bt_login", "|", "", sessionContext.getUserMap().get("s_referer"), api, "L000");
				} else {
					LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_LOGIN, "bt_login", "|", "", sessionContext.getUserMap().get("s_referer"), api, "L000");
				}
				
				/* 로그인 정보 LOG WRITE : 끝남 ************************************************************************/
				
				return "redirect:" + Common.isNull(params.get("rePage"), "home.latte");
				
				
				
			} else {
				// 정상 회원이 아닐경우 처리
				model.addAttribute("msg", "정상적인 회원이 아닙니다. 고객센터에 문의 바랍니다. (오류코드 : L001)");
				model.addAttribute("rePage", Common.isNull(params.get("rePage")));
				model.addAttribute("type", Common.isNull(params.get("type")));
				
				/* 로그인 정보 LOG WRITE : 시작 ************************************************************************/
				
				try {
					sessionContext = (SessionContext) sessionContextFactory.getObject();
				} catch (Exception e) {				
					
				}
				
				if (Config.DEBUG) {
					LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_DEV, "bt_login", "|", "", params.get("s_user_id"), api, "L001");
				} else {
					LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_LOGIN, "bt_login", "|", "", params.get("s_user_id"), api, "L001");
				}
				
				/* 로그인 정보 LOG WRITE : 끝남 ************************************************************************/
				
				return "redirect:" + Common.isNull(params.get("rePage"), "login");
			}
			
		} else {
			model.addAttribute("msg", "아이디 또는 비밀번호가 틀렸습니다.");
			
			/* 로그인 정보 LOG WRITE : 시작 ************************************************************************/
			
			try {
				sessionContext = (SessionContext) sessionContextFactory.getObject();
			} catch (Exception e) {				
				
			}
			
			if (Config.DEBUG) {
				LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_DEV, "bt_login", "|", "", params.get("s_user_id"), api, "L002");
			} else {
				LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_LOGIN, "bt_login", "|", "", params.get("s_user_id"), api, "L002");
			}
			
			/* 로그인 정보 LOG WRITE : 끝남 ************************************************************************/
			
			return "redirect:login.latte";
			
		}
		
	}
	
	@RequestMapping(value = "/directLogin.latte")
	public String directLogin(Model model, HttpServletRequest request, SessionContext sessionContext, @RequestParam Map<String, String> params) {
		
		String domain = request.getRequestURL().toString();
		
		domain = domain.replace("http://", "");
		domain = domain.substring(0, domain.indexOf("/"));
		
		// 병원 정보 가져오기
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		
		String type = params.get("type");
		
		// default 
		String returnUrl = "redirect:"+hospitalInfo.get("s_hospital_id")+"/loginAccept.latte" + 
								"?s_user_id=" + params.get("s_user_id") + 
								"&s_password="+params.get("s_password") + 
								"&rePage="+params.get("rePage");
		
		if( type != null && type.equals("SCHEDULE")){
			
			// 로그인 후 원하는 페이지로 이동
			String result = loginAccept(model, request, sessionContext, params, null);
			if( result.indexOf("home.latte") > 0 ){
				returnUrl = "redirect:"+hospitalInfo.get("s_hospital_id")+"/myPageScheduleEdit.latte" + 
						"?rownum=" + params.get("rownum");
			}else{
				returnUrl = result;
			}
		}
		
		return returnUrl;
	}
	
	@RequestMapping(value = "*/ajaxLogout.latte")
	public @ResponseBody String ajaxLogout(Model model, HttpSession session) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - logout");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		//String rtnUrl = "redirect:hospitalHome.latte?idx=s_sid001";
		
		//if(session.getAttribute("personalFlag").equals("Y")){
		//	rtnUrl = "redirect:"+(String) session.getAttribute("s_per_domain");
		//}
		
		if (sessionContext.isAuth() == false) {
			//return rtnUrl;
		}
		
		session.invalidate();
		return "";//rtnUrl;
	}
	
	
	@RequestMapping(value = "*/ajaxFindIDAccept.latte")
	public @ResponseBody String ajaxFindIDAccept(Model model, HttpServletRequest request, @RequestParam(required=false) String phone_number) {
		
		//if (Config.DEBUG) logger.info("ajaxFindIDAccept.latte");
		
		String id = Common.isNull(SqlDao.getString("getID", phone_number));
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if(id == null || id.equals("")) {
			
			b.add("result", Codes.ERROR_QUERY_PROCESSED);
		}
		else{
		
			b.add("result", Codes.SUCCESS_CODE);
			b.add("id", id);
		}
		
		return b.build();
	}
	
	/**
	 * 비밀번호 찾기
	 */
	@RequestMapping(value = "*/ajaxFindPWAccept.latte")
	public @ResponseBody String ajaxFindPWAccept(Model model, HttpServletRequest request, @RequestParam(required=false) Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("ajaxFindPWAccept.latte");
		
		// 전화번호 하이픈 제거
		params.put("phone_number", params.get("phone_number").replaceAll("-", ""));
		
		String tempPW = Common.isNull(SqlDao.getString("getTempPW", params));
		
		JSONSimpleBuilder b = new JSONSimpleBuilder();
		
		if (!tempPW.equals("")) {
			
			// 기존 비밀번호 업데이트
			params.put("pw", tempPW);
			int result = SqlDao.update("updatePW", params);
			
			if (result > 0) {
				// SMS발송
				
				String smsMsg = "임시비밀번호 발급 [ " + tempPW + " ]로 비밀번호가 변경되었습니다.";
				
				boolean smsInfo = SMSUtil.getInstance().sendSMS(params.get("phone_number"), smsMsg, "비밀번호찾기");
				
				if (smsInfo == true) {
					b.add("result", Codes.SUCCESS_CODE);
					//model.addAttribute("msg", "임시비밀번호가 발송되었습니다.");
				} else {
					b.add("result", Codes.ERROR_FAILED_SMS_SNED);
					//model.addAttribute("msg", "문자메세지 발송 오류 (오류코드 : 6520)");
				}
				
			}
			
			
		} else {
			b.add("result", Codes.ERROR_QUERY_PROCESSED);
			//model.addAttribute("msg", "입력하신 정보의 데이터가 없습니다.");
		}
		
		
		return b.build();
	}
	
	/**
	 * 공통 로그인 프로세스 메소드
	 * (뷰티, 애드라떼 통합 프로세스) 
	 */
	private void login_process(HttpServletRequest request, SessionContext sessionContext, Map<String, String> map) {
		
		// 로그인 아이피 정보 수집
		try {
			String ipAddress  = request.getHeader("X-FORWARDED-FOR");
			
	        if(ipAddress == null) {   
	          ipAddress = request.getRemoteAddr();   
	        } 
	        
	        map.put("s_last_login_ip", ipAddress);
	        
	        int ipResult = SqlDao.update("updateMemberIPInfo", map);
	        
	        if (ipResult != 1) {
	        	logger.info("[ERROR] Method - loginAccept : Latest IP Address change error. (IP:{})", ipAddress);
	        }
	        
	        // 사용자 URL 생성 업데이트
//	        int _sUrl = Common.IntConvertNvl(SqlDao.getString("getSummaryURL", map), 0);
//	        
//	        if (_sUrl == 0) {
//	        	
//	        	String sUrl = SummaryURL.getInstance().getURL(map.get("s_uid"));
//	        	
//	        	if (sUrl != null && !sUrl.equals("")) {
//	        		map.put("s_recom_bt_url", sUrl);
//	        		
//	        		SqlDao.update("updateSummaryURL", map);
//	        		
//	        	}
//	        }
	        
		} catch (Exception e) {
			e.printStackTrace();
		}
        
        // 기기 MAC Address 변경(예정)
        
        // 지역설정(예정)
        
        // 로그인 정보 세션 저장 (어플 연동 try, catch)
       try {
    	
    	   sessionContext = (SessionContext) sessionContextFactory.getObject();
       
       } catch (Exception e) {
    	  
       } finally {
    	   sessionContext.setAuth(true);
           sessionContext.setUserMap(map);
       }
       
        
/*       // 접속 정보 저장
       try {
    	   
    	   if (request.getSession().getAttribute("appType") == null) {
    		   request.getSession().setAttribute("appType", "");
    	   }
    	   
    	   if (!request.getSession().getAttribute("appType").equals("AndroidWebView") || request.getSession().getAttribute("appType").equals("IOSWebView")){
    		   AnalysisUtil.getInstance().setAnalysis(request, map.get("s_uid"), "LOGIN", map.get("s_user_id"), "", map.get("s_name"));
    	   }

       } catch (NullPointerException e) {
    	   
    	   System.out.println("Login : APPLICATION TYPE > NullPointerException (BeautyLatte^^)");
    	   
       }*/
		
        
	}
	
//	private void admin_login_process(HttpServletRequest request, SessionContext sessionContext, Map<String, String> map) {
//
//		try {
//			sessionContext = (SessionContext) sessionContextFactory.getObject();
//		} catch (Exception e) {
//			
//		} finally {
//			sessionContext.setAdminAuth(true);
//			sessionContext.setUserMap(map);
//		}
//	}
}
