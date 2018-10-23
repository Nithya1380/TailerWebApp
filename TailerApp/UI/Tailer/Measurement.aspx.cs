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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("MeasurementID")))
                MeasurementID = Convert.ToInt32(this.GetDecryptedQueryString("MeasurementID"));
        }

        [WebMethod]
        public static JsonResults SaveMeasurementMaster(string MeasurMasterID, string MeasurDetails)
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
                if (!adminObj.SaveMeasurementMaster(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(MeasurMasterID) ? 0 : Convert.ToInt32(MeasurMasterID), MeasurDetails, out Measur))
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
        public static JsonResults GetMeasurementMaster(string MeasurMasterID)
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
                if (!adminObj.GetMeasurementMaster(currentUser.CompanyID, currentUser.UserId, string.IsNullOrEmpty(MeasurMasterID) ? 0 : Convert.ToInt32(MeasurMasterID), out Measur))
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
        public static ItemMasterList GetItemList()
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
                if (customerObj.GetItemMasterList(currentUser.CompanyID, currentUser.UserId, 0, out returnObj))
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

    }
}