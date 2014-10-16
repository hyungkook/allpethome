<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
	
<div id="footer">
			<p class="txt01">
				<span class="border_r">법인(상호)명 : <label>${hospitalInfo.s_company_name}</label></span>
				<span class="border_r">대표자 : <label>${hospitalInfo.s_president}</label></span>
				<span class="border_r">사업자등록번호 : <label>${hospitalInfo.s_corp_reg_number}</label></span>
			</p>
			<c:if test="${not empty hospitalInfo.s_fax && not empty hospitalInfo.s_email}">
			<p class="txt01">
				<span class="border_r">FAX : <label> ${hospitalInfo.s_fax}</label></span>
				<span>이메일 : <label> ${hospitalInfo.s_email}</label></span>
			</p>
			</c:if>
			<c:if test="${not empty hospitalInfo.s_fax && empty hospitalInfo.s_email}">
			<p class="txt01">
				<span>FAX : <label> ${hospitalInfo.s_fax}</label></span>
			</p>
			</c:if>
			<c:if test="${empty hospitalInfo.s_email && not empty hospitalInfo.s_email }">
			<p class="txt01">
				<span>이메일 : <label> ${hospitalInfo.s_email}</label></span>
			</p>
			</c:if>
			<p class="txt01">
				<span>주소 : <label> ${hospitalAddress.s_old_addr_sido} ${hospitalAddress.s_old_addr_sigungu} ${hospitalAddress.s_old_addr_dong} ${hospitalAddress.s_old_addr_etc} ${hospitalAddress.s_old_zipcode}</label></span>
			</p>
			<p class="txt02 mt10">본 사이트에서 사용된 모든 일러스트, 그래픽 이미지와 내용의 무단 도용을 금합니다.</p>
			<p class="txt03 mt05">copyrightⓒ${hospitalInfo.s_company_name} all rights reserved</p>
			<p class="txt03">
				<span class="border_r">Hosting by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
				<span>Designed by <a href="http://www.allpethome.com/">ALLPET</a>.</span>
			</p>
		</div>