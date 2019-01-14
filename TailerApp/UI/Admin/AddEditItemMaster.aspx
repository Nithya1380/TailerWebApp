<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddEditItemMaster.aspx.cs" Inherits="TailerApp.UI.Admin.AddEditItemMaster" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/angular-datepicker.js"></script>
    
    <asp:PlaceHolder runat="server">
        <%: Scripts.Render("~/bundles/modernizr") %>
        <script src="<%: ResolveUrl("~/Scripts/jquery-1.10.2.js") %>"></script>
        <script src="<%: ResolveUrl("~/Scripts/jquery-1.10.2.min.js") %>"></script>
        <script src="<%: ResolveUrl("~/Scripts/jquery-1.10.2.ui.js") %>"></script>
    </asp:PlaceHolder>
    <script src="../../Scripts/bootstrap.min.js"></script>
    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"  />
   
    <script type="text/javascript">
        var gb_ItemMasterID='<%=ItemMasterID%>';

        var tailerApp = angular.module("TailerApp", ['720kb.datepicker']);
        tailerApp.controller("AddEditItemController", function ($scope, $window, $http, $rootScope, $sce) {
            $scope.ItemMaster = {};
            $scope.ShowError = false;
            $scope.ItemMasterID = gb_ItemMasterID;
            $scope.CustomerError = "";
            $scope.AlertClass = "alert-danger";
            $scope.EnableSave = true;
            $scope.ItemRateLists = {};
            $scope.ItemRates = {};
            $scope.ShowErrorRate = false;
            $scope.RateSaveDisabled = false;

            $scope.init = function () {
                $scope.GetItemGroups();
                if ($scope.ItemMasterID != 0)
                {
                    $scope.GetItemMasterDetails();
                    $scope.GetItemRateList();
                }
                   
            }

            $scope.GetItemGroups = function () {
                $scope.ItemGroupPickLists = {};

                $http({
                    method: "POST",
                    url: "AddEditItemMaster.aspx/GetItemGroups",
                    data: {},
                    dataType: "json",
                    headers: { contentType: "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.ItemGroupPickLists = response.data.d;

                }, function onFailure(error) {

                });
            };

            $scope.GetItemMasterDetails = function () {
                $scope.ItemMaster = {};

                $http({
                    method: "POST",
                    url: "AddEditItemMaster.aspx/GetItemDetails",
                    data: { itemMasterID: $scope.ItemMasterID },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        $scope.ShowError = true;
                        $scope.CustomerError = $sce.trustAsHtml(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.ItemMaster = response.data.d.ItemsList[0];

                }, function onFailure(error) {
                    $scope.ShowError = true;
                    $scope.CustomerError = $sce.trustAsHtml(response.data.d.ErrorMessage);
                    return false;
                });
            };

            $scope.AddEditItemMaster = function () {
                $scope.ShowError = false;
                $scope.CustomerError = "";

                if (!$scope.ValidateAdd())
                    return false;

                $http({
                    method: "POST",
                    url: "AddEditItemMaster.aspx/AddEditItemToDB",
                    data: { ItemMaster: $scope.ItemMaster, itemMasterID: $scope.ItemMasterID },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        $scope.ShowError = true;
                        $scope.CustomerError = $sce.trustAsHtml(response.data.d.ErrorMessage);
                        return false;
                    }
                    else {
                        $scope.ShowError = true;
                        $scope.CustomerError = $sce.trustAsHtml("New Item Added Successfully!");
                        $scope.AlertClass = "alert-success";
                        $scope.EnableSave = false;
                        $scope.RefreshItemMasterList();
                        if ($scope.ItemMasterID != undefined && $scope.ItemMasterID != null && $scope.ItemMasterID!=0)
                        $scope.GetItemRateList();
                        return false;
                    }

                }, function onFailure(error) {
                    $scope.ShowError = true;
                    $scope.CustomerError = response.data.d.ErrorCode;
                });

            };

            $scope.ValidateAdd = function () {
                var errors = "";
                if ($scope.ItemMaster.ItemCode == '' || $scope.ItemMaster.ItemCode == null) {
                    errors = '<li>Item Code</li>';
                }
                if ($scope.ItemMaster.ItemGroup == '' || $scope.ItemMaster.ItemGroup == null) {
                    errors += '<li>Item Group</li>';
                }
                if ($scope.ItemMaster.ItemDescription == '' || $scope.ItemMaster.ItemDescription == null) {
                    errors += '<li>Item Description</li>';
                }
                if ($scope.ItemMaster.ItemPrice == '' || $scope.ItemMaster.ItemPrice == null || isNaN($scope.ItemMaster.ItemPrice) || parseInt($scope.ItemMaster.ItemPrice)<=0) {
                    errors += '<li>Price</li>';
                }
               

                if (errors != "") {
                    $scope.ShowError = true;
                    $scope.CustomerError = $sce.trustAsHtml('<ul>' + errors + '</ul>');
                    $scope.AlertClass = "alert-danger";
                    return false;
                }

                return true;
            };

            $scope.RefreshItemMasterList = function () {
                if ($window != null && $window.opener != null && (typeof $window.opener.RefreshItemMasterList == 'function'))
                    $window.opener.RefreshItemMasterList();
            };

            $scope.GetItemRateList = function () {
                $scope.ItemRateLists = {};

                $http({
                    method: "POST",
                    url: "AddEditItemMaster.aspx/GetItemRatesList",
                    data: {ItemMasterID:$scope.ItemMasterID,ItemRateID:0},
                    dataType: "json",
                    headers: { contentType: "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.ItemRateLists = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.OnAddEditItemRateClick = function () {
                $scope.ShowErrorRate = false;
                $scope.CustomerErrorRate = "";

                if (!$scope.ValidateAddRate())
                    return false;

                $http({
                    method: "POST",
                    url: "AddEditItemMaster.aspx/AddEditItemRate",
                    data: {
                        StartDate: $scope.ItemRates.StartDate, ItemPrice: $scope.ItemRates.ItemPrice, ItemRateID: $scope.ItemRates.ItemRateID == null ? 0 : $scope.ItemRates.ItemRateID,
                        itemMasterID: $scope.ItemMasterID, TotalGST: $scope.ItemRates.TotalGST,
                        SGSTPer: $scope.ItemRates.SGSTPer, SGST: $scope.ItemRates.SGST, CGSTPer: $scope.ItemRates.CGSTPer, CGST: $scope.ItemRates.CGST, BillAmt: $scope.ItemRates.BillAmt
                    },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == -1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        $scope.ShowErrorRate = true;
                        $scope.CustomerErrorRate = $sce.trustAsHtml(response.data.d.ErrorMessage);
                        return false;
                    }
                    else {
                        $scope.ShowErrorRate = true;
                        $scope.CustomerErrorRate = $sce.trustAsHtml("Item Rate Saved Successfully!");
                        $scope.AlertClass = "alert-success";
                        $scope.GetItemRateList();
                        return false;
                    }

                }, function onFailure(error) {
                    $scope.ShowErrorRate = true;
                    $scope.CustomerErrorRate = error;
                });
            };

            $scope.ValidateAddRate = function () {
                var errors = "";
                if ($scope.ItemMasterID == 0 || $scope.ItemMaster.ItemCode == null) {
                    errors = '<li>Item Is not yet added</li>';
                }
                if ($scope.ItemRates.StartDate == '' || $scope.ItemRates.StartDate == null) {
                    errors += '<li>Start Date</li>';
                }
                
                if ($scope.ItemRates.ItemPrice == '' || $scope.ItemRates.ItemPrice == null || isNaN($scope.ItemRates.ItemPrice) || parseInt($scope.ItemRates.ItemPrice) <= 0) {
                    errors += '<li>Price</li>';
                }


                if (errors != "") {
                    $scope.ShowErrorRate = true;
                    $scope.CustomerErrorRate = $sce.trustAsHtml('<ul>' + errors + '</ul>');
                    $scope.AlertClass = "alert-danger";
                    return false;
                }

                return true;
            };

            $scope.OnAddEditItemRatePopUpClick = function (itemRate) {
                if (itemRate == null || itemRate==undefined)
                {
                    $scope.ItemRates = {StartDate: "", ItemPrice: null, ItemRateID: 0, TotalGST: null,
                        SGSTPer: null, SGST: null, CGSTPer: null, CGST: null, BillAmt: null};
                }
                else {
                    $scope.ItemRates = itemRate;
                    $scope.ItemRates.ItemRateID = itemRate.ItemRateID;

                    if (itemRate.StartDate == 'From Begining')
                    {
                        $scope.RateSaveDisabled=true;
                    }
                    else {
                        $scope.ItemRates.StartDate = itemRate.StartDate;
                        $scope.RateSaveDisabled = false;
                    }
                    
                    
                    $scope.ItemRates.ItemPrice = itemRate.ItemPrice;
                }
            };


            $scope.onChangeMasterPrice = function () {

                if ($scope.ItemMaster.ItemPrice != null && $scope.ItemMaster.ItemPrice != 0 && $scope.ItemMaster.ItemPrice != undefined
                    && $scope.ItemMaster.TotalGST != null && $scope.ItemMaster.TotalGST != 0 && $scope.ItemMaster.TotalGST != undefined
                    ) {

                    $scope.ItemMaster.SGSTPer = (parseFloat($scope.ItemMaster.TotalGST) / 2).toFixed(2);

                    $scope.ItemMaster.CGSTPer = (parseFloat($scope.ItemMaster.TotalGST) / 2).toFixed(2);

                    var TotalGSTAmt = parseFloat($scope.ItemMaster.ItemPrice) * (parseFloat($scope.ItemMaster.TotalGST) / 100.00);

                    $scope.ItemMaster.SGST = (parseFloat(TotalGSTAmt) / 2).toFixed(2);

                    $scope.ItemMaster.CGST = (parseFloat(TotalGSTAmt) / 2).toFixed(2);


                    $scope.ItemMaster.BillAmt = (parseFloat($scope.ItemMaster.ItemPrice) + parseFloat(TotalGSTAmt)).toFixed(2);
                }
                else if ($scope.ItemMaster.ItemPrice != null && $scope.ItemMaster.ItemPrice != 0 && $scope.ItemMaster.ItemPrice != undefined) {

                    $scope.ItemMaster.SGST = null;
                    $scope.ItemMaster.CGST = null;
                    $scope.ItemMaster.SGSTPer = null;
                    $scope.ItemMaster.CGSTPer = null;
                    $scope.ItemMaster.BillAmt = parseFloat($scope.ItemMaster.ItemPrice).toFixed(2);

                } else {
                    $scope.ItemMaster.SGST = null;
                    $scope.ItemMaster.CGST = null;
                    $scope.ItemMaster.SGSTPer = null;
                    $scope.ItemMaster.CGSTPer = null;
                    $scope.ItemMaster.BillAmt = null;
                }

            }

            $scope.OnTaxMasterChange = function () {
                if ($scope.ItemMaster.ItemPrice != null && $scope.ItemMaster.ItemPrice != 0 && $scope.ItemMaster.ItemPrice != undefined) {
                    var SGST = $scope.ItemMaster.SGST || 0;
                    var CGST = $scope.ItemMaster.CGST || 0;

                    $scope.ItemMaster.BillAmt = (parseFloat($scope.ItemMaster.ItemPrice) + parseFloat(SGST) + parseFloat(CGST)).toFixed(2);
                }

            }

            $scope.onChangePrice = function () {

                if ($scope.ItemRates.ItemPrice != null && $scope.ItemRates.ItemPrice != 0 && $scope.ItemRates.ItemPrice != undefined
                    && $scope.ItemRates.TotalGST != null && $scope.ItemRates.TotalGST != 0 && $scope.ItemRates.TotalGST != undefined
                    )
                {

                    $scope.ItemRates.SGSTPer = (parseFloat($scope.ItemRates.TotalGST) / 2).toFixed(2);

                    $scope.ItemRates.CGSTPer = (parseFloat($scope.ItemRates.TotalGST) / 2).toFixed(2);

                    var TotalGSTAmt = parseFloat($scope.ItemRates.ItemPrice) * (parseFloat($scope.ItemRates.TotalGST) / 100.00);

                    $scope.ItemRates.SGST = (parseFloat(TotalGSTAmt) / 2).toFixed(2);

                    $scope.ItemRates.CGST = (parseFloat(TotalGSTAmt) / 2).toFixed(2);


                    $scope.ItemRates.BillAmt = (parseFloat($scope.ItemRates.ItemPrice) + parseFloat(TotalGSTAmt)).toFixed(2);
                }
                else if ($scope.ItemRates.ItemPrice != null && $scope.ItemRates.ItemPrice != 0 && $scope.ItemRates.ItemPrice != undefined) {

                    $scope.ItemRates.SGST = null;
                    $scope.ItemRates.CGST = null;
                    $scope.ItemRates.SGSTPer = null;
                    $scope.ItemRates.CGSTPer = null;
                    $scope.ItemRates.BillAmt = parseFloat($scope.ItemRates.ItemPrice).toFixed(2);

                } else {
                    $scope.ItemRates.SGST = null;
                    $scope.ItemRates.CGST = null;
                    $scope.ItemRates.SGSTPer = null;
                    $scope.ItemRates.CGSTPer = null;
                    $scope.ItemRates.BillAmt = null;
                }

            }

            $scope.OnTaxChange = function () {
                if ($scope.ItemRates.ItemPrice != null && $scope.ItemRates.ItemPrice != 0 && $scope.ItemRates.ItemPrice != undefined) {
                        var SGST = $scope.ItemRates.SGST || 0;
                        var CGST = $scope.ItemRates.CGST || 0;
                    
                        $scope.ItemRates.BillAmt = (parseFloat($scope.ItemRates.ItemPrice) + parseFloat(SGST) + parseFloat(CGST)).toFixed(2);
                }

            }
        });

    </script>
</head>
<body>
    <form id="form1" runat="server" name="AddCustomer">
        <div class="col-lg-12 col-md-12 col-sm-12" data-ng-app="TailerApp" data-ng-controller="AddEditItemController" data-ng-init="init()">
            <div class="alert" data-ng-class="AlertClass" data-ng-show="ShowError">
                <span data-ng-bind-html="CustomerError" ></span>
            </div>
            <div class="card" style="margin-top: 5px;">
                <div class="card_header" style="border-bottom: 1px solid #00A5A8; padding-bottom: 8px; color: #00a5a8;">
                    Add New Item
			<span style="float: right">
                <span style="float: right">
                    <button class="client_btn" type="button" data-toggle="dropdown" data-ng-disabled="!EnableSave" style="border-color: #00A5A8 !important; background-color: #00B5B8" data-ng-click="AddEditItemMaster()">
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
                                <td style="text-align:right" class="back_shade">
                                    <span class="profileLabel"><span style="color:red">*</span> Item Code: </span>
                                </td>
                                <td>
                                    <span class="profileLabel">
                                        <input type="text" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="50" data-ng-model="ItemMaster.ItemCode"  required/>
                                    </span>
                                </td>
                                 <td style="text-align:right" class="back_shade">
                                    <span class="profileLabel"><span style="color:red">*</span> Item Group: </span>
                                </td>
                                <td colspan="5">
                                    <span class="profileLabel">
                                        <select class="form-control" id="drpItemGroup" data-ng-model="ItemMaster.ItemGroup"
                                             data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in ItemGroupPickLists.PickListItems track by custCat.PickListValue">
                                               <option value="">Select Group</option>
                                        </select>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel"><span style="color:red">*</span>Description:</span></td>
                                <td colspan="5">
                                   <span class="profileValue">
                                    <input type="text" data-ng-model="ItemMaster.ItemDescription" name="ItemDescription" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="200" required />
                                   </span>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Alias:</span></td>
                                <td colspan="5">
                                    <input type="text" data-ng-model="ItemMaster.ItemAlias" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="100" /></td>

                                
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel"><span style="color:red">*</span>Price:</span></td>
                                <td colspan="5">
                                    <input type="text" data-ng-model="ItemMaster.ItemPrice" ng-change="onChangeMasterPrice()" class="form-control" style="width: 250px; margin-left: 5px;  text-align:right;"  required />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Total GST %:</span></td>
                                <td colspan="5">
                                    <input type="text" data-ng-model="ItemMaster.TotalGST" ng-change="onChangeMasterPrice()" class="form-control" style="width: 250px; margin-left: 5px; text-align:right;" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">SGST {{ItemMaster.SGSTPer}}%:</span></td>
                                <td>
                                    <input type="text" data-ng-model="ItemMaster.SGST" ng-change="OnTaxMasterChange()" class="form-control" style="width: 250px; margin-left: 5px; text-align:right;" />
                                </td>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">CGST {{ItemMaster.CGSTPer}}%:</span></td>
                                <td>
                                    <input type="text" data-ng-model="ItemMaster.CGST" ng-change="OnTaxMasterChange()" class="form-control" style="width: 250px; margin-left: 5px; text-align:right;" />
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align:right" class="back_shade"><span class="profileLabel">Bill Amt:</span></td>
                                <td colspan="5">
                                    <input type="text" data-ng-model="ItemMaster.BillAmt" class="form-control" style="width: 250px; margin-left: 5px; text-align:right;" />
                                </td>
                            </tr>
                           
                        </tbody>
                    </table>
                    <div style="padding-bottom:5px">
                    </div>
                     <div class="panel panel-info">
                         <div class="panel-heading">
                             <h3 class="panel-title">Item Rates</h3>
                         </div>
                         <div class="panel-body">
                             <div class="row">
                                 <span class="pull-right" style="margin-right:5px">
                                     <button class="btn btn-lg btn-success" type="button" data-toggle="modal" data-target="#ItemRateModel" data-ng-click="OnAddEditItemRatePopUpClick(null)"><i class="fa fa fa-plus"></i></button>
                                 </span>
                                
                             </div>
                             <div class="row">
                                 <div class="col-lg-12 col-md-12 col-sm-12">
                                     <div class="card">
                                         <div class="row">
                                             <table class="table">
                                                 <thead>
                                                     <tr>
                                                         <th>Start Date</th>
                                                         <th>End Date</th>
                                                         <th>Item Price</th>
                                                         <th>Edit</th>
                                                     </tr>
                                                 </thead>
                                                 <tbody data-ng-repeat="ItemRate in ItemRateLists">
                                                     <tr>
                                                         <td>{{ItemRate.StartDate}}</td>
                                                         <td>{{ItemRate.EndDate}}</td>
                                                         <td>{{ItemRate.ItemPrice}}</td>
                                                         <td><a href="#" title="Edit Item" data-toggle="modal" data-target="#ItemRateModel" data-ng-click="OnAddEditItemRatePopUpClick(ItemRate)"><i class="fa fa-pencil" aria-hidden="true"></i></a></td>
                                                     </tr>
                                                 </tbody>
                                             </table>
                                         </div>
                                     </div>
                                 </div>

                             </div>
                         </div>
                     </div>
                </div>
            </div>

            <div id="ItemRateModel" class="modal fade" role="dialog">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                            <h4 class="modal-title">Add / Edit Rate</h4>
                        </div>
                        <div class="modal-body">
                            <div class="card_content">
                                <table style="width: 100%" class="profile_table">
                                    <tr>
                                        <td style="text-align: right" class="back_shade">
                                            <span class="profileLabel"><span style="color: red">*</span> Start Date:</span>
                                        </td>
                                        <td>
                                            <span class="profileLabel">
                                                <datepicker date-format="dd/MM/yyyy">
                                                      <input type="text" class="form-control" name="txtStartDate" id="txtStartDate" placeholder="Start Date" title="enter Start Date." data-ng-model="ItemRates.StartDate"/>
                                                </datepicker>
                                            </span>

                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade">
                                            <span class="profileLabel"><span style="color: red">*</span> Item Price:</span>
                                        </td>
                                        <td>
                                            <span class="profileLabel">
                                                <input type="text" data-ng-model="ItemRates.ItemPrice" class="form-control" ng-change="onChangePrice()" style="width: 250px; margin-left: 5px; text-align:right" required />
                                                <input type="hidden" id="hdnItemRateID" value="ItemRates.ItemRateID" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade">
                                            <span class="profileLabel"> Total GST %:</span>
                                        </td>
                                         <td>
                                            <span class="profileLabel">
                                                <input type="text" data-ng-model="ItemRates.TotalGST" class="form-control" ng-change="onChangePrice()" style="width: 250px; margin-left: 5px; text-align:right;" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade">
                                            <span class="profileLabel"> SGST {{ItemRates.SGSTPer}}%:</span>
                                        </td>
                                        <td>
                                            <span class="profileLabel">
                                                <input type="text" data-ng-model="ItemRates.SGST" class="form-control" ng-change="OnTaxChange()" style="width: 250px; margin-left: 5px; text-align:right" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade">
                                            <span class="profileLabel"> CGST {{ItemRates.CGSTPer}}%:</span>
                                        </td>
                                        <td>
                                            <span class="profileLabel">
                                                <input type="text" data-ng-model="ItemRates.CGST" class="form-control" ng-change="OnTaxChange()" style="width: 250px; margin-left: 5px; text-align:right" />
                                            </span>
                                        </td>
                                    </tr>
                                     <tr>
                                        <td style="text-align: right" class="back_shade">
                                            <span class="profileLabel"> Bill Amt:</span>
                                        </td>
                                        <td>
                                            <span class="profileLabel">
                                                <input type="text" data-ng-model="ItemRates.BillAmt" class="form-control" style="width: 250px; margin-left: 5px; text-align:right" />
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>

                                    </tr>
                                </table>
                            </div>
                            <div class="alert" data-ng-class="AlertClass" data-ng-show="ShowErrorRate">
                              <span data-ng-bind-html="CustomerErrorRate" ></span>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-lg btn-success" type="button" data-ng-disabled="RateSaveDisabled" data-ng-click="OnAddEditItemRateClick();"><i class="fas fa-plus-square"></i>&nbsp;Save</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
