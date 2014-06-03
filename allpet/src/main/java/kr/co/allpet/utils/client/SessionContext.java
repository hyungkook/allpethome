package kr.co.allpet.utils.client;


import java.io.Serializable;
import java.util.Map;

import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

@Scope(value="session")
@Component("sessionContext")
@SuppressWarnings("unused")
public class SessionContext implements Serializable  {
	
	private static final long serialVersionUID = -7368942518628048455L;
	
	private boolean auth;
	private boolean adminAuth;
	private Map<String, String> userMap;
	private String s_uid = "";
	
	public void setUserData(String key, String val){
		
		if(userMap!=null){
			userMap.put(key, val);
		}
	}
	
	public String getUserData(String key){
		
		if(userMap==null){
			return null;
		}
		else{
			return userMap.get(key);
		}
	}

	public Map<String, String> getUserMap() {
	   return userMap;
	}

	public void setUserMap(Map<String, String> userMap) {
		this.userMap = userMap;
	}
	
	public boolean isAuth() {
	    return auth;
	}

	public void setAuth (boolean auth) {
		this.auth = auth;
	}
	
	public boolean isAdminAuth(){
		return adminAuth;
	}

	public void setAdminAuth(boolean auth){
		this.adminAuth = auth;
	}
}
