<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TailerHome.aspx.cs" Inherits="TailerApp.UI.Tailer.TailerHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <style type="text/css">
        .BranchDiv
        {
            z-index:101;
            position:relative;
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
}
    </style>
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("TailerHomeController", function ($scope, $window, $http, $rootScope) {
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
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row" style="margin-top:30px" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="TailerHomeController">
        <%--<div class="col-md-4">
            <div class="panel panel-primary">
                <div class="panel-heading">
                </div>
                <div class="panel-wrapper collapse in">
				<div class="panel-body">
                   <a href="#" onclick="OnAccountsClick()"><i class="fas fa-university  fa-w-16 fa-3x"> Accounts</i></a> 
                </div>
                </div>
            </div>
        </div>--%>
        
        <div id="div_BranchSelection" clientidmode="static" class="BranchDiv" runat="server" style="display:none"></div>
    </div>
    <div class="BlackOverlay" id="div_overLay" runat="server" clientidmode="static" style="display:none"></div>
</asp:Content>
