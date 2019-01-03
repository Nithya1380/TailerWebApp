<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/SitePopUp.Master" CodeBehind="AuditLogs.aspx.cs" Inherits="TailerApp.UI.Tailer.AuditLogs" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var ActivityType = "<%=ActivityType%>";
        var ActivitID = "<%=ActivitID%>";

        var tailerApp = angular.module("TailerApp", []);

        tailerApp.controller("AuditLogsController", function ($scope, $window, $http, $rootScope) {
            $scope.AuditLogs = {};

            $scope.GetAuditLogs = function () {

                $scope.AuditLogs = {};

                $http({
                    method: "POST",
                    url: "AuditLogs.aspx/GetAuditLogs",
                    data: { ActivityType: $window.ActivityType, ActivitID: $window.ActivitID },
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

                    $scope.AuditLogs = JSON.parse(response.data.d.JSonstring);


                }, function onFailure(error) {
                    alert(response.data.d.ErrorMessage);
                    return false;
                });
            };

            $scope.GetAuditLogs();

            $scope.onclosepopup = function () {
                $window.close();
                return false;
            }
        });


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="AuditLogsController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
               Audit Logs
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="button_div" style="float: right; max-width: 200px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="onclosepopup()">Close</button>
                    </div>
                    <table class="table card_table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Time</th>
                                <th>Employee</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody ng-repeat="Item in AuditLogs">
                            <tr>
                                <td>{{Item.MdDate}}</td>
                                <td>{{Item.MdTime}}</td>
                                <td>{{Item.EmployeeName}}</td>
                                <td>{{Item.LogDescription}}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
               
    </div>
</asp:Content>
