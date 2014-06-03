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

<c:set var="mainMenuLen" value="${fn:length(menuList)}"/>

<style type="text/css">

/* .ui-select .ui-btn-inner {padding:10px 0px;}
.ui-select div {margin:0px; padding:0px; border:1px solid black;} */

</style>

<style>
.embed-container { position: relative; padding-bottom: 56.25%; padding-top: 30px; height: 0; overflow: hidden; max-width: 100%; height: auto; }
.embed-container iframe, .embed-container object, .embed-container embed { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
</style>

<script>
var p_acc = 0;
var slideMenu;
$(document).ready(function(){
	
	//initSlideMenu();
	//slideMenu = new SlideMenu(parseInt('${fn:length(menuList)}'));
});
$(window).load(function(){
	
	var p_len = parseInt('${mainMenuLen}',10);
	//alert($('#center').width()+"\n"+p_len);
	for(var pi = 0; pi < p_len; pi++){
		var pw =  Math.floor(($('#center').width())*(pi+1)/p_len);
		$("#menu"+pi).width(pw-p_acc);
		//console.log('11  '+p_acc+","+p_len+","+pw+","+(pw-p_acc));
		//alert(pi+":"+p_acc+',1 '+($("#menu"+pi).offset().left-$('#center').offset().left)+","+$("#menu"+pi).length);

		var m = -($("#menu"+pi).offset().left-$('#center').offset().left)+p_acc-10;
		$("#menu"+pi).css('margin-left',m);
		p_acc=pw;
		//alert($("#menu"+pi).offset().left+","+$("#menu"+pi).width());
	}
	
	//initSlideMenu();
	slideMenu = new SlideMenu(parseInt('${fn:length(menuList)}'));
});
</script>

<jsp:include page="board/SlideBoardMenu.jsp"/>

</head>
<body>
		
	<div data-role="page" id="home">
		
		<!-- content 시작-->
		<div data-role="content" id="contents">
		
			<!-- 상단 이미지 영역 -->
			<jsp:include page="main_header.jsp"/>

			<jsp:include page="../include/main_menu.jsp"/>
			
			<!-- 상단 메뉴 영역 시작-->
			<c:set var="curMenu" value="${boardInfo.sequence}"/>
			
			<div id="boardMenu" class="tab_2depth">
				<p id="right_btn" class="btn_l btn_img02"><a data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_l02.png" alt="" width="34" height="45"/></a></p>
				<p id="left_btn" class="btn_r btn_img02"><a data-role="button"><img src="${con.IMGPATH}/btn/btn_arrow_r02.png" alt="" width="34" height="45"/></a></p>
				<div class="list" id="list" style="overflow:hidden;">
					<ul id="ccc" style="position:relative; width:${mainMenuLen * 33}%">
						<li id="center" style="cursor:pointer;">
							<c:forEach items="${menuList}" var="item" varStatus="c">
							<c:set var="www"><fmt:formatNumber value="${100.0 / mainMenuLen}" pattern="0"/></c:set>
							<a id="menu${c.index}" style="width:${www}%;"<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="slideMenu.goMenuLink('hospitalService.latte?idx=${params.idx}&cmid=${item.s_cmid}');">${item.s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
							</c:forEach>
						</li>
					</ul>
				</div>
			</div>
			<!-- 상단 메뉴 영역 끝-->
			
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
					
					<c:if test="${needBox eq 'Y' and empty item.s_contents and fn:length(item.videoList)==0 and empty item.image_path}">
						<c:set var="needBox" value="N"/>
					</c:if>
					
					<c:if test="${not empty item.s_subject}"><h3 class="mt25"><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />${item.s_subject}</h3></c:if>
					
					<c:if test="${not empty item.image_path}">
						<c:set var="needBox" value="Y"/>
					</c:if>
					
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