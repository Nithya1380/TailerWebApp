using DAL.Model;
using DAL.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.DBManager
{
    public class SecurityManager : KanDelegate
    {
        public bool _U_ValidateLogin(string LoginId, string Password, string InstanceName, byte[] EncryptedPassword,
                   string IpAddesss, string BrowserInfo, string server, string webSessionID,string OperatingSystem, 
                   string BrowserVersion,string BrowserName, string SSOAuthToken,out Struct_LoginUser Ulogin)
        {
            bool ret = false;
            Ulogin = new Struct_LoginUser();
            try
            {

                this.Connect(this.GetConnString());
                string spName = "_U_ValidateLogin";
                this.ClearSPParams();
                this.AddSPStringParam("@LoginId", LoginId);
                this.AddSPStringParam("@Password", Password);
                this.AddSPVarBinaryParam("@EncryptedPassword", EncryptedPassword);
                this.AddSPStringParam("@IpAddesss", IpAddesss);
                this.AddSPStringParam("@BrowserInfo", BrowserInfo);
                this.AddSPStringParam("@server", server);
                this.AddSPStringParam("@webSessionID", webSessionID);
                this.AddSPStringParam("@instanceName", InstanceName);
                this.AddSPStringParam("@OperatingSystem", OperatingSystem);
                this.AddSPStringParam("@BrowserVersion", BrowserVersion);
                this.AddSPStringParam("@Browser", BrowserName);
                this.AddSPStringParam("@SSOAuthToken", SSOAuthToken);
                this.AddSPReturnIntParam("@return");

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {

                    while (reader.Read())
                    {

                        //get the LoginID (Login User Name)
                        if (reader["LoginID"] != DBNull.Value)
                            Ulogin.loginId = reader["LoginID"].ToString();
                        else
                            Ulogin.loginId = "";

                        //get the Role ID
                        if (reader["RoleID"] != DBNull.Value)
                            Ulogin.RoleID = Convert.ToInt32(reader["RoleID"]);
                        else
                            Ulogin.RoleID = 0;

                        if (reader["CompanyID"] != DBNull.Value)
                            Ulogin.CompanyID = Convert.ToInt32(reader["CompanyID"]);
                        else
                            Ulogin.CompanyID = 0;

                        //get the LOGIN_STATUS 
                        if (reader["LOGIN_STATUS"] != DBNull.Value)
                            Ulogin.loginstatus = reader["LOGIN_STATUS"].ToString();
                        else
                            Ulogin.loginstatus = "";

                        //get the SCOPE
                        if (reader["Scope"] != DBNull.Value)
                            Ulogin.rolescope = reader["Scope"].ToString();
                        else
                            Ulogin.rolescope = "";

                        //get the LAST_LOGIN 
                        //if (reader["LastLoginTime"] != DBNull.Value)
                        //    Ulogin.lastlogindate = Convert.ToDateTime(reader["LastLoginTime"]);
                      

                        //get the [USER_ID] 
                        if (reader["UserID"] != DBNull.Value)
                            Ulogin.UserId = Convert.ToInt32(reader["UserID"]);
                        else
                            Ulogin.UserId = 0;

                        ////get the USER_PK
                        //if (reader["USER_PK"] != DBNull.Value)
                        //    Ulogin.UserPrimaryKey = Convert.ToInt32(reader["USER_PK"]);
                        //else
                        //    Ulogin.UserPrimaryKey = 0;
                                               
                        //get the LANDING_PAGE
                        if (reader["LANDING_PAGE"] != DBNull.Value)
                            Ulogin.Landingpage = reader["LANDING_PAGE"].ToString();
                        else
                            Ulogin.Landingpage = "";

                        //get the ROLE_NAME
                        if (reader["RoleName"] != DBNull.Value)
                            Ulogin.RoleName = reader["RoleName"].ToString();
                        else
                            Ulogin.RoleName = "";

                        //get the IS_PASSWORD_REGENERATED 
                        if (reader["isPasswordRegenerated"] != DBNull.Value)
                            Ulogin.Is_Password_Regenerated = Convert.ToBoolean(reader["isPasswordRegenerated"]);
                        else
                            Ulogin.Is_Password_Regenerated = false;

                        if (reader["PassowordExpireOn"] != DBNull.Value)
                            Ulogin.PASSWD_EXPIRY = Convert.ToDateTime(reader["PassowordExpireOn"]);
                                             
                     
                        ////get the User_type 
                        //if (reader["User_Type"] != DBNull.Value)
                        //    Ulogin.UserType = Convert.ToByte(reader["User_Type"]);
                        //else
                        //    Ulogin.UserType = 0;

                        //SessionTimeOut
                        if (reader["SessionTimeOut"] != DBNull.Value)
                            Ulogin.SessionOutTime = Convert.ToInt32(reader["SessionTimeOut"]);
                        else
                            Ulogin.SessionOutTime = 0;

                        // Role Type
                        if (reader["ROLE_TYPE"] != DBNull.Value)
                            Ulogin.roleType = Convert.ToInt32(reader["ROLE_TYPE"]);
                        else
                            Ulogin.roleType = 0;

                        //userName  
                        if (reader["userName"] != DBNull.Value)
                            Ulogin.userName = Convert.ToString(reader["userName"]);
                        else
                            Ulogin.userName = "";
                        
                        if (reader["IsSSOLogin"] != DBNull.Value)
                            Ulogin.IsSSOLogin = Convert.ToBoolean(reader["IsSSOLogin"]);
                        else
                            Ulogin.IsSSOLogin = false;

                        if (reader["UserSessionID"] != DBNull.Value)
                            Ulogin.UserSessionID = reader["UserSessionID"].ToString();
                        else
                            Ulogin.UserSessionID = "";

                        if (reader["enableAutoSessionOut"] != DBNull.Value)
                            Ulogin.enableAutoSessionOut = Convert.ToBoolean(reader["enableAutoSessionOut"]);
                        else
                            Ulogin.enableAutoSessionOut = false;

                    }

                   reader.Close();
                  int retcode = this.GetOutValueInt("@return");

                  switch (retcode)
                    {
                        case 1: ret = true;
                            break;
                        case -1: SetError(102, "The username or password you entered is incorrect");
                            break;
                        case -2: SetError(109, "The user does not have access to any branches");
                            break;
                        case -3: SetError(-3, "Your account is locked due to too many failed attempts. Please contact your administrator to unlock.");
                            break;
                        case -4:
                            SetError(-4, "Blocked Your IP Address. Please contact Admin.");
                            break;
                        default: SetError(-100, "Failed to Login. Please try again later");

                            break;
                    }
                }
            }
            catch (Exception e)
            {
                SetError(-100, "Failed to Login. Please try again later");
                Utils.Write(0, 0, "SecurityManager", "_U_ValidateLogin", "", "", e);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }
    }
}
