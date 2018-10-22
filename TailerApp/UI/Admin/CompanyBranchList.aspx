<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="CompanyBranchList.aspx.cs" Inherits="TailerApp.UI.Admin.CompanyBranchList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
<script src="../../Scripts/AngularJS/angular.js"></script>
<script type="text/javascript">
    var tailerApp = angular.module("TailerApp", []);
    tailerApp.controller("CmpBnhListController", function ($scope, $window, $http, $rootScope) {
        $scope.CompanyList = {};
        $scope.BranchList = {};

        $scope.init = function () {
            $scope.CompanyList = {};
            $scope.BranchList = {};
            $scope.GetCmpBnhList();
        };

        $scope.GetCmpBnhList = function () {
            $scope.CompanyList = {};
            $scope.BranchList = {};

            $http({
                method: "POST",
                url: "CompanyBranchList.aspx/GetCompanyBranchList",
                data: {},
                dataType: "json",
                headers: { "Content-Type": "application/json" }
            }).then(function onSuccess(response) {
                if (response.data.d.errorCode == 1001) {
                    //Session Expired
                    return false;
                }
                if (response.data.d.errorCode != 0) {
                    alert(response.dta.d.errorMessage);
                    return false;
                }

                $scope.CompanyList = JSON.parse(response.data.d.CompanyList);
                $scope.BranchList = JSON.parse(response.data.d.BranchList);

            }, function onFailure(error) {

            });
        };

        $scope.AddEditCompany = function (CompanyID) {

            var width = 850;
            var height = 800;
            var left = (screen.width / 2) - (width / 2);
            var top = ((screen.height / 2) - (height / 2)) - 50;
            var windowFeatures = "width=" + width + ",height=" + height + ",status,resizable,scrollbars,modal,left=" + left + ",top=" + top + "";
            var URL = "../Admin/Company_AddModify.aspx?"
            var URLdata = "CompanyID=" + CompanyID;
            var winName = "Add Company"
            GetURLEncryptedData(URL, URLdata, winName, windowFeatures);
        }

        $scope.AddEditBranch = function (CompanyID, BranchID) {

            var width = 850;
            var height = 800;
            var left = (screen.width / 2) - (width / 2);
            var top = ((screen.height / 2) - (height / 2)) - 50;
            var windowFeatures = "width=" + width + ",height=" + height + ",status,resizable,scrollbars,modal,left=" + left + ",top=" + top + "";
            var URL = "../Admin/Branch_AddModify.aspx?"
            var URLdata = "CompanyID=" + CompanyID + "&BranchID=" + BranchID;
            var winName = "Add Branch"
            GetURLEncryptedData(URL, URLdata, winName, windowFeatures);
        }

        // Common Function To get encrpted URL
        function GetURLEncryptedData(URL, URLdata, winName, windowFeatures) {

            $http(
               {
                   method: "POST",
                   url: "CompanyBranchList.aspx/GetURLEncryptedData",
                   dataType: 'json',
                   data: { URLdata: URLdata },
                   headers: { "Content-Type": "application/json" }
               }).then(function successCallback(response) {

                   if (response.data.d.errorCode == 1001) {
                       //window.location = '../../SessionExpired.aspx';
                       return false;
                   }
                   else if (response.data.d.errorCode == 0) {
                       URL = URL + response.data.d.String_Outvalue;
                       OnAjaxSuccessURLEncryptedData(URL, winName, windowFeatures);
                   }
                   else {

                       var msg = response.data.d.errorMessage;
                       $window.alert(msg);

                   }

               }, function errorCallback(response) {
                   $window.alert(response.data.d.errorMessage);

               });

        }

        function OnAjaxSuccessURLEncryptedData(URL, winName, windowFeatures) {
            var navigateurl = URL;
            var winobj = window.open(navigateurl, winName, windowFeatures);
            winobj.focus();
        }
    });

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="CmpBnhListController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="GetCmpBnhList();">&nbsp;Display</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Company Code</th>
                                    <th>Created Date</th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="Cmp in CompanyList">
                                <tr>
                                    <td><a href="#" data-ng-click="AddEditCompany(Cmp.CompanyID)">{{Cmp.CompanyName}}</a></td>
                                    <td>{{Cmp.CompanyCode}}</td>
                                    <td>{{Cmp.CompCreatedDate}}</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
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
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Branch</th>
                                    <th>Branch Code</th>
                                    <th>Created Date</th>
                                    <th></th>
                                    <th></th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="Bnh in BranchList">
                                <tr>
                                    <td><a href="#" data-ng-click="AddEditBranch(Bnh.CompanyID, Bnh.BranchID)">{{Bnh.BranchName}}</a></td>
                                    <td>{{Bnh.BranchCode}}</td>
                                    <td>{{Bnh.BranchCreatedDate}}</td>
                                    <td></td>
                                    <td></td>
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