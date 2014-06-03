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
			function goMail() {
				
				
				jQuery.ajax({
					type:"POST",
					url:"ajaxEmailCheck.latte",
					async:false,
					data:({
							mail : $('#s_user_id').val()
						}),
					
					success:function(msg) {
						
						
						if(msg == "0000") {
							$('#idChk').val('Y');
						}
						
						if(msg == "1000") {
							$('#idChk').val('N');
						}
						
					}, error: function(xhr,status,error){
						alert(error);
					}
				});
			}
		
			function goStep2() {
				
				var id = $.trim($('#s_user_id').val());
				var pw = $.trim($('#s_password').val());
				var pw_re = $.trim($('#s_password_re').val());
				
				if (!id) {
					alert("이메일 계정을 입력해주세요.");
					return;
				}
				
				goMail();
				
				if ($('#idChk').val() == 'N') {
					alert('이미 가입된 메일이 존재합니다.');
					return;
				}
				
				if (!chkEmail(id)) {
					alert("이메일 형식을 다시 확인하세요.");
					return;
				}
				
				if ($("#s_password").val().length < 4) {
					alert("비밀번호는 4자리 이상으로 설정해주세요.");
					return;
				}
				
				if (pw != pw_re) {
					alert("비밀번호를 확인해주세요.");
					return;
				}
				
				$("#form").attr("action","joinStep.latte?step=2");
			    document.getElementById("form").submit();

				
			}
		</script>
</head>

<body>
<div data-role="page" style="background:#f7f3f4;">
	
	<c:if test="${empty appType}" >
    <!-- header 시작-->
    <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
    	<h1>회원가입</h1>
        <!--<h1 class="img"><img src="/images/common/h1_logo.png" alt="BeautyLatte" width="111" height="32"/>&nbsp;</h1>-->
        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
        <%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
    </div>
    <!-- ///// header 끝-->
    </c:if>
    
    <!-- content 시작-->
	<div data-role="content" id="contents">
		<form id="form" name="form" method="post">
		<input type="hidden" id="idChk" name="idChk" value="N" />
	        <div><img src="${con.IMGPATH}/common/step01.png" width="100%"/></div>
	        
	        <div class="st01">
	            <h3>이메일계정</h3>
	            <p class="input_type01 mt05"><input type="text" id="s_user_id" name="s_user_id" placeholder="이메일 입력"></p>
	            <p class="txt_type02 mt10">이메일 정보는 비밀번호 분실시와 이벤트 당첨자 확인 등에 이용되는 정보입니다. 주로 쓰시는 이메일 계정을 입력하시면 이용에 편리합니다.</p>
	            
	            <h3>비밀번호</h3>
	            <p class="input_type01 mt05"><input type="password" id="s_password" name="s_password" placeholder="비밀번호 입력"></p>
	            <p class="txt_type02 mt10">비밀번호는 4자리 이상의 영문 또는 숫자로 구성하여 주시기 바라니다.</p>
	            
	            <h3 style="margin-top:15px;">비밀번호 재확인</h3>
	            <p class="input_type01 mt05"><input type="password" id="s_password_re" name="s_password_re" placeholder="비밀번호 확인"></p>
	            <p class="btn_type02 mt30"><span onclick="goStep2();" data-role="button">다음</span></p>
	        </div>
        	<div style="font-size:12px; padding-top:100px; height:50px;">&nbsp;</div>
		</form>
    </div>
    <!-- ///// content 끝-->
    
    <!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/> 
    <!-- ///// footer 끝-->

</div>
</body>
</html>