<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TailerApp.UI.Common.Login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login</title>
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous" />
    <webopt:bundlereference runat="server" path="~/Content/css" />

    <style type="text/css">  
        body {  
            background: url(../images/06.jpg) no-repeat;  
            background-size: cover;  
            min-height: 100%;  
        }  
  
        html {  
            min-height: 100%;  
        }  
  
        .Error-control {  
            background: #ffdedd !important;  
            border-color: #ff5b57 !important;  
        }  
    </style>  

    <script type="text/javascript">
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
    

        <div class="container">  
           <div class="row">  
               <div class="col-lg-5 col-md-6 col-sm-8 col-xl-12 " style="margin: auto; float: initial; padding-top: 12%">  
                   <div class="row userInfo">  
  
                       <div class="panel panel-default ">  
                           <div class="panel-heading">  
                               <h3 class="panel-title" style="text-align: center; font-weight: bold">  
                                   <a class="collapseWill">Login to your Account</a>  
                               </h3>  
                           </div>  
                           <div id="collapse1" class="panel-collapse collapse in">  
                               <div class="panel-body">  
                                   <fieldset>  
                                       <div class="form-group">  
                                           <div class="col-md-"></div>  
                                           <label class="col-md-12 control-label" for="prependedcheckbox">  
                                               User ID  
                                           </label>  
                                           <div class="col-md-12">  
                                               <div class="input-group">  
                                                   <span class="input-group-addon">  
                                                       <i class="fa fa-user"></i>  
                                                   </span>  
                                                   <asp:TextBox ID="txtUserName" CssClass="form-control" placeholder="Enter User ID" runat="server"></asp:TextBox>  
                                               </div>  
                                               <asp:Label ID="lblErrUserName" CssClass="help-block" runat="server" Text="" ForeColor="White"></asp:Label>  
                                           </div>  
  
                                           <label class="col-md-12 control-label" for="prependedcheckbox">  
                                               Password  
                                           </label>  
                                           <div class="col-md-12">  
                                               <div class="input-group">  
                                                   <span class="input-group-addon">  
                                                       <i class="fa fa-lock"></i>  
                                                   </span>  
                                                   <asp:TextBox ID="txtPassword" CssClass="form-control" placeholder="Enter Your Password" runat="server" TextMode="Password"></asp:TextBox>  
                                               </div>  
                                               <asp:Label ID="lblErrPassword" CssClass="help-block" runat="server" Text="" ForeColor="White"></asp:Label>  
                                           </div>  
  
                                           <div class="col-md-12">  
                                                 
                                               <div class="col-lg-6">  
                                                   <div class="input-group" style="width: 100%">  
                                                       <asp:Button ID="btnLogin" CssClass="btn btn-success" Text="Login"  OnClick="btnLogin_Click"
                                                           OnClientClick="return FunForLoginValidation()" runat="server" Style="width: 100%"  />  
                                                   </div>  
                                               </div>  
                                                <asp:Label ID="lblErrorMessage" CssClass="help-block" runat="server" Text="" ForeColor="White"></asp:Label>
                                           </div>  
                                       </div>  
                                   </fieldset>  
  
                               </div>  
                           </div>  
  
                           <div class="panel-heading">  
                               <div class="panel-title" style="text-align: right">  
                                   <a class="collapseWill" href="SellerForgetPassword.aspx" style="font-size: x-small">Forgot Username or Password?  
                                   </a>  
                               </div>  
                           </div>  
                       </div>  
                   </div>  
               </div>  
           </div>  
       </div>  
    </form>
</body>
</html>
