<%@ Page Language="C#" MasterPageFile="~/UI/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="TailerApp.UI.Admin.AdminHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<style type="text/css">
    .web_hader{
        border: 1px solid rgba(140, 140, 140, 1);
        background-color:bisque; 
        font-weight: bold;
    }
    .web_Column{
        border: 1px solid rgba(140, 140, 140, 1);
        height:36px;
    }
</style>
<script type="text/javascript" language="javascript">

    
    var TailerApp = angular.module("TailerApp", []);

    TailerApp.controller('AdminHomeController', ['$scope', '$window', '$http', '$rootScope', function ($scope, $window, $http, $rootScope) {
        
        $scope.CompanyList = {};
        $scope.BranchList = {};

        $scope.GetCompanyAndBranchList = function() {

            $http(
               {
                   method: "POST",
                   url: "AdminHome.aspx/GetCompanyAndBranchList",
                   dataType: 'json',
                   data: { },
                   headers: { "Content-Type": "application/json" }
               }).then(function successCallback(response) {

                   if (response.data.d.errorCode == 10001) {
                       //window.location = '../../SessionExpired.aspx';
                       return false;
                   }
                   else if (response.data.d.errorCode == 0) {
                       $scope.CompanyList = JSON.parse(response.data.d.CompanyList);
                       $scope.BranchList = JSON.parse(response.data.d.BranchList);
                   }
                   else {

                       var msg = response.data.d.errorMessage;
                       $window.alert(msg);

                   }

               }, function errorCallback(response) {
                   $window.alert(response.data.d.errorMessage);

               });

        }

        $scope.GetCompanyAndBranchList();

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
                   url: "AdminHome.aspx/GetURLEncryptedData",
                   dataType: 'json',
                   data: { URLdata: URLdata},
                   headers: { "Content-Type": "application/json" }
               }).then(function successCallback(response) {

                   if (response.data.d.errorCode == 10001) {
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

    }]);

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div ng-app="TailerApp" ng-controller = "AdminHomeController" >
      <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-4 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="GetCompanyAndBranchList();">&nbsp;Display</button>
                <button class="btn btn-lg btn-success" type="button" data-ng-click="AddEditCompany(0);">&nbsp;Add Company</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Company</th>
                                    <th>Company Code</th>
                                    <th>Created Date</th>
                                    <th></th>
                                    <th></th>
                                    <th>Create Branch</th>
                                </tr>
                            </thead>
                            <tbody ng-repeat="Cmp in CompanyList">
                                <tr>
                                    <td><a href="#" data-ng-click="AddEditCompany(Cmp.CompanyID)">{{Cmp.CompanyName}}</a></td>
                                    <td>{{Cmp.CompanyCode}}</td>
                                    <td>{{Cmp.CompCreatedDate}}</td>
                                    <td></td>
                                    <td></td>
                                    <td><input type="button" value="Add Branch" ng-click="AddEditBranch(Cmp.CompanyID, 0)"/></td>
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
                    <div class="">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Company</th>
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
                                    <td>{{Bnh.CompanyName}}</td>
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

<%--    <div align="right" style="width:98%; padding-right:10px;">
        <input type="button" value="Add Company" ng-click="AddEditCompany(0)"/>
    </div>
    <div>
        <div class="container">
            <div class="row">
            <div class="col-xs-12 col-sm-11">
                <div class="row">
                    <div class="col-xs-4 col-sm-3 web_hader">
                        Company Code
                    </div>
                    <div class="col-xs-4 col-sm-3 web_hader">
                        Company Name
                    </div>
                    <div class="col-xs-4 col-sm-3 web_hader">
                        Created Date
                    </div>
                    <div class="col-xs-4 col-sm-3 web_hader">
                        &nbsp;
                    </div>
                </div>
            </div>
            <div class="col-xs-12 col-sm-11">
                <div class="row" ng-repeat="CBList in CompanyAndBranchList">
                    <div class="col-xs-4 col-sm-3 web_Column">
                        {{CBList.CompanyCode}}
                    </div>
                    <div class="col-xs-4 col-sm-3 web_Column">
                        {{CBList.CompanyName}}
                    </div>
                    <div class="col-xs-4 col-sm-3 web_Column">
                        {{CBList.CompCreatedDate}}
                    </div>
                    <div class="col-xs-4 col-sm-3 web_Column">
                        <input type="button" value="Edit Company" ng-click="AddEditCompany(CBList.CompanyID)"/>
                        <input type="button" value="Add Branch" ng-click="AddEditBranch(CBList.CompanyID, 0)"/>
                    </div>
                    <div class="col-xs-12 col-sm-12">
                        <div class="row" ng-repeat="BList in CBList.BranchList">
                            <div class="col-xs-4 col-sm-3 web_Column">
                                {{BList.BranchCode}}
                            </div>
                            <div class="col-xs-4 col-sm-3 web_Column">
                                {{BList.BranchName}}
                            </div>
                            <div class="col-xs-4 col-sm-3 web_Column">
                                {{BList.BranchCreatedDate}}
                            </div>
                            <div class="col-xs-4 col-sm-3 web_Column">
                                <input type="button" value="Edit Branch" ng-click="AddEditBranch(BList.CompanyID, BList.BranchID)"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
      </div>
    </div>--%>
  </div>
</asp:Content>

