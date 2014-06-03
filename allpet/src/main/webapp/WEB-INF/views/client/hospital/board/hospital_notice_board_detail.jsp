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
</jsp:scriptlet>

<script src="${con.JSPATH}/dateFunctions.js"></script>

<div class="view_top">
	<h3>${boardContents.s_subject}</h3>
	<p class="data mt05" id="reg_date1"></p>
</div>
<div class="view_contents">
	<p class="txt01">${fn:replace(fn:replace(boardContents.s_contents,'<','&lt;'),lf,'<br/>')}</p>
	<c:if test="${not empty boardContents.image_path}"><p class="view_img"><img src="${con.img_dns}${boardContents.image_path}" alt="" width="100%"/></p></c:if>
	<c:forEach var="video_item" items="${videoList}" varStatus="c">
	<c:if test="${video_item.s_sub_type eq codes.ELEMENT_BOARD_CONTENTS_SUBTYPE_RAW_CODE}">
		<div class='embed-container' style="margin-bottom:10px;">
			${video_item.s_value}
		</div>
	</c:if>
	</c:forEach>
</div>
<c:set var="ymdhms" value="${fn:split(boardContents.d_reg_date,' ')}"/>
<c:set var="ymd" value="${fn:split(ymdhms[0],'-')}"/>
<c:set var="hms" value="${fn:split(ymdhms[1],':')}"/>
<script>
var reg_date_tmp = (getFirstDateWeek(parseInt('${ymd[0]}'),parseInt('${ymd[1]}'))+parseInt('${ymd[2]}')-1)%7;
$('#reg_date1').html('${ymdhms[0]}('+['월','화','수','목','금','토','일'][reg_date_tmp]+') ${hms[0]}:${hms[1]}');
</script>