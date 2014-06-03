package kr.co.allpet.controller.client.mypage;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.CommonProcess;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.EncodingUtil;
import kr.co.allpet.utils.common.PageUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyPageAction {
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageAction.class);
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	/**
	 * 마이페이지 메인
	 * 
	 * @author 박주엽
	 * @date 2013. 12. 3.
	 */
	@RequestMapping(value="*/myPageHome.latte")
	public String myPageHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		logger.info("myPageHome.latte");
		
		// 로그인 확인
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
		// 병원id가 정상적이지 않음
		if(sid==null){
			return "client/error/domain_error";
		}
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageHome.latte";
		
		// 유저정보
		model.addAttribute("userInfo", sessionContext.getUserMap());
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		// 스케줄 정보 리스트
//		List list = SqlDao.getList("User.Schedule.getNearestList", params);
		List list = SqlDao.getList("User.Schedule.v2.getNearestList", params);
		model.addAttribute("userTodoList", list);
		// 가장 최근
		model.addAttribute("ef_nearest", SqlDao.getMap("User.Schedule.getEffectiveNearset", params.get("uid")));
		
		// 포인트 정보 리스트
		list = SqlDao.getList("MyPage.getUserPointAll", params.get("uid"));
		model.addAttribute("pointList", list);
		
		// 펫 정보 리스트
		model.addAttribute("petList", SqlDao.getList("MyPage.getPetInfoByUID", params.get("uid")));
		
