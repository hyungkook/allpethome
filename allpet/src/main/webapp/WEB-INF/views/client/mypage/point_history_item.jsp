<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:forEach var="item" items="${pointList}" varStatus="c">
<li class="point_list">
	<c:set var="ymdhms" value="${fn:split(item.d_reg_date,' ')}"/>
	<c:set var="ymd" value="${fn:split(ymdhms[0],'-')}"/>
	<c:set var="hms" value="${fn:split(ymdhms[1],':')}"/>
	<p class="date">${ymd[0]}.${ymd[1]}.${ymd[2]} (${hms[0]}:${hms[1]})</p>
	<p class="title">${item.s_desc}</p>
	<p class="point">
		<span class="aligner"></span>
		<span class="<c:if test='${item.n_point >= 0}'>plus</c:if><c:if test='${item.n_point < 0}'>minus</c:if>"><c:if test="${item.n_point > 0}">+</c:if>${item.n_point}</span>&nbsp;&nbsp;<img src="${con.IMGPATH}/common/icon_point.png" alt="" height="18px" />
	</p>
</li>
</c:forEach>