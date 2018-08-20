<%@ Page Language="C#" MasterPageFile="~/UI/Admin/AdminPopUp.Master" AutoEventWireup="true" CodeBehind="Company_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Company_AddModify" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
<script src="../../Scripts/AngularJS/angular.js"></script>
<script src="../../Scripts/AngularJS/CompanyController.js"></script>
<script src="../../Scripts/jquery-1.10.2.min.js"></script>
<link href="../Style/TailerStyle.css" rel="stylesheet" />
<link href="../Style/bootstrap.min.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div ng-app="TailerApp"  ng-controller="CompanyController" >
        <div class="web_box_design web_panel_blue_body" >
            <div class="web_budget_design">
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>General</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Company Name:</td><td style="text-align:left;"><input type="text" class="web_txtbox"/></td>
                            <td style="text-align:right;">Company Code:</td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>Address</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Address:</td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                            <td style="text-align:right;">City:</td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        </tr>
                        <tr>
                            <td></td><td><input type="text" class="web_txtbox" /></td>
                            <td style="text-align:right;">Pincode:</td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:110px"><span>Contect Nos</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">Phone: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">Fax: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">URL: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">E-Mail: </td><td><input type="text" class="web_txtbox" /></td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>