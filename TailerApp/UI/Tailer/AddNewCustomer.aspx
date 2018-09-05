<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddNewCustomer.aspx.cs" Inherits="TailerApp.UI.Tailer.AddNewCustomer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/modernizr") %>
        <script src="<%: ResolveUrl("~/Scripts/jquery-1.10.2.js") %>"></script>
        <script src="<%: ResolveUrl("~/Scripts/jquery-1.10.2.min.js") %>"></script>
        <script src="<%: ResolveUrl("~/Scripts/jquery-1.10.2.ui.js") %>"></script>
    </asp:PlaceHolder>

    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous" />
   
    <script type="text/javascript">
        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("AddCustomerController", function ($scope, $window, $http, $rootScope) {
            $scope.Customer = {};

            $scope.AddNewCustomer = function () {
                $http({
                    method: "POST",
                    url: "AddNewCustomer.aspx/AddNewCustomerToDB",
                    data: { Customer: $scope.Customer },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.d.ErrorMessage);
                        return false;
                    }

                }, function onFailure(error) {
                    var x = error;
                    alert(x);
                });

            };
        });

    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="col-lg-12 col-md-12 col-sm-12" data-ng-app="TailerApp" data-ng-controller="AddCustomerController">
            <div class="card" style="margin-top: 10px;">
                <div class="card_header" style="border-bottom: 1px solid #00A5A8; padding-bottom: 8px; color: #00a5a8;">
                    Add New Customer
			<span style="float: right">
                <span style="float: right">
                    <button class="client_btn" type="button" data-toggle="dropdown" style="border-color: #00A5A8 !important; background-color: #00B5B8" data-ng-click="AddNewCustomer()">
                        <i class="fa fa-save"></i>
                        Save
                    </button>
                    <button class="client_btn" type="button" onclick="window.close();" data-toggle="dropdown" style="border-color: #FFA87D !important; background-color: #FFA87D">
                        <i class="fa fa-close"></i>
                        Cancel
                    </button>
                </span>
            </span>
                </div>
                <div class="card_content">

                    <table style="width:100%" class="profile_table">
                        <tbody>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">First Name:</span></td>
                                <td colspan="5">
                                   <span class="profileValue">
                                    <input type="text" data-ng-model="Customer.FirstName" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                   </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Sur Name:</span></td>
                                <td colspan="2">
                                    <input type="text" data-ng-model="Customer.SurName" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="50" /></td>

                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Sex:</span></td>
                                <td colspan="3">
                                    <select class="form-control" data-ng-model="Customer.Sex" style="margin-left: 5px; width: 100px;">
                                        <option>Male</option>
                                        <option>Female</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">DOB:</span></td>
                                <td colspan="5">
                                    <input type="text" data-ng-model="Customer.DOB" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="15" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Address 1:</span></td>
                                <td colspan="6">
                                    <input type="text" data-ng-model="Customer.Address1" class="form-control" style="width: 300px; margin-left: 5px;" maxlength="50"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Address 2:</span></td>
                                <td colspan="5">
                                    <input type="text" data-ng-model="Customer.Address2" class="form-control" style="width: 300px; margin-left: 5px;" maxlength="50" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Zip:</span></td>
                                <td>
                                    <input type="text" data-ng-model="Customer.Zip" class="form-control" style="width: 100px; margin-left: 5px;" maxlength="20" /></td>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">City:</span></td>
                                <td>
                                    <input type="text" data-ng-model="Customer.City" class="form-control" style="width: 100px; margin-left: 5px;" maxlength="20" /></td>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">State:</span></td>
                                <td>
                                    <input type="text" data-ng-model="Customer.State" class="form-control" style="width: 100px; margin-left: 5px;" maxlength="20" /></td>
                            </tr>
                        </tbody>
                    </table>
                    <div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
