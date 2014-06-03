package kr.co.allpet.utils.common;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

/**
 * Map List String 을 JSON 문자열로 변환.
 * 
 * JSONObject.toJSONString, JSONArray.toJSONString 이 timestamp(dattime)형식을 제대로 변환하지 않아 직접 구현
 * 
 * @author Administrator
 * @date 2014. 4. 29.
 *
 */

public class JSONUtil {
	
	//private static JSONUtil instance = null;
	
	private String encoding = null;
	private boolean escape = false;
	
	public static JSONUtil getInstance(String encoding, boolean escape){
		
		//if(instance == null)
		//	instance = new JSONUtil();
		
		//return instance;
		return new JSONUtil(encoding, escape);
	}
	
	private JSONUtil(String encoding, boolean escape){
		
		this.encoding = encoding;
		this.escape = escape;
	}
	
//	public String toEncodedJSONString(Object obj){
//		
//		return toEncodedJSONString(obj, "UTF-8");
//	}

//	@SuppressWarnings("rawtypes")
//	public String toEncodedJSONString(Object obj, String encoding){
//		
//		try {
//			if(obj instanceof Map){
//				
//				return URLEncoder.encode(JSONObject.toJSONString((Map) obj),encoding);
//			}
//			else if(obj instanceof List){
//				
//				return URLEncoder.encode(JSONArray.toJSONString((List) obj),encoding);
//			}
//			else if(obj instanceof String){
//				
//				return URLEncoder.encode("{value:"+(String)obj+"}",encoding);
//			}
//			else
//				return null;
//		} catch (UnsupportedEncodingException e) {
//
//			e.printStackTrace();
//			return null;
//		}
//	}
	
	@SuppressWarnings("rawtypes")
	public String toJSONString(Object obj){
		
		if(obj instanceof Map){
				
			//return JSONObject.toJSONString((Map) obj);
			StringBuilder sb = new StringBuilder();
			mapToJsonString(sb, (Map) obj);
			return sb.toString();
		}
		else if(obj instanceof List){
			
			//return JSONArray.toJSONString((List) obj);
			StringBuilder sb = new StringBuilder();
			listToJsonString(sb, (List) obj);
			return JSONArray.toJSONString((List) obj);
		}
		else if(obj instanceof String){
			
			return "{value:"+(String)obj+"}";
		}
		else
			return null;
	}
	
	private String encode(String str){
		
		if(encoding!=null){
			try {
				str = URLEncoder.encode(str, encoding);
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(escape){
			str = EncodingUtil.escape(str); 
		}
		return str;
	}
	
	private void mapToJsonString(StringBuilder sb, Map map){
		
		sb.append("{");
		boolean first = true;
		
		Set set = map.keySet();
		Iterator iter = set.iterator();
		while(iter.hasNext()){
			if(first){first=false;}
			else{
				sb.append(",");
			}
			String key = (String) iter.next();
			Object obj = map.get(key);
			sb.append("\"");
			sb.append(encode(key));
			sb.append("\":");
			if(obj instanceof List){
				listToJsonString(sb, (List)obj);
			}
			else if(obj instanceof Map){
				mapToJsonString(sb, (Map)obj);
			}
			else{
				sb.append("\"");
				sb.append(encode(obj+"")+"\"");
			}
		}
		
		sb.append("}");
	}
	
	private void listToJsonString(StringBuilder sb, List list){
		
		sb.append("[");
		boolean first = true;
		
		Iterator iter = list.iterator();
		while(iter.hasNext()){
			if(first){first=false;}
			else{
				sb.append(",");
			}
			Object obj = iter.next();
			mapToJsonString(sb, (Map)obj);
		}
		
		sb.append("]");
	}
	
	private void arrayToJsonString(Object[] arr){
		
	}
}
