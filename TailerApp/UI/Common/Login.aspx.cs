using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;
using TailerApp.Controller;

namespace TailerApp.UI.Common
{
    public partial class Login : System.Web.UI.Page
    {
        public string redirectToPage=string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                HttpContext.Current.Session.Clear();
                HttpContext.Current.Session.Abandon();
            }

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txtUserName.Text) || string.IsNullOrEmpty(txtPassword.Text))
                    return;

                this.LoginProcess(txtUserName.Text, txtPassword.Text);
            }
            catch(Exception ex)
            {
                Utils.Write(ex);
            }

        }

        private void LoginProcess(string loginid, string password)
        {
            LoginUser objLoginUser = null;
            List<BranchDetail> userBranchList = null;
            string InstanceName = string.Empty;
            try
            {
                InstanceName = Utils.GetConfigParam<string>("InstanceName");
                string IpAddesss = System.Web.HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
                if (string.IsNullOrEmpty(IpAddesss))
                    IpAddesss = System.Web.HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];

                string BrowserInfo = "Browser Capabilities\n"
                                        + "Type : " + Request.Browser.Type + ", "
                                        + "Name : " + Request.Browser.Browser + ", "
                                        + "Version : " + Request.Browser.Version + ", "
                                        + "Major Version : " + Request.Browser.MajorVersion + ", "
                                        + "Minor Version : " + Request.Browser.MinorVersion + ", "
                                        + "Platform : " + Request.Browser.Platform + ", "
                                        + "Is Beta : " + Request.Browser.Beta + ", "
                                        + "Is Crawler : " + Request.Browser.Crawler + ", "
                                        + "Is AOL : " + Request.Browser.AOL + ", "
                                        + "Is Win16 : " + Request.Browser.Win16 + ", "
                                        + "Is Win32 : " + Request.Browser.Win32 + ", "
                                        + "Supports Frames : " + Request.Browser.Frames + ", "
                                        + "Supports Tables : " + Request.Browser.Tables + ", "
                                        + "Supports Cookies : " + Request.Browser.Cookies + ", "
                                        + "Supports VBScript : " + Request.Browser.VBScript + ", "
                                        + "Supports JavaScript : " + Request.Browser.JavaScript + ", "
                                        + "Supports Java Applets : " + Request.Browser.JavaApplets + ", "
                                        + "Supports ActiveX Controls : " + Request.Browser.ActiveXControls + ", "
                                        + "Supports JavaScript Version  " + Request.Browser["JavaScriptVersion"] + ", "
                                        + "UserAgent : " + Request.UserAgent;

                string OperatingSystem = Request.UserAgent;
                string BrowserVersion = Request.Browser.Version;
                string BrowserName = Request.Browser.Browser;

                string server = Request.ServerVariables["SERVER_NAME"];

                string webSessionID = System.Web.HttpContext.Current.Session.SessionID;
                string FullURL = "";
                string InstanceCode = "";
                LoginController objLoginController = new LoginController();
               
                objLoginUser = objLoginController.ValidateLogin(loginid, password, InstanceName, IpAddesss, BrowserInfo, server,
                               webSessionID, out userBranchList, OperatingSystem, BrowserVersion, BrowserName);
                if (objLoginUser != null)
                {
                    lblErrorMessage.Text = "";
                    if (!objLoginController.OnLoginSuccess(ref objLoginUser, ref userBranchList, redirectToPage))
                    {
                        ShowValidationMessage("Failed to Login.");
                    }
                   
                }
                else
                {
                    Session.Clear();
                    txtPassword.Focus();
                    ShowValidationMessage(objLoginController.GetLastError());
                }

            }
            catch (ThreadAbortException ex)
            {

            }
            catch (Exception ee)
            {
                Session.Clear();//Newly Added to Avoid Connection String Storage conflict If Password Mismatched means.
                Utils.Write(ee);
            }
        }
        private void ShowValidationMessage(string message)
        {
            try
            {
                lblErrorMessage.Text = message;
                //Utils.ExecuteScript(this.Page, "showLoginAlert();");
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }
        }
    }
}