<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Measurement.aspx.cs" Inherits="TailerApp.UI.Tailer.Measurement" %>

<asp:Content ID="content_Head" runat="server" ContentPlaceHolderID="HeaderContent">
    <link href="../Style/autocomplete.css" rel="stylesheet" />
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <%-- <script src="../../Scripts/AngularJS/autocomplete.js"></script>--%>
    <script src="../../Scripts/angular-datepicker.js"></script>
    <link href="../../Scripts/CalendarControl.css" rel="stylesheet" />
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/ui-bootstrap-tpls-1.3.2.js"></script>
    <link href="../Style/font-awesome.min.css" rel="stylesheet" />
    <script type="text/javascript" lang="javascript">

        var MeasurementID = "<%=MeasurementID%>";

        var tailerApp = angular.module("TailerApp", ['720kb.datepicker', 'ui.bootstrap']);

        tailerApp.directive('ngkeypressCtrl', function () {
            return function (scope, element, attrs) {
                var shiftDown = false;
                element.bind("keydown", function (event) {
                    // shift key code 16
                    if (event.which === 16) {
                        shiftDown = true;
                    }
                    // if enter pressed and shift is pressed then we send message
                    if (event.which === 13 && shiftDown) {
                        event.preventDefault();
                        scope.send();
                        scope.$apply();
                    }
                });
                //element.bind("keyup", function (event) {
                //    if (event.which === 16) {
                //        shiftDown = false;
                //    }
                //});
            };
        });

        tailerApp.directive('validCalendarDate', function () {
            return {
                require: 'ngModel',
                link: function (scope, element, attr, ngModelCtrl) {
                    var InputText = undefined;
                    element.on('blur', function () {
                        InputText = element[0].value;
                        if (InputText != '' && InputText != undefined) {
                            if (!validateUSDate(InputText)) {
                                alert('Invalid Date');
                                InputText = "";
                                element[0].focus();
                            }
                            else {
                                InputText = trimString(InputText);
                            }
                        }
                        ngModelCtrl.$setViewValue(InputText);
                        ngModelCtrl.$render();
                    });
                    return InputText;
                }
            };
        });


        tailerApp.controller("MeasurementController", function ($scope, $window, $http, $rootScope) {
            $scope.MeasurementID = $window.MeasurementID;
            $scope.MeasurementDetails = {};
            $scope.isDeleted = false;
            $scope.ItemList = {};
            $scope.SelectedItem = { ItemmasterID: 0, ItemDescription: '-Select-' };
            $scope.AccountCode = "";
            $scope.MeasurementField = [];

            $scope.GetMeasurementMaster = function () {
                $scope.MeasurementDetails = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetMeasurementMaster",
                    data: { MeasurMasterID: $scope.MeasurementID, isPrint: false },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    if (response.data.d.JSonstring2 != null && response.data.d.JSonstring2 != "")
                        $scope.MeasurementField = JSON.parse(response.data.d.JSonstring2);

                    if (response.data.d.JSonstring != null && response.data.d.JSonstring != "") {
                        $scope.MeasurementDetails = JSON.parse(response.data.d.JSonstring)[0];
                        if ($scope.MeasurementDetails.Account.AccountMasterID > 0)
                            $scope.GetAccountInvoiceList($scope.MeasurementDetails.Account.AccountMasterID, 1);
                    }

                    $scope.SelectedItem = angular.copy($scope.MeasurementDetails.SelectedItem);

                   

                }, function onFailure(error) {

                });
            };

            $scope.GetItemList = function (InvoiceID) {
                $scope.ItemList = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetItemList",
                    data: { InvoiceID: InvoiceID },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    //$scope.ItemList = JSON.parse(response.data.d.ItemsList);
                    $scope.ItemList = response.data.d.ItemsList;
                    if ($scope.SelectedItem != undefined && $scope.SelectedItem.ItemmasterID > 0 && $scope.MeasurementID == 0) {
                        if ($scope.ItemList.filter(function (x) { return x.ItemmasterID == $scope.SelectedItem.ItemmasterID }).length > 0)
                            $scope.MeasurementDetails.Qty = $scope.ItemList.filter(function (x) { return x.ItemmasterID == $scope.SelectedItem.ItemmasterID })[0].ItemQuantity;
                    }

                }, function onFailure(error) {

                });
            };


            $scope.GetMeasurementMaster();

            if ($scope.MeasurementID == 0)
                $scope.GetItemList(0);
   
            $scope.MeasurementFieldfilter = function (group) {
                return $scope.MeasurementField.filter(function (x) { return x.ItemGroup == group || x.ItemGroup == 'Mix' });
            }

            $scope.SaveMeasurementMaster = function () {
                $scope.MeasurementDetails.ItemID = $scope.SelectedItem.ItemmasterID;

                $scope.MeasurementDetails.AccountID = $scope.MeasurementDetails.Account.AccountMasterID;

                $scope.MeasurementField.forEach(function (item, index) {
                    var FValue = "";
                    if ($scope.MeasurementField[index].FieldValue != "" && $scope.MeasurementField[index].FieldValue != null && $scope.MeasurementField[index].FieldValue != undefined) {
                        if ($scope.MeasurementField[index].FieldValue.length > 0) {
                            $scope.MeasurementField[index].FieldValue.forEach(function (_item, _index) {
                                if (_item.val != '' && _item.val != null && _item.val != undefined)
                                    FValue += _item.val + ",";
                            });
                        }
                    }
                    $scope.MeasurementField[index].FValue = FValue;
                });

                var MeasurementDetails = JSON.stringify($scope.MeasurementDetails);
                var MeasurementField = JSON.stringify($scope.MeasurementField);

                $http({
                    method: "POST",
                    url: "Measurement.aspx/SaveMeasurementMaster",
                    data: { MeasurMasterID: $scope.MeasurementID, MeasurDetails: MeasurementDetails, MeasurementField: MeasurementField },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.MeasurementID = response.data.d.OutValue;

                    $window.alert('Save Succesfully');


                }, function onFailure(error) {
                    debugger;
                });
            };

            $scope.onClose = function () {
                $window.location.href = "MeasurementList.aspx";
                return false;
            }

            //**********//
            $scope.AccountList = {};

            $scope.GetAccountList = function () {
                $scope.AccountList = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetAccountList",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.AccountList = JSON.parse(response.data.d.JSonstring);


                }, function onFailure(error) {

                });
            };

            $scope.GetAccountList();


            $scope.AddItemToList = function (Obj) {
                debugger;
                Obj.$parent.Per.FieldValue.push({ val: 0 });
            }

            $scope.RemoveItemToList = function (Obj, i) {
                Obj.$parent.Per.FieldValue.splice(i, 1);
            }

            $scope.onSelect = function ($item, $model, $label, Obj) {
                $scope.GetAccountInvoiceList($item.AccountMasterID, 0);
                return false;
            }

            $scope.AccountInvoiceList = {};

            $scope.GetAccountInvoiceList = function (AccountID, Context) {
                $scope.AccountInvoiceList = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetAccountInvoiceList",
                    data: { AccountID: AccountID },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.AccountInvoiceList = JSON.parse(response.data.d.JSonstring);

                    if ($scope.AccountInvoiceList.length > 0 && Context == 0) {
                        $scope.MeasurementDetails.Invoice = $scope.AccountInvoiceList[0];
                        $scope.OnInvoiceChange($scope.AccountInvoiceList[0]);
                    } else {
                        $scope.GetItemList($scope.MeasurementDetails.Invoice.InvoiceID);
                    }

                }, function onFailure(error) {

                });
            };

            $scope.EmployeeList = {};

            $scope.GetEmployeeList = function () {
                $scope.EmployeeList = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetEmployee",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        $window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.EmployeeList = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            $scope.GetEmployeeList();

            $scope.GetEmployeebyPosition = function (Position) {
                return $scope.EmployeeList.filter(function (x) { return x.Position == Position });
            };

            $scope.OnInvoiceChange = function(obj){
                $scope.MeasurementDetails.TrialDate = obj.TrailTime;
                $scope.MeasurementDetails.DeliDate = obj.DeliveryTime;
                $scope.MeasurementDetails.MeasDate = obj.InvoiceDate;
                $scope.MeasurementDetails.SalesRep = { EmployeeMasterID: obj.SalesRepID, EmployeeName: '' };
                $scope.MeasurementDetails.Master = { EmployeeMasterID: obj.MasterID, EmployeeName: '' };
                $scope.MeasurementDetails.Designer = { EmployeeMasterID: obj.DesignerID, EmployeeName: '' };
                $scope.GetItemList(obj.InvoiceID);
            }

            $scope.onSelectedItemChange = function (obj) {
                if(obj.ItemQuantity)
                    $scope.MeasurementDetails.Qty = parseInt(obj.ItemQuantity);
            }

            $scope.PrintMeasurementMaster = function () {

                var width = 850;
                var height = 800;
                var left = (screen.width / 2) - (width / 2);
                var top = ((screen.height / 2) - (height / 2)) - 50;
                var windowFeatures = "width=" + width + ",height=" + height + ",status,resizable,scrollbars,modal,left=" + left + ",top=" + top + "";
                var URL = "../Tailer/PrintMeasurement.aspx?"
                var URLdata = "MeasurementID=" + $scope.MeasurementID;
                var winName = "Print Measurement"
                var navigateurl = URL + URLdata;
                var winobj = window.open(navigateurl, winName, windowFeatures);
                winobj.focus();
            }

            $scope.ctrlDown = false;
            $scope.ctrlKey = 17;

            $scope.keyDownFunc = function ($event) {

                if ($event.keyCode == $scope.ctrlKey)
                    $scope.ctrlDown = true;

                if ($scope.ctrlDown && $event.keyCode == 83) {
                    $scope.ctrlDown = false;
                    $scope.SaveMeasurementMaster();
                } else if ($scope.ctrlDown && $event.keyCode == 67) {
                    $scope.ctrlDown = false;
                    $scope.onClose();
                } else if ($scope.ctrlDown && $event.keyCode == 80) {
                    $scope.ctrlDown = false;
                    $scope.PrintMeasurementMaster();
                }

            };

            $scope.keyUpFunc = function ($event) {
                if ($event.keyCode == $scope.ctrlKey)
                    $scope.ctrlDown = false;
            };



        });


    </script>

    <style>
        .col-sm-1 {
            width: 12.33%;
            padding-right: 2px;
            padding-left: 2px;
        }

        .lbl-text-right {
            text-align: right;
            padding-top: 5px;
        }

        .text-sameLine {
            width: 50%;
            float: left;
        }

        ._720kb-datepicker-calendar-day._720kb-datepicker-today {
            background: #2e6e9e;
            color: white;
        }
    </style>

