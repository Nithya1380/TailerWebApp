<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="MeasurementField.aspx.cs" Inherits="TailerApp.UI.Tailer.MeasurementField" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("MeasurFieldController", function ($scope, $window, $http, $rootScope) {
            $scope.MeasurField = {};
            $scope.ItemGroupPickLists = {};

            $scope.init = function () {
                $scope.MeasurField = {};
                //$scope.GetMeasurementField();
            };

            $scope.GetMeasurementField = function () {
                $scope.MeasurField = {};

                $http({
                    method: "POST",
                    url: "MeasurementField.aspx/GetMeasurementField",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.MeasurField = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {
                    debugger
                });
            };


            $scope.GetItemGroups = function () {
                $scope.ItemGroupPickLists = {};

                $http({
                    method: "POST",
                    url: "MeasurementField.aspx/GetItemGroups",
                    data: {},
                    dataType: "json",
                    headers: { contentType: "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.ItemGroupPickLists = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.GetItemGroups();

            $scope.GetMeasurementField();

            $scope.SaveMeasurementField = function () {
                var MeasurField = JSON.stringify($scope.MeasurField);

                $http({
                    method: "POST",
                    url: "MeasurementField.aspx/SaveMeasurementField",
                    data: { MeasurField: MeasurField },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }
                    $window.alert('Save Succesfully');
                    $scope.GetMeasurementField();

                }, function onFailure(error) {

                });
            };


            $scope.movedown = function (order) {
                $scope.MeasurField.forEach(function (item, index) {
                    if (item.OrderBy == order)
                        $scope.MeasurField[index].OrderBy = order + 1;
                    else if (item.orderby == order + 1)
                        $scope.MeasurField[index].OrderBy = item.OrderBy - 1;

                });
            }

            $scope.moveup = function (order) {
                $scope.MeasurField.foreach(function (item, index) {
                    if (item.OrderBy == order)
                        $scope.MeasurField[index].OrderBy = order - 1;
                    else if (item.OrderBy == order - 1)
                        $scope.MeasurField[index].OrderBy = item.OrderBy + 1;

                });
            }

            $scope.AddNewMeasurementField = function () {
                var or = $scope.MeasurField.length + 1;
                $scope.MeasurField.push({ FieldName: '', MeasurementFieldID: 0, isRrepeat: false, OrderBy: or });
            }

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="MeasurFieldController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Measurement Field
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="button_div" style="float: right; max-width: 200px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="SaveMeasurementField();">Save</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-click="AddNewMeasurementField();">Add New</button>
                    </div>
                    <table class="table table-hover card_table">
                        <thead>
                            <tr>
                                <th style="width: 40%">Field Name</th>
                                <th style="width: 40%">Item Group</th>
                                <th style="width: 40%">Rrepeat</th>
                                <th style="width: 5%"></th>
                                <th style="width: 5%"></th>
                            </tr>
                        </thead>
                        <tbody ng-repeat="Measur in MeasurField | orderBy : 'OrderBy'">
                            <tr>
                                <td>
                                    <input type="text" maxlength="50" class="form-control" ng-model="Measur.FieldName" style="width: 70%" /></td>
                                <td>
                                    <select class="form-control" style="width: 40%" data-ng-model="Measur.ItemGroup"
                                        data-ng-options="option.PickListLabel for option in ItemGroupPickLists track by option.PickListValue">
                                        <option value="">Select Group</option>
                                    </select>
                                </td>
                                <td>
                                    <input type="checkbox" ng-model="Measur.isRrepeat" /></td>
                                <td><a ng-show="!$last" ng-click="movedown(Measur.OrderBy)"><i class="fa fa-angle-down" style="font-size: 36px"></i></a></td>
                                <td><a ng-show="!$first" ng-click="moveup(Measur.OrderBy)"><i class="fa fa-angle-up" style="font-size: 36px"></i></a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
</asp:Content>

