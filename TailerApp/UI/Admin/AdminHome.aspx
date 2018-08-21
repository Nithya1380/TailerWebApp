<%@ Page Language="C#" MasterPageFile="~/UI/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="AdminHome.aspx.cs" Inherits="TailerApp.UI.Admin.AdminHome" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
<style type="text/css">
 
</style>
<script type="text/javascript" language="javascript">
    var TailerApp = angular.module("TailerApp", []);

    TailerApp.controller('AdminHomeController', ['$scope', '$window', '$http', '$rootScope', function ($scope, $window, $http, $rootScope) {

        $scope.AddEditCompany = function () {
      
                var width = 850;
                var height = 800;
                var left = (screen.width / 2) - (width / 2);
                var top = ((screen.height / 2) - (height / 2)) - 50;
                var windowFeatures = "width=" + width + ",height=" + height + ",status,resizable,scrollbars,modal,left=" + left + ",top=" + top + "";
                var URL = "../Admin/Company_AddModify.aspx"
                var winName = "Add Company"
                var winobj = window.open(URL, winName, windowFeatures);
                winobj.focus();
        }
       
    }]);

</script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div ng-app="TailerApp" ng-controller = "AdminHomeController" >
    <div align="right" style="width:98%; padding-right:10px;">
        <input type="button" value="Add Company" ng-click="AddEditCompany()"/>
    </div>
  </div>
</asp:Content>

