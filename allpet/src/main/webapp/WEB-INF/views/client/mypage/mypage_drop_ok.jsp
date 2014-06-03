<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>탈퇴완료</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />

<script>
function goHome(){
	
	var home = $.cookie('homepage');
	
	if(home==null){
		alert('페이지 정보가 손실되었습니다. 처음부터 다시 접속해 주세요.');
		//location.href="http://m.medilatte.com/";
		return;
	}
	
	goPage(home);
}

</script>

</head>

<body>

	<div data-role="page">
	
		<div data-role="content" id="contents">
		
			<div class="mypage_header">
				탈퇴 완료
			</div>
			
			<div class="a_type04">
				
				<h3>탈퇴 신청이 정상적으로 처리되었습니다.</h3>
				
				<p class="contents">
					고객님의 소중한 정보는 개인정보 취급방침에 따라 안전하게 삭제되며, 일부 거래, 환불처리 등 정보는 관련 법률에 따라 일정기간 보관되었다가 파기됩니다.<br/>
					그동안 본 서비스를 이용해 주셔서 감사합니다. 더 나은 서비스상품으로 다시 뵙도록 노력하겠습니다.
				</p>
				
				<div class="btn_bar_red btn_bar_shape01 mt10">
					<a data-role="button" onclick="goHome();"><span>확인</span></a>
				</div>
			</div>
		</div>
		
		<jsp:include page="../include/mypage_footer.jsp"/>
		
	</div>

</body>
</html>