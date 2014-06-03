package kr.co.allpet.controller.client;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.EncodingUtil;
import kr.co.allpet.utils.common.SMSUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class JoinAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;
	
	private static final Logger logger = LoggerFactory.getLogger(JoinAction.class);
	
	/**
	 * 회원가입 : 회원가입폼
	 */
	@RequestMapping(value = { "*/joinTerms.latte", "*/join.latte" })
	public String joinTerms(Model model, @RequestParam(required=false) String msg) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinTerm");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == true) {
			return "redirect:home.latte";
		}
		
		model.addAttribute("msg", EncodingUtil.fromKorean(msg));
		
		return "client/join/joinForm";
	}
	
	@RequestMapping(value = { "*/joinAccept.latte"})
	public String joinAccept(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinTerm");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == true) {
			return "redirect:home.latte";
		}
		
		Map<String,String> jMap = new HashMap<String, String>();
		
		jMap.putAll(params);
		if (nullChk(jMap, "s_user_id").equals("Exception")) {
			model.addAttribute("msg", "기간이 만료 되어, 회원가입을 다시 진행하셔야 합니다.");
			return "redirect:joinTerms.latte";
		}
		
		/* 최종 가입 */
		String domain = request.getHeader("referer");//request.getRequestURL().toString();
		
		domain = domain.replace("http://", "");
		domain = domain.substring(0, domain.indexOf("/"));
		
		//System.out.println(domain);
		//model.addAttribute("domain", domain);
		
		// 병원 정보 가져오기
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		
		jMap.put("s_status", "Y");
		jMap.put("s_referer", hospitalInfo.get("s_hospital_id"));
		
		int result = SqlDao.insert("insertMember", jMap);
		
		return "client/join/join_step5";
	}
	
	
	/**
	 * 회원가입 : 이용약관
	 */
	@RequestMapping(value = "/joinTermsDetail.latte")
	public String joinTermsDetail(Model model, @RequestParam String type) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinTermsDetail");
		
		
		return "client/join/terms/terms";
	}
	
	/*
	 * 회원가입 : Step1
	 */
	@RequestMapping(value = "/joinStep.latte", params = "step=1")
	public String joinStep1(Model model, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinStep (step{})",  params.get("step"));
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == true) {
			return "redirect:home.latte";
		}
		
		
		return "client/join/join_step" + params.get("step");
	}
	
	/*
	 * 회원가입 : Step2
	 */
	@RequestMapping(value = "/joinStep.latte", params = "step=2")
	public String joinStep2(HttpServletRequest request, Model model, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinStep (step{})",  params.get("step"));
		
		HttpSession session = request.getSession();
		
		// Step1에서 저장된 내용 MAP 에 삽입
		if (session.getAttribute("jSession") == null) {
			session.setAttribute("jSession", params);
		}
		
		@SuppressWarnings("unchecked")
		Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
		
		if (nullChk(jMap, "s_user_id").equals("Exception")) {
			model.addAttribute("msg", "기간이 만료 되어, 회원가입을 다시 진행하셔야 합니다.");
			return "redirect:joinTerms.latte";
		}
		
		
		return "client/join/join_step" + params.get("step");
	}
	
	/*
	 * 회원가입 : Step3
	 */
	@RequestMapping(value = "/joinStep.latte", params = "step=3")
	public String joinStep3(Model model, HttpSession session, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinStep (step{})",  params.get("step"));
		
		@SuppressWarnings("unchecked")
		Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
		
		if (nullChk(jMap, "s_user_id").equals("Exception")) {
			model.addAttribute("msg", "기간이 만료 되어, 회원가입을 다시 진행하셔야 합니다.");
			return "redirect:joinTerms.latte";
		}
		
		// 인증번호 체크
		if (params.get("s_confirmNum") == null) {
			model.addAttribute("msg", "인증번호를 입력해주세요.");
			return "client/join/join_step2";
		}
		
		// 인증시간 체크
		long checkTime = System.currentTimeMillis() - Long.parseLong(jMap.get("_s_confirmTime"));
		
		if (checkTime > 1000 * 60 * 5) {
			model.addAttribute("msg", "휴대폰 인증시간을 초과하였습니다.");
			return "client/join/join_step2";
		}
		
		// 전화번호 하이픈 제거
		params.put("s_cphone_number", params.get("s_cphone_number").replaceAll("-", ""));
		
		if (!jMap.get("_s_cphone_number").equals(params.get("s_cphone_number"))) {
			model.addAttribute("msg", "인증받은 기기와 다른 기기입니다.");
			return "client/join/join_step2";
		}
		
		if (jMap.get("_s_confirmNum").equals(params.get("s_confirmNum"))) {
			// Step2에서 저장된 내용 MAP 삽입 후 SESSION 저장
			jMap.putAll(params);
			session.setAttribute("jSession", jMap);
		} else {
			model.addAttribute("msg", "인증번호가 틀렸습니다.");
			model.addAttribute("s_cphone_number", jMap.get("s_cphone_number"));
			return "client/join/join_step2";
		}
		
		
		return "client/join/join_step" + params.get("step");
	}
	
	/*
	 * 회원가입 : Step4
	 */
	@RequestMapping(value = "/joinStep.latte", params = "step=4")
	public String joinStep4(Model model, HttpSession session, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinStep (step{})",  params.get("step"));
		
		@SuppressWarnings("unchecked")
		Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
		
		if (nullChk(jMap, "s_user_id").equals("Exception")) {
			model.addAttribute("msg","기간이 만료 되어, 회원가입을 다시 진행하셔야 합니다.");
			return "redirect:joinTerms.latte";
		}
		
		// 이름 체크
		if (params.get("s_name") == null) {
			model.addAttribute("msg", "이름을 입력해주세요.");
			return "client/join/join_step3";
		}
		
		// 닉네임 체크
		if (params.get("s_nickname") == null) {
			model.addAttribute("msg", "닉네임을 입력해주세요.");
			return "client/join/join_step3";
		}
		
		// Step3에서 저장된 내용 MAP 삽입 후 SESSION 저장
		jMap.put("s_name", params.get("s_name"));
		jMap.put("s_nickname", params.get("s_nickname"));
		//jMap = Common.mapFromKorean(jMap);
		session.setAttribute("jSession", jMap);
		
		
		/* 생일 년도 설정을 위한 값 세팅 */
		String toYear = Calendar.getInstance().get(Calendar.YEAR) + "";
		model.addAttribute("toYear",toYear);
		
		return "client/join/join_step" + params.get("step");
	}
	
	/*
	 * 회원가입 : Step5
	 */
	@RequestMapping(value = "/joinStep.latte", params = "step=5")
	public String joinStep5(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - joinStep (step{})",  params.get("step"));
		
		@SuppressWarnings("unchecked")
		Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
		
		if (nullChk(jMap, "s_user_id").equals("Exception")) {
			model.addAttribute("msg", "기간이 만료 되어, 회원가입을 다시 진행하셔야 합니다.");
			return "redirect:joinTerms.latte";
		}
		
		/* 최종 가입 */
		// Step4에서 저장된 내용 MAP 삽입 후 SESSION 저장
		jMap.putAll(params);
		jMap.put("s_do", params.get("s_do"));
		jMap.put("s_sigu", params.get("s_sigu"));
		jMap.put("s_dong", params.get("s_dong"));
		jMap.put("s_location", jMap.get("s_do") + " " + jMap.get("s_sigu") + " " + jMap.get("s_dong"));
		jMap.put("d_birthday", jMap.get("s_birth_year") + "-" + jMap.get("s_birth_month") + "-" + jMap.get("s_birth_day"));
		
		// 아이피 정보 세팅
		String ipAddress  = request.getHeader("X-FORWARDED-FOR");   
		
        if(ipAddress == null) {   
          ipAddress = request.getRemoteAddr();   
        }
        
        jMap.put("s_reg_ip", ipAddress);
        jMap.put("s_last_login_ip", ipAddress);
        
        // 상태 세팅
        jMap.put("s_status", "Y");
		
        /** 데이터 입력전 아이디 체크 **/ 
        if (!Common.isNull(SqlDao.getString("getMail", jMap.get("s_user_id"))).equals("0")) {
        	model.addAttribute("msg", "오류 : 아이디 중복");
			return "redirect:joinTerms.latte";
        }
        
        /** 데이터 입력전 닉네임 체크 **/ 
        if (!Common.isNull(SqlDao.getString("getMemberNick", jMap.get("s_nickname"))).equals("0")) {
        	model.addAttribute("msg","오류 : 닉네임 중복");
			return "redirect:joinTerms.latte";
        }
        
        /** 데이터 입력전 휴대폰 체크 **/ 
        if (!Common.isNull(SqlDao.getString("getMemberHpNumber", jMap.get("s_cphone_number"))).equals("0")) {
        	model.addAttribute("msg", "오류 : 휴대폰 번호 중복");
			return "redirect:joinTerms.latte";
        }
        
        // 가입 경로 정보
        if (jMap.get("s_referer") == null || Common.isNull(jMap.get("s_referer")).equals("")) {
        	jMap.put("s_referer", Config.REFERER);	
        } 
     	
		int result = SqlDao.insert("insertMember", jMap);
		
		if (result > 0) {
			/*
			 * MAC 정보 향후 APP 개발시 추가 개발(예정)
			 */
			
			// 푸쉬 정보 등록
			jMap.put("s_push", "Y");
			
			int _oResult = SqlDao.insert("insertDuplicateMemberOption", jMap);
			
			if (_oResult > 0) {
				// 약관 업데이트
				jMap.put("s_agreement_state", "YYYY");
				int _aResult = SqlDao.insert("insertAgreementData", jMap);

				if (_aResult > 0) {
					
					// 메일 보내기 향후 개발(예정)
					model.addAttribute("msg", "회원가입을 축하드립니다.");
					
					// 사용자 URL 생성
//					String sUrl = SummaryURL.getInstance().getURL(jMap.get("s_uid"));
//				
//					if (sUrl != null && !sUrl.equals("")) {
//						jMap.put("s_recom_bt_url", sUrl);
//						
//						SqlDao.update("updateSummaryURL", jMap);
//						
//					}

					// 회원 가입 세션 종료
					String appType = (String) session.getAttribute("appType");
					session.invalidate();
					
					if (appType != null && appType.equals("")) {
						request.getSession().setAttribute("appType", appType);
					}
					
					// 메일 보내기
					String content = "<span style='display:block; color:#ff607f; font-weight:bold; padding-bottom:10px;'>beautylatte.co.kr 사이트 회원가입을 축하합니다!</span>"
									+ "<span style='color:#030303; font-weight:bold;'>" + jMap.get("s_name") + "님</span> 반갑습니다.<br/>"
									+ "beautylatte.co.kr 사이트에 회원가입을 해주셔서 감사 드립니다.<br />"
									+ "고객님이 만족하실 수 있도록 다양하고 질 높은 서비스를 제공하겠습니다.<br />"
									+ "감사합니다.";
					
					//MailSendUtil.getInstance().mailSend(jMap.get("s_user_id"), "뷰티라떼 회원가입을 축하드립니다.", content, jMap.get("s_uid"));
					
					//if (chk_qr.equals("Y")) {
					//	return "redirect:/event/qr.latte";
					//}
				}
				
			} else {
				
			}
			
			
		} else {
        	model.addAttribute("msg", "DB 입력시 오류 발생");
			return "redirect:joinTerms.latte";
		}
		
		/* DEV. INFO */
		if (Config.DEBUG) {
			System.out.println("-------------------------------------");
			System.out.println("* 회원 가입 정보");
			System.out.println("-------------------------------------");
			System.out.println("이 메 일 : " + jMap.get("s_user_id"));  
			System.out.println("암    호 : " + jMap.get("s_password"));  
			System.out.println("전화번호 : " + jMap.get("s_cphone_number"));  
			System.out.println("인증번호 : " + jMap.get("s_confirmNum"));  
			System.out.println("이    름 : " + jMap.get("s_name"));
			System.out.println("닉 네 임 : " + jMap.get("s_nickname"));
			System.out.println("지역정보 : " + jMap.get("s_location"));
			System.out.println("생년월일 : " + jMap.get("d_birthday"));
			System.out.println("아 이 피 : " + jMap.get("s_reg_ip"));
			System.out.println("최근정보 : " + jMap.get("s_last_login_ip"));
			System.out.println("상태정보 : " + jMap.get("s_status"));
			System.out.println("가입경로 : " + jMap.get("s_referer"));
			System.out.println("추 천 인 : " + jMap.get("s_recommender"));
			System.out.println("푸쉬정보 : " + jMap.get("s_push"));
			System.out.println("-------------------------------------");
		}
		
		return "client/join/join_step5";
	}
	
	/*
	 * AJAX - 이메일 체크
	 */
	@RequestMapping(value="*/ajaxEmailCheck.latte")
    public @ResponseBody String ajaxEmailCheck(@RequestParam String mail, HttpSession session) throws Exception   {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxEmailCheck");
		
		String _value = "";
		
		if (mail == null) {
			// 받아온 데이타 없음
			_value = "2000";
			return _value;
		}
		
		int _rCnt = Common.IntConvertNvl(SqlDao.getString("getMail", mail), 0);
		
		if (_rCnt == 0) {
			// 메일 없음 (성공)
			_value = "0000";
		} else {
			// 기존 가입자
			_value = "1000";
		}
		
		return _value;

    }
	
	
	/*
	 * AJAX - 인증번호 보내기 (회원가입, 휴대폰 변경)
	 */
	@RequestMapping(value="/ajaxHpAuthNumberSend.latte")
    public @ResponseBody String ajaxHpAuthNumberSend(@RequestParam String hpnum, HttpSession session) throws Exception   {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxHpAuthNumber");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		String 	_hpNum = Common.isNull(hpnum).replaceAll("\\p{Space}", "");
				_hpNum = Common.isNull(hpnum).replaceAll("-", "");
				
		String _authNum = "";
		
		String _value;
		
		if (!_hpNum.equals("")) {
				
			@SuppressWarnings("unchecked")
			Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
			
			if (sessionContext.isAuth() == false) {
				
				// 가입세션만료
				if(jMap == null) {
					_value = "9999";
					return _value;
				}
				
				// 기존에 핸드폰이 가입되어있는지 확인
				
				int _hpCnt = Common.IntConvert(Common.isNull(SqlDao.getString("getMemberHpNumber", _hpNum), "0"));
		
				if(_hpCnt != 0) {
					_value = "2000";
					return _value;
				}
			}
			
			// 인증번호 생성
			_authNum = Common.getRandomNumber(5);
			String smsMsg = "[뷰티라떼] 인증번호 [ " + _authNum +" ]를 입력해 주세요.";
			
			String result = "";
			
			if (sessionContext.isAuth() == false) {
				if(SMSUtil.getInstance().sendSMS(_hpNum, smsMsg, "회원가입")){
					result = "1";
				}
			} else {
				if(SMSUtil.getInstance().sendSMS(_hpNum, smsMsg, "휴대폰 변경")){
					result = "1";
				}
			}
			
			if (result.equals("1")) {

				if (sessionContext.isAuth() == false) {
				
					jMap.put("_s_cphone_number", _hpNum);
					jMap.put("_s_confirmNum", _authNum);
					jMap.put("_s_confirmTime", System.currentTimeMillis() + "");
				
					session.setAttribute("jSession", jMap);
					
				} else {
					
					sessionContext.getUserMap().put("_s_cphone_number", _hpNum);
					sessionContext.getUserMap().put("_s_confirmNum", _authNum);
					sessionContext.getUserMap().put("_s_confirmTime", System.currentTimeMillis() + "");
					
				}
				
				
				// 성공
				//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxHpAuthNumber : Auth.NO ({})", _authNum);
				
				_value="0000";
				
			} else {
				// 세션입력실패
				_value="9998";
			}
			
		} else {
			// 번호 없음
			_value="9997";	
		}
		
		return _value;

    }
	
	
	/*
	 * AJAX - 중복 닉네임 체크
	 */
	@RequestMapping(value="/ajaxNickCheck.latte")
    public @ResponseBody String ajaxNickCheck(@RequestParam String nick, HttpSession session) throws Exception   {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxNickNameCheck");

		String _value = "";
	
		nick = Common.isNull(nick).replaceAll(" ", "");
		
		/* 사용불가 닉네임 처리 */
		for (int i = 0; i < Config.validateNickNames.length; i++) {
			if(Config.validateNickNames[i].equals(nick)){
				_value = "2000";
				return _value;
			}
		}
		
		int _nChk = Common.IntConvertNvl(SqlDao.getString("getMemberNick", nick), 0);
		
		if (_nChk == 0) {
			// 닉네임 사용 가능
			//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxNickNameCheck : Nick ({})", nick);
			
			@SuppressWarnings("unchecked")
			Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
			
			jMap.put("s_nickname", nick);
			session.setAttribute("jSession", jMap);
			
			_value = "0000";
		} else {
			// 이미 사용 중
			_value = "1000";
		}
		
		return _value;

    }
	
	/*
	 * AJAX - 추천인 체크
	 */
	@RequestMapping(value="/ajaxRecomCheck.latte")
    public @ResponseBody String ajaxRecomCheck(@RequestParam Map<String, String> params, HttpSession session) throws Exception   {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxRecomChecks");

		String _value = "";
		
		/*
		 * recomType : 1 = 닉네임 , 2 = 휴대폰 , 3 = 이메일
		 */
		String _sql = "";
		
		params.put("recom", params.get("recom"));
		
		if (params.get("type").equals("1")) {
			
			_sql = "AND S_NICKNAME='" + params.get("recom") + "'";
			
		} else if (params.get("type").equals("2")) {
			
			_sql = "AND S_CPHONE_NUMBER='" + params.get("recom") + "'";
			
		} else if (params.get("type").equals("3")) {
			
			_sql = "AND S_USER_ID='" + params.get("recom") + "'";
			
		}
		
		String _recomUID = SqlDao.getString("getRecommenderUID", _sql);
		
		if (_recomUID != null) {
			// 추천인 있음
			
			@SuppressWarnings("unchecked")
			Map<String,String> jMap = (Map<String, String>) session.getAttribute("jSession");
			
			jMap.put("s_recommender",_recomUID);
			session.setAttribute("jSession", jMap);
			
			_value = "0000";
			
		} else {
			// 추천인 없음
			_value = "1000";
		}
		
		return _value;
	}
	
	private String nullChk(@SuppressWarnings("rawtypes") Map map, String key) {
	
		String isOK = "";
	
		
		try {

			if (map.get(key) == null) {
				isOK = "Exception";
			}

		} catch (NullPointerException e) {

			if (map == null) {
				isOK = "Exception";
			}

		}

		return isOK;
	}
}
