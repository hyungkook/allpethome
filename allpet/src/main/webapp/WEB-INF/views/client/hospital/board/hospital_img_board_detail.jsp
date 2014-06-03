<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
</jsp:scriptlet>

<div class="view_top">
	<h3>${boardContents.s_subject}</h3>
	<p class="data mt05">${boardContents.d_reg_date}</p>
</div>
<div class="view_contents">
	<c:forEach var="video_item" items="${videoList}" varStatus="c">
	<c:if test="${video_item.s_sub_type eq codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE}">
		<div class='embed-container' style="margin-bottom:10px;">
			${video_item.s_value}
		</div>
	</c:if>
	</c:forEach>
	<!-- <p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></p>
	<p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></p>
	<p><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/></p> -->
	<c:if test="${not empty boardContents.image_path}"><p class="view_img"><img src="${con.img_dns}${boardContents.image_path}" alt="" width="100%"/></p></c:if>
	<p class="txt01">${fn:replace(fn:replace(boardContents.s_contents,'<','&lt;'),lf,'<br/>')}</p>
</div>
