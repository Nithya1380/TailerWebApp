<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="EmployeeMaster.aspx.cs" Inherits="TailerApp.UI.Tailer.EmployeeMaster" %>

<asp:Content ID="content_Head" runat="server" ContentPlaceHolderID="HeaderContent">
    <script src="../../Scripts/AngularJS/angular.js"></script>

    <script type="text/javascript" lang="javascript">
        var EmployeeID = "<%=EmployeeID%>";

        var tailerApp = angular.module("TailerApp", []);
        tailerApp.controller("EmplController", function ($scope, $window, $http, $rootScope) {
            $scope.EmployeeID = $window.EmployeeID;
            $scope.EmployeeDetails = {};
            $scope.isDeleted = false;
            $scope.PositionList = {};
            $scope.selectedPosition = { PickListValue: '', PickListLabel: '' };

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
                if ($scope.EmployeeDetails.Address.City == '' || $scope.EmployeeDetails.Address.City == null) {
                    $scope.errors.push('City');
                }
                if ($scope.EmployeeDetails.Address.State == '' || $scope.EmployeeDetails.Address.State == null) {
                    $scope.errors.push('State');
                }
                if ($scope.EmployeeDetails.Address.MobileNo == '' || $scope.EmployeeDetails.Address.MobileNo == null) {
                    $scope.errors.push('Mobile No');
                }
            }

            $scope.SaveEmployeeMasterDetails = function () {
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
            }

            $scope.onClose = function () {
                $window.location.href = "EmployeeList.aspx";
                return false;
            }
        });
    </script>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" data-ng-app="TailerApp" data-ng-controller="EmplController" data-ng-init="init()">
        <div class="row">
            <div>&nbsp;</div>
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
                                            <div>&nbsp;<input type="file" title="Upload Photo" class="text-center center-block file-upload" style="margin-left: 3px" /></div>
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
                    <button class="client_btn" type="button" ng-hide="UserID == 0" ng-click="DeleteEmployeeMasterDetails();" data-toggle="dropdown" style="border-color: rgba(212, 63, 58, 1) !important; background-color: rgba(212, 63, 58, 1)">
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
                        <div class="col-sm-2">
                            <input type="text" class="form-control" placeholder="First Name" ng-model="EmployeeDetails.FirstName">
                        </div>
                        <label for="txtFullName" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Last Name</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" placeholder="Last Name" ng-model="EmployeeDetails.LastName">
                        </div>
                        <label for="drpSex" class="col-sm-2 lbl-text-right">Sex</label>
                        <div class="col-sm-2">
                            <select class="form-control" ng-model="EmployeeDetails.Gender">
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
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
                        <label for="txtFullName" class="col-sm-2 lbl-text-right">Hire Date</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" ng-model="EmployeeDetails.HireDate">
                        </div>
                        <label for="drpSex" class="col-sm-2 lbl-text-right">Birth Date</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" ng-model="EmployeeDetails.BirthDate">
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="txtAddress1" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Address Line 1</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control" placeholder="Address Line 1" ng-model="EmployeeDetails.Address.Address1" />
                        </div>
                        <label for="txtAddress2" class="col-sm-2 lbl-text-right">Address Line 2</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="Address Line 2" ng-model="EmployeeDetails.Address.Address2" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="drpCountry" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>City</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="City" ng-model="EmployeeDetails.Address.City" />
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>State</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="State" ng-model="EmployeeDetails.Address.State" />
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right">Pin</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="Pin" ng-model="EmployeeDetails.Address.Pincode" />
                        </div>
                    </div>
                     <div class="form-group row">
                        <label for="drpCountry" class="col-sm-2 lbl-text-right"><span style="color:red">*</span>Mobile No</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="Mobile" ng-model="EmployeeDetails.Address.MobileNo" />
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right">Work Phone</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="Work Phone" ng-model="EmployeeDetails.Address.OfficePhoneNo" />
                        </div>
                        <label for="drpState" class="col-sm-2 lbl-text-right">Home Phone</label>
                        <div class="col-sm-2">
                            <input type="text" class="form-control"  placeholder="Home Phone" ng-model="EmployeeDetails.Address.HomePhoneNo" />
                        </div>
                    </div>
                    <div class="form-group row">
                        <label for="drpCountry" class="col-sm-2 lbl-text-right">Mail ID</label>
                        <div class="col-sm-3">
                            <input type="text" class="form-control"  placeholder="Mail" ng-model="EmployeeDetails.Address.EmailID" />
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
