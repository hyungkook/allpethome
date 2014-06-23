<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>회원약관</title>	
	 	<jsp:include page="/include/client/INC_JSP_HEADER.jsp"/> 
		
		<script>
			function goTermMove() {
				
				if (!chkBox('tChk')) {
					alert("약관에 모두 동의 하여주시기 바랍니다.");
					return;
				}
				
				if ("${jSession.s_user_id}" == '') {
					goPage('joinStep.latte?step=1');				
				} else {
					goPage('joinStep.latte?step=2');
				}
				
				
				
			}
		</script>
</head>

<body>

<div data-role="page" style="background:#f7f3f4;">
	 
	<c:if test="${empty appType}" >
    <!-- header 시작-->
    <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
    	<h1>회원약관</h1>
        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
        <%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
    </div>
    <!-- ///// header 끝-->
    </c:if>
    
    <!-- content 시작-->
	<div data-role="content" id="contents">
    	
        <div class="st01">
            <p class="txt_ttl01" style="text-align:left;">안녕하세요. 가입을 진심으로 환영합니다.</p>
            <p class="txt_type0202 mt15">회원가입을 하려면 우선 여러분에게 어떤 권리와 책임이 따르는지 각 항목을 잘 읽어보시고 가입 절차를 진행해 주세요.</p>
            
            <p class="txt_type02 mt10">* 아래의 항목을 클릭하시면 자세한 내용을 확인하실 수 있습니다.</p>
            
            <table class="mt20 table_s">
            	<tr>
                	<td style="width:30px;"><label style="background:#f7f3f4; margin:0; width:30px; display:inline-block;"><input type="checkbox" id="tChk" name="tChk" checked="checked">&nbsp;</label></td>
                    <td valign="top"><a href="javascript:goPage('joinTermsDetail.latte?type=01');">서비스 이용약관 보기</a></td>
                </tr>
                <tr>
                	<td style="width:30px;"><label style="background:#f7f3f4; margin:0; width:30px; display:inline-block;"><input type="checkbox" id="tChk" name="tChk" checked="checked">&nbsp;</label></td>
                    <td valign="top"><a href="javascript:goPage('joinTermsDetail.latte?type=02');">개인정보 취급방침 보기</a></td>
                </tr>
                <tr>
                	<td style="width:30px;"><label style="background:#f7f3f4; margin:0; width:30px; display:inline-block;"><input type="checkbox" id="tChk" name="tChk" checked="checked">&nbsp;</label></td>
                    <td valign="top"><a href="javascript:goPage('joinTermsDetail.latte?type=03');">위치기반 서비스 이용약관 보기</a></td>
                </tr>
                <tr>
                	<td style="width:30px;"><label style="background:#f7f3f4; margin:0; width:30px; display:inline-block;"><input type="checkbox" id="tChk" name="tChk" checked="checked">&nbsp;</label></td>
                    <td valign="top"><a href="javascript:goPage('joinTermsDetail.latte?type=04');">개인정보 국외이전 동의 보기</a></td>
                </tr>
            </table>
            
            <p class="txt_type02 mt15">* 서비스 이용약관, 개인정보 취급방침, 위치기반 서비스 이용약관, 개인정보 국외이전에 동의하시면 아래에 '서비스 정책에 동의합니다'를 선택해 주세요.</p>
            <p class="txt_type02 mt05">* 서비스 동의를 하지 않은 회원님들은 본 서비스 이용에 제약이 있음을 알려드립니다.</p>
            
            <p class="btn_type01 mt30"><a href="javascript:goTermMove();" data-role="button">서비스 정책에 동의합니다.</a></p>
        </div>
        
        
        <div style="font-size:12px; padding-top:10px; height:50px;">&nbsp;</div>
        
    </div>
    <!-- ///// content 끝-->
    <!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/> 
    <!-- ///// footer 끝-->

</div>
</body>
</html>