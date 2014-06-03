<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />

<script>

$(document).ready(function(){
	
	initSlideMenu();
});

</script>

<%-- 메뉴 슬라이드 스크립트 부분 시작 --%>

<script>

var existMenuPositionCookie = true;
var menuPosition = $.cookie('menuPosition');
if(menuPosition==null){	menuPosition = 1;existMenuPositionCookie=false;}
else{$.removeCookie('menuPosition');}

function initSlideMenu(){
	
	if(isMobileDevice()){
		$('#list').bind("touchstart", function(e){touchstart(e);});
		$('#list').bind("touchmove", function(e){e.preventDefault();});
		$('#list').bind("touchend", function(e){touchend(e);});
	}
	else{
		$('#list').bind("mousedown", function(e){touchstart(e);});
		$('#list').bind("mouseup", function(e){touchend(e);});
	}
	
	movingDistance = parseInt($('#center').width()*parseFloat('${100.0 / fn:length(menuList)}')/100.0);
	
	if(existMenuPositionCookie){savedLock();}
	else{centerLock();}

	validateBtn();
}

function centerLock(){//가운데고정//
	
	var seq = parseInt('${boardInfo.sequence}')-2;
	var len = parseInt('${fn:length(menuList)}');
	if(seq<0) seq=0;
	if(seq>len-3) seq=len-3;
	$('#center').css('margin-left',(movingDistance*-seq));
}

function savedLock(){//마지막누른위치//
	var seq = -(parseInt(menuPosition)+1-2);
	$('#center').css('margin-left',(movingDistance*seq));
}

var isMoving = false;

var movingDistance = 0;//parseFloat('${100.0 / fn:length(menuList)}');
var menuCount = parseInt('${fn:length(menuList)}');

function moveRight(){
	
	if(isMoving)
		return;
	
	var ml = parseInt($('#center').css('margin-left'));

	if(ml > -1)
		return;
	
	isMoving = true;
	
	$('#center').animate({
		'margin-left':'+='+movingDistance
	},'fast',function(){

		validateBtn();
		menuPosition--;
		
		isMoving = false;
	});
}

function moveLeft(){
	
	if(isMoving)
		return;
	
	var ml = parseInt($('#center').css('margin-left'));
	var ll = -((menuCount-1-2) * movingDistance -1);

	if(ml < ll)
		return;
	
	isMoving = true;
	
	$('#center').animate({
		'margin-left':'-='+movingDistance
	},'fast',function(){

		validateBtn();
		menuPosition++;
		
		isMoving = false;
	});
}

function validateBtn(){
	
	var ml = parseInt($('#center').css('margin-left'));
	var ll = -((menuCount-1-2) * movingDistance -1);

	if(ml < ll){$('#left_btn').hide();
	}else{$('#left_btn').show();}
	
	if(ml > -1){$('#right_btn').hide();
	}else{$('#right_btn').show();}
}

var start_x = 0;
var move_x = 0;

function touchstart(e){
	
	try{
		start_x = e.pageX || e.originalEvent.touches[0].pageX || e.originalEvent.changedTouches[0];
	}catch(e){}
}

function touchend(e){
	
	try{
		var _x = e.pageX || e.originalEvent.changedTouches[0].pageX || e.originalEvent.changedTouches[0];
		move_x = _x - start_x;
		
		if(move_x > -5 && move_x < 5)
			;
		else if(move_x < 0){
			moveLeft();
		}else{
			moveRight();
		};
	}catch(e){}
}

function goMenuLink(url){
	
	// 임계값
	if(move_x < 5 && move_x > -5){
		$.cookie('menuPosition', menuPosition, {expires:1});
		goPage(url);
	}
}

</script>

<style>
.embed-container { position: relative; padding-bottom: 56.25%; padding-top: 30px; height: 0; overflow: hidden; max-width: 100%; height: auto; }
.embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
</style>

</head>
<body style="overflow-x:auto;">
		
	<div data-role="page">
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 상단 이미지 영역 -->
			<jsp:include page="../main_header.jsp"/>
		
			<!-- 메인메뉴 -->
			<jsp:include page="../../include/main_menu.jsp"/>
			
			<!-- 상단 메뉴 영역 시작 -->
			<c:set var="curMenu" value="${boardInfo.sequence}"/>
			<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>

			<div class="tab_2depth">
				<p id="right_btn" class="btn_l btn_img02"><a onclick="moveRight();" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l02.png" alt="" width="34" height="45"/></a></p>
				<p id="left_btn" class="btn_r btn_img02"><a onclick="moveLeft();" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r02.png" alt="" width="34" height="45"/></a></p>
				<div class="list" id="list" style="overflow:hidden;">
					<ul style="position:relative; width:${mainMenuLen * 33.33}%">
						<li id="center" style="cursor:pointer;">
							<c:forEach items="${menuList}" var="item" varStatus="c">
							<a id="menu${c.index}" style="width:${100.0 / mainMenuLen}%"<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goMenuLink('hospitalBoard.latte?idx=${params.idx}&cmid=${item.s_cmid}');">${item.s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							</c:forEach>
						</li>
					</ul>
				</div>
			</div>
			<!-- 상단 메뉴 영역 끝 -->
			
			<%-- 게시판 타입에 따라 레이아웃 결정 --%>
			<c:choose>
			<c:when test="${boardInfo.s_group eq codes.BOARD_TYPE_IMAGE}">
				<c:set var="inner_layout" value="hospital_img_board_detail.jsp"/></c:when>
			<c:when test="${boardInfo.s_group eq codes.BOARD_TYPE_NOTICE}">
				<c:set var="inner_layout" value="hospital_notice_board_detail.jsp"/></c:when>
			<c:when test="${boardInfo.s_group eq codes.BOARD_TYPE_FAQ}">
				<c:set var="inner_layout" value="hospital_faq_board_detail.jsp"/></c:when>
			</c:choose>
			
			<jsp:include page="${inner_layout}"/>
			<div class="btn_area">
				<p class="btn_gray"><a data-role="button" data-rel="back">이전목록</a></p>
			</div>
			
		</div>
		<!-- ///// content 끝-->
		
		<jsp:include page="/include/client/INC_FOOTER_COPYRIGHT.jsp"/>
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/>
		
	</div>
	
</body>
</html>