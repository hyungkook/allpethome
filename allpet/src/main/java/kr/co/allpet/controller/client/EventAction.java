package kr.co.allpet.controller.client;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.common.Common;

import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class EventAction {

private static final Logger logger = LoggerFactory.getLogger(LoginAction.class);
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;
	
	@RequestMapping(value = { "*/eventGolfAction.latte"})
	public @ResponseBody String joinAccept(Model model, HttpServletRequest request, HttpSession session, @RequestParam Map<String, String> params) {
		
		String _value = "";
		
		String checkCnt = SqlDao.getString("EVENTTEMP.checkEvent", params);
		if( checkCnt == null || "".equals(checkCnt) ){
		
			int _rCnt = SqlDao.insert("EVENTTEMP.insertEventGolf", params);
			if (_rCnt == 0) {
				_value = "0000";
			} else {
				_value = "9999";
			}
		}else{
			_value = "1111";
		}
		
		JSONObject obj = new JSONObject();
	    obj.put("result", _value);
	    
		return "callback(" +obj.toString() + ")";
	}
	
}
