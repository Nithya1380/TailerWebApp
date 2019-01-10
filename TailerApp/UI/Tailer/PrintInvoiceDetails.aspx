<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintInvoiceDetails.aspx.cs" Inherits="TailerApp.UI.Tailer.PrintInvoiceDetails" %>


<!DOCTYPE html>
<html>
<head>
    <title>Print Measurement</title>

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
        }

        .divborder {
            border-bottom: 1px black solid;
            margin-bottom: 5px;
            margin-left: 35px;
        }

        .lableAdd {
            text-align: center;
            width: 100%;
        }

        .lblInfotit {
            font-weight: bold;
            text-align: right;
            padding-right: 5px;
        }

        .lblInfoval {
            text-align: left;
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
            <div id="divInvoiceDetails" style="padding:15px">
                <div class="row">
                    <div class="col-sm-12">
                        <h5 class="lableHed">TAX INVOICE</h5>
                    </div>
                </div>
                <div class="row" style="padding-left: 25px;">
                    <div class="col-sm-4">
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
                <div class="col-sm-12 border">
                    <div class="row" >
                        <div class="col-sm-8">
                            <label class="lblInfotit">Customer:</label><label class="lblInfoval">{{InvoiceDetails.CustomerName}}</label>
                        </div>

                        <div class="col-sm-4 border">
                            <label class="lblInfotit">Date:</label><label class="lblInfoval">{{InvoiceDetails.InvoiceDate}}</label>
                        </div>
                    </div>
                    <div class="row" >
                        <div class="col-sm-8">
                            <label class="lblInfotit">Mobile:</label><label class="lblInfoval">{{InvoiceDetails.MobileNumber}}</label>
                        </div>
                        <div class="col-sm-4 border">
                            <label class="lblInfotit">Series:</label><label class="lblInfoval">{{InvoiceDetails.InvoiceSeries}}</label>
                        </div>
                    </div>
                        
                    <div class="row" >
                        
                        <div class="col-sm-12" style="padding:0px;">
                        <table class="table table-bordered" style="margin:0px">
                            <thead>
                                <tr>
                                    <th>Sr.</th>
                                    <th>Item Description</th>
                                    <th>Quantity</th>
                                    <th>Rate</th>
                                    <th colspan="2">Disc(%) & Amt</th>
                                    <th colspan="2">I/C GST & Amt</th>
                                    <th colspan="2">SGST & Amt</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody data-ng-repeat="Invoice in InvoiceDetails.DetailsList">
                                <tr>
                                    <td><span data-ng-bind="$index+1"></span></td>
                                    <td><span data-ng-bind="Invoice.ItemDescription"></span></td>
                                    <td ng-init="$parent.totalItemQuantity = $parent.totalItemQuantity + Invoice.ItemQuantity" ><span data-ng-bind="Invoice.ItemQuantity"></span></td>
                                    <td ng-init="$parent.totalItemPrice = $parent.totalItemPrice + Invoice.ItemPrice"><span data-ng-bind="Invoice.ItemPrice"></span></td>
                                    <td><span></span></td>
                                    <td ng-init="$parent.totalItemDiscount = $parent.totalItemDiscount + Invoice.ItemDiscount"><span data-ng-bind="Invoice.ItemDiscount"></span></td>
                                    <td><span></span></td>
                                    <td ng-init="$parent.totalGST = $parent.totalGST + Invoice.GST"><span data-ng-bind="Invoice.GST"></span></td>
                                    <td><span></span></td>
                                    <td ng-init="$parent.totalSGST = $parent.totalSGST + Invoice.SGST"><span data-ng-bind="Invoice.SGST"></span></td>
                                    <td ng-init="$parent.totalAmountPending = $parent.totalAmountPending + Invoice.AmountPending"><span data-ng-bind="Invoice.AmountPending"></span></td>
                                </tr>
                            </tbody>
                            <tfoot>
                                <tr>
                                    <th><span></span></th>
                                    <th><span> Total: </span></th>
                                    <th><span data-ng-bind="totalItemQuantity"></span></th>
                                    <th><span data-ng-bind="totalItemPrice"></span></th>
                                    <th><span></span></th>
                                    <th><span data-ng-bind="totalItemDiscount"></span></th>
                                    <th><span></span></th>
                                    <th><span data-ng-bind="totalGST"></span></th>
                                    <th><span></span></th>
                                    <th><span data-ng-bind="totalSGST"></span></th>
                                    <th><span data-ng-bind="totalAmountPending"></span></th>
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
                                    <label class="lblInfotit">CGST: </label>
                                    <label class="lblInfoval">{{totalGST}}</label>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="col-sm-7">
                                    <label class="lblInfotit">Del: </label>
                                    <label class="lblInfoval">{{InvoiceDetails.DeliveryDate}}</label>
                                </div>
                                <div class="col-sm-5">
                                    <label class="lblInfotit">SGST: </label>
                                    <label class="lblInfoval">{{totalSGST}}</label>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="col-sm-7">
                                   
                                </div>
                                <div class="col-sm-5">
                                    <label class="lblInfotit">TOTAL GST: </label>
                                    <label class="lblInfoval">{{totalGST+totalSGST}}</label>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-3 border">
                            <div class="row" >
                                <div class="col-sm-12">
                                    <label class="lblInfotit">TOTAL: </label>
                                    <label class="lblInfoval">{{totalAmountPending}}</label>
                                </div>
                            </div>
                            <div class="row" >
                                <div class="col-sm-12">
                                    <label class="lblInfotit">Debit: </label>
                                    <label class="lblInfoval">{{totalAmountPending}}</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
            </div>
            <input type="button" value="Downlod" ng-click="export()" />
        </div>
    </div>

</body>
</html>
