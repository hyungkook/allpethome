<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:forEach var="item" items="${userTodoList}">
<div class="round_list">
	<c:if test="${item.timeout_flag eq 'Y'}">
	<div class="tag"><img src="${con.IMGPATH}/common/icon_schedule_off.png" alt="" width="24" height="24"/></div>
	</c:if>
	<c:if test="${ef_nearest.s_rownumber eq item.s_rownumber}">
	<div class="tag"><img src="${con.IMGPATH}/common/icon_schedule_on.png" alt="" width="24" height="24"/></div>
	</c:if>
	<table onclick="goPage('myPageScheduleEdit.latte?rownum=${item.s_sgid}')">
		<colgroup>
			<col width="25%"><col width="*">
		</colgroup>
		<tr>
			<c:if test="${item.timeout_flag eq 'Y' and empty item.s_confirmer}"><td rowspan="3" class="dday"><span>만료</span></td></c:if>
			<c:if test="${item.timeout_flag eq 'Y' and not empty item.s_confirmer}"><td rowspan="3" class="dday"><span>완료</span></td></c:if>
			<c:if test="${ef_nearest.s_rownumber eq item.s_rownumber}"><td rowspan="3" class="dday_red"><div>D-day<br/><span>${item.date_diff}</span></div></td></c:if>
			<c:if test="${item.timeout_flag eq 'N' and ef_nearest.s_rownumber ne item.s_rownumber}"><td rowspan="3" class="dday"><div>D-day<br/><span>${item.date_diff}</span></div></td></c:if>
			<td class="title">
				<c:if test="${item.s_type eq codes.REGISTRANT_TYPE_USER}">
				직접작성<br/>
				</c:if>
				<c:if test="${item.s_type eq codes.REGISTRANT_TYPE_HOSPITAL}">
				${item.s_hospital_name}<br/>
				</c:if>
			</td>
		</tr>
		<tr>
			<td class="contents">${item.s_comment}</td>
		</tr>
		<tr>
			<c:set var="ymdhms" value="${fn:split(item.d_todo_date,' ')}"/>
			<c:set var="ymd" value="${fn:split(ymdhms[0],'-')}"/>
			<c:set var="hms" value="${fn:split(ymdhms[1],':')}"/>
			<td class="time">[${ymd[0]}-${ymd[1]}-${ymd[2]} ${hms[0]}:${hms[1]}]</td>
		</tr>
	</table>
</div>
</c:forEach>
