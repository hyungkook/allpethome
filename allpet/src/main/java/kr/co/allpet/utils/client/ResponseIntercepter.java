package kr.co.allpet.utils.client;

import java.util.Calendar;
import java.util.Date;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.allpet.utils.common.Common;
import kr.co.allpet.utils.common.LogUtil;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.ObjectFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

/**
 * 공통 세션 처리를 하기 위한 인터셉터 클래스
 * @author dev1
 *preHandle	boolean	1. 클라이언트의 요청을 컨트롤러에 전달 하기 전에 호출
					2. false 인 경우 intercepter  또는 controller 를 실행 시키지 않고 
						요청 종료
  postHandle	void	1. 컨트롤러 로직 실행 된 후 호출됨
						2. 컨트롤러 실행 도중 error 발생의 경우 postHandle() 는 실행
							되지 않음
						3. request 로 넘어온 데이터 가공시 많이 쓰임
  afterCompletion	void	1. 컨트롤러 로직 실행 된 후 호출 됨
							2. 컨트롤러 실행 도중이나 view 페이지 실행 도중 error 발생 해도 
								실행됨
							3. 공통 Exception 처리 로직 작성시 많이 쓰임
 */
@Service
public class ResponseIntercepter extends HandlerInterceptorAdapter {
	
	@Resource(name="sessionContextFactory")
	ObjectFactory<SessionContext> sessionContextFactory;
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
//		Calendar c = Calendar.getInstance();
//		c.set(2014, 2, 5, 0, 0, 0);
//		c.set(Calendar.MILLISECOND, 0);
//		System.out.println(c.getTimeInMillis()/1000);
		// 2014-3-5 0:0:0 => 1393945200
		
		//System.out.println("pre Free : "+Common.comma(Runtime.getRuntime().freeMemory())+", Total : "+Common.comma(Runtime.getRuntime().totalMemory())+", Time : "+(Calendar.getInstance().getTimeInMillis()/1000-1393945200));
		
		//System.out.println("pre Use  : "+Common.comma(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()));
		//System.out.println(Thread.currentThread().getName());
		
		response.setHeader("Cache-Control","no-cache");
		response.setHeader("Pragma","no-cache"); 
		response.setDateHeader("Expires",0);
		response.setCharacterEncoding("UTF-8");
		response.setHeader("P3P","CP='CAO PSA CONi OTR OUR DEM ONL'");
		
		// 상수
		request.setAttribute("con", Config.getConfig().getConfigMap());
		request.setAttribute("codes", Codes.getCodes().getCodesMap());
		
		String appType = Common.isNull(request.getParameter("appType"));
		
		// 단말 기종 판단
		String agent = request.getHeader("User-Agent");
		
		if(appType.length() > 0){
			request.getSession().setAttribute("appType", appType);
		} else if(agent.equals("AndroidWebView")){
			request.getSession().setAttribute("appType", agent);
		} else if(agent.equals("IOSWebView")){
			request.getSession().setAttribute("appType", agent);
		} else{
			request.getSession().setAttribute("appType", "");
		}
		
		RequestOrganizer.getInstance().add(request.getServletPath(), (SessionContext) sessionContextFactory.getObject());
		
		if(FilenameUtils.getBaseName(request.getServletPath()).indexOf("ajax")==-1){
			
			//SessionContext sessionContext = (SessionContext) sessionContextFactory.getObject();
			
			// URL REQUEST 정보 남기기
			if (Config.DEBUG) {
				//LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_DEV, "pet_request_url", "|", "", "REQUEST");
			} else {
				//LogUtil.LogInfo(request, sessionContext, Config.LOG_PATH_REQUEST_URL, "pet_request_url", "|", "", "REQUEST");
			}
		}
		else{
			//System.out.println("Request is ajax");
		}
		
		return true;

	}
		
	@Override
	public void afterCompletion(
			HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		
		//System.out.println("aft Free : "+Common.comma(Runtime.getRuntime().freeMemory())+", Total : "+Common.comma(Runtime.getRuntime().totalMemory()));
		//System.out.println("--------------------------------------------");
		
		//System.out.println("aft Use  : "+Common.comma(Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()));
	}
}
