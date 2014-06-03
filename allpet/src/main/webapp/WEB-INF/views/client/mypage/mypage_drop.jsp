<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>탈퇴신청</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<script>
	
	function goDropMember() {
				
		/* if (!chkBox('tChk')) {
			alert("약관에 모두 동의 하여주시기 바랍니다.");
			return;
		} */
		
		if (!$('#pw').val()) {
			alert("비밀번호를 입력해주시기 바랍니다.");
			return;
		}
		
		document.getElementById("form").action = "myPageDropMemberAccept.latte";
		document.getElementById("form").submit();
	}
			
</script>

</head>

<body>

	<form id="form" method="post">
	<div data-role="page" id="home">
	
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="100%" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				회원탈퇴
			</div>
			
			<div class="a_type04">
			
				<p class="contents">
					서비스 탈퇴 시 AD VENTURES에서 운영하는<br/>
					<b>메디라떼, 뷰티라떼, 라떼스타일</b> 서비스도 함께 탈퇴 처리됩니다.
				</p>
			
				<div class="inner_area">
					<p>이용약관을 반드시 확인하시어 탈퇴 후 보유 포인트 자동 소멸, 상담내역/진료기록 소멸 등 발생할 수 있는 불이익에 대해 숙지하시기 바랍니다.</p>
					<div class="btn_area02 mt20">
						<div class="l_50 btn_bar_black btn_bar_shape02">
							<a data-role="button" href="javascript:goPage('joinTermsDetail.latte?type=01');"><span>서비스 이용약관 보기</span></a>
						</div>
						<div class="r_50 btn_bar_black btn_bar_shape02">
							<a data-role="button" href="javascript:goPage('joinTermsDetail.latte?type=02');"><span>개인정보 취급방침 보기</span></a>
						</div>
					</div>
				</div>
				
				<p class="contents">
					서비스 이용약관과 개인정보 취급방침에 따라 고객님의 정보 소멸/삭제에 동의하시면 아래에 비밀번호를 입력하시고 탈퇴하기를 선택해 주세요.
				</p>
			
				<h3 class="title01">고객동의 확인을 위한 비밀번호 입력</h3>
				<div class="input01">
					<p class="inner_input"><input type="password" id="pw" name="pw" placeholder="인증번호를 입력해주세요."></p>
				</div>
				<div class="btn_bar_red btn_bar_shape01 mt10">
					<a data-role="button" onclick="goDropMember();"><span>탈퇴하기</span></a>
				</div>
			</div>
		
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="../include/mypage_footer.jsp"/>

	</div>
	
	</form>
	
</body>
</html>