<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<jsp:scriptlet>
pageContext.setAttribute("crlf", "\r\n");
pageContext.setAttribute("lf", "\n");
pageContext.setAttribute("cr", "\r");
pageContext.setAttribute("quot", "\"");
pageContext.setAttribute("equot", "\\\"");
</jsp:scriptlet>

<c:forEach items="${boardList}" var="item" varStatus="c">
<li id="b_item_${c.count}" class="li_list02" data-icon="false">
	<c:set var="ymdhms" value="${fn:split(item.d_reg_date,' ')}"/>
	<a onclick='preProcess();goPage("hospitalBoardDetail.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&bid=${item.s_bid}")' class="list_info" style="overflow:hidden; position:relative;">
	<c:if test="${not empty item.thum_img_path}"><img src="${con.img_dns}${item.thum_img_path}" width="65" height="65"/></c:if>
	<h3 id="subject_${c.count}">${item.s_subject}</h3>
	<p id="${item.s_bid}">${fn:replace(fn:replace(fn:replace(item.s_contents,lf,' '),'<','&lt;'),quot,equot)}</p>
	<p class="data">${ymdhms[0]}</p>
	</a>
</li>
<script>

$('#b_item_i${c.count}').ready(function(){
	
	var content = "${fn:replace(fn:replace(fn:replace(item.s_subject,lf,' '),'<','&lt;'),quot,equot)}";
	var $item = $('#subject_${c.count}');
	$item.html('1<br/>1');
	var item_h = $item.height()-1;
	
	createEllipse(content, 'subject_${c.count}', item_h);
	
	content = "${fn:replace(fn:replace(fn:replace(item.s_contents,lf,' '),'<','&lt;'),quot,equot)}";
	$item = $('#${item.s_bid}');
	$item.html('1<br/>1<br/>1');
	item_h = $item.height()-1;
	
	createEllipse(content, '${item.s_bid}', item_h);
});
</script>
</c:forEach>