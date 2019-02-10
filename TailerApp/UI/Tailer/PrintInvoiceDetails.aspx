<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintInvoiceDetails.aspx.cs" Inherits="TailerApp.UI.Tailer.PrintInvoiceDetails" %>


<!DOCTYPE html>
<html>
<head>
    <title>Print Invoice</title>

    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/AngularJS/pdfmake.min.js"></script>
    <script src="../../Scripts/AngularJS/html2canvas.min.js"></script>
    <script src="../../Scripts/jquery-1.10.2.js"></script>
    <script src="../../Scripts/jquery-1.10.2.ui.js"></script>
    <script src="../../Scripts/bootstrap.min.js"></script>
    <link href="../Style/bootstrap.min.css" rel="stylesheet" />

    <style type="text/css">
        .lableMes {
            text-align: right;
            width: 100%;
            font-weight: bold;
            margin: 0px;
        }

        .lableval {
            text-align: right;
            width: 100%;
        }

        .lableHed {
            width: 100%;
            font-weight: normal;
            text-align: center;
            line-height:0.98;
        }

        .divborder {
            border-bottom: 1px black solid;
            margin-bottom: 5px;
            margin-left: 35px;
        }

        .lableAdd {
            text-align: center;
            width: 100%;
            line-height:0.7;
        }

        .lblInfotit {
            font-weight: bold;
            text-align: right;
            padding-right: 5px;
        }

        .lblInfoval {
            text-align: left;
        }
        .border{
            border: 1px solid #2a2a2b!important
        }
        .table-bordered{
            border: 1px solid #2a2a2b
        }
        .table-bordered td, .table-bordered th{
            border:1px solid #2a2a2b!important
        }
        .border-left{
            border-left:1px solid #2a2a2b!important
        } .border-right{
            border-right:1px solid #2a2a2b!important
        }.border-top{
            border-top:1px solid #2a2a2b!important
        }
         .border-bottom{
            border-bottom:1px solid #2a2a2b!important
        }
    </style>

    <script type="text/javascript" language="javascript">

        var InvoiceID = "<%=InvoiceID%>";

        var tailerApp = angular.module("TailerApp", []);

        tailerApp.controller('PrintInvoiceDetailsController', ['$scope', '$window', '$http', '$rootScope', '$filter', function ($scope, $window, $http, $rootScope, $filter) {
            $scope.InvoiceID = $window.InvoiceID;
            $scope.InvoiceDetails = {};
            $scope.CompanyInfo = {};

            $scope.totalItemQuantity = 0;
            $scope.totalItemPrice = 0;
            $scope.totalItemDiscount = 0;
            $scope.totalGST = 0;
            $scope.totalSGST = 0;
            $scope.totalAmountPending = 0;

            $scope.GetInvoiceDetails = function () {
                $scope.InvoiceDetails = {};

                $http({
                    method: "POST",
                    url: "PrintInvoiceDetails.aspx/GetInvoiceDetails",
                    data: { invoiceID: parseInt($scope.InvoiceID) },
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

                    $scope.InvoiceDetails = JSON.parse(response.data.d.JSonstring);
                    $scope.InvoiceDetails.DetailsList = JSON.parse(response.data.d.JSonstring2);
                    var ItemCount = $scope.InvoiceDetails.DetailsList.length;
                    var ArrayCount = parseInt(ItemCount / 9) + (ItemCount % 9 > 0 ? 1 : 0);

                    $scope.InvoiceRepeat = new Array(ArrayCount);

                }, function onFailure(error) {

                });
            };


            $scope.GetCompanyInfo = function () {
                $scope.CompanyInfo = {};

                $http({
                    method: "POST",
                    url: "PrintInvoiceDetails.aspx/GetCompanyInfo",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        //$window.SessionOut();
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    if (response.data.d.JSonstring != null && response.data.d.JSonstring != "") {
                        $scope.CompanyInfo = JSON.parse(response.data.d.JSonstring)[0];
                    }


                }, function onFailure(error) {

                });
            };

            $scope.GetCompanyInfo();
            $scope.GetInvoiceDetails();


            $scope.export = function () {
                debugger
                html2canvas(document.getElementById('divInvoiceDetails'), {
                    onrendered: function (canvas) {
                        var data = canvas.toDataURL();
                        var docDefinition = {
                            content: [{
                                image: data,
                                width: 500,
                            }]
                        };
                        pdfMake.createPdf(docDefinition).download('InvoiceDetails_' + $scope.InvoiceID + ".pdf");
                    }
                });
            }
            
			$scope.NumberToWord = function(number){
				var numberwors = "";
				if(number && angular.isNumber(number)){
					
					if(isInteger(number)){
						numberwors = toWords(number)+' Rupees Only';
					}
					else{
						
						var num = number.toFixed(2).split('.');
						
						numberwors = toWords(num[0])+' Rupees '+toWords(num[1])+ 'Paise Only';
					}
				}
				
				return numberwors;
			}
			
						
			var th = ['','Thousand','Million', 'Billion','Trillion'];
			var dg = ['Zero','One','Two','Three','Four', 'Five','Six','Seven','Eight','Nine']; 
			var tn = ['Ten','Eleven','Twelve','Thirteen', 'Fourteen','Fifteen','Sixteen', 'Seventeen','Eighteen','Nineteen'];
			var tw = ['Twenty','Thirty','Forty','Fifty', 'Sixty','Seventy','Eighty','Ninety']; 


			function isInteger(x) {
				return x % 1 === 0;
			}
			
			function toWords(s)
			{  
				s = s.toString(); 
				s = s.replace(/[\, ]/g,''); 
				if (s != parseFloat(s)) return 'not a number'; 
				var x = s.indexOf('.'); 
				if (x == -1) x = s.length; 
				if (x > 15) return 'too big'; 
				var n = s.split(''); 
				var str = ''; 
				var sk = 0; 
				for (var i=0; i < x; i++) 
				{
					if ((x-i)%3==2) 
					{
						if (n[i] == '1') 
						{
							str += tn[Number(n[i+1])] + ' '; 
							i++; 
							sk=1;
						}
						else if (n[i]!=0) 
						{
							str += tw[n[i]-2] + ' ';
							sk=1;
						}
					}
					else if (n[i]!=0) 
					{
						str += dg[n[i]] +' '; 
						if ((x-i)%3==0) str += 'hundred ';
						sk=1;
					}


					if ((x-i)%3==1)
					{
						if (sk) str += th[(x-i-1)/3] + ' ';
						sk=0;
					}
				}
				if (x != s.length)
				{
					var y = s.length; 
					str += 'point '; 
					for (var i=x+1; i<y; i++) str += dg[n[i]] +' ';
				}
				return str.replace(/\s+/g,' ');
			}


        }]);

        //<label class="lableval ng-binding"><span>1</span><span style="font-size: 12px; vertical-align: top;">1/4</span></label>

    </script>