</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" data-ng-controller="MeasurementController">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Measurement
            </div>
        </div>
        <div class="row" ng-keydown="keyDownFunc($event)" ng-keyup="keyUpFunc($event)">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <div class="row">
                                <div class="col-lg-3 col-md-2 col-sm-3 pull-right">
                                    <button class="btn_ss bg-blue" type="button" ng-click="SaveMeasurementMaster()" data-toggle="dropdown">Save</button>
                                    <button class="btn_ss bg-blue" type="button" ng-show="MeasurementID>0" ng-click="PrintMeasurementMaster();" data-toggle="dropdown">Print</button>
                                    <button class="btn_ss bg-blue" type="button" ng-click="onClose();" data-toggle="dropdown">Close</button>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12">
                                    <div class="card">
                                        <div class="row">
                                            <table class="profile_table" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Account code:</span></td>
                                                        <td>
                                                            <input type="text" placeholder="Enter number" class="form-control"
                                                                style="max-width: 220px;" ng-model="MeasurementDetails.Account"
                                                                typeahead-on-select="onSelect($item, $model, $label, this);"
                                                                uib-typeahead="Account as Account.AccountCode for Account in AccountList |  filter:{AccountCode:$viewValue} | limitTo:10"
                                                                typeahead-show-hint="true" typeahead-min-length="0" class="web_txtbox" />
                                                            <%--</span>
                                                            <button title="Normal" class="btn btn-sm btn-success" type="button">
                                                                Refresh
                                                            </button>--%>
                                                        </td>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Measu No:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <input class="form-control ng-pristine ng-untouched ng-valid ng-empty ng-valid-maxlength" style="width: 95%; margin-left: 5px;" type="text" maxlength="10" data-ng-model="MeasurementDetails.MeasuNo">
                                                            </span>
                                                        </td>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Create Date:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <%--<input name="Debit" class="form-control ng-pristine ng-untouched ng-valid ng-empty ng-valid-maxlength" style="width: 95%; margin-left: 5px;" type="text" maxlength="10" data-ng-model="MeasurementDetails.MeasCreatedOn">--%>
                                                                <datepicker date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                                                <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="MeasurementDetails.MeasCreatedOn" 
						                                                style="width:110px;"/> 
				                                                </datepicker>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Account Name:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <input name="Debit" class="form-control-Multiple ng-pristine ng-untouched ng-valid ng-empty ng-valid-maxlength" style="width: 70%; margin-left: 5px;" type="text" maxlength="50" data-ng-model="MeasurementDetails.Account.AccountName">
                                                            </span>
                                                        </td>
                                                        <td class="back_shade" style="text-align: right;"><span class="profileLabel">Bill No:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <select class="form-control" ng-change="OnInvoiceChange(MeasurementDetails.Invoice)" data-ng-model="MeasurementDetails.Invoice" style="width: 95%; margin-left: 5px;"
                                                                    data-ng-options="Invoice.BillNumber for Invoice in AccountInvoiceList track by Invoice.InvoiceID">                                                              
                                                                </select>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                         <td class="back_shade" style="text-align: right;"><span class="profileLabel">Sales Rep:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <select class="form-control" data-ng-model="MeasurementDetails.SalesRep" style="width: 95%; margin-left: 5px;"
                                                                    data-ng-options="SalesRep.EmployeeName for SalesRep in GetEmployeebyPosition('SalesRep') track by SalesRep.EmployeeMasterID">  
                                                                    <option value="">Select</option>                                                            
                                                                </select>
                                                            </span>
                                                        </td>
                                                         <td class="back_shade" style="text-align: right;"><span class="profileLabel">Master:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <select class="form-control" data-ng-model="MeasurementDetails.Master" style="width: 95%; margin-left: 5px;"
                                                                    data-ng-options="Master.EmployeeName for Master in GetEmployeebyPosition('Master') track by Master.EmployeeMasterID"> 
                                                                    <option value="">Select</option>                                                             
                                                                </select>
                                                            </span>
                                                        </td>
                                                         <td class="back_shade" style="text-align: right;"><span class="profileLabel">Designer:</span></td>
                                                        <td>
                                                            <span class="profileValue">
                                                                <select class="form-control" data-ng-model="MeasurementDetails.Designer" style="width: 95%; margin-left: 5px;"
                                                                    data-ng-options="Designer.EmployeeName for Designer in GetEmployeebyPosition('Designer') track by Designer.EmployeeMasterID">                                                              
                                                                    <option value="">Select</option>
                                                                </select>
                                                            </span>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12 col-md-12 col-sm-12">
                                    <div class="card">
                                        <div class="row">
                                            <table class="profile_table" style="width: 100%;">
                                                <tbody>
                                                    <tr>
                                                        <td class="back_shade" style="text-align: right; width: 30%">
                                                            <span class="profileLabel">
                                                                <select class="form-control"
                                                                    ng-options="option.ItemDescription for option in ItemList track by option.ItemmasterID"
                                                                    ng-model="SelectedItem" ng-change="onSelectedItemChange(SelectedItem)">
                                                                </select>
                                                            </span>
                                                        </td>
                                                        <td style="width: 30%">
                                                            <span class="profileValue">
                                                                <input type="text" class="form-control" style="width: 100%" data-ng-model="MeasurementDetails.ItemDesc" />
                                                            </span>
                                                        </td>
                                                        <td style="width: 30%">{{SelectedItem.ItemGroup}}
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="panel-collapse collapse in">
                                <div class="panel-body">
                                    <div class="row">
                                        <div class="col-sm-2">
                                            <label for="txtFullName" class="lbl-text-right">Body/Fit</label>
                                            <div style="padding-left: 20px; padding-bottom: 5px;">
                                                <input type="text" class="form-control" style="padding-left: 20px;" ng-model="MeasurementDetails.BodyFit">
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <label for="txtFullName" class="lbl-text-right">Remark</label>
                                            <div style="padding-left: 20px; padding-bottom: 5px;">
                                                <input type="text" class="form-control" ng-model="MeasurementDetails.Remark">
                                            </div>
                                        </div>
                                        <%--<label for="drpSex" class="col-sm-1 lbl-text-right">Sex</label>
                                        <div class="col-sm-1">
                                            <select class="form-control" ng-model="EmployeeDetails.Gender">
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>--%>
                                    </div>
                                    <div class="row">
                                        <div class="col-sm-8">
                                            <div class="row">
                                                <div class="col-sm-4" ng-repeat="Per in MeasurementFieldfilter(SelectedItem.ItemGroup);">
                                                    <label for="drpSex" class="lbl-text-right">{{Per.FieldName}}</label>
                                                    <div ng-repeat="id in Per.FieldValue" style="padding-left: 20px; padding-bottom: 5px;">
                                                        <input type="number" class="form-control" ng-model="id.val" style="text-align: right; width: 50%; display: initial;" />
                                                        <i class="fa fa-remove" ng-show="Per.FieldValue.length > 1" ng-click="RemoveItemToList(this, $index)"></i>
                                                        <i ng-show="$last && $parent.Per.isRrepeat" style="display: block;" class="fa fa-plus-square" ng-click="AddItemToList(this)"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <label class="lbl-text-right">Trial Date</label>
                                                    <datepicker date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                                    <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="MeasurementDetails.TrialDate" 
						                                    style="width:110px;"/> 
				                                    </datepicker>

                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <label for="drpSex" class="lbl-text-right">Deli Date</label>
                                                    <%--<input type="text" class="form-control" ng-model="MeasurementDetails.DeliDate">--%>
                                                    <datepicker date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                                        <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="MeasurementDetails.DeliDate" 
						                                        style="width:110px;"/> 
				                                        </datepicker>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <label for="drpSex" class="lbl-text-right">Date</label>
                                                    <%--<input type="text" class="form-control" ng-model="MeasurementDetails.MeasDate">--%>
                                                    <datepicker date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					                                    <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="MeasurementDetails.MeasDate" 
						                                    style="width:110px;"/> 
				                                    </datepicker>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <label for="drpSex" class="lbl-text-right">Qty</label>
                                                    <input type="number" class="form-control" ng-model="MeasurementDetails.Qty">
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="col-sm-6">
                                                    <label for="drpSex" class="lbl-text-right">Weight</label>
                                                    <input type="number" class="form-control" ng-model="MeasurementDetails.MeasWeight">
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <%--<div class="form-group row">
                                        <label for="txtFullName" class="col-sm-1 lbl-text-right">Length</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text1">
                                        </div>
                                        <label for="txtFullName" class="col-sm-1 lbl-text-right">Soluder</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text2">
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Sleev</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text3">
                                        </div>
                                         <label for="drpSex" class="col-sm-1 lbl-text-right">Trial Date</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.TrialDate">
                                            <%--<input type="number" class="form-control" ng-model="MeasurementDetails.text3">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <%--<label for="txtAddress1" class="col-sm-1 lbl-text-right">Address Line 1</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.text4" />
                                        </div>
                                        <%--<label for="txtAddress2" class="col-sm-1 lbl-text-right">Address Line 2</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.text5" />
                                        </div>
                                        <div class="col-sm-3">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.text6" />
                                        </div>
                                        <label for="txtAddress2" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text7" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Deli Date</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.DeliDate">
                                            <%--<input type="number" class="form-control" ng-model="MeasurementDetails.text3">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">B.L.</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text8" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">   
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">Chest</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text9" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">weast</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text10" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">Seat</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text11" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Date</label>
                                        <div class="col-sm-1">
                                            <input type="text" class="form-control" ng-model="MeasurementDetails.MeasDate">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text12" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text13" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text14" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Qty</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.Qty">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text15" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text16" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text17" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">Neck</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control"  ng-model="MeasurementDetails.text18" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">alt+8</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text19" />
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text20" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">loose Sleev</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text21" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine"  ng-model="MeasurementDetails.text22" />
                                            <input type="text" class="form-control text-sameLine"  ng-model="MeasurementDetails.text23" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text24" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right"></label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.text25" />
                                        </div>
                                        <label for="drpSex" class="col-sm-1 lbl-text-right">Weight</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control" ng-model="MeasurementDetails.MeasWeight">
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="drpCountry" class="col-sm-1 lbl-text-right">CC</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine"  ng-model="MeasurementDetails.text26" />
                                            <input type="number" class="form-control text-sameLine"  ng-model="MeasurementDetails.text27" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">text28</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text28" />
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text29" />
                                        </div>
                                        <label for="drpState" class="col-sm-1 lbl-text-right">Bottom</label>
                                        <div class="col-sm-1">
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text30" />
                                            <input type="number" class="form-control text-sameLine" ng-model="MeasurementDetails.text31" />
                                        </div>
                                    </div>--%>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
