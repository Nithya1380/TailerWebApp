<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/SitePopUp.Master" CodeBehind="AddEditSeriesMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.AddEditSeriesMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="PopUphead" runat="server">
        <script src="../../Scripts/AngularJS/angular.js"></script>
        <script src="../../Scripts/angular-datepicker.js"></script>
        <link href="../../Scripts/CalendarControl.css" rel="stylesheet" />
        <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script type="text/javascript">
        var SeriesMasterID = "<%=SeriesMasterID%>";

        var tailerApp = angular.module("TailerApp", ['720kb.datepicker']);

        tailerApp.controller("SeriesMasterController", function ($scope, $window, $http, $rootScope) {
            $scope.SeriesMaster = {};
            $scope.SeriesMasterID = $window.SeriesMasterID;
            $scope.str = "0";

            $scope.GetSeriesMaster = function () {

                $scope.SeriesMaster = {};

                $http({
                    method: "POST",
                    url: "AddEditSeriesMaster.aspx/GetSeriesMaster",
                    data: { SeriesMasterID: $scope.SeriesMasterID },
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

                    $scope.SeriesMaster = JSON.parse(response.data.d.JSonstring)[0];


                }, function onFailure(error) {
                    alert(response.data.d.ErrorMessage);
                    return false;
                });
            };

            if ($scope.SeriesMasterID != 0)
                $scope.GetSeriesMaster();
            else {

                var d = new Date();
                var stardate = d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear();

                $scope.SeriesMaster = {
                    SeriesMasterID: 0,
                    StartDate: stardate,
                    Prefix: "",
                    LastValue: null,
                    WithZero: false,
                    Width: null
                }
            }

            $scope.SaveSeriesMaster = function () {

                if ($scope.SeriesMaster.StartDate == "" || $scope.SeriesMaster.StartDate == null) {
                    $window.alert("Please enter Start Date");
                    return false;
                }
                else {
                    var d = new Date();
                    var stardate = d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear();
                    stardate = stardate.split("/");
                    d = new Date(stardate[2], stardate[1] - 1, stardate[0]);
                    var from = $scope.SeriesMaster.StartDate.split("/")
                    var f = new Date(from[2], from[1] - 1, from[0]);
                    if (f < d) {
                        $window.alert("Start Date should be greater than today's date");
                        return false;
                    }
                }

                var SeriesMaster = JSON.stringify($scope.SeriesMaster);

                $http({
                    method: "POST",
                    url: "AddEditSeriesMaster.aspx/SaveSeriesMaster",
                    data: { SeriesMasterID: $scope.SeriesMasterID, SeriesMaster: SeriesMaster },
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

                    if ($window != null && $window.opener != null && (typeof $window.opener.RefreshSeriesMasterList == 'function'))
                        $window.opener.RefreshSeriesMasterList();

                    $scope.SeriesMaster.SeriesMasterID = response.data.d.OutValue;
                    $scope.SeriesMasterID = response.data.d.OutValue;

                    $window.alert("Save Succesfully");


                }, function onFailure(error) {
                    alert(response.data.d.ErrorMessage);
                    return false;
                });
            };

            $scope.onClosePopup = function () {
               $window.close();
                return false;
            }

            $scope.repeatstr = function (num) {
                var ar = new Array();

                if (num > 0)
                    ar = new Array(num+1).join("0");

                return ar;
            }

        });


    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PopUpContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="SeriesMasterController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                {{SeriesMasterID == 0?'Add new series':'Edit series'}}
            </div>
        </div>
        
        <div class="row">
            <div class="col-lg-12">
                <div class="card_bg">
                    <div class="button_div" style="float: right; max-width: 200px;">
                        <button class="btn_ss bg-blue" type="button" data-ng-click="SaveSeriesMaster();">Save</button>
                        <button class="btn_ss bg-blue" type="button" data-ng-click="onClosePopup();">Close</button>
                    </div>
                    <table class="table card_table">
                        <tr>
                            <td style= "text-align:right;"><span style="color:red">*</span>Start Date</td>
                            <td style= "text-align:left;"> 
                                <datepicker  date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="SeriesMaster.StartDate" 
						                style="width:110px;"/> 
				                 </datepicker>
                            </td>
                        </tr>
                        <tr>
                            <td style= "text-align:right;">Prefix</td>
                            <td style= "text-align:left;">
                                <input type="text" class="form-control" style="width:50%" ng-model="SeriesMaster.Prefix" maxlength="50"/> 
                            </td>
                        </tr>
                        <tr>
                            <td style= "text-align:right;">Last Value</td>
                            <td style= "text-align:left;">
                                <input type="number" class="form-control" style="width:50%" ng-model="SeriesMaster.LastValue" /> 
                            </td>
                        </tr>
                        <tr>
                            <td style= "text-align:right;">With Zero</td>
                            <td style= "text-align:left;">
                                 <input type="checkbox" ng-model="SeriesMaster.WithZero" /> 
                            </td>
                        </tr>
                        <tr>
                            <td style= "text-align:right;">Width</td>
                            <td style= "text-align:left;">
                                <input type="number" class="form-control" style="width:50%" ng-disabled="!SeriesMaster.WithZero" ng-model="SeriesMaster.Width" /> 
                            </td>
                        </tr>
                        <tr>
                            <td style= "text-align:right;">Example</td>
                            <td style= "text-align:left;">
                               {{SeriesMaster.Prefix}}{{SeriesMaster.WithZero && SeriesMaster.Width > 0 &&  SeriesMaster.Width>(SeriesMaster.Prefix+SeriesMaster.LastValue).length?repeatstr(SeriesMaster.Width-(SeriesMaster.Prefix+SeriesMaster.LastValue).length):''}}{{SeriesMaster.LastValue}}
                            </td>
                        </tr>
                    </table>
                </div>

            </div>
        </div>
               
    </div>
</asp:Content>