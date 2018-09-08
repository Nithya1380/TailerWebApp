var Tailer = angular.module("TailerApp", []);

Tailer.controller("CompanyController", function ($scope, $window, $http) {
    $scope.CompanyID = $window.CompanyID;
    $scope.Str_CompanyDetails = "";
    $scope.Str_AddressDetails = "";
    $scope.CD = {
        CompanyName:"",
        CompanyCode: "",
        CompLegalName: "",
        CompCreatedDate: "",
        CompBusType: "",
        TDSNo: "",
        TDSCircle: "",
        TDSChallanNo: "",
        PanNo: "",
        CSTNo: "",
        CSTDate: ""
    }

    $scope.AD = {
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

    $scope.GetCompanyDetails = function () {
        $http(
           {
               method: "POST",
               url: "Company_AddModify.aspx/GetCompanyDetails",
               dataType: 'json',
               data: { CompanyID: $scope.CompanyID },
               headers: { "Content-Type": "application/json" }
           }).then(function successCallback(response) {

               if (response.data.d.errorCode == 10001) {
                   //window.location = '../../SessionExpired.aspx';
                   return false;
               }
               else if (response.data.d.errorCode == 0) {
                   $scope.CD = JSON.parse(response.data.d.CompanyDetails)[0];
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

    if ($scope.CompanyID != 0 && $scope.CompanyID != undefined && $scope.CompanyID != "") {
        $scope.GetCompanyDetails();
    }

    $scope.SaveCompanyDetails = function () {
        $scope.Str_CompanyDetails = JSON.stringify($scope.CD);
        $scope.Str_AddressDetails = JSON.stringify($scope.AD);
        $http(
            {
                method: "POST",
                url: "Company_AddModify.aspx/SaveCompanyDetails",
                dataType: 'json',
                data: { CompanyID: $scope.CompanyID, CompanyDetails: $scope.Str_CompanyDetails, AddressDetails: $scope.Str_AddressDetails },
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

    $scope.ClosePopup = function () {
        window.close();
    }


});

