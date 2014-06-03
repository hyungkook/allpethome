<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<c:if test="${staffInfo.TIMETABLE_STATUS eq 'Y'}">
<!-- 진료시간-->
<div class="a_type01_b">
	<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />진료일정<span class="r01">* 진료일정은 사정에 따라 변경될 수 있습니다.</span></h3>
	<table  class="table_type01 mt10">
		<colgroup>
			<col width="*" /><col width="12%" /><col width="12%" /><col width="12%" />
			<col width="12%" /><col width="12%" /><col width="12%" /><col width="12%" />
		</colgroup>
		<tr>
			<th></th>
			<th>월</th>
			<th>화</th>
			<th>수</th>
			<th>목</th>
			<th>금</th>
			<th class="sat">토</th>
			<th class="sun">일</th>
		</tr>
		<c:set var="term" value="${fn:split(staffInfo.s_working_time,'|')}"/>	
		<c:forEach begin="0" end="${fn:length(term)-1}" varStatus="c">
			<tr>
			<td>
				<c:if test="${c.count==1}">오전</c:if>
				<c:if test="${c.count==2}">오후</c:if>
				<c:if test="${c.count==3}">야간</c:if>
			</td>
			<c:set var="week" value="${fn:split(term[c.index],';')}"/>
			<c:forEach begin="0" end="${fn:length(week)-1}" varStatus="w"><td>
			<c:if test="${week[w.index] eq 'Y'}"><img src="${con.IMGPATH}/common/point01.png" alt="" width="9" height="9" /></c:if>
			</td></c:forEach>
			</tr>
			
		</c:forEach>
	</table>
</div>
</c:if>

<!-- 이력사항-->
<c:if test="${staffInfo.HISTORY_STATUS eq 'Y'}">
<div class="a_type01_b">
	<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />이력사항</h3>
	<div class="txt_type01 mt10">
		<c:forEach var="item" items="${staffHistory}" varStatus="c">
		<c:set var="start_y" value="${fn:split(fn:split(item.d_start_date,' ')[0],'-')[0]}"/>
		<c:set var="end_y" value="${fn:split(fn:split(item.d_end_date,' ')[0],'-')[0]}"/>
		<c:if test="${start_y eq end_y}"><c:set var="history_year" value="${start_y}"/></c:if>
		<c:if test="${start_y ne end_y}"><c:set var="history_year">${start_y}<c:choose><c:when test="${empty start_y}"> ~ </c:when><c:when test="${empty end_y}"> ~ <br/></c:when><c:otherwise><br/> ~ </c:otherwise></c:choose>${end_y}</c:set></c:if>
		<dl>
			<c:choose>
			<c:when test="${not empty history_year}">
			<dt>${history_year}</dt>
			<dd>${item.s_desc}</dd>
			</c:when>
			<c:otherwise>
			<dd>${item.s_desc}</dd>
			</c:otherwise>
			</c:choose>
		</dl>
		</c:forEach>
	</div>
</div>
</c:if>

<!-- 학회활동 및 논문발표 -->
<c:if test="${staffInfo.CAREER_STATUS eq 'Y'}">
<div class="a_type01_b">
	<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />학회활동 및 논문발표</h3>
	<div class="txt_type01 mt10">
		<c:forEach var="item" items="${staffCareer}" varStatus="c">
		<c:set var="start_y" value="${fn:split(fn:split(item.d_start_date,' ')[0],'-')[0]}"/>
		<dl>
			<c:choose>
			<c:when test="${not empty item.d_start_date}">
			<dt>${start_y}</dt>
			<dd>${item.s_desc}</dd>
			</c:when>
			<c:otherwise>
			<dd>${item.s_desc}</dd>
			</c:otherwise>
			</c:choose>
		</dl>
		</c:forEach>
	</div>
</div>
</c:if>

<!-- 저서 -->
<c:if test="${staffInfo.BOOKS_STATUS eq 'Y'}">
<div class="a_type01_b">
	<h3><img src="${con.IMGPATH}/common/bu_tt.png" alt="" width="16" height="14" />저서</h3>
	<div class="txt_type01 mt10">
		<ul>
			<c:forEach var="item" items="${staffBooks}" varStatus="c">
			<li style="font-weight:normal;">${item.s_desc}</li>
			</c:forEach>
		</ul>
	</div>
</div>
</c:if>