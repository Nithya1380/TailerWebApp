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
    public partial class MeasurementList : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JsonResults GetMeasurementList(string AccountCode, string AccountName, string DeliveryFrom, string DeliveryTo)
        {
            JsonResults MeasurList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    MeasurList.ErrorCode = 1001;
                    MeasurList.ErrorMessage = "";
                    return MeasurList;
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetMeasurementList(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, AccountCode, AccountName, DeliveryFrom, DeliveryTo, out MeasurList))
                {
                    MeasurList.ErrorCode = 0;
                    MeasurList.ErrorMessage = "";
                }
                else
                {
                    MeasurList.ErrorCode = -1;
                    MeasurList.ErrorMessage = "Failed to get Employee List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }
            return MeasurList;
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