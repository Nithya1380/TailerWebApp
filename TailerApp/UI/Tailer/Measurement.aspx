﻿<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Measurement.aspx.cs" Inherits="TailerApp.UI.Tailer.Measurement" %>

<asp:Content ID="content_Head" runat="server" ContentPlaceHolderID="HeaderContent">
    <link href="../Style/autocomplete.css" rel="stylesheet" />
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/AngularJS/autocomplete.js"></script>

    <script type="text/javascript" lang="javascript">

        var MeasurementID = "<%=MeasurementID%>";

        var tailerApp = angular.module("TailerApp", ['autocomplete']);
        tailerApp.controller("MeasurementController", function ($scope, $window, $http, $rootScope) {
            $scope.MeasurementID = $window.MeasurementID;
            $scope.MeasurementDetails = {};
            $scope.isDeleted = false;
            $scope.ItemList = {};
            $scope.SelectedItem = { ItemmasterID: 0, ItemDescription: '-Select-' };
            $scope.AccountCode = "";

            $scope.GetMeasurementMaster = function () {
                $scope.MeasurementDetails = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetMeasurementMaster",
                    data: { MeasurMasterID: $scope.MeasurementID },
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

                    $scope.MeasurementDetails = JSON.parse(response.data.d.JSonstring)[0];
                    $scope.AccountCode = $scope.MeasurementDetails.AccountID;

                    $scope.SelectedItem = { ItemmasterID: $scope.MeasurementDetails.ItemID, ItemDescription: '' };

                }, function onFailure(error) {

                });
            };

            $scope.GetItemList = function () {
                $scope.ItemList = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetItemList",
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

                    //$scope.ItemList = JSON.parse(response.data.d.ItemsList);
                    $scope.ItemList = response.data.d.ItemsList;

                }, function onFailure(error) {

                });
            };

            if ($scope.MeasurementID != 0) {
                $scope.GetMeasurementMaster();
            }

            $scope.GetItemList();

            $scope.SaveMeasurementMaster = function () {
                $scope.MeasurementDetails.ItemID = $scope.SelectedItem.ItemmasterID;

                $scope.MeasurementDetails.AccountID = $scope.AccountList.filter(function (x) { return x.AccountCode == $scope.AccountCode })[0].AccountMasterID;

                var MeasurementDetails = JSON.stringify($scope.MeasurementDetails);

                $http({
                    method: "POST",
                    url: "Measurement.aspx/SaveMeasurementMaster",
                    data: { MeasurMasterID: $scope.MeasurementID, MeasurDetails: MeasurementDetails },
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

                    $scope.MeasurementID = response.data.d.OutValue;

                    $window.alert('Save Succesfully');


                }, function onFailure(error) {
                    debugger;
                });
            };

            $scope.onClose = function () {
                $window.location.href = "MeasurementList.aspx";
                return false;
            }

            //**********//
            $scope.AccountList = {};
            $scope.AccountArry = [];

            $scope.GetAccountList = function () {
                $scope.AccountList = {};
                $scope.AccountArry = [];

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetAccountList",
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

                    angular.forEach($scope.AccountList, function (value, key) {
                        $scope.AccountArry.push(value.AccountCode);
                    });

                    debugger
                    $scope.AccountArry.then(function (data) {

                        $scope.AccountArry = data;

                    });

                }, function onFailure(error) {

                });
            };

            $scope.GetAccountList();
           

            //$scope.getmovies = function () {

            //    return $scope.AccountArry;

            //}

            $scope.doSomething = function (typedthings) {
                debugger
                //console.log("Do something like reload data with this: " + typedthings);

                //$scope.newmovies = MovieRetriever.getmovies(typedthings);

                //$scope.newmovies.then(function (data) {

                //    $scope.movies = data;

                //});

            }

            $scope.doSomethingElse = function (suggestion) {
                debugger
                //console.log("Suggestion selected: " + suggestion);

            };

        });
    </script>

    <style>
        .col-sm-1{
            width: 12.33%;
            padding-right: 2px;
            padding-left: 2px; 
        }

        .lbl-text-right{
            text-align:right;
            padding-top:5px;
        }

        .text-sameLine{
            width:50%;
            float:left;
        }

    </style>
    
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" data-ng-controller="MeasurementController">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <div class="row">
                                <div class="col-lg-3 col-md-2 col-sm-3 pull-right">
                                    <button class="client_btn" type="button" ng-click="SaveMeasurementMaster()" data-toggle="dropdown" style="border-color: #00A5A8 !important; background-color: #00B5B8">
                                        <i class="fa fa-save"></i>Save
                                    </button>
                                    <%--<button class="client_btn" type="button" ng-hide="UserID == 0" ng-click="DeleteEmployeeMasterDetails();" data-toggle="dropdown" style="border-color: rgba(212, 63, 58, 1) !important; background-color: rgba(212, 63, 58, 1)">
                                        <i class="fa fa-close"></i>Delete
                                    </button>--%>
                                    <button class="client_btn" type="button" ng-click="onClose();" data-toggle="dropdown" style="border-color: #FFA87D !important; background-color: #FFA87D">
                                        <i class="fa fa-close"></i>Cancel
                                    </button>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12">
                                    <div class="card">
                                        <div class="row">
                                            <table class="profile_table" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Account code:</span></td>
                                                        <td>
                                                            <%--<span class="profileValue">--%>
                                                                <%--<input type="text" data-ng-model="MeasurementDetails.AccountCode" />--%>
                                                                <autocomplete ng-model="AccountCode" attr-placeholder="number" click-activation="true" data="AccountArry" on-Select="doSomethingElse"></autocomplete>
                                                            <%--</span>
                                                            <button title="Normal" class="btn btn-sm btn-success" type="button">
                                                                Refresh
                                                            </button>--%>
                                                        </td>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Measu No:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <input  class="form-control ng-pristine ng-untouched ng-valid ng-empty ng-valid-maxlength" style="width: 95%; margin-left: 5px;" type="text" maxlength="10" data-ng-model="MeasurementDetails.MeasuNo">
                                                            </span>
                                                        </td>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Create Date:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <input name="Debit" class="form-control ng-pristine ng-untouched ng-valid ng-empty ng-valid-maxlength" style="width: 95%; margin-left: 5px;" type="text" maxlength="10" data-ng-model="MeasurementDetails.MeasCreatedOn">
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Account Name:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <input name="Debit" class="form-control-Multiple ng-pristine ng-untouched ng-valid ng-empty ng-valid-maxlength" style="width: 70%; margin-left: 5px;" type="text" maxlength="50" data-ng-model="MeasurementDetails.AccountName">
                                                            </span>
                                                        </td>
                                                        <td>{{result}}</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12">
                                    <div class="card">
                                        <div class="row">
                                            <table class="profile_table" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="back_shade" style="text-align: right;">
                                                            <span class="profileLabel">
                                                                 <select class="form-control"
                                                                    ng-options="option.ItemDescription for option in ItemList track by option.ItemmasterID"
                                                                    ng-model="SelectedItem">
                                                                </select>
                                                            </span>
                                                        </td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <input type="text" data-ng-model="MeasurementDetails.ItemDesc" />
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <div class="form-group row">
                                        <label for="txtFullName" class="col-sm-1 lbl-text-right">Body/Fit</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.BodyFit">
                                        </div>
                                        <label for="txtFullName" class="col-sm-1 lbl-text-right">Remark</label>
                                        <div class="col-sm-4">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.Remark">
                                        </div>
                                        <%--<label for="drpSex" class="col-sm-1 lbl-text-right">Sex</label>
                                        <div class="col-sm-1">
                                            <select class="form-control" ng-model="EmployeeDetails.Gender">
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>--%>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtFullName" class="col-sm-1 lbl-text-right">Length</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text1">
                                        </div>
                                        <label for="txtFullName" class="col-sm-1 lbl-text-right">Soluder</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text2">
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Sleev</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text3">
                                        </div>
                                         <label for="drpSex" class="col-sm-1 lbl-text-right">Trial Date</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.TrialDate">
                                            <%--<input type="number" class="form-control" ng-model="MeasurementDetails.text3">--%>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <%--<label for="txtAddress1" class="col-sm-1 lbl-text-right">Address Line 1</label>--%>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.text4" />
                                        </div>
                                        <%--<label for="txtAddress2" class="col-sm-1 lbl-text-right">Address Line 2</label>--%>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.text5" />
                                        </div>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.text6" />
                                        </div>
                                        <label for="txtAddress2" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text7" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Deli Date</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.DeliDate">
                                            <%--<input type="number" class="form-control" ng-model="MeasurementDetails.text3">--%>
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">B.L.</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text8" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">   
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">Chest</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text9" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">weast</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text10" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">Seat</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text11" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Date</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.MeasDate">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text12" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text13" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text14" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Qty</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.Qty">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text15" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text16" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text17" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">Neck</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text18" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">alt+8</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text19" />
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text20" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">loose Sleev</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text21" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine"  ng-model="MeasurementDetails.text22" />
                                            <input type="text" class="form-control text-sameLine"  ng-model="MeasurementDetails.text23" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text24" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text25" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Weight</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.MeasWeight">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">CC</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine"  ng-model="MeasurementDetails.text26" />
                                            <input type="number" class="form-control text-sameLine"  ng-model="MeasurementDetails.text27" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">text28</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text28" />
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text29" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">Bottom</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text30" />
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text31" />
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
