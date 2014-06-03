package kr.co.allpet.utils.client;

import java.io.File;
import java.util.Map;

import kr.co.allpet.utils.common.Common;


public class Config {
	
	/* 
	 * Develop : YCNa (ADVentures)
	 *
	 * BeautyLatte : Application Setup Config
	 * 
	 */
	
	private static Config config = null;	
	private static Map<String, String> configMap = null;
	
	private static String PROJECT_NAME = "allpet";
	
	public static String REFERER = "ALLPET";			// 유저 회원가입시 가입 경로
	
	public static String DEFAULT_CHARSET = "UTF-8";
	public static String DEFAULT_CHARSET_L = "utf-8";
	
	private static String CONTEXT_ROOT = "petmd";
	
	// DOMAIN
	
	// live
//	public static String dns 		= "http://m.beautylatte.co.kr";
//	public static String img_dns 	= "http://h.allpethome.co.kr/";
	public static String img_dns 	= File.separator + CONTEXT_ROOT + "/getImages/";
	
	public static String IMAGE_PATH_ROOT = "/resource/";
	
	// Develop - true/false
	public static boolean DEBUG = false;

	// Template Path (Client)
	public static String JSPATH 	= "../common/template/js";
	public static String CSSPATH 	= "../common/template/css";
	public static String FONTPATH	= "../common/template/font";
//	public static String IMGPATH	= img_dns + "/common/template/images";
	public static String IMGPATH	= "../common/template/images";

	// SMS Info
	public static String ADV_ID		= "ADV_00000000000000000000000000000";
	public static String ADV_SMS_ID	= "adventures";
	public static String ADV_TELNO		= "16661609";
		
	// Common split char
	public static String SPLIT_CHAR = "!#@_ADV_&^%()!";

	public static String PATH_MAIL_LAYOUT = "/WEB-INF/views/client/common/mail_layout/default.txt";
	
	// Check Text
	public static String []validateNickNames = {
													"뷰띠라떼",
													"뷰티라떼",
													"BEAUTYLATTE",
													"beautylatte",
													"BeautyLatte",
													"메디라떼",
													"medilatte",
													"MediLatte",
													"admin",
													"administrator",
													"관리자",
													"뚜",
													"운영자",
													"관리인",
													""
												};
	
	// API
	public static String NAVER_SEARCH_KEY = "e5c7e6345fde45b560a5e0b7e99ab82e";
	
	// 지도 user key */
	public static String NAVER_MAP_KEY = "3655d60adc511e2fa3586d78a2ec289d";
	public static String DAUM_MAP_KEY = "70e6396f64364d307d16899c5a90cb9811e02ffa";
	
	// LOG PATH
	public static String LOG_PATH_ROOT 		= "/mnt/SERVICE_LOG/petmd";
	public static String LOG_PATH_DEV 			= "d:/log";
	public static String LOG_PATH_LOGIN 		= LOG_PATH_ROOT+"/login";
	public static String LOG_PATH_REQUEST_URL 	= LOG_PATH_ROOT+"/request_url";
	
	public static String SVC_ID_MEDI		= "SID_00001";
	public static String SVC_ID_BEAUTY 	= "SID_00002";
	
	public static String DATE_FORMAT_SMS = "yyyyMMddHHmmss";
	public static String DATE_FORMAT_DB = "yyyy-MM-dd HH:mm:ss";
	
	public Config() {
		config = this;
	}
	
	public static Config getConfig(){
		return new Config();
	}
	
	public Map<String, String> getConfigMap(){
		if(configMap == null){
			configMap = Common.getFieldMap(config);	
		}
		
		return configMap;
	}
}
