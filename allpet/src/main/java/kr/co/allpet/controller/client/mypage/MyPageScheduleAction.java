package kr.co.allpet.controller.client.mypage;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
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
import kr.co.allpet.utils.common.SMSUtil;
import kr.co.allpet.utils.common.SimpleDateFormatter;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MyPageScheduleAction {
	
	private static final Logger logger = LoggerFactory.getLogger(MyPageScheduleAction.class);
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;
	
	public void c(HttpServletRequest request){
		
		String hexip = "";
		
		InetAddress ad = null;
		try {
			ad = InetAddress.getLocalHost();
			
			String[] ip = ad.getHostAddress().split("\\.");
			hexip=Integer.toHexString(Integer.parseInt(ip[0], 10))
					+Integer.toHexString(Integer.parseInt(ip[1], 10))
					+Integer.toHexString(Integer.parseInt(ip[2], 10))
					+Integer.toHexString(Integer.parseInt(ip[3], 10));

		} catch (Exception e) {
			e.printStackTrace();
		}
		
		String d = Long.toHexString(Calendar.getInstance().getTimeInMillis())+hexip;
		//144b a4ed 01f
		//422a924c72e
	}
	
	@RequestMapping(value="*/myPageSchedule.latte")
	public String myPageSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("myPageSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageSchedule.latte";
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		List list = SqlDao.getList("User.Schedule.getMonthList", params);
		model.addAttribute("monthList", list);
		
		if(!Common.isValid(params.get("date"))){
			params.put("type", "month");
			params.put("date", (new SimpleDateFormat("yyyy-MM")).format(Calendar.getInstance().getTime()));
		}
		// 파라미터에 date가 없거나, 있긴한데 스케줄이 없을 경우
		else if(Common.isValid(list)
				&& (!Common.isValid(params.get("date")) || Common.isExist(list, "date", params.get("date")))){
		
			boolean existFutrue = false;
			
			String s_futrueMinDate = "";
			String s_lastMinDate = "";
			
			// 최소값을 비교하기 위해 날짜>숫자 변환하여 저장하는 변수들
			int n_futrueMinDate = 99999999;
			int n_lastMinDate = 99999999;
			int futureMin = 99999999;
			int lastMin = 99999999;
			Iterator iter = list.iterator();
			
			// 1. n_futrueMinDate, 현재 시간을 기준으로 이후 날짜들을 asc 정렬한다. 현재가 9월일 경우 9, 10, 11... 
			// 2. s_lastMinDate, 현재 시간을 기준으로 이전 날짜들을 desc 정렬한다. 현재가 9월일 경우 9, 8, 7...
			while(iter.hasNext()){
				Map map = (Map) iter.next();
				int td = Common.parseInt((String)map.get("year")+(String)map.get("month"));
				Calendar c = Calendar.getInstance();
				int cur = Common.parseInt(c.get(Calendar.YEAR)+String.format("%02d", c.get(Calendar.MONTH)+1));
				
				int d = Math.abs(cur-td);
				
				// 과거
				if(cur - td > 0){
					if(d < lastMin){
						lastMin = d;
						s_lastMinDate = (String)map.get("date");
						n_lastMinDate = td;
					}
					else if(d == lastMin && n_lastMinDate < td){
						s_lastMinDate = (String)map.get("date");
						n_lastMinDate = td;
					}
				}
				// 현재~미래
				else{
					if(d < futureMin){
						futureMin = d;
						s_futrueMinDate = (String)map.get("date");
						n_futrueMinDate = td;
					}
					else if(d == futureMin && n_futrueMinDate < td){
						s_futrueMinDate = (String)map.get("date");
						n_futrueMinDate = td;
					}
					if(!existFutrue)
						existFutrue = true;
				}
			}
			
			// 미래값이 있으면 미래값의 우선순위가 더 높다.
			// ex) 8, 9, 10, 11 월이 있고 현재 월이 9월일 경우 우선순위 9, 10, 11, 8
			if(existFutrue)
				params.put("date", s_futrueMinDate);
			else
				params.put("date", s_lastMinDate);
		}
		else{
			
		}
		
		List userTodoList = SqlDao.getList("User.Schedule.v2.getList", params);
		model.addAttribute("userTodoList", userTodoList);
		model.addAttribute("ef_nearest", SqlDao.getMap("User.Schedule.getEffectiveNearset", params.get("uid")));
		model.addAttribute("selectedDate", params.get("date"));
		
		Calendar c = Calendar.getInstance();
		
		params.put("year", c.get(Calendar.YEAR)+"");
		params.put("month", (c.get(Calendar.MONTH)+1)+"");
		params.put("day", (c.get(Calendar.DAY_OF_MONTH))+"");
		params.put("hour", (c.get(Calendar.HOUR_OF_DAY))+"");
		params.put("minute", (c.get(Calendar.MINUTE))+"");
		
		model.addAttribute("params", params);
		
		return "client/mypage/schedule_list";
	}
	
	// 스케줄 리스트에서 날짜 변경시 호출
	@RequestMapping(value="*/ajaxMyPageSchedule.latte")
	public String ajaxMyPageSchedule(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxMyPageSchedule.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageSchedule.latte";
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		List userTodoList = SqlDao.getList("User.Schedule.v2.getList", params);
		model.addAttribute("userTodoList", userTodoList);
		model.addAttribute("ef_nearest", SqlDao.getMap("User.Schedule.getEffectiveNearset", params.get("uid")));
		model.addAttribute("selectedDate", params.get("date"));
		
		return "client/mypage/schedule_list_item";
	}
	
	@RequestMapping(value="*/myPageScheduleEdit.latte")
	public String myPageScheduleEdit(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("myPageScheduleEdit.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageSchedule.latte";
		
		if(Common.isValid(params.get("rownum"))){
			
			params.put("uid", sessionContext.getUserMap().get("s_uid"));
			
			//Map<String, String> map = SqlDao.getMap("User.Schedule.getSchedule", params);//.get("rownum"));
			Map<String, String> map = SqlDao.getMap("User.Schedule.v2.getSchedule", params.get("rownum"));//.get("rownum"));
			
			if(map != null && !map.isEmpty()){
				
				params.put("year", map.get("d_todo_year"));
				params.put("month", map.get("d_todo_month"));
				params.put("day", map.get("d_todo_day"));
				params.put("hour", map.get("d_todo_hour"));
				params.put("minute", map.get("d_todo_minute"));
				
				model.addAttribute("schedule", map);
			}
			else{
				Calendar c = Calendar.getInstance();
				
				params.put("year", c.get(Calendar.YEAR)+"");
				params.put("month", (c.get(Calendar.MONTH)+1)+"");
				params.put("day", (c.get(Calendar.DAY_OF_MONTH))+"");
				params.put("hour", (c.get(Calendar.HOUR_OF_DAY))+"");
				params.put("minute", (c.get(Calendar.MINUTE))+"");
			}
			
			params.put("type", "modify");
		}
		else{
			Calendar c = Calendar.getInstance();
			
			params.put("year", c.get(Calendar.YEAR)+"");
			params.put("month", (c.get(Calendar.MONTH)+1)+"");
			params.put("day", (c.get(Calendar.DAY_OF_MONTH))+"");
			params.put("hour", (c.get(Calendar.HOUR_OF_DAY))+"");
			params.put("minute", (c.get(Calendar.MINUTE))+"");
			
			params.put("type", "new");
		}
		
		model.addAttribute("params", params);
		
		return "client/mypage/schedule_edit";
	}
	
	@RequestMapping(value="*/ajaxMyPageScheduleRegist_v2.latte")
	public @ResponseBody String ajaxMyPageScheduleRegist_v2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		////logger.info("myPageScheduleRegist.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_UNAUTHORIZED)
					.build();
		
		//params.put("rownum", Common.makeRownumber("usid", System.currentTimeMillis()*123+""));
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		params.put("sid", "");
		params.put("registrant", sessionContext.getUserMap().get("s_uid"));
		params.put("type", Codes.REGISTRANT_TYPE_USER);
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		//int result = SqlDao.insert("User.Schedule.v2.insertSchedule", params);
		
		String sgid = Common.makeRownumber("sgid", System.currentTimeMillis()*123+"");
		params.put("sgid", sgid);
		//params.put("uid", ids);
		//params.put("sid", "");
		//params.put("registrant", sessionContext.getUserMap().get("s_sid"));
		//params.put("type", Codes.REGISTRANT_TYPE_HOSPITAL);
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		int result = SqlDao.insert("User.Schedule.v2.insertSchedule", params);
		
		// 스케줄 해당 유저/동물 입력		
		params.put("sd_row", Common.makeRownumber("sd_row", System.currentTimeMillis()*1234+""));
		params.put("sgid", sgid);
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		params.put("status", "Y");
		
		int result2 = SqlDao.insert("User.Schedule.v2.insertDetail", params);
		
		if(result > 0 && result2 > 0){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_SUCCESS)
					.postAdd("code", Codes.SUCCESS_CODE)
					.postAdd("rownum", params.get("rownum"))
					.build();
		}
		else{
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
					.build();
		}
	}
	
	@RequestMapping(value="*/ajaxMyPageScheduleModify_v2.latte")
	public @ResponseBody String ajaxMyPageScheduleModify_v2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		////logger.info("myPageScheduleModify.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth()){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_UNAUTHORIZED)
					.build();
		}
		
		//params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		String rownum = params.get("rownum");
		params.put("sgid", rownum);
		
		Map origin_info = null;
		if(rownum!=null){
			//origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
			
			origin_info = SqlDao.getMap("User.Schedule.v2.getSchedule", rownum);
		}
		// 기존 스케줄 정보를 가져올 수 없음
		if(origin_info==null){
			
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_MISSING_PARAMETER)
					.build();
		}
		
		boolean is_different = false;
		
		// 날짜가 다른가?
		{
			Date ori_date = null;
			Date mod_date = null;
			
			ori_date = SimpleDateFormatter.toDate("yyyy-MM-dd HH:mm:ss", Common.toString(origin_info.get("d_todo_date")));
			mod_date = SimpleDateFormatter.toDate("yyyy-MM-dd HH:mm:ss", Common.toString(params.get("todo_date")));
			
			if(ori_date != null && mod_date != null){
				is_different = !ori_date.equals(mod_date);
			}
		}
		
		// 내용이 다른가?
		if(!is_different){
			is_different = !Common.strEqualNN(origin_info.get("s_comment"), params.get("comment"));
		}
		
		int result = 0;
		
		if(is_different){
			result = SqlDao.update("User.Schedule.v2.updateSchedule", params);
		}
		else{
			result = 1;
		}
		
		if(result > 0){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_SUCCESS)
					.postAdd("code", Codes.SUCCESS_CODE)
					.build();
		}
		else{
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
					.build();
		}
	}
	
	@RequestMapping(value="*/ajaxMyPageScheduleRemove_v2.latte")
	public @ResponseBody String ajaxMyPageScheduleRemove_v2(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		////logger.info("myPageScheduleRemove.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth()){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_UNAUTHORIZED)
					.build();
		}
		
		if(Common.isValid(params.get("rownum"))){
			
			params.put("uid", sessionContext.getUserMap().get("s_uid"));
			
			// 기존 스케줄 정보를 가져옴
			String rownum = params.get("rownum");
//			Map origin = null;
//			if(rownum!=null){
//				origin = SqlDao.getMap("User.Schedule.v2.getSchedule", params);
//			}
//			
//			// 스케줄 삭제
//			int result = SqlDao.update("User.Schedule.v2.removeSchedule", params);//.get("rownum"));
//			
//			// 연계된 예약 문자 메세지 삭제
//			SMSUtil.getInstance().cancelSMS((String) origin.get("s_sms_key"));
			
			Map origin_info = null;
			if(rownum!=null){
				//origin = SqlDao.getMap("Admin.Hospital.Schedule.getOneSchedule", rownum);
				
				origin_info = SqlDao.getMap("User.Schedule.v2.getScheduleInfo", rownum);
			}
			// 기존 스케줄 정보를 가져올 수 없음
			if(origin_info==null){
				//return builder.add("result", Codes.ERROR_MISSING_PARAMETER).build();
				return (new JSONSimpleBuilder())
						.add("result", Codes.RESULT_FAIL)
						.postAdd("code", Codes.ERROR_MISSING_PARAMETER)
						.build();
			}
			else{
				String sgid = params.get("rownum");
				
				// 등록된 메세지를 삭제
				String s = (String) origin_info.get("_key");
				if(s!=null){
					String[] msg_keys = s.split(";");
					for(int i = 0; i < msg_keys.length; i++){
						SMSUtil.getInstance().cancelSMS(msg_keys[i]);
					}
				}
				SqlDao.delete("User.Schedule.v2.deleteMSG", sgid);
			}
			
			int result = SqlDao.update("User.Schedule.v2.removeSchedule", params.get("rownum"));
			
			if(result > 0){
				return (new JSONSimpleBuilder())
						.add("result", Codes.RESULT_SUCCESS)
						.postAdd("code", Codes.SUCCESS_CODE)
						.build();
			}
			else{
				return (new JSONSimpleBuilder())
						.add("result", Codes.RESULT_FAIL)
						.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
						.build();
			}
		}
		else{
			// 파라미터 손실
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_MISSING_PARAMETER)
					.build();
		}
	}
	
	@RequestMapping(value="*/ajaxMyPageScheduleRegist.latte")
	public @ResponseBody String ajaxMyPageScheduleRegist(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("myPageScheduleRegist.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_UNAUTHORIZED)
					.build();
		
		params.put("rownum", Common.makeRownumber("usid", System.currentTimeMillis()*123+""));
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		params.put("sid", "");
		params.put("registrant", sessionContext.getUserMap().get("s_uid"));
		params.put("type", Codes.REGISTRANT_TYPE_USER);
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		int result = SqlDao.insert("User.Schedule.insertSchedule", params);
		
		if(result > 0){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_SUCCESS)
					.postAdd("code", Codes.SUCCESS_CODE)
					.postAdd("rownum", params.get("rownum"))
					.build();
		}
		else{
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
					.build();
		}
	}
	
	@RequestMapping(value="*/ajaxMyPageScheduleModify.latte")
	public @ResponseBody String ajaxMyPageScheduleModify(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("myPageScheduleModify.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth()){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_UNAUTHORIZED)
					.build();
		}
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		params.put("todo_date", params.get("year")+"-"+params.get("month")+"-"+params.get("day")+" "+params.get("hour")+":"+params.get("minute")+":"+"00");
		
		int result = SqlDao.update("User.Schedule.updateSchedule", params);
		
		if(result > 0){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_SUCCESS)
					.postAdd("code", Codes.SUCCESS_CODE)
					.build();
		}
		else{
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
					.build();
		}
	}
	
	@RequestMapping(value="*/ajaxMyPageScheduleRemove.latte")
	public @ResponseBody String ajaxMyPageScheduleRemove(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("myPageScheduleRemove.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth()){
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_UNAUTHORIZED)
					.build();
		}
		
		if(Common.isValid(params.get("rownum"))){
			
			params.put("uid", sessionContext.getUserMap().get("s_uid"));
			
			// 기존 스케줄 정보를 가져옴
			String rownum = params.get("rownum");
			Map origin = null;
			if(rownum!=null){
				origin = SqlDao.getMap("User.Schedule.getSchedule", params);
			}
			
			// 스케줄 삭제
			int result = SqlDao.update("User.Schedule.removeSchedule", params);//.get("rownum"));
			
			// 연계된 예약 문자 메세지 삭제
			SMSUtil.getInstance().cancelSMS((String) origin.get("s_sms_key"));
			
			if(result > 0){
				return (new JSONSimpleBuilder())
						.add("result", Codes.RESULT_SUCCESS)
						.postAdd("code", Codes.SUCCESS_CODE)
						.build();
			}
			else{
				return (new JSONSimpleBuilder())
						.add("result", Codes.RESULT_FAIL)
						.postAdd("code", Codes.ERROR_QUERY_PROCESSED)
						.build();
			}
		}
		else{
			// 파라미터 손실
			return (new JSONSimpleBuilder())
					.add("result", Codes.RESULT_FAIL)
					.postAdd("code", Codes.ERROR_MISSING_PARAMETER)
					.build();
		}
	}
	
	// 달력 생성시 기념일(휴일 등) 맵을 ajax로 반환
	@SuppressWarnings("unchecked")
	@RequestMapping(value="*/ajaxRequestAnniversary.latte")
	public @ResponseBody String ajaxRequestAnniversary(Model model, HttpServletRequest request, @RequestParam Map<String, String> params){
		//logger.info("ajaxRequestAnniversary.latte");
		
		SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
		
		if(!sessionContext.isAuth())
			return "redirect:login.latte?rePage=myPageSchedule.latte";
		
		params.put("uid", sessionContext.getUserMap().get("s_uid"));
		
		// 날짜와 유저아이디 유효성 확인
		if(Common.isValid(params.get("month")) && Common.isValid(params.get("uid"))){
			
			// 양력으로 기념일 리스트를 가져옴
			//DateMapBuilder dmBuilder = new DateMapBuilder();
			List<Map> list = SqlDao.getList("User.Schedule.getSolarAnniversaryList", params.get("month").split("-")[0]);
			//dmBuilder.insertList(list);
			
			Map<String, List<Map>> map = new HashMap<String, List<Map>>();
			map = insertDateMap(map, list);
			
			// 유저 스케줄 리스트를 가져옴
			list = SqlDao.getList("User.Schedule.v2.getListForCalendar", params);
			map = insertDateMap(map, list);
			
			return JSONUtil.getInstance(Config.DEFAULT_CHARSET,false).toJSONString(map);//dmBuilder.getMapList());
		}
		
		return "";
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private Map insertDateMap(Map map, List<Map> list){
		
		Iterator<Map> iter = list.iterator();
		while(iter.hasNext()){
			Map m = iter.next();
			
			List<Map> l = (List<Map>) map.get(m.get("d"));
			if(l==null){
				l = new ArrayList<Map>();
				map.put((String) m.get("d"),l);
			}
			m.remove("d");
			l.add(m);
		}
		return map;
	}
	
	
}
