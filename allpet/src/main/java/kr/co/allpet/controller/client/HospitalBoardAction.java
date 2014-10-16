package kr.co.allpet.controller.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Codes;
import kr.co.allpet.utils.client.CommonProcess;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.CustomizeUtil;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.client.StatusInfoUtil;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.EncodingUtil;
import kr.co.allpet.utils.common.PageUtil;
import kr.co.allpet.utils.common.XMLParserUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller

public class HospitalBoardAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	private static final Logger logger = LoggerFactory.getLogger(HospitalBoardAction.class);
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "*/hospitalBoard.latte")
	public String hospitalBoard(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("hospitalBoard.latte");
		
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
		
		// 메인 메뉴 처리
		Map<String, String> menu = CommonProcess.getInstance().processMainMenu(model, params.get("idx"), Codes.CUSTOM_CATEGORY_MAIN_MENU_4, false);
		
		// 병원 헤더, 로고 이미지
		CommonProcess.getInstance().getHospitalHeaderLogoImage(model, params);
		
		// 소식 메뉴의 하위 게시판 리스트를 가져옴
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", params.get("idx"));
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		s.put("visible", "Y");
		List boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		String parent = "";
		
		Map<String, Object> boardInfo = new HashMap<String, Object>();
		
		// 최초접근(선택된 게시판 없음)시 맨 처음 게시판 선택
		if(!Common.isValid(params.get("cmid"))){
			parent = (String) Common.getFirstValue(boardMenuList, "s_cmid");
		}
		// 파라미터로 온 게시판 id
		if(!Common.isValid(parent)){
			parent = params.get("cmid");
		}
		// 게시판 정보 얻어옴
		if(Common.isValid(parent)){
			boardInfo.putAll(SqlDao.getMap("COMMON.getCustomItem", parent));//params.get("cmid")));
		}
		
		// 검색어 복호화
		params.put("search_text", EncodingUtil.URLDecode(params.get("search_text"), Config.DEFAULT_CHARSET));
		
		// 해당 게시판의 sub info 를 가져온다. (param : 게시판보유자id(ex:s_sid), 게시판id)
		Map<String, String> m = CustomizeUtil.getInstance().putAllToMap(SqlDao.getList("COMMON.getCustomAttrById", parent), boardInfo, true);
		//Map mmm =Common.listToMap(SqlDao.getList("COMMON.getCustomAttrById", parent), "s_key", "s_value");
		//boardInfo.putAll(SqlDao.getMap("COMMON.getCustomAttrById", parent, "s_key"));
		
		if(boardInfo != null && !boardInfo.isEmpty()){
			if(Common.strEqual(m.get("s_group"),Codes.BOARD_TYPE_RSS)){
				
				// RSS 처리
				XMLParserUtil xml = new XMLParserUtil();
				
				ArrayList<String> keyTree = new ArrayList<String>();
				keyTree.add("rss");
				keyTree.add("channel");
				keyTree.add("item");
				
				ArrayList<Object> list = xml.parseByDOM("URL", m.get("attr_url"), keyTree);
				
				if(list!=null&&!list.isEmpty()){
					
					if(Common.strEqual(params.get("search_type"),"subjectcontents")){
						
						xml.search(list, new String[]{"title","description"},
								params.get("search_text"), Common.toInt(params.get("pageNumber")), 10);
					}
					else{
						xml.search(list, null, null, Common.toInt(params.get("pageNumber")), 10);
					}
					params.put("totalCount", xml.getSearchTotal()+"");
					params.put("pageNumber", xml.getPageNumber()+"");
					params.put("pageCount", xml.getPageCount()+"");
					
					model.addAttribute("rssList", xml.getSearchResultList());
				}
			}
			else{
				// 게시물 리스트 가져오기
				Map<String, String> bparam = new HashMap<String, String>();
				bparam.put("cmid", (String) boardInfo.get("s_cmid"));
				bparam.put("search_type", params.get("search_type"));
				bparam.put("search_text", params.get("search_text"));
				bparam.put("visible", "Y");
				
				bparam.put("totalCount", SqlDao.getString("Hospital.Board.getBoardListCnt", bparam));
				bparam.put("pageNumber", params.get("pageNumber"));
				
				PageUtil.getInstance().pageSetting(bparam, 10);
				params.putAll(bparam);
				
				model.addAttribute("boardList", SqlDao.getList("Hospital.Board.getBoardList", bparam));
				
				// 일반 게시판
				if(Common.strEqual(m.get("s_group"),Codes.BOARD_TYPE_NOTICE)){
					
					bparam.put("type", Codes.ELEMENT_BOARD_TYPE_IMPORTANT);
					
					model.addAttribute("importantBoardList", SqlDao.getList("Hospital.Board.getBoardList", bparam));
				}
			}
		}
		
		// 게시판 정보
		model.addAttribute("boardInfo", boardInfo);
		// 게시판 메뉴
		model.addAttribute("menuList", boardMenuList);
		
		// 병원 정보
		Map<String, String> info = SqlDao.getMap("Client.Hospital.getHomeInfo", params.get("idx"));
		
		// 병원의 추가 정보를 가져옴
		params.put("id", params.get("idx"));
		params.put("s_group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("s_lcode", Codes.STATUS_INFO_LCODE_INFO);
		info = StatusInfoUtil.merge(SqlDao.getList("Common.StatusInfo.getInfo", params), info, false);
		
		Map<String, String> hospitalAddress = SqlDao.getMap("Client.Hospital.getAddressInfo", params.get("idx"));
		
		model.addAttribute("hospitalInfo", info);
		model.addAttribute("hospitalAddress", hospitalAddress);
		
		model.addAttribute("params", params);
		
		return "client/hospital/hospital_board";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "*/hospitalBoardDetail.latte")
	public String hospitalBoardDetail(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("hospitalBoardDetail.latte");
		
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
		

		Map<String, String> info = SqlDao.getMap("Client.Hospital.getHomeInfo", params.get("idx"));
		
		// 병원의 추가 정보를 가져옴
		params.put("id", params.get("idx"));
		params.put("s_group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("s_lcode", Codes.STATUS_INFO_LCODE_INFO);
		info = StatusInfoUtil.merge(SqlDao.getList("Common.StatusInfo.getInfo", params), info, false);
		
		Map<String, String> hospitalAddress = SqlDao.getMap("Client.Hospital.getAddressInfo", params.get("idx"));
		
		model.addAttribute("hospitalInfo", info);
		model.addAttribute("hospitalAddress", hospitalAddress);
		
		// 메인 메뉴 처리
		Map<String, String> menu = CommonProcess.getInstance().processMainMenu(model, params.get("idx"), Codes.CUSTOM_CATEGORY_MAIN_MENU_4, false);
		
		// 소식 게시판의 하위 게시판 리스트를 가져옴
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", params.get("idx"));
		s.put("parent", menu.get("s_cmid"));
		s.put("status", "Y");
		s.put("visible", "Y");
		List boardMenuList = SqlDao.getList("COMMON.getByParent", s);
		model.addAttribute("menuList", boardMenuList);
		
		// 현재 게시글에 해당하는 게시판
		String parent = params.get("cmid");
		Map<String, String> boardInfo = SqlDao.getMap("COMMON.getCustomItem", parent);
		
		// 현재 선택된 메뉴의 속성값(list)들을 가져와서 map 으로 변환
		Map<String, String> m = CustomizeUtil.getInstance().putAllToMap(SqlDao.getList("COMMON.getCustomAttrById", parent), boardInfo, true);
		
		Map mmm = SqlDao.getMap("COMMON.getCustomAttrById", parent, "s_key");
		
		// 게시판 내용을 가져옴
		if(Common.isValid(params.get("bid"))){
			model.addAttribute("boardContents", SqlDao.getMap("Hospital.Board.getBoard", params.get("bid")));
			SqlDao.update("Hospital.Board.incrementReadCnt", params.get("bid"));
			
			List l = SqlDao.getList("Hospital.Board.getContentsByBid", params.get("bid"));
			model.addAttribute("videoList", l);
		}
		
		// 게시판 타입 정보를 가져옴
		model.addAttribute("boardInfo", boardInfo);
		
		// 병원 헤더, 로고 이미지
		CommonProcess.getInstance().getHospitalHeaderLogoImage(model, params);
		
		
		model.addAttribute("params", params);
		
		return "client/hospital/board/hospital_board_detail";//+layout;
	}
}
