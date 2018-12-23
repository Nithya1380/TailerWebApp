<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="MeasurementList.aspx.cs" Inherits="TailerApp.UI.Tailer.MeasurementList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/angular-datepicker.js"></script>
    <link href="../../Scripts/CalendarControl.css" rel="stylesheet" />
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/ui-bootstrap-tpls-1.3.2.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", ['720kb.datepicker', 'ui.bootstrap']);
        tailerApp.controller("MeasurListController", function ($scope, $window, $http, $rootScope) {
            $scope.MeasurList = {};
            //$scope.AccountCode = "";

            var d = new Date();

            $scope.DeliveryFrom = d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear();

            d.setDate(d.getDate() + 15)

            $scope.DeliveryTo = d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear();

            $scope.init = function () {
                $scope.MeasurList = {};
                $scope.GetMeasurementList();
            };

            $scope.GetMeasurementList = function () {
                $scope.MeasurList = {};
                var AccountMasterID = "";

                if ($scope.AccountCode != undefined)
                    AccountMasterID = $scope.AccountCode.AccountCode;

                $scope.AccountName = $scope.AccountName || "";
                $scope.DeliveryFrom = $scope.DeliveryFrom || "";
                $scope.DeliveryTo = $scope.DeliveryTo || "";

                $http({
                    method: "POST",
                    url: "MeasurementList.aspx/GetMeasurementList",
                    data: { AccountCode: AccountMasterID, AccountName: $scope.AccountName, DeliveryFrom: $scope.DeliveryFrom, DeliveryTo: $scope.DeliveryTo },
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

            $scope.AccountList = {};

            $scope.GetAccountList = function () {
                $scope.AccountList = {};

                $http({
                    method: "POST",
                    url: "MeasurementList.aspx/GetAccountList",
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

                    $scope.AccountList = JSON.parse(response.data.d.JSonstring);


                }, function onFailure(error) {

                });
            };

            $scope.GetAccountList();

            $scope.onSelect = function ($item, $model, $label, Obj) {
                return false;
            }

        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="MeasurListController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Measurement List
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="col-lg-9 pull-left">
                        <table style="width: 100%; max-width: 600px; margin-bottom:20px;">
                            <tbody>
                                <tr>
                                    <td style="text-align: right;">Account code:</td>
                                    <td>
                                        <input type="text" placeholder="Account code" class="form-control"
                                            style="max-width: 220px;" ng-model="AccountCode"
                                            typeahead-on-select="onSelect($item, $model, $label, this);"
                                            uib-typeahead="Account as Account.AccountCode for Account in AccountList |  filter:{name:$viewValue} | limitTo:10"
                                            typeahead-show-hint="true" typeahead-min-length="0" class="web_txtbox" />
                                    </td>
                                    <td style="text-align: right;">Account Name:</td>
                                    <td>
                                        <input type="text" placeholder="Account name" class="form-control" ng-model="AccountName" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right;">Delivery from:</td>
                                    <td colspan="3">
                                        <table>
                                            <tr>
                                                <td>
                                                    <datepicker date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                                    <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="DeliveryFrom" 
						                                    style="width:110px;"/> 
				                                    </datepicker>
                                                </td>
                                                <td>To</td>
                                                <td>
                                                    <datepicker date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                                    <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="DeliveryTo" 
						                                    style="width:110px;"/> 
				                                    </datepicker>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>

                            </tbody>
                        </table>
                    </div>
                    <div class="button_div" style="float: right; max-width: 200px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="GetMeasurementList();">Display</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-click="AddModifyMeasureClick(0);">Add New</button>
                    </div>
                    <table class="table card_table table-hover">
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
</asp:Content>
