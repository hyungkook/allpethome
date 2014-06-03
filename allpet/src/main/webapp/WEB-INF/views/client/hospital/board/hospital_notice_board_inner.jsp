<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

		<%-- <c:forEach items="${importantBoardList}" var="item">
			<li class="li_list" data-icon="false">
				<c:set var="ymdhms" value="${fn:split(item.d_reg_date,' ')}"/>
				<a onclick='goPage("hospitalBoardDetail.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&bid=${item.s_bid}")' class="list_info" style="overflow:hidden; position:relative;">
					<p class="data">${ymdhms[0]}</p>
					<h3 class="h3_tt01" style="color:red;">${item.s_subject}</h3>
				</a>
			</li>
		</c:forEach> --%>
<c:forEach items="${boardList}" var="item" varStatus="c">
<li class="li_list" id="b_item_i${c.count}" data-icon="false">
	<c:set var="ymdhms" value="${fn:split(item.d_reg_date,' ')}"/>
	<a onclick='preProcess();goPage("hospitalBoardDetail.latte?idx=${params.idx}&cmid=${boardInfo.s_cmid}&bid=${item.s_bid}")' class="list_info" style="overflow:hidden; position:relative;">
		<p class="data">${ymdhms[0]}</p>
		<h3 class="h3_tt01" id="subject${c.count}" <c:if test="${item.s_type eq codes.ELEMENT_BOARD_TYPE_IMPORTANT}"> style="color:red;"</c:if>>${item.s_subject}</h3>
	</a>
</li>
<script>
$('#b_item_i${c.count}').ready(function(){
	
	var content = "${fn:replace(fn:replace(fn:replace(item.s_subject,lf,' '),'<','&lt;'),quot,equot)}";
	var $item = $('#subject${c.count}');
	var $icon = $item.find('img').detach();
	$item.html('1<br/>1');
	var item_h = $item.height()-1;
	
	createEllipse(content, 'subject${c.count}', item_h, null, $icon);
});
</script>
</c:forEach>