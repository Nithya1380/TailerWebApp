<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateInvoice.aspx.cs" Inherits="TailerApp.UI.Tailer.CreateInvoice" %>
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
                     $(this).val(ui.item.CustomerName);
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
                             CustomerMasterID: item.CustomerMasterID
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

         var tailerApp = angular.module("TailerApp", ['ui.bootstrap']);//'autoCompleteModule'
         tailerApp.controller("CreateInvoiceController", function ($scope, $window, $http, $rootScope, $filter, $sce) {
             $scope.InvoiceList = [];
             $scope.TotalAmount = 0.00;
             $scope.CustInvoice = {};
             $scope.InvoicePickLists = {};
             $scope.ItemCodes = [];
             $scope.customerID = 0;

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
                     GST: "",
                     SGST: "",
                     AmountPending: ""
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

             $scope.onItemChange = function (InvoiceItem) {
                 if (InvoiceItem != null && InvoiceItem != undefined && !isNaN(InvoiceItem.ItemQuantity) && !isNaN(InvoiceItem.ItemPrice)) {
                     InvoiceItem.AmountPending = parseInt(InvoiceItem.ItemQuantity) * parseFloat(InvoiceItem.ItemPrice);

                     if (parseFloat(InvoiceItem.AmountPending) > 0) {
                         if (!isNaN(InvoiceItem.ItemDiscount) && parseFloat(InvoiceItem.ItemDiscount) > 0)
                             InvoiceItem.AmountPending = InvoiceItem.AmountPending - (parseFloat(InvoiceItem.AmountPending) * (parseFloat(InvoiceItem.ItemDiscount) / 100.00));

                         InvoiceItem.GST = parseFloat(InvoiceItem.AmountPending) * (18.00 / 100.00);
                         InvoiceItem.AmountPending = InvoiceItem.AmountPending + InvoiceItem.GST;
                     }


                     $scope.CalculateTotal();
                 }
             }

             $scope.CalculateTotal = function () {
                 $scope.TotalAmount = 0.00;
                 if ($scope.InvoiceList != null && $scope.InvoiceList != undefined) {
                     angular.forEach($scope.InvoiceList, function (InvoiceItem) {
                         if (InvoiceItem != null && InvoiceItem != undefined && !isNaN(InvoiceItem.AmountPending)) {
                             $scope.TotalAmount += InvoiceItem.AmountPending;
                         }
                     });
                 }
                 $scope.CalculateNetAmount();
             }

             $scope.CalculateNetAmount = function () {
                 $scope.CustInvoice.NetAmount = $scope.TotalAmount;
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
                     ItemPrice: $item.ItemPrice,
                     ItemDiscount: "",
                     GST: "",
                     SGST: "",
                     AmountPending: ""
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

                         return false;
                     }

                 }, function onFailure(error) {
                     $scope.ShowError = true;
                     $scope.InvoiceError = response.data.d.ErrorCode;
                 });


             };

         });
     </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="CreateInvoiceController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
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
                                        <span class="profileValue">
                                            <select class="form-control" id="drpSeries" data-ng-model="CustInvoice.InvoiceSeries" style="width:80%"
                                                    data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.AccountSeries track by custCat.PickListValue">
                                                    <option value="">None</option>
                                            </select>
                                        </span>
                                        <button class="btn btn-sm btn-success" type="button" title="Normal" style="display:none">
                                              <i class="fa fa-dot-circle-o" aria-hidden="true"></i>
                                            </button>
                                    </td>
                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Mobile:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.MobileNumber" name="MobileNumber" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Bill#:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.BillNumber" name="BillNumber" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.InvoiceDate" name="InvoiceDate" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Customer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.CustomerName" name="Debit" id="txtCustomer" class="form-control-Multiple autopop-textbox-Search" 
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
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.TrailDate" name="TrailDate" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                            <input type="text" data-ng-model="CustInvoice.TrailTime" name="TrailTime" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
                                            <button class="btn btn-sm btn-success" type="button" title="Book">
                                                <i class="fa fa-book" aria-hidden="true"></i>
                                            </button>
                                        </span>
                                    </td>
                                    <td colspan="4" rowspan="2">
                                        <span style="text-align:right;font-weight:bold;font-size:20px;float:right" data-ng-bind="TotalAmount">
                                            
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
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="CustInvoice.DeliveryDate" name="DeliveryDate" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                            <input type="text" data-ng-model="CustInvoice.DeliveryTime" name="DeliveryTime" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
                                           <button class="btn btn-sm btn-success" type="button" title="Refresh">
                                                <i class="fa fa-refresh" aria-hidden="true"></i>
                                            </button>
                                        </span>
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
                                        <button class="btn btn-lg btn-success" type="button" data-ng-click="onCreateInvoiceClick();"><i class="fa fa-dollar"></i>Create</button>
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
                                                    <th>Disc(%) & Amt</th>
                                                    <th>I/C GST</th>
                                                    <th>SGST</th>
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
                                                    <td><input type="number" data-ng-model="Invoice.ItemQuantity" class="form-control" style="width: 50px;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemPrice" class="form-control" style="width: 80px;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemDiscount" class="form-control" style="width: 80px;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.GST" class="form-control" style="width: 80px;" data-ng-disabled="true" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.SGST" class="form-control" style="width: 50px;" data-ng-disabled="true" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.AmountPending" class="form-control" style="width: 100px;" data-ng-disabled="true" /></td>
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
                                                                   data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.InvoicePaymentMethod track by custCat.PickListValue">
                                                                 <option value="">Select</option>
                                                            </select>
                                                        </span>
                                                    </td>
                                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Other Less & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select class="form-control" id="drpInvoiceLess" data-ng-model="CustInvoice.InvoiceLessCategory" style="width: 150px;"
                                                                   data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.InvoiceLessCategory track by custCat.PickListValue">
                                                                 <option value="">None</option>
                                                            </select>
                                                            
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Less(%) & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >

                                                            <input type="number" data-ng-model="CustInvoice.LessRs" name="LessRs" class="form-control-Multiple" style="width: 80px; margin-left: 5px;"  />
                                                            <input type="number" data-ng-model="CustInvoice.LessRsAmount" name="LessRsAmount" class="form-control-Multiple" style="width: 150px; margin-left: 5px;"  />
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
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Tax:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select class="form-control" id="drpInvoiceTax" data-ng-model="CustInvoice.InvoiceLessCategory" 
                                                                   data-ng-options="custCat.PickListValue as custCat.PickListLabel for custCat in InvoicePickLists.InvoiceTaxCategory track by custCat.PickListValue">
                                                                 <option value="">None</option>
                                                            </select>
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Net Amount:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="CustInvoice.NetAmount" name="Debit" class="form-control" data-ng-disabled="true" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <div class="tab-pane" id="CreditCardTab">
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
