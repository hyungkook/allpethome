<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
	
<c:forEach items="${boardList}" var="item" varStatus="c">
<c:set var="itemIndex" value="${params.totalCount - (params.pageNumber-1) * params.onePageCountRow - c.index}"/>
<li id="b_item_i${c.count}" class="li_list" data-icon="false">
	<a onclick='preProcess();goPage("hospitalBoardDetail.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&bid=${item.s_bid}")' class="list_info" style="overflow:hidden; position:relative;">
		<p class="data02">${itemIndex}</p>
		<h3 class="h3_tt01" id="subject${c.count}">${item.s_subject}</h3>
	</a>
</li>
<script>
$('#b_item_i${c.count}').ready(function(){
	
	var content = "${fn:replace(fn:replace(fn:replace(item.s_subject,lf,' '),'<','&lt;'),quot,equot)}";
	var $item = $('#subject${c.count}');
	$item.html('1<br/>1');
	var item_h = $item.height()-1;
	
	createEllipse(content, 'subject${c.count}', item_h);
});
</script>
</c:forEach>