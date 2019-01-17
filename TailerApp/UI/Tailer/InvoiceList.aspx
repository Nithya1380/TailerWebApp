<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InvoiceList.aspx.cs" Inherits="TailerApp.UI.Tailer.InvoiceList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/angular-datepicker.js"></script>
    <style type="text/css">
        .DatePickerInLine {
            display: inline !important;
        }
    </style>
    <script type="text/javascript">
        var g_ContextFrom = '<%=FromPage%>';
        var g_InvoiceDateFrom = '<%=InvoiceDateFrom%>';
        var g_InvoiceDateTo = '<%=InvoiceDateTo%>';
        var g_DeleveryDate = '<%=DeleveryDate%>';
        var roleScop = "<%=CURRENT_USER.rolescope%>";
        $(document).ready(function () {
            if (roleScop.indexOf('12,') >= 0)
                $("#btn_CreateNewInvoice").show();
            else
                $("#btn_CreateNewInvoice").hide();
        });

        var tailerApp = angular.module("TailerApp", ['720kb.datepicker']);
        tailerApp.controller("InvoiceListController", function ($scope, $window, $http, $rootScope) {
            $scope.InvoiceList = [];
            $scope.DeleteEnabled = true;
            $scope.InvoiceStartDate = '';
            $scope.InvoiceTotDate = '';
            $scope.InvoiceDeleverytDate = '';
            $scope.SelectAll = false;

            $scope.init = function () {
                $scope.SelectAll = false;
                $scope.InvoiceStartDate = g_InvoiceDateFrom;
                $scope.InvoiceTotDate = g_InvoiceDateTo;
                $scope.InvoiceDeleverytDate = g_DeleveryDate;
                $scope.InvoiceList = [];
                $scope.GetInvoiceList();
            };

            $scope.GetInvoiceList = function () {
                $scope.InvoiceList = [];
                $scope.Total_BasePrice = 0;
                $scope.Total_GST = 0;
                $scope.Total_SGST = 0;
                $scope.Total_NetAmount = 0;

                if ($scope.InvoiceStartDate == undefined || $scope.InvoiceStartDate == null)
                    $scope.InvoiceStartDate = '';

                if ($scope.InvoiceTotDate == undefined || $scope.InvoiceTotDate == null)
                    $scope.InvoiceTotDate = '';

                if ($scope.InvoiceDeleverytDate == undefined || $scope.InvoiceDeleverytDate == null)
                    $scope.InvoiceDeleverytDate = '';

                $http({
                    method: "POST",
                    url: "InvoiceList.aspx/GetInvoiceList",
                    data: { invoiceDateFrom: $scope.InvoiceStartDate, invoiceDateTo: $scope.InvoiceTotDate, deleveryDate: $scope.InvoiceDeleverytDate },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {

                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.InvoiceList = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {
                    try {

                    } catch (e) {
                        alert(e);
                    }
                });
            };


            $scope.onCustomerInvoiceClick = function (CustomerMasterID) {
                $window.location.href = "CreateInvoice.aspx?CustomerID=" + CustomerMasterID;
            };

            $scope.onCustomerInvoiceDetailsClick = function (invoiceID) {
                var left = (screen.width / 2) - (1100 / 2);
                var top = (screen.height / 2) - (600 / 2);
                $window.open("InvoiceDetails.aspx?InvoiceID=" + invoiceID, "InvoiceDetails", 'resizable=yes,location=1,status=1,scrollbars=1,width=1100,height=600,top=' + top + ', left=' + left);
                return false;
            };

            $scope.onPrintInvoiceDetailsClick = function (InvoiceID) {
                var left = (screen.width / 2) - (1100 / 2);
                var top = (screen.height / 2) - (600 / 2);
                $window.open("PrintInvoiceDetails.aspx?InvoiceID=" + InvoiceID, "PrintInvoiceDetails", 'resizable=yes,location=1,status=1,scrollbars=1,width=1100,height=600,top=' + top + ', left=' + left);
                return false;
            };

            $scope.onCheckBoxClick = function () {
                console.log($scope.SelectAll);
                if ($scope.SelectAll) {

                    $scope.InvoiceFilteredList.forEach(function (option) {
                        option.Selected = true;
                    });
                }
                else {
                    $scope.InvoiceFilteredList.forEach(function (option) {
                        option.Selected = false;
                    });
                }
            };

            $scope.onCustomerInvoiceDeleteClick = function () {
                var invoiceIds = '';

                $scope.InvoiceFilteredList.forEach(function (option) {
                    if (option.Selected)
                        invoiceIds += option.InvoiceID + ',';
                });

                if (invoiceIds == '') {
                    alert('Please select atleat one Invoice to delete.');
                    return false;
                }

                if (!confirm('You are about to delete selected Invoice(s). Do you want to continue?'))
                    return false;

                $http({
                    method: "POST",
                    url: "InvoiceList.aspx/DeleteInvoice",
                    data: { invoiceIds: invoiceIds },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    alert('Selected Invoice(s) deleted successfully!');
                    $scope.GetInvoiceList();

                }, function onFailure(error) {
                    alert(error);
                });
            };

        });

        function RefreshinvoiceList() {
            angular.element(document.getElementById('divMainContent')).scope().GetInvoiceList();
            // displayVendorList(vendorId);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="InvoiceListController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Invoice List
            </div>
        </div>

        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div style="float: left;">
                        <table style="width: 100%; max-width: 600px;">
                            <tbody>
                                <tr>
                                    <td>
                                        <table style="width: 100%">
                                            <tr>
                                                <td><span>Invoice Date:</span> </td>
                                                <td>
                                                    <datepicker date-format="dd/MM/yyyy">
                                                      <input type="text" data-ng-model="InvoiceStartDate" id="txtInvoiceDateFrom"  class="form-control" style="width: 100px; margin-left: 5px;" maxlength="15" required />
                                                    </datepicker>
                                                </td>
                                                <td>
                                                    <span>&nbsp;To:</span>
                                                </td>
                                                <td>
                                                    <datepicker date-format="dd/MM/yyyy">
                                                     <input type="text" data-ng-model="InvoiceTotDate" id="txtInvoiceDateTo"  class="form-control" style="width: 100px; margin-left: 5px;" maxlength="15" required />
                                                    </datepicker>
                                                </td>
                                                <td>
                                                    <span>&nbsp;Delevery Date:</span>
                                                </td>
                                                <td>
                                                    <datepicker date-format="dd/MM/yyyy">
                                                      <input type="text" data-ng-model="InvoiceDeleverytDate" id="txtDeleveryDate"  class="form-control" style="width: 100px; margin-left: 5px;" maxlength="15" required />
                                                     </datepicker>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Search:<input type="text" class="form-control" style="width: 300px; margin-left: 5px; display: inline !important" maxlength="50" data-ng-model="search.$"
                                        placeholder="Search By Invoice# or Mobile or Name or Amount" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="button_div" style="float: right; max-width: 300px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="GetInvoiceList();">Display</button>
                        <button class="btn_ss bg-blue" type="button" id="btn_CreateNewInvoice" data-ng-click="onCustomerInvoiceClick(0);">Add New</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-disabled="!DeleteEnabled" data-ng-click="onCustomerInvoiceDeleteClick();">Delete</button>
                    </div>
                    <table class="table card_table">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" id="chk_InvoiceHead" data-ng-change="onCheckBoxClick()" data-ng-model="SelectAll" /></th>
                                <th>Invoice#</th>
                                <th>Name</th>
                                <th>Mobile</th>
                                <th>Date</th>
                                <th>Master</th>
                                <th>Designer</th>
                                <th>Base Price</th>
                                <th>CGST</th>
                                <th>SGST</th>
                                <th>Amount</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody data-ng-repeat=" Invoice in InvoiceFilteredList=(InvoiceList | filter:search:strict)">
                            <tr>
                                <td>
                                    <input type="checkbox" id="chk_InvoiceLine" data-ng-model="Invoice.Selected" />
                                </td>
                                <td>{{Invoice.BillNumber}}</td>
                                <td>{{Invoice.CustomerName}}</td>
                                <td>{{Invoice.MobileNumber}}</td>
                                <td>{{Invoice.InvoiceDate}}</td>
                                <td>{{Invoice.MasterName}}</td>
                                <td>{{Invoice.DesignerName}}</td>
                                <td style="text-align:right" ng-init="$parent.Total_BasePrice=$parent.Total_BasePrice+Invoice.BasePrice">{{Invoice.BasePrice | currency : ''}}</td>
                                <td style="text-align:right" ng-init="$parent.Total_GST=$parent.Total_GST+Invoice.GST">{{Invoice.GST | currency : ''}}</td>
                                <td style="text-align:right" ng-init="$parent.Total_SGST=$parent.Total_SGST+Invoice.SGST">{{Invoice.SGST | currency : ''}}</td>
                                <td style="text-align:right" ng-init="$parent.Total_NetAmount=$parent.Total_NetAmount+Invoice.NetAmount">{{Invoice.NetAmount | currency : ''}}</td>
                                <td>
                                    <a href="#" title="Invoice Details" data-ng-click="onCustomerInvoiceDetailsClick(Invoice.InvoiceID)"><i class="fa fa-info-circle" style="font-size: 24px;"></i></a>
                                    <a href="#" title="Invoice Details" data-ng-click="onPrintInvoiceDetailsClick(Invoice.InvoiceID)"><i class="fa fa-print" style="font-size: 24px;"></i></a>
                                </td>
                            </tr>
                        </tbody>
                        <tfoot>
                            <tr>
                                <th colspan="7" style="text-align:right"> Total: </th>
                                <th style="text-align:right">{{Total_BasePrice | currency : ''}}</th>
                                <th style="text-align:right">{{Total_GST | currency : ''}}</th>
                                <th style="text-align:right">{{Total_SGST | currency : ''}}</th>
                                <th style="text-align:right">{{Total_NetAmount | currency : ''}}</th>
                                <th></th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
