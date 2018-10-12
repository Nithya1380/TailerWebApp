<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateInvoice.aspx.cs" Inherits="TailerApp.UI.Tailer.CreateInvoice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/angular-datepicker.js"></script>
    <style type="text/css">
        .scrollable0panel{
            max-height: 500px;
            overflow: auto;
            min-height:300px;
        }
    </style>
     <script type="text/javascript">
         var tailerApp = angular.module("TailerApp", []);
         tailerApp.controller("CreateInvoiceController", function ($scope, $window, $http, $rootScope) {
             $scope.InvoiceList = [];

             $scope.AddItem = function () {
                 var invoice = {
                     ItemCode: "",
                     ItemDescription: "",
                     ItemQuantity: "1",
                     ItemPrice: "",
                     ItemDiscount: "",
                     GST: "",
                     SGST: "",
                     AmountPending:""
                 }

                 $scope.InvoiceList.push(invoice);
             }

             $scope.RemoveItem = function () {
                 $scope.InvoiceList.pop();
             }

         });
     </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="CreateInvoiceController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
             <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table style="width:100%" class="profile_table">
                            <tbody>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Series:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <select id="drplst_Series" class="form-control-Multiple" style="width: 150px;">
                                                <option>None</option>
                                            </select>
                                        </span>
                                        <button class="btn btn-sm btn-success" type="button" title="Normal">
                                              <i class="fa fa-dot-circle-o" aria-hidden="true"></i>
                                            </button>
                                    </td>
                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Mobile:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Bill#:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Customer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 70%; margin-left: 5px;" maxlength="50" />
                                           <button class="btn btn-sm btn-success" type="button" title="Order">
                                               <i class="fa fa-address-card-o" aria-hidden="true"></i>
                                            </button>
                                         </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Trail Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
                                            <button class="btn btn-sm btn-success" type="button" title="Book">
                                                <i class="fa fa-book" aria-hidden="true"></i>
                                            </button>
                                        </span>
                                    </td>
                                    <td colspan="4" rowspan="2">
                                        <span style="text-align:right;font-weight:bold;font-size:20px;float:right">
                                            0.00
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Sales Rep:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 95%; margin-left: 5px;" maxlength="50" />
                                        </span>
                                        
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Delivery Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
                                           <button class="btn btn-sm btn-success" type="button" title="Refresh">
                                                <i class="fa fa-refresh" aria-hidden="true"></i>
                                            </button>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Master:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 95%; margin-left: 5px;" maxlength="50" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Designer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 95%; margin-left: 5px;" maxlength="50" />
                                        </span>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!--end of card-->
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#ItemTab">Item</a></li>
                                <li><a data-toggle="tab" href="#CreditCardTab">Credit Card</a></li>
                                <li><a data-toggle="tab" href="#TaxTab">Tax</a></li>
                                <li><a data-toggle="tab" href="#BarCodeTab">Bar Code</a></li>
                                <li><a data-toggle="tab" href="#PhotoTab">Photo</a></li>
                                <li><a data-toggle="tab" href="#FollowupBarCodeTab">Followup Bar Code</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active" id="ItemTab">
                                    <div class="row scrollable0panel" >
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>Item Code</th>
                                                    <th>Item Description</th>
                                                    <th>Quantity</th>
                                                    <th>Rate</th>
                                                    <th>Disc(%) & Amt</th>
                                                    <th>I/C GST</th>
                                                    <th>SGST</th>
                                                    <th>Amount Pend</th>
                                                </tr>
                                            </thead>
                                            <tbody data-ng-repeat="Invoice in InvoiceList">
                                                <tr>
                                                    <td><input type="text" data-ng-model="Invoice.ItemCode" class="form-control" style="width: 50px;" /> </td>
                                                    <td><input type="text" data-ng-model="Invoice.ItemDescription" class="form-control" style="width: 150px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemQuantity" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemPrice" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemDiscount" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.GST" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.SGST" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.AmountPending" class="form-control" style="width: 100px;" /></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <div>
                                            <button class="btn btn-sm btn-success" type="button" data-ng-click="AddItem();"><i class="fa fa-plus-circle"></i></button>
                                            <button class="btn btn-sm btn-success" type="button" data-ng-click="RemoveItem();"><i class="fa fa-minus-circle"></i></button>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <table style="width:100%" class="profile_table">
                                            <tbody>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Payment:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Other Less & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select id="drplst_OtherLessRs" class="form-control-Multiple" style="width: 150px;">
                                                                <option>None</option>
                                                            </select>
                                                            <input type="number" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" />
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Less(%) & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <input type="number" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 80px; margin-left: 5px;"  />
                                                            <input type="number" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 150px; margin-left: 5px;"  />
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Remarks:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Tax:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select id="drplst_Tax" class="form-control">
                                                                <option></option>
                                                            </select>
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Net Amount:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="tab-pane" id="CreditCardTab">
                                </div>
                                <div class="tab-pane" id="TaxTab">
                                </div>
                                <div class="tab-pane" id="BarCodeTab">
                                </div>
                                <div class="tab-pane" id="PhotoTab">
                                </div>
                                <div class="tab-pane" id="FollowupBarCodeTab">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
