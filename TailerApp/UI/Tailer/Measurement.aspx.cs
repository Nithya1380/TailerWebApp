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
    public partial class Measurement : PageBase
    {
        public int MeasurementID = 0;
        public int InvoiceID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("MeasurementID")))
                MeasurementID = Convert.ToInt32(this.GetDecryptedQueryString("MeasurementID"));

            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("InvoiceID")))
                InvoiceID = Convert.ToInt32(this.GetDecryptedQueryString("InvoiceID"));
            
        }

        [WebMethod]
        public static JsonResults SaveMeasurementMaster(string MeasurMasterID, string MeasurDetails, string MeasurementField)
        {
            JsonResults Measur = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    Measur.ErrorCode = 1001;
                    Measur.ErrorMessage = "";
                    return Measur;
                }

                CustomerManager adminObj = new CustomerManager();
                if (!adminObj.SaveMeasurementMaster(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(MeasurMasterID) ? 0 : Convert.ToInt32(MeasurMasterID), MeasurDetails, MeasurementField, out Measur))
                {
                    Measur.ErrorCode = adminObj.GetLastErrorCode();
                    Measur.ErrorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                Measur.ErrorCode = -4;
                Measur.ErrorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return Measur;
        }

        [WebMethod]
        public static ST_Measurement GetMeasurementMaster(string MeasurMasterID, bool isPrint, string InvoiceID)
        {
            ST_Measurement Measur = new ST_Measurement();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    Measur.ErrorCode = 1001;
                    Measur.ErrorMessage = "";
                    return Measur;
                }

                CustomerManager adminObj = new CustomerManager();
                if (!adminObj.GetMeasurementMaster(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(MeasurMasterID) ? 0 : Convert.ToInt32(MeasurMasterID), out Measur, isPrint, string.IsNullOrEmpty(InvoiceID) ? 0 : Convert.ToInt32(InvoiceID)))
                {
                    Measur.ErrorCode = adminObj.GetLastErrorCode();
                    Measur.ErrorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                Measur.ErrorCode = -4;
                Measur.ErrorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return Measur;
        }

        [WebMethod]
        public static ItemMasterList GetItemList(string InvoiceID)
        {
            ItemMasterList returnObj = new ItemMasterList();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = 1001;
                    returnObj.ErrorMessage = "";
                    return returnObj;
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.GetItemMasterList(currentUser.CompanyID, currentUser.UserId, 0, out returnObj, string.IsNullOrEmpty(InvoiceID) ? 0 : Convert.ToInt32(InvoiceID)))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = -1;
                    returnObj.ErrorMessage = "Failed to get Item Details. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return returnObj;
        }

        [WebMethod]
        public static JsonResults GetAccountList()
        {
            JsonResults returnObj = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = 1001;
                    returnObj.ErrorMessage = "";
                    return returnObj;
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetAccountList(currentUser.CompanyID, currentUser.UserId, out returnObj))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = -1;
                    returnObj.ErrorMessage = "Failed to get Account List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return returnObj;
        }

        [WebMethod]
        public static JsonResults GetAccountInvoiceList(string AccountID)
        {
            JsonResults returnObj = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = 1001;
                    returnObj.ErrorMessage = "";
                    return returnObj;
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetAccountInvoiceList(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(AccountID)?0:Convert.ToInt32(AccountID),  out returnObj))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = -1;
                    returnObj.ErrorMessage = "Failed to get Account Invoice List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return returnObj;
        }

        [WebMethod]
        public static JsonResults GetEmployee()
        {
            JsonResults emplList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    emplList.ErrorCode = 1001;
                    emplList.ErrorMessage = "";
                    return emplList;
                }

                AdminManagerSP adminObj = new AdminManagerSP();
                if (adminObj.GetEmployeeList(currentUser.CompanyID, currentUser.UserId, true, out emplList))
                {
                    emplList.ErrorCode = 0;
                    emplList.ErrorMessage = "";
                }
                else
                {
                    emplList.ErrorCode = 1;
                    emplList.ErrorMessage = "Failed to get Employee List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return emplList;
        }

        [WebMethod]
        public static JsonResults GetCompanyInfo()
        {
            JsonResults Measur = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    Measur.ErrorCode = 1001;
                    Measur.ErrorMessage = "";
                    return Measur;
                }

                CustomerManager adminObj = new CustomerManager();
                if (!adminObj.GetCompanyHeaderInfo(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, out Measur))
                {
                    Measur.ErrorCode = adminObj.GetLastErrorCode();
                    Measur.ErrorMessage = adminObj.GetLastError();
                }

            }
            catch (Exception ex)
            {
                Measur.ErrorCode = -4;
                Measur.ErrorMessage = "Unknown Error Occured";
                Utils.Write(ex);
            }

            return Measur;
        }


    }
}