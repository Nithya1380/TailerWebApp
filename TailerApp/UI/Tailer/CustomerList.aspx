﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CustomerList.aspx.cs" Inherits="TailerApp.UI.Tailer.CustomerList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/angular-datepicker.js"></script>
    <script type="text/javascript">
        var g_BirthDate = '<%=BirthDate%>';
        var roleScop = "<%=CURRENT_USER.rolescope%>"; 
        var g_createInvoicePermission = false;
        $(document).ready(function () {
              if (roleScop.indexOf('12,') >= 0)
                g_createInvoicePermission = true;
            else
               g_createInvoicePermission = false;

              
        });
        var tailerApp = angular.module("TailerApp", ['720kb.datepicker']);
        tailerApp.controller("CustomerListController", function ($scope, $window, $http, $rootScope) {
            $scope.CustomerList = {};
            $scope.CreateInvoicePerm = false;
            $scope.BirthDate = '';

            $scope.init = function () {
                $scope.CreateInvoicePerm = g_createInvoicePermission;
                $scope.BirthDate = g_BirthDate;
                $scope.CustomerList = {};
                $scope.GetCustomerList();
            };

            $scope.GetCustomerList = function () {
                $scope.CustomerList = {};

                if ($scope.BirthDate == undefined || $scope.BirthDate == null)
                    $scope.BirthDate = '';
            
                $http({
                    method: "POST",
                    url: "CustomerList.aspx/GetCustomerList",
                    data: { BirthDate: $scope.BirthDate },
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
                if (!g_createInvoicePermission)
                    return false;

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
            <div class="page-header-new col-lg-12">
                Customer List
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div style="float: left;">
                        <table style="width: 100%; max-width: 600px;">
                            <tr>
                                <td>
                                    <span>&nbsp;Birth Date:</span>
                                </td>
                                <td>
                                    <datepicker date-format="dd/MM/yyyy">
                                        <input type="text" data-ng-model="BirthDate" id="txtBirthDate"  class="form-control" style="width: 100px; margin-left: 5px;" maxlength="15"  />
                                    </datepicker>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div class="button_div" style="float:right;max-width:300px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="GetCustomerList();">Display</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-click="OnAddNewCustomerClick();">Add Customer</button>
                    </div>
                    <table class="table card_table">
                        <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Account Code</th>
                                    <th>DOB</th>
                                    <th>Mobile</th>
                                    <th ng-if="false">Home Phone</th>
                                    <th ng-if="false">Email</th>
                                    <th ng-if="false">Address</th>
                                    <th></th>
                                </tr>
                            </thead>
                           <tbody data-ng-repeat="customer in CustomerList">
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
</asp:Content>
