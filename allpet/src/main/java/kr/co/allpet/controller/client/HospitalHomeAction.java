package kr.co.allpet.controller.client;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Codes;
import kr.co.allpet.utils.client.CommonProcess;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.client.StatusInfoUtil;
import kr.co.allpet.utils.common.Common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller

public class HospitalHomeAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	private static final Logger logger = LoggerFactory.getLogger(HospitalHomeAction.class);
	
	@SuppressWarnings({ "unchecked" })
	@RequestMapping(value = "*/hospitalHome.latte")
	public String hospitalHome(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("hospitalHome.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		// 로그인 확인
		if(sessionContext.isAuth())
			params.put("isLogin", "Y");
		
		// 파라미터에 sid(idx) 가 없음
		if(!Common.isValid(params.get("idx"))){
			
			String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
			// id가 정상적이지 않음
			if(sid==null){
				return "client/error/domain_error";
			}
			params.put("idx", sid);
		}
		
		// 메인메뉴
		CommonProcess.getInstance().processMainMenu(model, params.get("idx"), Codes.CUSTOM_CATEGORY_MAIN_MENU_1, false);
		
		// 병원 기본 정보
		Map<String, String> info = SqlDao.getMap("Client.Hospital.getHomeInfo", params.get("idx"));
		
		// 병원의 추가 정보를 가져옴
		params.put("id", params.get("idx"));
		params.put("s_group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("s_lcode", Codes.STATUS_INFO_LCODE_INFO);
		info = StatusInfoUtil.merge(SqlDao.getList("Common.StatusInfo.getInfo", params), info, false);
		
		model.addAttribute("hospitalInfo", info);
		
		// 업무시간 정보
		model.addAttribute("workingTimeList", SqlDao.getList("Client.Hospital.getWorkingTime", params.get("idx")));
		
		// 병원 소개 이미지
		params.put("sid", params.get("idx"));
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		model.addAttribute("introImageList", SqlDao.getList("Client.Hospital.getImageByKey", params));
		
		// 병원 헤더, 로고 이미지
		CommonProcess.getInstance().getHospitalHeaderLogoImage(model, params);
		
		// 사이트 리스트
		model.addAttribute("siteList", SqlDao.getList("Client.Hospital.getSite", params.get("idx")));
		
		// 중요 공지사항 리스트
		params.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
		params.put("visible", "Y");
		model.addAttribute("importantBoardList", SqlDao.getList("Hospital.Board.getAllImportantList", params));
		
		model.addAttribute("params", params);
		
		return "client/hospital/hospital_home";
	}
}
