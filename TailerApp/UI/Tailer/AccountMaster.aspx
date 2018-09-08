﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AccountMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.AccountMaster" %>
<asp:Content ID="content_Head" runat="server" ContentPlaceHolderID="HeaderContent">
    <script src="../../Scripts/AngularJS/angular.js"></script>
     <script type="text/javascript" lang="javascript">
         $(function () {
                  $("#datepicker").datepicker();
             
         });

         var tailerApp = angular.module("TailerApp", []);
         tailerApp.controller("AccountsController", function ($scope, $window, $http, $rootScope) {
             $scope.CustomerPickLists = {};
             $scope.customerID = 0;

             $scope.init = function () {
                 $scope.GetCustomerDropdowns();
             };

             $scope.GetCustomerDropdowns = function () {
                 $scope.CustomerPickLists = {};

                 $http({
                     type: "POST",
                     url: "AccountMaster.aspx/GetCustomerPickLists",
                     data: { customerID: $scope.customerID },
                     dataType: "json",
                     headers: {contentType:"application/json"}
                 }).done(function onSuccess(response) {
                     if(response.d.ErrorCode==-1001)
                     {
                         //Session Expired
                         return false;
                     }
                     if (response.d.ErrorCode!=0) {
                         alert(response.d.ErrorMessage);
                         return false;
                     }

                     $scope.CustomerPickLists = response.d.CustomerPickLists;

                 }, function onFailure(error) {

                 });
             };
         });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet">
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
                                <li><a data-toggle="tab" href="#customerTab">Customer</a></li>
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
                                    <div class="form-horizontal">
                                        <div class="form-group row">
                                            <label class="checkbox-inline col-sm-2" style="font-weight:bold;margin-left:20px">
                                                <input type="checkbox" class="checkbox" name="chkCommonAccount" id="chkCommonAccount" />Common Account
                                            </label>
                                            <label class="checkbox-inline col-sm-2" style="font-weight:bold;">
                                                <input type="checkbox" class="checkbox" name="chkActiveAccount" id="chkActiveAccount" />Active Account
                                            </label>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtAccountCode" class="col-sm-2 lbl-text-right">Account Code</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="first_name" id="txtAccountCode" placeholder="Account Code" title="enter your Account Code.">
                                            </div>

                                            <label for="txtAccountName" class="col-sm-2 lbl-text-right">Account Name</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="first_name" id="txtAccountName" placeholder="Account Name" title="enter your Account Code.">
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="drpAccountType" class="col-sm-2 lbl-text-right">Account Type</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpAccountType">
                                                    <option>Select Account Type</option>
                                                </select>
                                            </div>

                                            <label for="drpParentGroup" class="col-sm-2 lbl-text-right">Parent Group</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpParentGroup">
                                                    <option>Select Parent Group</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label for="drpCategory" class="col-sm-2 lbl-text-right">Category</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpCategory">
                                                    <option>Select Category</option>
                                                </select>
                                            </div>

                                            <label for="txtPartyAlert" class="col-sm-2 lbl-text-right">Party Alert</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtPartyAlert" id="txtPartyAlert" placeholder="Party Alert" />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtOpening" class="col-sm-2 lbl-text-right">Opening</label>
                                            <div class="col-sm-4">
                                                <input type="number" class="form-control" name="txtOpening" id="txtOpening" style="display: inline !important; width: 90%" />&nbsp;Cr.
                                            </div>

                                            <label for="txtClosing" class="col-sm-2 lbl-text-right">Closing</label>
                                            <div class="col-sm-4">
                                                <input type="number" class="form-control" name="txtClosing" id="txtClosing" style="display: inline !important; width: 90%" />&nbsp;Cr.
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtCreatedDate" class="col-sm-2 lbl-text-right">Created Date</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtCreatedDate" id="txtCreatedDate" placeholder="Created Date" />
                                            </div>
                                            <div class="col-sm-6">
                                                <select class="form-control" id="drpDateCategory">
                                                    <option>Select Category</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label class="checkbox-inline col-sm-2" style="font-weight: bold;margin-left:20px">
                                                <input type="checkbox" class="checkbox" name="last_name" id="chkTDSApplicable" />TDS Applicable
                                            </label>
                                        </div>

                                        <div class="form-group row">
                                            <label for="drpTDSCategory" class="col-sm-2 lbl-text-right" style="text-align: right">TDS Category</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpTDSCategory">
                                                    <option>Select Category</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="drpDefault" class="col-sm-2 lbl-text-right">Default</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpDefault">
                                                    <option>Select Default</option>
                                                </select>
                                            </div>

                                            <label for="drpReverse" class="col-sm-2 lbl-text-right">Reverse</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpReverse">
                                                    <option>Select Reverse</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="drpSch6Group" class="col-sm-2 lbl-text-right">Sch6 Group</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpSch6Group">
                                                    <option>Select Sch6 Group</option>
                                                </select>
                                            </div>

                                            <label for="txtSch6AccountNo" class="col-sm-2 lbl-text-right">Sch6 Account No</label>
                                            <div class="col-sm-4">
                                                <input type="number" class="form-control" name="txtOpening" id="txtSch6AccountNo" />
                                            </div>
                                        </div>

                                    </div>
                                </div>
                                <!--/tab-pane-->
                                <div class="tab-pane" id="customerTab">
                                    <br />
                                    <div class="form-horizontal">
                                        <div class="row">
                                            <div class="col-lg-2 col-md-2 col-sm-2 pull-right">
                                                <button class="btn btn-lg btn-success" type="submit"><i class="glyphicon glyphicon-ok-sign"></i>&nbsp;Save</button>
                                            </div>
                                        </div>
                                         <div class="form-group row">
                                         </div>
                                        <div class="form-group row">
                                            <label for="txtFullName" class="col-sm-2 lbl-text-right">Full Name</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtFullName" id="txtFullName" placeholder="Full Name" title="enter your Full Name.">
                                            </div>
                                            <label for="drpSex" class="col-sm-2 lbl-text-right">Sex</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpSex">
                                                    <option>Male</option>
                                                    <option>Female</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label for="txtFirstName" class="col-sm-2 lbl-text-right">First Name</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtFullName" id="txtFirstName" placeholder="First Name" title="enter your First Name.">
                                            </div>
                                            <label for="txtLastName" class="col-sm-2 lbl-text-right">Last Name</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtLastName" id="txtLastName" placeholder="Last Name" title="enter your Last Name." />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label for="txtSurName" class="col-sm-2 lbl-text-right">Sur Name</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtSurName" id="txtSurName" placeholder="Sur Name" title="enter your Sur Name." />
                                            </div>
                                            <label for="txtContactPerson" class="col-sm-2 lbl-text-right">Contact Person</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtContactPerson" id="txtContactPerson" placeholder="Contact Person" title="enter Contact Person Name." />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label for="txtBirthDate" class="col-sm-2 lbl-text-right">Birth Date</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtBirthDate" id="txtBirthDate" placeholder="Birth Date" title="enter Birth Date." />
                                            </div>
                                            <label for="txtOpenDate" class="col-sm-2 lbl-text-right">Open Date</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtOpenDate" id="txtOpenDate" placeholder="Open Date" title="enter Open Date." />
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label for="txtAddress1" class="col-sm-2 lbl-text-right">Address 1</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtAddress1" id="txtAddress1" placeholder="Address 1" />
                                            </div>
                                            <label for="txtAddress2" class="col-sm-2 lbl-text-right">Address 2</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtAddress2" id="txtAddress2" placeholder="Address 2" />
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
                                                <select class="form-control" id="drpState">
                                                    <option>Select State</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group row">
                                            <label for="drpCity" class="col-sm-2 lbl-text-right">City</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpCity">
                                                    <option>Select City</option>
                                                </select>
                                            </div>
                                            <label for="txtPin" class="col-sm-2 lbl-text-right">Pin</label>
                                            <div class="col-sm-4">
                                                <input type="number" class="form-control" name="txtPin" id="txtPin" />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtMobile" class="col-sm-2 lbl-text-right">Mobile</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtMobile" id="txtMobile" placeholder="Mobile" title="enter your Mobile Number.">
                                            </div>
                                            <label for="txtPhone" class="col-sm-2 lbl-text-right">Phone</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtPhone" id="txtPhone" placeholder="Phone" title="enter your Phone Number." />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtEmail" class="col-sm-2 lbl-text-right">Email</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtMobile" id="txtEmail" placeholder="Email" title="enter your Email.">
                                            </div>
                                            <label for="txtReferenceNo" class="col-sm-2 lbl-text-right">Reference No</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtReferenceNo" id="txtReferenceNo" placeholder="Reference Number" title="Enter Reference Number." />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtPANNo" class="col-sm-2 lbl-text-right">PAN No</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtPANNo" id="txtPANNo" placeholder="PAN No" title="enter your PAN No.">
                                            </div>
                                            <label for="txtAnnDate" class="col-sm-2 lbl-text-right">Ann Date</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtAnnDate" id="txtAnnDate" placeholder="Ann Date" title="Enter Ann Date." />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="txtRemarks" class="col-sm-2 lbl-text-right">Remarks</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtRemarks" id="txtRemarks" placeholder="Remarks" title="enter Remarks.">
                                            </div>
                                            <label for="txtCustomerCardNo" class="col-sm-2 lbl-text-right">Customer Card No</label>
                                            <div class="col-sm-4">
                                                <input type="text" class="form-control" name="txtCustomerCardNo" id="txtCustomerCardNo" placeholder="Customer Card No" title="Enter Customer Card No." />
                                            </div>
                                        </div>

                                        <div class="form-group row">
                                            <label for="drpSRName" class="col-sm-2 lbl-text-right">SR Name</label>
                                            <div class="col-sm-4">
                                                <select class="form-control" id="drpSRName">
                                                    <option>Select SR Name</option>
                                                </select>
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
                                            <input type="text" class="form-control" name="txtSupplierCode" id="txtSupplierCode" placeholder="Code" />
                                        </div>
                                        <label for="txtSupplierName" class="col-sm-2 lbl-text-right">Name<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                           <input type="text" class="form-control" name="txtSupplierName" id="txtSupplierName" placeholder="Name" />
                                        </div>
                                    </div>
                                     <div class="form-group row">
                                        <label for="drpSupplierType" class="col-sm-2 lbl-text-right">Type<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <select class="form-control" id="drpSupplierType"></select>
                                        </div>
                                        <label for="drpSupplierCategory" class="col-sm-2 lbl-text-right">Category</label>
                                        <div class="col-sm-4">
                                           <select class="form-control" id="drpSupplierCategory"></select>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierCSTNo" class="col-sm-2 lbl-text-right">CST No</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierCode" id="txtSupplierCSTNo" />
                                        </div>
                                        <label for="txtSupplierCSTDate" class="col-sm-2 lbl-text-right">CST Date</label>
                                        <div class="col-sm-4">
                                           <input type="text" class="form-control" name="txtSupplierCSTDate" id="txtSupplierCSTDate" placeholder="CST Date" />
                                        </div>
                                    </div>
                                     <div class="form-group row">
                                        <label for="txtSupplierSTNo" class="col-sm-2 lbl-text-right">ST No</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierSTNo" id="txtSupplierSTNo" />
                                        </div>
                                        <label for="txtSupplierSTDate" class="col-sm-2 lbl-text-right">ST Date</label>
                                        <div class="col-sm-4">
                                           <input type="text" class="form-control" name="txtSupplierSTDate" id="txtSupplierSTDate" placeholder="ST Date" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierGSTINo" class="col-sm-2 lbl-text-right">GSTIN No<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierGSTINo" id="txtSupplierGSTINo" />
                                        </div>
                                        <label for="txtSupplierTINNo" class="col-sm-2 lbl-text-right">TIN No</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierTINNo" id="txtSupplierTINNo" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierVATNo" class="col-sm-2 lbl-text-right">VAT No<span style="color:red">*</span></label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierVATNo" id="txtSupplierVATNo" />
                                        </div>
                                        <label for="txtSupplierVATLess" class="col-sm-2 lbl-text-right">Less(VATAV)%</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierVATLess" id="txtSupplierVATLess" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierPANNo" class="col-sm-2 lbl-text-right">PAN No</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierPANNo" id="txtSupplierPANNo" />
                                        </div>
                                        <label for="txtSupplierMarkUp" class="col-sm-2 lbl-text-right">Mark Up%</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierMarkUp" id="txtSupplierMarkUp" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtSupplierMarkDown" class="col-sm-2 lbl-text-right">Mark Down%</label>
                                        <div class="col-sm-4">
                                            <input type="number" class="form-control" name="txtSupplierMarkDown" id="txtSupplierMarkDown" />
                                        </div>
                                        <label for="txtSupplierCreditDays" class="col-sm-2 lbl-text-right">Credit Days</label>
                                        <div class="col-sm-4">
                                           <input type="number" class="form-control" name="txtSupplierCreditDays" id="txtSupplierCreditDays" />
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <!--/tab-pane-->
                        </div>
                        <!--/tab-content-->
                    </div>
                </div>
            </div>

        </div>
    </div><!--/row-->

   
</asp:Content>
