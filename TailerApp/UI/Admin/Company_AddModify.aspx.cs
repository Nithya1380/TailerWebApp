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
    public partial class Company_AddModify : System.Web.UI.Page
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
            try
            {
                AdminManagerSP AdminManager = new AdminManagerSP();
                if (!AdminManager._C_GetCompanyDetails(string.IsNullOrEmpty(CompanyID) ? 0 : Convert.ToInt32(CompanyID), 0, out OutPutData))
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
            try
            {
                AdminManagerSP AdminManager = new AdminManagerSP();
                if (!AdminManager._C_AddModifyCompany(string.IsNullOrEmpty(CompanyID) ? 0 : Convert.ToInt32(CompanyID), 0, CompanyDetails, AddressDetails))
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

        protected string GetDecryptedQueryString(string queryString)
        {
            string rowUrl = null;
            string queryStringVal = null;
            try
            {
                if (HttpContext.Current.Request.Url.ToString().Contains('?'))
                {
                    rowUrl = HttpContext.Current.Request.Url.ToString().Split('?')[1];
                    string[] actualQueryStrings = TailerApp.Common.Cryptography.Decrypt(rowUrl.Substring(rowUrl.IndexOf('?') + 1)).Split(new char[] { '&' });
                    if (actualQueryStrings != null && actualQueryStrings.Length > 0)
                    {
                        var objQuery = actualQueryStrings.Where(str => str.StartsWith(queryString + "="));
                        var queryString_EqualsCount = 0;
                        if (objQuery.Count() > 0)
                        {
                            queryStringVal = objQuery.First().Split('=')[1];

                            queryString_EqualsCount = objQuery.First().Count(X => X == '=');
                        }

                        if (queryString_EqualsCount >= 2)
                        {
                            int firstEqualIndex = objQuery.First().IndexOf('=');
                            queryStringVal = objQuery.First().Substring(firstEqualIndex + 1);
                        }

                    }
                }
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return queryStringVal;
        }

    }
}