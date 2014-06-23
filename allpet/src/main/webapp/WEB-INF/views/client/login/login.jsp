<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>로그인</title>

	<jsp:include page="/include/client/INC_JSP_HEADER.jsp"/> 
	
	<script>
		function goLogin(type) {
			
			document.getElementById("form").action="loginAccept.latte?type=" + type + "&rePage=" + encodeURIComponent("${rePage}");
			document.getElementById("form").submit();
		}
		
		$(window).load(function(){
			
			$('#password').on('keyup',function(){
				if(event.keyCode==13)
					goLogin('${type}');
			});
			
			$('#password').focus();
		});
		
		function openFindIdPopup(){
			
			location.hash = "id";
			$('#find_id_popup').show();
		}
		
		function closeFindIdPopup(){
			
			$('#find_id_popup').hide();
			history.back();
		}
		
		function findId() {
			
			if (!$('#phone_number').val()) {
				alert("휴대폰 번호를 입력해주세요.");
				return;
			}
			
			if (chkPhoneNumber($('#phone_number').val()) == false) {
				alert("휴대폰 번호가 부적합합니다.");
				return;
			}
			
			$.pjAjax({
				url:'ajaxFindIDAccept.latte',
				data:{phone_number:$('#phone_number').val()},
				success:function(response,status,xhr){
					if(response.result!='${codes.SUCCESS_CODE}'){
						alert("요청하신 휴대폰번호로 검색된 아이디가 없습니다.");
					}else{
						$('#user_id').val(response.id);
						closeFindIdPopup();
					};
				},
				error:function(xhr,status,error){
					alert("에러\n"+status+"\n"+error);
				}
			});
		}
		
		function openFindPwPopup(){
			
			$('#find_pw_popup').show();
			location.hash = "pw";
		}
		
		function closeFindPwPopup(){
			
			$('#find_pw_popup').hide();
			history.back();
		}
		
		function findPw() {
			
			if (!$('#id').val()) {
				alert("이메일을 입력해주세요.");
				return;
			}
			
			if (!$('#pw_phone_number').val()) {
				alert("휴대폰 번호를 입력해주세요.");
				return;
			}
			
			if (chkPhoneNumber($('#pw_phone_number').val()) == false) {
				alert("휴대폰 번호가 부적합합니다.");
				return;
			}
			
			document.getElementById("form").action = "findPWAccept.latte";
			$.pjAjax({
				url:'ajaxFindPWAccept.latte',
				data:{id:$('#id').val(),phone_number:$('#pw_phone_number').val()},
				success:function(response,status,xhr){
					if(response.result=='${codes.SUCCESS_CODE}'){
						alert("임시비밀번호가 발송되었습니다.");
					}else if(response.result=='${codes.ERROR_FAILED_SMS_SNED}'){
						alert("문자메세지 발송 오류");
					}else if(response.result=='${codes.ERROR_QUERY_PROCESSED}'){
						alert("입력하신 정보의 데이터가 없습니다.");
					}else{
						alert("알 수 없는 에러가 발생하였습니다.");
					};
					closeFindPwPopup();
				},
				error:function(xhr,status,error){
					alert("에러\n"+status+"\n"+error);
				}
			});
			
		}
		
		$(window).on('hashchange',function(){
			
			if((location.hash==''||location.hash=='#')){
				$('#find_id_popup').hide();
				$('#find_pw_popup').hide();
			}
		});
		
		function join(){
			
			goPage('joinTerms.latte');
			// window.open('','_blank').location.href="http://m.medilatte.com/client/login/join.latte?referer=ALLPET";
		}
	
	</script>
</head>

<body>

