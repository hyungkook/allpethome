package kr.co.allpet.utils.client;

import java.util.HashMap;
import java.util.Map;
import java.util.List;

import kr.co.allpet.dao.SqlDao;

public class DateCache {
	
	private static class CachePair{
		public String time;
		@SuppressWarnings("rawtypes")
		public List<Map> list;
		
		@SuppressWarnings("rawtypes")
		public CachePair(String time, List<Map> list){
			this.time = time;
			this.list = list;
		}
	}
	
	private static DateCache instance = null;
	
	public static DateCache getInstance(){
		
		if(instance==null)
			instance=new DateCache();
		
		return instance;
	}
	
	private DateCache(){}

	private HashMap<String, CachePair> anniversary_cache = null;
	
	@SuppressWarnings("rawtypes")
	public List<Map> getSolarAnnivaryList(String year){
		
		String time = (System.currentTimeMillis()/60000)+"";
		
		// 최초 로드
		if(anniversary_cache==null){
			
			List<Map> list = SqlDao.getList("COMMON.getSolarAnniversaryList", year);
			
			anniversary_cache = new HashMap<String, CachePair>();
			anniversary_cache.put(year, new CachePair(time,list));
			
			System.out.println("anniversary load");
		}
		else{
			
			// 해당 날자의 데이터가 없으면 새로 로드
			CachePair cache_pair = anniversary_cache.get(year);
			if(cache_pair==null){
				
				List<Map> list = SqlDao.getList("COMMON.getSolarAnniversaryList", year);
				anniversary_cache.put(year, new CachePair(time,list));
				
				System.out.println("anniversary load");
			}
			else{
				// 리스트가 없거나, 유효 시간이 지났다면 새로 로드
				if(cache_pair.list==null || cache_pair.time==null || !cache_pair.time.equals(time)){
					List<Map> list = SqlDao.getList("COMMON.getSolarAnniversaryList", year);
					cache_pair.time = time;
					cache_pair.list = list;
					
					System.out.println("anniversary load");
				}
			}
		}
		
		return anniversary_cache.get(year).list;
	}
}
