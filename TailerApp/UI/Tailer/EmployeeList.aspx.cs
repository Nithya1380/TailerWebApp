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
    public partial class EmployeeList : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JsonResults GetEmployeeList()
        {
            JsonResults emplList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    emplList.ErrorCode = 1001;
                    emplList.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.GetEmployeeList(currentUser.CompanyID, currentUser.UserId, false, out emplList))
                {
                    emplList.ErrorCode = 0;
                    emplList.ErrorMessage = "";
                }
                else
                {
                    emplList.ErrorCode = -1;
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