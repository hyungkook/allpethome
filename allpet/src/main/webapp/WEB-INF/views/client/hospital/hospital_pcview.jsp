<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>
	img { margin:0; padding:0; font-size:0; line-height:0;}
	
	html { width:100%; height:100%;}
	body { width:100%; height:100%; margin:0; padding:0; font-size:0; line-height:0; background:#dfdfdc;}
	#wrap { width:692px; height:100%; margin:0 auto 0 auto; position:relative; background:#dfdfdc url(common/template/images/common/hm01.png) left top repeat-y;}
	#wrap .ht { width:100%; height:64px; margin:0; padding:39px 0 0 0; overflow:hidden; position:absolute; left:0; top:0; position:fixed; font-size:0; line-height:0; z-index:999; background:#dfdfdc; text-align:center;}
	#wrap .hb { width:100%; height:68px; margin:0; padding:0 0 67px 0; overflow:hidden; position:absolute; left:0; bottom:0; position:fixed; font-size:0; line-height:0; z-index:999; background:#dfdfdc; text-align:center;}
	#wrap .hm { width:620px; overflow-y:hidden; overflow-x:hidden; position:absolute; top:103px; bottom:135px; left:35px; z-index:99;}
	
	#wrap .bg_t { width:602px; height:7px; position:absolute; top:103px; left:35px; margin:0; padding:0; font-size:0; line-height:0; z-index:999;}
	#wrap .bg_l { width:7px; position:absolute; top:103px; bottom:135px; left:35px; margin:0; padding:0; font-size:0; line-height:0; z-index:999;}
	#wrap .bg_b { width:602px; height:7px; position:absolute; bottom:135px; left:35px; margin:0; padding:0; font-size:0; line-height:0; z-index:999;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title><c:choose><c:when test="${empty hospitalInfo.s_hospital_name}">동물병원</c:when><c:otherwise>${hospitalInfo.s_hospital_name}</c:otherwise></c:choose></title>
</head>
<body>
	<div id="wrap">
    	<!-- 껍데기 영역 -->
    	<p class="ht"><img src="common/template/images/common/ht01.png" alt="" width="692" height="64"></p>
        <p class="hb"><img src="common/template/images/common/hb01.png" alt="" width="692" height="64"></p>
          <!-- contents 영역 -->
        <div class="hm">
			<iframe src="${hospitalInfo.s_hospital_id}/hospitalHome.latte" style=" border-width:0; width:100%; height:100%;" frameborder="0" scrolling="yes" id="ifrm"></iframe>
		</div>
		
		<!-- bg 영역 -->
        <p class="bg_t"><img src="common/template/images/common/bg_top.png" alt="" width="100%" height="7"></p>
        <p class="bg_l"><img src="common/template/images/common/bg_left.png" alt="" width="7" height="100%"></p>
        <p class="bg_b"><img src="common/template/images/common/bg_bottom.png" alt="" width="100%" height="7"></p>
	</div>
	<div style="position:absolute; z-index: 9999; width: 30px; height: 30px; left: 0px; top:0px; cursor: pointer;" onclick="javascript:document.getElementById('ifrm').src = document.getElementById('ifrm').contentWindow.location;">&nbsp;</div>
</body>
</html>