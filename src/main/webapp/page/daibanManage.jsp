<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>待办任务管理</title>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/themes/icon.css">
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/static/jquery-easyui-1.3.3/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
        /*var url;
         function searchTask(){
         $("#dg").datagrid('load',{
         "s_name":$("#s_name").val()
         });
         }
         function formatAction(val,row){   //{pageContext.request.contextPath}
         return "<a href='javascript:openFinishTaskTab("+row.id+")'>办理任务</a>&nbsp;<a target='_blank' href='$/task/showCurrentView.action?taskId="+row.id+"'>查看当前流程图</a>"
         }
         function openFinishTaskTab(taskId){
         $.post("/task/redirectPage.action",{taskId:taskId},function(result){
         window.parent.openTab('办理任务',result.url+"?taskId="+taskId,'icon-check');
         },"json");
         }
         $('#pg').propertygrid({
         url: 'get_data',
         showGroup: true,
         scrollbarSize: 0
         });*/
        function al(id) {
            alert(id);
        }
        $(function () {
            var editRow = undefined;
            $('#bg').datagrid({
                title: '',
                loadMsg: "数据加载中，请稍后……",
                collapsible: true,
                singleSelect: false,
                selectOnCheck: false,
                checkOnSelect: false,
                pageSize: 5,
                pageList: [2, 5, 10, 20],
                url: '${pageContext.request.contextPath}/getTeacherLists',
                sortName: 'RoleSort',
                sortOrder: 'asc',

                pagination: true,
                beforePageText: '第',//页数文本框前显示的汉字 
                afterPageText: '页    共 {total} 页',
                displayMsg: '第{from}到{pages}条，共{pages}条',
                frozenColumns: [[
                    {field: 'ck', checkbox: true, width: fixWidth(0.3)},
                    {title: '编号', field: 'id', width: fixWidth(0.3), align: 'center', sortable: true}
                ]],
                columns: [[
                    {title: '角色编码', field: 'name', width: fixWidth(0.3), align: 'center', sortable: true},
                    /*  {field: 'userName', title: '用户名称', width: 120, align: 'center', sortable: true},
                     {field: 'gender', title: '用户性别', width: 80, align: 'center', sortable: true},
                     {field: 'birthday', title: '出生日期', width: 80, align: 'center', sortable: true},
                     {field: 'address', title: '地址', width: 80, align: 'center', sortable: true},
                     {field: 'phone', title: '手机号', width: 80, align: 'center', sortable: true},
                     {field: 'creationDate', title: '创建时间', width: 80, align: 'center', sortable: true},*/
                    {
                        field: 'opt', title: '操作', width: fixWidth(0.25), align: 'center',
                        formatter: function (value, rec) {
                            //  alert(rec.id);
                            return '<span style="color:red" onclick="al(+1+)">查看计划</span>';
                        }
                    }
                ]], onLoadSuccess: function () {
                    $('.datagrid-toolbar').append($('#txtSearch'));
                    $('#txtSearch').show();
                },
                toolbar: [
                    {
                        id: 'add',
                        text: '添加',
                        iconCls: 'icon-add',
                        handler: function () {
                            open1();
                        }
                    }, {
                        id: 'cut',
                        text: '删除',
                        iconCls: 'icon-cut',
                        handler: function () {
                            var codes = getSelections();
                            //  alert('codes' + getSelections());
                            if (codes == '') {
                                $.messager.alert('提示消息', '请选择要删除的数据！', 'info');
                            } else {
                                $.messager.confirm('提示消息', '确定要删除所选数据吗？', function (r) {
                                    if (r) {
                                        $.ajax({
                                            url: '${pageContext.request.contextPath}/delUser?codes=' + codes,
                                            type: 'post',
                                            dataType: 'text',
                                            success: function (returnValue) {
                                                if (returnValue) {
                                                    // alert('yes');
                                                    $('#bg').datagrid('reload');
                                                    $('#bg').datagrid('clearSelections');
                                                }
                                            }
                                        });
                                    }
                                });
                            }
                        }
                    }, '-',
                    {
                        id: 'btnSearch',
                        text: '搜索',
                        iconCls: 'icon-search',
                        handler: function () {
                            $('#bg').datagrid('options').url = '${pageContext.request.contextPath}/searchUserInfo?search=' + $('#txtSearch').val();
                            $('#bg').datagrid("reload");
                            $('#bg').datagrid("getPager").pagination({

                                beforePageText: '第',//页数文本框前显示的汉字 
                                afterPageText: '页    共 {pages} 页',
                                displayMsg: '第{from}到{to}条，共{total}条'
                            });
                        }
                    }, '-',
                    {
                        text: '修改', iconCls: 'icon-edit', handler: function () {
                        //修改时要获取选择到的行
                        var rows = $('#bg').datagrid("getSelections");
                        //如果只选择了一行则可以进行修改，否则不操作
                        if (rows.length == 1) {
                            //修改之前先关闭已经开启的编辑行，当调用endEdit该方法时会触发onAfterEdit事件
                            if (editRow != undefined) {
                                $('#bg').datagrid("endEdit", editRow);
                            }
                            //当无编辑行时
                            if (editRow == undefined) {
                                //获取到当前选择行的下标
                                var index = $('#bg').datagrid("getRowIndex", rows[0]);
                                //开启编辑
                                $('#bg').datagrid("beginEdit", index);
                                //把当前开启编辑的行赋值给全局变量editRow
                                editRow = index;
                                //当开启了当前选择行的编辑状态之后，
                                //应该取消当前列表的所有选择行，要不然双击之后无法再选择其他行进行编辑
                                $('#bg').datagrid("unselectAll");
                            }
                        }
                    }
                    }, '-',
                    {
                        text: '保存', iconCls: 'icon-save', handler: function () {
                        //保存时结束当前编辑的行，自动触发onAfterEdit事件如果要与后台交互可将数据通过Ajax提交后台
                        $('#bg').datagrid("endEdit", editRow);
                    }
                    }, '-',
                    {
                        text: '取消编辑', iconCls: 'icon-redo', handler: function () {
                        //取消当前编辑行把当前编辑行罢undefined回滚改变的数据,取消选择的行
                        editRow = undefined;
                        $('#bg').datagrid("rejectChanges");
                        $('#bg').datagrid("unselectAll");
                    }
                    }, '-'],
                onAfterEdit: function (rowIndex, rowData, changes) {
                    //endEdit该方法触发此事件
                    console.info(rowData);
                    editRow = undefined;
                },
                onDblClickRow: function (rowIndex, rowData) {
                    //双击开启编辑行
                    if (editRow != undefined) {
                        $('#bg').datagrid("endEdit", editRow);
                    }
                    if (editRow == undefined) {
                        $('#bg').datagrid("beginEdit", rowIndex);
                        editRow = rowIndex;
                    }
                },
                onSelect: function (rowIndex, rowData) {
                    alert("id" + rowData.id);
                    $('#bg').datagrid("unselectAll");




                    $('#intra_Group_dialogtable').datagrid({
                        striped: true,
                        url: '/lendauthorizgroupAction?tid=' + rowData.id,
                        iconCls: "icon-add",
                        fitColumns: false,
                        loadMsg: "数据加载中......",
                        pagination: true,
                        rownumbers: true,
                        nowrap: false,
                        showFooter: true,
                        singleSelect: true,
                        pageList: [2, 5, 10, 20],
                        //data : dataArray,
                        columns: [[{
                            field: 'groupname',
                            title: '日期安排',
                            width: 150,
                            align: 'center',
                            sortable: true
                        }, {
                            field: 'radsrcno',
                            title: '放射源编号',
                            width: 150,
                            align: 'center',
                            sortable: true
                        }]],
                        onLoadSuccess: function () {
                            //数据加载成功后久可以拖动
                            $(this).datagrid('enableDnd');
                        },
                        onDrop: function (targetRow, sourceRow, point) {
                            console.log(targeRow + "," + sourceRow + "," + point);
                        }
                    });
                    $('#dd').dialog('open');
                    $('#fm').dialog('close');
                    //$('#intra_Group_dialogdiv').window('open');  //弹出这个dialog框
                    //分组名称
                    var groupNmame = $("#fzmc").val();
                    //alert(groupNmame);

                    var check = $('#intra_Radsrc_Group_table')
                        .datagrid('getChecked');
                    //alert(check);
                    var groupnos = "";
                    var radsrcnos = "";
                    for (var i = 0; i < check.length; i++) {
                        if (i < check.length - 1) {
                            groupnos += check[i].groupno + ",";
                            radsrcnos += check[i].radsrcno + ",";
                        } else {
                            groupnos += check[i].groupno;
                            radsrcnos += check[i].radsrcno;
                        }
                    }
                    $('#intra_Group_dialogdiv').dialog(
                        {
                            id: 'intra_Radsrc_Group_dialog',
                            modeal: true,
                            buttons: [
                                {
                                    text: '&nbsp;确&nbsp;&nbsp;定&nbsp;',
                                    handler: function () {
                                    }
                                },
                                {
                                    text: '&nbsp;关&nbsp;&nbsp;闭&nbsp;',
                                    handler: function () {
                                        $('#dd').window('close');
                                    }
                                }],

                            onClose: function () {
                                $(this).dialog('destroy');
                            },
                            onLoad: function () {
                            },
                            onBeforeOpen: function () {
                                //dialog展示之前，使他绝对剧中
                                $("#intra_Group_dialogdiv").dialog("center");
                            }
                        });
                }
            });

            $('#dd').dialog({
                title: '添加用户',
                collapsible: false,
                resizable: true,
                //小弹层的OK
                buttons: [{
                    text: 'Ok',
                    iconCls: 'icon-ok',
                    handler: function () {
                        $.ajax({
                            url: "${pageContext.request.contextPath}/addUser",
                            type: "post",
                            data: $("#fm").serialize(),
                            success: function (data) {
                                if (data == "true") {
                                    alert('添加成功');
                                    $('#bg').datagrid('reload');
                                } else {
                                    alert('添加失败');
                                }
                                // $('#dd').dialog('close');
                            }
                        });

                    }
                }, {
                    text: 'Cancel',
                    handler: function () {
                        $('#dd').dialog('close');
                    }
                }]
            });

            $('#dd').dialog('close');
            $('#xx').dialog('close');
            $('#fm').dialog('close');
        });
        function fixHeight(percent) {
            return (document.body.clientHeight) * percent;
        }
        function fixWidth(percent) {
            return (document.body.clientWidth - 5) * percent;
        }
    </script>
