/// <reference path="angular.js" />

var tailerApp = angular.module("TailerApp", []);

tailerApp.controller("ModifyRoleController",['$scope', '$window', '$http', '$rootScope', '$filter', function ($scope, $window, $http, $rootScope, $filter) {
    $scope.RoleID = $window.RoleID;
    $scope.RoleName = "";
    $scope.RolePermission = {};
    $scope.PermissionAdded = "";
    $scope.PermissionRemoved = "";
    $scope.isDeleted = false;

    $scope.GetRolePermission = function () {
        $http({
            method: "POST",
            url: "AddModifyRole.aspx/GetRolePermission",
            data: { RoleID: $scope.RoleID },
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
            else {
                $scope.RolePermission = JSON.parse(response.data.d.RolePermissions);
                $scope.RoleName = response.data.d.RoleName;
            }

        }, function onFailure(error) {

        });
    };

    $scope.GetRolePermission();

    $scope.SaveRolePermission = function () {
        if (!ValidateRolePermission())
            return false;

        $scope.RolePermission.forEach(function (item, index) {
            if (item.isChecked != item.isOldChecked) {
                if (item.isChecked)
                    $scope.PermissionAdded += item.CompanyPermissionID + ",";
                else
                    $scope.PermissionRemoved += item.CompanyPermissionID + ",";
            }

        });

        $http({
            method: "POST",
            url: "AddModifyRole.aspx/SaveRolePermission",
            data: { RoleID: $scope.RoleID, RoleName: $scope.RoleName, PermissionAdded: $scope.PermissionAdded, PermissionRemoved: $scope.PermissionRemoved, isDeleted: $scope.isDeleted },
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
            else {
                if ($scope.isDeleted) {
                    $window.alert("Delete Succesfully");
                    window.close();
                } else {
                    $scope.RoleID = response.data.d.Outvalue;
                    $scope.GetRolePermission();
                    $window.alert("Save Succesfully");

                }
                
            }

        }, function onFailure(error) {

        });
    };

    $scope.onRoleDeleteClick = function () {
        $scope.isDeleted = true;
        $scope.SaveRolePermission();
    }

    function ValidateRolePermission() {
        if ($scope.RoleName == "") {
            $window.alert("Enter Role name");
            return false;
        }
        return true;
    }

    $scope.FilterItem = function (id, ism) {
        return $scope.RolePermission.filter(function (x) { return x.ParentPermissionIndexID == id && x.IsMenu == ism });
    };

    $scope.onParCheck = function (id, val) {

        $scope.RolePermission.filter(function (z) { return z.ParentPermissionIndexID == id }).forEach(function (item, index) {
            item.isChecked = val;

        });
    }

    $scope.onRolePermClose = function () {
        window.close();
    }

}]);