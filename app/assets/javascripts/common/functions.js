/**
 * Ready
 */
$().ready(function(){
	loadLib();
});
/*
 * 滚动事件
 */
$(window).scroll(function() {
	
});

/**
 * Dom变化需要重新载入，有什么好办法？
 */
function loadLib(){
	/**
	 * swipe 
	 */
	var bullets = $('#dots').find('li');
	for (var i=0; i<bullets.length; i++) {
		var elem = bullets[i];
		elem.setAttribute('data-tab', i);
		elem.onclick = function(){
			mySwipe.slide(parseInt(this.getAttribute('data-tab'), 10), 500);
		};
	}
	
	window.mySwipe = Swipe(document.getElementById('slider'), {
		startSlide: 0,
		speed: 500,
		auto: 5000,
		continuous: true,
		disableScroll: true,
		stopPropagation: false,
		callback: function(index, element) {
		  var i = bullets.length;
	      while (i--) {
	        bullets[i].className = '';
	      }
	      if (index >= bullets.length) {
	      	index = (index - 1) / 2;
	      	index = parseInt(String(index));
	      }
	      bullets[index].className = 'on';
		}, 
		transitionEnd: function(index, element) {}
	});
	
	/*
	 * headroom调用
	 */
	// $("#header").headroom();
	// 获取页面元素
	var myElement = document.getElementById("header");
	if(myElement != null){
        // 创建 Headroom 对象，将页面元素传递进去
        var headroom  = new Headroom(myElement,{
            tolerance : {
              up : 5,
              down : 5
            },
            offset : 0,
            classes : {
              pinned : 'slideInDown',
              unpinned : 'slideInUp',
              top : 'headroom--top',
              notTop : 'headroom--not-top',
              initial : 'headroom'
            }
          });
        // 初始化
        headroom.init(); 
	}
	
	//对日期选择器进行初始化配置
	$('.datepicker-input').datepicker({ autoclose: true , language: 'zh-CN', todayBtn: 'linked'});
	
};

/**
 * mmenu
 */
$().ready(function(){
	$(function() {
	    $('#navMenu').mmenu({
	         offCanvas: {
	            position: "right"
	         }
		});
	});
});

$(document).ready(function(){
	$('[data-toggle="tooltip"]').tooltip();
});

$(window).resize(function() { 
	//销毁提示框
	$('#phoneArea').tooltip('destroy');
	$('#validCodeArea').tooltip('destroy');
}); 


/**
 * Masonry
 */
/*$(function() {
	var container = document.querySelector('#masonry');
	if(container != null){
		var msnry = new Masonry( container, {
		  // options...
		  itemSelector: '.item'
		});
	}
});*/

/**
 * Pjax
 */
$(function() {
	$(document).pjax('a[data-pjax]', '#pjax-container');
	$(document).on('pjax:beforeSend', function() {
		$('.yl-loading').show();
	});
	$(document).on('pjax:complete', function() {
		loadLib();
		ngRefresh();
		$('.yl-loading').hide();
	});
	
 });
 // Refresh angular...
 var ngRefresh = function() {
    var scope = angular.element("body").scope();
    var compile = angular.element("body").injector().get('$compile');

    compile($("body").contents())(scope);
    scope.$apply();
};

 
//图片预览的功能
var previewImage = function(imgFile){
    YL.previewImg(imgFile, function(path, userAgent){
        $('#profile-head-img').attr('src',path);
        $('#messagePicture').attr('src',path);
        img = $(imgFile).next();
        img.attr('src',path);
    });
};

/**
 * 返回顶部
 */
$(window).scroll(function() {
	if($(document).scrollTop() > 1111){
		$('.back_to_top').fadeIn();
	}else{
		$('.back_to_top').fadeOut();
	}
});

scroll_number = -1;
function pageScroll(){
	scroll_number -= 10;
	window.scrollBy(0,scroll_number);
	scrolldelay = setTimeout('pageScroll()',11);
	if($(document).scrollTop() <= 0){
		scroll_number = -1;
		clearTimeout(scrolldelay);
	}
}

/**
 * 编辑页面表单验证
 */
