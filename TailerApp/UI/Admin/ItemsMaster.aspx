<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ItemsMaster.aspx.cs" Inherits="TailerApp.UI.Admin.ItemsMaster" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("ItemsListController", function ($scope, $window, $http, $rootScope) {
            $scope.ItemsList = {};

            $scope.init = function () {
                $scope.ItemsList = {};
                $scope.GetItemMasterList();
            };

            $scope.GetItemMasterList = function () {
                $scope.ItemsList = {};

                $http({
                    method: "POST",
                    url: "ItemsMaster.aspx/GetItemsList",
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

                    $scope.ItemsList = JSON.parse(response.data.d.ItemsList);

                }, function onFailure(error) {
                    alert(response.data.d.ErrorMessage);
                    return false;
                });
            };

            
            $scope.OnAddEditItemClick = function (ItemMasterID) {
                var left = (screen.width / 2) - (850 / 2);
                var top = (screen.height / 2) - (500 / 2);
                $window.open("AddEditItemMaster.aspx?ItemMasterID=" + ItemMasterID, "AddEditItemMaster", 'resizable=yes,location=1,status=1,scrollbars=1,width=850,height=500,top=' + top + ', left=' + left);
                return false;
            };
        });

        function RefreshItemMasterList() {
            angular.element(document.getElementById('divMainContent')).scope().GetItemMasterList();
            // displayVendorList(vendorId);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="ItemsListController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom:5px">
                <button class="btn btn-lg btn-success" type="button" data-ng-click="OnAddEditItemClick(0);"><i class="fas fa-plus-square"></i>&nbsp;Add New</button>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Description</th>
                                    <th>Group</th>
                                    <th>Price</th>
                                    <th></th>
                                    
                                </tr>
                            </thead>
                            <tbody ng-repeat="Item in ItemsList">
                                <tr>
                                    <td>{{Item.ItemCode}}</td>
                                    <td>{{Item.ItemDescription}}</td>
                                    <td>{{Item.ItemGroup}}</td>
                                    <td>{{Item.ItemPrice}}</td>
                                    <td><a href="#" title="Edit Item" data-ng-click="OnAddEditItemClick(Item.ItemmasterID)"><i class="fa fa-dollar" style="font-size:24px;"></i></a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
