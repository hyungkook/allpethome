package kr.co.allpet.utils.client;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.common.Common;

import org.springframework.ui.Model;

public class CommonProcess {
	
	private static CommonProcess instance = null;
	
	public static CommonProcess getInstance(){
		
		if(instance==null)
			instance = new CommonProcess();
		
		return instance;
	}
	
	private CommonProcess(){}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Map<String, String> processMainMenu(Model model, String sid, String curMenu, boolean needCurMenuInfo){
		
		Map s = new HashMap<String, Object>();
		s.put("parent", "MAIN_MENU");
		//s.put("parent", "s_cmid005");
		s.put("id", sid);
		s.put("status", "Y");
		List<Map> mainMenu = CustomizeUtil.getInstance().getAttributesByParent(s);
		
		model.addAttribute("mainMenu", mainMenu);
		
		// 현재 선택된 메뉴 정보를 찾음
		Map returnMap = null;
		for(Map map:mainMenu){
			if(Common.strEqual(curMenu, (String) map.get("s_group"))){
				model.addAttribute("curMenuId", map.get("s_cmid"));
				returnMap = map;
			}
		}
		
		s.clear();
		
		return returnMap;
	}
	
	@SuppressWarnings("rawtypes")
	public void getHospitalHeaderLogoImage(Model model, Map<String,String> params){
		
		params.put("sid", params.get("idx"));
		params.put("keys", "('"+Codes.IMAGE_TYPE_HOSPITAL_HEADER+"','"+Codes.IMAGE_TYPE_HOSPITAL_LOGO+"')");
		List<Map> imgList = SqlDao.getList("Client.Hospital.getImageInKey", params);
		Iterator<Map> iter = imgList.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_HEADER))
				model.addAttribute("header_img",m);
			else if(Common.strEqual((String) m.get("S_LKEY"),Codes.IMAGE_TYPE_HOSPITAL_LOGO))
				model.addAttribute("logo_img",m);
		}
	}
	
	public String getCurrentSid(SessionContext sessionContext, HttpServletRequest request){
		
		String hospi_id = sessionContext.getUserData("hospi_id");
		String cur_id = Common.getRootSubpath(request);
		
		// 세션에 id가 없으니 새로 받아오고 덤으로 sid도 가져옴
		if(!Common.isValid(hospi_id)){
			sessionContext.setUserData("hospi_id", cur_id);
			
			Map<String,String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSidFromId", cur_id);
			
			if(hospitalInfo==null){
				return null;
			}
			
			sessionContext.setUserData("sid", hospitalInfo.get("s_sid"));
			return hospitalInfo.get("s_sid");
		}
		else{
			
			String sid = sessionContext.getUserData("sid");
			// id가 바뀜
			if(!Common.strEqual(hospi_id, cur_id)){
				sessionContext.setUserData("hospi_id", cur_id);
				
				Map<String,String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSidFromId", cur_id);
				
				if(hospitalInfo==null){
					return null;
				}
				
				sessionContext.setUserData("sid", hospitalInfo.get("s_sid"));
				return hospitalInfo.get("s_sid");
			}
			// id는 있는데 sid가 없음면 sid를 새로 받아옴
			else if(!Common.isValid(sid)){
				sessionContext.setUserData("hospi_id", cur_id);
				
				Map<String,String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSidFromId", sid);
				
				if(hospitalInfo==null){
					return null;
				}
				
				sessionContext.setUserData("sid", hospitalInfo.get("s_sid"));
				return hospitalInfo.get("s_sid");
			}
			else{
				
				return sessionContext.getUserData("sid");
			}
		}
	}
}
