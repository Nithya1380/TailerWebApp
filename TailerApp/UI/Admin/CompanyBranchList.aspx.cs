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
    public partial class CompanyBranchList : PageBase
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
                    records.errorCode = 1001;
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
        public static Struct_Company GetCompanyBranchList()
        {
            Struct_Company records = new Struct_Company();
            TailerApp.Common.LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    records.errorCode = 1001;
                    records.errorMessage = "";
                }

                AdminManagerSP AdminManager = new AdminManagerSP();
                if (!AdminManager._C_GetCompanyAndBranchList(currentUser.CompanyID, currentUser.UserId, out records))
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