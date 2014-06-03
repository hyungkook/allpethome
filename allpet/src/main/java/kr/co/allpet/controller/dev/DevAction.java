package kr.co.allpet.controller.dev;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.allpet.dao.SqlDao;
import kr.co.allpet.utils.client.Config;
import kr.co.allpet.utils.client.SessionContext;
import kr.co.allpet.utils.common.Base64EncTable;
import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.EncodingUtil;
import kr.co.allpet.utils.common.SMSUtil;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sun.xml.internal.messaging.saaj.util.Base64;

@Controller
public class DevAction {
	
	@SuppressWarnings("rawtypes")
	@Resource(name="sessionContextFactory")
	ObjectFactory sessionContextFactory;

	@RequestMapping(value = "/ajaxDevLog.latte")
	public @ResponseBody String ajaxDevLog(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {

		System.out.println("--- start ------------------------------------");
		System.out.println(params);
		System.out.println("--- end --------------------------------------");

		return "";
	}
	
	@RequestMapping(value = "/ajaxBase64Request.latte")
	public @ResponseBody String ajaxBase64Request(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		
		Base64EncTable t = Base64EncTable.getInstance();
		request.getSession().setAttribute("base64encode",t.getEncodeMap());
		request.getSession().setAttribute("base64decode",t.getDecodeMap());
		
		return JSONObject.toJSONString(t.getEncodeMap());
	}
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ajaxBase64Test.latte")
	public @ResponseBody String ajaxBase64Test(Model model, HttpServletRequest request, @RequestParam Map<String, String> params) {
		String data = params.get("data");
		HashMap<String, String> map = (HashMap<String, String>) request.getSession().getAttribute("base64decode");
		System.out.println("decoded:"+EncodingUtil.URLDecode(Base64.base64Decode(Base64EncTable.mapping(map, data)),"UTF-8"));
		//System.out.println("decoded:"+EncodingUtil.unescape(Base64.base64Decode(sb.toString())));
		
		return "";
	}
	
	@RequestMapping(value = "/ajaxStaffImgUpload.latte")
	public @ResponseBody String ajaxImageUpload(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		params.put("crop_url", "");
			
		params.put("width", "800");
		params.put("height", "450");
		
		params.put("base_w", "800");
		params.put("base_h", "450");

		
		params.put("thum_w", "800");
		params.put("thum_h", "450");
		
		params.put("imgsrc", "");
			
		params.put("crop_w", "800");
		params.put("crop_h", "450");
		
		return JSONObject.toJSONString(params);
	}
	
	@RequestMapping(value = "/testPage.latte")
	public String testPage(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		return "client/test/"+params.get("url");
	}
	
	@RequestMapping(value = "/testDropOk.latte")
	public String myPageDropMemberAccept(Model model, HttpSession session, @RequestParam Map<String, String> params) {

		model.addAttribute("msg", "정상적으로 탈퇴 처리 되었습니다.");
		return "client/mypage/mypage_drop_ok";
	}

	@RequestMapping(value = "/smsTest1.latte")
	public String smsTest1(Model model, HttpServletRequest request, HttpServletResponse response, HttpSession session, @RequestParam Map<String, String> params) throws Exception {
		
		String str = "뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫";
		
//		System.out.println(SMSUtil.getInstance().getMsgLength("안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요요요요요요요요요"));
//		System.out.println(SMSUtil.getInstance().getMsgLength("뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫꺫"));
//		System.out.println(SMSUtil.getInstance().getMsgLength("ashhfa983hfafㅁ3ㅗㄹ졸8ㅗㅈ98롲댜ㅗㅁㄹㄷ8ㅈㅁ러3ㅈ8ㅗㄱ8ㅁ조9ㄹ먀저3ㅈ9ㅗㄱㅁ98굣ㄱ오소ㅗㅗ56ghㅇㄱ5ㅗ554"));
//		System.out.println(SMSUtil.getInstance().getMsgLength("一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十一二三四五六七八九十五六七八九十一二三四五六七八九十"));
//		System.out.println(SMSUtil.getInstance().getMsgLength("뺇안"));
		
		//89
		System.out.println(SMSUtil.getInstance().getMsgLength("ashhfa983hfafㅁ3ㅗㄹ졸8ㅗㅈ98롲댜ㅗㅁㄹㄷ8ㅈㅁ러3ㅈ8ㅗㄱ8ㅁ조9ㄹ먀저3ㅈ9ㅗㄱㅁ98굣ㄱ오소ㅗ"));
		//90
		System.out.println(SMSUtil.getInstance().getMsgLength("뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫뺇뛣뺇떏꺫"));
//		
//		System.out.println(SMSUtil.getInstance().getMsgLength("ashhfa983hfafㅁ3ㅗㄹ졸8ㅗㅈ98롲댜ㅗㅁㄹㄷ8ㅈㅁ러3ㅈ8ㅗㄱ8ㅁ조9ㄹ먀저3ㅈ9ㅗㄱㅁ98굣ㄱ오소9"));
//		System.out.println(SMSUtil.getInstance().getMsgLength("ashhfa983hfafㅁ3ㅗㄹ졸8ㅗㅈ98롲댜ㅗㅁㄹㄷ8ㅈㅁ러3ㅈ8ㅗㄱ8ㅁ조9ㄹ먀저3ㅈ9ㅗㄱㅁ98굣ㄱ오소ㅗ"));
//		System.out.println("ashhfa983hfafㅁ3ㅗㄹ졸8ㅗㅈ98롲댜ㅗㅁㄹㄷ8ㅈㅁ러3ㅈ8ㅗㄱ8ㅁ조9ㄹ먀저3ㅈ9ㅗㄱㅁ98굣ㄱ오소ㅗ".length());
		
//		SMSUtil.getInstance().sendSMS("01024781727", "ashhfa983hfafㅁ3ㅗㄹ졸8ㅗㅈ98롲댜ㅗㅁㄹㄷ8ㅈㅁ러3ㅈ8ㅗㄱ8ㅁ조9ㄹ먀저3ㅈ9ㅗㄱㅁ98굣ㄱ오소9ㅗ", "테스트문자");;
		//SMSUtil.getInstance().sendSMS("01024781727", "test", "테스트문자");
		
		Calendar calendar = Calendar.getInstance();
		calendar.set(2014, 2, 10, 14, 37, 00);
		//calendar.add(Calendar.DAY_OF_MONTH, -3);
		String rsv = (String.format("%04d%02d%02d%02d%02d%02d", 
				calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH)+1, calendar.get(Calendar.DAY_OF_MONTH),
				calendar.get(Calendar.HOUR_OF_DAY), calendar.get(Calendar.MINUTE), calendar.get(Calendar.SECOND)));
		SMSUtil.getInstance().sendSMSReserve("01024781727", "테스트", "테스트", "key", rsv);
		
//		HashMap<String,String> m = new HashMap<String, String>();
//		m.put("val", "aaa");
//		int result = SqlDao.insert("SMS.insertAutoIncTest", m);
		//System.out.println("send!");
		
		return "";
	}
}
