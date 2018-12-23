<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InvoiceList.aspx.cs" Inherits="TailerApp.UI.Tailer.InvoiceList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
     <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("InvoiceListController", function ($scope, $window, $http, $rootScope) {
            $scope.InvoiceList = {};

            $scope.init = function () {
                $scope.InvoiceList = {};
                $scope.GetInvoiceList();
            };

            $scope.GetInvoiceList = function () {
                $scope.InvoiceList = {};

                $http({
                    method: "POST",
                    url: "InvoiceList.aspx/GetInvoiceList",
                    data: {},
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
                                    <td >Search:<input type="text" class="form-control" style="width: 300px; margin-left: 5px; display: inline !important" maxlength="50" data-ng-model="search.$"
                                        placeholder="Search By Invoice# or Mobile or Name or Amount" />
                                    </td>

                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="button_div" style="float: right; max-width: 200px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="GetInvoiceList();">Display</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-click="onCustomerInvoiceClick(0);">Add New</button>
                    </div>
                    <table class="table card_table">
                        <thead>
                            <tr>
                                <th>Invoice#</th>
                                <th>Name</th>
                                <th>Mobile</th>
                                <th>Date</th>
                                <th>Master</th>
                                <th>Designer</th>
                                <th>Amount</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody data-ng-repeat="Invoice in InvoiceList | filter:search:strict">
                            <tr>
                                <td>{{Invoice.BillNumber}}</td>
                                <td>{{Invoice.CustomerName}}</td>
                                <td>{{Invoice.MobileNumber}}</td>
                                <td>{{Invoice.InvoiceDate}}</td>
                                <td>{{Invoice.MasterName}}</td>
                                <td>{{Invoice.DesignerName}}</td>
                                <td>{{Invoice.NetAmount}}</td>
                                <td><a href="#" title="Invoice Details" data-ng-click="onCustomerInvoiceDetailsClick(Invoice.InvoiceID)"><i class="fa fa-info-circle" style="font-size: 24px;"></i></a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
