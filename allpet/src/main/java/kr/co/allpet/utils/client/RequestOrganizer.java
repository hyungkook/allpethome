package kr.co.allpet.utils.client;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

/**
 * 서블릿 접근시 액션명 별로 request 개수 카운트...
 *
 */
public class RequestOrganizer {

	private static RequestOrganizer mRequestOrganizer = null;
	
	public static RequestOrganizer getInstance(){
		
		if(mRequestOrganizer==null){
			mRequestOrganizer = new RequestOrganizer();
		}
		
		return mRequestOrganizer;
	}
	
	private HashMap<String, Object[]> map = null;
	
	private long lastTime = 0;
	
	private int REQUEST_URL = 0;
	private int COUNT = 1;
	
	private RequestOrganizer(){
		map = new HashMap<String, Object[]>();
	}
	
	public synchronized void add(String request_url, SessionContext sc){
		
		Object[] data = map.get(request_url);
		
		if(data==null){
			
			data = new Object[2];
			data[REQUEST_URL] = request_url;
			data[COUNT] = new Integer(1);
			
			map.put(request_url, data);
		}
		else{
			
			Integer i = (Integer)data[COUNT];
			i+=1;
			data[COUNT] = i;
		}
		
		long cur = System.currentTimeMillis();
		if(cur > lastTime + 60000){
			
			Set<String> s = map.keySet();
			Iterator<String> iter = s.iterator();
			while(iter.hasNext()){
				Object[] arr = map.get(iter.next());
				System.out.println(cur+" : "+arr[REQUEST_URL]+", "+arr[COUNT]);
			}
			lastTime = cur;
			map.clear();
		}
	}
}
