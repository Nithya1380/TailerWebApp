<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.AccountMaster" %>
<asp:Content ID="content_Head" runat="server" ContentPlaceHolderID="HeaderContent">
    <script src="../../Scripts/AngularJS/angular.js"></script>
     <script type="text/javascript" lang="javascript">
         $(function () {
                 // $("#datepicker").datepicker();
             
         });

         var gb_customerID='<%=CustomerID%>';

         var tailerApp = angular.module("TailerApp", []);
         tailerApp.controller("AccountsController", function ($scope, $window, $http, $rootScope) {
             $scope.CustomerPickLists = {};
             $scope.customerID = gb_customerID;
             $scope.customerMaster = {};
             $scope.customerMaster.CustomerAccount= {};
             $scope.customerMaster.Customer= {};
             $scope.customerMaster.CustomerSupply = {};
             $scope.customerMaster.CustomerBranches = {};

             $scope.init = function () {
                 $scope.GetCustomerDropdowns();
                 $scope.GetCustomerDetails();
             };

             $scope.GetCustomerDropdowns = function () {
                 $scope.CustomerPickLists = {};

                 $http({
                     method: "POST",
                     url: "AccountMaster.aspx/GetCustomerPickLists",
                     data: { customerID: $scope.customerID },
                     dataType: "json",
                     headers: {contentType:"application/json"}
                 }).then(function onSuccess(response) {
                     if (response.data.d.ErrorCode == -1001)
                     {
                         //Session Expired
                         return false;
                     }
                     if (response.data.d.ErrorCode != 0) {
                         alert(response.data.d.ErrorMessage);
                         return false;
                     }

                     $scope.CustomerPickLists = response.data.d.CustomerPickLists;

                 }, function onFailure(error) {

                 });
             };

             $scope.GetCustomerDetails = function () {
                 $scope.customerMaster = {};
                 $scope.customerMaster.CustomerAccount = {};
                 $scope.customerMaster.Customer = {};
                 $scope.customerMaster.CustomerSupply = {};
                 $scope.customerMaster.CustomerBranches = {};

                 $http({
                     method: "POST",
                     url: "AccountMaster.aspx/GetCustomerDetails",
                     data: { customerID: $scope.customerID },
                     dataType: "json",
                     headers: { contentType: "application/json" }
                 }).then(function onSuccess(response) {
                     if (response.data.d.ErrorCode == -1001) {
                         //Session Expired
                         return false;
                     }
                     if (response.data.d.ErrorCode != 0) {
                         alert(response.data.d.ErrorMessage);
                         return false;
                     }

            
                     $scope.customerMaster.CustomerAccount = response.data.d.CustomerAccount;
                     $scope.customerMaster.Customer = response.data.d.Customer;
                     $scope.customerMaster.CustomerSupply = response.data.d.CustomerSupply;
                     $scope.customerMaster.CustomerBranches = response.data.d.CustomerBranches;
                     

                 }, function onFailure(error) {

                 });
             };
         });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" data-ng-controller="AccountsController" data-ng-init="init()" >
    <div class="row">
        <div>&nbsp;</div>
    </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-5 col-md-5 col-sm-5" style="border-right: 1px solid #dfe1e6;">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="profilePic_outer">
                                                <img src="http://ssl.gstatic.com/accounts/ui/avatar_2x.png" class="profilePic">
                                            </div>
                                        </td>
                                        <td style="vertical-align: top">
                                            <div class="clientName">Remington Albritton</div>
                                            <div>&nbsp;<input type="file" title="Upload Photo" class="text-center center-block file-upload" style="margin-left: 3px" /></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <table style="width: 100%" class="profile_table1">
                                <tbody>
                                    <tr>
                                        <td><i class="fa fa-map-marker" style="font-size: 15px; color: #636E7B;"></i>&nbsp;<span class="profileValue1">391 County Rd 3386</span></td>
                                    </tr>
                                    <tr>
                                        <td><span class="profileValue1">391 Brooks, Jennifer Rd 3386</span></td>
                                    </tr>
                                    <tr>
                                        <td><span class="profileValue1">Paradise    TX    76073</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-4" style="border-left: 1px solid #dfe1e6;">
                            <table style="width: 100%" class="profile_table1">
                                <tbody>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Phone:</span></td>
                                        <td>&nbsp;<span class="profileValue1">(999) 927-7421</span></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Cell No:</span></td>
                                        <td>&nbsp;<span class="profileValue1">(999) 866-5522</span></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Work Phone:</span></td>
                                        <td>&nbsp;<span class="profileValue1">(999) 927-6541</span></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Email:</span></td>
                                        <td>&nbsp;<span class="profileValue1">remingtonalbritton@yahoo.com </span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--end of col-4-->
                    </div>
                </div>
                <!--end of card-->
            </div>

            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#accountTab">Account</a></li>
                                <li><a data-toggle="tab" href="#loyaltyTab">Loyalty Gift</a></li>
                                <li><a data-toggle="tab" href="#customerAndBranchTab">Company & Branch</a></li>
                                <li><a data-toggle="tab" href="#cardPrintTab">Card Print</a></li>
                                <li><a data-toggle="tab" href="#supplierTab">Supplier</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active" id="accountTab">
                                    <br />
                                    <div class="row">
                                        <div class="col-lg-2 col-md-2 col-sm-2 pull-right">
                                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                                        </div>
                                    </div>
                                    <div class="form-group row"></div>
                                    <div class="form-horizontal">
                                        <div class="panel-group" id="accordion">
                                            <div class="panel panel-info">
                                                <div class="panel-heading">
                                                    <h3 class="panel-title">Personal Information
                                                      <a data-toggle="collapse" data-parent="#accordion" href="#collapsePersonalInfo" class="pull-right clickable"><i class="glyphicon glyphicon-chevron-up"></i></a>
                                                    </h3>
                                                </div>
                                                <div id="collapsePersonalInfo" class="panel-collapse collapse in">
                                                    <div class="panel-body">
                                                        <div class="form-group row">
                                                            <label for="txtFullName" class="col-sm-2 lbl-text-right">Full Name</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtFullName" id="txtFullName" placeholder="Full Name" title="enter your Full Name." data-ng-model="customerMaster.Customer.FullName">
                                                            </div>
                                                            <label for="drpSex" class="col-sm-2 lbl-text-right">Sex</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpSex" data-ng-model="customerMaster.Customer.Gender">
                                                                    <option>Male</option>
                                                                    <option>Female</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="txtFirstName" class="col-sm-2 lbl-text-right">First Name</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtFullName" id="txtFirstName" placeholder="First Name" title="enter your First Name." data-ng-model="customerMaster.Customer.FirstName">
                                                            </div>
                                                            <label for="txtLastName" class="col-sm-2 lbl-text-right">Last Name</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtLastName" id="txtLastName" placeholder="Last Name" title="enter your Last Name." data-ng-model="customerMaster.Customer.MiddleName"/>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="txtSurName" class="col-sm-2 lbl-text-right">Sur Name</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtSurName" id="txtSurName" placeholder="Sur Name" title="enter your Sur Name." data-ng-model="customerMaster.Customer.SurName"/>
                                                            </div>
                                                            <label for="txtContactPerson" class="col-sm-2 lbl-text-right">Contact Person</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtContactPerson" id="txtContactPerson" placeholder="Contact Person" title="enter Contact Person Name." data-ng-model="customerMaster.Customer.ContactPerson"/>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="txtBirthDate" class="col-sm-2 lbl-text-right">Birth Date</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtBirthDate" id="txtBirthDate" placeholder="Birth Date" title="enter Birth Date." data-ng-model="customerMaster.Customer.BirthDate"/>
                                                            </div>
                                                            <label for="txtOpenDate" class="col-sm-2 lbl-text-right">Open Date</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtOpenDate" id="txtOpenDate" placeholder="Open Date" title="enter Open Date." data-ng-model="customerMaster.Customer.OpenDate"/>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="txtAddress1" class="col-sm-2 lbl-text-right">Address 1</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtAddress1" id="txtAddress1" placeholder="Address 1" data-ng-model="customerMaster.Customer.Address1"/>
                                                            </div>
                                                            <label for="txtAddress2" class="col-sm-2 lbl-text-right">Address 2</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtAddress2" id="txtAddress2" placeholder="Address 2" data-ng-model="customerMaster.Customer.Address2"/>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="drpCountry" class="col-sm-2 lbl-text-right">Country</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpCountry">
                                                                    <option>Select Country</option>
                                                                </select>
                                                            </div>
                                                            <label for="drpState" class="col-sm-2 lbl-text-right">State</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpState" data-ng-model="customerMaster.Customer.State">
                                                                    <option>Select State</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="drpCity" class="col-sm-2 lbl-text-right">City</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpCity" data-ng-model="customerMaster.Customer.City">
                                                                    <option>Select City</option>
                                                                </select>
                                                            </div>
                                                            <label for="txtPin" class="col-sm-2 lbl-text-right">Pin</label>
                                                            <div class="col-sm-4">
                                                                <input type="number" class="form-control" name="txtPin" id="txtPin" data-ng-model="customerMaster.Customer.Pincode"/>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtMobile" class="col-sm-2 lbl-text-right">Mobile</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtMobile" id="txtMobile" placeholder="Mobile" title="enter your Mobile Number." data-ng-model="customerMaster.Customer.MobileNo">
                                                            </div>
                                                            <label for="txtPhone" class="col-sm-2 lbl-text-right">Phone</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtPhone" id="txtPhone" placeholder="Phone" title="enter your Phone Number." data-ng-model="customerMaster.Customer.HomePhoneNo"/>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtEmail" class="col-sm-2 lbl-text-right">Email</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtMobile" id="txtEmail" placeholder="Email" title="enter your Email." data-ng-model="customerMaster.Customer.EmailID">
                                                            </div>
                                                            <label for="txtReferenceNo" class="col-sm-2 lbl-text-right">Reference No</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtReferenceNo" id="txtReferenceNo" placeholder="Reference Number" title="Enter Reference Number." data-ng-model="customerMaster.Customer.ReferenceNumber"/>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtPANNo" class="col-sm-2 lbl-text-right">PAN No</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtPANNo" id="txtPANNo" placeholder="PAN No" title="enter your PAN No." data-ng-model="customerMaster.Customer.PANNumber">
                                                            </div>
                                                            <label for="txtAnnDate" class="col-sm-2 lbl-text-right">Ann Date</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtAnnDate" id="txtAnnDate" placeholder="Ann Date" title="Enter Ann Date." data-ng-model="customerMaster.Customer.AnnDate" />
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtRemarks" class="col-sm-2 lbl-text-right">Remarks</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtRemarks" id="txtRemarks" placeholder="Remarks" title="enter Remarks."  data-ng-model="customerMaster.Customer.Remarks">
                                                            </div>
                                                            <label for="txtCustomerCardNo" class="col-sm-2 lbl-text-right">Customer Card No</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtCustomerCardNo" id="txtCustomerCardNo" placeholder="Customer Card No" title="Enter Customer Card No." data-ng-model="customerMaster.Customer.CustomerCardNumber"/>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="drpSRName" class="col-sm-2 lbl-text-right">SR Name</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpSRName" data-ng-model="customerMaster.Customer.SRName">
                                                                    <option>Select SR Name</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="panel panel-info">
                                                <div class="panel-heading">
                                                    <h3 class="panel-title">Account Information
                                                    <a data-toggle="collapse" data-parent="#accordion" href="#collapseAccountInfo" class="pull-right clickable"><i class="glyphicon glyphicon-chevron-up"></i></a>
                                                    </h3>
                                                </div>
                                                <div id="collapseAccountInfo" class="panel-collapse collapse in">
                                                    <div class="panel-body">
                                                        <div class="form-group row">
                                                            <label class="checkbox-inline col-sm-2" style="font-weight: bold; margin-left: 20px">
                                                                <input type="checkbox" class="checkbox" name="chkCommonAccount" id="chkCommonAccount" data-ng-model="customerMaster.CustomerAccount.IsCommonAccount"/>Common Account
                                                            </label>
                                                            <label class="checkbox-inline col-sm-2" style="font-weight: bold;">
                                                                <input type="checkbox" class="checkbox" name="chkActiveAccount" id="chkActiveAccount" data-ng-model="customerMaster.CustomerAccount.IsActive"/>Active Account
                                                            </label>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtAccountCode" class="col-sm-2 lbl-text-right">Account Code</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="first_name" id="txtAccountCode" placeholder="Account Code" title="enter your Account Code." data-ng-model="customerMaster.CustomerAccount.AccountCode">
                                                            </div>

                                                            <label for="txtAccountName" class="col-sm-2 lbl-text-right">Account Name</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="first_name" id="txtAccountName" placeholder="Account Name" title="enter your Account Code." data-ng-model="customerMaster.CustomerAccount.AccountName">
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="drpAccountType" class="col-sm-2 lbl-text-right">Account Type</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpAccountType" data-ng-model="customerMaster.CustomerAccount.AccountType">
                                                                    <option>Select Account Type</option>
                                                                </select>
                                                            </div>

                                                            <label for="drpParentGroup" class="col-sm-2 lbl-text-right">Parent Group</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpParentGroup" data-ng-model="customerMaster.CustomerAccount.ParentGroup">
                                                                    <option>Select Parent Group</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label for="drpCategory" class="col-sm-2 lbl-text-right">Category</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpCategory" data-ng-model="customerMaster.CustomerAccount.AccountCategory">
                                                                    <option>Select Category</option>
                                                                </select>
                                                            </div>

                                                            <label for="txtPartyAlert" class="col-sm-2 lbl-text-right">Party Alert</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtPartyAlert" id="txtPartyAlert" placeholder="Party Alert" data-ng-model="customerMaster.CustomerAccount.PartyAlert"/>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtOpening" class="col-sm-2 lbl-text-right">Opening</label>
                                                            <div class="col-sm-4">
                                                                <input type="number" class="form-control" name="txtOpening" id="txtOpening" style="display: inline !important; width: 90%"  data-ng-model="customerMaster.CustomerAccount.OpeningBalance"/>&nbsp;Cr.
                                                            </div>

                                                            <label for="txtClosing" class="col-sm-2 lbl-text-right">Closing</label>
                                                            <div class="col-sm-4">
                                                                <input type="number" class="form-control" name="txtClosing" id="txtClosing" style="display: inline !important; width: 90%" data-ng-model="customerMaster.CustomerAccount.ClosingBalance"/>&nbsp;Cr.
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="txtCreatedDate" class="col-sm-2 lbl-text-right">Created Date</label>
                                                            <div class="col-sm-4">
                                                                <input type="text" class="form-control" name="txtCreatedDate" id="txtCreatedDate" placeholder="Created Date"  data-ng-model="customerMaster.CustomerAccount.AccountCreatedDate" />
                                                            </div>
                                                            <div class="col-sm-6">
                                                                <select class="form-control" id="drpDateCategory">
                                                                    <option>Select Category</option>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="form-group row">
                                                            <label class="checkbox-inline col-sm-2" style="font-weight: bold; margin-left: 20px">
                                                                <input type="checkbox" class="checkbox" name="last_name" id="chkTDSApplicable"  data-ng-model="customerMaster.CustomerAccount.IsTDSApplicable"/>TDS Applicable
                                                            </label>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="drpTDSCategory" class="col-sm-2 lbl-text-right" style="text-align: right">TDS Category</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpTDSCategory" data-ng-model="customerMaster.CustomerAccount.TDSCategory">
                                                                    <option>Select Category</option>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="drpDefault" class="col-sm-2 lbl-text-right">Default</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpDefault" data-ng-model="customerMaster.CustomerAccount.Default">
                                                                    <option>Select Default</option>
                                                                </select>
                                                            </div>

                                                            <label for="drpReverse" class="col-sm-2 lbl-text-right">Reverse</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpReverse"  data-ng-model="customerMaster.CustomerAccount.Reverse">
                                                                    <option>Select Reverse</option>
                                                                </select>
                                                            </div>
                                                        </div>

                                                        <div class="form-group row">
                                                            <label for="drpSch6Group" class="col-sm-2 lbl-text-right">Sch6 Group</label>
                                                            <div class="col-sm-4">
                                                                <select class="form-control" id="drpSch6Group" data-ng-model="customerMaster.CustomerAccount.Sh6Group">
                                                                    <option>Select Sch6 Group</option>
                                                                </select>
                                                            </div>

                                                            <label for="txtSch6AccountNo" class="col-sm-2 lbl-text-right">Sch6 Account No</label>
                                                            <div class="col-sm-4">
                                                                <input type="number" class="form-control" name="txtOpening" id="txtSch6AccountNo" data-ng-model="customerMaster.CustomerAccount.Sh6AccountNumber"/>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        
                                
                                <!--/tab-pane-->
                                <div class="tab-pane" id="loyaltyTab">
                                    <br />
                                     <div class="row">
                                            <div class="col-lg-2 col-md-2 col-sm-2 pull-right">
                                                <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                                            </div>
                                        </div>
                                         <div class="form-group row">
                                         </div>
                                </div>

                                <div class="tab-pane" id="customerAndBranchTab">
                                    <div class="form-group">
                                        <div class="col-xs-6 pull-right">
                                            <br />
                                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Retrieve</button>
                                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Share In Branch Group</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <br />
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>
                                                        <input type="checkbox" class="checkbox" name="chkAllBranch" id="chkAllBranch" /></th>
                                                    <th>Company</th>
                                                    <th>Branch</th>
                                                    <th>&nbsp;</th>
                                                    <th>&nbsp;</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td>
                                                        <input type="checkbox" class="checkbox" name="chkBranch1" id="chkBranch1" /></td>
                                                    <td>Company 1</td>
                                                    <td>Branch 1</td>
                                                    <td>0.00 N</td>
                                                    <td>CB</td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <input type="checkbox" class="checkbox" name="chkBranch2" id="chkBranch2" /></td>
                                                    <td>Company 2</td>
                                                    <td>Branch 2</td>
                                                    <td>0.00 N</td>
                                                    <td>CB</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="tab-pane" id="cardPrintTab">
                                    <hr>
                                    <div class="form-group">
                                        <div class="col-xs-6">
                                            <br />
                                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>Print Card</button>
                                        </div>
                                    </div>
                                </div>

                                <div class="tab-pane" id="supplierTab">
                                    <br />
                                    <div class="row">
                                        <div class="col-lg-2 col-md-2 col-sm-2 pull-right">
                                            <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierCode" class="col-sm-2 lbl-text-right">Code<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <input type="text" class="form-control" name="txtSupplierCode" id="txtSupplierCode" placeholder="Code" data-ng-model="customerMaster.CustomerSupply.SupplierCode"/>
                                        </div>
                                        <label for="txtSupplierName" class="col-sm-2 lbl-text-right">Name<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                           <input type="text" class="form-control" name="txtSupplierName" id="txtSupplierName" placeholder="Name" data-ng-model="customerMaster.CustomerSupply.SupplierName"/>
                                        </div>
                                    </div>
                                     <div class="form-group row">
                                        <label for="drpSupplierType" class="col-sm-2 lbl-text-right">Type<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <select class="form-control" id="drpSupplierType" data-ng-model="customerMaster.CustomerSupply.SupplierType"></select>
                                        </div>
                                        <label for="drpSupplierCategory" class="col-sm-2 lbl-text-right">Category</label>
                                        <div class="col-sm-4">
                                           <select class="form-control" id="drpSupplierCategory" data-ng-model="customerMaster.CustomerSupply.SupplierCategory"></select>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierCSTNo" class="col-sm-2 lbl-text-right">CST No</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierCode" id="txtSupplierCSTNo" data-ng-model="customerMaster.CustomerSupply.CSTNumber"/>
                                        </div>
                                        <label for="txtSupplierCSTDate" class="col-sm-2 lbl-text-right">CST Date</label>
                                        <div class="col-sm-4">
                                           <input type="text" class="form-control" name="txtSupplierCSTDate" id="txtSupplierCSTDate" placeholder="CST Date" data-ng-model="customerMaster.CustomerSupply.CSTDate"/>
                                        </div>
                                    </div>
                                     <div class="form-group row">
                                        <label for="txtSupplierSTNo" class="col-sm-2 lbl-text-right">ST No</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierSTNo" id="txtSupplierSTNo" data-ng-model="customerMaster.CustomerSupply.STNumber"/>
                                        </div>
                                        <label for="txtSupplierSTDate" class="col-sm-2 lbl-text-right">ST Date</label>
                                        <div class="col-sm-4">
                                           <input type="text" class="form-control" name="txtSupplierSTDate" id="txtSupplierSTDate" placeholder="ST Date" data-ng-model="customerMaster.CustomerSupply.STDate"/>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierGSTINo" class="col-sm-2 lbl-text-right">GSTIN No<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierGSTINo" id="txtSupplierGSTINo" data-ng-model="customerMaster.CustomerSupply.GSTINNumber"/>
                                        </div>
                                        <label for="txtSupplierTINNo" class="col-sm-2 lbl-text-right">TIN No</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierTINNo" id="txtSupplierTINNo" data-ng-model="customerMaster.CustomerSupply.TINNumber"/>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierVATNo" class="col-sm-2 lbl-text-right">VAT No<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierVATNo" id="txtSupplierVATNo" data-ng-model="customerMaster.CustomerSupply.VATNumber"/>
                                        </div>
                                        <label for="txtSupplierVATLess" class="col-sm-2 lbl-text-right">Less(VATAV)%</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierVATLess" id="txtSupplierVATLess" data-ng-model="customerMaster.CustomerSupply.LessVATPercent"/>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierPANNo" class="col-sm-2 lbl-text-right">PAN No</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierPANNo" id="txtSupplierPANNo" data-ng-model="customerMaster.CustomerSupply.SupplierPANNumber"/>
                                        </div>
                                        <label for="txtSupplierMarkUp" class="col-sm-2 lbl-text-right">Mark Up%</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierMarkUp" id="txtSupplierMarkUp"  data-ng-model="customerMaster.CustomerSupply.MarkUpPercent"/>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierMarkDown" class="col-sm-2 lbl-text-right">Mark Down%</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierMarkDown" id="txtSupplierMarkDown" data-ng-model="customerMaster.CustomerSupply.MarkDownPercent"/>
                                        </div>
                                        <label for="txtSupplierCreditDays" class="col-sm-2 lbl-text-right">Credit Days</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierCreditDays" id="txtSupplierCreditDays" data-ng-model="customerMaster.CustomerSupply.CreditDays"/>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!--/tab-pane-->
                         </div>
                        </div>
                        <!--/tab-content-->
                    </div>
                </div>
            </div>

        </div>
    </div><!--/row-->

   
</asp:Content>
