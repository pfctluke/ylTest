/*!
 * YL-lib v1.0.0 (http://www.icitymobile.com)
 * Author: Luke, Gary, Eva
 */
var YL = {};

/**
 * 只能输入数字 
 * $('input').onlyNum();
 * 去掉注释则加入class="only-num"即可
 */
$.fn.onlyNum = function () {
    $(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 48 && keyCode <= 57) || keyCode == 8)
            return true;
        else
            return false;
    }).focus(function () {
    //禁用输入法
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
    //获取剪切板的内容
        var clipboard = window.clipboardData.getData("Text");
        if (/^\d+$/.test(clipboard))
            return true;
        else
            return false;
    });
};
// $().ready(function(){
	// $('.only-num').onlyNum();
// });

/**
 * 只能输入字母
 * $('input').onlyLetter();
 * 去掉注释则加入class="only-letter"即可
 */
$.fn.onlyLetter = function () {
    $(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122) || keyCode == 8)
            return true;
        else
            return false;
    }).focus(function () {
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
        var clipboard = window.clipboardData.getData("Text");
        if (/^[a-zA-Z]+$/.test(clipboard))
            return true;
        else
            return false;
    });
};
// $().ready(function(){
	// $('.only-letter').onlyLetter();
// });

/**
 * 只能输入数字和字母
 * $('input').onlyNumLetter();
 * 去掉注释则加入class="only-num-letter"即可
 */
$.fn.onlyNumLetter = function () {
    $(this).keypress(function (event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode >= 48 && keyCode <= 57) || (keyCode >= 65 && keyCode <= 90) || (keyCode >= 97 && keyCode <= 122) || keyCode == 8)
            return true;
        else
            return false;
    }).focus(function () {
        this.style.imeMode = 'disabled';
    }).bind("paste", function () {
        var clipboard = window.clipboardData.getData("Text");
        if (/^(\d|[a-zA-Z])+$/.test(clipboard))
            return true;
        else
            return false;
    });
};// $().ready(function(){
	// $('.only-num-letter').onlyNumLetter();
// });

/**
 * 避免重复提交表单
 * 提交表单时，点击提交按钮后，按钮变disabled，提交成功即离开页面时恢复原状去掉disabled
 * 用法 增加class “.single-click”
 */
$(function() {
	$('.single-click').click(function(){
		$(this).attr('disabled', true);
	});
 });
 $(window).unload(function(){return $('.single-click').attr('disabled', false);});
 
/**
 * 图片预览
 * imgFile: 图片; successFn: 读取文件后执行的函数，返回path和userAgent; exErrorFn: 文件格式错误执行的函数;
 */
YL.previewImg = function(imgFile, successFn, exErrorFn){
    var filextension=imgFile.value.substring(imgFile.value.lastIndexOf("."),imgFile.value.length);
    filextension=filextension.toLowerCase();
    if ((filextension!='.jpg')&&(filextension!='.gif')&&(filextension!='.jpeg')&&(filextension!='.png')&&(filextension!='.bmp')){
        if(exErrorFn == null){
            alert("Sorry, the website only supports images with standard format. Please change the format before uploading. Thank you!");
            imgFile.focus();
        }else{
            exErrorFn();
        }
    }else{
        var userAgent = window.navigator.userAgent.toLowerCase();
        var path=window.URL.createObjectURL(imgFile.files[0]);// FF 7.0以上
        if(successFn != null){
            successFn(path, userAgent);
        }
        $('#profile-head-img').attr('src',path);
        $('#messagePicture').attr('src',path);
        img = $(imgFile).next();
        img.attr('src',path);
    }
};