var editValidate = function(isOverall){
	var flag = true;
	if( $('#fullNameInput').val().length == 0 && isOverall){
		$('#fullNameArea').tooltip('show');
		flag = false;
	}else{
		$('#fullNameArea').tooltip('destroy');
	}
	if( $('#nicknameInput').val().length == 0 && isOverall){
		$('#nicknameArea').tooltip('show');
		flag = false;
	}else{
		$('#nicknameArea').tooltip('destroy');
	}
	if ($('#user_sex_1').is(':checked') || $('#user_sex_0').is(':checked')) {
		$('#sexArea').tooltip('destroy');
	} else {
		$('#sexArea').tooltip('show');
		flag = false;
	}
	if( $('#birthdayInput').val().length == 0 && isOverall){
		$('#birthdayArea').tooltip('show');
		flag = false;
	}else{
		$('#birthdayArea').tooltip('destroy');
	}
	if( $('#addressInput').val().length == 0 && $('#companyInput').val().length == 0 && $('#clubInput').val().length == 0 && isOverall){
		$('#addressCheck').prop("checked",true);
		$('#addressInput').show();
		$('#companyCheck').prop("checked",true);
		$('#companyInput').show();
		$('#clubCheck').prop("checked",true);
		$('#clubInput').show();
		$('#addressArea').tooltip('show');
		$('#companyArea').tooltip('show');
		$('#clubArea').tooltip('show');
		flag = false;
	}else{
		$('#addressArea').tooltip('destroy');
		$('#companyArea').tooltip('destroy');
		$('#clubArea').tooltip('destroy');
	}
	if( !isNumber($('#tennisAgeInput').val())){
		$('#tennisAgeArea').tooltip('show');
		$("#tennisAgeInput").val("0");
		flag = false;
	}else{
		$('#tennisAgeArea').tooltip('destroy');
	}
	if ($('#user_is_coach_true').is(':checked') || $('#user_is_coach_false').is(':checked')) {
		$('#isCoachArea').tooltip('destroy');
	} else {
		$('#isCoachArea').tooltip('show');
		flag = false;
	}
	//判断文件大小
	var obj = document.getElementById('imgFile');
   	var fileLength = getFileLength(obj);
	if( fileLength>(512*1024) ){
		var mainBody = document.getElementById('edit-main-part');
		var alertItem = getAlertBox('图片超出大小，请重新选择图片！');
		$('#noticeArea').html(alertItem);
		flag = false;
	}
	return flag;
};
$(document).ready(function(){
	if ($('#addressInput').val() != null && $('#addressInput').val().length > 0) {
		$('#addressCheck').prop("checked",true);
		$('#addressInput').show();
	} 
	if ($('#companyInput').val() != null && $('#companyInput').val().length > 0) {
		$('#companyCheck').prop("checked",true);
		$('#companyInput').show();
	} 
	if ($('#clubInput').val() != null && $('#clubInput').val().length > 0) {
		$('#clubCheck').prop("checked",true);
		$('#clubInput').show();
	}
});
var registerValidate = function() {
	var flag = true;
	if( $('#fullNameInput').val().length == 0 ){
		$('#fullNameArea').tooltip('show');
		flag = false;
	}else{
		$('#fullNameArea').tooltip('destroy');
	}
	if( $('#nicknameInput').val().length == 0 ){
		$('#nicknameArea').tooltip('show');
		flag = false;
	}else{
		$('#nicknameArea').tooltip('destroy');
	}
	if ($('#user_sex_1').is(':checked') || $('#user_sex_0').is(':checked')) {
		$('#sexArea').tooltip('destroy');
	} else {
		$('#sexArea').tooltip('show');
		flag = false;
	}
	if( $('#birthdayInput').val().length == 0 ){
		$('#birthdayArea').tooltip('show');
		flag = false;
	}else{
		$('#birthdayArea').tooltip('destroy');
	}
	if( $('#phoneInput').val().length == 0 ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	if( !isMobiles($('#phoneInput').val()) ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	if( $('#validCodeInput').val().length ==0 ){
		$('#validCodeArea').tooltip('show');
		flag = false;
	}else{
		$('#validCodeArea').tooltip('destroy');
	}
	if( $('#addressInput').val().length == 0 && $('#companyInput').val().length == 0 && $('#clubInput').val().length == 0 ){
		$('#addressCheck').prop("checked",true);
		$('#addressInput').show();
		$('#companyCheck').prop("checked",true);
		$('#companyInput').show();
		$('#clubCheck').prop("checked",true);
		$('#clubInput').show();
		$('#addressArea').tooltip('show');
		$('#companyArea').tooltip('show');
		$('#clubArea').tooltip('show');
		flag = false;
	}else{
		$('#addressArea').tooltip('destroy');
		$('#companyArea').tooltip('destroy');
		$('#clubArea').tooltip('destroy');
	}
	if( !isNumber($('#tennisAgeInput').val())){
		$('#tennisAgeArea').tooltip('show');
		$("#tennisAgeInput").val("0");
		flag = false;
	}else{
		$('#tennisAgeArea').tooltip('destroy');
	}
	if ($('#user_is_coach_true').is(':checked') || $('#user_is_coach_false').is(':checked')) {
		$('#isCoachArea').tooltip('destroy');
	} else {
		$('#isCoachArea').tooltip('show');
		flag = false;
	}
	//判断文件大小
	var obj = document.getElementById('imgFile');
   	var fileLength = getFileLength(obj);
	if( fileLength>(512*1024) ){
		var mainBody = document.getElementById('edit-main-part');
		var alertItem = getAlertBox('图片超出大小，请重新选择图片！');
		$('#noticeArea').html(alertItem);
		flag = false;
	}else if (fileLength <= 0) {
		// var mainBody = document.getElementById('edit-main-part');
		// var alertItem = getAlertBox('请上传头像！');
		// $('#noticeArea').html(alertItem);
		// flag = false;
	}
	return flag;
};
/**
 * 一般会员注册验证
 */
var normalRegisterValidate = function() {
	var flag = true;
	if( $('#fullNameInput').val().length == 0 ){
		$('#fullNameArea').tooltip('show');
		flag = false;
	}else{
		$('#fullNameArea').tooltip('destroy');
	}
	if( $('#nicknameInput').val().length == 0 ){
		$('#nicknameArea').tooltip('show');
		flag = false;
	}else{
		$('#nicknameArea').tooltip('destroy');
	}
	if ($('#user_sex_1').is(':checked') || $('#user_sex_0').is(':checked')) {
		$('#sexArea').tooltip('destroy');
	} else {
		$('#sexArea').tooltip('show');
		flag = false;
	}
	if( $('#phoneInput').val().length == 0 ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	if( !isMobiles($('#phoneInput').val()) ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	if( $('#validCodeInput').val().length ==0 ){
		$('#validCodeArea').tooltip('show');
		flag = false;
	}else{
		$('#validCodeArea').tooltip('destroy');
	}
	//判断文件大小
	var obj = document.getElementById('imgFile');
   	var fileLength = getFileLength(obj);
	if( fileLength>(512*1024) ){
		var mainBody = document.getElementById('edit-main-part');
		var alertItem = getAlertBox('图片超出大小，请重新选择图片！');
		$('#noticeArea').html(alertItem);
		flag = false;
	}else if (fileLength <= 0) {
		// var mainBody = document.getElementById('edit-main-part');
		// var alertItem = getAlertBox('请上传头像！');
		// $('#noticeArea').html(alertItem);
		// flag = false;
	}
	return flag;
};
/**
 * 填写居住地址checkbox监听
 */
var addressCheckClick = function () {
	if($('#addressCheck').is(':checked')) {
		$('#addressInput').show();
	} else {
		$('#addressInput').hide();
		$("#addressInput").val("");
		$('#addressArea').tooltip('destroy');
	}
};
/**
 * 填写公司checkbox监听
 */
var companyCheckClick = function () {
	if($('#companyCheck').is(':checked')) {
		$('#companyInput').show();
	} else {
		$('#companyInput').hide();
		$("#companyInput").val("");
		$('#companyArea').tooltip('destroy');
	}
};
/**
 * 填写俱乐部checkbox监听
 */
var clubCheckClick = function () {
	if($('#clubCheck').is(':checked')) {
		$('#clubInput').show();
	} else {
		$('#clubInput').hide();
		$("#clubInput").val("");
		$('#clubArea').tooltip('destroy');
	}
};
/**
 * 俱乐部注册校验
 */
var registerClubValidate = function() {
	var flag = true;
	if( $('#nameInput').val().length == 0 ){
		$('#nameArea').tooltip('show');
		flag = false;
	}else{
		$('#nameArea').tooltip('destroy');
	}
	if( $('#introductionInput').val().length == 0 ){
		$('#introductionArea').tooltip('show');
		flag = false;
	}else{
		$('#introductionArea').tooltip('destroy');
	}
	if( $('#fieldInput').val().length == 0 ){
		$('#fieldArea').tooltip('show');
		flag = false;
	}else{
		$('#fieldArea').tooltip('destroy');
	}
	if( $('#membershipInput').val().length == 0 ){
		$('#membershipArea').tooltip('show');
		flag = false;
	}else{
		$('#membershipArea').tooltip('destroy');
	}
	if( $('#phoneInput').val().length ==0 ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	//判断文件大小
	var obj = document.getElementById('imgFile');
   	var fileLength = getFileLength(obj);
	if( fileLength>(512*1024) ){
		var mainBody = document.getElementById('edit-main-part');
		var alertItem = getAlertBox('图片超出大小，请重新选择图片！');
		$('#noticeArea').html(alertItem);
		flag = false;
	}else if (fileLength <= 0) {
		var mainBody = document.getElementById('edit-main-part');
		var alertItem = getAlertBox('请上传俱乐部会徽！');
		$('#noticeArea').html(alertItem);
		flag = false;
	}
	return flag;
};

/**
 *发帖页面的验证 
 */
var messageUploadValidate = function(){
	var obj = document.getElementById('imgFile');
	var fileLength = getFileLength(obj);
	
	if( $('#body').val() == "" || $('#body').val() == null ){
		var alertItem = getAlertBox('请输入您要发布的内容！');
		$('#noticeArea').html(alertItem);
		return false;
	}
	
	if( $('#body').val().length > 255 ){
		var alertItem = getAlertBox('内容不能超过255个字！');
		$('#noticeArea').html(alertItem);
		return false;
	}
	
	if( fileLength > (5*1024*1024) ){
		var mainBody = document.getElementById('edit-main-part');
		var alertItem = getAlertBox('图片超出大小，请重新选择图片！');
		$('#noticeArea').html(alertItem);
		return false;
	}
	
	//$('#submit').attr('disabled', true);
	$('#submit').css('display','none');
	return true;
};

/*
 * 登录页面的js
 */
var getValidCode = function(){
	var phoneNumber = $('#phoneInput').val();
	if(phoneNumber == "" || phoneNumber == null){
		$('#phoneArea').tooltip('show');
	}else if( !isMobiles(phoneNumber)){
		$('#phoneArea').tooltip('show');
	}else{
		countDown();//开始计时
		$.ajax({
			url: '/users/get_valid_code',
			type: 'POST',
			data: {
				phone: phoneNumber,
			},
			dataType:'json',
			success: function(data){
				if( data.response == "1"){
					$('#noticeArea').html(getSuccessBox(data.msg));
				}else{
					$('#noticeArea').html(getAlertBox(data.msg));
				}
			},
			error:{
			},	
		});
	}
};
/**
 * 修改新手机号验证码
 */
var getValidCodeByNewPhone = function(){
	var phoneNumber = $('#phoneInput').val();
	if(phoneNumber == "" || phoneNumber == null){
		$('#phoneArea').tooltip('show');
	}else if( !isMobiles(phoneNumber)){
		$('#phoneArea').tooltip('show');
	}else{
		countDown();//开始计时
		$.ajax({
			url: '/users/get_valid_code_by_new_phone',
			type: 'POST',
			data: {
				new_phone: phoneNumber,
			},
			dataType:'json',
			success: function(data){
				if( data.response == "1"){
					$('#noticeArea').html(getSuccessBox(data.msg));
				}else{
					$('#noticeArea').html(getAlertBox(data.msg));
				}
			},
			error:{
			},	
		});
	}
};

//计时函数
var secs = 60;
var countDown = function(){
	if( secs == 60 ){//禁用获取按钮
		$('#countDownBtn').attr('disabled','disabled');
	}
	document.getElementById("countDownBtn").innerHTML = secs + 's';
	if(secs > 0){
		secs--;
		window.setTimeout("countDown("+ secs +")", 1000);
	}else{
		document.getElementById("countDownBtn").innerHTML = '获取';
		secs = 60;//重置时间取消禁用
		$('#countDownBtn').removeAttr('disabled');
	}
};

/**
 *登录页面的js验证 
 */
var signInValidate = function(){
	var flag = true;
	if( $('#phoneInput').val().length == 0 ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	if( !isMobiles($('#phoneInput').val()) ){
		$('#phoneArea').tooltip('show');
		flag = false;
	}else{
		$('#phoneArea').tooltip('destroy');
	}
	
	if( $('#validCodeInput').val().length ==0 ){
		$('#validCodeArea').tooltip('show');
		flag = false;
	}else{
		$('#validCodeArea').tooltip('destroy');
	}
	
	return flag;
};

/*
 * 获取文件大小  单位bytes
 */
var getFileLength = function(obj){
	var objValue = obj.value;  
    var fileLength = -1;  
    if (objValue=="") return fileLength;  
    try{  
        //对于非IE获得要上传文件的大小  
         fileLength=parseInt(obj.files[0].size);
    }catch (e) {  
        fileLength=-1;  
	}
	return fileLength;
};

/**
 *获取AlertBox
 */

var getAlertBox = function(message){
	var alertItem = '<div class="info-box alert-danger fade in"><a href="#" class="close" data-dismiss="alert">&times;</a><span>' + message + '</span></div>';
	return alertItem;
};
var getSuccessBox = function(message){
	var alertItem = '<div class="info-box alert-success fade in"><a href="#" class="close" data-dismiss="alert">&times;</a><span>' + message + '</span></div>';
	return alertItem;
};
/**
 * 电话号码验证
 */
var isMobiles = function (str) {
    //验证手机号
    var numberPat = /^((\+86)|(86))?(1)\d{10}?$/;
    return numberPat.test(str);
};
/**
 * 数字验证
 */
var isNumber = function (str) {
    //验证手机号
    var numberPat = /[0-9]|\./;
    return numberPat.test(str);
};

/**
 * 首页获取互动消息
 */
var homeMessagePageNo = 0;
var hasMore = true ;
var getMessages = function(){
	$('.yl-loading').show();
	$.ajax({
		url: '/messages/get_messages_by_size',
		type: 'POST',
		data: {
			page: homeMessagePageNo,
			pageSize: 5, //这里设置主页获取消息的每页大小
			offset: 20 //首页初始化的时候已经有20条消息
		},
		dataType:'json',
		headers: {
			'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
		},
		success: function(data){
			if(data.messages.length != 0){
				for( var i = 0; i < data.messages.length; i++){
					addAMessage(data.messages[i]);
				}
				homeMessagePageNo++;
			}else{
				hasMore = false;
				// $('#moreBtn').html('没有更多');
				// $('#moreBtn').attr('onclick','');
			}
			
			$('.yl-loading').hide();
		},
		error:{
		},
	
	});
};

var addAMessage = function(message){
	var str = '';
	str += '<div class="friend-module bounceInLeft">';
	str += '<div class="friend-module-image">';
	if (message.message_images_first_url != null){
		str += '<image src="' + message.message_images_first_url + '" onerror="this.src=\'/assets/default.png\'" >';
	}else{
		str += '<div class="default-row"></div>';
	}
	str += '</div>';
	str += '<div class="pull-left friend-module-picture">';
	if(message.user.profile_picture_url != "" || message.user.profile_picture_url != null){
		str += '<img src="'+ message.user.profile_picture_url +'">';
	}else{
		str += '<img src="default_head.png">';
	}
	str += '</div>';
	str += '<div class="pull-left friend-module-name" title="'+ message.user.full_name +'">'+ message.user.full_name +'</div>';
	str += '<div class="pull-left friend-module-club"></div>';
	str += '<div class="pull-right friend-module-time">'+ message.create_time_show +'</div>';
	str += '<div class="clearfix"></div>';
	str += '<div class="friend-module-sum">'+ message.body +'</div>';
	str += '</div>';
	str += '<div class="clearfix"></div>';
	//$(str).insertBefore('#moreBtn');
	$('#home-friend-module-container').append(str);
};

//添加删除图片
function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).before(content.replace(regexp, new_id));
}
var ageLimitChange = function(show) {
	if (show) {
		$('#age_form').show();
	} else {
		$('#age_form').hide();
	}
};
function delayURL(url) {
    var delay = document.getElementById("time").innerHTML;
    if (delay > 0) {
        delay--;
        document.getElementById("time").innerHTML = delay
    } else {
        window.top.location.href = url
    }
    setTimeout("delayURL('" + url + "')", 1000)
}

var playerSelectClick = function(input) {
	$('#present_selected_input').val("player_input_" + $(input).attr("input-id"));
	$('#present_selected_id_input').val("player_id_input_" + $(input).attr("input-id"));
	$("#players_search_input").val("");
	getUsers();
}

var addPlayer = function (player_li) {
  var input = $('#present_selected_input').val();
  var idInput = $('#present_selected_id_input').val();
  var name = $(player_li).html();
  var id = $(player_li).val();
  $('#' + input).val(name);
  $('#' + idInput).val(id);
}

var getUsers = function(){
	var content = $('#players_search_input').val();
	$.ajax({
		url: '/users/search_users',
		type: 'POST',
		data: {
			search_content: content
		},
		dataType:'json',
		headers: {
			'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
		},
		success: function(data){
			$("#players_list").html("");
			if(data.length != 0){
				for( var i = 0; i < data.length; i++){
					addUser(data[i]);
				}
			}
		},
		error:{
		},
	
	});
};

var addUser = function(user){
	/*<li value="17" onclick="addPlayer(this);" data-dismiss="modal" aria-hidden="true">文超</li>*/
	var str = '';
	str += '<li value="' + user.id + '"';
	str += ' onclick="addPlayer(this);" data-dismiss="modal" aria-hidden="true">';
	str += user.full_name;
	if (user.phone != null && user.phone.length > 6) {
		str += '(' + user.phone.substring(0, 3) + '****' + user.phone.substring(7, user.phone.length) +  ')';
	}
	str += '</li>';
	$('#players_list').append(str);
};