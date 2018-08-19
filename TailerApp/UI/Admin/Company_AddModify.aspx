<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Company_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Company_AddModify" %>
<script src="../../Scripts/AngularJS/angular.js"></script>
<script src="../../Scripts/AngularJS/CompanyController.js"></script>
<script src="../../Scripts/jquery-1.10.2.min.js"></script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div ng-app="TailerApp"  ng-controller="CompanyController" >
        Company Name: <input type="text" />
        Company Code: <input type="text" />
        Address: <input type="text" />
                <input type="text" />
        City: <input type="text" />
        Pincode: <input type="text" />
        Phone: <input type="text" />
        Fax: <input type="text" />
        URL: <input type="text" />
        E-Mail: <input type="text" />
    </div>
    </form>
</body>
</html>
