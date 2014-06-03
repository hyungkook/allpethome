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
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<jsp:include page="/include/client/INC_JSP_HEADER.jsp" />

<style type="text/css">

/* .ui-select .ui-btn-inner {padding:10px 0px;}
.ui-select div {margin:0px; padding:0px; border:1px solid black;} */

</style>

<style>
.embed-container { position: relative; padding-bottom: 56.25%; padding-top: 30px; height: 0; overflow: hidden; max-width: 100%; height: auto; }
.embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
</style>

<script>

function sms(phone,msg){
	
	location.href="sms://"+phone+"?body="+encodeURIComponent(msg);
}

var isMoving = false;

function moveRight(){
	
	if($('#front a:last').length > 0){
		
		if(isMoving)
			return;
		
		isMoving = true;
		
		$('#center').animate({
			'margin-left':'+=33.33%'
		},'fast');
		
		$('#front').animate({
			'margin-left':'+=33.33%'
		},'fast',function(){
			$('#center').css('margin-left','0%');
			$('#front').css('margin-left','-100%');
			
			var c = $('#center a:last').detach();
			var f = $('#front a:last').detach();
			$('#center').prepend(f);
			$('#back').prepend(c);
			menuPosition--;
			
			$('#center').trigger('create');
			
			isMoving = false;
		});
	}
}

function moveLeft(){
	
	if($('#back a:first').length > 0){
		
		if(isMoving)
			return;
		
		isMoving = true;
		
		$('#center').animate({
			'margin-left':'-=33.33%'
		},'fast');
		
		$('#back').animate({
			'margin-left':'-=33.33%'
		},'fast',function(){
			$('#center').css('margin-left','0%');
			$('#back').css('margin-left','100%');
			
			var c = $('#center a:first').detach();
			var b = $('#back a:first').detach();
			$('#center').append(b);
			$('#front').append(c);
			menuPosition++;
			
			$('#center').trigger('create');
			
			isMoving = false;
		});
	}
}

var x = 0;
var xx = 0;

function touchstart(e){
	
	try{
		var _x = e.pageX || e.originalEvent.touches[0].pageX || e.originalEvent.changedTouches[0];
		xx = _x - x;
		x = _x;
	}catch(e){}
}

function touchend(e){
	
	try{
		var _x = e.pageX || e.originalEvent.changedTouches[0].pageX || e.originalEvent.changedTouches[0];
		xx = _x - x;
		
		if(xx > -5 && xx < 5)
			;
		else if(xx < 0){
			moveLeft();
		}
		else{
			moveRight();
		}
	}catch(e){}
}

$(document).ready(function(){
	
	if(isMobileDevice()){
		$('#list').bind("touchstart", function(e){touchstart(e);});
		$('#list').bind("touchmove", function(e){e.preventDefault();});
		$('#list').bind("touchend", function(e){touchend(e);});
	}
	else{
		$('#list').bind("mousedown", function(e){touchstart(e);});
		$('#list').bind("mouseup", function(e){touchend(e);});
	}
});

function goMenuLink(url){
	
	if(xx < 5 && xx > -5)
		goPage(url);
}

var menuPosition = 1;

