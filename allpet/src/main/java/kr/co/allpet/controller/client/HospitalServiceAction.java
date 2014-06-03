package kr.co.allpet.controller.client;

import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
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

public class HospitalServiceAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	private static final Logger logger = LoggerFactory.getLogger(HospitalServiceAction.class);
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "*/hospitalService.latte")
	public String hospitalService(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("hospitalService.latte");
		
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
		Map<String, String> menu = CommonProcess.getInstance().processMainMenu(model, params.get("idx"), Codes.CUSTOM_CATEGORY_MAIN_MENU_3, false);

		Map<String, String> s = new HashMap<String, String>();
		s.put("id", params.get("idx"));
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		List<Map> boardMenuList = SqlDao.getList("COMMON.getByParent", s);

		// 선택한 메뉴 id
		// ([0] = 부모, [1] = 자신) 의 id
		String[] cmids = request.getParameterValues("cmid");
		
		// 서브메뉴(2 depth) 리스트를 가져오기 시작
		
		// 1 depth 메뉴리스트에서 첫번째 것을 가져옴
		Map<String, String> item = boardMenuList.iterator().next();
		
		Map<String, String> param = new HashMap<String, String>();
		param.put("id", params.get("idx"));
		// 부모(1depth)가 어떤것인지 할당
		if(cmids!=null && cmids.length > 0)
			param.put("parent", cmids[0]);
		else{
			param.put("parent", (String) item.get("s_cmid"));
		}
		List<Map> firstBoardList = SqlDao.getList("COMMON.getChildCustom", param);
		
		// 서브메뉴 리스트를 가져오기 끝
		
		// 메뉴, 서브메뉴 추가
		model.addAttribute("menuList", boardMenuList);
		model.addAttribute("subMenuList", firstBoardList);
		
		String leaf = null;
		
		// 현재 선택된 메뉴의 정보를 가져옴. 선택된 거 없으면 첫번째 것
		if(cmids!=null && cmids.length > 0){
			leaf = cmids[0];
		}
		else{
			leaf = (String) item.get("s_cmid");
		}
		model.addAttribute("boardInfo", SqlDao.getMap("COMMON.getCustomItem", leaf));
		
		// 서브메뉴가 있을 경우
		if(firstBoardList!=null && !firstBoardList.isEmpty()){
			Map<String, String> subItem = firstBoardList.iterator().next();
			
			// 현재 선택된 서브메뉴의 정보를 가져옴. 선택된 거 없으면 첫번째 것
			if(cmids!=null && cmids.length == 2){
				leaf = cmids[1];
			}
			else{
				leaf = (String) subItem.get("s_cmid");
			}
			model.addAttribute("subBoardInfo", SqlDao.getMap("COMMON.getCustomItem", leaf));
		}
		
		Map<String, String> bparam = new HashMap<String, String>();
		bparam.put("cmid", leaf);
		bparam.put("visible", "Y");
		List<Map> list = SqlDao.getList("Hospital.Board.getServiceBoardList", bparam);
		
		if(Common.isValid(list)){
			HashMap<String, Object> subinfo = new HashMap<String, Object>();
			subinfo.put("list", list);
			subinfo.put("type", Codes.ELEMENT_BOARD_CONTENTS_TYPE_VIDEO_LINK);
			List l = SqlDao.getList("Hospital.Board.getContentsInBid", subinfo);
			
			if(Common.isValid(l)){
				Map videoListMap = Common.splitListGroupBy(l, "s_bid");
				
				Iterator<Map> iter2 = list.iterator();
				while(iter2.hasNext()){
					Map m = iter2.next();
					m.put("videoList", videoListMap.get(m.get("s_bid")));
				}
			}
		}
		
		model.addAttribute("boardList",list);
		
		model.addAttribute("params", params);
		
//		List l = SqlDao.getList("Hospital.Board.getContentsByBid", params.get("bid"));
//		model.addAttribute("videoList", l);
		
		// 병원 헤더, 로고 이미지
		CommonProcess.getInstance().getHospitalHeaderLogoImage(model, params);
		
		// 병원 정보
		Map<String, String> hospitalInfo = SqlDao.getMap("Client.Hospital.getSimpleHospitalInfo", params.get("idx"));
		params.put("id", params.get("idx"));
		params.put("s_group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("s_lcode", Codes.STATUS_INFO_LCODE_INFO);
		hospitalInfo = StatusInfoUtil.merge(SqlDao.getList("Common.StatusInfo.getInfo", params), hospitalInfo, false);
		model.addAttribute("hospitalInfo", hospitalInfo);
		
		return "client/hospital/hospital_service";
	}
}
