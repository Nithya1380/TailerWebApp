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
    public partial class Branch_AddModify : PageBase
    {
        public int CompanyID = 0;
        public int BranchID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("CompanyID")))
                CompanyID = Convert.ToInt32(this.GetDecryptedQueryString("CompanyID"));

            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("BranchID")))
                BranchID = Convert.ToInt32(this.GetDecryptedQueryString("BranchID"));
        }

        [WebMethod]
        public static Struct_Branch GetBranchDetails(string CompanyID, string BranchID)
        {
            Struct_Branch OutPutData = new Struct_Branch();
            TailerApp.Common.LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    OutPutData.errorCode = 10001;
                    OutPutData.errorMessage = "";
                }

                AdminManagerSP AdminManager = new AdminManagerSP();
                if (!AdminManager._C_GetBranchDetails(string.IsNullOrEmpty(CompanyID) ? 0 : Convert.ToInt32(CompanyID), currentUser.UserId, string.IsNullOrEmpty(BranchID) ? 0 : Convert.ToInt32(BranchID), out OutPutData))
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
        public static JSONReturnData SaveBranchDetails(string CompanyID, string BranchID, string BranchDetails, string AddressDetails)
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
                if (AdminManager._C_AddModifyBranch(string.IsNullOrEmpty(CompanyID) ? 0 : Convert.ToInt32(CompanyID), currentUser.UserId, string.IsNullOrEmpty(BranchID) ? 0 : Convert.ToInt32(BranchID), BranchDetails, AddressDetails))
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