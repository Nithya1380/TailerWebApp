<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="EmployeeList.aspx.cs" Inherits="TailerApp.UI.Tailer.EmployeeList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("EmplListController", function ($scope, $window, $http, $rootScope) {
            $scope.EmployeeList = {};

            $scope.init = function () {
                $scope.EmployeeList = {};
                $scope.GetEmployeeList();
            };

            $scope.GetEmployeeList = function () {
                $scope.EmployeeList = {};

                $http({
                    method: "POST",
                    url: "EmployeeList.aspx/GetEmployeeList",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.EmployeeList = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.AddModifyEmployeeClick = function (Employee) {
                $window.location.href = "EmployeeMaster.aspx?EmployeeID=" + Employee;
                return false;
            };
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="EmplListController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="AddModifyEmployeeClick(0);"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
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
                                    <th>Position</th>
                                    <th>Mobile</th>
                                    <th>Home Phone</th>
                                    <th>Email</th>
                                    <th>Address</th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="Employee in EmployeeList">
                                <tr>
                                    <td><a href="#" data-ng-click="AddModifyEmployeeClick(Employee.EmployeeMasterID)">{{Employee.EmployeeName}}</a></td>
                                    <td>{{Employee.Position}}</td>
                                    <td>{{Employee.MobileNo}}</td>
                                    <td>{{Employee.HomePhoneNo}}</td>
                                    <td>{{Employee.EmailID}}</td>
                                    <td>{{Employee.Address1}} {{Employee.Address2}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>