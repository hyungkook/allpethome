<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>마이페이지</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />
<jsp:include page="../include/title_header.jsp" />

<script>

function goHome(){
	
	var home = $.cookie('pet_homepage');
	
	if(home==null){
		alert('정보가 손상되었습니다. 처음부터 다시 접속해 주세요.');
		return;
	}
	
	goPage(home);
}

function logout(){
	$.ajax({async:false,url:'ajaxLogout.latte'});
	goHome();
}

</script>

</head>
<body>

	<div id="page" data-role="page">
	
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<div class="mypage_header">
				<div class="back"><a data-role="button" data-rel="back"><img height="0" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
				마이페이지
				<div class="menu1"><a data-role="button" onclick="goHome();"><img height="0" src="${con.IMGPATH}/btn/btn_home.png"/></a></div>
			</div>
			
			<div class="mypage_home_edit">
				<div class="info">
					<p class="name">${userInfo.s_name}</p>
					<p class="email mt05">${userInfo.s_user_id}</p>
				</div>
				<div class="btn">
					<a data-role="button" onclick="goPage('myPageModifyPesonalInfo.latte');"><img src="${con.IMGPATH}/btn/btn_myinfo_edit.png" alt="" width="100%" height="100%" /></a>
				</div>
			</div>
			
			<div class="a_type02">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />예정 스케줄</h3>
				<c:if test="${not empty userTodoList}">
				<jsp:include page="schedule_list_item.jsp"/>
				</c:if>
				<c:if test="${empty userTodoList}">
				<p style="padding:20px;">현재 등록된 일정이 없습니다.</p>
				</c:if>
				
				<div class="btn_area02">
					<div class="l_60">
						<p class="btn_bar_red btn_bar_shape01">
							<a data-role="button" onclick="goPage('myPageScheduleEdit.latte');"><span>일정추가</span></a>
						</p>
					</div>
					<div class="r_40">
						<p class="btn_bar_black btn_bar_shape01">
							<a data-role="button" onclick="goPage('myPageSchedule.latte?type=month');"><span>더보기</span></a>
						</p>
					</div>
				</div>
			</div>
			
			<div class="a_type02">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />반려동물</h3>
				
				<c:forEach var="item" items="${petList}">
					<c:if test="${item.age_second >= 60*60*24*365}">
					<c:set var="age"><fmt:formatNumber value="${item.age_second/60/60/24/365}" pattern="0"/>년</c:set>
					</c:if>
					<c:if test="${item.age_second >= 60*60*24*30 and item.age_second < 60*60*24*365}">
					<c:set var="age"><fmt:formatNumber value="${item.age_second/60/60/24/30}" pattern="0"/>개월</c:set>
					</c:if>
					<c:if test="${item.age_second < 60*60*24*30}">
					<c:set var="age"><fmt:formatNumber value="${item.age_second/60/60/24}" pattern="0"/>일</c:set>
					</c:if>
				<div class="mypage_home_pet" onclick="goPage('petRegPage.latte?pid=${item.s_pid}');">
					<div class="list">
						<p><span class="pet_name">${item.s_pet_name}</span><span class="pet_age">&nbsp;|&nbsp;</span><span class="pet_species"><c:if test="${item._species eq '개'}">Dog</c:if><c:if test="${item._species eq '고양이'}">Cat</c:if></span></p>
						<p class="pet_age">${item._breed} ${age}</p>
					</div>
					<div class="btn">
						<img src="${con.IMGPATH}/btn/btn_arrow_r.png" alt="" height="52px" />&nbsp;
					</div>
				</div>
				
				</c:forEach>
				<c:if test="${empty petList}">
				<p style="padding:20px;">등록된 반려동물이 없습니다. 반려동물의 각종 정보를 등록해 편리하게 관리해 보세요.</p>
				</c:if>
				
				<p class="btn_bar_red btn_bar_shape01 mt08">
					<a data-role="button" onclick="goPage('petRegPage.latte');"><span>반려동물 등록하기</span></a>
				</p>
				
			</div>
			
			<%-- <div class="a_type02">
				<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />적립 포인트</h3>
				
				<c:forEach var="item" items="${pointList}">
				<div class="list_item01" onclick="goPage('myPagePointHistory.latte?sid=${item.s_sid}');">
					<div class="inner">
						<p class="name">${item.s_hospital_name} 적립 포인트</p>
						<p class="point"><fmt:formatNumber value="${item.sum_pt}" pattern="#,###"/>&nbsp;<img src="${con.IMGPATH}/common/icon_point.png" alt="" height="16px" /></p>
					</div>
					<div class="btn">
						<img src="${con.IMGPATH}/btn/btn_arrow_r.png" alt="" height="52px" />&nbsp;
					</div>
				</div>
				</c:forEach>
				<c:if test="${empty pointList}">
				<p style="padding:20px;">적립된 포인트 내역이 없습니다.</p>
				</c:if>
			</div> --%>
			
			<div class="a_type02">
			
				<p class="btn_bar_black btn_bar_shape01">
					<a data-role="button" onclick="logout();"><span>로그아웃</span></a>
				</p>
				
				<!-- <p class="btn_bar_black btn_bar_shape01 mt08">
					<a data-role="button" onclick="goPage('myPageDropMember.latte');"><span>탈퇴신청</span></a>
				</p> -->
			</div>
		
		</div>
		
		<jsp:include page="../include/mypage_footer.jsp"/>
	
	</div>

</body>
</html>