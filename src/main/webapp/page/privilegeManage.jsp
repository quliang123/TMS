<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>用户管理</title>
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
        /**
         * 初始化界面
         */
        var dataGrid;
        var editRowId;
        var rowEditor = undefined;
        $(function () {
            dataGrid = $("#role_tb")
                .datagrid(
                    {
                        url: "${pageContext.request.contextPath}/getList",// 加载的URL
                        isField: "id",
                        method: "post",
                        pagination: false,// 显示分页
                        fit: true,// 自动补全
                        fitColumns: true,
                        singleSelect: true,
                        iconCls: "icon-save",// 图标
                        columns: [[ // 每个列具体内容
                            {
                                field: 'rid',
                                title: '编号',
                                align: 'center',
                                width: 100,
                            },
                            {
                                field: 'roleName',
                                title: '角色名称',
                                align: 'center',
                                width: 100,
                                editor: 'text'
                            }, {
                                field: 'isDelete',
                                title: '是否禁用',
                                align: 'center',
                                width: 100,
                                editor: {
                                    type: 'checkbox',
                                    options: {
                                        on: '1',
                                        off: '0'
                                    }
                                },
                                formatter: function (value, row, index) {
                                    if (value == '0') {
                                        return '<span style="color:green">正常</span>';
                                    } else {
                                        return '<span style="color:red">禁用</span>';
                                    }
                                }
                            }, {
                                field: 'action',
                                title: '编辑权限',
                                align: 'center',
                                width: 100,
                                formatter: function (value, row, index) {
                                    return "<a href='#' class='easyui-linkbutton' onclick='editRole(" + row.rid + ")'>编辑权限</a>";
                                }
                            }, {
                                field: 'roleUser',
                                title: '查看管理员',
                                align: 'center',
                                width: 100,
                                formatter: function (value, row, index) {
                                    return "<a href='#' class='easyui-linkbutton' onclick='editRoleUser(" + row.rid + ")'>查看管理员</a>";
                                }
                            }]],
                        toolbar: [ // 工具条
                            {
                                text: "增加",
                                iconCls: "icon-add",
                                handler: function () {// 回调函数
                                    if (rowEditor == undefined) {
                                        dataGrid.datagrid('insertRow', {// 如果处于未被点击状态，在第一行开启编辑
                                            index: 0,
                                            row: {}
                                        });
                                        rowEditor = 0;
                                        dataGrid.datagrid('beginEdit',
                                            rowEditor);// 没有这行，即使开启了也不编辑

                                    }

                                }
                            },
                            {
                                text: "删除",
                                iconCls: "icon-remove",
                                handler: function () {
                                    var rows = dataGrid
                                        .datagrid('getSelections');

                                    if (rows.length <= 0) {
                                        $.messager.alert('警告', '您没有选择',
                                            'error');
                                    } else if (rows.length > 1) {
                                        $.messager.alert('警告', '不支持批量删除',
                                            'error');
                                    } else {
                                        $.messager
                                            .confirm(
                                                '确定',
                                                '您确定要删除吗',
                                                function (t) {
                                                    if (t) {

                                                        $.ajax({
                                                            url: '../service/role/del',
                                                            method: 'POST',
                                                            data: rows[0],
                                                            dataType: 'json',
                                                            success: function (r) {
                                                                if (r.code == "1") {
                                                                    dataGrid
                                                                        .datagrid('acceptChanges');
                                                                    $.messager
                                                                        .show({
                                                                            msg: r.msg,
                                                                            title: '成功'
                                                                        });
                                                                    editRow = undefined;
                                                                    dataGrid
                                                                        .datagrid('reload');
                                                                } else {
                                                                    dataGrid
                                                                        .datagrid(
                                                                            'beginEdit',
                                                                            editRow);
                                                                    $.messager
                                                                        .alert(
                                                                            '错误',
                                                                            r.msg,
                                                                            'error');
                                                                }
                                                                dataGrid
                                                                    .datagrid('unselectAll');
                                                            }
                                                        });

                                                    }
                                                })
                                    }

                                }
                            },
                            {
                                text: "修改",
                                iconCls: "icon-edit",
                                handler: function () {
                                    var rows = dataGrid
                                        .datagrid('getSelections');
                                    if (rows.length == 1) {
                                        if (rowEditor == undefined) {
                                            var index = dataGrid.datagrid(
                                                'getRowIndex', rows[0]);
                                            rowEditor = index;
                                            dataGrid
                                                .datagrid('unselectAll');
                                            dataGrid.datagrid('beginEdit',
                                                index);

                                        }
                                    }
                                }
                            },
                            /*{
                             text : "查询",
                             iconCls : "icon-search",
                             handler : function() {
                             }
                             },*/
                            {
                                text: "保存",
                                iconCls: "icon-save",
                                handler: function () {
                                    dataGrid.datagrid('endEdit', rowEditor);
                                    rowEditor = undefined;
                                }
                            }, {
                                text: "取消编辑",
                                iconCls: "icon-redo",
                                handler: function () {
                                    rowEditor = undefined;
                                    dataGrid.datagrid('rejectChanges');
                                }
                            }],
                        onAfterEdit: function (rowIndex, rowData, changes) {
                            var inserted = dataGrid.datagrid('getChanges',
                                'inserted');
                            var updated = dataGrid.datagrid('getChanges',
                                'updated');
                            if (inserted.length < 1 && updated.length < 1) {
                                editRow = undefined;
                                dataGrid.datagrid('unselectAll');
                                return;
                            }

                            var url = '';
                            if (inserted.length > 0) {
                                url = '../service/role/add';
                            }
                            if (updated.length > 0) {
                                url = '../service/role/update';
                            }

                            $.ajax({
                                url: url,
                                method: "POST",
                                data: rowData,
                                dataType: 'json',
                                success: function (r) {
                                    if (r.code == "1") {
                                        dataGrid
                                            .datagrid('acceptChanges');
                                        $.messager.show({
                                            msg: r.msg,
                                            title: '成功'
                                        });
                                        editRow = undefined;
                                        dataGrid.datagrid('reload');
                                    } else {
                                        /* datagrid.datagrid('rejectChanges'); */
                                        dataGrid.datagrid('beginEdit',
                                            editRow);
                                        $.messager.alert('错误', r.msg,
                                            'error');
                                    }
                                    dataGrid.datagrid('unselectAll');
                                }
                            });

                        },
                        onDblClickCell: function (rowIndex, field, value) {
                            if (rowEditor == undefined) {
                                dataGrid.datagrid('beginEdit', rowIndex);
                                rowEditor = rowIndex;
                            }

                        }
                    });
        });

        function editRole(id) {
            alert(id);
            editRowId = id;
            //1.取消所有选择
            //var root = $('#tt').tree('getRoot');
            //$("#tt").tree('uncheck',root.target);
            //2.加载权限，动态选择
            var url = '${pageContext.request.contextPath}/roleTree?roleId=' + id;
            $('#tt').tree({
                    url: "${pageContext.request.contextPath}/roleTree?roleId=" + id,
                    type: "POST",
                    onClick: function (node) {
                        var text = node.text;
                        var ico = node.iconCls;
                        var vla = node.val();
                        alert(text + ico + vla)
                    }

                }
            )

            /*            $.ajax({
             cache: true,
             type: "POST",
             url: url,
             async: false,
             success: function (data) {
             alert('data' + data);
             data = JSON.parse(data);
             alert(data);
             /!*$(data).each(function (i, obj) {
             var children = obj.children;
             alert('children'+children);
             /!* $(children).each(function (j, c_obj) {
             var cc = $("#tt").tree('find', c_obj.id);
             // alert(cc);
             if (cc) {
             $("#tt").tree('check', cc.target);
             }
             });*!/
             });*!/
             }
             });*/

            $("#win").window('open');
        }
        //获取选中节点和父节点
        function getChecked() {
            var nodesParent = $('#tt').tree('getChecked', 'indeterminate');
            var nodes = $(' ').tree('getChecked');
            var s = '';

            for (var i = 0; i < nodesParent.length; i++) {
                if (s != '')
                    s += ',';
                s += nodesParent[i].id;
            }
            for (var i = 0; i < nodes.length; i++) {
                if (s != '')
                    s += ',';
                s += nodes[i].id;
            }
            return s;
        }
        //提交修改
        function confrimEdit() {

            var funIds = getChecked();
            alert(funIds + "====================" + editRowId);
            var url = '${pageContext.request.contextPath}/savePrivilege';
            var data = {
                "roleId": editRowId,
                "funcIds": funIds
            };
            $.ajax({
                cache: true,
                type: "POST",
                url: url,
                data: data,
                async: true,
                success: function (data) {
                    if (data == "1") {
                        $.messager.show({
                            msg: "操作成功",
                            title: '成功'
                        });
                        closeWin();
                    } else {
                        $.messager
                            .alert(
                                '错误',
                                "操作失败",
                                'error');
                    }
                }
            });
        }
        //关闭窗口
        function closeWin() {
            $('#tt').tree('reload');
            $("#win").window('close');
        }
        //打开编辑管理员窗口
        function editRoleUser(roleId) {
            alert(roleId);
            editRowId = roleId;
            var roleUserGrid = $("#roleUser_tb").datagrid(
                {
                    url: "${pageContext.request.contextPath}/getUserByRid?rid=" + roleId,// 加载的URL
                    isField: "user_id",
                    method: "POST",
                    pagination: false,// 显示分页
                    fit: true,// 自动补全
                    fitColumns: true,
                    singleSelect: true,
                    iconCls: "icon-save",// 图标
                    columns: [[ // 每个列具体内容
                        {
                            field: 'uid',
                            title: '用户编号',
                            align: 'center',
                            width: 100,
                        }, {
                            field: 'uname',
                            title: '姓名',
                            align: 'center',
                            width: 100,
                        }
                    ]]
                });
            $("#roleUserWin").window('open');
        }
        //输入工号添加用户至管理员
        function addRoleUser() {
            var empNo = $("#addUserId").val();
            var url = '../service/role/addRoleUser';
            var data = {
                "roleId": editRowId,
                "empNo": empNo
            };
            $.ajax({
                type: "POST",
                url: url,
                data: data,
                dataType: 'json',
                success: function (data) {
                    if (data.flg == "1") {
                        $.messager.show({
                            msg: "操作成功",
                            title: '成功'
                        });
                        $("#roleUser_tb").datagrid('reload');
                    } else {
                        $.messager
                            .alert(
                                '错误',
                                data.msg,
                                'error');
                    }
                }
            });
        }
    </script>
    <script type="text/javaScript">
        //打开菜单窗口
        function openMenuDialog() {
            var selected = $("#list").datagrid('getSelected');
            if (selected != null) {
                $("#id").val(selected.id);
                queryMenus(selected.id);
                $("#menuWindow").window("open");
            } else {
                $.messager.alert('提示', "未选择数据！");
            }
        }
        //角色-菜单信息入库
        function ajaxSubmit(rid, idstr) {
            $.post("${ctx}/roleMenu/save.jhtml", {"roleId": rid, "ids": idstr}, function (obj) {
                $.messager.alert('提示', obj.msg);
                $("#menuWindow").window('close');
            }, 'json');
        }
    </script>
