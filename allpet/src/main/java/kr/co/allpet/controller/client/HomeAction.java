package kr.co.allpet.controller.client;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;


import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.common.Common;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeAction {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeAction.class);
	
	/**
	 * 병원 개별 등록 도메인으로 접속한 경우 홈으로 리다이렉트
	 */
	@RequestMapping(value = "/personalHome.latte")
	public String personalHome(Model model, HttpServletRequest request, Map<String, String> params, String msg) {
		
		String domain = request.getHeader("referer");//request.getRequestURL().toString();
		
		domain = domain.replace("http://", "");
		domain = domain.substring(0, domain.indexOf("/"));
		
		if( "www.allpetHome.com".equalsIgnoreCase(domain)){
			return "homePage";
		}
		
		// 병원 정보 가져오기
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		
		// 유저 접속 카운트 입력
		try{
			updateUserCount(hospitalInfo);
		}catch (Exception e) {
			e.printStackTrace();
		}
				
		String isMobile = params.get("isMobile");
		if( isMobile != null && isMobile.equalsIgnoreCase("n")){
			// pc 에서 접속하였고, 특정 싸이트 연결이 필요한 경우
			String pcLink = hospitalInfo.get("s_pcLink");
			if( Common.isNotNull(pcLink)){
				model.addAttribute("redirectUrl", pcLink);
				return "returnOtherHome";
			}
		}
		
		if(hospitalInfo == null){
			return "client/error/domain_error";
		} else {
//			return "redirect:http://m.allpethome.co.kr/"+hospitalInfo.get("s_hospital_id")+"/hospitalHome.latte";
			return "redirect:"+hospitalInfo.get("s_hospital_id")+"/hospitalHome.latte";
		}
	}
	
	@RequestMapping(value = "/pcView.latte")
	public String personalHome2(Model model, HttpServletRequest request, Map<String, String> params, String msg) {
		
		String domain = request.getHeader("referer");//request.getRequestURL().toString();
		
		domain = domain.replace("http://", "");
		domain = domain.substring(0, domain.indexOf("/"));
		if( "www.allpetHome.com".equalsIgnoreCase(domain)){
			return "homePage";
		}
		
		// 병원 정보 가져오기
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		
		// 유저 접속 카운트 입력
		try{
			updateUserCount(hospitalInfo);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		// pc 에서 접속하였고, 특정 싸이트 연결이 필요한 경우
		if(hospitalInfo == null){
			return "client/error/domain_error";
		}else{
			String pcLink = hospitalInfo.get("s_pcLink");
			String pctype = hospitalInfo.get("s_pctype");
			
			if( !"ALLPET".equalsIgnoreCase(pctype) && Common.isNotNull(pcLink)){
				model.addAttribute("redirectUrl", pcLink);
				return "returnOtherHome";
			} else {
				model.addAttribute("hospitalInfo", hospitalInfo);
//				return "redirect:"+hospitalInfo.get("s_hospital_id")+"/hospitalHome.latte";
				return "client/hospital/hospital_pcview";
			}
		}
	}
	
	public void updateUserCount(Map<String, String> params){
		Map<String, String> userCount = SqlDao.getMap("Client.Hospital.getUserCount", params.get("s_sid"));
		if( userCount == null || userCount.isEmpty() ){
			userCount = new HashMap<String, String>();
			userCount.put("s_sid", params.get("s_sid"));
			userCount.put("s_hospital_name", params.get("s_hospital_name"));
			SqlDao.insert("Client.Hospital.insertUserCount", userCount);
		}else{
			String tdcnt = userCount.get("S_TODAY_COUNT");
			String ttcnt = userCount.get("S_TOTAL_COUNT"); 
			userCount.put("S_TODAY_COUNT", (Integer.parseInt(tdcnt) + 1) +"");
			userCount.put("S_TOTAL_COUNT", (Integer.parseInt(ttcnt) + 1) +"");
			SqlDao.update("Client.Hospital.updateUserCount", userCount);
		}
	}
	
	@RequestMapping(value = "/eventRoot.latte")
	public String eventRoot(Model model, HttpServletRequest request, Map<String, String> params) {
		
		model.addAttribute("p", params);
		
		return "client/eventRoot";
	}
	
	/**
	 * pageHome.latte?id=아이디.. 로 접근할 경우 홈으로 리다이렉트 
	 */
	@RequestMapping(value = "/pageHome.latte")
	public String pageHome(Model model, HttpServletRequest request, String id) {
		
		Map<String,String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSidFromId", id);
		
		if(hospitalInfo==null){
			return "client/error/domain_error";
		}
		
		return "redirect:"+id+"/hospitalHome.latte";
	}

	/**
	 * 도메인/병원아이디/home.latte 로 접근하는 경우 홈으로 리다이렉트
	 */
	@RequestMapping(value = "*/home.latte")
	public String home(Model model, HttpServletRequest request) {
		
		String id = Common.getRootSubpath(request);
		
		Map<String,String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSidFromId", id);
		
		if(hospitalInfo==null){
			return "client/error/domain_error";
		}
		
		return "redirect:hospitalHome.latte";
	}
}
