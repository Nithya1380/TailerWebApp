<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddModifyRole.aspx.cs" Inherits="TailerApp.UI.Admin.AddModifyRole" %>

<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>

<script src="../../Scripts/AngularJS/angular.js"></script>
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>

<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/solid.css" crossorigin="anonymous">
<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.3.1/css/fontawesome.css" crossorigin="anonymous">

<style type="text/css">

.web_panel_blue_head {
    background-color: #9cd3d1 !important;
    border: none;
    font-size: 15px;
    padding-left : 7px;
    font-weight: bold;
	border-left:4px solid #32a7a2 !important;
}

.web_parent_perss{

	padding-left: 15px
}

.web_child_perss{
	
	padding-left: 40px
}

</style>

<script type="text/javascript" language="javascript">
    /*
    public bool _U_UsersRegeneratePassword(int hha, int loggedInUser, int UserId, byte[] currentPassword, byte[] newPassword, out JSONReturnData report)
            {
                bool ret = false;
                report = new JSONReturnData();
                try
                {
                    string spName = "_U_UsersRegeneratePassword";
                    this.Connect(this.GetConnString(), hha, UserId);
                    this.ClearSPParams();
                    this.AddSPIntParam("@hha", hha);
                    this.AddSPIntParam("@user", loggedInUser);
                    this.AddSPIntParam("@UserID", UserId);
                    this.AddSPVarBinaryParam("@OldPassword", currentPassword);
                    this.AddSPVarBinaryParam("@NewPassword", newPassword);
    
                    this.AddSPReturnIntParam("@return");
                    if (this.ExecuteNonSP(spName) > 0)
                    {
                        int retcode = this.GetOutValueInt("@return");
                        switch (retcode)
                        {
                            case 1:
                                ret = true;
                                report.errorCode = 0;
                                break;
                            case -1:
                                SetError(-1, "UserID dose not exist.");
                                ret = false;
                                break;
                            case -2:
                                SetError(-2, "This user is Inactive.");
                                ret = false;
                                break;
                            default:
                                SetError(-50, "Failed to change password. Please contact kantime support.");
                                ret = false;
                                break;
                        }
                    }
                }
                catch (Exception ex)
                {
                    Utils.Write(hha, loggedInUser, "SetUpManager_SP", "_U_UsersPassword", "", "", ex);
                    this.SetError(-50, "Failed to change password. Please contact kantime support.");
                    ret = false;
                }
                finally
                {
                    this.ClearSPParams();
                    this.Disconnect();
                }
    
                return ret;
    
            }
            
            
            [WebMethod]
            public static JSONReturnData UpdateUserPasswords(string UserID, string CurrentPassword, string NewPassword, string ConfirmNewPassword)
            {
                JSONReturnData report = new JSONReturnData();
    
                try
                {
                    //validate session and get session details. If no session, then redirect to session expired page. 
                    LoginUser sessionObj = null;
                    ValidateStaticSession(out sessionObj);
    
                    //double check for session 
                    if (sessionObj == null)
                    {
                        report.errorMessage = "Your login session is expired. Please relogin and try again.";
                        report.errorCode = -1; // No Session
                        return report;
                    }
                    byte[] EncryptedCurrentpassword = new System.Text.ASCIIEncoding().GetBytes(Cryptography.Encrypt(CurrentPassword));
                    byte[] EncryptedNewpassword = new System.Text.ASCIIEncoding().GetBytes(Cryptography.Encrypt(NewPassword));
    
                    SetUpManager_SP ManagerObj = new SetUpManager_SP();
                    bool ret = ManagerObj._U_UsersRegeneratePassword
                        (sessionObj.HHAid, sessionObj.UserId, Convert.ToInt32(UserID), EncryptedCurrentpassword, EncryptedNewpassword, out report);
    
                    if (!ret)
                    {
                        report.errorCode = ManagerObj.GetLastErrorCode();
                        report.errorMessage = ManagerObj.GetLastError();
                    }
                    else
                    {
                        if (report.errorCode == 0)
                        {
    
                            report.errorMessage = "";
    
                            //Succesfully Updated Password in Users table Regular DataBase.
    
                            bool ret_ChangePwdinMasterDB = false;
    
                            SetUpManager_SP MasterManagerObj = new SetUpManager_SP();
    
                            ret_ChangePwdinMasterDB = MasterManagerObj._Master_ChangeUsersPasswordinMasterDataBase(UserID, EncryptedNewpassword, sessionObj.HHAid, out report);
    
                            if (ret_ChangePwdinMasterDB)
                            {
                                //Succesfully Changed Password in Master Database.
    
                            }
                            else
                            {
                                report.errorCode = MasterManagerObj.GetLastErrorCode();
                                report.errorMessage = MasterManagerObj.GetLastError();
    
                                Utils.Write("Failed to Change Password in Master Table.[!ret_ChangePwdinMasterDB].Exception Occured While Reverting back changes[UpdateUserPasswords in SetUP Page]");
    
                                JSONReturnData ChangeToOldPassword = new JSONReturnData();
    
                                //Failed to Change Password in Master Database.So we are reverting back Changed Password in Regular Database.
                                //We are Passing Current Password as NewPassword
                                bool ret_RegularDBPwdChange = ManagerObj._U_UsersRegeneratePassword
                                         (sessionObj.HHAid, sessionObj.UserId, Convert.ToInt32(UserID), EncryptedCurrentpassword, EncryptedCurrentpassword, out ChangeToOldPassword);
    
                                if (!ret_RegularDBPwdChange)
                                {
                                    report.errorCode = -50;
                                    report.errorMessage = "Failed to Update Password. Please contact KanTime Support.";
                                    Utils.Write("Failed to Change Password in Users Table.[!ret_RegularDBPwdChange].Exception Occured While Reverting back changes[UpdateUserPasswords] in SetUP Page");
                                }
                                else
                                {
    
                                }
                            }
                        }
                    }
                }
                catch (Exception ee)
                {
                    Utils.Write(ee);
                }
                return report;
            }
    
            function GetFilterConditionSettingsasUpdateUserPasswordsJSON(UserID) {
               var CurrentPassword = 
    return JSON.stringify({ UserID: UserID, CurrentPassword: CurrentPassword, NewPassword: NewPassword, ConfirmNewPassword: ConfirmNewPassword })
    }
		
    function check(x) {
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
        $('#hdn_PassStatus').val('');
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
        str = str + "<div style=\"border:" + border + " ; width:" + width + "px; height:" + height + "px;\">";
        str = str + "<div style=\"background-color:" + fill + "; width:" + res + "%; height:" + height + "px;\">";
        str = str + "</div></div>";
        if (res > 0 && res <= 40) {
            str = str + "Weak";
            $('#hdn_PassStatus').val('Weak');
        }
        else if (res > 40 && res <= 60) {
            str = str + "Good";
            $('#hdn_PassStatus').val('Good');
        }
        else if (res > 60 && res <= 80) {
            str = str + "Strong";
            $('#hdn_PassStatus').val('Strong');
        }
        else if (res > 80) {
            str = str + "Excellent";
            $('#hdn_PassStatus').val('Excellent');
        }
        document.getElementById("prog_bar").innerHTML = str;

    }

    <i class="fas fa-angle-down"></i>
   <i class="fas fa-angle-right"></i>
*/

    var test = angular.module("Test", []);
	
    test.controller('testcontroller', ['$scope', '$window', '$http', '$rootScope', '$filter', function ($scope, $window, $http, $rootScope, $filter) {

        $scope.PerList 
            = [{PerName: 'Menu1', ID: 1, PID: 0, ism: true, isch: false},
                 {PerName: 'Menu2', ID: 2, PID: 0, ism: true, isch: false},
                 {PerName: 'Menu3', ID: 3, PID: 0, ism: true, isch: false},
                 {PerName: 'Menu4', ID: 4, PID: 0, ism: true, isch: false},
                 {PerName: 'SubMenu1', ID: 5, PID: 2, ism: true, isch: false},
                 {PerName: 'SubMenu2', ID: 6, PID: 2, ism: true, isch: false},
                 {PerName: 'SubMenu3', ID: 7, PID: 3, ism: true, isch: false},
                 {PerName: 'SubMenu4', ID: 8, PID: 3, ism: true, isch: false},
                 {PerName: 'SubMenu5', ID: 9, PID: 3, ism: true, isch: false},
                 {PerName: 'SubMenu6', ID: 10, PID: 2, ism: true, isch: false},
                 {PerName: 'ParPer1', ID: 11, PID: 0, ism: false, isch: false},
                 {PerName: 'ParPer2', ID: 12, PID: 0, ism: false, isch: false},
                 {PerName: 'ParPer3', ID: 13, PID: 0, ism: false, isch: false},
                 {PerName: 'ParPer4', ID: 14, PID: 0, ism: false, isch: false},
                 {PerName: 'ChildPer1', ID: 15, PID: 12, ism: false, isch: false},
                 {PerName: 'ChildPer2', ID: 16, PID: 12, ism: false, isch: false},
                 {PerName: 'ChildPer3', ID: 17, PID: 13, ism: false, isch: false},
                 {PerName: 'ChildPer4', ID: 18, PID: 13, ism: false, isch: false},
                 {PerName: 'ChildPer5', ID: 19, PID: 13, ism: false, isch: false},
                 {PerName: 'ChildPer6', ID: 20, PID: 13, ism: false, isch: false},
            ];
		
        $scope.FilterItem = function (id, ism) {
            return $scope.PerList.filter(function (x) { return x.PID == id && x.ism == ism });
        };
	
        $scope.onParCheck = function(id, val){
		
            $scope.PerList.filter(function (z) { return z.PID == id }).forEach(function (item, index) {
                item.isch = val;
		
            });
        }

    }]);

