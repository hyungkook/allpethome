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
<title>마이페이지</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />

<script>
	/* 메뉴토글 : 시작 *************/
	$(document).ready(function() {
		menuToggle("menu_mypage");		 
	});
	/* 메뉴토글 : 끝남 *************/


		
	function getSelectLocationList() {
				
				var url="locationInfo.latte?type=init";
				
				$("#searchFrame").attr("src", url);
				$("#wrap").hide();
				$("#searchDiv").show();
	}
			
	function closeSearchDiv(){
		
		$("#searchDiv").hide();
		$("#wrap").show();
	}
		
	function iframe_autoresize() {

		$('#searchDiv').height(document.getElementById("searchFrame").contentWindow.document.body.scrollHeight);
	    
	}

	/* 주소변경 Ajax */
	function ajaxLocationUpdate() {
	
		
		if (!$('#s_do').val()) {
			alert("지역을 선택해주세요");
			return;
		}
		
		jQuery.ajax({
			type:"POST",
			url:"ajaxLocationUpdate.latte",
			data:{
				s_location : $('#s_do').val() + " " + $('#s_sigu').val() + " " + $('#s_dong').val(),
				s_do : $('#s_do').val(),
				s_sigu : $('#s_sigu').val(),
				s_dong : $('#s_dong').val()
			},
			
			success:function(msg){

				if (msg == "4444") {
					alert("로그인이 필요한 기능입니다.");
					return;
				}
				
				if (msg == "0000") {
					alert("변경 되었습니다.");
					return;
				}
				
				if (msg == "9999") {
					alert("DB 업데이트 오류 (오류코드:9999)");
					return;
				}
				
			}, error: function(xhr,status,error){
				// alert(error);
			}
		});
		
	}
	
	function logout() {
		if (!confirm("정말 로그아웃 하시겠습니까?")) {
			return;
		}
		goPage('logout.latte');
	}
	
	
</script>

</head>

