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
		var sec = 00;  // set the seconds 
		var min = 00;  // set the minutes
		var confirmChk = 0;
		var confirmCount = 1;
	
		function getConfirmHpNum(){
			if(confirmCount >3){
				alert("인증번호 발송횟수는 3회로 제한됩니다.");
				location.href="joinStep.latte?step=1";
				return;
			}
			confirmChk = 0;
			
			var hpnum = document.getElementById("s_cphone_number").value;

			if(hpnum == ""){
				alert("휴대폰 번호를 입력해 주세요");
				return;
			} 
			 
			if(chkPhoneNumber(hpnum) == false){
				alert("잘못된 휴대전화 번호입니다. \n 예) 010XXXXXXXX");
				return;
			}
		 
		 	
			jQuery.ajax({
				type:"POST",
				url:"ajaxHpAuthNumberSend.latte",
				data:({hpnum : hpnum}),
				success:function(msg){

					if(msg == "0000") {
						min = 05;	//시간 초기화 변수
						countDownClear();
						countDown();
						confirmChk = 1;
						confirmCount = confirmCount + 1;
						alert("인증번호 발송하였습니다.");
					}
					
					if(msg == "9999") {
						alert("세션이 만료 되었습니다. 다시 진행해주세요.");
						goPage("joinTerms.latte");
						return;
					}
					
					if(msg == "2000") {
						alert("이미 가입되어 있는 핸드폰 번호 입니다.");
						return;
					}
					
					if(msg == "9998") {
						alert("에러코드 - 9998");
						return;
					}
					
					if(msg == "9997") {
						alert("번호를 입력하지 않으셨거나, 시스템에 문제가 발생하였습니다.");
						return;
					}
					
					if(msg == "9999") {
						alert("번호를 입력하지 않으셨거나, 시스템에 문제가 발생하였습니다.");
						return;
					}
					
				}, error: function(xhr,status,error){
					alert(error);
				}
			}); 
	}
	
	function countDownClear(){
		if(SD != null){
			window.clearTimeout(SD);
			sec = 00;  // set the seconds 
			min = 05;  // set the minutes
			
		}
	}
	
	var SD;

	function countDown() {
		sec--;
		if (sec == -01) {
			sec = 59;
			min = min - 1;
		} else {
			min = min;
		}
		if (sec <= 9) {
			sec = "0" + sec;
		}
		time = (min <= 9 ? "0" + min : min) + ":" + sec + " 남음";
		if (document.getElementById) {
			confirmTime.innerHTML = time;
		}
		SD = window.setTimeout("countDown();", 1000);
		if (min == '00' && sec == '00') {
			sec = "00";
			window.clearTimeout(SD);
			confirmChk = 2;
			alert("인증시간이 지났습니다\n인증번호를 다시 전송해 주세요");
			confirmTime.innerHTML = "05:00 남음";
		}
	}
	
	function goStep3(){
		if(confirmChk == 0){
			alert("휴대폰 인증을 받아주시기 바랍니다");
			return;
		}
		if(document.getElementById("s_cphone_number").value == ""){
			alert("휴대폰 번호를 입력해 주시기 바랍니다");
			return;
		}
		if(document.getElementById("s_confirmNum").value == ""){
			alert("인증 번호를 입력해 주시기 바랍니다");
			return;
		}
		
		document.getElementById("form").action = "joinStep.latte?step=3";
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
    <form id="form" id="form" name="form" method="post">
	<div data-role="content" id="contents">
    	
        <div><img src="${con.IMGPATH}/common/step02.png" width="100%"/></div>
        
        <div class="st01">
            <p class="txt_type02 mt30">본인 인증과 쿠폰 사용 시 필요한 정보이며, 입력된 휴대폰 번호로 인증번호가 발송됩니다.</p>
            
            <h3>휴대폰 번호</h3>
            <table class="mt05">
            	<colgroup><col width="70%" /><col width="30%" /></colgroup>
            	<tr>
                	<td style="padding-right:4px;"><p class="input_type01"><input type="text" id="s_cphone_number" name="s_cphone_number" value="${s_cphone_number}" placeholder="00000000000"></p></td>
                    <td><p class="btn_type01"><a onclick="getConfirmHpNum();" data-role="button">인증번호발송</a></p></td>
                </tr>
            </table>
            
            <h3>인증번호 입력</h3>
            <table class="mt05">
            	<colgroup><col width="70%" /><col width="30%" /></colgroup>
            	<tr>
                	<td style="padding-right:4px;"><p class="input_type01"><input type="text" id="s_confirmNum" name="s_confirmNum" placeholder="00000000000"></p></td>
                    <td><p class="txt_type03" id="confirmTime">05:00 남음</p></td>
                </tr>
            </table>
            
            <p class="btn_type02 mt30"><a onclick="goStep3();" data-role="button">다음</a></p>
        </div>
        <div style="font-size:12px; padding-top:100px; height:50px;">&nbsp;</div>
        
    </div>
    </form>
    <!-- ///// content 끝-->
    
    <!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/> 
    <!-- ///// footer 끝-->
   </div>

</body>
</html>