</script>
</head>
<body>
		
	<div data-role="page" id="home">
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 상단 이미지 영역 -->
			<jsp:include page="main_header.jsp"/>

			<jsp:include page="../include/main_menu.jsp"/>
			
			<!-- 탭 영역 시작-->
			<c:set var="curMenu" value="${boardInfo.sequence}"/>
			<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>
			
			<c:choose>
			<c:when test="${empty boardInfo.menuPosition}">
				<c:set var="menuPosition" value="${curMenu - 1}"/>
			</c:when>
			<c:otherwise>
				<c:set var="menuPosition" value="${boardInfo.menuPosition}"/>
			</c:otherwise>
			</c:choose>
			
			<c:if test="${menuPosition gt (mainMenuLen-3+1)}">
				<c:set var="menuPosition" value="${mainMenuLen-3+1}"/>
			</c:if>
			<c:if test="${menuPosition lt 1}">
				<c:set var="menuPosition" value="1"/>
			</c:if>
			<script>
			menuPosition = '${menuPosition}';
			</script>
			<div class="tab_2depth">
				<c:if test="${mainMenuLen > 3}">
					<p class="btn_l btn_img02"><a onclick="moveRight();" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l02.png" alt="" width="34" height="45"/></a></p>
					<p class="btn_r btn_img02"><a onclick="moveLeft();" data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r02.png" alt="" width="34" height="45"/></a></p>
				</c:if>
				<div class="list" id="list">
					<ul style="position:relative;">
						<li id="front" style="margin-left:-100%; text-align:right; position:absolute;">
							<c:if test="${menuPosition-2 gt -1}">
							<c:forEach items="${menuList}" begin="0" end="${menuPosition-2}" varStatus="c">
							<a<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goPage('hospitalService.latte?idx=${params.idx}&cmid=${menuList[c.index].s_cmid}&menuPosition='+menuPosition);">${menuList[c.index].s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							</c:forEach>
							</c:if>
						</li>
						<li id="center" style="cursor:pointer;">
							<c:if test="${menuPosition+3-2 gt -1}">
							<c:forEach items="${menuList}" begin="${menuPosition-1}" end="${menuPosition+3-2}" varStatus="c">
							<a<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goPage('hospitalService.latte?idx=${params.idx}&cmid=${menuList[c.index].s_cmid}&menuPosition='+menuPosition);">${menuList[c.index].s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							</c:forEach>
							</c:if>
						</li>
						<li id="back" style="margin-left:100%; position:absolute;">
							<c:if test="${mainMenuLen gt 0}">
							<c:forEach items="${menuList}" begin="${menuPosition+3-1}" end="${mainMenuLen-1}" varStatus="c">
							<a<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goPage('hospitalService.latte?idx=${params.idx}&cmid=${menuList[c.index].s_cmid}&menuPosition='+menuPosition);">${menuList[c.index].s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							</c:forEach>
							</c:if>
						</li>
					</ul>
				</div>
			</div>
			<!-- // 탭 영역 끝-->
			
			<div class="a_type01">
				<!-- 셀렉트 메뉴 -->
				<c:if test="${not empty subMenuList}">
				<div class="btn_select">
					<a data-role="button">
					<select data-icon="false" onchange="goPage('hospitalService.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&cmid='+$(this).val());">
						<c:forEach var="item" items="${subMenuList}" varStatus="c">
						<option value="${item.s_cmid}" <c:if test="${subBoardInfo.s_cmid eq item.s_cmid}">selected="selected"</c:if>>${item.s_name}</option>
						</c:forEach>
					</select>
					</a>
					<p class="bu"><img src="${con.IMGPATH}/common/select_arrow.png" alt="" width="26" height="34"/></p>
				</div>
				</c:if>
				
				<!-- 본문 시작 -->
				<c:forEach var="item" items="${boardList}" varStatus="c">
				<%-- <c:choose> --%>
					<c:set var="needBox" value="Y"/>
					<c:if test="${empty item.s_subject and not empty item.s_contents}">
						<c:set var="needBox" value="N"/>
					</c:if>
					
					<c:if test="${not empty item.s_subject}"><h3 class="mt25"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />${item.s_subject}</h3></c:if>
					
					<c:if test="${not empty item.s_contents and needBox eq 'N'}">
						<p class="txt_type01 mt15">${fn:replace(fn:replace(item.s_contents,'<','&lt;'),crlf,'<br/>')}</p>
					</c:if>
					
					<c:if test="${needBox eq 'Y'}">
					<div class="w_box02 mt05" id="video_${c.count}">
						<c:if test="${not empty item.image_path}"><p class="img_area"><img src="${con.img_dns}${item.image_path}" alt="" width="100%" /></p></c:if>
						<c:forEach var="video_item" items="${item.videoList}" varStatus="v">
						<c:if test="${video_item.s_sub_type eq codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE}">
							<script>
								$(window).load(function(){
									var video_target_len = $('#video_back_${c.count}').length;
									if(video_target_len > 0)
										$("<div class='embed-container'>${fn:replace(video_item.s_value,quot,equot)}</div>").insertBefore($('#video_back_${c.count}'));
									else
										$('#video_${c.count}').append($("<div class='embed-container'>${fn:replace(video_item.s_value,quot,equot)}</div>"));
										
								});
							</script>
						</c:if>
						</c:forEach>
						<c:if test="${not empty item.s_contents}"><p class="txt01" id="video_back_${c.count}">${fn:replace(fn:replace(item.s_contents,'<','&lt;'),lf,'<br/>')}</p></c:if>
					</div>
					</c:if>
				</c:forEach>
				<c:if test="${empty boardList}">등록된 글이 없습니다.</c:if>
				<!-- 본문 끝 -->
				
			</div>
			
		</div>
		<!-- ///// content 끝-->
		
		<!-- footer -->
		<jsp:include page="/include/client/INC_FOOTER_COPYRIGHT.jsp" />
		<jsp:include page="/include/client/INC_JSP_FOOTER.jsp" />
		
	</div>
	
</body>
</html>