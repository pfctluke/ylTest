/**
 * 大众网球首页
 * @param {Object} $scope
 */
tennisModule.controller('homeController', ['$scope', '$element', '$http',
  function($scope, $element, $http) {
	//Todo
	$scope.changeHref = function(url){
		window.location.href=url;
	};
}]);

/**
 * 帖子列表页面
 * @param {Object} $scope
 */
tennisModule.controller('messageController', ['$scope', '$element', '$http',
  function($scope, $element, $http) {
  	//页面变量
	$scope.messages = new Array();
	$scope.page = 0;
	$scope.isLoading = false;
	$scope.hasMore = true;

	//请求获得数据
	/*$scope.loadItem = function(){
		$scope.isLoading = true;
		$.ajax( {    
		    url: '/messages/get_messages',
		    data:{
				page: $scope.page
			},    
		    type:'post',    
		    dataType:'json',    
		    success:function(data) {    
		        $.each(data.messages, function(index, val){
					$scope.messages.push(val);
					console.log($scope.messages);
				});
				$scope.$watch('messages', function(newValue, oldValue) {  
					$scope.addItem();
					setTimeout($scope.addPage(),1000);
				}); 
		     },    
		     error : function() {    
		     	console.log('error');
				$scope.isLoading = false;
		     }    
		});
	};*/
	$scope.loadItem = function(){
		$('.yl-loading').show();
		$scope.isLoading = true;
		$http({
			method: 'POST',
			url: '/messages/get_messages',
			data: {
				page: $scope.page
			},
			headers: {
				'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
			}
		}).success(function(data, status) {
			$.each(data.messages, function(index, val){
				$scope.messages.push(val);
			});
			$scope.$watch('messages', function(newValue, oldValue) {  
				$scope.addItem();
			});
			if (data.messages.length < 1) {
				$scope.hasMore = false;
				$('.yl-loading').hide();
			}; 
		}).error(function(data, status) {
			console.log('error');
			$scope.isLoading = false;
		});
	};
	
	//加入到Masonry
	$scope.addItem = function(){
		$('#masonry').masonry( 'on', 'layoutComplete', function() {
			$scope.addPage();
			$('.yl-loading').hide();
		});
		$('#masonry').imagesLoaded(function(){
			elements = masonry.find('.item:not(.md)');
			elements.each(function(){
				$(this).removeClass('hide').addClass('md');
			});
			masonry.masonry('appended', elements);
			
		});
	};
	
	// 当滚动到最底部以上100像素时， 加载新内容  
	$(window).scroll(function(){  
	    if ($(document).height() - $(this).scrollTop() - $(this).height()<10 && $scope.hasMore){
	    	if(!$scope.isLoading){
	    		$scope.loadItem();
	    	}
	    }
	});  
	
	$scope.addPage = function(){
		$scope.page ++;
		$scope.isLoading = false;
	};
	
}]);

//球友互动发帖页面
tennisModule.controller('messageUploadController', ['$scope', '$element', '$http',
  function($scope, $element, $http) {
	//Todo
	$scope.maxLength = 255;
}]);

//登录页面的angular controller
tennisModule.controller('loginController', ['$scope', '$element', '$http',
  function($scope, $element, $http) {
	//Todo
	// $scope.currentValidCode = '';
	// $scope.secs = 60 ;
// 	
	// //获取验证码的validCode
	// $scope.getValidCode = function(){
// 		
		// if($scope.phoneNumber == "" || $scope.phoneNumber == null){
			// $('#phoneArea').tooltip('show');
		// }else if( !$scope.isMobiles($scope.phoneNumber)){
			// $('#phoneArea').tooltip('show');
		// }else{
// 			
			// countDown();
// 			
			// $('#phoneArea').tooltip('destroy');
			// $http({
				// method: 'POST',
				// url: '/users/get_valid_code',
				// data: {
					// phone: $scope.phoneNumber
				// }
			// }).success(function(data, status) {
				// $scope.currentValidCode = data.valid_code;
			// }).error(function(data, status) {
				// console.log('error');
			// });
		// }
	// };
// 	
	// //倒计时
	// var secs = 60;
	// var countDown = function(){
		// document.getElementById("countDownBtn").innerHTML= secs+'s';
		// if(secs > 0){
			// secs--;
			// //window.setTimeout("countDown()", 1000);
			// $scope.timeout(countDown(),1000);
		// }else{
// 			
		// }
	// };
// 	
	// //电话号码验证
	// $scope.isMobiles = function (str) {
        // //验证手机号
        // var numberPat = /^(13[0-9]|15[0|1|2|3|5|6|7|8|9]|18[0|2|5|6|7|8|9])\d{8}$/;
        // return numberPat.test(str);
    // };
// 	
	// //提交前进行验证
	// $scope.beforeSubmit = function(){
		// return false;
	// };
	
	
}]);

//编辑个人信息页面
tennisModule.controller('editProfileController', ['$scope', '$element', '$http',
  function($scope, $element, $http) {
	//Todo
	$scope.maxLength = 255;
	
	
}]);
