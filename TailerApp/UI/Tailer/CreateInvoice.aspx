<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CreateInvoice.aspx.cs" Inherits="TailerApp.UI.Tailer.CreateInvoice" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <%--<link href="../../Content/angular-auto-complete.css" rel="stylesheet" />
    <script src="../../Scripts/angular-auto-complete.js"></script>--%>
     <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

    <script src="../../Scripts/AngularJS/angular.js"></script>
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script src="../../Scripts/angular-datepicker.js"></script>
    
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
                 data: JSON.stringify({searchText:request.term}), 
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

         var tailerApp = angular.module("TailerApp", []);//'autoCompleteModule'
         tailerApp.controller("CreateInvoiceController", function ($scope, $window, $http, $rootScope) {
             $scope.InvoiceList = [];
             $scope.TotalAmount = 0.00;
             $scope.CustInvoice = {};

             $scope.AddItem = function () {
                 var invoice = {
                     ItemCode: "",
                     ItemDescription: "",
                     ItemQuantity: 1,
                     ItemPrice: "",
                     ItemDiscount: "",
                     GST: "",
                     SGST: "",
                     AmountPending:""
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

             $scope.onItemChange=function(InvoiceItem)
             {
                 if (InvoiceItem != null && InvoiceItem != undefined && !isNaN(InvoiceItem.ItemQuantity) && !isNaN(InvoiceItem.ItemPrice))
                 {
                     InvoiceItem.AmountPending = parseInt(InvoiceItem.ItemQuantity) * parseFloat(InvoiceItem.ItemPrice);
                     $scope.CalculateTotal();
                 }
             }

             $scope.CalculateTotal=function()
             {
                 $scope.TotalAmount = 0.00;
                 if($scope.InvoiceList!=null && $scope.InvoiceList!=undefined)
                 {
                     angular.forEach($scope.InvoiceList, function (InvoiceItem) {
                         if (InvoiceItem != null && InvoiceItem != undefined && !isNaN(InvoiceItem.AmountPending)) {
                             $scope.TotalAmount+=InvoiceItem.AmountPending;
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
                                            <select id="drplst_Series" class="form-control-Multiple" style="width: 150px;">
                                                <option>None</option>
                                            </select>
                                        </span>
                                        <button class="btn btn-sm btn-success" type="button" title="Normal">
                                              <i class="fa fa-dot-circle-o" aria-hidden="true"></i>
                                            </button>
                                    </td>
                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Mobile:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Bill#:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control" style="width: 95%; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Customer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.CustomerName" name="Debit" id="txtCustomer" class="form-control-Multiple autopop-textbox-Search" 
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
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
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
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 95%; margin-left: 5px;" maxlength="50" />
                                        </span>
                                        
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Delivery Date:</span></td>
                                    <td >
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" maxlength="10" />
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 60px; margin-left: 5px;" maxlength="10" />
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
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 95%; margin-left: 5px;" maxlength="50" />
                                        </span>
                                    </td>
                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Designer:</span></td>
                                    <td>
                                        <span class="profileValue">
                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 95%; margin-left: 5px;" maxlength="50" />
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
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
                            <ul class="nav nav-tabs">
                                <li class="active"><a data-toggle="tab" href="#ItemTab">Item</a></li>
                                <li><a data-toggle="tab" href="#CreditCardTab">Credit Card</a></li>
                                <li><a data-toggle="tab" href="#TaxTab">Tax</a></li>
                                <li><a data-toggle="tab" href="#BarCodeTab">Bar Code</a></li>
                                <li><a data-toggle="tab" href="#PhotoTab">Photo</a></li>
                                <li><a data-toggle="tab" href="#FollowupBarCodeTab">Followup Bar Code</a></li>
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
                                                    <td><input type="text" data-ng-model="Invoice.ItemCode" class="form-control ItemAutoComplete" style="width: 50px;" onblur="OnItemBlur(this);" onfocus="_OnTextBoxFocusItem(this)"  /> </td>
                                                    <td><input type="text" data-ng-model="Invoice.ItemDescription" class="form-control" style="width: 150px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemQuantity" class="form-control" style="width: 50px;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemPrice" class="form-control" style="width: 80px;" data-ng-change="onItemChange(Invoice)" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.ItemDiscount" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.GST" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.SGST" class="form-control" style="width: 50px;" /></td>
                                                    <td><input type="number" data-ng-model="Invoice.AmountPending" class="form-control" style="width: 100px;" /></td>
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
                                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Other Less & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select id="drplst_OtherLessRs" class="form-control-Multiple" style="width: 150px;">
                                                                <option>None</option>
                                                            </select>
                                                            <input type="number" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 100px; margin-left: 5px;" />
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Less(%) & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <input type="number" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 80px; margin-left: 5px;"  />
                                                            <input type="number" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 150px; margin-left: 5px;"  />
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Remarks:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="Customer.FirstName" name="Debit" class="form-control-Multiple" style="width: 250px; margin-left: 5px;" maxlength="50" />
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Tax:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <select id="drplst_Tax" class="form-control">
                                                                <option></option>
                                                            </select>
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Net Amount:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <input type="text" data-ng-model="CustInvoice.NetAmount" name="Debit" class="form-control" style="width: 250px; margin-left: 5px;" maxlength="50" />
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
