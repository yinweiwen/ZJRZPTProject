﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="GeneralFramework.Manager.WebForm1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="../jquery-easyui-1.5.1/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="../jquery-easyui-1.5.1/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="../jquery-easyui-1.5.1/demo/demo.css">
    <script type="text/javascript" src="../jquery-easyui-1.5.1/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="../jquery-easyui-1.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="../jquery-easyui-1.5.1/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.cookie.js"></script>
    <script type="text/javascript">
        var NavMenu;
        var UserName;
        $(function () {
            $('#dlg').dialog('close');
            $.ajax({
                type: "Get",
                dataType: "json",
                async: false,
                url: "../../WebServer/NavMenuWebService.ashx?Method=GetNavMenuJson",
                success: function (json) {
                    if (json != "") {
                        NavMenu = json;
                        CreateNav();
                    }
                }
            });

            $.ajax({
                type: "Get",
                dataType: "text",
                async: false,
                url: "../../WebServer/UserLoginWebService.ashx?Method=GetLoginUserInfo",
                success: function (text) {
                    UserName = text;
                    $('#user_msg').html('镇江市965808企业融资服务平台欢迎您：' + UserName);
                }
            });
        })

        function CreateNav() {
            var title;
            for (var i = 0; i < NavMenu.length; i++) {
                if (i == 0) {
                    title = NavMenu[i].MenuName;
                }
                $('#NavMenu').tabs('add', {
                    title: NavMenu[i].MenuName,
                    content: createFrame(NavMenu[i].MenuUrl),
                    closable: false
                });
            }
            $('#NavMenu').tabs('select', title);
        }

        function createFrame(url) {
            var s = '<iframe name="mainFrame" scrolling="yes" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
            return s;
        }

        function OpenUserDialog() {
            $('#textUserName').textbox("setValue", UserName);
            $('#NewPWD').val('');
            $('#QRNewPWD').val('');
            $('#dlg').dialog('open');
        }
        function EditUserPwd() {
            var newpwd = $('#NewPWD').val();
            var qrnewpwd = $('#QRNewPWD').val();
            if (newpwd != qrnewpwd) {
                $.messager.alert('错误', '确认密码必须与新密码一致！', 'error');
            } else {
                $.ajax({
                    type: "Post",
                    dataType: "text",
                    async: false,
                    data: { UserName: $('#textUserName').val(), Pwd: newpwd },
                    url: "../../WebServer/UserLoginWebService.ashx?Method=EditUserPwd",
                    success: function (text) {
                        if (text == "1") {
                            $.messager.alert('提示', '密码修改成功！', 'info');
                            $('#dlg').dialog('close');
                        } else {
                            $.messager.alert('提示', '密码修改失败！', 'info');
                        }
                    }
                });
            }
        }

    </script>
</head>
<body class="easyui-layout">
    <form id="form1" runat="server">
    <div style="margin: 20px 0;">
    </div>
    <div data-options="region:'north'" style="margin-left: 10px; height: 100px; text-align: center;
        line-height: 99px; font-size: 40px; color: White; background: url(../../images/htbanner.jpg) repeat fixed!important;
        overflow: hidden;">
        镇江市965808企业融资服务平台
    </div>
    <div data-options="region:'south',split:true" maxheight="30px" style="height: 30px;">
        <div id="user_msg" style="text-align: right; float: left;">
        </div>
        <div id="time" style="text-align: right; float: left;">
        </div>
        <div id="Logout" style="text-align: right; float: right; height: 20px; margin-right: 10px;">
            <a href="#" onclick="OpenUserDialog()">修改密码</a>&nbsp;&nbsp;&nbsp; <a href="../login.html">
                退出系统</a>
        </div>
    </div>
    <div style="margin: 20px 0;">
    </div>
    <div region="center" border="false">
        <div id="NavMenu" class="easyui-tabs" style="width: auto; height: 100%;">
        </div>
    </div>
    <div id="dlg" class="easyui-dialog" title="修改密码" style="text-align: center; width: 400px;
        height: 230px; padding: 10px" data-options="
                iconCls: 'icon-save',
                buttons: '#dlg-buttons'
            ">
        <div style="margin-bottom: 20px">
            <input id="textUserName" disabled="disabled" class="easyui-textbox" iconwidth="28"
                style="width: 100%; height: 25px; padding: 10px;">
        </div>
        <div style="margin-bottom: 20px">
            <input id="NewPWD" class="easyui-passwordbox" prompt="新密码" iconwidth="28" style="width: 100%;
                height: 25px; padding: 10px;">
        </div>
        <div style="margin-bottom: 20px">
            <input id="QRNewPWD" class="easyui-passwordbox" prompt="确认密码" iconwidth="28" style="width: 100%;
                height: 25px; padding: 10px;">
        </div>
    </div>
    <div id="dlg-buttons">
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="EditUserPwd()">保存</a>
        <a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#dlg').dialog('close')">
            关闭</a>
    </div>
    </form>
</body>
</html>
