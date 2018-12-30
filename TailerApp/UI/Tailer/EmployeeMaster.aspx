<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="EmployeeMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.EmployeeMaster" %>

<asp:Content ID="content_Head" runat="server" ContentPlaceHolderID="HeaderContent">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/angular-datepicker.js"></script>
    <link href="../../Scripts/CalendarControl.css" rel="stylesheet" />
    <link href="../../Scripts/angular-datepicker.css" rel="stylesheet" />
    <script type="text/javascript" lang="javascript">
        var EmployeeID = "<%=EmployeeID%>";

        var tailerApp = angular.module("TailerApp", ['720kb.datepicker']);

        tailerApp.directive('capitalize', function () {
            return {
                require: 'ngModel',
                link: function(scope, element, attrs, modelCtrl) {
                    var capitalize = function(inputValue) {
                        if (inputValue == undefined) inputValue = '';
                        var capitalized = inputValue.toUpperCase();
                        if (capitalized !== inputValue) {
                            // see where the cursor is before the update so that we can set it back
                            var selection = element[0].selectionStart;
                            modelCtrl.$setViewValue(capitalized);
                            modelCtrl.$render();
                            // set back the cursor after rendering
                            element[0].selectionStart = selection;
                            element[0].selectionEnd = selection;
                        }
                        return capitalized;
                    }
                    modelCtrl.$parsers.push(capitalize);
                    capitalize(scope[attrs.ngModel]); // capitalize initial value
                }
            };
        });

        tailerApp.controller("EmplController", function ($scope, $window, $http, $rootScope) {
            $scope.EmployeeID = $window.EmployeeID;
            $scope.EmployeeDetails = {};
            $scope.isDeleted = false;
            $scope.PositionList = {};
            $scope.selectedPosition = { PickListValue: '', PickListLabel: '' };
            $scope.EmployeeDetails = {
                FirstName: '',
                LastName: '',
                Address: { Address1: '', City: '', State: '', MobileNo: '' }
            }
            $scope.isMailValid = false;

            $scope.GetEmployeeMasterDetails = function () {
                $scope.EmployeeDetails = {};

                $http({
                    method: "POST",
                    url: "EmployeeMaster.aspx/GetEmployeeMasterDetails",
                    data: { EmployeeID: $scope.EmployeeID },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.errorCode == 1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.errorCode != 0) {
                        alert(response.data.d.errorMessage);
                        return false;
                    }

                    $scope.EmployeeDetails = JSON.parse(response.data.d.EmployeeDetails)[0];
                    $scope.EmployeeDetails.Address = $scope.EmployeeDetails.Address[0];

                    $scope.selectedPosition = { PickListValue: $scope.EmployeeDetails.Position, PickListLabel: $scope.EmployeeDetails.Position };

                }, function onFailure(error) {

                });
            };

            $scope.GetPositions = function () {
                $scope.PositionList = {};

                $http({
                    method: "POST",
                    url: "EmployeeMaster.aspx/GetPositions",
                    data: {},
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                    $scope.PositionList = JSON.parse(response.data.d.JSonstring);

                }, function onFailure(error) {

                });
            };

            if ($scope.EmployeeID != 0) {
                $scope.GetEmployeeMasterDetails();
            }

            $scope.GetPositions();

            $scope.ValidateSave = function () {
                $scope.errors = new Array();
                if ($scope.EmployeeDetails.FirstName == '' || $scope.EmployeeDetails.FirstName == null) {
                    $scope.errors.push('First Name');
                }
                if ($scope.EmployeeDetails.LastName == '' || $scope.EmployeeDetails.LastName == null) {
                    $scope.errors.push('Last Name');
                }
                if ($scope.EmployeeDetails.Address.Address1 == '' || $scope.EmployeeDetails.Address.Address1 == null) {
                    $scope.errors.push('Address Line 1');
                }
                if ($scope.EmployeeDetails.Address.Pincode == '' || $scope.EmployeeDetails.Address.Pincode == null) {
                    $scope.errors.push('Pincode');
                }
                if ($scope.EmployeeDetails.Address.City == '' || $scope.EmployeeDetails.Address.City == null) {
                    $scope.errors.push('City');
                }
                if ($scope.EmployeeDetails.Address.State == '' || $scope.EmployeeDetails.Address.State == null) {
                    $scope.errors.push('State');
                }
                if ($scope.EmployeeDetails.Address.MobileNo == '' || $scope.EmployeeDetails.Address.MobileNo == null) {
                    $scope.errors.push('Mobile No');
                }
                if (!$scope.isMailValid) {
                    $scope.errors.push('Invalid EmailID');
                }


                if ($scope.errors.length > 0)
                    return true;

                return false;
            }

            $scope.SaveEmployeeMasterDetails = function () {

                if ($scope.ValidateSave() && !$scope.isDeleted)
                    return false;

                $scope.EmployeeDetails.Position = $scope.selectedPosition.PickListValue;

                var EmployeeDetails = JSON.stringify($scope.EmployeeDetails);

                $http({
                    method: "POST",
                    url: "EmployeeMaster.aspx/SaveEmployeeMasterDetails",
                    data: { EmployeeID: $scope.EmployeeID, EmployeeDetails: EmployeeDetails, isDeleted: $scope.isDeleted },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.errorCode == 1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.errorCode != 0) {
                        alert(response.data.d.errorMessage);
                        return false;
                    }

                    $scope.EmployeeID = response.data.d.EmployeeID;
                    $scope.EmployeeDetails.Address.AddressID = response.data.d.AddressID;

                    if ($scope.isDeleted) {
                        $window.alert('Deleted Succesfully');
                        $scope.onClose();
                    } else {
                        $window.alert('Save Succesfully');
                    }


                }, function onFailure(error) {
                    debugger;
                });
            };

            $scope.DeleteEmployeeMasterDetails = function () {
                $scope.isDeleted = true;
                $scope.SaveEmployeeMasterDetails();
            }

            $scope.onClose = function () {
                $window.location.href = "EmployeeList.aspx";
                return false;
            }

            $scope.GetPincodeDetails = function (pin) {

                $http({
                    method: "POST",
                    url: "EmployeeMaster.aspx/GetPincodeDetails",
                    data: { pincode: pin },
                    dataType: "json",
                    headers: { "Content-Type": "application/json" }
                }).then(function onSuccess(response) {
                    if (response.data.d.ErrorCode == 1001) {
                        //Session Expired
                        return false;
                    }
                    if (response.data.d.ErrorCode != 0) {
                        alert(response.data.d.ErrorMessage);
                        return false;
                    }

                   
                    if (response.data.d.JSonstring != '' && response.data.d.JSonstring != undefined && response.data.d.JSonstring != null) {

                        $scope.EmployeeDetails.Address.City = JSON.parse(response.data.d.JSonstring)[0].districtname;
                        $scope.EmployeeDetails.Address.State = JSON.parse(response.data.d.JSonstring)[0].statename;
                    }

                }, function onFailure(error) {

                });
            };

            $scope.Pincodekeyup = function (val, obj) {

                var patt1 = /^\d+$/;
                if (!patt1.test(val)) {
                    if(val != undefined)
                        obj.EmployeeDetails.Address.Pincode = val.toString().substring(0, val.toString().length - 1);
                    else
                        obj.EmployeeDetails.Address.Pincode = null;
                } else if (val.length == 6) {
                    $scope.GetPincodeDetails(val);
                }
            }

            $scope.ValidateEmail = function (mail) {
                mail = mail || "";
                var patt1 = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
                if (!patt1.test(mail) && mail != "")
                    $scope.isMailValid = false;
                else
                    $scope.isMailValid = true;
            }

        });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" data-ng-controller="EmplController" data-ng-init="init()">
        <div class="row">
            <div class="page-header-new col-lg-12">
                Employee Profile
            </div>
        </div>
        <div class="row">
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-5 col-md-5 col-sm-5" style="border-right: 1px solid #dfe1e6;">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="profilePic_outer">
                                                <img src="http://ssl.gstatic.com/accounts/ui/avatar_2x.png" class="profilePic">
                                            </div>
                                        </td>
                                        <td style="vertical-align: top">
                                            <div class="clientName">{{EmployeeDetails.FirstName+' '+EmployeeDetails.LastName}}</div>
                                            <div ng-if="false">&nbsp;<input type="file" title="Upload Photo" class="text-center center-block file-upload" style="margin-left: 3px" /></div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-lg-3 col-md-3 col-sm-3">
                            <table style="width: 100%" class="profile_table1">
                                <tbody>
                                    <tr>
                                        <td><i class="fa fa-map-marker" style="font-size: 15px; color: #636E7B;"></i>&nbsp;<span class="profileValue1">{{EmployeeDetails.Address.Address1}}</span></td>
                                    </tr>
                                    <tr>
                                        <td><span class="profileValue1">{{EmployeeDetails.Address.Address2}}</span></td>
                                    </tr>
                                    <tr>
                                        <td><span class="profileValue1">{{EmployeeDetails.Address.City}},{{EmployeeDetails.Address.State}}-{{EmployeeDetails.Address.Pincode}}</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-4" style="border-left: 1px solid #dfe1e6;">
                            <table style="width: 100%" class="profile_table1">
                                <tbody>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Mobile No:</span></td>
                                        <td>&nbsp;<span class="profileValue1">{{EmployeeDetails.Address.MobileNo}}</span></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Work Phone:</span></td>
                                        <td>&nbsp;<span class="profileValue1">{{EmployeeDetails.Address.OfficePhoneNo}}</span></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Home Phone:</span></td>
                                        <td>&nbsp;<span class="profileValue1">{{EmployeeDetails.Address.HomePhoneNo}}</span></td>
                                    </tr>
                                    <tr>
                                        <td style="text-align: right"><span class="profileValue1">Email:</span></td>
                                        <td>&nbsp;<span class="profileValue1">{{EmployeeDetails.Address.EmailID}}</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <!--end of col-4-->
                    </div>
                </div>
                <!--end of card-->
            </div>

            <div class="row" ng-show="errors.length > 0" style="margin:-9px 0px -15px 30px;">
                <ul style="color:red;">
                    <li ng-repeat="err in errors">
                        {{err}}
                    </li>
                </ul>
            </div>
            <br />
            <div class="col-lg-12 col-md-12 col-sm-12">
                <div class="card">
                    <div class="row">
                        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="row">
                <div class="col-lg-3 col-md-2 col-sm-3 pull-right">
                    <button class="client_btn" type="button" ng-click="SaveEmployeeMasterDetails()" data-toggle="dropdown" style="border-color: #00A5A8 !important; background-color: #00B5B8">
                        <i class="fa fa-save"></i>Save
                    </button>
                    <button class="client_btn" type="button" ng-hide="EmployeeID == 0" ng-click="DeleteEmployeeMasterDetails();" data-toggle="dropdown" style="border-color: rgba(212, 63, 58, 1) !important; background-color: rgba(212, 63, 58, 1)">
                        <i class="fa fa-close"></i>Delete
                    </button>
                    <button class="client_btn" type="button" ng-click="onClose();" data-toggle="dropdown" style="border-color: #FFA87D !important; background-color: #FFA87D">
                        <i class="fa fa-close"></i>Cancel
                    </button>
                </div>
            </div>
            <div class="panel-collapse collapse in">
                <div class="panel-body">
                    <div class="form-group row">
                        <label for="txtFullName" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>First Name</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" placeholder="First Name" ng-model="EmployeeDetails.FirstName" capitalize>
                        </div>
                        <label for="txtFullName" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Last Name</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" placeholder="Last Name" ng-model="EmployeeDetails.LastName" capitalize>
                        </div>
                        <label class="col-sm-1 lbl-text-right"></label>
                        <div class="col-sm-1">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="drpSex" class="col-sm-2 lbl-text-right">DOB</label>
                        <div class="col-sm-2">
                            <%--<input type="text" class="form-control" ng-model="EmployeeDetails.BirthDate">--%>
                            <datepicker  date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					            <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="EmployeeDetails.BirthDate" 
						            style="width:110px;"/> 
				            </datepicker>
                        </div>
                        <label for="txtFullName" class="col-sm-2 lbl-text-right">Hire Date</label>
                        <div class="col-sm-2">
                            <%--<input type="text" class="form-control" ng-model="EmployeeDetails.HireDate">--%>
                            <datepicker  date-format="dd/MM/yyyy" style="width: 0px; margin-left: 0px; float: none;">
					            <input type="text" class="form-control" tabindex="2000" valid-calendar-date ng-model="EmployeeDetails.HireDate" 
						            style="width:110px;"/> 
				            </datepicker>
                        </div>
                        <label for="drpSex" class="col-sm-1 lbl-text-right">Gender</label>
                        <div class="col-sm-1">
                            <select class="form-control" ng-model="EmployeeDetails.Gender">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="txtAddress1" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Address1</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" placeholder="Address1" ng-model="EmployeeDetails.Address.Address1" capitalize />
                        </div>
                        <label for="txtAddress2" class="col-sm-2 lbl-text-right">Address2</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control"  placeholder="Address2" ng-model="EmployeeDetails.Address.Address2" capitalize />
                        </div>
                        <label class="col-sm-1 lbl-text-right"></label>
                        <div class="col-sm-1">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="drpState" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Pincode</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" maxlength="6" placeholder="Pin" ng-keyup="Pincodekeyup(EmployeeDetails.Address.Pincode, this)" ng-model="EmployeeDetails.Address.Pincode" />
                        </div>
                        <label for="drpCountry" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>City</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="City" ng-model="EmployeeDetails.Address.City" capitalize />
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>State</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="State" ng-model="EmployeeDetails.Address.State" capitalize />
                        </div>
                    </div>
                     <div class="form-group row">
                        <label for="drpCountry" class="col-sm-2 lbl-text-right">Email ID</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control" ng-blur="ValidateEmail(EmployeeDetails.Address.EmailID)"  placeholder="Mail" ng-model="EmployeeDetails.Address.EmailID" />
                        </div>
                        <label for="drpCountry" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Mobile No</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" maxlength="10" placeholder="Mobile" ng-model="EmployeeDetails.Address.MobileNo" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="txtFullName" class="col-sm-2 lbl-text-right">Position</label>
                        <div class="col-sm-2">
                            <select class="form-control"
                              ng-options="option.PickListLabel for option in PositionList track by option.PickListValue"
                              ng-model="selectedPosition">
                            </select>
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right">Work Phone</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" maxlength="10" placeholder="Work Phone" ng-model="EmployeeDetails.Address.OfficePhoneNo" />
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right">Home Phone</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" maxlength="10" placeholder="Home Phone" ng-model="EmployeeDetails.Address.HomePhoneNo" />
                        </div>
                    </div>
                </div>
            </div>
                            </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
