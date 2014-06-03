package kr.co.allpet.controller.client.mypage;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Codes;
import kr.co.allpet.utils.client.CommonProcess;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.SMSSender;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.common.BatchQueryBuilder;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.JSONSimpleBuilder;
import kr.co.allpet.utils.common.JSONUtil;
import kr.co.allpet.utils.common.SimpleDateFormatter;

import org.json.simple.JSONArray;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyPagePetAction {
	
	private static final Logger logger = LoggerFactory.getLogger(MyPagePetAction.class);
	
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	/**
	 * 펫 정보 페이지
	 * 
	 * @author 박주엽
	 * @date 2013. 12. 3.
	 */
	@RequestMapping(value="*/petRegPage.latte")
	public String petRegPage(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("petRegPage.latte");
		
		// 로그인 확인
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageHome.latte";
		
		String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
		// 병원id가 정상적이지 않음
		if(sid==null){
			return "client/error/domain_error";
		}
		
		// 동물 종 선택 콤보박스 리스트
		model.addAttribute("pet_species", SqlDao.getList("COMMON.getElementList", Codes.PET_DOG_SPECIES));
		model.addAttribute("dog_breed", SqlDao.getList("COMMON.getElementList", Codes.PET_DOG_SPECIES));
		model.addAttribute("cat_breed", SqlDao.getList("COMMON.getElementList", Codes.PET_CAT_SPECIES));
		
		// 펫 정보
		// pid가 있으면 수정, 없으면 새로 생성 모드
		if(Common.isValid(params.get("pid"))){
			
			model.addAttribute("petInfo", SqlDao.getMap("MyPage.getPetInfoByPID", params.get("pid")));
			params.put("type","modify");
		}
		else{
			params.put("type","new");
		}
		
		model.addAttribute("doc_term",SqlDao.getList("COMMON.getElementList", "DVAC_TERM"));
		model.addAttribute("cat_term",SqlDao.getList("COMMON.getElementList", "CVAC_TERM"));
		
		model.addAttribute("params", params);
		
		return "client/mypage/pet_reg";
	}

	/**
	 * 펫 정보 등록/수정
	 * 
	 * @author 박주엽
	 * @date 2013. 12. 3.
	 */
	@RequestMapping(value="*/petRegExecute.latte")
	public @ResponseBody String petRegExecute(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("petRegExecute.latte");
		
		// 로그인 
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth()){
			JSONSimpleBuilder builder = new JSONSimpleBuilder();
			builder.add("resultCode", Codes.ERROR_UNAUTHORIZED);
			return builder.build();
		}
		
		// 병원id가 정상적이지 않음
		String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
		if(sid==null){
			return (new JSONSimpleBuilder()).add("result", Codes.ERROR_UNAUTHORIZED).build();
		}
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		// request로 pid를 받지 않았다면 새로 생성
		if(!Common.isValid(params.get("pid")))
			params.put("pid", Common.makeRownumber("pid", params.get("uid")));
		
		builder.add("pid", params.get("pid"));
		
		if(SqlDao.insert("MyPage.insertPetInfo", params)>0)
			builder.postAdd("resultCode", Codes.SUCCESS_CODE);
		else
			builder.postAdd("resultCode", Codes.ERROR_QUERY_EXCEPTION);
		
		// 기초접종 등록
		// (1~최대6차 기초접종 + 항체가검사 + 추가접종)
		
		List<Map> schedule = getVaccinationSchedule(params, Codes.VACCINATION_BASIC_SET);
		
		int basic_c = Common.toInt(params.get("first_base"));
		int basic_year = Common.toInt(params.get("base_year"));
		int basic_month = Common.toInt(params.get("base_month"));
		int basic_day = Common.toInt(params.get("base_day"));
		
		// 등록된 스케줄이 없을 경우에만 등록(최초)
		if( basic_c != 0 && basic_c != 0 && basic_c != 0 && basic_c != 0 && !Common.isValid(schedule)){
			
			// 병원 정보를 가져옴
			Map<String, String> info = SqlDao.getMap("Client.Hospital.getHomeInfo", sid);
			String hsp_phone = info.get("s_tel");
			
			// species 값 치환
			if(Common.strEqual(params.get("species"), "dog")){
				params.put("species", Codes.PET_DOG_SPECIES);
				params.put("group_type", "BASIC_DOG");
			}
			else if(Common.strEqual(params.get("species"), "cat")){
				params.put("species", Codes.PET_CAT_SPECIES);
				params.put("group_type", "BASIC_CAT");
			}
			params.put("sid", sid);
			List<Map> vcList = SqlDao.getList("Client.Pet.getVaccineList", params);
			
			Map<String, List> m = Common.splitListGroupBy(vcList, "t");
			
			Map basic_info = (Map)m.get("BASIC").get(0);
			int basic_len = Common.toInt(basic_info.get("len"));
			String term_type = (String) basic_info.get("term_type");
			
			long basic_term = Common.toInt(basic_info.get("term"));
			
			// term_type으로 msec 으로 변환
			basic_term = calTerm(basic_term, term_type); 
			
			Calendar calendar = Calendar.getInstance();
			calendar.set(basic_year, basic_month-1, basic_day);
			
			Calendar today = Calendar.getInstance();
			
			int msg_send_index = 0;
			
			// 이전 날짜이므로 다음 날짜를 새로 잡고 예약
			if(today.getTimeInMillis() > calendar.getTimeInMillis()){
				
				msg_send_index = basic_c;
			}
			else{
				
				msg_send_index = basic_c -1;
			}
			
			int basic_y = 0;
			int basic_m = 0;
			int basic_d = 0;
			
			String group_id = Common.makeRownumber("g", System.currentTimeMillis()*123+"");
			
			for(int i = 0; i < basic_len; i++){
				
				calendar.set(basic_year, basic_month-1, basic_day);
				calendar.setTimeInMillis(calendar.getTimeInMillis()+(basic_term*(i-(basic_c-1))));
				
				basic_y = calendar.get(Calendar.YEAR);
				basic_m = calendar.get(Calendar.MONTH)+1;
				basic_d = calendar.get(Calendar.DAY_OF_MONTH);
				
				String comment = "["+info.get("s_hospital_name")+"] "+params.get("pet_name")+" 기초접종"+(i+1)+"차 "+SimpleDateFormatter.toString("yyyy년 MM월 dd일", calendar)+"예약되어있습니다.";
				
				// 스케줄 등록
				params.put("sgid", Common.makeRownumber("sgid", System.currentTimeMillis()*123+""));
				params.put("uid", sessionContext.getUserMap().get("s_uid"));
				params.put("sid", "");
				params.put("registrant", sid);
				params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
				params.put("todo_date", SimpleDateFormatter.toString("yyyy-MM-dd", calendar)+" 12:00:00");
				params.put("comment", comment);
				params.put("vaccine_group", Codes.VACCINATION_BASIC_SET);
				params.put("vaccine_index", (i+1)+"");
				
				params.put("group_id", group_id);
				
				int result = SqlDao.insert("User.Schedule.v2.insertSchedule", params);
				
				// 스케줄 하위 유저,펫 등록
				params.put("sd_row", Common.makeRownumber("sd_row", System.currentTimeMillis()*1234+""));
				// sgid, uid, pid(parameter)
				params.put("status", "Y");
				
				int result2 = SqlDao.insert("User.Schedule.v2.insertDetail", params);
				
				// 접종 메세지 등록
				if(msg_send_index == i){
					
					// sms key
					Long seq = null;
					
					BatchQueryBuilder scheduleMsgQuery = new BatchQueryBuilder();
					
					for(int day = 1; day > 0; day--){
						
						calendar.set(basic_y, basic_m-1, basic_d);
						calendar.add(Calendar.DAY_OF_MONTH, -day);
						
						if(calendar.getTimeInMillis() - System.currentTimeMillis() < 0){
							continue;
						}
						
						String sms_term = (day*86400)+"";
						
						String phone = sessionContext.getUserMap().get("s_cphone_number");
						
						// SMS 등록
						SMSSender sender = new SMSSender(hsp_phone);
						String rsv = SimpleDateFormatter.toString(Config.DATE_FORMAT_SMS, calendar);
						sender.reserveSMS(phone, "동물병원 문자서비스", comment, info.get("s_s_sid"), rsv);
						seq = sender.getLastKey();
						
						scheduleMsgQuery.open();
						scheduleMsgQuery.appendString(Common.makeRownumber("scm_row", System.currentTimeMillis()+""));
						scheduleMsgQuery.appendString(params.get("sgid"));
						scheduleMsgQuery.appendString("SMS");
						scheduleMsgQuery.appendString(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar));
						scheduleMsgQuery.appendRaw(sms_term);
						scheduleMsgQuery.appendString(seq+"");
						scheduleMsgQuery.close();
						if(day > 1){
							scheduleMsgQuery.lf();
						}
					}
					
					String s = scheduleMsgQuery.build();
					if(!s.isEmpty()){
						int result3 = SqlDao.insert("User.Schedule.v2.insertMSG", s);
					}
				}
			}
			
			// 항체가검사 등록
			{
				calendar.set(basic_y, basic_m-1, basic_d);
				calendar.add(Calendar.DAY_OF_MONTH, 14);
				
				String comment = "["+info.get("s_hospital_name")+"] "+params.get("pet_name")+" 항체가검사 "+SimpleDateFormatter.toString("yyyy년 MM월 dd일", calendar)+"예약되어있습니다.";
				
				// 스케줄 등록
				params.put("sgid", Common.makeRownumber("sgid", System.currentTimeMillis()*123+""));
				params.put("uid", sessionContext.getUserMap().get("s_uid"));
				params.put("sid", "");
				params.put("registrant", sid);
				params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
				params.put("todo_date", SimpleDateFormatter.toString("yyyy-MM-dd", calendar)+" 12:00:00");
				params.put("comment", comment);
				params.put("vaccine_group", Codes.VACCINATION_BASIC_SET);
				params.put("vaccine_index", (basic_len+1)+"");
				
				int result = SqlDao.insert("User.Schedule.v2.insertSchedule", params);
				
				// 스케줄 하위 유저,펫 등록
				params.put("sd_row", Common.makeRownumber("sd_row", System.currentTimeMillis()*1234+""));
				// sgid, uid, pid(parameter)
				params.put("status", "Y");
				
				int result2 = SqlDao.insert("User.Schedule.v2.insertDetail", params);
			}
			
			// 추가접종 등록
			
			{
				calendar.set(basic_y, basic_m-1, basic_d);
				calendar.add(Calendar.YEAR, 1);
				
				String comment = "["+info.get("s_hospital_name")+"] "+params.get("pet_name")+" 추가접종 "+SimpleDateFormatter.toString("yyyy년 MM월 dd일", calendar)+"예약되어있습니다.";
				
				// 스케줄 등록
				params.put("sgid", Common.makeRownumber("sgid", System.currentTimeMillis()*123+""));
				params.put("uid", sessionContext.getUserMap().get("s_uid"));
				params.put("sid", "");
				params.put("registrant", sid);
				params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
				params.put("todo_date", SimpleDateFormatter.toString("yyyy-MM-dd", calendar)+" 12:00:00");
				params.put("comment", comment);
				params.put("vaccine_group", Codes.VACCINATION_BASIC_SET);
				params.put("vaccine_index", (basic_len+2)+"");
				
				int result = SqlDao.insert("User.Schedule.v2.insertSchedule", params);
				
				// 스케줄 하위 유저,펫 등록
				params.put("sd_row", Common.makeRownumber("sd_row", System.currentTimeMillis()*1234+""));
				// sgid, uid, pid(parameter)
				params.put("status", "Y");
				
				int result2 = SqlDao.insert("User.Schedule.v2.insertDetail", params);
			}
		}
		
		
		
		// 심장사상충 등록
		
		// 기초접종 등록
		
		//List<Map> dirofilaria_schedule = getVaccinationSchedule(params, Codes.VACCINATION_DIROFILARIA);
		
		//if(!Common.)
		
		int dirofilaria_year = Common.toInt(params.get("new_drf_year"));
		int dirofilaria_month = Common.toInt(params.get("new_drf_month"));
		int dirofilaria_day = Common.toInt(params.get("new_drf_day"));
		
		if(dirofilaria_year != 0 && dirofilaria_month != 0 && dirofilaria_day != 0){
			
			if((dirofilaria_month < 1 || dirofilaria_month > 12) || (dirofilaria_day < 1 || dirofilaria_day > 31)){
				
				return (new JSONSimpleBuilder())
						.add("result", Codes.ERROR_INVALID_PARAMETER)
						.postAdd("result_detail", Codes.ERROR_DETAIL_INVALID_DATE)
						.postAdd("rownum", params.get("rownum"))
						.build();
			}
			
			List<Map> dirofilaria_schedule = getVaccinationSchedule(params, Codes.VACCINATION_DIROFILARIA, false);
			
			String gid = "";
			int new_index = 1;
			
			if(Common.isValid(dirofilaria_schedule)){
				
				Map first = dirofilaria_schedule.get(0);
				
				// 마지막 접종 일정이 인증되지 않음
				if(!Common.isValid((String) first.get("confirmer"))){
					
					return (new JSONSimpleBuilder())
							.add("result", Codes.ERROR_INSUFFICIENT_TERMS)
							.postAdd("rownum", params.get("rownum"))
							.build();
				}
			
				gid = (String) first.get("gid");
				new_index = Common.toInt(first.get("idx"))+1;
			}
			else{
				
				gid = Common.makeRownumber("g", System.currentTimeMillis()*123+"");
			}
			//first.get("")
			
			Calendar calendar = Calendar.getInstance();
			
			
			
			calendar.set(dirofilaria_year, dirofilaria_month-1, dirofilaria_day);

			if(calendar.getTimeInMillis() < System.currentTimeMillis()){
				
				return (new JSONSimpleBuilder())
						.add("result", Codes.ERROR_INVALID_PARAMETER)
						.postAdd("result_detail", Codes.ERROR_DETAIL_INVALID_DATE)
						.postAdd("rownum", params.get("rownum"))
						.build();
			}
			
			// 병원 정보를 가져옴
			Map<String, String> info = SqlDao.getMap("Client.Hospital.getHomeInfo", sid);
			String hsp_phone = info.get("s_tel");
			
			String comment = "["+info.get("s_hospital_name")+"] "+params.get("pet_name")+" 심장사상충 접종 "+SimpleDateFormatter.toString("yyyy년 MM월 dd일", calendar)+"예약되어있습니다.";
			
			// 스케줄 등록
			params.put("sgid", Common.makeRownumber("sgid", System.currentTimeMillis()*123+""));
			params.put("uid", sessionContext.getUserMap().get("s_uid"));
			params.put("sid", "");
			params.put("registrant", sid);
			params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
			params.put("todo_date", SimpleDateFormatter.toString("yyyy-MM-dd", calendar)+" 12:00:00");
			params.put("comment", comment);
			params.put("vaccine_group", Codes.VACCINATION_DIROFILARIA);
			params.put("vaccine_index", (new_index)+"");
			
			int result = SqlDao.insert("User.Schedule.v2.insertSchedule", params);
			
			// 스케줄 하위 유저,펫 등록
			params.put("sd_row", Common.makeRownumber("sd_row", System.currentTimeMillis()*1234+""));
			// sgid, uid, pid(parameter)
			params.put("status", "Y");
			int result2 = SqlDao.insert("User.Schedule.v2.insertDetail", params);
			
			/*
			// 접종 메세지 등록
			// sms key
			Long seq = null;
			
			BatchQueryBuilder scheduleMsgQuery = new BatchQueryBuilder();
			
			for(int day = 1; day > 0; day--){
				
				calendar.set(dirofilaria_year, dirofilaria_month-1, dirofilaria_day);
				calendar.add(Calendar.DAY_OF_MONTH, -day);
				
				String sms_term = (day*86400)+"";
				
				String phone = sessionContext.getUserMap().get("s_cphone_number");
				
				SMSSender sender = new SMSSender(hsp_phone);
				String rsv = SimpleDateFormatter.toString(Config.DATE_FORMAT_SMS, calendar);
				sender.reserveSMS(phone, "동물병원 문자서비스", comment, info.get("s_s_sid"), rsv);
				seq = sender.getLastKey();
				
				scheduleMsgQuery.open();
				scheduleMsgQuery.appendString(Common.makeRownumber("scm_row", System.currentTimeMillis()+""));
				scheduleMsgQuery.appendString(params.get("sgid"));
				scheduleMsgQuery.appendString("SMS");
				scheduleMsgQuery.appendString(SimpleDateFormatter.toString("yyyy-MM-dd HH:mm:ss", calendar));
				scheduleMsgQuery.appendRaw(sms_term);
				scheduleMsgQuery.appendString(seq+"");
				scheduleMsgQuery.close();
				if(day > 1){
					scheduleMsgQuery.lf();
				}
			}
			
			int result3 = SqlDao.insert("User.Schedule.v2.insertMSG", scheduleMsgQuery.build());
				
		 */
		}
		
		///
		
