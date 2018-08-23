var TailerApp = angular.module("TailerApp", []);

TailerApp.controller("BranchController", function ($scope) {
    $scope.CompanyID = 0;
    $scope.BranchID = 0;
    $scope.B_Details = 0;
    $rootScope.PopupHeader = 'Add Branch';
});