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
                        alert(response.d.ErrorMessage);
                        return false;
                    }

                    $scope.CustomerList =JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.onCustomerClick = function (CustomerMasterID) {
                alert(CustomerMasterID);
            };
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" ng-app="TailerApp" ng-controller="CustomerListController" ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" ng-click="GetCustomerList();"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
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
                                    <th>Mobile</th>
                                    <th>Home Phone</th>
                                    <th>Email</th>
                                    <th>Address</th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="customer in CustomerList">
                                <tr>
                                    <td><a href="#" ng-click="onCustomerClick({{customer.CustomerMasterID}})">{{customer.CustomerName}}</a></td>
                                    <td>{{customer.MobileNo}}</td>
                                    <td>{{customer.HomePhoneNo}}</td>
                                    <td>{{customer.EmailID}}</td>
                                    <td>{{customer.Address1}} {{customer.Address2}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
