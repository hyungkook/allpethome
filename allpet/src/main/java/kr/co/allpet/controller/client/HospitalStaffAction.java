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
import kr.co.allpet.utils.common.PageUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class HospitalStaffAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	private static final Logger logger = LoggerFactory.getLogger(HospitalStaffAction.class);

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "*/hospitalStaff.latte")
	public String hospitalStaff(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("hospitalStaff.latte");
		
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
		CommonProcess.getInstance().processMainMenu(model, params.get("idx"), Codes.CUSTOM_CATEGORY_MAIN_MENU_2, true);
		
		Map<String, String> s = new HashMap<String, String>();
		s.put("id", params.get("idx"));
		s.put("parent", Codes.CUSTOM_PARENT_STAFF);
		s.put("status", "Y");
		List<Map> staffMenuList = SqlDao.getList("COMMON.getByParent", s);
		
		model.addAttribute("staffMenu", staffMenuList);
		
		String parent = "";
		
		Map<String, String> categoryInfo = null;

		// request로 요청한 스태프 카테고리 id(cmid)
		if(Common.isValid(params.get("cmid")))
			parent = params.get("cmid");
		
		// 위에서 cmid가 없으면 첫번째 카테고리 id를 가져옴
		if(!Common.isValid(parent)){
			Iterator<Map> iter = staffMenuList.iterator();
			if(iter.hasNext()){
				
				Map map = iter.next();
				parent =  (String) map.get("s_cmid");
			}
		}
		// 카테고리 정보를 가져옴
		if(Common.isValid(parent))
			categoryInfo = SqlDao.getMap("COMMON.getCustomItem", parent);
		model.addAttribute("categoryInfo", categoryInfo);
		
		// 스태프 정보 가져올 파라미터 세팅
		params.put("category", parent);
		params.put("state", "Y");
		
		// 스태프 수
		params.put("totalCount", SqlDao.getString("Hospital.Staff.getStaffListCnt", params));
		//PageUtil.getInstance().pageSetting(params, 1);
		
		// 스태프 정보 가져옴
		List<Map> staffList = SqlDao.getList("Hospital.Staff.getStaffList", params);
		
		Map<String, String> staffInfo = Common.getFirstMap(staffList);
		//Map<String, String> staffInfo
		
		if(staffInfo != null){
			// 병원의 Status Info를 가져옴
			params.put("id", staffInfo.get("s_stid"));
			params.put("group", Codes.STATUS_INFO_GROUP_STAFF);
			@SuppressWarnings("rawtypes")
			List l = SqlDao.getList("Common.StatusInfo.getInfo", params);
			staffInfo = StatusInfoUtil.merge(l, staffInfo, true);
			//List<Map> flexList = SqlDao.getList("Common.StatusInfo.getInfo", params);
			
			// info에 flexList의 값들을 집어넣음
			//staffInfo = StatusInfoUtil.merge(flexList, staffInfo, false);
			model.addAttribute("staffInfo", staffInfo);
			
			// 스태프 이력사항, 학술활동, 저서 정보를 가져옴
			if(staffInfo != null){
				Map<String, String> pparam = new HashMap<String, String>();
				pparam.put("stid", staffInfo.get("s_stid"));
				pparam.put("type", Codes.STAFF_PAST_HISTORY);
				model.addAttribute("staffHistory", SqlDao.getList("Hospital.Staff.getStaffPastList", pparam));
				pparam.put("type", Codes.STAFF_PAST_CAREER);
				model.addAttribute("staffCareer", SqlDao.getList("Hospital.Staff.getStaffPastList", pparam));
				pparam.put("type", Codes.STAFF_PAST_BOOKS);
				model.addAttribute("staffBooks", SqlDao.getList("Hospital.Staff.getStaffPastList", pparam));
			}
		}
		model.addAttribute("staffList", staffList);
		
		model.addAttribute("params", params);
		
		// 병원 소개 이미지
		params.put("sid", params.get("idx"));
		params.put("key", Codes.IMAGE_TYPE_HOSPITAL_INTRO);
		model.addAttribute("introImageList", SqlDao.getList("Client.Hospital.getImageByKey", params));
		
		
		// 병원 기본 정보
		Map<String, String> info = SqlDao.getMap("Client.Hospital.getSimpleHospitalInfo", params.get("idx"));
		
		// 병원의 Status Info를 가져옴
		params.put("id", params.get("idx"));
		params.put("group", Codes.STATUS_INFO_GROUP_HOSPITAL);
		params.put("lcode", Codes.STATUS_INFO_LCODE_INFO);
		List<Map> flexList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		// info에 flexList의 값들을 집어넣음
		info = StatusInfoUtil.merge(flexList, info, false);
		model.addAttribute("hospitalInfo", info);
		
		// 병원 헤더, 로고 이미지
		CommonProcess.getInstance().getHospitalHeaderLogoImage(model, params);
		
		// 최소한의 병원 정보 (병원명 출력 등)
		//model.addAttribute("hospitalInfo", SqlDao.getMap("Client.Hospital.getSimpleHospitalInfo", params.get("idx")));
		
		return "client/hospital/hospital_staff";
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "*/ajaxHospitalStaff.latte")
	public String ajaxHospitalStaff(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		//logger.info("ajaxHospitalStaff.latte");
		
		// 스태프 정보 가져올 파라미터 세팅
		Map<String, String> staffCntParam = new HashMap<String, String>();
		staffCntParam.put("idx", params.get("idx"));
		params.put("category", params.get("category"));
		params.put("state", "Y");
		
		params.put("totalCount", SqlDao.getString("Hospital.Staff.getStaffListCnt", params));
		params.put("pageNumber", params.get("seq"));
		PageUtil.getInstance().pageSetting(params, 1);
		
		// 스태프 정보 가져옴
		Map<String, String> staffInfo = SqlDao.getMap("Hospital.Staff.getStaffList", params);
		
		// 스태프의 Status Info를 가져옴
		params.put("id", staffInfo.get("s_stid"));
		params.put("group", Codes.STATUS_INFO_GROUP_STAFF);
		@SuppressWarnings("rawtypes")
		List l = SqlDao.getList("Common.StatusInfo.getInfo", params);
		staffInfo = StatusInfoUtil.merge(l, staffInfo, true);
		//List<Map> flexList = SqlDao.getList("Common.StatusInfo.getInfo", params);
		
		// info에 flexList의 값들을 집어넣음
		//staffInfo = StatusInfoUtil.merge(flexList, staffInfo, false);
		model.addAttribute("staffInfo", staffInfo);
		
		// 스태프 이력사항, 학술활동, 저서 정보를 가져옴
		if(staffInfo != null){
			
			Map<String, String> pparam = new HashMap<String, String>();
			pparam.put("stid", staffInfo.get("s_stid"));
			
			// 통채로 가져옴 (이력사항, 학술활동, 저서 정보)
			List<Map> list = SqlDao.getList("Hospital.Staff.getStaffPastList", pparam);
			
			// 각각(이력사항, 학술활동, 저서 정보)의 리스트로 나눔
			Map<String, List> listMap = Common.splitList(list, "s_type",
					new String[]{
					Codes.STAFF_PAST_HISTORY, "staffHistory",
					Codes.STAFF_PAST_CAREER, "staffCareer",
					Codes.STAFF_PAST_BOOKS, "staffBooks"
					});
			
			model.addAllAttributes(listMap);
		}
		
		model.addAttribute("params", params);
		
		// 최소한의 병원 정보 (병원명 출력 등)
		model.addAttribute("hospitalInfo", SqlDao.getMap("Client.Hospital.getSimpleHospitalInfo", params.get("idx")));
		
		return "client/hospital/hospital_staff_info";
	}
}
