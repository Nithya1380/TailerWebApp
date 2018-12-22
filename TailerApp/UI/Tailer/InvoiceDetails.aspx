<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="InvoiceDetails.aspx.cs" Inherits="TailerApp.UI.Tailer.InvoiceDetails" %>

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

    <webopt:bundlereference runat="server" path="~/Content/css" />
    <link href="~/favicon.ico" rel="shortcut icon" type="image/x-icon" />
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css" integrity="sha384-hWVjflwFxL6sNzntih27bfxkr27PmbbK/iSvJ+a4+0owXq79v+lsFkW54bOGbiDQ" crossorigin="anonymous" />
    <script type="text/javascript">
        var g_InvoiceID = '<%=InvoiceID%>';
        var tailerApp = angular.module("TailerApp", []);
        

        tailerApp.controller("InvoiceDetailsController", function ($scope, $window, $http, $rootScope) {
            $scope.InvoiceDetails = {};
            $scope.InvoiceID = g_InvoiceID;

            $scope.init = function () {
                $scope.InvoiceDetails = {};
                $scope.GetInvoiceDetails();
                
            };

            $scope.GetInvoiceDetails = function () {
                $scope.InvoiceDetails = {};
                 $http({
                    method: "POST",
                    url: "InvoiceDetails.aspx/GetInvoiceDetails",
                    data: { invoiceID: parseInt($scope.InvoiceID) },
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

                    $scope.InvoiceDetails = JSON.parse(response.data.d.JSonstring);
                    $scope.InvoiceDetails.DetailsList = JSON.parse(response.data.d.JSonstring2);

                }, function onFailure(error) {

                });
            };



        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
     <div class="container bootstrap snippet" data-ng-app="TailerApp" id="divMainContent" data-ng-controller="InvoiceDetailsController" data-ng-init="init()">
       
        <div class="row">
             <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="card_header" style="border-bottom: 1px solid #00A5A8; padding-bottom: 8px; color: #00a5a8;">
                        Invoice Details
                    </div>
                    <div class="card_content">
                        <div class="row">
                            <table style="width: 100%" class="profile_table">
                                <tbody>
                                    <tr>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Series:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.InvoiceSeries"></span>
                                            </span>

                                        </td>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Mobile:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.MobileNumber"></span>
                                            </span>
                                        </td>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Bill#:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.BillNumber"></span>
                                            </span>
                                        </td>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Date:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.InvoiceDate"></span>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Customer:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.CustomerName"></span>
                                            </span>
                                        </td>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Trail Date:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.TrailDate"></span>
                                                <span data-ng-bind="InvoiceDetails.TrailTime"></span>
                                            </span>
                                        </td>
                                        <td colspan="4" rowspan="2">
                                            <span style="text-align: right; font-weight: bold; font-size: 20px; float: right" data-ng-bind="InvoiceDetails.NetAmount"></span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Sales Rep:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.SelsRepsName"></span>
                                            </span>

                                        </td>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Delivery Date:</span></td>
                                        <td>
                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.DeliveryDate"></span>
                                                <span data-ng-bind="InvoiceDetails.DeliveryTime"></span>
                                            </span>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Master:</span></td>
                                        <td>

                                            <span class="profileValue">
                                                <span data-ng-bind="InvoiceDetails.MasterName"></span>
                                            </span>
                                        </td>
                                        <td style="text-align: right" class="back_shade"><span class="profileLabel">Designer:</span></td>
                                        <td>
                                            <span data-ng-bind="InvoiceDetails.DesignerName"></span>
                                        </td>
                                        <td colspan="4" style="text-align: right"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
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
                                <li style="display:none"><a data-toggle="tab" href="#CreditCardTab">Credit Card</a></li>
                                <li style="display:none"><a data-toggle="tab" href="#TaxTab">Tax</a></li>
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
                                            <tbody data-ng-repeat="Invoice in InvoiceDetails.DetailsList">
                                                <tr>
                                                    <td><span data-ng-bind="Invoice.ItemCode"></span></td>
                                                    <td><span data-ng-bind="Invoice.ItemDescription"></span></td>
                                                    <td><span data-ng-bind="Invoice.ItemQuantity"></span></td>
                                                    <td><span data-ng-bind="Invoice.ItemPrice"></span></td>
                                                    <td><span data-ng-bind="Invoice.ItemDiscount"></span></td>
                                                    <td><span data-ng-bind="Invoice.GST"></span></td>
                                                    <td><span data-ng-bind="Invoice.SGST"></span></td>
                                                    <td><span data-ng-bind="Invoice.AmountPending"></span></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                    <div class="row">
                                        <table style="width:100%" class="profile_table">
                                            <tbody>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Payment:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                           <span data-ng-bind="InvoiceDetails.PaymentNumber"></span>
                                                        </span>
                                                    </td>
                                                     <td style="text-align: right" class="back_shade"><span class="profileLabel">Other Less & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <span data-ng-bind="InvoiceDetails.LessRs"></span>
                                                          </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Less(%) & Rs:</span></td>
                                                    <td >
                                                        <span class="profileValue" >
                                                            <span data-ng-bind="InvoiceDetails.LessRsAmount"></span>
                                                        </span>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Remarks:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <span data-ng-bind="InvoiceDetails.Remarks"></span>
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right;display:none" class="back_shade"><span class="profileLabel">Tax:</span></td>
                                                    <td  style="display:none">
                                                        <span class="profileValue" >
                                                            <span data-ng-bind="InvoiceDetails.NetAmount"></span>
                                                        </span>
                                                    </td>
                                                    <td style="text-align: right" class="back_shade"><span class="profileLabel">Net Amount:</span></td>
                                                    <td >
                                                        <span class="profileValue">
                                                            <span data-ng-bind="InvoiceDetails.NetAmount"></span>
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
    </form>
</body>
</html>