<body>



	<div id="searchDiv" style="display : none; margin: 0; padding: 0;height:100%;">
		<iframe id="searchFrame" name="searchFrame" onload="iframe_autoresize();"  style="position: relative; width: 100%; height:100%; margin: 0; padding: 0; border: 0; overflow-y: auto;" ></iframe>
	</div>
	
	<div data-role="page" id="wrap" style="background: #f7f3f4;">
		
		<c:if test="${empty appType}" >
		<!-- header 시작-->
	    <div data-role="header" id="head" data-position="fixed" data-tap-toggle="false" data-theme="a">
	    	<h1>마이페이지</h1>
	        <a href="index.html" data-role="botton" data-rel="back"><img src="${con.IMGPATH}/btn/btn_back.png" alt="back" width="32" height="32"/>&nbsp;</a>
	        <a href="#" data-role="botton" data-rel="menu" id="RightMenu"><img src="${con.IMGPATH}/btn/btn_menu.png" alt="shop" width="32" height="32"/>&nbsp;</a>
	        <%-- <a href="index.html" data-role="botton" class="shop"><img src="${con.IMGPATH}/btn/btn_shop.png" alt="shop" width="32" height="32"/>&nbsp;</a> --%>
	    </div>
	    </c:if>


        <!-- 휴대폰 인증팝업 시작-->
        <form id="auth_form" method="post">
        <input type="text" id="auth_cphone_number" name="s_cphone_number"/>
		<div class="pop_area" id="pop_area">
		    <div class="spop">
		    
		    	<div class="pop_header">
		            인증번호 입력
		            <p class="btn_close"><a onclick="closePop();" data-role="button"><img src="${con.IMGPATH}/btn/btn_close04.png" alt="" width="15" height="15"/></a></p>
		        </div>
		        
		        <div class="pop_contents">
		            <table class="mt05">
		            	<colgroup><col width="70%" /><col width="30%" /></colgroup>
		            	<tr>
		                	<td style="padding-right:4px;"><p class="input_type01"><input type="text" id="s_confirmNum" name="s_confirmNum" ></p></td>
		                    <td><p class="btn_type01"><a onclick="getConfirmHpNum();" data-role="button">인증번호 발송</a></p></td>
		                </tr>
		                <tr>
		                    <td colspan="2"><p class="txt_type03 mt15" id="confirmTime">05:00 남음</p></td>
		                </tr>
		            </table>
		            <p class="txt_type02 mt20">SMS 문자서비스를 통해 받으신 인증번호를 입력 해 주세요.</p>
		            <p class="btn_type02 mt05"><a onclick="goPhoneNumberChange();" data-role="button">인증번호 확인</a></p>
		        </div>
		        
		    </div>
		</div>
		</form>
		<!-- 휴대폰 인증팝업 시작-->

	
    <!-- content 시작-->
	<div data-role="content" id="contents">
        
        <form id="form" method="post">
		   	<input type="hidden" name="s_do" id="s_do"/>
		   	<input type="hidden" name="s_sigu" id="s_sigu"/>
		   	<input type="hidden" name="s_dong" id="s_dong"/>

        <!-- mypage 시작-->
        <div class="mypage_index">
        
        	<!-- mypage info 시작-->
        	<div class="info">
            	<dl>
                	<dt>${sessionContext.userMap.s_name} (${sessionContext.userMap.s_nickname})</dt>
                    <dd>${sessionContext.userMap.s_user_id}</dd>
                    <dd class="mt10" id="phone">${sessionContext.userMap.s_cphone_number}</dd>
                    <dd>
                    	<c:if test="${sessionContext.userMap.s_gender eq 'M'}">남자</c:if><c:if test="${sessionContext.userMap.s_gender eq 'F'}">여자</c:if>&nbsp;${sessionContext.userMap.s_age}세,&nbsp;
                    	${sessionContext.userMap.s_location}
                    </dd>
                </dl>
            </div>
            <!-- //mypage info 끝-->
            
            <!-- 전화번호 포맷 변환 -->
            <!-- <script>$('#phone').empty().html(formatPhoneNumber("${sessionContext.userMap.s_cphone_number}", "-"));</script> -->
            
            <div class="line_a15">
            
            	<div class="stage_area02">
                	<dl style="margin-top:0;">
                    	<dt>생년월일</dt>
                        <dd>${fn:substring(sessionContext.userMap.d_birthday, 0, 4)}년 ${fn:substring(sessionContext.userMap.d_birthday, 5, 7)}월 ${fn:substring(sessionContext.userMap.d_birthday, 8, 10)}일, 만 ${sessionContext.userMap.s_age}세</dd>
                    </dl>
                    <dl>
                    	<dt>성별</dt>
                        <dd><c:if test="${sessionContext.userMap.s_gender eq 'M'}">남자</c:if><c:if test="${sessionContext.userMap.s_gender eq 'F'}">여자</c:if></dd>
                    </dl>
                    <dl>
                    	<dt style="top:11px;">휴대폰</dt>
                        <dd class="area_r">
                            <div class="input_type01"><input type="text" id="s_cphone_number" name="s_cphone_number" value="${sessionContext.userMap.s_cphone_number}"/></div>
                            <div class="btn">
                                <p class="btn_type03"><a onclick="openPop();" data-role="button" style="height:40px; line-height:40px;">저장</a></p>
                            </div>
                        </dd>
                    </dl>
                    <dl>
                    	<dt style="top:11px;">주소</dt>
                        <dd class="area_r">
                            <div class="btn_type03"><a onclick="getSelectLocationList();" data-role="button" style="height:40px; line-height:40px;"><span id="locationView">${sessionContext.userMap.s_location}</span></a></div>
                            <div class="btn">
                                <p class="btn_type03"><a onclick="ajaxLocationUpdate();" data-role="button" style="height:40px; line-height:40px;">저장</a></p>
                            </div>
                        </dd>
                    </dl>
                </div>
            </div>
            
            <!-- 전화번호 포맷 변환 -->
            <!-- <script>$('#s_cphone_number').val(formatPhoneNumber("${sessionContext.userMap.s_cphone_number}", "-"));</script> -->            
            
        </div>
        </form> 
        <!-- //mypage 끝-->
        
        <form id="pw_form" method="post">
        
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
        
        </form>
        
	</div>
    <!-- ///// content 끝-->

		<!-- footer 시작-->
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp" />
		<!-- ///// footer 끝-->

	</div>
	 
	<script>
	
	setInputConstraint('phoneNumber','s_cphone_number',12);

		$(document).ready(function(){ 
			$('#pop_area').hide();			
		});
		
		function openPop() {
			
			var hpnum = $('#s_cphone_number').val();

			if (formatPhoneNumber(hpnum, "-") == formatPhoneNumber("${sessionContext.userMap.s_cphone_number}", "-")) {
				alert("기존 번호와 동일합니다.");
				return;
			}
			
			if(hpnum == ""){
				alert("휴대폰 번호를 입력해 주세요");
				return;
			} 
			 
			if(chkPhoneNumber(hpnum) == false){
				alert("잘못된 휴대전화 번호입니다.");
				return;
			}
			
			$('#contents').hide();
			$('#pop_area').show();	
			
			var cont = $('.spop').css('height');
			var contHeight = parseInt(cont.substring(0,cont.length -2)*0.5 );
			$('.spop').css('margin-top',-contHeight);
			
		}
		
		
		function closePop() {
			$('#contents').show();
			$('#pop_area').hide();	
		}
		

		// 휴대폰인증 스크립트
		var sec = 00;  // set the seconds 
		var min = 00;  // set the minutes
		var confirmChk = 0;
		var confirmCount = 1;
		
		function getConfirmHpNum(){
			
			if(confirmCount >3){
				alert("인증번호 발송횟수는 3회로 제한됩니다.");
				location.href="myPagePesonalInfo.latte";
				return;
			}
			
			confirmChk = 0;
			
			var hpnum = $('#s_cphone_number').val();

			
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
						goPage("home");
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
	
	function goPhoneNumberChange(){
		
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
		
		$('#auth_cphone_number').val($('#s_cphone_number').val());
		
		document.getElementById("auth_form").action = "myPagePhoneChangeUpdate.latte";
		document.getElementById("auth_form").submit();
		
	}
</script>
 </body>
</html>