//				params.put("uid", sessionContext.getUserData("s_uid"));
//				params.put("response_type", "json");
//				params.put("vc_group", "BASIC_")
//				List<Map> schedule = SqlDao.getList("Client.Pet.getVaccinationSchedule", params);
		
		
		
		
		
		
		
		//if(result > 0 && result2 > 0){
			return (new JSONSimpleBuilder())
					.add("result", Codes.SUCCESS_CODE)
					.postAdd("rownum", params.get("rownum"))
					.build();
		//}
//		else{
//			return (new JSONSimpleBuilder())
//					.add("result", Codes.RESULT_FAIL)
//					.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
//					.build();
//		}
//		
//		return builder.build();//"client/mypage/pet_reg";
	}
	
	@RequestMapping(value="*/petRemoveExecute.latte")
	public @ResponseBody String petRemoveExecute(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("petRemoveExecute.latte");
		
		// 로그인 
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth()){
			JSONSimpleBuilder builder = new JSONSimpleBuilder();
			builder.add("resultCode", Codes.ERROR_UNAUTHORIZED);
			return builder.build();
		}
		
		JSONSimpleBuilder builder = new JSONSimpleBuilder();
		
		// status = N 삭제처리
		params.put("status", "N");
		if(SqlDao.update("MyPage.updatePetStatus", params)>0){
			builder.add("resultCode", Codes.SUCCESS_CODE);
			builder.postAdd("redirect", "myPageHome.latte");
		}
		else
			builder.add("resultCode", Codes.ERROR_QUERY_EXCEPTION);
		
		return builder.build();
	}
	
	@RequestMapping(value="*/vaccinationList.latte")
	public @ResponseBody String vaccinationList(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("vaccinationList.latte");
		
		// 로그인 확인
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageHome.latte";
		
		// 병원id가 정상적이지 않음
		String sid = CommonProcess.getInstance().getCurrentSid(sessionContext, request);
		if(sid==null){
			return "client/error/domain_error";
		}
		
		params.put("uid", sessionContext.getUserData("s_uid"));
		
		Map<String, Object> schedules = new HashMap<String, Object>();
		schedules.put(Codes.VACCINATION_BASIC_SET, getVaccinationSchedule(params, Codes.VACCINATION_BASIC_SET));
		schedules.put(Codes.VACCINATION_DIROFILARIA, getVaccinationSchedule(params, Codes.VACCINATION_DIROFILARIA));
		
		// 해당 스케줄에 맞는 sid로 하단에서 백신 리스트를 가져옴.
		{
			List<Map> sl = (List<Map>) schedules.get(Codes.VACCINATION_BASIC_SET);
			if(Common.isValid(sl)){
				Iterator<Map> si = sl.iterator();
				if(si.hasNext()){
					sid = (String) si.next().get("registrant");
				}
			}
		}
		
		//params.put("species", Codes.PET_DOG_SPECIES);
		if(Common.strEqual(params.get("species"), "dog")){
			params.put("species", Codes.PET_DOG_SPECIES);
			params.put("group_type", "BASIC_DOG");
		}
		else if(Common.strEqual(params.get("species"), "cat")){
			params.put("species", Codes.PET_CAT_SPECIES);
			params.put("group_type", "BASIC_CAT");
		}
		params.put("sid", sid);
		
		//params.put("group_type", Codes.VACCINATION_BASIC_SET);
		// 기초접종 가져옴
		List<Map> vcList = SqlDao.getList("Client.Pet.getVaccineList", params);
		Map<String, List> m = Common.splitListGroupBy(vcList, "t");
		
		params.put("group_type", Codes.VACCINATION_DIROFILARIA);
		m.put(Codes.VACCINATION_DIROFILARIA, SqlDao.getList("Client.Pet.getVaccineList", params));
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("v", m);
		result.put("s", schedules);
		
		// 결과를 json으로 리턴
		return JSONUtil.getInstance(Config.DEFAULT_CHARSET,false).toJSONString(result);
	}
	
	@SuppressWarnings("rawtypes")
	private List<Map> getVaccinationSchedule(Map<String, String> params, String vc_group){
		
		Map<String, String> p = new HashMap<String, String>();
		
		p.put("uid", params.get("uid"));
		p.put("pid", params.get("pid"));
		p.put("response_type", "json");
		p.put("vc_group", vc_group);
		return SqlDao.getList("Client.Pet.getVaccinationSchedule", p);
	}
	
	@SuppressWarnings("rawtypes")
	private List<Map> getVaccinationSchedule(Map<String, String> params, String vc_group, boolean is_asc){
		
		Map<String, String> p = new HashMap<String, String>();
		
		p.put("uid", params.get("uid"));
		p.put("pid", params.get("pid"));
		p.put("response_type", "json");
		p.put("vc_group", vc_group);
		p.put("sort", is_asc?"ASC":"DESC");
		return SqlDao.getList("Client.Pet.getVaccinationSchedule", p);
	}
	
	private long calTerm(long term_val, String term_type){
		
		return term_type.equals("DAY")?(term_val*86400000L):
			term_type.equals("WEEK")?(term_val*7L*86400000L):
				term_type.equals("MONTH")?(term_val*30L*86400000L):
					term_type.equals("YEAR")?(term_val*365L*86400000L):0;
	}
}
