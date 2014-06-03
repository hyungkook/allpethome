package kr.co.allpet.controller.client;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.EncodingUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class CommonAction {
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	private static final Logger logger = LoggerFactory.getLogger(CommonAction.class);
	
	/**
	 * 지역팝업용
	 */
	@SuppressWarnings({ "rawtypes"})
	@RequestMapping(value = "*/locationInfo.latte")
	public String locationInfo(Model model, @RequestParam Map<String, String> params) {
		
		String value 	= EncodingUtil.fromKorean(Common.isNull(params.get("value")));
		String type 	= EncodingUtil.fromKorean(Common.isNull(params.get("type")));
		String dong 	= EncodingUtil.fromKorean(Common.isNull(params.get("dong")));
		String sido 	= EncodingUtil.fromKorean(Common.isNull(params.get("sido")));
		String gugun 	= EncodingUtil.fromKorean(Common.isNull(params.get("gugun")));
		
		if (Config.DEBUG) logger.info("[Develop Mode] Method - locationInfo : {},{}", type, value);
		
		List<Map> gugunList = null;
		List<Map> dongList = null;
		List<Map> searchLocationList = null;
		
		Map<String, String> map = new HashMap<String,String>();
		
		String title = "지역선택";
		
		//지역 선택
		if (type.equals("init")) {
			title = "지역선택";
			
		}
		
		if (type.equals("gugun")) {
			title = value;
			gugunList = SqlDao.getList("selectAreaGugun", value);
		}
		
		if (type.equals("dong")) {
			title = value;
			
			
			map.put("s_sido", sido);
			map.put("s_gugun", gugun);
			
			
			dongList = SqlDao.getList("selectAreaDong", map);
			
		}
		
		if (type.equals("search")) {
			
			String city = EncodingUtil.fromKorean(Common.isNull(params.get("city")));
			map.put("city", city);
			
			searchLocationList = SqlDao.getList("getSearchLocationList", map);
			
			model.addAttribute("searchLocationList", searchLocationList);
			
			map.put("type", type);
			
			model.addAttribute("params", map);
			model.addAttribute("title", "검색 조건");
			
			return "client/common/commonLocation";
		}
		
		map.put("value", value);
		map.put("type", type);
		map.put("dong", dong);
		map.put("sido", EncodingUtil.fromKorean(params.get("sido")));
		map.put("gugun", gugun);
		
		model.addAttribute("title", title);
		model.addAttribute("gugunList", gugunList);
		model.addAttribute("dongList", dongList);
		model.addAttribute("params", map);
		
		return "client/common/commonLocation";
	}
	
	// 회원 위치정보
	@RequestMapping(value = "*/ajaxLocationInfo.latte")
	public String ajaxLocationInfo(Model model, @RequestParam Map<String, String> params) {
		//logger.info("ajaxLocationInfo.latte");
		
		Map<String, String> map = new HashMap<String,String>();
		
		String str = params.get("search_type");
		if(Common.strEqual(str, "sido")){
			model.addAttribute("areaList", SqlDao.getList("selectAreaSido", null));
		}
		else if(Common.strEqual(str, "sigungu")){
			model.addAttribute("areaList", SqlDao.getList("selectAreaGugun", params.get("sido")));
		}
		else if(Common.strEqual(str, "dong")){
			map.put("s_sido", params.get("sido"));
			map.put("s_gugun", params.get("sigungu"));
			model.addAttribute("areaList", SqlDao.getList("selectAreaDong", map));
		}

		model.addAttribute("params", params);
		
		return "client/mypage/mypage_location_list";
	}
}
