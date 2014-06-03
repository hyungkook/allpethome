<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<script>
function main_header_phone(){
	
	if('${hospitalInfo.s_tel}'==''){
		alert('등록된 번호가 없습니다.');
	}
	else
		location.href='tel://${hospitalInfo.s_tel}';
}
function openKakao(){
	
	$('#kakao_popup').show();
}
function closeKakao(){
	
	$('#kakao_popup').hide();
}
function goKakao(){
	
	location.href="kakao:\//";
}
</script>

<div class="simple_popup01" id="kakao_popup" style="display:none;">
	<div class="bg"></div>
	<div class="c_area_l1">
		<span class="aliner"></span>
		<div class="c_area_l2">
			<div class="title_bar">
				<p class="title_name">카카오톡</p>
				<a class="title_close" data-role="button" onclick="closeKakao();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="32px"/></a>
			</div>
			<div class="center kakaopopup">
				<p class="title01">
					카카오톡 ID : <b>${hospitalInfo.SNS_ID}</b>
				</p>
				<p class="detail01">
					위 아이디를 카카오톡 친구찾기에서 친구 등록하시면 병원진료 관련 무료 상담 도움 드립니다!
				</p>
				<%-- <p class="go_btn">
					<a data-role="button" onclick="goKakao();"><img src="${con.IMGPATH}/btn/btn_kakao02.png" alt="" height="24px"/>&nbsp;<span>카카오톡 바로가기</span></a>
				</p> --%>
			</div>
		</div>
	</div>
</div>

<!-- 상단 이미지 영역 시작-->
<div class="visual_area">
	<div class="logo_area">
		<%--
		<p class="img_area"><span><img src="<c:choose><c:when test="${empty logo_img.s_image_path}">${con.IMGPATH}/common/default_logo.jpg</c:when><c:otherwise>${con.img_dns}${logo_img.s_image_path}</c:otherwise></c:choose>" width="79px" height="79px"/></span></p>
		 --%>
		 <c:if test="${!empty logo_img.s_image_path}">
		<p class="img_area"><span><img src="${con.img_dns}${logo_img.s_image_path}" width="79px" height="79px"/></span></p>
		</c:if><p class="txt01">${hospitalInfo.s_hospital_name}</p>
	</div>
	<p class="my_info"><a onclick="goPage('myPageHome.latte');" data-role="button"><img src="${con.IMGPATH}/btn/btn_man.png" alt="" width="13" height="14"/><label><c:choose><c:when test="${params.isLogin eq 'Y'}">내정보</c:when><c:otherwise>로그인</c:otherwise></c:choose></label></a></p>
	<div class="btn_call">
		<%-- <p class="btn01"><a onclick="<c:if test="${empty hospitalInfo.s_sns_id}">alert('등록된 카카오톡 아이디가 없습니다.');</c:if><c:if test="${not empty hospitalInfo.s_sns_id}">alert('카카오톡 아이디 ${hospitalInfo.s_sns_id}');</c:if>" data-role="button"><img src="${con.IMGPATH}/btn/btn_kakao.png" alt="kakao talk" width="51" height="51"/></a></p> --%>
		<c:if test="${hospitalInfo.SNS_ID_status eq 'Y'}">
		<p class="btn01"><a data-role="button" onclick="openKakao();"><img src="${con.IMGPATH}/btn/btn_kakao.png" alt="kakao talk" width="51" height="51"/></a></p>
		</c:if>
		<p class="btn02 mt04"><a onclick="main_header_phone();" data-role="button"><img src="${con.IMGPATH}/btn/btn_phon.png" alt="전화" width="51" height="51"/></a></p>
	</div>
	<p class="bg_img"><img src="<c:choose><c:when test="${empty header_img.s_image_path}">${con.IMGPATH}/common/default_header.jpg</c:when><c:otherwise>${con.img_dns}${header_img.s_image_path}</c:otherwise></c:choose>" width="100%"/></p>
</div>
<!-- // 상단 이미지 영역 끝-->