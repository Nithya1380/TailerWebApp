<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TailerHome.aspx.cs" Inherits="TailerApp.UI.Tailer.TailerHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <style type="text/css">
        .BranchDiv
        {
            z-index:1002;
            position:relative;
            margin-left:5%;
            margin-top:-10%;
        }

        .BlackOverlay
{
    height: 100%;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
    background-color: rgba(0, 0, 0, .9);
    overflow-y: hidden;
    transition: 1s;
    opacity:0.5;
    z-index:1001;
   
}
    </style>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("TailerHomeController", function ($scope, $window, $http, $rootScope) {
            $scope.DashboardDetails = {};

            $scope.init = function () {
                $scope.DashboardDetails = {};
                $scope.GetDashboardDetails();
            };

            $scope.OnBranchSelection = function (branchID) {
                $http({
                    method: "POST",
                    url: "TailerHome.aspx/SelectBranch",
                    data: { branchID: branchID },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }
                    else {
                        
                        document.getElementById('div_BranchSelection').style.display = 'none';
                        document.getElementById('div_overLay').style.display = 'none';
                    }
                    

                }, function onFailure(error) {
                    alert(error);
                });
            }

            $scope.GetDashboardDetails = function () {
                $scope.DashboardDetails = {};

                $http({
                    method: "POST",
                    url: "TailerHome.aspx/GetDashboardDetails",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.DashboardDetails = JSON.parse(response.data.d.JSonstring);
                    $scope.DashboardDetails.Branches = JSON.parse(response.data.d.JSonstring2);

                }, function onFailure(error) {

                });
            };

            $scope.onDashboardCounterClick = function (url, count) {
                if (count <= 0)
                    return false;

                window.location.href = "<%=ApplicationVirtualPath%>" + url;
                return false;
             }
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div data-ng-app="TailerApp" id="divMainContent" data-ng-controller="TailerHomeController" data-ng-init="init()">

        <div class="row">
            <div class="page-header-new col-lg-12">
                Dashboard
            </div>
        </div>
        <!--end of row-->

        <div class="row">
            <div class="col-lg-3">
                <div class="card">
                    <table style="width: 100%">
                        <tr data-ng-click="onDashboardCounterClick('/UI/Tailer/InvoiceList.aspx?FromPage=3',DashboardDetails.DelivaryOfTheDay)">
                            <td rowspan="2">
                                <div class="delivery_outer">
                                    <img src="<%=ApplicationVirtualPath %>/Content/Images/delivery-truck.png" />
                                </div>
                            </td>
                            <td class="card_counter"><span data-ng-bind="DashboardDetails.DelivaryOfTheDay"></span> </td>
                        </tr>
                        <tr>
                            <td class="card_text">Delivery Of The Day</td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="line_outer">
                                    <div class="line_filled_delivery"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!--end of card col-->
            <div class="col-lg-3">
                <div class="card">
                    <table style="width: 100%">
                        <tr data-ng-click="onDashboardCounterClick('/UI/Tailer/CustomerList.aspx?FromPage=2',DashboardDetails.BirthDay)">
                            <td rowspan="2">

                                <div class="birthday_outer">
                                    <img src="<%=ApplicationVirtualPath %>/Content/Images/birthday.png" width="26" />
                                </div>
                            </td>
                            <td class="card_counter"><span data-ng-bind="DashboardDetails.BirthDay"></span> </td>
                        </tr>
                        <tr>
                            <td class="card_text">Customer Birthday</td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="line_outer">
                                    <div class="line_filled_birthday"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!--end of card col-->
            <div class="col-lg-3">
                <div class="card">
                    <table style="width: 100%">
                        <tr data-ng-click="onDashboardCounterClick('/UI/Tailer/InvoiceList.aspx?FromPage=2',DashboardDetails.RecentInvoices)">
                            <td rowspan="2">
                                <div class="invoice_outer">
                                    <img src="<%=ApplicationVirtualPath %>/Content/Images/invoice.png" style="width: 26px; margin-top: 2px;" />
                                </div>
                            </td>
                            <td class="card_counter"><span data-ng-bind="DashboardDetails.RecentInvoices"></span></td>
                        </tr>
                        <tr>
                            <td class="card_text">Recent Invoice</td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="line_outer">
                                    <div class="line_filled_invoice"></div>
                                </div>
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <!--end of card col-->
        </div>
        <!--end of row-->

        <div class="row">

            <div class="col-lg-6">
                <div class="card_bg">
                    <div class="card_header">
                        Branch List
                    </div>

                    <table class="table card_table">
                        <thead>
                            <tr>
                            <th>Branch Code</th>
                            <th>Name</th>
                            <th>Area</th>
                        </tr>
                        </thead>
                        <tbody data-ng-repeat="branch in DashboardDetails.Branches">
                            <tr>
                            <td><span data-ng-bind="branch.BranchCode"></span></td>
                            <td><span data-ng-bind="branch.BranchName"></span></td>
                            <td><span data-ng-bind="branch.BranchDivision"></span></td>
                        </tr>
                        </tbody>
                    </table>

                </div>
            </div>
            <!--end of col-->

            <div class="col-lg-6">
                <div class="card_bg">
                    <div class="card_header">
                        Chart
                    </div>
                    Graph
                </div>
            </div>
            <!--end of col-->
        </div>

        <div class="row">
            <div id="div_BranchSelection" clientidmode="static" class="BranchDiv" runat="server" style="display: none"></div>
        </div>
    </div>
    <div class="BlackOverlay" id="div_overLay" runat="server" clientidmode="static" style="display:none"></div>
</asp:Content>
