var Tailer = angular.module("TailerApp", []);

Tailer.controller("BranchController", function ($scope, $window, $http) {
    $scope.CompanyID = $window.CompanyID;
    $scope.BranchID = $window.BranchID;
    $scope.Str_BranchDetails = "";
    $scope.Str_AddressDetails = "";
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
                   window.location = '../../SessionExpired.aspx';
               }
               else if (response.data.d.errorCode == 0) {
                   $scope.CD = JSON.parse(response.data.d.BranchDetails)[0];
                   $scope.AD = JSON.parse(response.data.d.AddressDetails)[0];
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
        $scope.Str_BranchDetails = JSON.stringify($scope.BD);
        $scope.Str_AddressDetails = JSON.stringify($scope.BAD);
        $http(
            {
                method: "POST",
                url: "Branch_AddModify.aspx/SaveBranchDetails",
                dataType: 'json',
                data: { CompanyID: $scope.CompanyID, BranchID: $scope.BranchID, BranchDetails: $scope.Str_BranchDetails, AddressDetails: $scope.Str_AddressDetails },
                headers: { "Content-Type": "application/json" }
            }).then(function successCallback(response) {

                if (response.data.d.errorCode == 10001) {
                    window.location = '../../SessionExpired.aspx';
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

    $scope.ClosePopup = function () {
        window.close();
    }


});

