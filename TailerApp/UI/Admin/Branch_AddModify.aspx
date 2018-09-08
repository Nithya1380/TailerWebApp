<%@ Page Language="C#" MasterPageFile="~/UI/Admin/AdminPopUp.Master" AutoEventWireup="true" CodeBehind="Branch_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Branch_AddModify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/AngularJS/BranchController.js"></script>
<style type="text/css">
    .table td, .table th{
        padding: 5px;
    }
</style>
<script type="text/javascript">
    var CompanyID = "<%=CompanyID%>";
    var BranchID = "<%=BranchID%>";
</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div class="Web_PopupHeader">
        <span >Add Branch</span>
    </div>
    <div ng-app="TailerApp" ng-controller="BranchController" >
        <div align="right" style="width:98%; padding-right:10px;">
             <input type="button" value="Save" ng-click="SaveBranchDetails()"/>
            <input type="button" value="Close" ng-click="ClosePopup()"/>
        </div>
        <div class="web_box_design web_panel_blue_body" >
            <div class="web_budget_design">
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>General</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Branch Code: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchCode"/></td>
                            <td style="text-align:right;">Short Name: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.ShortName" /></td>
                            <td style="text-align:right;">Created Date: </td><td style="text-align:left;"><input type="text" style="width:82px;" class="web_txtbox" ng-model="BD.BranchCreatedDate" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">Branch Name: </td><td colspan="3" style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchName" /></td>
                            <td style="text-align:right;">No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchNo" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">Legal Name: </td><td colspan="3" style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchLegalName" /></td>
                            <td style="text-align:right;">Type: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchType" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">Contect Person: </td><td colspan="5" style="text-align:left;"><input type="text" style="width:230px;" class="web_txtbox" ng-model="BD.BranchContactPer" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>Address</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Address:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.Address1" /></td>
                            <td style="text-align:right;">City:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.City" /></td>
                        </tr>
                        <tr>
                            <td></td><td><input type="text" class="web_txtbox" g-model="BAD.Address2" /></td>
                            <td style="text-align:right;">Pincode:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.Pincode" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:110px"><span>Contect Nos</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">Phone: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.OfficePhoneNo" /></td>
                        <td style="text-align:right;">Fax: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.HomePhoneNo"  /></td>
                        <td style="text-align:right;">URL: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.Website" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">E-Mail: </td><td colspan="5"><input type="text" class="web_txtbox" ng-model="BAD.EmailID" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Registration Nos</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">CST No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BarnchCSTNo" /></td>
                        <td colspan="2"></td>
                        <td style="text-align:right;">ST No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchSTNo" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">GSTIN : </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchGSTIN" /></td>
                        <td style="text-align:right;">TIN No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchTINNo" /></td>
                        <td style="text-align:right;">ST Date: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchSTDate" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Excise Details</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchExciseNo" /></td>
                        <td style="text-align:right;">Address: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.ExciseAddress" /></td>
                        <td style="text-align:right;">Division: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.ExciseDivision" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">Range : </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.ExciseRange" /></td>
                        <td colspan="2"></td>
                        <td style="text-align:right;">State: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.ExciseState" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Capillary</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">User: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">Password: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">Area: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Pariod of Year</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">Current Period: Form Date: </td><td style="text-align:left;"><input type="text" style="width:83px;" class="web_txtbox" ng-model="BD.PeriodFormDate" /></td>
                        <td style="text-align:right;">To Date: </td><td style="text-align:left;"><input type="text" style="width:83px;" class="web_txtbox" ng-model="BD.PeriodToDate" /></td>
                        <td style="text-align:right;">Branch Division: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchDivision" /></td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>