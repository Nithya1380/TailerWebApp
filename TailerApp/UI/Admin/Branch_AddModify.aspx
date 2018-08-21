<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Branch_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Branch_AddModify" %>
<script src="../../Scripts/AngularJS/angular.js"></script>
<script src="../../Scripts/AngularJS/BranchController.js"></script>
<script src="../../Scripts/jquery-1.10.2.min.js"></script>
<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

    <div ng-app="TailerApp"  ng-controller="BranchController" >

        Branch Code: <input type="text" />
        Short Name: <input type="text" />
        Branch Name: <input type="text" />
        Legal Name: <input type="text" />
        Contect Person: <input type="text" />
        Create Date: <input type="text" />
        No: <input type="text" />
        Type: <input type="text" />
        Address: <input type="text" />
                <input type="text" />
        City: <input type="text" />
        Pincode: <input type="text" />
        Phone: <input type="text" />
        Fax: <input type="text" />
        URL: <input type="text" />
        E-Mail: <input type="text" />
        CST No: <input type="text" />
        ST NO: <input type="text" />

        GSTIN*: <input type="text" />
        TIN NO: <input type="text" />
        ST Data: <input type="text" />

        No: <input type="text" />
        Address: <input type="text" />
        Division: <input type="text" />
        Range: <input type="text" />
        State: <input type="text" />

        Current Period: From Date: <input type="text" />
        To Date: <input type="text" />
        Branch Division: <input type="text" />
    </div>
    </form>
</body>
</html>
