<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>아이디 찾기</title>	
	 	<jsp:include page="/include/client/INC_JSP_HEADER.jsp"/> 
		
		<script>
		
			function goFindId() {
				
				if (!$('#phone_number').val()) {
					alert("휴대폰 번호를 입력해주세요.");
					return;
				}
				
				if (chkPhoneNumber($('#phone_number').val()) == false) {
					alert("휴대폰 번호가 부적합합니다.");
					return;
				}
				
				document.getElementById("form").action = "findIDAccept.latte";
				document.getElementById("form").submit();
				
			}
		
		</script>
</head>

<body>
<div data-role="page" style="background:#f7f3f4;">

	<c:if test="${empty appType}" >
    <!-- header 시작-->
    <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
    	<h1>아이디 찾기</h1>
        <!--<h1 class="img"><img src="${con.IMGPATH}/common/h1_logo.png" alt="BeautyLatte" width="111" height="32"/>&nbsp;</h1>-->
        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
        <%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
    </div>
    <!-- ///// header 끝-->
    </c:if>
    
    <!-- content 시작-->
	<div data-role="content" id="contents">
    
    <form id="form" method="post">
        <div class="st01">
            <h3>휴대폰번호</h3>
            <p class="input_type01 mt05"><input type="text" id="phone_number" name="phone_number" value="${phone_number}" placeholder="00000000000"></p>
            <p class="btn_type01 mt30"><a onclick="goFindId();" data-role="button">확인</a></p>
        </div>
	</form>        
    </div>
    
    <!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/> 
    <!-- ///// footer 끝-->

</div>

<script>
setInputConstraint('phoneNumber','phone_number',12);
</script>
</body>
</html>