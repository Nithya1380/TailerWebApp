<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="MeasurementField.aspx.cs" Inherits="TailerApp.UI.Tailer.MeasurementField" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("MeasurFieldController", function ($scope, $window, $http, $rootScope) {
            $scope.MeasurField = {};

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

            $scope.AddNewMeasurementField = function () {

            }

            $scope.movedown = function (obj, i) {
                debugger
                obj.Measur.OrderBy = obj.Measur.OrderBy + 1;
            }

            $scope.moveup = function (obj, i) {
                debugger
                obj.Measur.OrderBy = obj.Measur.OrderBy - 1;
            }

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="MeasurFieldController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-3 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="SaveMeasurementField();"><i class="fas fa-plus-square"></i>&nbsp;Save</button>
                <button class="btn btn-lg btn-success" type="button" data-ng-click="AddNewMeasurementField();"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th style="width:40%">Field Name</th>
                                    <th style="width:40%">Rrepeat</th>
                                    <th style="width:5%"></th>
                                    <th style="width:5%"></th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="Measur in MeasurField | orderBy : 'OrderBy'">
                                <tr>
                                    <td><input type="text" maxlength="50" class="form-control"  ng-model="Measur.FieldName" style="width:70%" /></td>
                                    <td><input type="checkbox" ng-model="Measur.isRrepeat" /></td>
                                    <td><a ng-show="!$last" ng-click="movedown(this, $index)"><i class="fa fa-angle-down" style="font-size:36px"></i></a></td>
                                    <td><a ng-show="!$first" ng-click="moveup(this, $index)"><i class="fa fa-angle-up" style="font-size:36px"></i></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>

