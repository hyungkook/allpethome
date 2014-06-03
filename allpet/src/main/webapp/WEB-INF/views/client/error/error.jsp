
<%@page import="java.net.URLEncoder"%>
<%@page import="com.sun.org.apache.xerces.internal.impl.dv.util.Base64"%>
<%@page import="org.springframework.web.util.UrlPathHelper"%>

<%@page import="java.util.Enumeration"%>
<%
response.setStatus(200);
%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densitydpi=medium-dpi">
    <meta name="apple-mobile-web-app-capable" content="yes">
	<title>동물병원</title>
	<link rel="stylesheet" href="http://m.medilatte.com/client/css/style.css" type="text/css"/>
    <script>
	window.addEventListener('load', function(){
    setTimeout(scrollTo, 0, 0, 1);
	}, false);
	</script>
</head>

<body>
<div id="wrap" class="bg_wrap01" >
	
    <!-- contents start-->
    <div id="contents">
    	<div class="error_ttl"><!-- <img src="http://img.medilatte.com/client/images/common/error_logo.png" width="118" height="29"/> --> 페이지를 찾을수 없습니다.</div>
        <div class="txt_type01" style="margin:30px 15px 0 15px; text-align:center;">에러가 발생한 페이지는 자동으로 관리자에게 통보되며,<br />이를 통해 신속히 복구할 수 있도록 조치하겠습니다.<br />서비스 이용에 불편을 드려 대단히 죄송합니다.</div>
        <div class="stage_area02 mt25">
        	<!-- <p style="width:50%; float:left;"><a href="http://m.medilatte.com/client/index.latte" class="btn_type0603" style="display:block; width:98%;">메인 페이지로 이동</a></p> -->
            <p style="width:100%; float:right;"><a href="#" class="btn_type0603" style="display:block; width:98%;" onclick="javascript:history.go(-1);">이전 페이지로 이동</a></p>
        </div>
        <!-- 버튼 하나일 경우
        <div class="stage_area02 mt20" >
        	<p style="width:50%; margin:0 auto;"><a href="#" class="btn_type0603" style="display:block; width:98%;">이전 페이지로 이동</a></p>
        </div>
        -->
        <div style="height:70px"></div><!-- gnb 영역만큼 띠우기-->
    </div>
    <!-- / contents end-->
    <%-- ${requestScope['javax.servlet.error.message']} --%>
    <br/><br/>
    <%--
     try{
	    
		String agent = request.getHeader("User-Agent");
		
	    StringBuffer sb = new StringBuffer();
		String ipAddress  = request.getHeader("X-FORWARDED-FOR");   
        if(ipAddress == null)   
        {   
          ipAddress = request.getRemoteAddr();   
        }
        /* 아이피 기록 */
		sb.append(ipAddress).append("|");
        String todatetime = StrUtil.today();
        /* 날자 기록 */
        sb.append(todatetime).append("|");
       
        /* 단말정보 기록 */
        if(agent.indexOf("AndroidWebView") >= 0){
        	sb.append("AndroidWebView").append("|");	
        	
        }else if(agent.indexOf("iPhone") >= 0){
        	sb.append("iPhone").append("|");
        	
        }else if(agent.indexOf("Android") >= 0){
        	sb.append("Android").append("|");
        	
        }else if(agent.indexOf("IOSWebView") >= 0){
        	sb.append("IOSWebView").append("|");
        	
        }else{
        	sb.append("PC").append("|");
        }
	    
        /* 호출 URL 기록 */
        String path = StrUtil.getString(new UrlPathHelper().getOriginatingServletPath(request));
        sb.append(path).append("|");
	    
        /* 파라미터 기록*/
		Enumeration paramname = request.getParameterNames();

        StringBuffer paramSB = new StringBuffer();
	    while(paramname.hasMoreElements()){
	    	String p_name = (String)paramname.nextElement();
	    	//out.println(p_name +"=" + request.getParameter(p_name) +"<br/>");
	    	paramSB.append(p_name +"=" + request.getParameter(p_name));
	    }
	  	//TestEncoding.testEncoding(sb.toString());
	    String queryString = Base64.encode(URLEncoder.encode(paramSB.toString(), "8859_1").getBytes());
        paramSB.delete(0, paramSB.length());
        paramSB = null;
	    
        sb.append(queryString).append("|");
        
        /* 에러코드 기록 */
        String statusCode = StrUtil.getString(request.getAttribute("javax.servlet.error.status_code"));
        
        sb.append(statusCode);
        
        
        
        
        
        String logName = Log.getFileNameToday("medi_error_", "", "");
	    
	    if(AppStatus.DEBUG_MODE){
	    	Log.write(AppStatus.LOG_REPOSITORY_DEV + AppStatus.LOG_REPOSITORY_ERROR, logName, sb.toString() );
	     	//Log.write(AppStatus.LOG_REPOSITORY_DEV, logName, (Exception)request.getAttribute("javax.servlet.error.exception"));
	    }else{
	    	Log.write(AppStatus.LOG_REPOSITORY + AppStatus.LOG_REPOSITORY_ERROR, logName, sb.toString() );
	     	//Log.write(AppStatus.LOG_REPOSITORY, logName, (Exception)request.getAttribute("javax.servlet.error.exception"));
	    }
	    
	    sb.delete(0, sb.length());
	    sb = null;
     }catch(Exception e){}
    --%>
        
</div>
</body>
</html>