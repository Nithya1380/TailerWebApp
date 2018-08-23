<%@ Page Language="C#" MasterPageFile="~/UI/Admin/AdminPopUp.Master" AutoEventWireup="true" CodeBehind="Branch_AddModify.aspx.cs" Inherits="TailerApp.UI.Admin.Branch_AddModify" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
<style type="text/css">
    .table td, .table th{
        padding: 5px;
    }
</style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div class="Web_PopupHeader">
        <span >Add Branch</span>
    </div>
    <div ng-app="TailerApp"  ng-controller="BranchController" >

        <div class="web_box_design web_panel_blue_body" >
            <div class="web_budget_design">
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:70px"><span>General</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tbody>
                        <tr>
                            <td style="text-align:right;">Branch Code: </td><td style="text-align:left;"><input type="text" class="web_txtbox"/></td>
                            <td style="text-align:right;">Short Name: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                            <td style="text-align:right;">Created Date: </td><td style="text-align:left;"><input type="text" style="width:82px;" class="web_txtbox" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">Branch Name: </td><td colspan="3" style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                            <td style="text-align:right;">No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">Legal Name: </td><td colspan="3" style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                            <td style="text-align:right;">Type: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        </tr>
                        <tr>
                            <td style="text-align:right;">Contect Person: </td><td colspan="5" style="text-align:left;"><input type="text" style="width:230px;" class="web_txtbox" /></td>
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
                        <td style="text-align:right;">E-Mail: </td><td colspan="5"><input type="text" class="web_txtbox" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Registration Nos</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">CST No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td colspan="2"></td>
                        <td style="text-align:right;">ST No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">GSTIN : </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">TIN No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">ST Date: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                </table>
                </div>
                <h2 class="blueborderline_bottom" style="margin-left:-10px"><div class="slope" style="width:132px"><span>Excise Details</span></div></h2>
                <div class="table-responsive  web_tabletext_center">
                <table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" >
                    <tr>
                        <td style="text-align:right;">No: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">Address: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td style="text-align:right;">Division: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                    <tr>
                        <td style="text-align:right;">Range : </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                        <td colspan="2"></td>
                        <td style="text-align:right;">State: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
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
                        <td style="text-align:right;">Current Period: Form Date: </td><td style="text-align:left;"><input type="text" style="width:83px;" class="web_txtbox" /></td>
                        <td style="text-align:right;">To Date: </td><td style="text-align:left;"><input type="text" style="width:83px;" class="web_txtbox" /></td>
                        <td style="text-align:right;">Branch Division: </td><td style="text-align:left;"><input type="text" class="web_txtbox" /></td>
                    </tr>
                </table>
                </div>
            </div>
        </div>
    </div>
</asp:Content>