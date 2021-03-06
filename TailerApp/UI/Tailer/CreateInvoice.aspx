﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateInvoice.aspx.cs" Inherits="TailerApp.UI.Tailer.CreateInvoice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <%--<link href="../../Content/angular-auto-complete.css" rel="stylesheet" />
    <script src="../../Scripts/angular-auto-complete.js"></script>--%>
     <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/angular-datepicker.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/1.3.2/ui-bootstrap-tpls.js" ></script>
    <style type="text/css">
        .scrollable0panel{
            max-height: 500px;
            overflow: auto;
            min-height:300px;
        }
    </style>
     <script type="text/javascript">

         _CLIENT_HIDDEN_NAME = '';

         $(function () {
             CustomerAutoComplete('txtCustomer');
             CustomerAutoComplete('txtMobileNumber');
             ItemAutoComplete();
         });




         function CustomerAutoComplete(id) {
             $("#" + id).autocomplete({
                 minLength: 0,
                 source: GetCustomerBySearchKey,
                 focus: function (event, ui) {
                     $(this).val(ui.item.CustomerName);
                     return false;
                 },
                 select: function (event, ui) {
                     if ($(this)[0].id == 'txtMobileNumber') {
                         $(this).val(ui.item.CustomerMoNumber);
                         $("#txtCustomer").val(ui.item.Customer);
                     }
                     else {
                         $(this).val(ui.item.Customer);
                         $("#txtMobileNumber").val(ui.item.CustomerMoNumber);
                     }

                     $('#_HIDDEN_CUSTOMER_ID').val(ui.item.CustomerMasterID);
                     _CLIENT_HIDDEN_NAME = ui.item.CustomerName;


                     return false;
                 },
                 open: function () {
                     $(this).autocomplete('widget').css('z-index', 101);
                     return false;
                 }
             }).focus(function () {
                 var self = this;
                 window.setTimeout(function () {
                     if (self.value.length == 0)
                         $(self).autocomplete('search', '');
                 });
             });
         }


         function OnClientBlur(txtClientID) {

             var element = angular.element($('#txtCustomer'));
             var controller = element.controller();
             var scope = element.scope();

             if (txtClientID.value == "ALL" || txtClientID.value == "") {
                 $("#txtCustomer").val("");
                 $("#txtMobileNumber").val("");
                 scope.$apply(function () {
                     scope.CustInvoice.CustomerID = 0;
                     $('#_HIDDEN_CUSTOMER_ID').val(0);
                 });
             }
             else {
                 scope.$apply(function () {

                     scope.CustInvoice.CustomerID = angular.element(document.getElementById("_HIDDEN_CUSTOMER_ID")).val();
                     scope.CustInvoice.MobileNumber = angular.element(document.getElementById("txtMobileNumber")).val();
                     if (scope.CustInvoice.CustomerID == 0 || scope.CustInvoice.CustomerID == undefined || scope.CustInvoice.CustomerID == null || scope.CustInvoice.CustomerID == "") {
                         element.val("");
                         $("#txtCustomer").val("");
                         $("#txtMobileNumber").val("");
                         $('#_HIDDEN_CUSTOMER_ID').val(0);
                     }
                     //else {
                     //    _OnClientSelection(scope.ClientID);
                     //}
                 });
             }
         }

         function _OnTextBoxFocus(obj) {
             try {
                 if (obj != null && obj != undefined) {
                     if (obj.value != "ALL" && obj.value != "Select" && obj.value != "--Select--" && obj.value != "- Select -" && obj.value != "") {
                         if ($('#_HIDDEN_CUSTOMER_ID').val() != "0")
                             _CLIENT_HIDDEN_NAME = obj.value;
                     }
                 }
             } catch (e) { }
         }

         function GetCustomerBySearchKey(request, response) {
             var _Url = "CreateInvoice.aspx/SearchCustomers";

             $.ajax({
                 type: "POST",
                 url: _Url,
                 data: JSON.stringify({ searchText: request.term }),
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 dataFilter: function (data) {
                     //return $.parseJSON(data).d.records
                     return $.parseJSON(data).d.JSonstring;
                 },
                 success: function (data) {
                     //if (data.length == 0) {
                     //}

                     response($.map(data, function (item) {
                         return {
                             label: item.CustomerName,
                             CustomerName: item.CustomerName,
                             CustomerMasterID: item.CustomerMasterID,
                             CustomerMoNumber: item.CustomerMoNumber,
                             Customer: item.Customer
                         }
                     }
                         ))
                 },
                 failure: function (msg) {
                     alert(msg);
                 }
             });
         }

         //***********************************************************************************
         function ItemAutoComplete() {
             $(".ItemAutoComplete").autocomplete({
                 minLength: 0,
                 source: GetItemBySearchKey,
                 focus: function (event, ui) {
                     $(this).val(ui.item.ItemCode);
                     return false;
                 },
                 select: function (event, ui) {
                     $(this).val(ui.item.ItemCode);
                     $(this).data('ItemmasterID', ui.item.ItemmasterID);

                     return false;
                 },
                 open: function () {
                     $(this).autocomplete('widget').css('z-index', 101);
                     return false;
                 }
             }).focus(function () {
                 var self = this;
                 window.setTimeout(function () {
                     if (self.value.length == 0)
                         $(self).autocomplete('search', '');
                 });
             });
         }


         function OnItemBlur(txtClientID) {

             var element = angular.element($(txtClientID));
             var controller = element.controller();
             var scope = element.scope();

             if (angular.element(document.getElementById("txtCustomer")).val() == "ALL" || angular.element(document.getElementById("txtCustomer")).val() == "") {
                 scope.$apply(function () {
                     scope.CustInvoice.CustomerID = 0;
                     $('#_HIDDEN_CUSTOMER_ID').val(0);
                 });
             }
             else {
                 scope.$apply(function () {

                     scope.CustInvoice.CustomerID = angular.element(document.getElementById("_HIDDEN_CUSTOMER_ID")).val();
                     if (scope.CustInvoice.CustomerID == 0 || scope.CustInvoice.CustomerID == undefined || scope.CustInvoice.CustomerID == null || scope.CustInvoice.CustomerID == "") {
                         element.val("");
                         $('#_HIDDEN_CUSTOMER_ID').val(0);
                     }
                     //else {
                     //    _OnClientSelection(scope.ClientID);
                     //}
                 });
             }
         }

         function _OnTextBoxFocusItem(obj) {
             try {
                 if (obj != null && obj != undefined) {
                     if (obj.value != "ALL" && obj.value != "Select" && obj.value != "--Select--" && obj.value != "- Select -" && obj.value != "") {
                         if ($('#_HIDDEN_CUSTOMER_ID').val() != "0")
                             _CLIENT_HIDDEN_NAME = obj.value;
                     }
                 }
             } catch (e) { }
         }

         function GetItemBySearchKey(request, response) {
             var _Url = "CreateInvoice.aspx/SearchItems";

             $.ajax({
                 type: "POST",
                 url: _Url,
                 data: JSON.stringify({ searchText: request.term }),
                 contentType: "application/json; charset=utf-8",
                 dataType: "json",
                 dataFilter: function (data) {
                     //return $.parseJSON(data).d.records
                     return $.parseJSON(data).d.JSonstring;
                 },
                 success: function (data) {
                     //if (data.length == 0) {
                     //}
                     ItemMaster.ItemmasterID, ItemMaster.ItemDescription, ItemMaster.ItemCode, ItemMaster.ItemPrice, ItemMaster.ItemGroup
                     response($.map(data, function (item) {
                         return {
                             label: item.ItemCode,
                             ItemmasterID: item.ItemmasterID,
                             ItemDescription: item.ItemDescription,
                             ItemCode: item.ItemCode,
                             ItemPrice: item.ItemPrice,
                             ItemGroup: item.ItemGroup
                         }
                     }
                         ))
                 },
                 failure: function (msg) {
                     alert(msg);
                 }
             });
         }

         var tailerApp = angular.module("TailerApp", ['ui.bootstrap', '720kb.datepicker']);//'autoCompleteModule'
         tailerApp.controller("CreateInvoiceController", function ($scope, $window, $http, $rootScope, $filter, $sce) {
             $scope.InvoiceList = [];
             $scope.TotalAmount = 0.00;
             $scope.CustInvoice = {};
             $scope.InvoicePickLists = {};
             $scope.ItemCodes = [];
             $scope.customerID = 0;
             $scope.IsCalculateTax = true;
             $scope.LatestSeriesMaster = {};
             $scope.InvoiceID = 0;
             var d = new Date();
             $scope.CustInvoice.InvoiceDate = d.getDate() + '/' + (d.getMonth() + 1) + '/' + d.getFullYear();
             $scope.CustInvoice.PaymentNumber = { PickListValue: "Cash", PickListLabel: "Cash" };
             $scope.init = function () {
                 $scope.ShowError = false;
                 $scope.InvoiceError = '';
                 $scope.AlertClass = "alert-danger";
                 $scope.InvoicePickLists = {};
                 $scope.GetInvoiceDropdowns();
                 $scope.GetItemCodes();
                 $scope.AddItem();
             }

             $scope.AddItem = function () {
                 var invoice = {
                     ItemMasterID: 0,
                     ItemCode: "",
                     ItemDescription: "",
                     ItemQuantity: 1,
                     ItemPrice: "",
                     ItemDiscount: "",
                     ItemDiscountPer: "",
                     GST: 0,
                     SGST: 0,
                     GSTP: null,
                     SGSTP: null,
                     AmountPending: "",
                     BasePrice: 0,
                     TotalGST: 0
                 }

                 $scope.InvoiceList.push(invoice);
             }

             $scope.RemoveItem = function () {
                 $scope.InvoiceList.pop();
                 $scope.CalculateTotal();
             }

             $scope.OnAddNewCustomerClick = function () {
                 var left = (screen.width / 2) - (850 / 2);
                 var top = (screen.height / 2) - (500 / 2);
                 $window.open("AddNewCustomer.aspx?contextFrom=2", "AddCustomer", 'resizable=yes,location=1,status=1,scrollbars=1,width=850,height=500,top=' + top + ', left=' + left);
                 return false;
             };

             $scope.onItemChange = function (InvoiceItem, isCalculateTotal) {
                 isCalculateTotal =  isCalculateTotal || true;
                 if (InvoiceItem != null && InvoiceItem != undefined && !isNaN(InvoiceItem.ItemQuantity) && !isNaN(InvoiceItem.ItemPrice)) {
                     
                     var BasePrice = parseInt(InvoiceItem.ItemQuantity) * parseFloat(InvoiceItem.ItemPrice);

                     InvoiceItem.BasePrice = BasePrice;

                     if (!isNaN(InvoiceItem.ItemDiscountPer) && parseFloat(InvoiceItem.ItemDiscountPer) > 0) {
                         InvoiceItem.BasePrice = (parseFloat(BasePrice) - (parseFloat(BasePrice) * (parseFloat(InvoiceItem.ItemDiscountPer) / 100.00))).toFixed(2);
                         InvoiceItem.ItemDiscount = (parseFloat(BasePrice) * (parseFloat(InvoiceItem.ItemDiscountPer) / 100.00)).toFixed(2);
                     } else {
                         InvoiceItem.BasePrice = BasePrice;
                         InvoiceItem.ItemDiscount = null;
                     }

                     InvoiceItem.AmountPending = parseFloat(InvoiceItem.BasePrice);

                     if (!isNaN(InvoiceItem.TotalGST) && parseFloat(InvoiceItem.TotalGST) > 0) {

                         var TotalGSTAmt = parseFloat(InvoiceItem.BasePrice) * (parseFloat(InvoiceItem.TotalGST) / 100.00);

                         InvoiceItem.GST = (parseFloat(TotalGSTAmt) / 2).toFixed(2);

                         InvoiceItem.SGST = (parseFloat(TotalGSTAmt) / 2).toFixed(2);

                         InvoiceItem.AmountPending = parseFloat(InvoiceItem.BasePrice) + parseFloat(TotalGSTAmt);
                     }


                     //if (!isNaN(InvoiceItem.GST) && parseFloat(InvoiceItem.GST) > 0)
                     //    InvoiceItem.AmountPending = parseFloat(InvoiceItem.AmountPending) + parseFloat(InvoiceItem.GST);

                     //if (!isNaN(InvoiceItem.SGST) && parseFloat(InvoiceItem.SGST) > 0)
                     //    InvoiceItem.AmountPending = parseFloat(InvoiceItem.AmountPending) + parseFloat(InvoiceItem.SGST);

                     InvoiceItem.AmountPending = parseFloat(InvoiceItem.AmountPending).toFixed(2);

                     //if (parseFloat(InvoiceItem.AmountPending) > 0) {
                         
                             

                         //if ($scope.IsCalculateTax)
                         //{
                         //    if (!isNaN(InvoiceItem.GSTP) && InvoiceItem.GSTP > 0)
                         //    {
                         //        InvoiceItem.GST =parseFloat(InvoiceItem.AmountPending) - (parseFloat(InvoiceItem.AmountPending) * (100 / (100 + InvoiceItem.GSTP)));
                         //    }
                         //    else {
                         //        InvoiceItem.GST = 0.00;
                         //    }
                             
                         //    if (!isNaN(InvoiceItem.SGSTP) && InvoiceItem.SGSTP > 0)
                         //    {
                         //        InvoiceItem.SGST =parseFloat(InvoiceItem.AmountPending) - (parseFloat(InvoiceItem.AmountPending) * (100 / (100 + InvoiceItem.SGSTP)));
                         //    }
                         //    else {
                         //        InvoiceItem.SGST = 0.00;
                         //    }
                            
                         //}
                         //else {
                         //    if (!isNaN(InvoiceItem.GSTP) && InvoiceItem.GSTP > 0)
                         //        InvoiceItem.GST = parseFloat(InvoiceItem.AmountPending) * (InvoiceItem.GSTP / 100.00);
                         //    else
                         //        InvoiceItem.GST = 0.00;

                         //    if (!isNaN(InvoiceItem.SGSTP) && InvoiceItem.SGSTP > 0)
                         //        InvoiceItem.SGST = parseFloat(InvoiceItem.AmountPending) * (InvoiceItem.SGSTP / 100.00);
                         //    else
                         //        InvoiceItem.SGST = 0.00;
                         //}

                         //InvoiceItem.GST =parseFloat(parseFloat(InvoiceItem.GST).toFixed(2));
                         //InvoiceItem.SGST = parseFloat(parseFloat(InvoiceItem.SGST).toFixed(2));

                         //if ($scope.IsCalculateTax)
                         //    InvoiceItem.AmountPending = parseFloat(parseFloat(InvoiceItem.AmountPending - InvoiceItem.GST - InvoiceItem.SGST).toFixed(2));
                         //else
                         //    InvoiceItem.AmountPending = parseFloat(parseFloat(InvoiceItem.AmountPending + InvoiceItem.GST + InvoiceItem.SGST).toFixed(2));
                
                     //}

                     if (isCalculateTotal)
                        $scope.CalculateTotal();
                 }
             }

             $scope.ReCalculateTax = function () {
                 if ($scope.InvoiceList != null && $scope.InvoiceList != undefined) {
                     angular.forEach($scope.InvoiceList, function (InvoiceItem) {
                         if (InvoiceItem != null && InvoiceItem != undefined ) {
                             $scope.onItemChange(InvoiceItem);
                         }
                     });
                 }
             };

             $scope.CalculateTotal = function () {
                 $scope.TotalAmount = 0;
                 $scope.TotalBasePrice = 0;
                 $scope.TotalCGST = 0;
                 $scope.TotalSGST = 0;
                 $scope.TotalLessRsAmount = 0;
                 if ($scope.InvoiceList != null && $scope.InvoiceList != undefined) {
                     angular.forEach($scope.InvoiceList, function (InvoiceItem) {
                         if (InvoiceItem != null && InvoiceItem != undefined) {
                             if (!isNaN(InvoiceItem.AmountPending))
                                 $scope.TotalAmount = parseFloat($scope.TotalAmount) + parseFloat(InvoiceItem.AmountPending);

                             if (!isNaN(InvoiceItem.BasePrice))
                                 $scope.TotalBasePrice = parseFloat($scope.TotalBasePrice) + parseFloat(InvoiceItem.BasePrice);

                             if (!isNaN(InvoiceItem.GST))
                                 $scope.TotalCGST = parseFloat($scope.TotalCGST) + parseFloat(InvoiceItem.GST);

                             if (!isNaN(InvoiceItem.SGST))
                                 $scope.TotalSGST = parseFloat($scope.TotalSGST) + parseFloat(InvoiceItem.SGST);

                             if (!isNaN(InvoiceItem.ItemDiscount) && InvoiceItem.ItemDiscount != null)
                                 $scope.TotalLessRsAmount = parseFloat($scope.TotalLessRsAmount) + parseFloat(InvoiceItem.ItemDiscount);
                         }
                     });
                 }
         
                 //$scope.TotalAmount = parseFloat(parseFloat($scope.TotalAmount).toFixed(2));
                 $scope.CalculateNetAmount();
             
             }

             $scope.CalculateNetAmount = function () {
                 $scope.CustInvoice.NetAmount = Math.round($scope.TotalAmount);
                 $scope.CustInvoice.RoundOnOff = (Math.round($scope.TotalAmount) - $scope.TotalAmount).toFixed(2);
                 $scope.CustInvoice.TotalAmount = $scope.TotalAmount.toFixed(2);
                 $scope.TotalAmount = Math.round($scope.TotalAmount);
                 $scope.CustInvoice.TotalBasePrice = $scope.TotalBasePrice;
                 $scope.CustInvoice.TotalCGST = $scope.TotalCGST;
                 $scope.CustInvoice.TotalSGST = $scope.TotalSGST;
                 $scope.CustInvoice.LessRsAmount = $scope.TotalLessRsAmount.toFixed(2);
             }

             $scope.onLessRsChange = function () {
                 angular.forEach($scope.InvoiceList, function (InvoiceItem) {
                     if (InvoiceItem != null && InvoiceItem != undefined) {
                         if (!isNaN($scope.CustInvoice.LessRs))
                             InvoiceItem.ItemDiscountPer = $scope.CustInvoice.LessRs
                         else
                             InvoiceItem.ItemDiscountPer = null;

                         $scope.onItemChange(InvoiceItem);
                     }
                 });

                 $scope.CalculateTotal();
             }

             //$scope.autoCompleteOptions = {
             //    minimumChars: 1,
             //    selectedTextAttr: 'CustomerName',
             //    data: function (searchText) {
             //        return $http.get('CreateInvoice.aspx/SearchCustomers')
             //            .then(function (response) {
             //                searchText = searchText.toUpperCase();

             //                // ideally filtering should be done on the server
             //                var states = _.filter(response.data, function (customers) {
             //                    return customers.CustomerName;
             //                });

             //                return _.pluck(states, 'name');
             //            });
             //    }
             //}

             $scope.GetInvoiceDropdowns = function () {
                 $scope.CustomerPickLists = {};

                 $http({
                     method: "POST",
                     url: "CreateInvoice.aspx/GetInvoicePickLists",
                     data: { customerID: $scope.customerID },
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

                     $scope.InvoicePickLists = response.data.d;

                 }, function onFailure(error) {

                 });
             };

             $scope.GetItemCodes = function () {
                 if ($scope.ItemCodes == null || $scope.ItemCodes.length == 0) {
                     $scope.ItemCodes = [];
                     try {
                         $http(
                        {
                            method: "POST",
                            url: "CreateInvoice.aspx/SearchItems",
                            dataType: 'json',
                            data: { searchText: '' },
                            headers: {
                                "Content-Type": "application/json"
                            }
                        }).then(function successCallback(response) {
                            if (response.data.d.JSonstring != "")
                                $scope.ItemCodes = JSON.parse(response.data.d.JSonstring);
                            else
                                $window.alert("There are no Items.")

                        }, function errorCallback(response) {
                            $scope.WarningMessages = "Failed to load Items list";
                            $log.info(response);
                        });
                     }
                     catch (err) {
                         alert(err);
                     }
                 }

                 return $scope.ItemCodes;
             }

             $scope.onItemSelect = function ($item, $model, $label, $index) {
                 var invoice = {
                     ItemMasterID: $item.ItemmasterID,
                     ItemCode: $item.ItemCode,
                     ItemDescription: $item.ItemDescription,
                     ItemQuantity: 1,
                     ItemPrice: $item.ItemPrice.toFixed(2),
                     ItemDiscountPer: "",
                     ItemDiscount: "",
                     GST: $item.CGST,
                     SGST: $item.SGST,
                     ItemGST: $item.CGST,
                     ItemSGST: $item.SGST,
                     GSTP: $item.CGSTPer,
                     SGSTP: $item.SGSTPer,
                     AmountPending: $item.BillAmt,
                     BillAmt: $item.BillAmt,
                     BasePrice: $item.ItemPrice.toFixed(2),
                     TotalGST: $item.TotalGST
                 }

                 $scope.InvoiceList[$index] = invoice;

                 $scope.onItemChange($scope.InvoiceList[$index]);
             }

             $scope.ValidateInvoiceCreation = function () {
                 var errors = "";
                 var isWrongItemExists = false;
                 if (isNaN($scope.CustInvoice.CustomerID) || parseInt($scope.CustInvoice.CustomerID) == 0) {
                     errors = '<li>Customer Name</li>';
                 }
                 if ($scope.CustInvoice.MobileNumber == '' || $scope.CustInvoice.MobileNumber == null) {
                     errors += '<li>Mobile Number</li>';
                 }
                 if (isNaN($scope.CustInvoice.MasterID) || $scope.CustInvoice.MasterID == null) {
                     errors += '<li>Master</li>';
                 }
                 if (isNaN($scope.CustInvoice.DesignerID) || $scope.CustInvoice.DesignerID == null) {
                     errors += '<li>Designer</li>';
                 }
                 if ($scope.InvoiceList == null || $scope.InvoiceList.length == 0) {
                     errors += '<li>Invoice Line Items</li>';
                 }
                 else {
                     angular.forEach($scope.InvoiceList, function (invoice) {
                         if (isNaN(invoice.ItemMasterID) || invoice.ItemMasterID == null || invoice.ItemMasterID == 0) {
                             isWrongItemExists = true;
                         }
                     });

                     if (isWrongItemExists) {
                         errors += '<li>Enter Correct Item Code</li>';
                     }
                 }



                 if (errors != "") {
                     $scope.ShowError = true;
                     $scope.InvoiceError = $sce.trustAsHtml('<ul>' + errors + '</ul>');
                     $scope.AlertClass = "alert-danger";
                     return false;
                 }

                 return true;

             }

             $scope.onCreateInvoiceClick = function () {
                 $scope.ShowError = false;
                 $scope.InvoiceError = "";

                 if (!$scope.ValidateInvoiceCreation())
                     return false;



                 $http({
                     method: "POST",
                     url: "CreateInvoice.aspx/CreateNewInvoice",
                     data: { customerInvoice: $scope.CustInvoice, InvoiceList: $scope.InvoiceList },
                     dataType: "json",
                     headers: { "Content-Type": "application/json" }
                 }).then(function onSuccess(response) {
                     if (response.data.d.ErrorCode == -1001) {
                         //Session Expired
                         return false;
                     }
                     if (response.data.d.ErrorCode != 0) {
                         $scope.ShowError = true;
                         $scope.InvoiceError = $sce.trustAsHtml(response.data.d.ErrorMessage);
                         return false;
                     }
                     else {
                         $scope.ShowError = true;
                         $scope.InvoiceError = $sce.trustAsHtml("Invoice Created Successfully! <b> Bill Number :" + response.data.d.JSonstring + "<b>");
                         $scope.AlertClass = "alert-success";
                         $scope.InvoiceID = response.data.d.OutValue;

                         return false;
                     }

                 }, function onFailure(error) {
                     $scope.ShowError = true;
                     $scope.InvoiceError = error.statusText;
                 });


             };

             $scope.GetLatestSeriesMaster = function () {

                 $http({
                     method: "POST",
                     url: "CreateInvoice.aspx/GetLatestSeriesMaster",
                     data: { },
                     dataType: "json",
                     headers: { "Content-Type": "application/json" }
                 }).then(function onSuccess(response) {
                     if (response.data.d.ErrorCode == -1001) {
                         //Session Expired
                         return false;
                     }
                     if (response.data.d.ErrorCode != 0) {
                         $scope.ShowError = true;
                         $scope.InvoiceError = $sce.trustAsHtml(response.data.d.ErrorMessage);
                         return false;
                     }
                     else {
                         $scope.LatestSeriesMaster = JSON.parse(response.data.d.JSonstring)[0];

                         if($scope.LatestSeriesMaster != undefined)
                         {
                             $scope.CustInvoice.InvoiceSeries =
                                   $scope.LatestSeriesMaster.Prefix +
                                   ($scope.LatestSeriesMaster.WithZero && $scope.LatestSeriesMaster.Width > 0 && $scope.LatestSeriesMaster.Width > ($scope.LatestSeriesMaster.Prefix + $scope.LatestSeriesMaster.LastValue).length ? $scope.repeatstr($scope.LatestSeriesMaster.Width - ($scope.LatestSeriesMaster.Prefix + $scope.LatestSeriesMaster.LastValue).length) : '')
                                    + $scope.LatestSeriesMaster.LastValue;

                             $scope.CustInvoice.BillNumber = $scope.LatestSeriesMaster.LastValue;
                         }

                     }

                 }, function onFailure(error) {
                     $scope.ShowError = true;
                     $scope.InvoiceError = response.data.d.ErrorCode;
                 });

             };

             $scope.GetLatestSeriesMaster();

             $scope.repeatstr = function (num) {
                 var ar = new Array();

                 if (num > 0)
                     ar = new Array(num + 1).join("0");

                 return ar;
             }

             $scope.onPrintInvoiceDetailsClick = function () {
                 var left = (screen.width / 2) - (1100 / 2);
                 var top = (screen.height / 2) - (600 / 2);
                 $window.open("PrintInvoiceDetails.aspx?InvoiceID=" + $scope.InvoiceID, "PrintInvoiceDetails", 'resizable=yes,location=1,status=1,scrollbars=1,width=1100,height=600,top=' + top + ', left=' + left);
                 return false;
             };

             $scope.onMeasureClick = function (Measur) {
                 $window.location.href = "Measurement.aspx?InvoiceID=" + $scope.InvoiceID;
                 return false;
             };

         });
     </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="CreateInvoiceController" data-ng-init="init()">
         <div class="row">
            <div class="page-header-new col-lg-12">
                Create New Invoice
            </div>
        </div>
        <div class="row">
             <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <table style="width:100%" class="profile_table">
                            <tbody>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Series:</span></td>
                                    <td>
                                        <span class="profileValue" style="font-weight:bold;">
                                            {{CustInvoice.InvoiceSeries}}
                                            <%--<select class="form-control" id="drpSeries" data-ng-model="CustInvoice.InvoiceSeries" style="width:80%"
                                                    data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.AccountSeries track by custCat.PickListValue">
                                                    <option value="">None</option>
                                            </select>--%>
                                        </span>
                                        <button class="btn btn-sm btn-success" type="button" title="Normal" style="display:none">
                                              <i class="fa fa-dot-circle-o" aria-hidden="true"></i>
                                            </button>
                                    </td>
                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Mobile:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.MobileNumber" id="txtMobileNumber" name="MobileNumber" 
                                                    class="form-control-Multiple autopop-textbox-Search" style="width: 95%; margin-left: 5px;" maxlength="10" 
                                                    placeholder="{{CustInvoice.MobileNumber}}"
                                                    onblur="OnClientBlur(this);" onfocus="_OnTextBoxFocus(this)"
                                                    />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Bill#:</span></td>
                                    <td >
                                        <span class="profileValue" style="font-weight:bold; min-width:50px;">
                                            {{CustInvoice.BillNumber}}
                                           <%-- <input type="text" data-ng-model="CustInvoice.BillNumber" name="BillNumber" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />--%>
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                             <datepicker date-format="dd/MM/yyyy" >
                                                      <input type="text" data-ng-model="CustInvoice.InvoiceDate" name="InvoiceDate" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                              </datepicker>
                                           
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Customer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.CustomerName" name="Debit" id="txtCustomer" 
                                                class="form-control-Multiple autopop-textbox-Search" 
                                                style="width: 70%; margin-left: 5px;" maxlength="50"
                                                placeholder="{{CustInvoice.CustomerName}}"
                                                onblur="OnClientBlur(this);" onfocus="_OnTextBoxFocus(this)"
                                                 /> <%--auto-complete="autoCompleteOptions"--%>
                                           <button class="btn btn-sm btn-success" type="button" title="Order" data-ng-click="OnAddNewCustomerClick()">
                                               <i class="fa fa-address-card-o" aria-hidden="true"></i>
                                            </button>
                                                                                       
                                            <input type="hidden" id="_HIDDEN_CUSTOMER_ID" value="0"  />
                                         </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Trail Date:</span></td>
                                    <td >
                                       
                                            <table>
                                                <tr>
                                                    <td>
                                                        <datepicker date-format="dd/MM/yyyy" >
                                                             <input type="text" data-ng-model="CustInvoice.TrailDate" name="TrailDate" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                                        </datepicker>
                                                    </td>
                                                    <td>
                                                        <input type="number" data-ng-model="CustInvoice.TrailTime" name="TrailTime" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-sm btn-success" type="button" title="Book">
                                                          <i class="fa fa-book" aria-hidden="true"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </table>
                                       
                                    </td>
                                    <td colspan="4" rowspan="2">
                                        <span style="text-align:right;font-weight:bold;font-size:20px;float:right" >
                                            {{TotalAmount | currency : '' }}
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Sales Rep:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <select class="form-control" id="drpInvoiceSalesRep" data-ng-model="CustInvoice.SalesRepID" style="width: 95%; margin-left: 5px;" 
                                                     data-ng-options="custCat.EmployeeMasterID as custCat.EmployeeName for custCat in InvoicePickLists.SalesReps track by custCat.EmployeeMasterID">
                                                 <option value="">Select</option>
                                             </select>
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Delivery Date:</span></td>
                                    <td >
                                        <table>
                                            <tr>
                                                <td>
                                                    <datepicker date-format="dd/MM/yyyy" >
                                                              <input type="text" data-ng-model="CustInvoice.DeliveryDate" name="DeliveryDate" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                                        </datepicker>
                                                </td>
                                                <td>
                                                    <input type="number" data-ng-model="CustInvoice.DeliveryTime" name="DeliveryTime" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-success" type="button" title="Refresh">
                                                      <i class="fa fa-refresh" aria-hidden="true"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        </table>                                       
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Master:</span></td>
                                    <td>

                                        <span class="profileValue">
                                            <select class="form-control" id="drpInvoiceMaster" data-ng-model="CustInvoice.MasterID" style="width: 95%; margin-left: 5px;" 
                                                     data-ng-options="custCat.EmployeeMasterID as custCat.EmployeeName for custCat in InvoicePickLists.Masters track by custCat.EmployeeMasterID">
                                                 <option value="">Select</option>
                                             </select>
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Designer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <select class="form-control" id="drpInvoiceDesigner" data-ng-model="CustInvoice.DesignerID" style="width: 95%; margin-left: 5px;" 
                                                     data-ng-options="custCat.EmployeeMasterID as custCat.EmployeeName for custCat in InvoicePickLists.Designers track by custCat.EmployeeMasterID">
                                                 <option value="">Select</option>
                                             </select>
                                        </span>
                                    </td>
                                    <td colspan="4" style="text-align:right">
                                       <%-- <input type="checkbox" data-ng-model="IsCalculateTax" data-ng-change="ReCalculateTax()" /> Include Tax--%>
                                        <button class="btn_ss bg-blue" type="button" data-ng-click="onCreateInvoiceClick();"><i class="fa fa-dollar"></i>Create</button>
                                        <input class="btn_ss bg-blue" type="button" data-ng-click="onPrintInvoiceDetailsClick();" ng-show="InvoiceID>0" value="Print" />
                                        <input class="btn_ss bg-blue" type="button" data-ng-click="onMeasureClick();" ng-show="InvoiceID>0" value="Add Measure" />
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <!--end of card-->
            </div>
        </div>
        <div class="row">
             <div class="alert" data-ng-class="AlertClass" data-ng-show="ShowError">
                <span data-ng-bind-html="InvoiceError" ></span>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#ItemTab">Item</a></li>
                                <li><a data-toggle="tab" href="#CreditCardTab">Credit Card</a></li>
                                <li><a data-toggle="tab" href="#TaxTab">Tax</a></li>
                                <li style="display:none"><a data-toggle="tab" href="#BarCodeTab">Bar Code</a></li>
                                <li style="display:none"><a data-toggle="tab" href="#PhotoTab">Photo</a></li>
                                <li style="display:none"><a data-toggle="tab" href="#FollowupBarCodeTab">Followup Bar Code</a></li>
                            </ul>
                            <div class="tab-content">
                                <div class="tab-pane active" id="ItemTab">
                                    <div class="row scrollable0panel" >
                                        <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>Item Code</th>
                                                    <th>Item Description</th>
                                                    <th>Quantity</th>
                                                    <th>Rate</th>
                                                    <th colspan="2">Disc(%) & Amt</th>
                                                    <th colspan="2">I/C GST(%) & Amt</th>
                                                    <th colspan="2">SGST(%) & Amt</th>
                                                    <th>Amount Pend</th>
                                                </tr>
                                            </thead>
                                            <tbody data-ng-repeat="Invoice in InvoiceList">
                                                <tr>
                                                    <td>
                                                        <input type="text"  placeholder="Type Item Code" style="width: 80px;" data-ng-model="Invoice.ItemCode" class="form-control"
                                                               typeahead-on-select="onItemSelect($item, $model, $label, $index);"
                                                               uib-typeahead="Item.ItemCode as Item.ItemCode for Item in ItemCodes |  filter:{ItemCode:$viewValue} | limitTo:50" 
                                                               data-ng-focus="GetItemCodes()" typeahead-show-hint="true" typeahead-min-length="0"  
                                                         />   
                                                    </td>
                                                    <td><input type="text" data-ng-model="Invoice.ItemDescription" class="form-control" style="width: 150px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemQuantity" class="form-control" style="width: 50px; text-align:right;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.ItemPrice" class="form-control" style="width: 80px; text-align:right;" data-ng-disabled="true" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemDiscountPer" class="form-control" style="width: 80px; text-align:right;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.ItemDiscount" class="form-control" data-ng-disabled="true" style="width: 80px; text-align:right;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.GSTP" class="form-control" style="width: 60px; text-align:right;"  data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.GST" class="form-control" style="width: 80px; text-align:right;" data-ng-disabled="true" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.SGSTP" class="form-control" style="width: 60px; text-align:right;"  data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.SGST" class="form-control" style="width: 80px; text-align:right;" data-ng-disabled="true" /></td>
                                                    <td><input type="text" data-ng-model="Invoice.AmountPending" class="form-control" style="width: 100px;  text-align:right;" data-ng-disabled="true" /></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                        <div>
                                            <button class="btn btn-sm btn-success" type="button" data-ng-click="AddItem();"><i class="fa fa-plus-circle"></i></button>
                                            <button class="btn btn-sm btn-success" type="button" data-ng-click="RemoveItem();"><i class="fa fa-minus-circle"></i></button>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <table style="width:100%" class="profile_table">
                                            <tbody>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Payment:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <select class="form-control" id="drpInvoicePaymentMethod" data-ng-model="CustInvoice.PaymentNumber" style="width:250px;"
                                                                   data-ng-options="custCat.PickListValue for custCat in InvoicePickLists.InvoicePaymentMethod track by custCat.PickListValue">
                                                                 <option value="">Select</option>
                                                            </select>
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span ng-if="false" class="profileLabel">Other Less & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" ng-if="false" >
                                                            <select class="form-control" id="drpInvoiceLess" data-ng-model="CustInvoice.InvoiceLessCategory" style="width: 150px;"
                                                                   data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.InvoiceLessCategory track by custCat.PickListValue">
                                                                 <option value="">None</option>
                                                            </select>
                                                            
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Less(%) & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >

                                                            <input type="number" data-ng-model="CustInvoice.LessRs" name="LessRs" class="form-control-Multiple" data-ng-change="onLessRsChange()" style="width: 80px; margin-left: 5px; text-align:right;"  />
                                                            <input type="text" data-ng-model="CustInvoice.LessRsAmount" name="LessRsAmount" data-ng-disabled="true" class="form-control-Multiple" style="width: 150px; margin-left: 5px; text-align:right;"  />
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Remarks:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="CustInvoice.Remarks" name="Remarks" class="form-control-Multiple" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right; min-width:60px;" class="back_shade"><span ng-show="CustInvoice.RoundOnOff" class="profileLabel">{{CustInvoice.RoundOnOff<0?'Round Off: ':'Round On: '}}</span></td>
                                                    <td style="text-align:right; min-width:30px;"><span ng-show="CustInvoice.RoundOnOff">{{CustInvoice.RoundOnOff>0?CustInvoice.RoundOnOff:CustInvoice.RoundOnOff*-1}}</span></td>
                                                    <%--<td style="text-align: right" class="back_shade"><span class="profileLabel">Tax:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select class="form-control" id="drpInvoiceTax" data-ng-model="CustInvoice.InvoiceLessCategory" 
                                                                   data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.InvoiceTaxCategory track by custCat.PickListValue">
                                                                 <option value="">None</option>
                                                            </select>
                                                        </span>
                                                    </td>--%>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Net Amount:</span></td>
                                                    <td style="text-align:right;">
                                                        <span class="profileValue" >
                                                            {{CustInvoice.NetAmount | currency : ''}}
                                                            <%--<input type="text" data-ng-model="CustInvoice.NetAmount" name="Debit" class="form-control" data-ng-disabled="true" style="width: 250px; margin-left: 5px;" maxlength="50" />--%>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="tab-pane" id="CreditCardTab">
                                    <table class="table">
                                            <thead>
                                                <tr>
                                                    <th>Number</th>
                                                    <th>Name</th>
                                                    <th>Phone</th>
                                                    <th>Bank</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td><input type="text" data-ng-model="CustInvoice.CrdNumber" class="form-control" style="width: 98%;" /></td>
                                                    <td><input type="text" data-ng-model="CustInvoice.CrdName" class="form-control" style="width: 98%;" /></td>
                                                    <td><input type="text" data-ng-model="CustInvoice.CrdPhone" class="form-control" style="width: 98%;" /></td>
                                                    <td><input type="text" data-ng-model="CustInvoice.CrdBank" class="form-control" style="width: 98%;" /></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                </div>
                                <div class="tab-pane" id="TaxTab">
                                </div>
                                <div class="tab-pane" id="BarCodeTab">
                                </div>
                                <div class="tab-pane" id="PhotoTab">
                                </div>
                                <div class="tab-pane" id="FollowupBarCodeTab">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>
