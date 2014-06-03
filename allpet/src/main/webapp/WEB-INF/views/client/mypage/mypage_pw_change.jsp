<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
 
</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>비밀번호 변경</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />

<script>
	/* 메뉴토글 : 시작 *************/
	$(document).ready(function() {
		menuToggle("menu_mypage");		 
	});
	/* 메뉴토글 : 끝남 *************/
	
	function goSubmit() {
		
		if (!$('#old_pw').val()) {
			alert("기존 비밀번호를 입력하세요");
			return;
		}
		
		if ($("#new_pw").val().length < 4) {
			alert("비밀번호는 4자리 이상으로 설정해주세요");
			return;
		}
		
		if ($("#new_pw").val() != $("#new_re_pw").val()) {
			alert("비밀번호를 확인해주세요");
			return;
		}
		
		$("#form").attr("action","myPagePasswordChangeUpdate.latte");
	    document.getElementById("form").submit();

		
	}
	
</script>

</head>

<body>

	<form id="form" method="post">
	
	<div data-role="page" id="wrap" style="background: #f7f3f4;">
	
	<c:if test="${empty appType}" >
    <!-- header 시작-->
    <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
    	<h1>비밀번호 변경</h1>
        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
        <%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
    </div>
    <!-- ///// header 끝-->
    </c:if>
    
    <!-- content 시작-->
	<div data-role="content" id="contents">
        
        <div class="st01">
        	<p class="txt_type04 pt30">※ 4자 이상의 영문 대소문자, 숫자를 조합하여사용하실 수 있습니다.</p>
            <p class="txt_type04 pt10">※ 생년월일, 전화번호 등 개인정보와 관련된 숫자, 연속된 숫자와 같이 쉬운 비밀번호는 다른 사람이 쉽게 알아낼 수 있으니 사용을 자제해 주세요.</p>
            <div class="stage_area02 mt15">
                <dl>
                    <dt class="red">기존 비밀번호</dt>
                    <dd style="padding-left:124px;"><p class="input_type01"><input type="password" id="old_pw" name="old_pw"/></p></dd>
                </dl>
                <dl style="margin-top:5px;">
                    <dt class="red">새 비밀번호</dt>
                    <dd style="padding-left:124px;"><p class="input_type01"><input type="password" id="new_pw" name="new_pw"/></p></dd>
                </dl>
                <dl style="margin-top:5px;">
                    <dt class="red">새 비밀번호 재입력</dt>
                    <dd style="padding-left:124px;"><p class="input_type01"><input type="password" id="new_re_pw" name="new_re_pw"/></p></dd>
                </dl>
            </div>
            <p class="btn_type02 mt20"><a onclick="goSubmit();" data-role="button">비밀번호 변경</a></p>
        </div>
        <div style="font-size:12px; padding-top:150px; height:50px;">&nbsp;</div>
           
        
        
	</div>
    <!-- ///// content 끝-->

		<!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
</form>
 </body>
</html>