</head>
<body style="margin: 1px">
<%--
<table id="pg" style="width:300px"></table>
--%>
<table id="bg">

</table>
<%--<div id="tb">
    <div>
        &nbsp;教师名称&nbsp;<input type="text" id="s_name" size="20" onkeydown="if(event.keyCode==13) searchTask()"/>
        <a href="javascript:searchTask()" class="easyui-linkbutton" iconCls="icon-search" plain="true">搜索</a>
    </div>
</div>--%>
<div id="dd" class="easyui-dialog" title="您的选择是：" style="width: 600px; height: 300px; padding: 5px 2px" resizable:true,modal:true data-options="region:'center'">   
  <%--  <table id="intra_Group_dialogtable" class="easyui-datagrid" style="width:600px;height:350px">
    </table>--%>
    <form id="fm" method="post">
        <table cellpadding="6px" align="center">
            <tr>
                <td>班级名称:</td>
                <td>
                    <input type="text" id="userName" name="className" class="easyui-validatebox" required="true" style="width: 200px"/>
                </td>
            </tr>

            <tr>
                <td>时间：</td>
                <td>
                    <input  id="week" name="week" class="easyui-combobox" data-options="panelHeight:'auto',valueField:'id',textField:'name',url:'${pageContext.request.contextPath}/getWeekList'" editable="false" value="请选择"/>
                </td>
            </tr>
            <tr>
                <td>时间：</td>
                <td>
                    <input  id="AMorPM" name="AMorPM" class="easyui-combobox" data-options="panelHeight:'auto',valueField:'id',textField:'name',url:'${pageContext.request.contextPath}/getAMorPMList'" editable="false" value="请选择"/>
                </td>
            </tr>
            <tr>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <a href="javascript:submitData()" class="easyui-linkbutton" iconCls="icon-submit">提交</a>&nbsp;
                    <a href="javascript:resetValue()" class="easyui-linkbutton" iconCls="icon-reset">重置</a>
                </td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>