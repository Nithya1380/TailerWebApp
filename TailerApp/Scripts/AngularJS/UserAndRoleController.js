/// <reference path="angular.js" />

var tailerApp = angular.module("TailerApp", ['angular_MultiselectDropdown']);

tailerApp.controller("UserAndRoleController", function ($scope, $window, $http, $rootScope, $filter) {
    $scope.UserList = {};
    $scope.RoleList = {};
    $scope.UserID = 0;
    $scope.UserRolsID = {};
    $scope.UserName = "";
    $scope.UserMailID = "";
    $scope.Userpassword = "";
    $scope.UserCnfpassword = "";
    $scope.isPasswordRegenerated = false;
    $scope.isdeleted = false;
    $scope.passwordStatus = '';
    $scope.passwordStyle = '';
    $scope.EmployeeList = {};
    $scope.EmployeeMasterID = {};
    $scope.UserBranchList = {};
    $scope.BranchIDs = "";

    $scope.GetUsersList = function () {            
        $http({
            method: "POST",
            url: "UserAndRole.aspx/GetUsers",
            data:{},
            dataType: "json",
            headers: { "Content-Type": "application/json" }
        }).then(function onSuccess(response) {
            if (response.data.d.errorCode == 1001) {
                SessionOut();
                return false;
            }
            if (response.data.d.errorCode != 0) {
                alert(response.data.d.errorMessage);
                return false;
            }
            else {
                $scope.UserList = JSON.parse(response.data.d.Users);
            }

        }, function onFailure(error) {

        });
    };

    $scope.GetUsersList();

    $scope.GetRoleList = function () {
        $http({
            method: "POST",
            url: "UserAndRole.aspx/GetRoles",
            data: {},
            dataType: "json",
            headers: { "Content-Type": "application/json" }
        }).then(function onSuccess(response) {
            if (response.data.d.errorCode == 1001) {
                SessionOut();
                return false;
            }
            if (response.data.d.errorCode != 0) {
                alert(response.data.d.errorMessage);
                return false;
            }
            else {
                $scope.RoleList = JSON.parse(response.data.d.Roles);
            }

        }, function onFailure(error) {

        });
    };

    $scope.GetRoleList();

    $scope.GetEmployee = function () {
        $http({
            method: "POST",
            url: "UserAndRole.aspx/GetEmployee",
            data: {},
            dataType: "json",
            headers: { "Content-Type": "application/json" }
        }).then(function onSuccess(response) {
            if (response.data.d.ErrorCode == 1001) {
                SessionOut();
                return false;
            }
            if (response.data.d.ErrorCode != 0) {
                alert(response.data.d.ErrorMessage);
                return false;
            }
            else {
                $scope.EmployeeList = JSON.parse(response.data.d.JSonstring);
            }

        }, function onFailure(error) {

        });
    };

    $scope.GetEmployee();

    $scope.GetUserBranch = function (UserID) {
        $http({
            method: "POST",
            url: "UserAndRole.aspx/GetUserBranch",
            data: { UserID: UserID },
            dataType: "json",
            headers: { "Content-Type": "application/json" }
        }).then(function onSuccess(response) {
            if (response.data.d.ErrorCode == 1001) {
                SessionOut();
                return false;
            }
            if (response.data.d.ErrorCode != 0) {
                alert(response.data.d.ErrorMessage);
                return false;
            }
            else {
                
                $scope.UserBranchList = JSON.parse(response.data.d.JSonstring);
                
            }

        }, function onFailure(error) {

        });
    };

    $scope.OnUserClick = function (UserID) {
        if (UserID != 0) {
            var Obj = $scope.UserList.filter(function (x) { return x.UserID == UserID })[0];
            $scope.UserRolsID = { RoleID: Obj.RoleID, RoleName: "" };
            $scope.EmployeeMasterID = { EmployeeMasterID: Obj.EmployeeID, EmployeeName: "" };
            $scope.UserName = Obj.UserName;
            $scope.UserMailID = Obj.LoginID;
            $scope.Userpassword = "";
            $scope.UserCnfpassword = "";
            $scope.UserID = UserID;
            $scope.passwordStatus = '';
            $scope.passwordStyle = '';
        } else {
            $scope.UserRolsID = { RoleID: 0, RoleName: "" };
            $scope.EmployeeMasterID = { EmployeeMasterID: 0, EmployeeName: "" };
            $scope.UserName = "";
            $scope.UserMailID = "";
            $scope.Userpassword = "";
            $scope.UserCnfpassword = "";
            $scope.UserID = 0;
            $scope.isPasswordRegenerated = false;
            $scope.isdeleted = false;
            $scope.passwordStatus = '';
            $scope.passwordStyle = '';
        }
        $scope.GetUserBranch(UserID);
        $("#div_usermodify").css("display", "block");

    };

    $scope.OnAddModifyUserClick = function () {
        
        if (!ValidateUser())
            return false;
        
        $http({
            method: "POST",
            url: "UserAndRole.aspx/AddModifyUser",
            data: {LoginUserID: $scope.UserID, UserName: $scope.UserName, LoginID: $scope.UserMailID, RoleID: $scope.UserRolsID.RoleID, 
                Password: $scope.Userpassword, isPasswordRegenerated: $scope.isPasswordRegenerated, isdeleted: $scope.isdeleted,
                EmpoyeeID: $scope.EmployeeMasterID.EmployeeMasterID, BranchIDs: $scope.BranchIDs
            },
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
                if ($scope.isdeleted) {
                    $window.alert("User deleted Succesfully");
                }
                else if ($scope.isPasswordRegenerated) {
                    $window.alert("Succesfully Changed Password");
                }
                else {
                    $window.alert("Save Succesfully");
                    $scope.GetUsersList();
                }
                $("#div_usermodify").css("display", "none");
                return false;
            }

        }, function onFailure(error) {

        });

        return false;
    };

    function ValidateUser() {
        if ($scope.isdeleted) {
            return true;
        }
        else if ($scope.isPasswordRegenerated) {
            if ($scope.passwordStatus == 'Weak' && $scope.Userpassword != "") {
                $window.alert("Password is week");
                return false;
            }
            else if ($scope.Userpassword == "") {
                $window.alert("Please Enter password");
                return false;
            }
            else if ($scope.UserCnfpassword == "") {
                $window.alert("Please Enter confirm password");
                return false;
            }
            else if ($scope.Userpassword != $scope.UserCnfpassword) {
                $window.alert("Please is not same");
                return false;
            }
        }
        else {
            if ($scope.UserName == "") {
                $window.alert("Please enter is user name");
                return false;
            }
            else if ($scope.UserMailID == "") {
                $window.alert("Please enter is mail id");
                return false;
            }
            else if ($scope.UserRolsID.RoleID == 0) {
                $window.alert("Please select role");
                return false;
            }
            else if ($scope.UserRolsID.RoleID == 0) {
                $window.alert("Please select Employee");
                return false;
            }
            if ($scope.UserID == 0) {
                if ($scope.passwordStatus == 'Weak' && $scope.Userpassword != "") {
                    $window.alert("Password is week");
                    return false;
                }
                else if ($scope.Userpassword == "") {
                    $window.alert("Please Enter password");
                    return false;
                }
                else if ($scope.UserCnfpassword == "") {
                    $window.alert("Please Enter confirm password");
                    return false;
                }
                else if ($scope.Userpassword != $scope.UserCnfpassword) {
                    $window.alert("Password is not same");
                    return false;
                }
            }
        }
        return true;
    }

    $scope.onUserDeleteClick = function () {
        $scope.isdeleted = true;
        $scope.OnAddModifyUserClick();
    }

    $scope.OnChangedPasswordClick = function () {
        $scope.isPasswordRegenerated = true;
        $("#passwordreset").css("display", "block");
        return false;
    }

    $scope.onChangedPasswordClose = function () {
        $scope.isPasswordRegenerated = false;
        $("#passwordreset").css("display", "none");
        return false;
    }

    $scope.OnAddModifyRoleClick = function (RoleID) {
        $window.open("AddModifyRole.aspx?RoleID=" + RoleID, "role", "resizable=yes,location=1,status=1,scrollbars=1,width=800,height=600");
        return false;
    }

    $scope.onUserClose = function () {
        $("#div_usermodify").css("display", "none");
        return false;
    }

   $scope.check = function(x) {
        var level = 0;
        var p1 = /[a-z]/;
        var p2 = /[A-Z]/;
        var p3 = /[0-9]/;
        var p4 = /[\!\@\#\$\%\^\&\*\(\)\-\_\=\+\[\{\]\}\|\\\;\:\'\"\,\<\.\>\/\?\`\~]/;
        if (x.length >= 8)
            level++;
        if (p1.test(x))
            level++;
        if (p2.test(x))
            level++;
        if (p3.test(x))
            level++;
        if (p4.test(x))
            level++;
        prog_bar(level, 0, 5, 200, 10, "#cdcdcc", "#44adf6");
    }


    function prog_bar(cur_val, min_val, max_val, width, height, border, fill) {
        $scope.passwordStatus = '';
        $scope.passwordStyle = '';
        var str = "", res = 0;
        if (cur_val >= min_val && cur_val <= max_val) {
            if (min_val < max_val) {
                res = ((cur_val - min_val) / (max_val - min_val)) * 100;
                res = Math.floor(res);
            }
            else {
                res = 0;
            }
        }
        else {
            res = 0;
        }
        if (res <= 40)
            fill = "#9f0400";
        else if (res <= 60)
            fill = "#e9d103";
        else if (res <= 80)
            fill = "#007100";
        //str = str + "<div style=\"border:" + border + " ; width:" + width + "px; height:" + height + "px;\">";
        //str = str + "<div style=\"background-color:" + fill + "; width:" + res + "%; height:" + height + "px;\">";
        //str = str + "</div></div>";
        if (res > 0 && res <= 40) {
            $scope.passwordStatus = "Weak";
        }
        else if (res > 40 && res <= 60) {
            $scope.passwordStatus = "Good";
        }
        else if (res > 60 && res <= 80) {
            $scope.passwordStatus = "Strong";
        }
        else if (res > 80) {
            $scope.passwordStatus = "Excellent";

        }
        $scope.passwordStyle = { 'color': fill };

    }

});