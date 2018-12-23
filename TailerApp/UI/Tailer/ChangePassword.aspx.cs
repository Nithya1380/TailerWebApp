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

namespace TailerApp.UI.Tailer
{
    public partial class ChangePassword : PageBase
    {
        public string ApplicationVirtualPath = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            ApplicationVirtualPath = Utils.ApplicationVirtualPath;
        }

        [WebMethod]
        public static JSONReturnData GetUserDetails()
        {
            JSONReturnData userObj = new JSONReturnData();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    userObj.errorCode = 1001;
                    userObj.errorMessage = "";
                    return userObj;
                }
                byte[] EncryptedCurrentpassword;

                AdminManagerSP adminObj = new AdminManagerSP();
                if (adminObj.GetUserDetails(currentUser.CompanyID, currentUser.UserId, out EncryptedCurrentpassword))
                {
                    userObj.errorCode = 0;
                    userObj.errorMessage = "";
                    userObj.String_Outvalue = Cryptography.Decrypt(System.Text.Encoding.ASCII.GetString(EncryptedCurrentpassword));
                }
                else
                {
                    userObj.errorCode = 1;
                    userObj.errorMessage = "Failed to get User List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return userObj;
        }

        [WebMethod]
        public static JSONReturnData SaveChangePassword(string Password)
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

                if (adminObj.SaveChangePassword(currentUser.CompanyID, currentUser.UserId, EncryptedCurrentpassword))
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
    }
}