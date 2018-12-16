<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerList.aspx.cs" Inherits="TailerApp.UI.Tailer.CustomerList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("CustomerListController", function ($scope, $window, $http, $rootScope) {
            $scope.CustomerList = {};

            $scope.init = function () {
                $scope.CustomerList = {};
                $scope.GetCustomerList();
            };

            $scope.GetCustomerList = function () {
                 $scope.CustomerList = {};
            
                $http({
                    method: "POST",
                    url: "CustomerList.aspx/GetCustomerList",
                    data:{},
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

                    $scope.CustomerList =JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.onCustomerClick = function (CustomerMasterID) {
                $window.location.href = "AccountMaster.aspx?CustomerID=" + CustomerMasterID;
            };

            $scope.onCustomerInvoiceClick = function (CustomerMasterID) {
                $window.location.href = "CreateInvoice.aspx?CustomerID=" + CustomerMasterID;
            };

            $scope.OnAddNewCustomerClick = function () {
                var left = (screen.width / 2) - (850 / 2);
                var top = (screen.height / 2) - (500 / 2);
                $window.open("AddNewCustomer.aspx?contextFrom=1", "AddCustomer", 'resizable=yes,location=1,status=1,scrollbars=1,width=850,height=500,top=' + top + ', left=' + left);
                return false;
            };
        });

        function RefreshCustomerList() {
            angular.element(document.getElementById('divMainContent')).scope().GetCustomerList();
            // displayVendorList(vendorId);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="CustomerListController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="OnAddNewCustomerClick();"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Account Code</th>
                                    <th>DOB</th>
                                    <th>Mobile</th>
                                    <th ng-if="false">Home Phone</th>
                                    <th ng-if="false">Email</th>
                                    <th ng-if="false">Address</th>
                                    
                                </tr>
                            </thead>
                            <tbody ng-repeat="customer in CustomerList">
                                <tr>
                                    <td><a href="#" data-ng-click="onCustomerClick(customer.CustomerMasterID)">{{customer.CustomerName}}</a></td>
                                    <td>{{customer.AccountCode}}</td>
                                    <td>{{customer.BirthDate}}</td>
                                    <td>{{customer.MobileNo}}</td>
                                    <td ng-if="false">{{customer.HomePhoneNo}}</td>
                                    <td ng-if="false">{{customer.EmailID}}</td>
                                    <td ng-if="false">{{customer.Address1}} {{customer.Address2}}</td>
                                    <td><a href="#" title="Create Invoice" data-ng-click="onCustomerInvoiceClick(customer.CustomerMasterID)"><i class="fa fa-dollar" style="font-size:24px;"></i></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
