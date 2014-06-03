<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%--
var v = new FloatingDialog({root:$('#home')});
v.open(msg,position);
v.close();
--%>
<script>
var FloatingDialog = function(options){
	
	this.opt = {
		root:$('body'),
		type:'fixed',
		zindex:99997,
		autoCloseTerm:1000
	};
	
	$.extend(this.opt,options);
	
	var _this = this;
	
	//this.absolute_dialog = {
	//		$root:$('<div style="position:absolute; top:0; width:100%; height:100%; background:transparent; z-index:99997;"></div>'),
	//		$cover:$('<div style="position:absolute; top:0; width:100%; height:100%; background:black; filter:alpha(opacity=25); opacity:0.25; z-index:99997;"></div>'),
	//		$msg_cover:$('<div style="position:absolute; width:100%; height:100px; background:black; filter:alpha(opacity=65); opacity:0.65; z-index:99998;"></div>'),
	//		$msg:$('<div style="position:absolute; width:100%; height:100px; background:transparent; z-index:99999;"><p style="color:white; text-align:center; height:100%;"><span style="display:inline-block; height:100%; vertical-align:middle;"></span></p></div>'),
	//		$msg_core:$('<span id="dialog_msg" style="vertical-align:middle;"></span>')
	//};
	
	this.absolute_dialog = {
			$root:$('<div/>'),
			$cover:$('<div/>'),
			$msg_cover:$('<div/>'),
			$msg:$('<div/>'),
			$msg_core:$('<span id="dialog_msg" style="vertical-align:middle;"></span>')
	};
	
	if(this.opt.type=='fixed'){
		this.absolute_dialog.$root.css(	{
			position:'fixed',
			top:'0',
			bottom:'0',
			left:'0',
			right:'0'
		});
	}else{
		this.absolute_dialog.$root.css(	{
			position:'absolute',
			top:'0',
			width:'100%',
			height:'100%'
		});
	}
	this.absolute_dialog.$root.css({
		background:'transparent',
		zIndex:this.opt.zindex+""
	});
	
	this.absolute_dialog.$cover.css({
		position:'absolute',
		top:'0',
		width:'100%',
		height:'100%',
		background:'black',
		filter:'alpha(opacity=25)',
		opacity:'0.25',
		zIndex:this.opt.zindex+""
	});
	
	this.absolute_dialog.$msg_cover.css({
		position:'absolute',
		width:'100%',
		height:'100px',
		background:'black',
		filter:'alpha(opacity=65)',
		opacity:'0.65',
		zIndex:(this.opt.zindex-(-1))+""
	});
	
	this.absolute_dialog.$msg.css({
		position:'absolute',
		width:'100%',
		height:'100px',
		background:'transparent',
		zIndex:(this.opt.zindex-(-2))+""
	});
	this.absolute_dialog.$msg.html('<p style="color:white; text-align:center; height:100%;"><span style="display:inline-block; height:100%; vertical-align:middle;"></span></p>');
	
	this.absolute_dialog.$root.append(this.absolute_dialog.$cover);
	this.absolute_dialog.$root.append(this.absolute_dialog.$msg_cover);
	this.absolute_dialog.$root.append(this.absolute_dialog.$msg);
	this.absolute_dialog.$msg.find('p').append(this.absolute_dialog.$msg_core);
	
	this.abs_d_init = function (msg,position){
		_this.absolute_dialog.$msg_cover.css('top',position-50);
		_this.absolute_dialog.$msg.css('top',position-50);
		_this.absolute_dialog.$msg_core.html(msg);
		
		return _this.absolute_dialog.$root;
	};
	
	this.abs_d_remove = function (){
		_this.absolute_dialog.$root.remove();
	};
	
	this.open = function (msg, position, time){
		
		var f = function(){
			_this.abs_d_remove();
		};
		
		//var rate = browserInnerWidth() / screen.width;
		//var viewport_height = rate * screen.height;
		
		this.opt.root.append(_this.abs_d_init(msg,position));//viewport_height/2+(cc.getTotalY() - cc.getViewportY())));
		this.opt.root.trigger('create');
		
		if(time!=null){
			if(time>0)
				setTimeout(f,time);
		}
		else if(_this.opt.autoCloseTerm>0)
			setTimeout(f,_this.opt.autoCloseTerm);
	};
	
	this.close = function(){
		_this.abs_d_remove();
	};
	
	//fd.open('부가정보',$(this).offset().top);
};
</script>