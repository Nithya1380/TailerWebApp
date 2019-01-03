<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="SeriesMasterList.aspx.cs" Inherits="TailerApp.UI.Tailer.SeriesMasterList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("SeriesMasterListController", function ($scope, $window, $http, $rootScope) {
            $scope.SeriesMasterList = {};
           
            $scope.GetSeriesMasterList = function (SeriesMasterID) {

                $scope.SeriesMasterList = {};

                $http({
                    method: "POST",
                    url: "SeriesMasterList.aspx/GetSeriesMaster",
                    data: { SeriesMasterID: SeriesMasterID },
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

                    $scope.SeriesMasterList = JSON.parse(response.data.d.JSonstring);
 

                }, function onFailure(error) {
                    alert(response.data.d.ErrorMessage);
                    return false;
                });
            };

            $scope.GetSeriesMasterList(0);


            $scope.OnAddEditSeriesMaster = function (SeriesMasterID) {
                var left = (screen.width / 2) - (850 / 2);
                var top = (screen.height / 2) - (500 / 2);
                $window.open("AddEditSeriesMaster.aspx?SeriesMasterID=" + SeriesMasterID, "AddEditSeriesMaster", 'resizable=yes,location=1,status=1,scrollbars=1,width=850,height=500,top=' + top + ', left=' + left);
                return false;
            };

            $scope.OnAuditLogs = function () {
                var left = (screen.width / 2) - (850 / 2);
                var top = (screen.height / 2) - (500 / 2);
                $window.open("AuditLogs.aspx?ActivityType=SeriesMasterID", "AuditLogs", 'resizable=yes,location=1,status=1,scrollbars=1,width=850,height=500,top=' + top + ', left=' + left);
                return false;
            };
        });

        function RefreshSeriesMasterList() {
            angular.element(document.getElementById('divMainContent')).scope().GetSeriesMasterList(0);
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="SeriesMasterListController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Series Master
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="button_div" style="float: right; max-width: 200px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="OnAddEditSeriesMaster(0);">Add New</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-click="OnAuditLogs();">Audit</button>
                    </div>
                    <table class="table card_table">
                        <thead>
                            <tr>
                                <th>Start Date</th>
                                <th>Prefix</th>
                                <th>Last Value</th>
                                <th>With Zero</th>
                                <th>Width</th>
                                <th></th>

                            </tr>
                        </thead>
                        <tbody ng-repeat="Item in SeriesMasterList">
                            <tr>
                                <td>{{Item.StartDate}}</td>
                                <td>{{Item.Prefix}}</td>
                                <td>{{Item.LastValue}}</td>
                                <td>{{Item.WithZero?'YES':'NO'}}</td>
                                <td>{{Item.Width}}</td>
                                <td><a href="#" title="Edit Item" data-ng-click="OnAddEditSeriesMaster(Item.SeriesMasterID)"><i class="fa fa-pencil" style="font-size: 24px;"></i></a></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
               
    </div>
</asp:Content>
