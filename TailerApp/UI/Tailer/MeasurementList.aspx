<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="MeasurementList.aspx.cs" Inherits="TailerApp.UI.Tailer.MeasurementList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("MeasurListController", function ($scope, $window, $http, $rootScope) {
            $scope.MeasurList = {};

            $scope.init = function () {
                $scope.MeasurList = {};
                $scope.GetMeasurementList();
            };

            $scope.GetMeasurementList = function () {
                $scope.MeasurList = {};

                $http({
                    method: "POST",
                    url: "MeasurementList.aspx/GetMeasurementList",
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

                    $scope.MeasurList = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.AddModifyMeasureClick = function (Measur) {
                $window.location.href = "Measurement.aspx?MeasurementID=" + Measur;
                return false;
            };
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="MeasurListController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-3 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="GetMeasurementList();"><i class="fas fa-plus-square"></i>&nbsp;Display</button>
                <button class="btn btn-lg btn-success" type="button" data-ng-click="AddModifyMeasureClick(0);"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Account Name</th>
                                    <th>Item Desc</th>
                                    <th>Created Date</th>
                                    <th>Trial Date</th>
                                    <th>Delivery Date</th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="Measur in MeasurList">
                                <tr>
                                    <td><a href="#" data-ng-click="AddModifyMeasureClick(Measur.MeasurementMasterID)">{{Measur.AccountName}}</a></td>
                                    <td>{{Measur.ItemDesc}}</td>
                                    <td>{{Measur.MeasCreatedOn}}</td>
                                    <td>{{Measur.TrialDate}}</td>
                                    <td>{{Measur.DeliDate}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