//		// 홈페이지 링크 가져오기
//		String domain = request.getRequestURL().toString();
//		
//		domain = domain.replace("http://", "");
//		domain = domain.substring(0, domain.indexOf("/"));
//		
//		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
//		if(hospitalInfo != null){
//			model.addAttribute("homePage", "hospitalHome.latte?idx="+params.get("idx"));//hospitalInfo.get("s_sid"));
		//
		
		model.addAttribute("params", params);
		
		return "client/mypage/mypage_home";
	}
	
	/**
	 * 포인트 내역 페이지
	 */
	@RequestMapping(value="*/myPagePointHistory.latte")
	public String myPagePointHistory(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		logger.info("myPagePointHistory.latte");
		
		// 로그인 확인
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
		// 병원id가 정상적이지 않음
		if(sid==null){
			return "client/error/domain_error";
		}
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageHome.latte";
		
		// 만약 sid가 request로 안 왔다면 마이페이지로 다시.
		if(!Common.isValid(params.get("sid")))
			return "redirect:myPageHome.latte";
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		Map<String,String> map = SqlDao.getMap("MyPage.getTotalUserPoint", params);
		//Map<String,String> map1 = SqlDao.getMap("MyPage.getUserPointAll", params.get("uid"));
		//map.putAll(map1);
		
		model.addAttribute("total", map);
		
		if(map==null)
			params.put("totalCount", "0");
		else
			params.put("totalCount", Common.toString(map.get("cnt")));
		PageUtil pu = PageUtil.getInstance();
		pu.pageSetting(params, 20);
		
		List list = SqlDao.getList("MyPage.getUserPoint", params);
		
		model.addAttribute("pointList", list);
		model.addAttribute("params", params);
		
		// 1 페이지면 전체페이지, 그 이상(더보기 클릭)이면 내용물만 리턴
		if(Common.strEqual(params.get("pageNumber"),"1"))
			return "client/mypage/point_history";
		else
			return "client/mypage/point_history_item";
	}
	
	/**
	 * 마이페이지 (개인정보관리)
	 */
	@RequestMapping(value = "*/myPageModifyPesonalInfo.latte")
	public String myPageModifyPesonalInfo(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		logger.info("myPageModifyPesonalInfo.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
		// 병원id가 정상적이지 않음
		if(sid==null){
			return "client/error/domain_error";
		}
		
		if (sessionContext.isAuth() == false) {
			return "redirect:login.latte?rePage=myPageHome.latte";
		}

		// UID 세팅
		params.put("s_uid", sessionContext.getUserMap().get("s_uid"));
		
		// 가입 시간 가져오기
		model.addAttribute("regtime", Common.isNull(SqlDao.getString("MyPage.getMemberRegTime", params), "1"));
		
		model.addAttribute("msg", EncodingUtil.fromKorean(params.get("msg")));

		//return "client/mypage/mmp";
		return "client/mypage/mypage_modify_personal_info";
	}
	
	/* 패스워드 변경 : 시작 ******************************************************************************************************/
//	@RequestMapping(value = "/myPagePasswordChangeForm.latte")
//	public String myPagePasswordChangeForm(Model model, HttpServletRequest request, String msg) {
//		
//		//if (Config.DEBUG) logger.info("[Develop Mode] Method - myPagePasswordChangeForm");
//		
//		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
//		
//		if (sessionContext.isAuth() == false) {
//			return "redirect:login.latte?rePage=myPageInfo.latte";
//		}
//
//		model.addAttribute("msg", EncodingUtil.fromKorean(msg));
//		
//		return "client/mypage/mypage_pw_change";
//	}
	
	@RequestMapping(value = "*/myPagePasswordChangeUpdate.latte")
	public String myPagePasswordChangeUpdate(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - myPagePasswordChangeUpdate");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == false) {
			return "redirect:login.latte?rePage=myPageHome.latte";
		}

		// UID 세팅
		params.put("s_uid", sessionContext.getUserMap().get("s_uid"));
		
		// 기존 비밀번호 확인
		params.put("s_password", params.get("old_pw"));
		int result = Common.IntConvertNvl(SqlDao.getString("MyPage.getPasswordCheck", params), 0);
		
		if (result != 1) {
			model.addAttribute("msg", "기존 비밀번호를 확인하여 주시기 바랍니다");
			return "redirect:myPageModifyPesonalInfo.latte";
		}
		
		// 기존 비밀번호가 맞을 경우 새 비밀번호 저장
		result = SqlDao.update("MyPage.updatePassword", params);
		
		if (result > 0) {
			model.addAttribute("msg", EncodingUtil.escape("정상적으로 변경되었습니다."));
		} else {
			model.addAttribute("msg", "DB 오류 (오류코드 : 5900)");
		}
		
		return "redirect:myPageHome.latte";
	}
	/* 패스워드 변경 : 끝남 ******************************************************************************************************/
	
	
	
	// 휴대폰 변경
	@RequestMapping(value = "*/myPagePhoneChangeUpdate2")
	public @ResponseBody String myPagePhoneChangeUpdate2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		// UID 정보 PUT
		params.put("s_uid", sessionContext.getUserMap().get("s_uid"));
		
		// 휴대폰 인증 성공 (업데이트)
		params.put("s_cphone_number", params.get("s_cphone_number").replace("-", ""));
		
		/* 기존에 같은 핸드폰 번호 상태값 변경 ('T') */ 
		SqlDao.update("updateDuplicationPhoneNumber", params);
		
		int result = SqlDao.update("updatePhoneNumber", params);
		
		if (result > 0) {

			// 세션정보 변경
			sessionContext.getUserMap().put("s_cphone_number", params.get("s_cphone_number"));
			return "0000";
		} else {
			return "9999";
		}
	}
	// 휴대폰 변경
	@RequestMapping(value = "*/myPagePhoneChangeUpdate")
	public String myPagePhoneChangeUpdate(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		// 인증번호 체크
		if (params.get("s_confirmNum") == null) {
			model.addAttribute("msg", "인증번호를 입력해주세요.");
		}
		
		// 인증시간 체크
		long checkTime = System.currentTimeMillis() - Long.parseLong(sessionContext.getUserMap().get("_s_confirmTime"));
		
		if (checkTime > 1000 * 60 * 5) {
			model.addAttribute("msg", "휴대폰 인증시간을 초과하였습니다.");
		}
		
		if (!sessionContext.getUserMap().get("_s_cphone_number").equals(params.get("s_cphone_number"))) {
			model.addAttribute("msg", "인증받은 기기와 다른 기기입니다.");
		}
		
		if (sessionContext.getUserMap().get("_s_confirmNum").equals(params.get("s_confirmNum"))) {
			
			// UID 정보 PUT
			params.put("s_uid", sessionContext.getUserMap().get("s_uid"));
			
			// 휴대폰 인증 성공 (업데이트)
			params.put("s_cphone_number", params.get("s_cphone_number").replace("-", ""));
			
			/* 기존에 같은 핸드폰 번호 상태값 변경 ('T') */ 
			SqlDao.update("updateDuplicationPhoneNumber", params);
			
			int result = SqlDao.update("updatePhoneNumber", params);
			
			if (result > 0) {

				// 세션정보 변경
				sessionContext.getUserMap().put("s_cphone_number", params.get("s_cphone_number"));
				
				model.addAttribute("msg", "휴대폰 번호가 변경되었습니다.");
			} else {
				model.addAttribute("msg", "DB 오류 (오류코드 : 4902)");
			}
			
		} else {
			model.addAttribute("msg", "인증번호가 틀렸습니다.");
			model.addAttribute("s_cphone_number", sessionContext.getUserMap().get("s_cphone_number"));
		}
		
		return "redirect:myPageModifyPesonalInfo.latte";
	}
	
	// 주소 변경
	@RequestMapping(value = "*/ajaxLocationUpdate")
	public @ResponseBody String ajaxLocationUpdate(HttpServletRequest request, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - ajaxLocationUpdate");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == false) {
			// 로그인 필요
			return "4444";
		}
		
		// UID 세팅
		params.put("s_uid", sessionContext.getUserMap().get("s_uid"));
		
		int result = SqlDao.update("updateLocation", params);
		
		if (result > 0) {
			// 세션 변경
			sessionContext.getUserMap().put("s_location", params.get("s_location"));
			return "0000";
		} else {
			return "9999";
		}
	}
	
	/** 마이페이지(탈퇴신청) : 시작 **********************************************************/
	@RequestMapping(value = "*/myPageDropMember.latte")
	public String myPageDropMember(Model model, String msg) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - myPageDropMember");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == false) {
			return "redirect:login.latte?rePage=myPageDropMember.latte";
		}
		
		model.addAttribute("msg", EncodingUtil.fromKorean(msg));
		
		return "client/mypage/mypage_drop";
	}
	
	@RequestMapping(value = "*/myPageDropMemberAccept.latte")
	public String myPageDropMemberAccept(Model model, HttpSession session, @RequestParam Map<String, String> params) {
		
		//if (Config.DEBUG) logger.info("[Develop Mode] Method - myPageDropMemberAccept");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if (sessionContext.isAuth() == false) {
			return "redirect:login.latte?rePage=myPageDropMember.latte";
		}
		
		params.put("s_uid", sessionContext.getUserMap().get("s_uid"));
		params.put("s_password", params.get("pw"));
		
		int result = Common.IntConvert(Common.isNull(SqlDao.getString("getPasswordCheck", params), "0"));
		
		// 비밀번호 확인
		if (result < 1) {
			model.addAttribute("msg", "비밀번호가 틀렸습니다.");	
			return "redirect:myPageDropMember.latte";
		}
		
		result = SqlDao.update("updateDropStatus", params);
		
		if (result > 0) {

			// 세션 삭제
			session.invalidate();
			model.addAttribute("msg", "정상적으로 탈퇴 처리 되었습니다.");
			return "client/mypage/mypage_drop_ok";
			
		} else {
			model.addAttribute("msg", "DB 오류 (오류코드 : 9200)");
			return "redirect:myPageHome.latte";
		}
		
	}
	/** 마이페이지(탈퇴신청) : 끝남 **********************************************************/
}
