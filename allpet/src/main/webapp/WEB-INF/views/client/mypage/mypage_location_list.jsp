<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<ul class="select_list01">
	<li class="title">
		<p>${title}</p>
		<a data-role="button" onclick="cancelSelectArea();"><img src="${con.IMGPATH}/btn/btn_pop_close.png" height="36px"/></a>
	</li>
	
	<c:if test="${params.search_type eq 'sido' }">
	<c:forEach items="${areaList}" var="list" varStatus="c" >
		<li class="item" onclick="sido='${list.S_SIDO}';selectArea();">${list.S_SIDO}</li>
	</c:forEach>
	</c:if>
	
	<c:if test="${params.search_type eq 'sigungu' }">
	<c:forEach items="${areaList}" var="list" varStatus="c" >
		<li class="item" onclick="sigungu='${list.S_GUGUN}';selectArea();">${list.S_GUGUN}</li>
	</c:forEach>
	</c:if>
		
	<c:if test="${params.search_type eq 'dong' }">
	<c:forEach items="${areaList }" var="list" >
		<li class="item" onclick="dong='${list.S_DONG}';selectArea();">${list.S_DONG}</li>
	</c:forEach>
	</c:if>
</ul>
<input type="hidden" id="area_type" value="${params.type}"/>