<%@ Page Language="C#" MasterPageFile="~/UI/Admin/AdminPopUp.Master" AutoEventWireup="true" CodeBehind="Branch_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Branch_AddModify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
    <script src="../../Scripts/jquery-1.10.2.js"></script>
    <script src="../../Scripts/jquery-1.10.2.min.js"></script>

    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../Style/bootstrap.min.css" rel="stylesheet" />
    <script src="../../Scripts/bootstrap.min.js"></script>

    <link href="../../Scripts/CalendarControl.css" rel="stylesheet" />

    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <script src="../../Scripts/angular-datepicker.js"></script>
    <script src="../../Scripts/AngularJS/BranchController.js"></script>
<style type="text/css">
    .table td, .table th{
        padding: 5px;
    }
 ._720kb-datepicker-calendar-day._720kb-datepicker-today {
  background:#2e6e9e;
  color:white;
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
                <div class="web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Branch Code: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchCode"/></td>
                            <td style="text-align:right;">Short Name: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.ShortName" /></td>
                            <td style="text-align:right;">Created Date: </td><td style="text-align:left;">
                                <div class="input-group date">
				                    <datepicker  date-format="MM/dd/yyyy" style="width: 0px; margin-left: 0px; margin-right: 110px;">
					                    <input type="text" tabindex="2000" valid-calendar-date id="txt_BranchCreatedDate" ng-model="BD.BranchCreatedDate" 
						                    class="form-control" style="width:110px;"/> 
				                    </datepicker>
			                        <span class="input-group-append">
					                    <button class="btn btn-outline-secondary" style="padding: 0px 4px;" type="button" ng-click="FocusScheduleFromDate('txt_BranchCreatedDate')">
						                    <i class="fa fa-calendar"></i>
					                    </button>
			                        </span>
			                    </div>
                              </td>
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
                <div class="web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Address:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.Address1" /></td>
                            <td style="text-align:right;">City:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.City" /></td>
                        </tr>
                        <tr>
                            <td></td><td><input type="text" class="web_txtbox" ng-model="BAD.Address2" /></td>
                            <td style="text-align:right;">Pincode:</td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BAD.Pincode" /></td>
                        </tr>
                    </tbody>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:110px"><span>Contect Nos</span></div></h2>
                <div class="web_tabletext_center">
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
                <div class="web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">CST No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BarnchCSTNo" /></td>
                        <td colspan="2"></td>
                        <td style="text-align:right;">ST No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchSTNo" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">GSTIN : </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchGSTIN" /></td>
                        <td style="text-align:right;">TIN No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchTINNo" /></td>
                        <td style="text-align:right;">ST Date: </td>
                        <td style="text-align:left;">
                            <div class="input-group date">
				                    <datepicker  date-format="MM/dd/yyyy" style="width: 0px; margin-left: 0px; margin-right: 110px;">
					                    <input type="text" tabindex="2000" valid-calendar-date id="txt_BranchSTDate" ng-model="BD.BranchSTDate" 
						                    class="form-control" style="width:110px;"/> 
				                    </datepicker>
			                        <span class="input-group-append">
					                    <button class="btn btn-outline-secondary" style="padding: 0px 4px;" type="button" ng-click="FocusScheduleFromDate('txt_BranchSTDate')">
						                    <i class="fa fa-calendar"></i>
					                    </button>
			                        </span>
			                    </div>
                        </td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Excise Details</span></div></h2>
                <div class="web_tabletext_center">
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
                <h2 class="blueborderline_bottom" style="margin-left:-10px" ng-show="BranchID == 0"><div class="slope" style="width:132px"><span>Capillary</span></div></h2>
                <div class="web_tabletext_center" ng-show="BranchID == 0">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">User: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="User" /></td>
                        <td style="text-align:right;">Password: </td><td style="text-align:left;"><input type="password" class="web_txtbox" ng-model="Password" /></td>
                        <td style="text-align:right;">Area: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Pariod of Year</span></div></h2>
                <div class="web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">Current Period: Form Date: </td>
                        <td style="text-align:left;">
                            <div class="input-group date">
				                <datepicker  date-format="MM/dd/yyyy" style="width: 0px; margin-left: 0px; margin-right: 110px;">
					                <input type="text" tabindex="2000" valid-calendar-date id="txt_PeriodFormDate" ng-model="BD.PeriodFormDate" 
						                class="form-control" style="width:110px;"/> 
				                </datepicker>
			                    <span class="input-group-append">
					                <button class="btn btn-outline-secondary" style="padding: 0px 4px;" type="button" ng-click="FocusScheduleFromDate('txt_PeriodFormDate')">
						                <i class="fa fa-calendar"></i>
					                </button>
			                    </span>
			                </div>
                        </td>
                        <td style="text-align:right;">To Date: </td>
                            <td style="text-align:left;">
                                <div class="input-group date">
				                    <datepicker  date-format="MM/dd/yyyy" style="width: 0px; margin-left: 0px; margin-right: 110px;">
					                    <input type="text" tabindex="2000" valid-calendar-date id="txt_PeriodToDate" ng-model="BD.PeriodToDate" 
						                    class="form-control" style="width:110px;"/> 
				                    </datepicker>
			                        <span class="input-group-append">
					                    <button class="btn btn-outline-secondary" style="padding: 0px 4px;" type="button" ng-click="FocusScheduleFromDate('txt_PeriodToDate')">
						                    <i class="fa fa-calendar"></i>
					                    </button>
			                        </span>
			                    </div>
                            </td>
                        <td style="text-align:right;">Branch Division: </td><td style="text-align:left;"><input type="text" class="web_txtbox" ng-model="BD.BranchDivision" /></td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>