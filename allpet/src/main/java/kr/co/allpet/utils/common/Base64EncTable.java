package kr.co.allpet.utils.common;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class Base64EncTable {

	private static Base64EncTable instance=null;
	
	public static Base64EncTable getInstance(){
		
		if(instance==null){
			instance = new Base64EncTable();
		}
		if(instance.isEmpty()){
			instance.create();
		}
		return instance;
	}
	
	HashMap<String,String> enMap = new HashMap<String, String>();
	HashMap<String,String> deMap = new HashMap<String, String>();
	
	public Base64EncTable(){
		create();
	}
	
	private boolean isEmpty(){
		
		if(enMap.isEmpty() || deMap.isEmpty()){
			return true;
		}
		else{
			return false;
		}
	}
	
	private void create(){
		
		String[] base64 = new String[]{
				"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
				"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
				"0","1","2","3","4","5","6","7","8","9","+","/"
			};
		String[] base64_2 = base64.clone();
			
		Random random = new Random(System.nanoTime());
		int cnt = 3;
		for(int i = 0; i < 64*cnt; i++){
			int r = random.nextInt(64);
			String tmp = base64_2[r];
			base64_2[r] = base64_2[i%64];
			base64_2[i%64] = tmp;
		}
		
		for(int i = 0; i < 64; i++){
			enMap.put(base64[i], base64_2[i]);
			deMap.put(base64_2[i], base64[i]);
		}
	}
	
	public HashMap<String,String> getEncodeMap(){
		return enMap;
	}
	
	public HashMap<String,String> getDecodeMap(){
		return deMap;
	}
	
	public String getEncodedString(String str) throws IllegalStateException{
		return Base64EncTable.mapping(enMap, str);
	}
	
	public String getDecodedString(String str) throws IllegalStateException{
		return Base64EncTable.mapping(deMap, str);
	}
	
	public static String mapping(Map<String,String> map, String str) throws IllegalStateException{
		if(map==null || map.isEmpty()){
			throw new IllegalStateException("no have mapping data!");
		}
		StringBuilder sb = new StringBuilder();
		int strLen = str.length();
		for(int i=0; i < strLen; i++){
			String s = map.get(str.charAt(i)+"");
			sb.append(s==null?str.charAt(i):s);
		}
		return sb.toString();
	}
	
	@SuppressWarnings("unchecked")
	public static HashMap<String, String>[] getTable(){
		
		String[] base64 = new String[]{
			"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
			"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z",
			"0","1","2","3","4","5","6","7","8","9","+","/"
		};
		String[] base64_2 = base64.clone();
		
		Random random = new Random(System.nanoTime());
		int cnt = 3;
		for(int i = 0; i < 64*cnt; i++){
			int r = random.nextInt(64);
			String tmp = base64_2[r];
			base64_2[r] = base64_2[i%64];
			base64_2[i%64] = tmp;
		}
		HashMap<String,String> enMap = new HashMap<String, String>();
		HashMap<String,String> deMap = new HashMap<String, String>();
		for(int i = 0; i < 64; i++){
			enMap.put(base64[i], base64_2[i]);
			deMap.put(base64_2[i], base64[i]);
		}
		String timestamp = (System.currentTimeMillis()/60000)+"";
		enMap.put("timestamp", timestamp);
		
		return (HashMap<String, String>[]) new HashMap[]{enMap,deMap};
	}
}
