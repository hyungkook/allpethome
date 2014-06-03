package kr.co.allpet.utils.client;

import java.util.Map;

import kr.co.allpet.utils.common.Common;

public class Codes {
	
	private static Codes codes = null;	
	private static Map<String, String> codeMap = null;
	
	public Codes() {
		codes = this;
	}
	
	public static Codes getCodes(){
		return new Codes();
	}
	
	public Map<String, String> getCodesMap(){
		if(codeMap == null){
			codeMap = Common.getFieldMap(codes);	
		}
		
		return codeMap;
	}
	
	
	
	public static String VACCINATION_BASIC_SET = "BASIC_SET";
	public static String VACCINATION_DIROFILARIA = "DIROFILARIA";
	
	/**
	 * ELEMENTS
	 */
	
	public static String STAFF_PAST = "STAFF_PAST";
	public static String STAFF_PAST_HISTORY = "10001";			// 이력사항
	public static String STAFF_PAST_CAREER = "10002";			// 학술활동
	public static String STAFF_PAST_BOOKS = "10003";			// 저서
	
	public static String REGISTRANT_TYPE_USER = "USR";			// 등록자 - 유저
	public static String REGISTRANT_TYPE_HOSPITAL = "AHSP";	// 등록자 - 병원
	
	public static String IMAGE_TYPE_HOSPITAL_INTRO = "HINT";	// 병원 소개 이미지 
	public static String IMAGE_TYPE_HOSPITAL_LOGO = "HLG";		// 병원 로고 이미지
	public static String IMAGE_TYPE_HOSPITAL_HEADER = "HHDR";	// 병원 헤더 이미지
	public static String IMAGE_TYPE_STAFF = "STFF";			// 스태프 이미지
	
	public static String PET_SPECIES = "PET_SPECIES";
	public static String PET_DOG_SPECIES = "DOG_SPECIES";
	public static String PET_CAT_SPECIES = "CAT_SPECIES";
	
	public static String HOSPITAL_STATUS_NORMAL = "10001";				//
	public static String HOSPITAL_STATUS_ABANDONED = "10002";
	
	public static String ELEMENT_HOSPITAL_SITE = "HOSPITAL_SITE";
	public static String ELEMENT_HOSPITAL_SITE_HOMEPAGE = "10001";		// 홈페이지
	public static String ELEMENT_HOSPITAL_SITE_BLOG = "10002";			// 블로그
	public static String ELEMENT_HOSPITAL_SITE_FACEBOOK = "10003";		// 페이스북
	public static String ELEMENT_HOSPITAL_SITE_TWITTER = "10004";		// 트위터
	public static String ELEMENT_HOSPITAL_SITE_CAFE = "10005";			// 카페
	
	public static String ELEMENT_BOARD_TYPE_NORMAL = "10001";
	public static String ELEMENT_BOARD_TYPE_IMPORTANT = "10002";
	
	public static String ELEMENT_BOARD_CONTENTS_TYPE_VIDEO_LINK = "VIDEO_LINK";
	public static String ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE = "RAW_CODE";
	public static String ELEMENT_BOARD_CONTENTS_SUBTYPE_URL_ONLY = "URL_ONLY";
	public static String ELEMENT_VIDEO_PROVIDER_YOUTUBE = "YOTUBE";
	public static String ELEMENT_VIDEO_PROVIDER_VIMEO = "VIMEO";
	
	
	
	/**
	 * STATUS INFO 테이블 정보
	 */
	
	public static String STATUS_INFO_GROUP_HOSPITAL = "HOSPITAL";
	public static String STATUS_INFO_GROUP_STAFF = "STAFF";
	public static String STATUS_INFO_LCODE_ADDRESS = "ADDRESS";
	public static String STATUS_INFO_LCODE_INFO = "INFO";
	
	
	
	/**
	 *  CUSTOMIZE 테이블
	 */
	
	public static String CUSTOM_PARENT_MAIN_MENU = "MAIN_MENU";
	public static String CUSTOM_PARENT_STAFF = "STAFF";
	
	public static String CUSTOM_CATEGORY_MAIN_MENU_1 = "MAIN_MENU_1";
	public static String CUSTOM_CATEGORY_MAIN_MENU_2 = "MAIN_MENU_2";
	public static String CUSTOM_CATEGORY_MAIN_MENU_3 = "MAIN_MENU_3";
	public static String CUSTOM_CATEGORY_MAIN_MENU_4 = "MAIN_MENU_4";
	public static String CUSTOM_CATEGORY_MAIN_MENU_5 = "MAIN_MENU_5";
	
	public static String BOARD_TYPE_RSS = "BOARD_10001";				// RSS 게시판
	public static String BOARD_TYPE_IMAGE = "BOARD_10002";				// 이미지 게시판
	public static String BOARD_TYPE_NOTICE = "BOARD_10003";			// 공지사항 게시판
	public static String BOARD_TYPE_FAQ = "BOARD_10004";				// FAQ 게시판
	
	
	
	/**
	 * 에러 코드
	 */

	public static String RESULT_SUCCESS = "success";
	public static String RESULT_FAIL = "fail";
	
	public static String SUCCESS_CODE = "1000";
	public static String ERROR_QUERY_PROCESSED = "2000";		// 파라미터 != DB데이터, 오류 없으나 결과가 0인 상태
	public static String ERROR_MISSING_PARAMETER = "2001";		// 서블릿으로 필수 파라미터가 넘어오지 않음
	public static String ERROR_QUERY_EXCEPTION = "2002";		// 쿼리 예외 (분류x)
	public static String ERROR_UNAUTHORIZED = "2003";			// 쿼리 예외 (분류x)
	public static String ERROR_INVALID_PARAMETER = "2004";			// 잘못된 파라미터
	public static String ERROR_INSUFFICIENT_TERMS = "2005";		// 조건 불충분
	
	public static String ERROR_DETAIL_INVALID_DATE = "9001";	// 날짜 부정확
	public static String ERROR_DETAIL_NOT_PRE_ = "9001";	// 날짜 부정확
	
	public static String ERROR_FAILED_SMS_SNED = "2401";			// 문자 발송 실패
	
}
