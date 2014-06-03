<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
$(document).ready(function(){
	var mh = $('.mypage_header').find('img');
	mh.height($('.mypage_header').find('a').height());
	mh.width($('.mypage_header').find('a').height());
});
</script>