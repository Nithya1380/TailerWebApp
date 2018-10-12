<%@ Page Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserAndRole.aspx.cs" Inherits="TailerApp.UI.Admin.UserAndRole" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContent" runat="server">
    <script src="../../Scripts/AngularJS/angular.js"></script>
    <script src="../../Scripts/AngularJS/UserAndRoleController.js"></script>
    <style type="text/css">
        .modal-backdrop {
            position: fixed;
            z-index: auto;
            padding-top: 100px;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.7);
            opacity: 2.26;
        }
    </style>
    <script type="text/javascript">
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container bootstrap snippet" ng-app="TailerApp" ng-controller="UserAndRoleController">
        <div class="row">
            <div>&nbsp;</div>
        </div>
        <div class="col-lg-12 col-md-12 col-sm-12">
            <div class="card">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#userTab">Users</a></li>
                            <li><a data-toggle="tab" href="#roleTab">Roles</a></li>

                        </ul>
                        <%--User List--%>
                        <div class="tab-content">
                            <div class="tab-pane active" id="userTab">
                                <div class="row">
                                    <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom: 5px">
                                        <button class="btn btn-lg btn-success" type="button" ng-click="OnUserClick(0);"><i class="fas fa-plus-square"></i>&nbsp;Add New User</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12">
                                        <div class="card">
                                            <div class="row">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Name</th>
                                                            <th>Login ID</th>
                                                            <th>Role</th>
                                                            <th></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody ng-repeat="user in UserList">
                                                        <tr>
                                                            <td><a href="#" ng-click="OnUserClick(user.UserID)">{{user.EmployeeName}}</a></td>
                                                            <td>{{user.LoginID}}</td>
                                                            <td>{{user.RoleName}}</td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%--Role List--%>
                            <div class="tab-pane" id="roleTab">
                                <div class="row">
                                    <div class="col-lg-2 col-md-2 col-sm-2 pull-right" style="margin-bottom: 5px">
                                        <button class="btn btn-lg btn-success" type="button" ng-click="OnAddModifyRoleClick(0);"><i class="fas fa-plus-square"></i>&nbsp;Add New Role</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-12 col-md-12 col-sm-12">
                                        <div class="card">
                                            <div class="row">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Role</th>
                                                            <th></th>
                                                            <th></th>
                                                            <th></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody ng-repeat="role in RoleList">
                                                        <tr>
                                                            <td><a href="#" ng-click="OnAddModifyRoleClick(role.RoleID)">{{role.RoleName}}</a></td>
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>
                                                            <td></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
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
        <%--user add modify--%>
        <div id="div_usermodify" class="modal modal-backdrop">
            <div class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
                <div class="panel panel-info">
                    <div class="panel-heading">
                        <div class="panel-title">{{UserID == 0?'Add New User':'Modify User'}}</div>
                    </div>
                    <div class="panel-body">
                        <div class="form-horizontal" role="form">
                            <div class="form-group" style="display: none">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>User Name</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" name="email" placeholder="User Name" ng-model="UserName">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Mail ID</label>
                                <div class="col-sm-8">
                                    <input type="text" class="form-control" placeholder="mail id" ng-model="UserMailID">
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Role</label>
                                <div class="col-sm-8">
                                    <select class="form-control" ng-options="Role.RoleName for Role in RoleList track by Role.RoleID"
                                        ng-model="UserRolsID">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Employee</label>
                                <div class="col-sm-8" ng-disabled="UserID>0">
                                    <select class="form-control" ng-options="Employee.EmployeeName for Employee in EmployeeList track by Employee.EmployeeMasterID"
                                        ng-model="EmployeeMasterID">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span ng-hide="UserID != 0" style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Password</label>
                                <div class="col-sm-8">
                                    <input type="password" ng-hide="UserID != 0" class="form-control" name="password" placeholder="password" ng-keyup="check(Userpassword)" ng-model="Userpassword">
                                    <a href="#" ng-hide="UserID == 0" ng-click="OnChangedPasswordClick()">Changed Password</a>
                                    <span ng-style="passwordStyle">{{passwordStatus}}</span>
                                </div>
                            </div>
                            <div class="form-group" ng-hide="UserID != 0">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Confirm password</label>
                                <div class="col-sm-8">
                                    <input type="password" class="form-control" name="password_confirmation" placeholder="confirm password" ng-model="UserCnfpassword">
                                    <p style="color: green" ng-show="Userpassword!='' && Userpassword==UserCnfpassword">&#10004;</p>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Branch</label>
                                <div class="col-sm-8">
                                    <select class="form-control" ng-options="Employee.EmployeeName for Employee in EmployeeList track by Employee.EmployeeMasterID"
                                        ng-model="EmployeeMasterID">
                                    </select>
                                </div>
                            </div>
                            <div class="form-group">
                                <!-- Button -->
                                <div class="  col-sm-offset-3 col-sm-9">
                                    <button class="client_btn" type="button" ng-click="OnAddModifyUserClick()" data-toggle="dropdown" style="border-color: #00A5A8 !important; background-color: #00B5B8">
                                        <i class="fa fa-save"></i>Save
                                    </button>
                                    <button class="client_btn" type="button" ng-hide="UserID == 0" ng-click="onUserDeleteClick();" data-toggle="dropdown" style="border-color: rgba(212, 63, 58, 1) !important; background-color: rgba(212, 63, 58, 1)">
                                        <i class="fa fa-close"></i>Delete
                                    </button>
                                    <button class="client_btn" type="button" ng-click="onUserClose();" data-toggle="dropdown" style="border-color: #FFA87D !important; background-color: #FFA87D">
                                        <i class="fa fa-close"></i>Cancel
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="passwordreset" class="modal modal-backdrop">
            <div style="margin-top: 137px" class="mainbox col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2">
                <div class="panel panel-info">
                    <div class="panel-heading">
                        <div class="panel-title">Change Password</div>
                    </div>
                    <div class="panel-body">
                        <div class="form-horizontal" role="form">
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Password</label>
                                <div class="col-sm-8">
                                    <input type="password" class="form-control" name="password" placeholder="password" ng-keyup="check(Userpassword)" ng-model="Userpassword">
                                    <span ng-style="passwordStyle">{{passwordStatus}}</span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="email" class=" control-label col-sm-3"><span style="color: red; font-size: 8px; vertical-align: top;">&#10033;</span>Confirm password</label>
                                <div class="col-sm-8">
                                    <input type="password" class="form-control" name="password_confirmation" placeholder="confirm password" ng-model="UserCnfpassword">
                                </div>
                            </div>
                            <div class="form-group">
                                <!-- Button -->
                                <div class="  col-sm-offset-3 col-sm-9">
                                    <button class="client_btn" type="button" ng-click="OnAddModifyUserClick()" data-toggle="dropdown" style="border-color: #00A5A8 !important; background-color: #00B5B8">
                                        <i class="fa fa-save"></i>Save
                                    </button>
                                    <button class="client_btn" type="button" ng-click="onChangedPasswordClose();" data-toggle="dropdown" style="border-color: #FFA87D !important; background-color: #FFA87D">
                                        <i class="fa fa-close"></i>Cancel
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
