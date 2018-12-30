<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintMeasurement.aspx.cs" Inherits="TailerApp.UI.Tailer.PrintMeasurement" %>

<!DOCTYPE html>
<html>
<head>
    <title>Print Measurement</title>
    
    <script src="../../Scripts/AngularJS/angular.js"></script>
<%--    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.22/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>--%>
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
            font-weight: bold;
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

        var MeasurementID = "<%=MeasurementID%>";

        var tailerApp = angular.module("TailerApp", []);

        tailerApp.controller('PrintMeasurementController', ['$scope', '$window', '$http', '$rootScope', '$filter', function ($scope, $window, $http, $rootScope, $filter) {
            $scope.MeasurementID = $window.MeasurementID;
            $scope.MeasurementDetails = {};
            $scope.MeasurementField = [];
            $scope.CompanyInfo = {};

            $scope.GetMeasurementMaster = function () {
                $scope.MeasurementDetails = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetMeasurementMaster",
                    data: { MeasurMasterID: $scope.MeasurementID, isPrint: true },
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
                    }

                    $scope.MeasurementField = $scope.MeasurementField.filter(function (x) { return x.ItemGroup == $scope.MeasurementDetails.SelectedItem.ItemGroup || x.ItemGroup == 'Mix' });

                    if (response.data.d.MeasurementList.length > 0) {

                        response.data.d.MeasurementList.forEach(function (item, index) {
                            $scope.MeasurementField.filter(function (x) { return x.id == item.MeasurementFieldID })[0].Lang = item.Lang;
                        });
                    }

                }, function onFailure(error) {

                });
            };


            $scope.GetCompanyInfo = function () {
                $scope.CompanyInfo = {};

                $http({
                    method: "POST",
                    url: "Measurement.aspx/GetCompanyInfo",
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
            $scope.GetMeasurementMaster();

            //$scope.PerList
            //    = [{ name: 'Menu1', id: [{ val: '5.00' }, { val: 6 }, { val: 7 }], isRep: true, orderby: 1 },
            //         { name: 'Menu2', id: [{ val: 5 }, { val: 6.00 }, { val: 7 }], isRep: true, orderby: 2 },
            //         { name: 'Menu3', id: [{ val: 5 }, { val: 6.86 }, { val: '7.00' }], isRep: true, orderby: 3 },
            //         { name: 'Menu4', id: [{ val: 5.25 }, { val: 6 }, { val: 7 }], isRep: true, orderby: 4 },
            //         { name: 'Menu6', id: [{ val: 5 }, { val: 6 }, { val: 7 }], isRep: true, orderby: 5 },
            //         { name: 'Menu7', id: [{ val: 5 }, { val: 6.56 }, { val: 7.52 }], isRep: true, orderby: 6 },
            //         { name: 'Menu8', id: [{ val: 5.56 }, { val: 6 }, { val: 7 }], isRep: true, orderby: 7 },
            //         { name: 'Menu9', id: [{ val: 0 }], isRep: false, orderby: 8 },
            //    ];

            $scope.export = function () {
                debugger
                html2canvas(document.getElementById('exportthis'), {
                    onrendered: function (canvas) {
                        var data = canvas.toDataURL();
                        var docDefinition = {
                            content: [{
                                image: data,
                                width: 500,
                            }]
                        };
                        pdfMake.createPdf(docDefinition).download($scope.MeasurementDetails.Account.AccountCode + ".pdf");
                    }
                });
            }


            function gcd(a, b) {
                return (b) ? gcd(b, a % b) : a;
            }
            $scope.decimalToFraction = function (_decimal) {
                var aa = _decimal.toString().indexOf(".") ? _decimal.toString().split(".")[0] : 0;
                _decimal = parseFloat(_decimal.toString().indexOf(".") ? _decimal.toString().replace(/\d+[.]/, '.') : 0);
                if (_decimal == parseInt(_decimal)) {
                    //return _decimal
                    
                    //{
                    //    top: parseInt(_decimal),
                    //    bottom: 1,
                    //    display: parseInt(_decimal) + '/' + 1
                    //};
                    return new Array(aa, '');
                }
                else {
                    var top = _decimal.toString().indexOf(".") ? _decimal.toString().replace(/\d+[.]/, '') : 0;
                    var bottom = Math.pow(10, top.toString().replace('-', '').length);
                    if (_decimal >= 1) {
                        top = +top + (Math.floor(_decimal) * bottom);
                    }
                    else if (_decimal <= -1) {
                        top = +top + (Math.ceil(_decimal) * bottom);
                    }

                    var x = Math.abs(gcd(top, bottom));
                    //return {
                    //    top: (top / x),
                    //    bottom: (bottom / x),
                    //    display: (top / x) + '/' + (bottom / x)
                    //};
                    return new Array(aa, (top / x) + '/' + (bottom / x));
                }
            };

        }]);

        //<label class="lableval ng-binding"><span>1</span><span style="font-size: 12px; vertical-align: top;">1/4</span></label>

    </script>
