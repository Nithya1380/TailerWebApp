using DAL.DBManager;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;

namespace TailerApp.UI.Admin
{
    public partial class UserAndRole : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static Struct_UserRole GetUsers()
        {
            Struct_UserRole userList = new Struct_UserRole();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    userList.errorCode = 1001;
                    userList.errorMessage = "";
                    return userList;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (adminObj._U_GetUsers(currentUser.CompanyID, currentUser.UserId, out userList))
                {
                    userList.errorCode = 0;
                    userList.errorMessage = "";
                }
                else
                {
                    userList.errorCode = 1;
                    userList.errorMessage = "Failed to get User List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return userList;
        }

        [WebMethod]
        public static Struct_UserRole GetRoles()
        {
            Struct_UserRole roleList = new Struct_UserRole();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    roleList.errorCode = 1001;
                    roleList.errorMessage = "";
                    return roleList;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (adminObj._U_GetRoles(currentUser.CompanyID, currentUser.UserId, out roleList))
                {
                    roleList.errorCode = 0;
                    roleList.errorMessage = "";
                }
                else
                {
                    roleList.errorCode = 1;
                    roleList.errorMessage = "Failed to get Role List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return roleList;
        }

        [WebMethod]
        public static JSONReturnData AddModifyUser(string LoginUserID, string UserName, string LoginID, string RoleID, string Password, bool isPasswordRegenerated, bool isdeleted, string EmpoyeeID)
        {
            JSONReturnData Objuser = new JSONReturnData();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    Objuser.errorCode = 1001;
                    Objuser.errorMessage = "";
                    return Objuser;
                }
                byte[] EncryptedCurrentpassword = new System.Text.ASCIIEncoding().GetBytes(Cryptography.Encrypt(Password));

                AdminManagerSP adminObj = new AdminManagerSP();

                if (adminObj._U_AddModifyUser(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(LoginUserID) ? 0 : Convert.ToInt32(LoginUserID),
                    UserName, LoginID, string.IsNullOrEmpty(RoleID) ? 0 : Convert.ToInt32(RoleID), EncryptedCurrentpassword, isPasswordRegenerated, isdeleted, , string.IsNullOrEmpty(EmpoyeeID) ? 0 : Convert.ToInt32(EmpoyeeID)))
                {
                    Objuser.errorCode = 0;
                    Objuser.errorMessage = "";
                }
                else
                {
                    Objuser.errorCode = 1;
                    Objuser.errorMessage = "Failed to save user. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return Objuser;
        }

        [WebMethod]
        public static JsonResults GetEmployee()
        {
            JsonResults emplList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    emplList.ErrorCode = 1001;
                    emplList.ErrorMessage = "";
                    return emplList;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (adminObj.GetEmployeeList(currentUser.CompanyID, currentUser.UserId, true, out emplList))
                {
                    emplList.ErrorCode = 0;
                    emplList.ErrorMessage = "";
                }
                else
                {
                    emplList.ErrorCode = 1;
                    emplList.ErrorMessage = "Failed to get Employee List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return emplList;
        }

    }
}