</script>
</head>
<body>

<div ng-app="Test">
    <div ng-controller="testcontroller">
	<br>
	<div>
		<div class="web_panel_blue_head"><label> Menu Access </label></div>
		<div ng-repeat="MenuPar in (FilterItem(0, true))">
			<table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" style="margin-bottom:0px">
				<tr>
					<td style="padding:  0.25rem">
						<span class="web_parent_perss">&nbsp;<input type="checkbox" ng-model="MenuPar.isch" ng-click="onParCheck(MenuPar.ID, MenuPar.isch)" />&nbsp;{{MenuPar.PerName}}</span>
					</td>
				</tr>
				<tr ng-repeat="MenuChi in (FilterItem(MenuPar.ID, true))">
					<td style="padding:  0.25rem">
						<span class="web_child_perss"><input type="checkbox" ng-model="MenuChi.isch" ng-disabled="!MenuPar.isch" />&nbsp;{{MenuChi.PerName}}</span>
					</td>
				</tr>
			</table>
		</div>
		<div class="web_panel_blue_head"><label> Privileges </label></div>
		<div ng-repeat="PerPar in (FilterItem(0, false))">
			<table class="table table-bordered_second table-condensed table-hover table-striped table-bordered" style="margin-bottom:0px">
				<tr>
					<td style="padding:  0.25rem">
						<span  class="web_parent_perss">&nbsp;<input type="checkbox" ng-click="onParCheck(MenuPar.ID, MenuPar.isch)" ng-model="MenuPar.isch" />&nbsp;{{PerPar.PerName}}</span>
					</td>
				</tr>
				<tr ng-repeat="PerChi in (FilterItem(PerPar.ID, false))">
					<td style="padding: 0.25rem">
						<span class="web_child_perss"><input type="checkbox" ng-model="MenuChi.isch" ng-disabled="!MenuPar.isch" />&nbsp;{{PerChi.PerName}}</span>
					</td>
				</tr>
			</table>
		</div>
	</div>
    </div>
</div>

</body>
</html>
