<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<c:forEach items="${rssList}" var="item" varStatus="c">
<li id="b_item_i${c.count}" class="li_list" data-icon="false">
	<a href="${item.value.link[0]}" class="list_info" style="overflow:hidden; position:relative;" target="_blank">
		<c:if test="${not empty item.value.image and not empty item.value.image[0]}"><img src="${item.value.image[0]}" width="65" height="65"/></c:if>
		<h3 id="${c.count}"><c:if test="${fn:indexOf(item.value.link[0],'blog.naver')>-1}"><img src="${con.IMGPATH}/common/bu_naver.png" alt="" width="35" height="15"/></c:if>${item.value.title[0]}</h3>
		<p>${item.value.description[0]}</p>
	</a>
</li>
<script>
$('#b_item_i${c.count}').ready(function(){
	
	var content = "${fn:replace(fn:replace(item.value.title[0],lf,' '),quot,equot)}";
	var $item = $('#${c.count}');
	var $icon = $item.find('img').detach();
	$item.html('1<br/>1');
	var item_h = $item.height()-1;
	
	createEllipse(content, '${c.count}', item_h, null, $icon);
});
</script>
</c:forEach>