</head>
<body>
    <div ng-app="TailerApp">
        <div ng-controller="PrintMeasurementController">
            <br>
            <div id="exportthis">
                <div class="row">
                    <div class="col-sm-12">
                        <h4 class="lableHed">{{CompanyInfo.CompanyName}}<span> ({{CompanyInfo.BranchName}}) </span></h4>
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
                        <h6 class="lableAdd" ng-show="CompanyInfo.OfficePhoneNo || CompanyInfo.HomePhoneNo" >Ph: {{CompanyInfo.OfficePhoneNo}},{{CompanyInfo.HomePhoneNo}}</h6>
                    </div>
                </div>
                <div style="border: 1px black solid; margin: 5px;">
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-5">
                            <label class="lblInfotit">Account Code:</label><label class="lblInfoval">{{MeasurementDetails.Account.AccountCode}}</label>
                        </div>
                        <div class="col-sm-5">
                            <label class="lblInfotit">Measu No:</label><label class="lblInfoval">{{MeasurementDetails.MeasuNo}}</label>
                        </div>
                        <div class="col-sm-2">
                            <label class="lblInfotit">Qty:</label><label class="lblInfoval">{{MeasurementDetails.Qty}}</label>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Account Name:</label><label class="lblInfoval">{{MeasurementDetails.Account.AccountName}}</label>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Item:</label><label class="lblInfoval">{{MeasurementDetails.SelectedItem.ItemDescription}}</label>
                        </div>
                    </div>
                    <div class="row" align="center">
                        <div class="col-sm-11 divborder"></div>
                    </div>
                    <div class="row" style="padding: 0px 25px;">
                        <div class="col-sm-1" ng-repeat="Per in MeasurementField">
                            <label class="lableMes">{{Per.FieldName}}</label><label class="lableMes" ng-show="Per.Lang">({{Per.Lang}})</label>
                            <div ng-repeat="id in Per.FieldValue" style="padding-left: 20px; padding-bottom: 5px;">
                                <label class="lableval"><span>{{decimalToFraction(id.val)[0]}}</span><span style="font-size: 12px; vertical-align: top;">{{decimalToFraction(id.val)[1]}}</span></label>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Trial Date:</label><label class="lblInfoval">{{MeasurementDetails.TrialDate}}</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Deli Date:</label><label class="lblInfoval">{{MeasurementDetails.DeliDate}}</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Date:</label><label class="lblInfoval">{{MeasurementDetails.MeasDate}}</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Created Date:</label><label class="lblInfoval">{{MeasurementDetails.MeasCreatedOn}}</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Weight:</label><label class="lblInfoval">{{MeasurementDetails.MeasWeight}}</label>
                        </div>
                    </div>
                </div>
            </div>
            <input type="button" value="Downlod" ng-click="export()" />
        </div>
    </div>

</body>
</html>
