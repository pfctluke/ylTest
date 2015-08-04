$().ready(function(){
   LoadAdminLibs(); 
});

function LoadAdminLibs(){
    $('#sidebar-collapse').click(function(){
        $('#sidebar').toggleClass('menu-compact');
        $('#sidebar-collapse').toggleClass('active');
    });
    
    //后台用来选择左侧 以及右侧的标题变更
	var type = $('#admin-container').data('type');
	var typeString = "";//类型对应的中文字符串
	var typeUrl = "#";
	switch(type){
		case "users":
			typeString = "用户管理";
			typeUrl = "/admin/users";
			break;
		case "news":
			typeString = "新闻管理";
			typeUrl = "/admin/news";
			break;
		case "carousels":
            typeString = "头图管理";
            typeUrl = "/admin/carousels";
		    break;
		case "messages":
			typeString = "帖子管理";
			typeUrl = "/admin/messages";
		    break;
		case "topics":
			typeString = "专题管理";
			typeUrl = "/admin/topics";
			break;
		case "topic_news":
			typeString = "专题新闻管理";
			var id = $('#admin-container').data('id');
			typeUrl = "/admin/topics/" + id + "/topic_news";
			$('#admin-right-sub-title-2').html(typeString);
			$('#admin-right-sub-title-2').attr("href",typeUrl);
			$('#admin-right-sub-title-li-2').show();
			typeString = "专题管理";
			typeUrl = "/admin/topics";
			type = "topics";
			break;
		case "clubs":
			typeString = "俱乐部管理";
			typeUrl = "/admin/clubs";
			break;
		case "venues":
			typeString = "场馆管理";
			typeUrl = "/admin/venues";
			break;
		case "competitions":
			typeString = "赛事管理";
			typeUrl = "/admin/competitions";
			break;
		case "items":
			typeString = "赛事项目管理";
			var id = $('#admin-container').data('id');
			typeUrl = "/admin/competitions/" + id + "/items";
			$('#admin-right-sub-title-2').html(typeString);
			$('#admin-right-sub-title-2').attr("href",typeUrl);
			$('#admin-right-sub-title-li-2').show();
			typeString = "赛事管理";
			typeUrl = "/admin/competitions";
			type = "competitions";
			break;
		case "orders":
			typeString = "订单管理";
			typeUrl = "/admin/orders";
			break;
		case "units":
			typeString = "赛事项目管理";
			var id = $('#admin-container').data('id');
			typeUrl = "/admin/competitions/" + id + "/items";
			$('#admin-right-sub-title-2').html(typeString);
			$('#admin-right-sub-title-2').attr("href",typeUrl);
			$('#admin-right-sub-title-li-2').show();
			typeString = "赛事管理";
			typeUrl = "/admin/competitions";
			type = "competitions";
			break;
		case "teams":
			typeString = "赛事管理";
			typeUrl = "/admin/competitions";
			type = "competitions";
			break;
		case "team_show":
			typeString = "参赛队伍管理";
			var id = $('#admin-container').data('id');
			typeUrl = "/admin/competitions/" + id + "/team_list";
			$('#admin-right-sub-title-2').html(typeString);
			$('#admin-right-sub-title-2').attr("href",typeUrl);
			$('#admin-right-sub-title-li-2').show();
			typeString = "赛事管理";
			typeUrl = "/admin/competitions";
			type = "competitions";
			break;
	}
	$('#admin-right-sub-title-1').html(typeString);
	$('#admin-right-sub-title-1').attr("href",typeUrl);
	if(type != null && type != ""){
		$('#'+ type).addClass('active');
	}
}
