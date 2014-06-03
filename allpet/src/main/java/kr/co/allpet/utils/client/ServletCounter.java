package kr.co.allpet.utils.client;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import kr.co.allpet.dao.SqlDao;

public class ServletCounter extends Thread{
	
	private class Counter{
		
		int cnt = 0;
		
		public void inc(){
			
			cnt++;
		}
		
		public int get(){
			
			return cnt;
		}
	}
	
	HashMap<String, Counter> map = new HashMap<String, Counter>();
	
	ArrayList<String> names = new ArrayList<String>();

	public synchronized void check(String name){
		
		if(name==null || name.length()==0){
			return;
		}
		
		Counter c = map.get(name);
		if(c==null){
			
			c = new Counter();
			map.put(name, c);
			names.add(name);
		}
		
		c.inc();
	}
	
	@Override
	public void run(){
		
		try{
			while(true){
				//long newTime = System.currentTimeMillis();
				//if(newTime > lastTime + term){
					//lastTime = newTime;
					//act();
				//}
				int s = names.size();
				if(s > 0){
					Map<String, String> p = new HashMap<String, String>();
					for(int i = 0; i < s; i++){
						p.put(names.get(i), map.get(names.get(i)).get()+"");
						SqlDao.insert("insertOrUpdatePageview", p);
					}
				}
				map.clear();
				names.clear();
				
				sleep(60000);
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			//instance=null;
		}
	}
}
