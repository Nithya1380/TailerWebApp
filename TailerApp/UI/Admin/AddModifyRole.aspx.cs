using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;
using DAL.DBManager;
using DAL.Model;

namespace TailerApp.UI.Admin
{
    public partial class AddModifyRole : PageBase
    {
        public int RoleID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("RoleID")))
                RoleID = Convert.ToInt32(this.GetDecryptedQueryString("RoleID"));
        }

        [WebMethod]
        public static JSONReturnData SaveRolePermission(string RoleID, string RoleName, string PermissionAdded, string PermissionRemoved, bool isDeleted)
        {
            JSONReturnData ObjRole = new JSONReturnData();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    ObjRole.errorCode = 1001;
                    ObjRole.errorMessage = "";
                    return ObjRole;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (!adminObj._U_ModifyRolePermission(currentUser.CompanyID, currentUser.UserId, RoleName, string.IsNullOrEmpty(RoleID) ? 0 : Convert.ToInt32(RoleID), PermissionAdded, PermissionRemoved, isDeleted, out ObjRole))
                {
                    ObjRole.errorCode = adminObj.GetLastErrorCode();
                    ObjRole.errorMessage = adminObj.GetLastError();
                }
               
            }
            catch (Exception ex)
            {
                ObjRole.errorCode = -4;
                ObjRole.errorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return ObjRole;
        }

        [WebMethod]
        public static Struct_UserRole GetRolePermission(string RoleID)
        {
            Struct_UserRole rolePermission = new Struct_UserRole();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    rolePermission.errorCode = 1001;
                    rolePermission.errorMessage = "";
                    return rolePermission;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (!adminObj._U_GetRolePermission(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(RoleID) ? 0 : Convert.ToInt32(RoleID), out rolePermission))
                {
                    rolePermission.errorCode = adminObj.GetLastErrorCode();
                    rolePermission.errorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                rolePermission.errorCode = -4;
                rolePermission.errorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return rolePermission;
        }

    }
}