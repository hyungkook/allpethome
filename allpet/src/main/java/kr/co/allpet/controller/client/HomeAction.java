package kr.co.allpet.controller.client;

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
		
		// 병원 정보 가져오기
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		
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
	
	@RequestMapping(value = "/personalHome2.latte")
	public String personalHome2(Model model, HttpServletRequest request, Map<String, String> params, String msg) {
		
		String domain = request.getHeader("referer");//request.getRequestURL().toString();
		
		domain = domain.replace("http://", "");
		domain = domain.substring(0, domain.indexOf("/"));
		
		// 병원 정보 가져오기
		Map<String,String> hospitalInfo = SqlDao.getMap("getSidbyDomain", domain);
		
		// pc 에서 접속하였고, 특정 싸이트 연결이 필요한 경우
		if(hospitalInfo == null){
			return "client/error/domain_error";
		}else{
			String pcLink = hospitalInfo.get("s_pcLink");
			if( Common.isNotNull(pcLink)){
				model.addAttribute("redirectUrl", pcLink);
				return "returnOtherHome";
			} else {
				return "redirect:"+hospitalInfo.get("s_hospital_id")+"/hospitalHome.latte";
			}
		}
	}
	
	@RequestMapping(value = "/eventRoot.latte")
	public String eventRoot(Model model, HttpServletRequest request, Map<String, String> params) {
		
		model.addAttribute("p", params);
		
		return "client/eventRoot";
	}
	
	/**
	 * 테스트용
	 */
	@RequestMapping(value = "/gotoHome1.latte")
	public String gotoHome1(Model model, HttpServletRequest request, Map<String, String> params) {
		
		return "client/test/jump";
	}
	
	/**
	 * 테스트용
	 */
	@RequestMapping(value = "/gotoHome2.latte")
	public String gotoHome2(Model model, HttpServletRequest request, String id) {
		
		Map<String,String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSidFromId", id);
		
		return "redirect:"+id+"/hospitalHome.latte?idx="+hospitalInfo.get("s_sid");
		
		//model.addAttribute("url", "hospitalHome.latte?idx="+hospitalInfo.get("s_sid"));
		//return "client/test/frameset";
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
