﻿var Tailer = angular.module("TailerApp", ['720kb.datepicker']);

Tailer.directive('validCalendarDate', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModelCtrl) { 
            var  InputText = undefined;
            element.on('blur', function () {
                InputText = element[0].value;
                if (InputText != '' && InputText != undefined) {
                    if (!validateUSDate(InputText)) {
                        alert('Invalid Date');
                        InputText = "";
                        element[0].focus(); 
                    }
                    else {
                        InputText = trimString(InputText);
                    }
                }
                ngModelCtrl.$setViewValue(InputText);
                ngModelCtrl.$render(); 
            });  
            return InputText;
        }
    };
});

Tailer.controller("BranchController", function ($scope, $window, $http) {
    $scope.CompanyID = $window.CompanyID;
    $scope.BranchID = $window.BranchID;
    $scope.Str_BranchDetails = "";
    $scope.Str_AddressDetails = "";
    $scope.User = "";
    $scope.Password = "";
    $scope.BD = {
        BranchName: "",
        BranchLegalName: "",
        BranchCode: "",
        BranchSTNo: "",
        BranchITNo: "",
        BarnchCSTNo: "",
        BranchExciseNo: "",
        BranchContactPer: "",
        BranchCreatedDate: "",
        CreatedBy: "",
        ShortName: "",
        BranchNo: "",
        BranchType: "",
        BranchGSTIN: "",
        BranchTINNo: "",
        BranchSTDate: "",
        ExciseAddress: "",
        ExciseDivision: "",
        ExciseRange: "",
        ExciseState: "",
        PeriodFormDate: "",
        PeriodToDate: "",
        BranchDivision: ""
    }

    $scope.BAD = {
        Address1: "",
        Address2: "",
        City: "",
        State: "",
        Pincode: "",
        OfficePhoneNo: "",
        MobileNo: "",
        AlternateNo: "",
        HomePhoneNo: "",
        EmailID: "",
        Website: ""
    }

    $scope.GetBranchDetails = function () {

        $http(
           {
               method: "POST",
               url: "Branch_AddModify.aspx/GetBranchDetails",
               dataType: 'json',
               data: { CompanyID: $scope.CompanyID, BranchID: $scope.BranchID },
               headers: { "Content-Type": "application/json" }
           }).then(function successCallback(response) {

               if (response.data.d.errorCode == 10001) {
                   return false;
               }
               else if (response.data.d.errorCode == 0) {
                   $scope.BD = JSON.parse(response.data.d.BranchDetails)[0];
                   $scope.BAD = JSON.parse(response.data.d.AddressDetails)[0];
               }
               else {

                   var msg = response.data.d.errorMessage;
                   $window.alert(msg);

               }

           }, function errorCallback(response) {
               $window.alert(response.data.d.errorMessage);

           });

        return false;
    }

    if ($scope.CompanyID != 0 && $scope.CompanyID != undefined && $scope.CompanyID != ""
        && $scope.BranchID != 0 && $scope.BranchID != undefined && $scope.BranchID != ""
        ) {
        $scope.GetBranchDetails();
    }

    $scope.SaveBranchDetails = function () {

        if (!$scope.savevalidate())
            return false;

        $scope.Str_BranchDetails = JSON.stringify($scope.BD);
        $scope.Str_AddressDetails = JSON.stringify($scope.BAD);
        $http(
            {
                method: "POST",
                url: "Branch_AddModify.aspx/SaveBranchDetails",
                dataType: 'json',
                data: { CompanyID: $scope.CompanyID, BranchID: $scope.BranchID, BranchDetails: $scope.Str_BranchDetails, AddressDetails: $scope.Str_AddressDetails, user: $scope.User, password: $scope.Password },
                headers: { "Content-Type": "application/json" }
            }).then(function successCallback(response) {

                if (response.data.d.errorCode == 10001) {
                    //window.location = '../../SessionExpired.aspx';
                    return false;
                }
                else if (response.data.d.errorCode == 0) {
                    $window.alert("Save successfully");
                }
                else {

                    var msg = response.data.d.errorMessage;
                    $window.alert(msg);

                }

            }, function errorCallback(response) {
                $window.alert(response.data.d.errorMessage);

            });

        return false;
    }

    $scope.savevalidate = function () {
        var errormsg = "";

        if ($scope.BD.BranchName == "")
            errormsg += ' - Branch Name \n'

        if ($scope.BD.BranchCode == "")
            errormsg += ' - Branch Code \n'

        if ($scope.BAD.Address1 == "")
            errormsg += ' - Address \n'

        if ($scope.BranchID == 0) {
            if ($scope.User == "")
                errormsg += ' - User \n'
            if ($scope.Password == "")
                errormsg += ' - Password \n'
        }

        if (errormsg != "") {
            errormsg = "Please Enter following. \n" + errormsg;
            $window.alert(errormsg);
            return false;
        }

        return true;
    }

    $scope.ClosePopup = function () {
        window.close();
    }

    $scope.FocusScheduleFromDate = function (id) {
        angular.element('#' + id).focus();
    }


});


