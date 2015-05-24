<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE>
<html>
<head>
<title>로딩..</title>

<script>

var mobileKeyWords = new Array('iPhone', 'iPod', 'BlackBerry', 'Android', 'Windows CE', 'LG', 'MOT', 'SAMSUNG', 'SonyEricsson');
var isMobile = false;
for (var word in mobileKeyWords){
    if (navigator.userAgent.match(mobileKeyWords[word]) != null){
    	isMobile = true;
        break;
    }
}
if(isMobile){
	// alert("모바일기기로 접속하였습니다.");
	location.href='personalHome.latte';	
}else{
	// alert("PC로 접속하였습니다.");
	location.href='pcView.latte';
}

</script>

</head>
</html>