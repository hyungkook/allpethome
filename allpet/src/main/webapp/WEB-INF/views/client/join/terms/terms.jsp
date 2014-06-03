<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>서비스정책</title>
<jsp:include page="/include/client/INC_JSP_HEADER.jsp"/>
<jsp:include page="../../include/title_header.jsp" />
	
	<script>
	function topScroll() {
		window.scrollTo(0,0); 
	} 
	</script>
</head>

<body>
<div data-role="page">

	<!-- content 시작-->
	<div data-role="content" id="contents">
		<div class="mypage_header">
			<div class="back"><a data-role="button" data-rel="back"><img height="100%" src="${con.IMGPATH}/btn/btn_back.png"/></a></div>
			서비스 정책
		</div>
		
		<div class="tab02">
			<ul>
				<li class="first w50"><a onclick="goPage('joinTermsDetail.latte?type=01');" <c:if test="${param.type eq '01'}">class="on"</c:if>><span>이용약관</span></a></li>
				<li class="w50"><a onclick="goPage('joinTermsDetail.latte?type=02');" <c:if test="${param.type eq '02'}">class="on"</c:if>><span>개인정보 취급방침</span></a></li>
			</ul>
		</div>
		
		<div class="a_type01">
		<c:if test="${param.type eq '01'}">
		<div class="service_txt">
			<dl>
				<dt>제1조 [ 목적 ]</dt>
				<dd>
					<span class="txt12">본 약관은 메디라떼, 뷰티라떼 서비스(이하 "서비스")에 가입한 "회원"이 에이디벤처스 주식"회사"(이하 "회사")가 제공하는 서비스를 이용함에 있어 "회원" 및 "회사" 간의 제반 권리 의무와 관련 절차 등을 규정하는데 그 목적이 있습니다.</span>
				</dd>
				<dt>제2조 (용어의 정의)</dt>
				<dd>
					<span class="txt12">이 약관에서 사용하는 용어의 정의는 다음 각 항과 같으며, 정의되지 않은 용어에 대한 해석은 관계법령 및 홈페이지 내 별도 안내에서 정하는 바에 따릅니다.</span><br /><br />
					1) 메디라떼, 뷰티라떼 서비스(이하, "서비스") : 정보통신기기(PC, 모바일, 태블릿 PC 등의 장치를 포함)를 통해 모든 "회원"이 이용하는 서비스로 "회사"가 제휴한 "제휴사 또는 병원"(이하 "제휴사"라 한다)에 대한 정보검색, 포인트 적립 등을 제공하는 의료정보 검색 서비스 입니다.<br />
					2) 메디라떼, 뷰티라떼 "회원"(이하, "회원") : 본 약관에 동의 후 이용계약을 체결하고, 서비스에 정상적으로 가입되어 "서비스"를 이용하는 고객을 의미합니다.<br />
					3) 메디라떼, 뷰티라떼 계정(이하 "ID") : "회원"의 식별과 서비스 이용을 위하여 "회원"이 선정하고 "회사"가 승인하는 이메일 주소를 의미합니다.<br />
					4) 게시글 : "회원"이 서비스를 이용함에 있어 게시 또는 등록하는 부호, 문자, 음성, 음향, 영상, 이미지 등의 형태의 글 및 각종 파일과 링크 등을 의미합니다.<br />
					5) 메디라떼, 뷰티라떼 포인트 : 본 약관 제 7조의 기준에 부합하여 "회원"이 "회사"가 정한 규정에 따라 "제휴포인트"로의 전환 및 "제휴컨텐츠" 구입 등에 이용이 가능한 포인트를 말하며 재화로서의 가치는 없습니다. <br />
					6) 제휴컨텐츠 : "회사"가 제휴를 통하여 "회원"이 포인트를 지급하고 사용할 수 있는 다양한 서비스를 의미합니다. <br />
					7) 제휴포인트 : "회사"가 제휴한 "제휴서비스"에서 사용 가능한 포인트로 "메디라떼, 뷰티라떼 포인트"와 교환 또는 전환이 가능합니다.<br />
					8) 제휴서비스 : "회사"가 제휴한 서비스를 의미합니다.<br />
					9) 이벤트 : "제휴사"가 "서비스"를 통하여 "회원"에게 일정 상금 및 상품을 내걸고 진행하는 서비스를 의미합니다.<br />
					10) 컨텐츠 : "회사"가 제공하는 정보, 영상, 이미지, 이벤트 등으로 구성되는 서비스 형태를 의미합니다.<br />
					11) 프로필 : 모든 "회원"에게 공개되는 "회원"의 기본정보입니다. 공개 여부는 "회원"이 설정할 수 있습니다.
				</dd>

				<dt>제3조 [ 약관의 효력 및 개정 ]</dt>
				<dd>
					1) 본 약관은 서비스 화면 및 http://www.medilatte.com, http://www.beautylatte.co.kr(이하 "사이트") 에 게시하여 "회원"에게 공지 함으로써 효력이 발생합니다.<br />
					2) "회사"는 "약관의규제에관한법률", "정보통신망이용촉진및정보보호등에관한법률" 등 관련법을 위배하지 않는 범위에서 본 약관을 개정할 수 있습니다.<br />
					3) 본 약관은 필요 시 개정될 수 있으며 약관을 개정하고자 할 경우, "회사"는 개정된 약관을 적용일자 및 개정사유를 명시하여 현행약관과 함께 그 개정약관의 적용일자 14일 이전부터 적용일자 전일까지 공지합니다. 개정약관의 공지는 규정된 방법 중 1가지 이상의 방법으로 "회원"에게 명확하게 공지하도록 합니다.<br />
						<span style="margin-left:10px; display:block;">
						1.웹사이트 내 게시<br />
						2.E-mail통보<br />
						3.SMS 통보<br />
						4."회사"가 정한 기타 공지 방법 등
						</span>
					
					4) 본 조의 규정에 의하여 개정약관은 원칙적으로 그 효력 발생일로부터 장래를 향하여 유효합니다.<br />
					5) 본 약관의 개정과 관련하여 이의가 있는 "회원"은 "회원"탈퇴를 할 수 있습니다. 단, 이의가 있음에도 불구하고 본 조 제1항및 제2항에 따른 "회사"의 공지가 있은 후 14일 이내에 "회원"탈퇴 및 거부의사를 표명하지 않은 "회원"은 개정 약관에 동의한 것으로 봅니다.<br />
					6) "회원"이 개정약관의 적용에 동의하지 않는 경우 "회사"는 개정약관의 내용을 적용할 수 없으며, 이 경우 "회원"은 이용계약을 해지할 수 있습니다.<br />
					7) 본 조의 통지방법 및 통지의 효력은 본 약관의 각 조항에서 규정하는 개별적 또는 전체적인 통지의 경우에 이를 준용합니다.
				</dd>
				
				<dt>제4조 [ 서비스 이용신청 및 이용계약 성립 ] </dt>
				<dd>
					1) 서비스 이용계약은 "회원"이 본 약관 및 "개인정보취급방침" 등에 대하여 동의하고 "회사"가 제공하는 가입양식을 작성하여 서비스 이용을 신청한 경우 "회사"가 이를 승낙함으로써 이용계약이 체결됩니다.<br />
					2) "회원"은 제1항의 이용 신청 시 반드시 실제정보(본인 명의의 휴대전화번호, 본인이 사용중인 유효한 이메일 등)를 기재하여야 하며, 허위정보를 기재한 "회원"의 경우 서비스 이용이 제한되거나 제5조에 의거 "회원"과의 "서비스" 이용계약을 해지할 수 있습니다.<br />
					3) 만14세 미만의 이용고객이 서비스를 이용하기 위해서는 "회사"가 요구하는 소정의 법정대리인의 동의절차를 거쳐야 합니다.<br />
					4) 타인의 명의를 도용하는 등의 부정한 목적과 방법으로 이용 신청한 "회원"의 ID는 사전 통지없이 삭제될 수 있으며, 당해 "회원"은 "서비스" 이용금지 및 법적 제재를 받을 수 있습니다.<br />
					5) 제1항에 따른 신청에 있어 "회사"는 "회원"의 본인인증을 요청할 수 있습니다.<br />
					6) "회사"는 "회원"들에게 원활한 "서비스" 제공을 위해 "회원"에게 이메일 및 SMS 등을 통한 광고 및 "서비스" 관련 각종 정보를 제공할 수 있습니다. "회원"이 원치 않는 경우 언제든지 무선서비스를 통해서 수신거부를 할 수 있습니다.<br />
					7) ”회사”는 법률에서 정한 특별한 규정이 없는 경우를 제외하고, 기본적으로 본 약관의 동의를 근거로하여 별도동의 없이 “제휴서비스”, “제휴컨텐츠”, “이벤트”등의 서비스를 제공하는 “제휴사”에 제공될 수 있습니다.<br />
					8) "회사"는 "서비스" 운영 중 "회사" 정책에 따라 광고주가 광고송출을 원하는 "회원"의 범주를 제한할 시 "회원"은 서비스 이용에 제한이 따를 수 있습니다.<br />
					9) "회원"은 "서비스"를 이용 중 신청양식에 기재한 "회원"정보가 변경되었을 경우 즉각 "회원"정보를 수정하여야 합니다. "회원"정보 미 수정에 따라 발생하는 모든 책임은 "회원"에게 있습니다.
				</dd>
				
				<dt>제5조 [ "회원"정보의 변경 ] </dt>
				<dd>
					1) "회원"은 서비스 내 마이페이지 화면을 통하여 본인의 개인정보를 열람하고 수정할 수 있습니다. 단, "회사" 정책에 따라 월 1회로 개인정보 수정 시기를 제한하며 단말기 식별번호, 닉네임, 성별, ID 등은 수정이 불가능합니다.<br />
					2) "회원"은 거주지역, 관심사, 차량유무를 제외하고 본인의 개인정보를 허위로 설정하여 부당한 방법으로 이익을 취할 경우, 당사자의 포인트는 소멸되며 서비스 이용이 제한될 수 있습니다. 
				</dd>
				
				<dt>제6조 [ 이용계약의 해지 및 자격상실/정지 ]  </dt>
				<dd>
					<span class="txt12">가. "회원"은 본인 희망 시 계약을 해지하거나 서비스의 이용중지를 요청할 수 있습니다.</span><br />
					<span class="txt12">나. "회원"이 서비스의 이용중지를 요청 시, 이메일 통보 등 "회사"가 지정한 절차를 거쳐 신청해야 합니다.</span><br />
					<span class="txt12">다. "회사"는 다음 각 호에 해당하는 "회원"이 확인될 경우, 당해 "회원"에 대한 사전 통보없이 "회원"자격 유보/중지/해지 등의 조치를 취할 수 있으며, 이 경우 "회원"은 서비스와 관련된 모든 권리를 주장할 수 없습니다.</span><br />
					1) "회원"가입 신청 시에 허위의 내용을 등록한 경우<br />
					2) 포인트 부정적립 및 부정사용 등 서비스를 부정한 방법 또는 목적으로 이용한 경우<br />
					-서면 통보<br />
					-부정적립이란 "회원"이 "회사"가 정한 절차 또는 방식에 의해 포인트를 적립하지 않았음에도 불구하고 "회원"에게 적립된 경우 또는 정해진 적립율 이상으로 적립포인트가 적립된 경우를 말합니다. "회원"은 포인트를 적립하기 위해 정상적인 방법으로 포인트를 적립하여야하며 "회사"가 제공하는 절차를 이행해야 합니다. 그 이외의 경우에는 부정적립으로 간주합니다.<br />
					3) "회사"가 서비스 내 공지사항을 통하여 공시하는 후기작성 규정을 위반하는 경우<br />
					4) "회원"이 사망한 경우<br />
					5) 다른 "회원"의 서비스 홈페이지 이용을 방해하거나 그 정보를 도용하는 등 전자거래질서를 위협하는 경우<br />
					6) 서비스 내 다른 "회원"에 대한 위협/희롱/지속적인 고통 및 불편을 끼치는 경우<br />
					7) 서비스 내에서 "회사"의 운영자/임직원 또는 "회사"를 사칭한 경우<br />
					8) "회원" 가입 신청 시 제3자의 개인정보를 이용 및 불법으로 도용한 경우<br />
					9) 서비스 이용 중 법률 위반행위 및 사회의 안녕/질서/미풍양속을 해치는 행위를 한 경우<br />
					10) 제3자의 특허권, 상표권, 저작권, 영업비밀 등 지적재산권을 포함한 기타 권리를 침해하는 행위를 한 경우<br />
					11) "회사"로부터 특별한 권한을 부여 받지 않고 "회사"의 홈페이지 나 클라이언트 프로그램을 변경 또는 "회사"의 서버를 해킹하는 등의 시스템을 위협하는 행위를 한 경우<br />
					12) "회사"의 사전승인 및 다른 "회원"에 대한 사전 동의없이 Active X, 스파이웨어, 애드웨어 등의 프로그램을 강제로 설치하게 한 경우<br />
					13) 서비스 방문자나 타 "회원"의 의사와 무관하게 특정 사이트로 방문을 유도한 경우<br />
					14) 서비스 이용 중 불법복제 소프트웨어, 제3자의 저작물을 밀매하는 등의 관련 법률에 저촉되는 행위를 한 경우<br />
					15) 인종/성/광신/이적 등의 반 사회적/도덕적 편견에 기반한 단체를 결성하는 행위를 한 경우
					16) 다른 "회원"의 ID/이메일 계정 등의 개인정보를 수집하는 행위<br />
					17) 범죄와의 결부, 관련 법령 위반 활동으로 판단되는 행위를 한 경우<br />
					18) 다른 "회원"으로 하여금 상기 6항 내지 17항의 금지행위를 하도록 유발 및 조장하는 활동을 한 경우<br />
					19) 기타 본 약관에 규정된 "회원"의 의무를 위반한 경우<br />
				</dd>
				
				<dt>제7조 [ "회원"탈퇴와 포인트 처리 ]</dt>
				<dd>1) 본 약관 제6조 제2항에 정해진 방법으로 탈퇴를 하고자 하는 "회원"은 "회원"탈퇴 요청 후 "회사"가제공하는 절차를 이행하면 탈퇴를 하게 됩니다. 이때 잔여포인트는 자동으로 소멸되고 "회원"가입 시 작성한 기본정보는 영구 소멸됩니다.</dd>
				<dd>2) 본 약관 제6조 제3항에 정해진 바에 의하여 자격상실 통보를 받은 "회원"은 적립된 가용포인트를 자격상실 통보일로부터 본 약관이 정하는 바에 따라 현금 환급 및 제휴컨텐츠를 구매할 수 없습니다. 잔여포인트 해소기간까지 사용하지 않은 포인트는 자동으로 소멸됩니다.</dd>
				
				<dt>제8조 [ 메디라떼, 뷰티라떼 서비스 ]</dt>
				<dd>
			   	<span class="txt12">가. "회사"가 본 약관에 정해진 바에 따라 "회원"에게 제공하는 "서비스"는 다음 각 호와 같으며 서비스를 이용하고자 하는 고객은 본 약관에 정해진 제반 절차를 거쳐 "회원"으로 가입하여야 합니다. 단, 본 "서비스"는 의료정보검색 서비스로써 그 특성 상 "제휴사"의 요구 또는 관련 법령에 따라 "회원"들은 일부 "서비스"의 이용조건, 이용범위 등이 제한되거나 "회원"에게 일정한 자격요건이 요구될 수 있으며, 이 경우 "회사"는 그 제한사항 및 자격요건을 "회원"에게 고지해드립니다.</span><br />
					
						1) 적립 서비스<br />
						-"회원"은 본 약관에 정해진 바에 따라 병원정보를 검색하고 "제휴사"에서 서비스 또는 재화를 구매할 경우 법령에서 정하는 기준에 따라 비급여 항목 진료 또는 서비스 및 재화의 구매 등을 이행하고 포인트를 적립받을 수 있습니다.<br />
						-"회원"이 "제휴사"에서 결제를 하는 경우 본 "서비스"와는 별개로 "회원"의 개인정보가 결제정보와 함께 "제휴사"에 제공되므로, "서비스"를 통해 "포인트"로 적립을 받을 경우 "회원"은 자동으로 "회사"와 "제휴사" 상호 간 회원정보 제공에 동의하는 것으로 간주합니다.<br />
						-따라서 "회사"와 "제휴사"간 제공되는 정보는 "포인트" 적립 및 이벤트 공지 등에 사용될 수 있습니다.<br />
						
						2) 제휴포인트 전환 서비스<br />
						-"회원"은 본 약관에 정해진 바에 따라 적립된 "포인트"를 "제휴포인트"로 교환 또는 전환 받을 수 있습니다.<br />
						3) 제휴컨텐츠 서비스<br />
						-"회원"은 본 약관에 정해진 바에 따라 적립된 포인트로 제휴된 상품을 구매 할 수 있습니다.<br />
						4) 이벤트 서비스<br />
						-"회원"은 본 약관에 정해진 바에 따라 이벤트에 참여할 수 있습니다.<br />
						5) 즐겨찾기 등록<br />
						-"회원"이 "제휴사"를 "즐겨찾기 등록"하는 경우, "회사"의 개인정보 활용에 동의하는 것으로 간주하며, "제휴사"에 대한 공지사항 및 이벤트정보 등의 수신에 동의하는 것으로 한다.<br />
						-"즐겨찾기 등록"의 경우 "제휴사"에 제공되는 정보는 최소화하여 비공개로 제공되며, "제휴사"는 "서비스"에서 제공하는 SMS문자발송에만 활용할 수 있다.<br />
						6) 기타<br />
						-"회사"는 상기 각 호의 서비스 이외에도 추가적인 서비스를 개발하여 "회원"에게 제공할 수 있습니다.<br />
				<span class="txt12">나. "회사"는 "서비스"의 원활한 제공을 위하여 서비스 웹사이트(www.medilatte.com, www.beautylatte.co.kr)를 운영하고 있으며, 서비스에서 지원되지 못하는 보다 상세한 내용을 확인 및 문의할 수 있습니다. </span>
				</dd>
				
				<dt>제9조 (서비스의 내용 및 변경)</dt>
				<dd>1) "회사"는 서비스 사이트를 통하여 "회원"에 대한 메디라떼, 뷰티라떼 관련 제반 서비스 및 정보의 제공, 기타 "회사"가 정하는 업무를 수행합니다.</dd>
				<dd>2) "회사"는 "서비스"의 내용을 변경하고자 할 경우에는 변경된 서비스의 내용 및 제공일자를 공지합니다. 단, 변동내용을 구체적으로 공지하기가 불가능한 경우에는 7일 전에 그 취지 및 공지가 불가능한 변동사유를 공지합니다.</dd>
				
				<dt>제10조 [ 서비스의 일시 중단 ]</dt>
				<dd>1) "회사"는 컴퓨터 등 정보통신설비의 점검,보수 ,교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.</dd>
				<dd>2) 본 조 제1항의 사유로 서비스를 중단하고자 할 경우 "회사"는 SMS로 발송하거나 서비스 내 공지사항 및 사이트에 게시하는 방법으로 "회원"에게 서비스 중단사실을 알려드립니다.</dd>
				<dd>3) "회사"의 고의 또는 과실에 기인한 서비스의 부당한 중단 및 시스템 장애로 "회원"이 손해를 입은 경우, "회사"는 통상적으로 예상 가능한 범위 내에서 동 손해를 배상합니다.</dd>
				
				<dt>제11조 [ 포인트 적립 ]</dt>
				<dd>1) "서비스"에서 제공하는 절차를 이행하면 포인트를 부여받게 됩니다. 포인트 적립을 위하여 특정 "회원"의 자격요건이 요구될 수 있으며, 적립된 포인트는 "마이페이지" 화면에서 확인할 수 있습니다.</dd>
				<dd>2) 포인트의 적립과 관련하여 발생하는 제세공과금은 "회원"이 부담하는 것을 원칙으로 합니다. .</dd>
				
				<dt>제12조 [ 포인트 정정, 취소 및 소멸 ]</dt>
				<dd>1) 포인트 적립에 오류가 있을 경우 "회원"은 오류발생 시점부터 90일 이내에 "회사"에 정정 신청을 하여야 하며, "회사"는 "회원"의 정정 신청일로부터 90일 이내에 조정할 수 있습니다. .</dd>
				<dd>2) "회사"는 "제휴사"가 "회원"에게 부여한 포인트를 관리하고 운영하는 역할을 담당합니다. 따라서 "제휴사"와 "회사"간에 거래과정에서 결제 문제 발생 또는 "제휴사"의 파산, 부도 등 지급이 불가능한 경우에는 "회원"에게 기 부여된 포인트가 취소될 수 있으며, 이에 대한 책임은 "제휴사"에게 있습니다. </dd>
				<dd>3) "회원"이 본 서비스를 이용하여 적립받은 포인트의 유효기간은 12개월 이며, 사용하지 않은 포인트는 유효기간 경과 후 자동 소멸됩니다.</dd>
				
				<dt>제13조 [ "회원"ID 및 비밀번호 ]</dt>
				<dd>1) "회원"ID와 비밀번호에 관한 관리책임은 "회원" 본인에게 있으며, "회원"은 제3자에게 자신의 ID 및 비밀번호를 알려주거나 이용하게 해서는 안됩니다.</dd>
				<dd>2) "회원"이 자신의 ID 또는 비밀번호를 도난 당하거나 제3자가 사용하고 있음을 인지한 경우에는 즉시 "회사"에 통보하고 "회사"의 안내가 있는 경우에는 그에 따라야 합니다.</dd>
				
				<dt>제14조 [ "회사"의 의무 ] </dt>
				<dd>1) "회사"는 관련법과 이 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 계속적이고 안정적으로 "서비스"를 제공하기 위하여 최선을 다하여 노력합니다. </dd>
				<dd>2) "회사"는 "회원"이 안전하게 서비스를 이용할 수 있도록 개인정보(신용정보 포함)보호를 위해 보안시스템을 갖추어야 하며 개인정보취급방침을 공시하고 준수합니다. </dd>
				<dd>3) "회사"는 서비스이용과 관련하여 "회원"으로부터 제기된 의견이나 불만이 정당하다고 인정할 경우에는 이를 처리하여야 합니다. "회원"이 제기한 의견이나 불만사항에 대해서는 게시판을 활용하거나 전자우편 등을 통하여 "회원"에게 처리과정 및 결과를 전달합니다. </dd>
				<dd>4) "회사"는 "회원" 관리 및 양질의 서비스를 제공하기 위하여 서비스 홈페이지 www.medilatte.com, www.beautylatte.co.kr 을 운영 합니다. </dd>
				
				<dt>제15조 [ "회원"의 의무 ]</dt>
				<dd>
				 <span class="txt12">"회원"은 서비스 이용과 관련하여 다음 각 호의 행위를 하여서는 안됩니다.</span><br />
					1) 서비스 이용 관련 제반 신청행위 또는 변경행위 시 허위내용 등록행위<br />
					2) 서비스 내 게시된 각종 정보의 무단 변경, 삭제 등 훼손 행위<br />
					3) 다른 "회원"의 명예를 손상시키거나 개인정보를 수집하는 행위<br />
					4) "회사"의 동의 없이 영리 목적의 광고 정보를 전송하거나 "회사"가 허용한 정보 이외의 다른 정보(컴퓨터 프로그램 및 광고 등)를 송신하거나 게시하는 행위<br />
					5) 일체의 가공행위를 통해 서비스를 분해, 모방 또는 변형하는 행위<br />
					6) "회사" 또는 기타 제3자의 저작권 등 지적재산권에 대한 침해 행위<br />
					7) 외설 또는 폭력적인 정보(메시지 ,화상 ,음성 등), 기타 공서양속에 반하는 정보를 서비스에 공개하거나 게시하는 행위<br />
					8) 서비스 공지사항에 공시된 후기작성 규정을 위반하는 행위
				</dd>
				
				<dt>제16조 [ 저작권의 귀속 및 이용제한 ]</dt>
				<dd>1) "회사"가 작성한 저작물에 대한 저작권 기타 지적재산권은 "회사"에 귀속합니다.</dd>
				<dd>2) "회원"은 서비스를 이용함으로써 얻은 정보를 "회사"의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.</dd>
				
				<dt>제17조 [ 서비스 관련 분쟁해결 ]</dt>
				<dd>1) "회사"는 서비스 이용과 관련하여 "회원"으로부터 제출되는 불만사항 및 의견을 최대한 신속하게 처리합니다. 다만, 신속한 처리가 곤란한 경우에는 "회원"에게 그 사유와 처리일정을 조속히 통보해 드립니다.</dd>
				<dd>2) "회사"와 "회원"간에 발생한 분쟁은 전자거래기본법에 의하여 설치된 전자거래분쟁 조정위원회의 조정</dd>
				
				<dt>제18조 [ 서비스 종료 ]</dt>
				<dd>1) "서비스"를 종료하고자 할 경우, "회사"는 "서비스"를 종료하고자 하는 날로부터 3개월 이전에 본 약관 제3조 제3항에 규정된 통지방법을 준용하여 "회원"에게 알려드립니다.</dd>
				<dd>2) 본 조 제1항에 따른 서비스 종료 통지가 있은 날(이하 "통지일") 현재 기 적립된 포인트는 "회사"가 별도 지정하는 날(이하 "서비스 종료일")까지 본 약관이 정하는 바에 따라 제휴포인트로 전환하거나 제휴컨텐츠를 이용해 소진하여야 합니다. "서비스 종료일"까지 사용하지 않은 포인트는 자동으로 소멸됩니다.</dd>
				<dd>3) 본 조 제1항에 따른 "서비스" 종료 통지일 이후 "회원"은 "회사"로부터 "서비스"를 제공받지 못합니다.</dd>
				
				<dt>제19조 [ 준거법 및 합의관할 ]</dt>
				<dd>1) 본 약관에서 정하지 않은 사항과 본 약관의 해석에 관하여는 대한민국법 및 상관례에 따릅니다.</dd>
				<dd>2) "서비스" 및 본 약관과 관련한 분쟁 및 소송은 서울중앙지방법원 또는 민사소송법상의 관할법원을 제1심 관할법원으로 합니다.</dd>
				
				<dt>제20조 [ 개인정보보호 의무 ]</dt>
				<dd><span class="txt12">"회사"는 관련법령이 정하는 바에 따라서 "회원" 등록정보를 포함한 "회원"의 개인정보를 보호하기 위하여 노력합니다. "회원"의 개인정보보호에 관해서는 관련법령 및 "회사"가 정하는 "개인정보 취급방침"에 정한 바에 의하며, "회원"이 상시 확인할 수 있도록 홈페이지를 통해 공지하고 있습니다.</span></dd>
				
				<dt style="font-size: 12px; text-align: center; color: #017da0; margin-top:30px;">부 칙</dt>
				<dd>
				본 약관은 2012년 10월 22일부터 시행합니다.<br />
				현재 이용약관은 메디라떼, 뷰티라떼 사이트에서 확인 할 수 있습니다.<br /><br />
				개정일 : 2013년 11월 07일
				</dd>
				<dd>(Ver. 1.2)</dd>
			</dl>
		</div>
		</c:if>
		<c:if test="${param.type eq '02'}">
		<div class="service_txt">
			<dl>
				<dd class="pt20">
				<span class="txt12">에이디벤처스 주식회사(이하 '회사')는 회원님의 개인정보를 중요시하며, 개인정보의 보호와 관련하여 정보통신망 이용촉진 및 정보보호 등에 관한 법률, 개인정보 보호법, 전기통신사업법, 통신비밀보호법 등 개인정보와 관련된 법령 상의 개인정보 보호 규정 및 방송통신위원회가 제정한 개인정보보호지침을 준수하고 있습니다.<br /><br />
				
				회사는 개인정보취급방침을 통하여 회원님들의 개인정보가 남용되거나 유출되지 않도록 최선을 다할 것이며, 회원님께서 제공하시는 개인정보가 어떠한 용도와 방식으로 이용되고 있고, 개인정보보호를 위해 어떠한 조치가 취해지고 있는지 알려드리고자 합니다.
				<br /><br />
				단, 본 개인정보 취급방침은 정부의 법령 및 지침의 변경, 또는 보다 나은 서비스의 제공을 위하여 그 내용이 변경될 수 있으니, 회원님들께서는 사이트 방문 시 수시로 그 내용을 확인하여 주시기 바라며, 회사는 개인정보취급방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.<br /><br /></span>
				<span>
				1. 수집하는 개인정보 항목 및 이용 목적<br />
				2. 개인정보의 보유, 이용기간 및 파기<br />
				3. 개인정보의 제3자 제공<br />
				4. 개인정보의 취급 위탁<br />
				5. 회원 및 법정대리인의 권리와 그 행사방법<br />
				6. 이용자의 의무<br />
				7. 개인정보 자동수집 장치(쿠키 등)의 설치, 운영 및 그 거부에 관한 사항<br />
				8. 링크사이트에 대한 책임<br />
				9. 개인정보의 기술적/관리적 보호 대책<br />
				10. 개인정보 관리 책임자<br />
				11. 개인정보 취급방침의 개정과 그 공지<br />
				별첨. 에이디벤처스 주식회사 청소년 보호 정책<br />
				</span>
				</dd>
				<dt>1. 수집하는 개인정보 항목 및 이용 목적</dt>
				<dd>
				
				<span class="txt12">가. 회사가 개인정보를 수집하는 목적은 이용자의 신분과 서비스 이용의사를 확인하여 최적화되고 맞춤화된 서비스를 제공하기 위함입니다. 회사는 최초 회원가입 시 서비스 제공을 원활하게 하기 위해 필요한 최소한의 정보만을 수집하고 있으며 회사가 제공하는 서비스 이용에 따른 대금결제, 물품배송 및 환불 등에 필요한 정보를 추가로 수집할 수 있습니다.</span><br /><br />
				<span class="txt12">나. 회사는 개인정보를 수집 및 이용목적 이외에 다른 용도로 이를 이용하거나 이용자의 동의 없이 제3자에게 제공하지 않습니다.</span><br /><br />
				<span class="txt12">다. 다음과 같은 목적으로 개인정보를 수집하여 이용할 수 있습니다.</span><br /><br />
				
				1) 회원<br />
				- 성명, 아이디, 비밀번호, 아이핀(I-PIN)번호, 이메일, 연락처(일반전화 또는 휴대전화), 기기식별번호(디바이스 아이디 또는 IMEI), 거주지역, 생년월일, 직업, 결혼여부, 성별 <br />
				- 연계정보 : 회사가 제공하는 서비스의 이용에 따르는 본인확인, 연령제한 서비스 제공, 아이핀(I-PIN)인증, 민원사항처리, 만 14세 미만인 경우 위 항목에 대한 법정대리인의 정보. 다만, 서비스 이용과정에서 서비스 이용기록, 접속 로그, 쿠키, 접속 IP 정보, 결제기록 등이 생성되어 수집될 수 있습니다.<br />
				- 이메일주소, 전화번호, 이동전화번호, 주소 : 거래의 원활한 진행, 본인의사의 확인, 불만처리, 새로운 상품, 서비스 정보와 고지사항의 안내 등<br />
				- 수취인 성명, 주소, 전화번호 : 상품과 경품 배송을 위한 배송지 확인 등<br />
				- 신용카드정보, 은행계좌정보, 이동전화번호정보 : 대금결제서비스의 제공 등
				<br />
				2) 기타<br />
				-이용과정이나 사업처리 과정에서 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
				(IP Address, 방문일시, 서비스 이용 기록 : 부정 이용 방지, 비인가 사용 방지 등)<br />
				-당사의 제휴과정에서 아래와 같은 정보들이 수집될 수 있습니다.
				(제휴사의 고객포인트카드번호, 제휴사의 ID, 제휴사의 이메일, 제휴사에 등록한 전화번호)
				<br /><br />
				<span class="txt12">
				라. 회사는 이용자의 개인정보를 수집할 경우 반드시 이용자의 동의를 얻어 수집하며, 이용자의 기본적 인권을 침해할 우려가 있는 인종, 출신지, 본적지, 사상, 정치적 성향, 범죄기록, 건강상태 등의 정보는 이용자의 동의 또는 법령의 규정에 의한 경우 이외에는 수집하지 않습니다. <br /><br />
				마. 당사는 회원 가입을 만 14세 이상인 경우에 가능하도록 하며 개인정보의 수집•이용에 법정대리인의 동의가 필요한 만 14세 미만 아동의 개인정보는 원칙적으로 수집하지 않습니다. <br /><br />
				바. 회사는 수집된 회원님들의 개인정보를 다음의 목적을 위해 이용하고 있습니다.
				</span>
				<br /><br />
				1) 서비스 제공에 관한 계약 이행 및 서비스 제공에 따른 요금정산<br />
				- 콘텐츠 및 회원 맞춤형 서비스 제공, 서비스 구매 및 요금 결제, 금융거래 본인 인증 및 금융 서비스<br />
				2) 회원관리<br />
				- 회원제 서비스 이용에 따른 본인확인, 개인 식별, 불량회원의 부정 이용 방지와 비인가 사용 방지, 가입 의사 확인, 가입 및 가입회수 제한, 분쟁 조정을 위한 기록 보존, 불만처리 등 민원처리, 고지사항 전달<br />
				3) 신규서비스 개발 • 마케팅 및 광고에 활용<br />
				- 신규 서비스(컨텐츠) 개발 및 특화, 이벤트 등 광고성 정보 전달, 통계학적 특성에 따른 서비스 제공 및 광고 게재, 접속 빈도 파악, 회원의 서비스 이용에 대한 통계<br />
				4) 시행일 이후 "회원"이 "서비스"를 이용할 시 개정약관에 동의한 것으로 간주됩니다. "회원"은 변경된 약관에 동의하지 않을 경우 이용계약을 해지할 수 있습니다.
				<br /><br />
				<span class="txt12">사. 회사는 다음과 같은 방법으로 개인정보를 수집할 수 있습니다.</span><br />
				- 서비스(회원가입), 홈페이지, 서면, 팩스, 전화, 고객센터 문의하기, 이벤트, 제휴사로부터의 제공, 단말기를 통한 수집 등<br />
				- 생성정보 수집 툴을 통한 자동 수집<br />
				</dd>
				<dt>2. 개인정보의 보유, 이용기간 및 파기</dt>
				<dd>
				<span class="txt12">가.회사는 원칙적으로 개인정보 수집 및 이용목적이 달성된 후에는 해당 개인정보를 지체 없이 파기합니다. 단, 관계법령의 규정에 의하여 보존할 필요가 있는 경우 회사는 아래와 같이 관계법령에서 정한 일정한 기간 동안 회원정보를 보관합니다.</span>
				<br /><br />
				1) 상법 등 법령에 따라 보존할 필요성이 있는 경우<br />
				-계약 또는 청약철회 등에 관한 기록<br />
				보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제 6조 및 시행령 제 6조<br />
				보존기간 : 5년<br />
				-대금결제 및 재화 등의 공급에 관한 기록<br />
				보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제 6조 및 시행령 제 6조<br />
				보존기간 : 5년<br />
				-소비자의 불만 또는 분쟁처리에 관한 기록<br />
				보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률 제 6조 및 시행령 제 6조<br />
				보존기간 : 3년<br />
				-본인확인에 관한 기록<br />
				보존근거 : 정보통신망 이용촉진 및 정보보호에 관한 법률 제44조의 5 및 시행령 제 29조<br />
				보존기간 : 6개월<br />
				-접속에 관한 기록<br />
				보존근거 : 통신비밀보호법 제 15조의 2 및 시행령 제 41조<br />
				보존기간 : 3개월<br />
				-부정이용기록<br />
				보존근거 : 부정이용의 배제 등 회사 방침에 의한 보존<br />
				보존기간 : 1년<br />
				-신용정보의 수집, 처리 및 이용 등에 관한 기록<br />
				보존근거 : 신용정보의 이용 및 보호에 관한 법률<br />
				보존기간 : 3년<br />
				-표시•광고에 관한 기록<br />
				보존근거 : 전자상거래 등에서의 소비자보호에 관한 법률<br />
				보존기간 : 6개월<br />
				
				2) 회사가 보유기간을 미리 고지하고 그 보유기간이 경과하지 아니한 경우와 개별적으로 동의를 받은 경우에는 약정한 기간 동안 보존합니다.<br />
				3) 수집된 개인정보의 보유•이용기간은 서비스이용계약체결(회원가입)시부터 서비스이용계약해지(탈퇴신청, 직권탈퇴 포함)입니다. 또한 동의 해지 시 회사는 이용자의 개인정보를 상기 명시한 정보보유 사유에 따라 일정 기간 저장하는 자료를 제외하고는 지체 없이 파기하며 개인정보취급이 제3자에게 위탁된 경우에는 수탁자에게도 파기하도록 지시합니다.<br />
				4) 파기방법<br />
				-이용자의 개인정보는 수집 및 이용목적이 달성된 후에는 지체 없이 파기됩니다. 종이에 출력된 개인정보는 분쇄기로 분쇄하거나 소각 등을 통하여 파기하고, 전자적 파일형태로 저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 파기합니다.<br />
				5) 개인정보 자동 수집장치의 설치/운영 및 거부에 관한 사항<br />
				-회사는 계정정보를 생성하기 위해 이용자가 "서비스"를 실행할 때 기기식별번호(디바이스 아이디 또는 IMEI)를 자동으로 수집하게 되며, 이에 대한 승인 여부는 이용자 설정할 수 있습니다.<br />
				</dd>
				<dt>3. 개인정보의 제3자 제공</dt>
				<dd>
				<span class="txt12">가.회사는 이용자들의 개인정보를 「수집하는 개인정보 항목 및 이용 목적」에서 고지한 범위 내에서 사용하며, 기본적으로 서비스이용약관의 동의를 근거로하여 별도동의 없이 제휴서비스, 제휴컨텐츠, 이벤트등의 서비스를 제공하는 제휴사에 제공될 수 있습니다. 이외에 이용자의 사전 동의 없이 동 범위를 초과하여 이용하거나 원칙적으로 이용자의 개인정보를 제3자에게 제공하지 않습니다. 다만, 아래의 경우에는 예외로 합니다.</span><br /><br />
				1) 이용자들이 사전에 공개 또는 제3자 제공에 동의한 경우<br />
				2) 법령의 규정에 의거하거나, 수사, 조사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관 및 감독당국의 요구가 있는 경우<br /><br />
				
				<span class="txt12">나.회사가 제공하는 서비스를 통하여 주문 및 결제가 이루어진 경우 상담 등 거래 당사자간 원활한 의사소통 및 배송 등 거래이행을 위하여 관련된 정보를 필요한 범위 내에서 거래 당사자에게 제공합니다. </span><br /><br />
				<span class="txt12">다.그 밖에 개인정보 제3자제공이 필요한 경우에는 합당한 절차를 통한 이용자의 동의를 얻어 제3자에게 개인정보를 제공할 수 있습니다. 동의를 얻어 개인정보를 제공받는 자와 이용목적은 제공의 동의를 받을 시 안내 및 명시됩니다. </span>
				</dd>
				<dt>4. 개인정보의 취급 위탁</dt>
				<dd>
				<span class="txt12">가.회사는 원활하고 향상된 서비스를 위하여 개인정보 취급을 타인에게 위탁할 수 있습니다.</span><br /><br />
				<span class="txt12">나.회사는 개인정보의 처리와 관련하여 아래와 같이 업무를 위탁하고 있으며, 관계법령에 따라 위탁 계약 시 개인정보가 안전하게 관리될 수 있도록 필요한 조치를 하고 있습니다. 또한 위탁 처리하는 정보는 원활한 서비스를 제공하기 위하여 필요한 최소한의 정보에 국한됩니다.</span><br /><br />
				<span class="txt12">다.회사의 이용자의 개인정보 위탁 처리 시 수탁업체 및 위탁 목적은 아래와 같습니다.</span>
				</dd>
			</dl>
		</div>
		<div class="stage_area03">
			<table  class="table_type04 mt15">
				<colgroup>
					<col width="50%" /><col width="50%" />
				</colgroup>
				<tr>
					<th>수탁업체</th>
					<th>위탁업무 내용</th>
				</tr>
				<tr>
					<td>Siren24</td>
					<td>실명인증 / I-PIN인증</td>
				</tr>
				<tr>
					<td>INICIS, LG U+</td>
					<td>신용카드 결제, 실시간 계좌이체, 휴대폰 결제</td>
				</tr>
				<tr>
					<td>나이스신용정보평가</td>
					<td>성인인증 / 실명인증</td>
				</tr>
				<tr>
					<td>㈜앱디스코</td>
					<td>배송 및 MMS발송 대행</td>
				</tr>
				<tr>
					<td>㈜앱디스코</td>
					<td>포인트교환, 고객상담, 고객주문 및 배송상담, 고객불만사항 접수 및 처리, 회원정보 수정</td>
				</tr>
			</table>
		</div>
		<div class="service_txt">
			<dl>
				<dt>5. 회원 및 법정대리인의 권리와 그 행사방법</dt>
				<dd>
				<span class="txt12">가. 회원은 언제든지 등록되어 있는 본인 개인정보를 조회하거나 수정할 수 있으며 회원 탈퇴 절차를 통하여 개인정보 이용에 대한 동의 등을 철회할 수 있습니다.</span><br /><br />
				<span class="txt12">나. 개인정보의 조회/수정을 위해서는 어플리케이션, 모바일웹, 웹사이트등의 [마이페이지]내의 [개인정보관리] 항목에서 확인 가능하며, 가입 해지(동의철회)는 [마이페이지]내의 [개인정보관리] 항목 하단의 '탈퇴신청'을 통하여 탈퇴하실 수 있습니다.</span><br /><br />
				<span class="txt12">다. 이 외에도 회사의 개인정보 관리책임자에게 서면, 전화 또는 이메일로 연락하여 열람/수정/탈퇴를 요청하실 수 있습니다.</span><br /><br />
				<span class="txt12">라. 회원님이 개인정보의 오류에 대한 정정을 요청하신 경우에는 정정을 완료하기 전까지 당해 개인정보를 이용 또는 제공하지 않습니다. 회사는 회원님의 요청에 의해 해지 또는 삭제된 개인정보는 제 2 조에 명시된 바에 따라 처리하고 그 외의 용도로 열람 또는 이용할 수 없도록 처리하고 있습니다.</span>
				</dd>
				<dt>6. 이용자의 의무</dt>
				<dd>
				이용자는 자신의 개인정보를 보호할 의무가 있으며, 이용자 본인의 부주의나 인터넷 상의 문제 등으로 개인정보가 유출되어 발생한 문제에 대해 회사는 일체의 책임을 지지 않습니다.<br /><br />
				<span class="txt12">가. 이용자는 자신의 개인정보를 최신의 상태로 유지해야 하며, 이용자의 부정확한 정보 입력으로 발생하는 문제의 책임은 이용자 자신에게 있습니다.</span><br /><br />
				<span class="txt12">나. 타인의 주민등록번호 등 개인정보를 도용하여 회원가입 또는 물품거래 시 이용자자격 상실과 함께 주민등록법에 의거하여 처벌될 수 있습니다.</span><br /><br />
				<span class="txt12">다. 이용자는 아이디, 비밀번호 등에 대해 보안을 유지할 책임이 있으며 제3자에게 이를 양도하거나 대여할 수 없습니다. 이용자는 회사의 개인정보보호정책에 따라 보안을 위해 비밀번호의 주기적 변경에 협조할 의무가 있습니다.</span><br /><br />
				<span class="txt12">라. 이용자는 "정보 통신망 이용촉진 및 정보보호 등에 관한 법률", "개인정보보호법", "주민등록법" 등 기타 개인정보에 관한 법률을 준수하여야 합니다.</span>
				</dd>
				<dt>7. 개인정보 자동수집 장치(쿠키, 기기식별번호 등)의 설치, 운영 및 그 거부에 관한 사항</dt>
				<dd>
				<span class="txt12">가. 쿠키 등 사용목적</span><br />
				- 회사는 회원님들에게 보다 적절하고 유용한 서비스를 제공하기 위하여 회원님의 정보를 수시로 저장하고 불러오는 '쿠키(cookie)'를 사용합니다. 쿠키란 회사의 웹사이트를 운영하는데 이용되는 서버가 회원님의 컴퓨터로 전송하는 아주 작은 텍스트 파일로서 회원님의 컴퓨터 하드디스크에 저장됩니다. 회원님께서는 쿠키의 사용여부에 대하여 선택하실 수 있습니다.<br /><br />
				<span class="txt12">나. 쿠키 설정 거부 방법</span><br />
				- 예: 쿠키 설정을 거부하는 방법으로는 이용자가 사용하는 웹 브라우저의 옵션을 선택함으로써 모든 쿠키를 허용하거나 쿠키를 저장할 때마다 확인을 거치거나, 모든 쿠키의 저장을 거부할 수 있습니다. 설정방법 예(인터넷 익스플로어의 경우) : 웹 브라우저 상단의 도구 &gt; 인터넷 옵션 &gt; 개인정보 단, 쿠키 설치를 거부하였을 경우 로그인이 필요한 일부 서비스 이용에 어려움이 있을 수 있습니다.<br /><br />
				<span class="txt12">다. 기기식별번호 수집 및 승인</span><br />
				-회사는 계정정보를 생성하기 위해 이용자가 "서비스"를 실행할 때 기기식별번호(디바이스 아이디 또는 IMEI)를 자동으로 수집하게 되며, 이에 대한 승인 여부는 이용자 설정할 수 있습니다.  <br />			  
				</dd>
				<dt>8. 링크사이트에 대한 책임</dt>
				<dd>
				회사는 이용자에게 다른 모바일웹 또는 어플리케이션, 웹사이트 등에 대한 링크를 제공할 수 있습니다. 다만, 링크되어 있는 모바일웹 또는 어플리케이션, 웹사이트 등이 개인정보를 수집하는 행위에 대해서는 본 "개인정보취급방침"이 적용되지 않습니다.
				</dd>
				<dt>9. 개인정보의 기술적/관리적 보호 대책</dt>
				<dd>
				이용자들의 개인정보를 취급함에 있어 개인정보가 분실, 도난, 누출, 변조 또는 훼손되지 않도록 안전성 확보를 위하여 다음과 같은 기술적/관리적 보호대책을 강구하고 있습니다.<br /><br />
				<span class="txt12">가. 개인정보의 암호화</span><br />
				- 이용자의 비밀번호는 일 방향 암호화하여 저장 및 관리되고 있으며, 개인정보의 확인 및 변경은 비밀번호를 알고 있는 본인에 의해서만 가능합니다. 비밀번호는 이용자의 생일, 전화번호 등 타인이 추측하기 쉬운 숫자 등을 이용하지 않도록 비밀번호 생성규칙을 수립하여 적용하고 있습니다. 주민등록번호, 외국인 등록번호 등의 개인정보는 저장되지 않으나, 부득이하게 저장하는 경우 안전한 암호 알고리즘으로 암호화되어 저장 및 관리되고 있습니다.<br /><br />
				<span class="txt12">나. 해킹 등에 대비한 대책</span><br />
				- 회사는 해킹 등 회사 정보통신망 침입에 의해 이용자의 개인정보가 유출되는 것을 방지하기 위해 침입탐지 및 침입차단 시스템을 24시간 가동하고 있습니다. 만일의 사태에 대비하여 모든 침입탐지 시스템과 침입차단 시스템은 이중화로 구성하여 운영하고 있으며, 민감한 개인정보는 암호화 통신 등을 통하여 네트워크상에서 개인정보를 안전하게 전송할 수 있도록 하고 있습니다.<br /><br />
				<span class="txt12">다. 개인정보 취급자의 최소화 및 교육</span><br />
				- 회사는 회사의 개인정보 취급자를 최소한으로 제한하며, 개인정보 취급자에 대한 교육 등 관리적 조치를 통해 개인정보보호의 중요성을 인식시키고 있습니다.
				</dd>
				<dt>10. 개인정보관리책임자</dt>
				<dd>
				회원님들의 개인정보를 보호하고 개인정보와 관련된 불만 등을 처리하기 위하여 회사는 고객서비스담당 부서 및 개인정보관리책임자를 두고 있습니다. 회원님의 개인정보와 관련한 문의사항은 아래의 고객서비스담당 부서 또는 개인정보관리책임자에게 연락하여 주시기 바랍니다.<br />
				[고객서비스 &amp; 개인정보관리 담당]<br />
				이 름 : 박상익 <br />
				소 속 : 운영팀<br />
				직 위 : 매니저<br />
				전화번호 : 1666-1609<br />
				이메일 : help@medilatte.com, beautylatte@advs.co.kr<br /><br />
				
				기타 개인정보침해에 대한 신고나 상담이 필요하신 경우에는 아래 기관에 문의하시기 바랍니다.<br />
				1. 개인정보침해신고센터(www.118.or.kr/118)<br />
				2. 정보보호마크인증위원회 (www.eprivacy.or.kr/02-580-0533~4)<br />
				3. 대검찰청 인터넷범죄수사센터 (http://icic.sppo.go.kr/02-3480-3600)<br />
				4. 경찰청 사이버테러대응센터 (www.ctrc.go.kr/02-392-0330)<br />
				11. 개인정보취급방침의 개정과 그 공지<br /><br />
				
				본 방침은 2012년 09 월 01 일 부터 시행됩니다. 본 개인정보 취급방침이 변경될 경우 회사는 변경 내용을 그 시행일 7일 전부터 홈페이지 '공지사항'을 통하여 공지 및 이용자 동의를 받을 예정입니다.
				</dd>
				<dt>* 개인정보취급방침 버전</dt>
				<dd>2012년 09월 01일</dd>
				<dd>개정일 : 2013년 03월 14일</dd>
				<dt>* 별첨. 에이디벤처스 주식회사 청소년 보호 정책</dt>
				<dd>
				에이디벤처스 주식회사(이하 "회사"라 합니다)은 불건전한 유해매체물로부터 청소년을 보호하기 위해 정보통신망이용촉진 및 정보보호등에관한법률 및 청소년보호법에 근거하여 청소년보호정책을 시행하고 있습니다. 당사는 방송통신심의위원회 심의규정 및 청소년유해매체물 기준에 따라, 19세 미만의 청소년들이 유해매체물에 접근할 수 없도록 방지하고 있습니다.<br /><br />
				
				1. 유해정보에 대한 청소년접근제한 및 관리조치<br />
				당사는 청소년이 각종 불법, 유해매체물의 유통 등으로 인한 피해를 입지 않도록 청소년유해매체물에 대해서는 별도의 성인인증 장치를 적용하며 청소년 유해정보가 노출되지 않도록 예방합니다.<br />
				2. 유해정보로 인한 피해상담 및 고충처리당사는 청소년 유해매체물의 유통으로 인한 피해신고 및 처리를 위해 신고 센타를 통한 신고를 접수 받아 처리 하고 있습니다.<br />
				3. 당사 청소년 보호정책 책임자<br />
				회원님의 본 정책과 관련한 문의사항은 아래의 당사 청소년 보호정책 책임자에게 연락하여 주시기 바랍니다.<br />
				[청소년 보호정책 담당]<br />
				이 름 : 박상익<br />
				소 속 : PM팀<br />
				직 위 : 매니저<br />
				전화번호 : 1666-1609<br />
				이메일 : help@advs.co.kr<br />
				</dd>
			</dl>
		</div>
		</c:if>
		
		</div>

	</div>
	<!-- ///// content 끝-->
	
	<jsp:include page="../../include/mypage_footer.jsp"/>
	<!-- footer 시작-->
	<%-- <jsp:include page="/include/client/INC_JSP_FOOTER.jsp"/> --%> 
	<!-- ///// footer 끝-->

</div>
</body>
</html>