</head>
<body>
<table id="role_tb">
</table>

<!-- 权限编辑窗口 -->
<div id="win" class="easyui-window" title="角色编辑"
     style="width: 500px; height: 250px;" closed="true">
    <form style="padding: 10px 20px 10px 40px;">
        <ul id="tt" class="easyui-tree" <%--url="../service/func/allTree" method="post"--%>
            checkbox="true">
        </ul>
        <div style="padding: 5px; text-align: center;">
            <a href="#" class="easyui-linkbutton" icon="icon-ok" onclick="confrimEdit();">确定</a> <a
                href="#" class="easyui-linkbutton" icon="icon-cancel" onclick="closeWin();">取消</a>
        </div>
    </form>
</div>

<div id="menuWindowfooter" style="padding:5px;text-align:right;">
    <a href="#" onclick="onCheck();" class="easyui-linkbutton" data-options="iconCls:'icon-save'">提交</a>
</div>

<!-- 角色用户编辑窗口 -->
<div id="roleUserWin" class="easyui-window" title="编辑管理员"
     style="width: 500px; height: 250px;" closed="true">
    <table id="roleUser_tb" toolbar="#addBar">
    </table>
</div>

<!-- 角色用户编辑窗口工具栏 -->
<div id="addBar" style="padding: 3px">
    <span>输入工号添加用户:</span> <input id="addUserId"
                                  style="line-height: 26px; border: 1px solid #ccc">
    <a href="#" class="easyui-linkbutton" plain="true" onclick="addRoleUser()">点击添加至管理员</a>
</div>


<script type="text/javascript"
        src="<%=request.getContextPath()%>/js/admin/role.js"></script>
</body>
</html>