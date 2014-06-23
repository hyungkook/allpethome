<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>회원가입</title>	
	 	<jsp:include page="/include/client/INC_JSP_HEADER.jsp"/> 
		
		<script>
		</script>
</head>

<body>
<div data-role="page" style="background:#f7f3f4;">
    
    <!-- content 시작-->
	<div data-role="content" id="contents">
        
        <div class="st01">
            <p class="txt_ttl01" style="text-align:left;">회원가입 신청서 작성이 모두 완료되었습니다.</p>
            
            <p class="btn_type0103 mt30"><a onclick="goPage('login.latte?rePage=myPageHome.latte');" data-role="button">가입완료</a></p>
        </div>
        <div style="font-size:12px; padding-top:100px; height:50px;">&nbsp;</div>
        
    </div>
    

</div>

 <script type="text/javascript">
 
	
  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-39177988-1']);
  _gaq.push(['_trackPageview']);
 

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();
 

</script>


</body>
</html>