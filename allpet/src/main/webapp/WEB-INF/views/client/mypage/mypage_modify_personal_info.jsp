<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ page import = "java.util.Calendar" %>

<jsp:scriptlet>
 
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
 
</jsp:scriptlet>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>개인정보수정</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<%-- 해쉬변화 감지 라이브러리 --%>
<%-- <script src="${con.JSPATH}/jquery.ba-hashchange.js"></script> --%>

<script>
			
	function closeSearchDiv(){
		
		$("#searchDiv").hide();
		$("#contents").show();
	}

	/* 주소변경 Ajax */
	function ajaxLocationUpdate() {
	
		if(!$('#s_do').val()) {
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
	
	<%-- location.hash를 이용한 뒤로가기 구현 --%>
	var sido = '';
	var sigungu = '';
	var dong = '';
	
	function selectArea(){
		
		per_hash = location.hash;
		
		if(location.hash==''||location.hash=='#'){
			location.hash='#area_sido';
		}
		else if(location.hash=='#area_sido'){
			location.hash='#area_sigungu';
		}
		else if(location.hash=='#area_sigungu'){
			location.hash='#area_dong';
		}
		else if(location.hash=='#area_dong'){
			history.go(-3);
		}
	}
	
	function cancelSelectArea(){
		
		per_hash='';
		
		if(location.hash==''){
		}
		else if(location.hash=='#area_sido'){
			history.go(-1);
		}
		else if(location.hash=='#area_sigungu'){
			history.go(-2);
		}
		else if(location.hash=='#area_dong'){
			history.go(-3);
		}
	}
	
	var per_hash = '';

	<%-- 해쉬값이 바뀌는지 지속적으로 체크 --%>
//	setInterval(function(){//타이머방식
//	$(window).hashchange(function(){//라이브러리
	$(window).on('hashchange',function(){
		
		if((location.hash==''||location.hash=='#')){
			
			$('#pop_area').hide();
			
			if($('#searchDiv').is(':visible')){
				$('#searchDiv').hide();
				$('#contents').show();
				if(sido!=''&&sigungu!=''&&dong!=''){
					$('#locationView').html(sido+" "+sigungu+" "+dong);
					$('#s_do').val(sido);
					$('#s_sigu').val(sigungu);
					$('#s_dong').val(dong);
				}
				sido='';sigungu='';dong='';
			}
		}
		//if(per_hash!=location.hash){
			var options = {
					url:'ajaxLocationInfo.latte',
					type:'POST',
					success:function(response,status,xhr){
						$('#area_list').empty();
						$('#area_list').append(response);
						$('#searchDiv').show();
						$('#contents').hide();
					},
					error:function(xhr,status,error){
						alert(status+"\n"+error);
					}
			};
			
			per_hash = location.hash;
			//console.log(per_hash);
			if(location.hash=='#area_sido'){
				$.ajax($.extend(options,{data:{
					search_type:'sido'
				}}));
			}
			else if(location.hash=='#area_sigungu'){
				$.ajax($.extend(options,{data:{
					search_type:'sigungu',
					sido:sido
				}}));
			}
			else if(location.hash=='#area_dong'){
				$.ajax($.extend(options,{data:{
					search_type:'dong',
					sido:sido,
					sigungu:sigungu
				}}));
			}
		//}
	});//,100);
	
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
		
		$("#pw_form").attr("action","myPagePasswordChangeUpdate.latte");
	    document.getElementById("pw_form").submit();

		
	}
	
</script>

</head>

<body>
   	
   	<div id="tag_marker" style="display:none;">
	   	<a id="area_sido"></a>
	   	<a id="area_sigungu"></a>
	   	<a id="area_dong"></a>
   	</div>
	
	<div data-role="page">
	
		<div id="searchDiv" style="display : none; margin: 0; padding: 0;height:100%;">
			<div class="area_list" id="area_list"></div>
		</div>
	
		<form id="auth_form" method="post">
		<input type="hidden" id="auth_cphone_number" name="s_cphone_number"/>
		
		<div class="simple_popup01" id="pop_area">
			<div class="bg"></div>
			<div class="c_area_l1">
				<span class="aliner"></span>
				<div class="c_area_l2">
					<div class="title_bar">
						<p class="title_name">인증번호 입력</p>
						<a class="title_close" data-role="button" onclick="closePop();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="32px"/></a>
					</div>
					<div class="center">
						<p class="popup_inner_msg01">SMS 문자서비스를 통해 받으신 인증번호를 입력해 주세요.</p>
						<div class="btn_area02">
							<div class="l_60 input02">
								<p class="inner_input"><input type="text" id="s_confirmNum" name="s_confirmNum" placeholder="인증번호를 입력해주세요."></p>
							</div>
							<p class="r_40 btn_bar_gray btn_bar_shape02">
								<a data-role="button" onclick="getConfirmHpNum();"><span>발송 요청</span></a>
							</p>
						</div>
						<p class="remain_time01">
							<img src="${con.IMGPATH}/common/icon_time.png" height="20px"/>
							<span class="time" id="confirmTime">05:00분</span>
							<span>&nbsp;남음</span>
						</p>
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button" onclick="goPhoneNumberChange();"><img src="${con.IMGPATH}/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>인증번호 확인</span></a>
						</p>
					</div>
				</div>
			</div>
		</div>
		</form>
		
	
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<form id="form" method="post">
			<input type="hidden" name="s_do" id="s_do"/>
			<input type="hidden" name="s_sigu" id="s_sigu"/>
			<input type="hidden" name="s_dong" id="s_dong"/>
			
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="100%" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				개인정보수정
			</div>
			
			<%-- 생일 --%>
			<c:set var="birth_y">${fn:substring(sessionContext.userMap.d_birthday, 0, 4)}</c:set>
			<c:set var="birth_m">${fn:substring(sessionContext.userMap.d_birthday, 5, 7)}</c:set>
			<c:set var="birth_d">${fn:substring(sessionContext.userMap.d_birthday, 8, 10)}</c:set>
			<c:set var="c_age">${sessionContext.userMap.s_age}</c:set>
			
			<%-- 오늘 --%>
			<% Calendar c = Calendar.getInstance(); %>
			<c:set var="cur_y"><%= c.get(Calendar.YEAR) %></c:set>
			<c:set var="cur_m"><%= c.get(Calendar.MONTH)+1 %></c:set>
			<c:set var="cur_d"><%= c.get(Calendar.DAY_OF_MONTH) %></c:set>
			
			<%-- 만 나이 --%>
			<c:if test="${birth_m lt cur_m}">
			<c:set var="c_age">${c_age-1}</c:set>
			</c:if>
			
			<div class="a_type02">
				<div class="name_area_personal_edit">
					<p class="name">${sessionContext.userMap.s_name} <%--(${sessionContext.userMap.s_nickname}) --%></p>
					<p class="email mt05">${sessionContext.userMap.s_user_id}</p>
				</div>
				<table class="edit_table01 mt20">
					<colgroup>
						<col width="23%">
						<col width="*">
					</colgroup>
					<%--
					<tr>
						<th>생년월일</th>
						<td>${birth_y}년 ${birth_m}월 ${birth_d}일. 만 ${c_age}세</td>
					</tr>
					<tr>
						<th>성별</th>
						<td><c:if test="${sessionContext.userMap.s_gender eq 'M'}">남</c:if><c:if test="${sessionContext.userMap.s_gender eq 'F'}">여</c:if></td>
					</tr>
					 --%>
					<tr>
						<th>휴대폰</th>
						<td class="btn_area01">
							<div class="rate75">
								<div class="input01">
									<p class="inner_input"><input type="text" id="s_cphone_number" name="s_cphone_number" placeholder="휴대폰번호" value="${sessionContext.userMap.s_cphone_number}"></p>
								</div>
							</div>
							<p class="rate25 btn_bar_black btn_bar_shape02">
								<a data-role="button" onclick="ajaxPhoneUpdate();"><span>변경</span></a>
							</p>
						</td>
					</tr>
					<tr>
						<th>주소</th>
						<td class="btn_area01">
							<div class="rate75">
								<p class="readonly_input01" id="locationView" onclick="selectArea();">
									${sessionContext.userMap.s_location}
								</p>
							</div>
							<p class="rate25 btn_bar_red btn_bar_shape02">
								<a data-role="button" onclick="ajaxLocationUpdate();"><span>변경</span></a>
							</p>
						</td>
					</tr>
				</table>
			</div>
			</form>
			
			<form id="pw_form" method="post">
			<div class="a_type02">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />비밀번호 변경</h3>
				<table class="edit_table01 mt20">
					<colgroup>
						<col width="35%">
						<col width="*">
					</colgroup>
					<tr>
						<th>기존 비밀번호</th>
						<td>
							<div class="input01">
								<p class="inner_input"><input type="password" id="old_pw" name="old_pw"></p>
							</div>
						</td>
					</tr>
					<tr>
						<th>새 비밀번호</th>
						<td>
							<div class="input01">
								<p class="inner_input"><input type="password" id="new_pw" name="new_pw"></p>
							</div>
						</td>
					</tr>
					<tr>
						<th>새 비밀번호 재입력</th>
						<td>
							<div class="input01">
								<p class="inner_input"><input type="password" id="new_re_pw" name="new_re_pw"></p>
							</div>
						</td>
					</tr>
				</table>
				
				<p class="btn_bar_red btn_bar_shape01 mt15">
					<a data-role="button" onclick="goSubmit();"><span>비밀번호 변경</span></a>
				</p>
			</div>
			</form>
			
			<div class="a_type02">
				<p class="btn_bar_black btn_bar_shape01 mt08">
					<a data-role="button" onclick="goPage('myPageDropMember.latte');"><span>탈퇴신청</span></a>
				</p>
			</div>
		</div>
		<!-- ///// content 끝-->

		<jsp:include page="../include/mypage_footer.jsp"/>

	</div>
	<script>
	
	setInputConstraint('phoneNumber','s_cphone_number',12);

		$(document).ready(function(){ 
			$('#pop_area').hide();			
		});
		
		/* 주소변경 Ajax */
		function ajaxPhoneUpdate() {
			
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
			
			jQuery.ajax({
				type:"POST",
				url:"myPagePhoneChangeUpdate2.latte",
				data:{
					s_cphone_number : hpnum
				},
				
				success:function(msg){
					if (msg == "0000") {
						alert("휴대폰 번호가 변경되었습니다.");
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
			
			location.hash = "phone";
			//$('#contents').hide();
			$('#pop_area').show();	
			
			var cont = $('.spop').css('height');
			var contHeight = parseInt(cont.substring(0,cont.length -2)*0.5 );
			$('.spop').css('margin-top',-contHeight);
			
		}
		
		
		function closePop() {
			//$('#contents').show();
			$('#pop_area').hide();
			history.back();
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