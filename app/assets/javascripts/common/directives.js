//加载Masonry
tennisModule.directive('masonry', function ($parse) {
    return {
        link: function ($scope, $elem, $attrs) {  
        	$('#masonry').imagesLoaded(function(){
	        	setTimeout(function(){ 
		            $(window).scrollTop(0);
		            masonry = $elem.masonry({
		                itemSelector : ".item",
						columnWidth: 1,
		            });
		            $scope.loadItem();
	        	},100);
        	});
        }
    };        
});
