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

namespace TailerApp.UI.Tailer
{
    public partial class EmployeeMaster : PageBase
    {
        public int EmployeeID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("EmployeeID")))
                EmployeeID = Convert.ToInt32(this.GetDecryptedQueryString("EmployeeID"));
        }


        [WebMethod]
        public static Struct_Employee SaveEmployeeMasterDetails(string EmployeeID, string EmployeeDetails, bool isDeleted)
        {
            Struct_Employee empl = new Struct_Employee();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    empl.errorCode = 1001;
                    empl.errorMessage = "";
                    return empl;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (!adminObj.SaveEmployeeMasterDetails(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(EmployeeID) ? 0 : Convert.ToInt32(EmployeeID), EmployeeDetails, isDeleted, out empl))
                {
                    empl.errorCode = adminObj.GetLastErrorCode();
                    empl.errorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                empl.errorCode = -4;
                empl.errorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return empl;
        }

        [WebMethod]
        public static Struct_Employee GetEmployeeMasterDetails(string EmployeeID)
        {
            Struct_Employee empl = new Struct_Employee();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    empl.errorCode = 1001;
                    empl.errorMessage = "";
                    return empl;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (!adminObj.GetEmployeeMasterDetails(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(EmployeeID) ? 0 : Convert.ToInt32(EmployeeID), out empl))
                {
                    empl.errorCode = adminObj.GetLastErrorCode();
                    empl.errorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                empl.errorCode = -4;
                empl.errorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return empl;
        }


        [WebMethod]
        public static JsonResults GetPositions()
        {
            JsonResults plist = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    plist.ErrorCode = 1001;
                    plist.ErrorMessage = "";
                    return plist;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (!adminObj.GetPickLists(currentUser.CompanyID, currentUser.UserId, "EmployeePosition", out plist))
                {
                    plist.ErrorCode = adminObj.GetLastErrorCode();
                    plist.ErrorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                plist.ErrorCode = -4;
                plist.ErrorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return plist;
        }
    }
}