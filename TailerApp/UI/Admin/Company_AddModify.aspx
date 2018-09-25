<%@ Page Language="C#" MasterPageFile="~/UI/Admin/AdminPopUp.Master" AutoEventWireup="true" CodeBehind="Company_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Company_AddModify" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/AngularJS/CompanyController.js"></script>


<style type="text/css">
    .table td, .table th{
        padding: 5px;
    }
</style>
<script type="text/javascript">
    var CompanyID = "<%=CompanyID%>";
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div class="Web_PopupHeader">
        <span >Add Company</span>
    </div>

     <div ng-app="TailerApp" ng-controller="CompanyController">
        <div align="right" style="width:98%; padding-right:10px;">
             <input type="button" value="Save" ng-click="SaveCompanyDetails()"/>
            <input type="button" value="Close" ng-click="ClosePopup()"/>
            
        </div>
        <div class="web_box_design web_panel_blue_body" >
            <div class="web_budget_design">
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>General</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Company Name:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.CompanyName"/></td>
                            <td style="text-align:right;">Company Code:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.CompanyCode" /></td>
                            <td style="text-align:right;">Company Create Date:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.CompCreatedDate" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>Address</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Address:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="AD.Address1" /></td>
                            <td style="text-align:right;">City:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="AD.City" /></td>
                        </tr>
                        <tr>
                            <td></td><td><input type="text" class="web_txtbox" ng-model="AD.Address2" /></td>
                            <td style="text-align:right;">Pincode:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="AD.Pincode" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:110px"><span>Contect Nos</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">Phone: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="AD.OfficePhoneNo" /></td>
                        <td style="text-align:right;">Fax: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="AD.AlternateNo" /></td>
                        <td style="text-align:right;">URL: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="AD.Website" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">E-Mail: </td><td colspan="5"><input type="text" class="web_txtbox" ng-model="AD.EmailID" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Registration Nos</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">TDS Number: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.TDSNo" /></td>
                        <td style="text-align:right;">TDS Circle: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.TDSCircle"/></td>
                        <td style="text-align:right;">TDS Challan Number: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.TDSChallanNo" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">Pan Number: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.PanNo" /></td>
                        <td style="text-align:right;">CST Number: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD.CSTNo" /></td>
                        <td style="text-align:right;">CST Date: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="CD." /></td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>