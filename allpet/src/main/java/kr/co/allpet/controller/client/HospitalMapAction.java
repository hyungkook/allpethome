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

public class HospitalMapAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	private static final Logger logger = LoggerFactory.getLogger(HospitalMapAction.class);

	@RequestMapping(value = "*/hospitalMap.latte")
	public String hospitalMap(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("hospitalMap.latte");
		
		// 로그인 확인
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
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
		
		// 메인 메뉴
		CommonProcess.getInstance().processMainMenu(model, params.get("idx"), Codes.CUSTOM_CATEGORY_MAIN_MENU_5, false);
		
		Map<String, String> info = SqlDao.getMap("Client.Hospital.getHomeInfo", params.get("idx"));
		
		// 병원의 추가 정보를 가져옴
		params.put("id", params.get("idx"));
		params.put("s_group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("s_lcode", Codes.STATUS_INFO_LCODE_INFO);
		info = StatusInfoUtil.merge(SqlDao.getList("Common.StatusInfo.getInfo", params), info, false);
		
		Map<String, String> hospitalAddress = SqlDao.getMap("Client.Hospital.getAddressInfo", params.get("idx"));
		
		model.addAttribute("hospitalInfo", info);
		model.addAttribute("hospitalAddress", hospitalAddress);
		
		// 병원 헤더, 로고 이미지
		CommonProcess.getInstance().getHospitalHeaderLogoImage(model, params);
		
		model.addAttribute("params", params);
		
		// 자세히보기 detail 값이 파라미터로 넘어왔을 경우 파라미터를 붙인 jsp 호출
		return "client/hospital/hospital_map"+(Common.isValid(params.get("detail"))?"_"+params.get("detail"):"");
	}
}
