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
    public partial class Company_AddModify : PageBase
    {
        public int CompanyID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("CompanyID")))
                CompanyID = Convert.ToInt32(this.GetDecryptedQueryString("CompanyID"));

        }

        [WebMethod]
        public static Struct_Company GetCompanyDetails(string CompanyID)
        {
            Struct_Company OutPutData = new Struct_Company();
            TailerApp.Common.LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    OutPutData.errorCode = 10001;
                    OutPutData.errorMessage = "";
                }

                AdminManagerSP AdminManager = new AdminManagerSP();
                if (!AdminManager._C_GetCompanyDetails(string.IsNullOrEmpty(CompanyID) ? 0 : Convert.ToInt32(CompanyID), currentUser.UserId, out OutPutData))
                {
                    OutPutData.errorCode = AdminManager.GetLastErrorCode();
                    OutPutData.errorMessage = AdminManager.GetLastError();

                }
                return OutPutData;
            }
            catch (Exception e)
            {
                OutPutData.errorCode = -4;
                OutPutData.errorMessage = "Unknown Error Occured";
                Utils.Write(e);
            }
            return OutPutData;
        }

        [WebMethod]
        public static JSONReturnData SaveCompanyDetails(string CompanyID, string CompanyDetails, string AddressDetails)
        {
            JSONReturnData OutPutData = new JSONReturnData();
            TailerApp.Common.LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    OutPutData.errorCode = 10001;
                    OutPutData.errorMessage = "";
                }

                AdminManagerSP AdminManager = new AdminManagerSP();
                if (AdminManager._C_AddModifyCompany(string.IsNullOrEmpty(CompanyID) ? 0 : Convert.ToInt32(CompanyID), currentUser.UserId, CompanyDetails, AddressDetails))
                {
                    OutPutData.errorCode = AdminManager.GetLastErrorCode();
                    OutPutData.errorMessage = AdminManager.GetLastError();
                }
                return OutPutData;
            }
            catch (Exception e)
            {
                OutPutData.errorCode = -4;
                OutPutData.errorMessage = "Unknown Error Occured";
                Utils.Write(e);
            }
            return OutPutData;
        }

    }
}