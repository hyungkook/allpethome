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
		function goJoin() {
			

			
			var id = $.trim($('#s_user_id').val());
			var pw = $.trim($('#s_password').val());
			var pw_re = $.trim($('#s_password_re').val());
			
			if (!id) {
				alert("이메일 계정을 입력해주세요.");
				$('#s_user_id').focus();
				return;
			}
			
			if (!chkEmail(id)) {
				alert("이메일 형식을 다시 확인하세요.");
				$('#s_user_id').focus();
				return;
			}
			
			goUserCheck();
			
			if ($('#idChk').val() == 'N') {
				alert('이미 가입된 메일이 존재합니다.');
				$('#s_user_id').focus();
				return;
			}
			
			if (!$.trim($('#s_name').val())) {
				alert("이름을 입력하여 주세요.");
				$('#s_name').focus();
				return;
			}
			if (!$.trim($('#s_cphone_number').val())) {
				alert("휴대전화 번호를 입력하여 주세요.");
				$('#s_cphone_number').focus();
				return;
			}
			
			if(chkPhoneNumber($.trim($('#s_cphone_number').val())) == false){
				alert("잘못된 휴대전화 번호입니다. \n 예) 010XXXXXXXX");
				$('#s_cphone_number').focus();
				return;
			}
			
			if ($("#s_password").val().length < 4) {
				alert("비밀번호는 4자리 이상으로 설정해주세요.");
				$('#s_password').focus();
				return;
			}
			
			if (pw != pw_re) {
				alert("비밀번호를 확인해주세요.");
				$('#s_password_re').focus();
				return;
			}
			
			$.post( "joinAccept.latte", $( "#form" ).serialize() ).done(function( data ) {
				if( data == "1"){
					if( window.hybrid ){
						var msg = '{"type" : "JOIN","userId" : "' + id + '"}';
						window.hybrid.setMessage(msg);
					}
					alert('회원 가입되었습니다.');
				}else{
					alert('회원가입에 실패하였습니다. 관리자에게 문의하여 주세요.');
				}
				goPage('login.latte?rePage=myPageHome.latte');
			});
			//document.getElementById("form").action="joinAccept.latte";
			//document.getElementById("form").submit();
		}
		
		$(window).load(function(){
			
			$('#s_password_re').on('keyup',function(){
				if(event.keyCode==13)
					goJoin('');
			});
			
			$('#s_user_id').focus();
		});
		
		function goUserCheck() {
			
			
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
	
	</script>
</head>

<body>

<div data-role="page">

	<!-- content 시작-->
	<div data-role="content" id="contents">
	
		<div style="position:absolute; left:50%; top:-30px; z-index:-1;">
			<img src="${con.IMGPATH}/common/footprint01.png" width="160px"/>
		</div>
	
		<form id="form" name="form" method="post">
		<input type="hidden" id="idChk" name="idChk" value="N" />
		<input type="hidden" name="prePage" value="${prePage}"/>
		
		<div class="login_area">
			<p class="login_msg1">
				<br />
				AllPet 회원가입을 환영합니다. <br />
				추후 다양한 서비스가 예정되어있습니다.<br />
			</p>
			<div class="login_input">
				<p class="search_input"><input type="text" id="s_user_id" name="s_user_id" value="" placeholder="이메일"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="text" id="s_name" name="s_name" placeholder="이름"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="text" id="s_cphone_number" name="s_cphone_number" placeholder="휴대전화번호"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="password" id="s_password" name="s_password" placeholder="비밀번호"></p>
			</div>
			<div class="login_input">
				<p class="search_input"><input type="password" id="s_password_re" name="s_password_re" placeholder="비밀번호확인"></p>
			</div>
			
			<div class="login_btn">
				<p class="btn_bar_red btn_bar_shape01">
					<a data-role="button" onclick="goJoin();"><img src="${con.IMGPATH}/common/login_btn.png" alt="" height="20px"/>&nbsp;<span>회원가입</span></a>
				</p>
			</div>
		</div>
		</form>
		
		<div style="position:absolute; right:60%; bottom:50px; z-index:-1;">
			<img src="${con.IMGPATH}/common/footprint02.png" width="120px"/>
		</div>
	
	</div>
	
	<jsp:include page="../include/mypage_footer.jsp"/>

</div>
</body>
</html>