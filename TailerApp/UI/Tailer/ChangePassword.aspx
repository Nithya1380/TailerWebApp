<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="ChangePassword.aspx.cs" Inherits="TailerApp.UI.Tailer.ChangePassword" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/font-awesome.min.css" rel="stylesheet" />
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("ChangePasswordController", function ($scope, $window, $http) {
            $scope.OldPass = "";
            $scope.Pass = "";
            $scope.NewPass = "";
            $scope.CnfPass = "";
            $scope.passwordStatus = '';
            $scope.passwordStyle = '';
            $scope.isSaved = false;

            $scope.GetUserDetails = function () {

                $http({
                    method: "POST",
                    url: "ChangePassword.aspx/GetUserDetails",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.errorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.errorCode != 0) {
                        alert(response.dta.d.errorMessage);
                        return false;
                    }

                    $scope.OldPass = response.data.d.String_Outvalue;

                }, function onFailure(error) {

                });

                return false;
            };

            $scope.GetUserDetails();

            $scope.SaveChangePassword = function () {

                if ($scope.Pass == "") {
                    $window.alert("Please Enter password");
                    return false;
                }
                else if ($scope.OldPass != $scope.Pass) {
                    $window.alert("Incorrect Password");
                    return false;
                }
                else if ($scope.passwordStatus == 'Weak' && $scope.Pass != "") {
                    $window.alert("Password is week");
                    return false;
                }
                else if ($scope.NewPass == "") {
                    $window.alert("Please Enter new password");
                    return false;
                }
                else if ($scope.CnfPass == "") {
                    $window.alert("Please Enter confirm password");
                    return false;
                }
                else if ($scope.NewPass != $scope.CnfPass) {
                    $window.alert("Password is not same");
                    return false;
                }


                $http({
                    method: "POST",
                    url: "ChangePassword.aspx/SaveChangePassword",
                    data: { Password: $scope.NewPass },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.errorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.errorCode != 0) {
                        alert(response.dta.d.errorMessage);
                        return false;
                    }

                    $scope.isSaved = true;

                }, function onFailure(error) {

                });
                return false;
            };


            $scope.check = function (x) {
                var level = 0;
                var p1 = /[a-z]/;
                var p2 = /[A-Z]/;
                var p3 = /[0-9]/;
                var p4 = /[\!\@\#\$\%\^\&\*\(\)\-\_\=\+\[\{\]\}\|\\\;\:\'\"\,\<\.\>\/\?\`\~]/;
                if (x.length >= 8)
                    level++;
                if (p1.test(x))
                    level++;
                if (p2.test(x))
                    level++;
                if (p3.test(x))
                    level++;
                if (p4.test(x))
                    level++;
                prog_bar(level, 0, 5, 200, 10, "#cdcdcc", "#44adf6");
            };


            function prog_bar(cur_val, min_val, max_val, width, height, border, fill) {
                $scope.passwordStatus = '';
                $scope.passwordStyle = '';
                var str = "", res = 0;
                if (cur_val >= min_val && cur_val <= max_val) {
                    if (min_val < max_val) {
                        res = ((cur_val - min_val) / (max_val - min_val)) * 100;
                        res = Math.floor(res);
                    }
                    else {
                        res = 0;
                    }
                }
                else {
                    res = 0;
                }
                if (res <= 40)
                    fill = "#9f0400";
                else if (res <= 60)
                    fill = "#e9d103";
                else if (res <= 80)
                    fill = "#007100";
                if (res > 0 && res <= 40) {
                    $scope.passwordStatus = "Weak";
                }
                else if (res > 40 && res <= 60) {
                    $scope.passwordStatus = "Good";
                }
                else if (res > 60 && res <= 80) {
                    $scope.passwordStatus = "Strong";
                }
                else if (res > 80) {
                    $scope.passwordStatus = "Excellent";

                }
                $scope.passwordStyle = { 'color': fill };

            };

            $scope.onClose = function () {
                $window.location.href = "<%=ApplicationVirtualPath%>" + '/UI/Tailer/TailerHome.aspx';
                return false;
            };

        });

        //ng-keyup="check(Userpassword)"

    </script>
    <style>
        .password{
            width:50%
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="ChangePasswordController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Change Password
            </div>
        </div>
        <div class="row" ng-show="!isSaved">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <div class="button_div">
                                <button class="btn_ss bg-blue" type="button" ng-click="SaveChangePassword();" ng-show="!isSaved">Save</button>
                                <button class="btn_ss bg-blue" type="button" ng-click="onClose()">Close</button>
                            </div>
                        </div>
                        <div class="label_div col-lg-3 col-md-3 col-sm-6">
                            Password
                        </div>
                        <div class="val_div col-lg-8 col-md-3 col-sm-6">
                            <input type="password" class="password form-control" name="password" placeholder="password" ng-model="Pass">
                        </div>
                        <div class="label_div col-lg-3 col-md-3 col-sm-6">
                            New Password
                        </div>
                        <div class="val_div col-lg-8 col-md-3 col-sm-6">
                            <input type="password" class="password form-control" name="newpassword" placeholder="new password" ng-keyup="check(NewPass)" ng-model="NewPass">
                            <span ng-show="NewPass != ''" ng-style="passwordStyle">{{passwordStatus}}</span>
                        </div>
                        <div class="label_div col-lg-3 col-md-3 col-sm-6">
                            Confirm Password
                        </div>
                        <div class="val_div col-lg-8 col-md-3 col-sm-6">
                            <input type="password" class="password form-control" name="cnfpassword" placeholder="Confirm password" ng-model="CnfPass">
                            <i class="fa fa-check" ng-show="CnfPass != '' && CnfPass == NewPass" style="font-size:24px; color:green;"></i>
                        </div>
                    </div>
                </div>
            </div>
            <!--end of col-->
        </div>
        <div class="row" ng-show="isSaved">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <div class="button_div">
                                <button class="btn_ss bg-blue" type="button" ng-click="onClose()">Close</button>
                            </div>
                        </div>
                        <div class="col-lg-12 col-md-12 col-sm-12" style="text-align: center;"><i class="fa fa-check-square-o" style="font-size:48px;color:green;"></i></div>
                        <div class="col-lg-12 col-md-12 col-sm-12" style="text-align: center;">
                            Changed Succesfully
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--end of row-->
    </div>
</asp:Content>

