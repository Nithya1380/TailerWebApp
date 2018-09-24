using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL;
using DAL.Model;
using DAL.Utilities;
using DAL.DBManager;
using System.Web.Services;

namespace TailerApp.UI.Admin
{
    public partial class AdminHome : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JSONReturnData GetURLEncryptedData(string URLdata)
        {
            JSONReturnData records = new JSONReturnData();
            TailerApp.Common.LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    records.errorCode = 10001;
                    records.errorMessage = "";
                }
                string EncryptedData = TailerApp.Common.Cryptography.Encrypt(URLdata);
                records.errorCode = 0;
                records.errorMessage = "";
                records.String_Outvalue = EncryptedData;
            }
            catch (Exception ee)
            {
                records.errorCode = -5;
                records.errorMessage = "Unknown Error occured while canceling Schedules.";
            }
            return records;
        }

        [WebMethod]
        public static Struct_Company GetCompanyAndBranchList()
        {
            Struct_Company records = new Struct_Company();
            try
            {
                AdminManagerSP AdminManager = new AdminManagerSP();
                if (AdminManager._C_GetCompanyAndBranchList(0, out records))
                {
                    records.errorCode = AdminManager.GetLastErrorCode();
                    records.errorMessage = AdminManager.GetLastError();
                }
                return records;
            }
            catch (Exception ee)
            {
                records.errorCode = -5;
                records.errorMessage = "Unknown Error occured while canceling Schedules.";
            }
            return records;
        }
    }
}