function geolocationSuccessHandler(position) {
	var latitude = position.coords.latitude;
	var longitude = position.coords.longitude;
	// 쿠키 저장
	$.cookie("myLat",latitude, { expires: 365, path : '/'});
	$.cookie("myLon",longitude, { expires: 365, path : '/'});
	alert('success');
}

function geolocationErrorHandler(err) {alert("위치 데이터를 가져오는데 실패하였습니다.\n"+err.code+"\n"+err.message);}

function getLocation(){
	if(navigator.geolocation){
		navigator.geolocation.getCurrentPosition(geolocationSuccessHandler, geolocationErrorHandler, {
			timeout:3100,
			maximumAge:90000,
			enableHighAccuracy:false
		});
	}
}