<div data-role="page">

	<div class="simple_popup01" id="find_id_popup">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">아이디찾기</p>
					<a class="title_close" data-role="button" onclick="closeFindIdPopup();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center">
					<div class="login_input">
						<p class="search_input"><input type="text" id="phone_number" placeholder="휴대폰번호"></p>
					</div>
					<div class="login_btn" style="margin-top:20px;">
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button" onclick="findId();"><img src="${con.IMGPATH}/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>확인</span></a>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="simple_popup01" id="find_pw_popup">
		<div class="bg"></div>
		<div class="c_area_l1">
			<span class="aliner"></span>
			<div class="c_area_l2">
				<div class="title_bar">
					<p class="title_name">비밀번호찾기</p>
					<a class="title_close" data-role="button" onclick="closeFindPwPopup();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="32px"/></a>
				</div>
				<div class="center">
					<div class="login_input">
						<p class="search_input"><input type="text" id="id" placeholder="이메일계정"></p>
					</div>
					<div class="login_input">
						<p class="search_input"><input type="text" id="pw_phone_number" placeholder="휴대폰번호"></p>
					</div>
					<div class="login_btn" style="margin-top:20px;">
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button" onclick="findPw();"><img src="${con.IMGPATH}/btn/btn_confirm.png" alt="" height="20px"/>&nbsp;<span>임시비밀번호 받기</span></a>
						</p>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<script>
	setInputConstraint('phoneNumber','phone_number',12);
	$('#find_id_popup').hide();
	$('#find_pw_popup').hide();
	</script>

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div style="position:absolute; left:50%; top:-30px; z-index:-1;">
			<img src="${con.IMGPATH}/common/footprint01.png" width="160px"/>
		</div>
	
		<form id="form" name="form" method="post">
		<input type="hidden" name="prePage" value="${prePage}"/>
		
		<div class="login_area">
		
			<!-- <p class="login_title">
				<span>LOG-IN</span>
			</p> -->
			
			<div class="login_icon_area">
				<div class="btn_list">
				<ul>
					<li>
						<p class="icon_cir_red"><img src="${con.IMGPATH}/common/login_schedule.png" alt="" width="100%" /></p>
					</li>
					<li>
						<p class="icon_cir_yellow"><img src="${con.IMGPATH}/common/login_mypoint.png" alt="" width="100%"/></p>
					</li>
					<li>
						<p class="icon_cir_skyblue"><img src="${con.IMGPATH}/common/login_mypet.png" alt="" width="100%"/></p>
					</li>
				</ul>
				</div>
			</div>
			
			<p class="login_msg1">
				로그인을 하시면 <span>개인 일정관리, 반려동물 등록</span> 등 다양한 서비스를 만나보실 수 있습니다.
			</p>
			
			<div class="login_input">
				<p class="search_input"><input type="text" id="user_id" name="s_user_id" value="" placeholder="아이디"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="password" id="password" name="s_password" placeholder="비밀번호"></p>
			</div>
			
			<div class="login_btn">
				<p class="btn_bar_red btn_bar_shape01">
					<a data-role="button" onclick="goLogin('${type}');"><img src="${con.IMGPATH}/common/login_btn.png" alt="" height="20px"/>&nbsp;<span>로그인</span></a>
				</p>
			</div>
			
			<p class="id_search">
				<a onclick="openFindIdPopup();"><span>아이디 찾기</span></a>
				&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;
				<a onclick="openFindPwPopup();"><span>비밀번호 찾기</span></a>
			</p>
		</div>
		</form>
		
		<div style="position:absolute; right:60%; bottom:50px; z-index:-1;">
			<img src="${con.IMGPATH}/common/footprint02.png" width="120px"/>
		</div>
	
		<p class="new_join" onclick="join();">
			<img src="${con.IMGPATH}/common/login_join.png" alt="" height="20px"/>&nbsp;<span>신규회원가입</span>
		</p>
	
	</div>
	<!-- ///// content 끝-->
	
	<div id="footer">
		<p class="login_footer">
			하나의 계정으로 <b>ALLPET의 모든 동물병원 싸이트</b>를 이용하실 수 있습니다.
		</p>
	</div>
	
	<jsp:include page="../include/mypage_footer.jsp"/>

</div>
</body>
</html>