</head>
<body>
    <div ng-app="TailerApp">
        <div ng-controller="PrintInvoiceDetailsController">
            <br>
            <div id="divInvoiceDetails" style="padding:15px" ng-repeat="Inv in InvoiceRepeat track by $index">
                <div class="row" ng-init="Inv.start=$index*9">
                    <div class="col-sm-12">
                        <h5 class="lableHed">TAX INVOICE</h5>
                    </div>
                </div>
                <div class="row" style="padding-left: 25px;">
                    <div class="col-sm-4" style="line-height: 1.2;">
                        <div class="row">
                            <div class="col-sm-12">
                                <span class="lableHed">GSTNIN : </span><span> {{CompanyInfo.BranchGSTIN}} </span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <span class="lableHed">CIN : </span><span> {{CompanyInfo.CIN}} </span>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <span class="lableHed">HSN CD : </span><span> {{CompanyInfo.HSNCD}} </span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="row">
                            <div class="col-sm-12">
                                <h5 class="lableHed">{{CompanyInfo.CompanyName}}<span> ({{CompanyInfo.BranchName}}) </span></h5>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <h6 class="lableAdd">{{CompanyInfo.Address1}}, {{CompanyInfo.Address2}},</h6>
                                <h6 class="lableAdd" ng-show="CompanyInfo.City || CompanyInfo.State || CompanyInfo.Pincode">{{CompanyInfo.City}}, {{CompanyInfo.State}}-{{CompanyInfo.Pincode}}</h6>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12">
                                <h6 class="lableAdd" ng-show="CompanyInfo.OfficePhoneNo || CompanyInfo.HomePhoneNo">Ph: {{CompanyInfo.OfficePhoneNo}},{{CompanyInfo.HomePhoneNo}}</h6>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4"></div>
                </div>
                <div class="col-sm-12" style="line-height:1;">
                    <div class="row" >
                        <div class="col-sm-8 border-left border-top">
                            <label class="lblInfoval">{{InvoiceDetails.CustomerName}}</label>
                        </div>

                        <div class="col-sm-4 border">
                            <label class="lblInfotit">Date:</label><label class="lblInfoval">{{InvoiceDetails.InvoiceDate}}</label>
                        </div>
                    </div>
                    <div class="row" >
                        <div class="col-sm-8 border-left border-top">
                            <label class="lblInfoval">{{InvoiceDetails.MobileNumber}}</label>
                        </div>
                        <div class="col-sm-4 border-right border-left">
                            <label class="lblInfotit">Series:</label><label class="lblInfoval">{{InvoiceDetails.InvoiceSeries}}</label>
                        </div>
                    </div>
                        
                    <div class="row" >
                        
                        <div class="col-sm-12" style="padding:0px;">
                        <table class="table table-bordered" style="margin:0px;line-height:0.4">
                            <thead>
                                <tr >
                                    <th style="width:2%;">Sr.</th>
                                    <th style="width:20%;">Item Description</th>
                                    <th style="width:2%; text-align:right;">Qty</th>
                                    <th style="width:5%; text-align:right;">Rate</th>
                                    <th style="width:10%; text-align:right;" ng-show="totalItemDiscount>0" colspan="2">Disc% & Amt</th>
                                    <th style="width:10%; text-align:right;" colspan="2">C% & Amt</th>
                                    <th style="width:10%; text-align:right;" colspan="2">S% & Amt</th>
                                    <th style="width:10%; text-align:right;">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr  data-ng-repeat="Invoice in InvoiceDetails.DetailsList | limitTo: 9 : Inv.start">
                                    <td style="text-align:right;"><span data-ng-bind="$index+1"></span></td>
                                    <td><span data-ng-bind="Invoice.ItemDescription"></span></td>
                                    <td style="text-align:right;" ng-init="$parent.totalItemQuantity = $parent.totalItemQuantity + Invoice.ItemQuantity" ><span data-ng-bind="Invoice.ItemQuantity"></span></td>
                                    <td style="text-align:right;" ng-init="$parent.totalItemPrice = $parent.totalItemPrice + Invoice.ItemPrice">{{Invoice.ItemPrice | currency : ''}}</td>
                                    <td style="text-align:right;" ng-show="$parent.totalItemDiscount>0" >{{Invoice.ItemDiscountPer}}</td>
                                    <td style="text-align:right;" ng-show="$parent.totalItemDiscount>0" ng-init="$parent.totalItemDiscount = $parent.totalItemDiscount + Invoice.ItemDiscount">{{Invoice.ItemDiscount | currency : ''}}</td>
                                    <td style="text-align:right;">{{Invoice.GSTPer}}</td>
                                    <td style="text-align:right;" ng-init="$parent.totalGST = $parent.totalGST + Invoice.GST">{{Invoice.GST | currency : ''}}</td>
                                    <td style="text-align:right;">{{Invoice.SGSTPer}}</td>
                                    <td style="text-align:right;" ng-init="$parent.totalSGST = $parent.totalSGST + Invoice.SGST">{{Invoice.SGST | currency : ''}}</td>
                                    <td style="text-align:right;" ng-init="$parent.totalAmountPending = $parent.totalAmountPending + Invoice.AmountPending">{{Invoice.AmountPending | currency : ''}}</td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th><span></span></th>
                                    <th style="text-align:right;"><span> Total: <br /><br /><br /><br /><br /> </span></th>
                                    <th style="text-align:right;">{{totalItemQuantity}}</th>
                                    <th style="text-align:right;">{{totalItemPrice | currency : ''}}</th>
                                    <th ng-show="$parent.totalItemDiscount>0"><span></span></th>
                                    <th style="text-align:right;" ng-show="$parent.totalItemDiscount>0">{{totalItemDiscount | currency : ''}}</th>
                                    <th><span></span></th>
                                    <th style="text-align:right;">{{totalGST | currency : '' }}</th>
                                    <th><span></span></th>
                                    <th style="text-align:right;" >{{totalSGST | currency : ''}}</th>
                                    <th style="text-align:right;">{{totalAmountPending | currency : ''}}</th>
                                </tr>
                            </tfoot>
                        </table>
                      </div>
                    </div>
                    <div class="row border" >
                        <div class="col-sm-9">
                            <div class="row" >
                                <div class="col-sm-12 border-bottom">
                                    <label class="lblInfotit">Invoice Value in words: </label>
                                    <label class="lblInfoval" data-ng-bind="NumberToWord(totalAmountPending)"></label>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="col-sm-7">
                                    <label class="lblInfotit">Trial: </label>
                                    <label class="lblInfoval">{{InvoiceDetails.TrailTime}}</label>
                                </div>
                                <div class="col-sm-5">
                                    <label class="lblInfotit col-sm-5">CGST {{InvoiceDetails.DetailsList[0].GSTPer}}% </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right;">{{totalGST  | currency : ''}}</label>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="col-sm-7">
                                    <label class="lblInfotit">Del: </label>
                                    <label class="lblInfoval">{{InvoiceDetails.DeliveryDate}}</label>
                                </div>
                                <div class="col-sm-5">
                                    <label class="lblInfotit col-sm-5">SGST {{InvoiceDetails.DetailsList[0].SGSTPer}}% </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right;">{{totalSGST  | currency : ''}}</label>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="col-sm-7">
                                   
                                </div>
                                <div class="col-sm-5" >
                                    <label class="lblInfotit col-sm-5" style="border-top:1px dashed">TOTAL GST: </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right; border-top:1px dashed">{{totalGST+totalSGST  | currency : ''}}</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3 border-left" style="padding-right:0px;">
                            <div class="row" style="padding-right:0px;" >
                                <div class="col-sm-12" style="padding-right:0px;">
                                    <label class="lblInfotit col-sm-6">TOTAL: </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right;padding-right:2px;">{{InvoiceDetails.TotalAmount  | currency : ''}}</label>
                                </div>
                            </div>
                            <div class="row" style="padding-right:0px;">
                                <div class="col-sm-12" style="padding-right:0px;">
                                    <label class="lblInfotit col-sm-6">Debit: </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right; padding-right:0px;">{{InvoiceDetails.TotalAmount  | currency : ''}}</label>
                                </div>
                            </div>
                            <div class="row" style="padding-right:0px;" ng-show="InvoiceDetails.RoundOnOff">
                                <div class="col-sm-12" style="padding-right:0px;"> 
                                    <label class="lblInfotit col-sm-6">{{InvoiceDetails.RoundOnOff<0?'Round Off':'Round On'}}: </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right; padding-right:0px;">{{InvoiceDetails.RoundOnOff>0?InvoiceDetails.RoundOnOff:InvoiceDetails.RoundOnOff*-1  | currency : ''}}</label>
                                </div>
                            </div>
                            <div class="row" style="padding-right:0px;">
                                <div class="col-sm-12" style="padding-right:0px;">
                                    <label class="lblInfotit col-sm-6">Net Amount: </label>
                                    <label class="lblInfoval col-sm-5" style="text-align:right; padding-right:0px;">{{InvoiceDetails.NetAmount  | currency : ''}}</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
            <input type="button" style="display:none;" value="Downlod" ng-click="export()" />
        </div>
    </div>

</body>
</html>
