<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath() + "/";

	//阶段及其对应的可能性
	Map<String,String> pMap = (Map<String, String>) application.getAttribute("pMap");

	Set<String> set = pMap.keySet();


%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

	<script>

		//处理阶段和对应可能性的json
		var json = {

			<%
				for (String key : set) {

					String value = pMap.get(key);

			%>
				"<%=key%>" : <%=value%>, //此处的逗号不用自己处理，已经是json格式了，会自动屏蔽
			<%
				}
			%>

		};

		$(function () {

			$("#create-customerName").typeahead({
				source: function (query, process) {
					$.get(
							"workbench/transaction/getCustomerName.do",
							{ "name" : query },
							function (data) {
								//alert(data);
								/*
									data
										[{客户名称1},{2},{3}]
								 */

								process(data);
							},
							"json"
					);
				},
				//延迟加载的时间
				delay: 500
			});

			$(".time1").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "bottom-left"
			});

			$(".time2").datetimepicker({
				minView: "month",
				language:  'zh-CN',
				format: 'yyyy-mm-dd',
				autoclose: true,
				todayBtn: true,
				pickerPosition: "top-left"
			});

			//为放大镜图标，绑定事件，打开搜索市场活动的窗口
			$("#openSearchModalBtn").click(function () {

				$("#searchActivityModal").modal("show");

			});
			//为放大镜图标，绑定事件，打开搜索市场活动的窗口
			$("#openSearchContactsModalBtn").click(function () {

				$("#searchContactsModal").modal("show");

			});

			//为搜索操作模态窗口的搜索框绑定事件，执行搜索并展现市场活动列表的操作
			$("#aname").keydown(function (event) {

				if (event.keyCode == 13) {

					$.ajax({
						url: "workbench/clue/getActivityListByName.do",
						data: {
							"aname": $.trim($("#aname").val())
						},
						type: "get",
						dataType: "json",
						success: function (data) {
							/*
                                data:[{市场活动1},{市场活动2},{市场活动3}]
                             */
							var html = "";

							$.each(data, function (i, n) {

								html += '<tr>';
								html += '<td><input type="radio" name="xz" value="' + n.id + '"/></td> ';
								html += '<td id="' + n.id + '">' + n.name + '</td>';
								html += '<td>' + n.startDate + '</td>';
								html += '<td>' + n.endDate + '</td>';
								html += '<td>' + n.owner + '</td>';
								html += '</tr>';

							})

							$("#activitySearchBody").html(html);
						}
					});

					//按下回车不关闭窗口(默认是关闭)
					return false;
				}

			});

			//执行搜索并展现联系人列表的操作
			$("#cname").keydown(function (event) {

				if (event.keyCode == 13) {

					$.ajax({
						url: "workbench/transaction/getContactsListByName.do",
						data: {
							"cname": $.trim($("#cname").val())
						},
						type: "get",
						dataType: "json",
						success: function (data) {
							/*
                                data:[{联系人1},{联系人2},{联系人3}]
                             */
							var html = "";

							$.each(data, function (i, n) {

								html += '<tr>';
								html += '<td><input type="radio" name="cxz" value="'+n.id+'"/></td> ';
								html += '<td id="'+n.id+'">'+n.fullname+'</td>';
								html += '<td>'+n.email+'</td>';
								html += '<td>'+n.mphone+'</td>';
								html += '</tr>';

							})

							$("#contactsSearchBody").html(html);
						}
					});

					//按下回车不关闭窗口(默认是关闭)
					return false;
				}

			});

			//为提交市场活动按钮绑定事件，填充市场活动源（填写两项信息 名字+id）
			$("#submitActivityBtn").click(function () {

				//获取选中市场活动的id
				var $xz = $("input[name=xz]:checked");
				var id = $xz.val();

				//取得市场活动的名字
				var name = $("#"+id).html();

				//将信息填入交易表单的市场源中
				$("#activityId").val(id);
				$("#activityName").val(name);

				//将搜索框清空
				$("#aname").val("");

				//将搜索到的内容清空
				$("#activitySearchBody").html("");

				//将模态窗口关闭
				$("#searchActivityModal").modal("hide");

			});

			//为提交联系人按钮绑定事件
			$("#submitContactsBtn").click(function () {

				//获取选中市场活动的id
				var $xz = $("input[name=cxz]:checked");
				var id = $xz.val();

				//取得市场活动的名字
				var name = $("#"+id).html();

				//将信息填入交易表单的市场源中
				$("#contactsId").val(id);
				$("#contactsName").val(name);

				//将搜索框清空
				$("#cname").val("");

				//将搜索到的内容清空
				$("#contactsSearchBody").html("");

				//将模态窗口关闭
				$("#searchContactsModal").modal("hide");

			});


			//为阶段的下拉框，绑定选中下拉框事件，根据选中阶段，绑定阶段填写可能性
			$("#create-stage").change(function () {

				//取得选中的阶段
				var stage = $("#create-stage").val();

				/*
					我们现在以json.key的形式不能取得value因为今天的stage是一个可变的变量
					如果是这样的key，那么我们就不能以传统的json.key的形式来取值我们要使用的取值方式为
					json[ key]
				*/
				var possibility = json[stage];

				$("#create-possibility").val(possibility);
			})

		})

	</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="searchActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="aname" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitActivityBtn">提交</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="searchContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="cname" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsSearchBody">
							<%--<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="submitContactsBtn">提交</button>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
					<option></option>
				  <c:forEach items="${uList}" var="u">
					  <option value="${u.id}" ${user.id eq u.id ? "selected" : ""}>${u.name}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-stage">
			  	<option></option>
			  	<c:forEach items="${stageList}" var="s">
					<option value="${s.value}">${s.text}</option>
				</c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
					<c:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
					<c:forEach items="${sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="activityName">
				<input type="hidden" id="activityId" name="activityId"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="openSearchContactsModalBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="contactsName">
				<input type="hidden" id="contactsId" name="contactsId"/>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-describe"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time2" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>