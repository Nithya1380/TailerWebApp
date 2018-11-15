<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PrintMeasurement.aspx.cs" Inherits="TailerApp.UI.Tailer.PrintMeasurement" %>

<!DOCTYPE html>
<html>
<head>
    <title>Print Measurement</title>
    
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.22/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>
    <script src="../../Scripts/jquery-1.10.2.js"></script>
    <script src="../../Scripts/jquery-1.10.2.ui.js"></script>
    <script src="../../Scripts/bootstrap.min.js"></script>
    <link href="../Style/bootstrap.min.css" rel="stylesheet" />

    <style type="text/css">
        .lableMes {
            text-align: right;
            width: 100%;
            font-weight: bold;
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

        var test = angular.module("Test", []);

        test.controller('testcontroller', ['$scope', '$window', '$http', '$rootScope', '$filter', function ($scope, $window, $http, $rootScope, $filter) {
            debugger
            $scope.PayerDropDownSetting = {
                AllIDsReq: true,
                IsDisabled: false
            };

            $scope.PerList
                = [{ name: 'Menu1', id: [{ val: '5.00' }, { val: 6 }, { val: 7 }], isRep: true, orderby: 1 },
                     { name: 'Menu2', id: [{ val: 5 }, { val: 6.00 }, { val: 7 }], isRep: true, orderby: 2 },
                     { name: 'Menu3', id: [{ val: 5 }, { val: 6.86 }, { val: '7.00' }], isRep: true, orderby: 3 },
                     { name: 'Menu4', id: [{ val: 5.25 }, { val: 6 }, { val: 7 }], isRep: true, orderby: 4 },
                     { name: 'Menu6', id: [{ val: 5 }, { val: 6 }, { val: 7 }], isRep: true, orderby: 5 },
                     { name: 'Menu7', id: [{ val: 5 }, { val: 6.56 }, { val: 7.52 }], isRep: true, orderby: 6 },
                     { name: 'Menu8', id: [{ val: 5.56 }, { val: 6 }, { val: 7 }], isRep: true, orderby: 7 },
                     { name: 'Menu9', id: [{ val: 0 }], isRep: false, orderby: 8 },
                ];

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
                        pdfMake.createPdf(docDefinition).download("test.pdf");
                    }
                });
            }

        }]);

    </script>
</head>
<body>
    <div ng-app="Test">
        <div ng-controller="testcontroller">
            <br>
            <div id="exportthis">
                <div class="row">
                    <div class="col-sm-12">
                        <h4 class="lableHed">Company Name</h4>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <h6 class="lableAdd">BTM, 2nd Stage, Bangalore, KA</h6>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <h6 class="lableAdd">Contect: 456285632</h6>
                    </div>
                </div>
                <div style="border: 1px black solid; margin: 5px;">
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Account Code:</label><label class="lblInfoval">9142923770</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Measu No:</label><label class="lblInfoval">123</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Created Date:</label><label class="lblInfoval">10/11/2018</label>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Account Name:</label><label class="lblInfoval">Mahesh Patidar</label>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Item:</label><label class="lblInfoval">Shirt</label>
                        </div>
                    </div>
                    <div class="row" align="center">
                        <div class="col-sm-11 divborder"></div>
                    </div>
                    <div class="row" style="padding: 0px 25px;">
                        <div class="col-sm-1" ng-repeat="Per in PerList">
                            <label class="lableMes">{{Per.name}}</label>
                            <div ng-repeat="id in Per.id" style="padding-left: 20px; padding-bottom: 5px;">
                                <label class="lableval">{{id.val}}</label>
                            </div>
                        </div>
                    </div>
                    <div class="row" style="margin-left: 5px;">
                        <div class="col-sm-4">
                            <label class="lblInfotit">Trial Date:</label><label class="lblInfoval">15/11/2018</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Deli Date:</label><label class="lblInfoval">18/11/2018</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Date:</label><label class="lblInfoval">10/11/2018</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Qty:</label><label class="lblInfoval">1</label>
                        </div>
                        <div class="col-sm-4">
                            <label class="lblInfotit">Weight:</label><label class="lblInfoval"></label>
                        </div>
                    </div>
                </div>
            </div>
            <input type="button" value="Downlod" ng-click="export()" />
        </div>
    </div>

</body>
</html>
