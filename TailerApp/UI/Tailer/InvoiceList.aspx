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
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-4 col-md-4 col-sm-2 pull-right" style="margin-bottom:5px;">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="GetInvoiceList();"><i class="fas fa-plus-square"></i>&nbsp;Display</button>
                <button class="btn btn-lg btn-success" type="button" data-ng-click="onCustomerInvoiceClick(0);"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Invoice#</th>
                                    <th>Name</th>
                                    <th>Date</th>
                                    <th>Master</th>
                                    <th>Designer</th>
                                    <th>Amount</th>
                                    
                                </tr>
                            </thead>
                            <tbody data-ng-repeat="Invoice in InvoiceList">
                                <tr>
                                    <td>{{Invoice.BillNumber}}</td>
                                    <td>{{Invoice.CustomerName}}</td>
                                    <td>{{Invoice.InvoiceDate}}</td>
                                    <td>{{Invoice.MasterName}}</td>
                                    <td>{{Invoice.DesignerName}}</td>
                                    <td>{{Invoice.NetAmount}}</td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
