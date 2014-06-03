<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

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
var jsp = new Array();
jsp['aaa'] = '${menuPosition}';
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
				<a<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goPage('hospitalBoard.latte?idx=${params.idx}&cmid=${menuList[c.index].s_cmid}&menuPosition='+menuPosition);">${menuList[c.index].s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
				</c:forEach>
				</c:if>
			</li>
			<li id="center" style="cursor:pointer;">
				<c:if test="${menuPosition+3-2 gt -1}">
				<c:forEach items="${menuList}" begin="${menuPosition-1}" end="${menuPosition+3-2}" varStatus="c">
				<a<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goPage('hospitalBoard.latte?idx=${params.idx}&cmid=${menuList[c.index].s_cmid}&menuPosition='+menuPosition);">${menuList[c.index].s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
				</c:forEach>
				</c:if>
			</li>
			<li id="back" style="margin-left:100%; position:absolute;">
				<c:if test="${mainMenuLen gt 0}">
				<c:forEach items="${menuList}" begin="${menuPosition+3-1}" end="${mainMenuLen-1}" varStatus="c">
				<a<c:if test="${c.index eq curMenu-1}"> class="on"</c:if> onclick="goPage('hospitalBoard.latte?idx=${params.idx}&cmid=${menuList[c.index].s_cmid}&menuPosition='+menuPosition);">${menuList[c.index].s_name}<span><img src="${con.IMGPATH}/common/b_arrow02.png" alt="" width="10" height="5"/></span></a>
				</c:forEach>
				</c:if>
			</li>
		</ul>
	</div>
</div>