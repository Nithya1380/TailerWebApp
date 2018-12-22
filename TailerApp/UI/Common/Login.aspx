<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TailerApp.UI.Common.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous" />
    <webopt:bundlereference runat="server" path="~/Content/css" />

   <style type="text/css">
    body {
        background: rgba(73,155,234,1);
        background: -moz-linear-gradient(left, #3956c9 0%, #000058 100%);
        background: -webkit-gradient(left top, right top, color-stop(0%, rgba(73,155,234,1)), color-stop(100%, #000058 ));
        background: -webkit-linear-gradient(left, #3956c9 0%, #000058 100%);
        background: -o-linear-gradient(left, #3956c9 0%, #000058 100%);
        background: -ms-linear-gradient(left, #3956c9 0%, #000058 100%);
        background: linear-gradient(to right, #3956c9 0%, #000058 100%);
        background-image: url(../../Content/Images/login_back.jpg);
        background-repeat: no-repeat;
        background-size: 100% 100%;
        height: 100vh;
    }

    .login_box {
        background-color: #fff;
        margin-top: 100px;
        margin: 0 auto;
        max-width: 400px;
        padding: 20px;
        border-radius: 25px;
        padding-bottom: 30px;
        -webkit-box-shadow: 1px 1px 15px rgba(0, 0, 0, 0.1);
        -moz-box-shadow: 1px 1px 15px rgba(0, 0, 0, 0.1);
        box-shadow: 1px 1px 15px rgba(0, 0, 0, 0.1);
    }
    .login_top_icon{
        text-align:center;
        margin-bottom:15px;
    }

    .form_sec{
        margin-top:10px;
    }

    .form_table {
        font-family: 'Roboto Condensed', sans-serif;
        font-weight: 500;
        width: 90%;
        color: #545454;
        margin: 0 auto;
    }
    .login_txt {
        width: 100%;
        border: 2px solid #cccccc;
        border-radius: 18px;
        height: 44px;
        font-size: 16px;
        padding: 8px 15px;
        margin-bottom: 15px;
        color: #656565;
        margin-top: 3px;
    }

    input {
        outline: none;
    }
    .login_button {
        width: 100%;
        background-color: #3a59ca;
        border: 1px solid #3a59ca;
        font-weight: 500;
        color: #fff;
        padding: 10px;
        margin-top: 22px;
        border-radius: 18px;
        font-size: 15px;
        outline: none;
        transition-delay: .01s;
    }

        .login_button:hover {
            background-color: #1e40b9;
            border: 1px solid #1e40b9;
        } 
        .login_forget {
            font-size: 13px;
            cursor: pointer;
            color: #5f5f5f;
        }
        .login_forget:hover{
            color:#0094ff;
        }

    .login_name {
        font-weight: 500;
        text-align: center;
        margin-bottom: 20px;
        font-size: 18px;
        color: #545454;
        font-family: 'Roboto Condensed', sans-serif;
    }
</style>

    <script type="text/javascript">
        $(window).load(function () {
            centerContent();
        });

        $(window).resize(function () {
            centerContent();
        });

        function centerContent() {
            var container = $('body');
            var content = $('.login_box');
            content.css("left", (container.width() - content.width()) / 2);
            content.css("margin-top", ((container.height() - content.height()) / 2) - 50);
        }

        function FunForLoginValidation() {
            var objValid = true;
            var objUserName = $("[id$=txtUserName]").val();
            var objPassword = $("[id$=txtPassword]").val();
            if (objUserName == "") {
                $('[id$=lblErrUserName]').text("User Name is required");
                $('[id$=lblErrUserName]').css("color", "#FF0000");
                $("[id$=txtUserName]").addClass("Error-control");
                objValid = false;
            }
            else {
                $('[id$=lblErrUserName]').text("");
                $('[id$=lblErrUserName]').css("color", "#FFFFFF");
                $("[id$=txtUserName]").removeClass("Error-control");
            }

            if (objPassword == "") {
                $('[id$=lblErrPassword]').text("Password is required");
                $('[id$=lblErrPassword]').css("color", "#FF0000");
                $("[id$=txtPassword]").addClass("Error-control");
                objValid = false;
            }
            else {
                $('[id$=lblErrPassword]').text("");
                $('[id$=lblErrPassword]').css("color", "#FFFFFF");
                $("[id$=txtPassword]").removeClass("Error-control");
            }
            return objValid;
        }
        function AcceptAlphanumeric(evt) {
            var key = evt.keyCode;
            return ((key >= 48 && key <= 57) || (key >= 65 && key <= 90) || (key >= 95 && key <= 122));
        }
        function NotAllowSingleDoubleQuotes(e) {
            var charCode = e.keyCode;
            if (charCode == 34)
                return false;
            if (charCode == 39)
                return false;
        }
   </script>  
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager runat="server">
            <Scripts>
                <%--To learn more about bundling scripts in ScriptManager see http://go.microsoft.com/fwlink/?LinkID=301884 --%>
                <%--Framework Scripts--%>
                <asp:ScriptReference Name="MsAjaxBundle" />
                <asp:ScriptReference Name="jquery" />
                <asp:ScriptReference Name="bootstrap" />
                <asp:ScriptReference Name="respond" />
                <asp:ScriptReference Name="WebForms.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebForms.js" />
                <asp:ScriptReference Name="WebUIValidation.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebUIValidation.js" />
                <asp:ScriptReference Name="MenuStandards.js" Assembly="System.Web" Path="~/Scripts/WebForms/MenuStandards.js" />
                <asp:ScriptReference Name="GridView.js" Assembly="System.Web" Path="~/Scripts/WebForms/GridView.js" />
                <asp:ScriptReference Name="DetailsView.js" Assembly="System.Web" Path="~/Scripts/WebForms/DetailsView.js" />
                <asp:ScriptReference Name="TreeView.js" Assembly="System.Web" Path="~/Scripts/WebForms/TreeView.js" />
                <asp:ScriptReference Name="WebParts.js" Assembly="System.Web" Path="~/Scripts/WebForms/WebParts.js" />
                <asp:ScriptReference Name="Focus.js" Assembly="System.Web" Path="~/Scripts/WebForms/Focus.js" />
                <asp:ScriptReference Name="WebFormsBundle" />
                <%--Site Scripts--%>
            </Scripts>
        </asp:ScriptManager>
    
        <div class="login_box">
        <div class="page_logo">
            <img src="../../Content/Images/s2k.png" width="50" />
        </div>
        <div class="login_top_icon">
            <img src="../../Content/Images/user.png" />
        </div>
        <div class="login_name">Stitch Software</div>
        <div class="form_sec">
            <table class="form_table">
                <tr>
                    <td>User Name</td>
                </tr>
                <tr>
                    <td>
                         <asp:TextBox ID="txtUserName" CssClass="login_txt" placeholder="Enter User ID" runat="server"></asp:TextBox> 
                        <asp:Label ID="lblErrUserName" CssClass="help-block" runat="server" Text="" ForeColor="White"></asp:Label>  
                    </td>
                </tr>
                <tr>
                    <td>Password</td>
                </tr>
                <tr>
                    <td><asp:TextBox ID="txtPassword" CssClass="login_txt" placeholder="Enter Your Password" runat="server" TextMode="Password"></asp:TextBox>  
                        <asp:Label ID="lblErrPassword" CssClass="help-block" runat="server" Text="" ForeColor="White"></asp:Label> 
                    </td>
                </tr>
                <tr style="display:none">
                    <td align="right">
                        <span class="login_forget">Forgot Password?</span>
                    </td>
                </tr>
                <tr>
                    <td>
                       
                        <asp:Button ID="btnLogin" CssClass="login_button" Text="Login"  OnClick="btnLogin_Click"
                               OnClientClick="return FunForLoginValidation()" runat="server"   /> 
                    </td>
                </tr>
                <tr>
                    <asp:Label ID="lblErrorMessage" CssClass="help-block" runat="server" Text="" ForeColor="Red"></asp:Label>
                </tr>
            </table>
        </div>
    </div>

  
    </form>
</body>
</html>
