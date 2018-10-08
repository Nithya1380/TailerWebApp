using DAL.DBManager;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TailerApp.Common;

namespace TailerApp.Controller
{
    public class LoginController
    {
        private int errorCode;
        private string errorMessage;

        public void SetError(int errorCode)
        {
            this.errorCode = errorCode;
        }

        public void SetError(int errorCode, string error)
        {
            this.errorCode = errorCode;
            errorMessage = error;
        }

        public string GetLastError()
        {
            string _errorMessage = string.Empty;
            if (!string.IsNullOrEmpty(errorMessage))
                _errorMessage = errorMessage;
           
            return _errorMessage;

        }
        public LoginUser ValidateLogin(string loginId, string password, string InstanceName, string IpAddesss, string BrowserInfo,
               string server, string webSessionID,out List<BranchDetail> userBranchList, string OperatingSystem = "", string BrowserVersion = "", string BrowserName = "",
               string SSOAuthToken = "")
        {
            bool retval = false;
            LoginUser objLoginUser = null;
            userBranchList = new List<BranchDetail>();
            try
            {
                SecurityManager securitymanagerObj = new SecurityManager();
                Struct_LoginUser Ulogin = new Struct_LoginUser();
                byte[] Encryptedpassword = new System.Text.ASCIIEncoding().GetBytes(Cryptography.Encrypt(password));

                retval = securitymanagerObj._U_ValidateLogin(loginId, password, InstanceName, Encryptedpassword, IpAddesss, BrowserInfo,
                          server, webSessionID, OperatingSystem, BrowserVersion, BrowserName, SSOAuthToken, out Ulogin, out userBranchList);
                if (retval == true)
                {
                    objLoginUser = new LoginUser();

                    objLoginUser.loginId = Ulogin.loginId;
                    objLoginUser.CompanyID = Ulogin.CompanyID;
                    objLoginUser.loginstatus = Ulogin.loginstatus;
                    objLoginUser.RoleID = Ulogin.RoleID;
                    objLoginUser.rolescope = Ulogin.rolescope;

                    if (Ulogin.lastlogindate != null)
                        objLoginUser.lastlogindate = Convert.ToDateTime(Ulogin.lastlogindate);

                    objLoginUser.UserId = Ulogin.UserId;
                    objLoginUser.UserPrimaryKey = Ulogin.UserPrimaryKey;
                    objLoginUser.RoleName = Ulogin.RoleName;
                    objLoginUser.Landingpage = Ulogin.Landingpage;
                    objLoginUser.Is_Password_Regenerated = Ulogin.Is_Password_Regenerated;
                    objLoginUser.PASSWD_EXPIRY = Ulogin.PASSWD_EXPIRY;
                    objLoginUser.UserType = Ulogin.UserType;
                    objLoginUser.SessionOutTime = Ulogin.SessionOutTime;
                    objLoginUser.roleType = Ulogin.roleType; 


                    if (!string.IsNullOrEmpty(Ulogin.Landingpage))
                        objLoginUser.Landingpage = Ulogin.Landingpage;
                    else
                        objLoginUser.Landingpage = "UI/Common/BlankHome.aspx";

                    objLoginUser.userName = Ulogin.userName;
                    objLoginUser.IsSSOLogin = Ulogin.IsSSOLogin;
                    objLoginUser.UserSessionID = Ulogin.UserSessionID;
                    objLoginUser.enableAutoSessionOut = Ulogin.enableAutoSessionOut;
                }
                else
                {
                    this.SetError(securitymanagerObj.GetLastErrorCode(),securitymanagerObj.GetLastError());

                }
                    
                
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            finally
            {
                // LoginHelper = null;
            }
            return objLoginUser;
        }

        public bool OnLoginSuccess(ref LoginUser objLoginUser, ref List<BranchDetail> userBranchList, string RedirectPage)
        {
            bool ret = false;
            bool canRedirct = true;
            try
            {
                if (objLoginUser != null)
                {

                    if (objLoginUser.SessionOutTime != 0)
                        HttpContext.Current.Session.Timeout = objLoginUser.SessionOutTime;
                    else
                        HttpContext.Current.Session.Timeout = 180;

                    //MenuAccess menuObj = new MenuAccess();
                    //bool menuRet = menuObj.getMenuListHtml(objLoginUser.rolescope, objLoginUser.HHAid, objLoginUser.UserId, objLoginUser.ROLE, objLoginUser.User_Type,
                    //    out objLoginUser.mainMenuList, out objLoginUser.subMenuList, out objLoginUser.subSubMenuList);
                   
                    //if (!menuRet)
                    //{
                        
                    //}

                    if (userBranchList != null && userBranchList.Count == 1)
                        objLoginUser.UserBranchID = userBranchList[0].BranchID;

                    HttpContext.Current.Session.Add("LoginUser", objLoginUser);
                    HttpContext.Current.Session.Add("LoginUserBranchList", userBranchList);
                   
                    
                    if (canRedirct)
                    {
                        if (RedirectPage != "")
                        {
                            HttpContext.Current.Response.Redirect(RedirectPage);
                        }
                    }

                    bool Password_Expired = false;
                    if ((DateTime.Now > objLoginUser.PASSWD_EXPIRY && objLoginUser.PASSWD_EXPIRY != default(DateTime)) || String.Compare(objLoginUser.PASSWD_EXPIRY.ToShortDateString(), DateTime.Now.ToShortDateString()) == 0)
                    {
                        Password_Expired = true;
                    }
                    if (objLoginUser.IsSSOLogin == false && (objLoginUser.Is_Password_Regenerated || Password_Expired))
                    {
                        HttpContext.Current.Response.Redirect(Utils.ApplicationVirtualPath + "/UI/Common/UserPasswordChangePage.aspx?", false);
                    }
                    else if (canRedirct)
                    {
                        Utils.ShowPage(objLoginUser.Landingpage);                       
                    }
                    ret = true;
                }

            }
            catch (Exception ex)
            {
                ret = false;
                Utils.Write(ex);
            }
            return ret;
        }

    }
}