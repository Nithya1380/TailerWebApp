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
    public partial class MeasurementField : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JsonResults SaveMeasurementField(string MeasurField)
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
                if (!adminObj.SaveMeasurementField(currentUser.CompanyID, currentUser.UserId, MeasurField))
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
        public static JsonResults GetMeasurementField()
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
                if (!adminObj.GetMeasurementField(currentUser.CompanyID, currentUser.UserId, out Measur))
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
        public static JsonResults GetItemGroups()
        {
            JsonResults returnObj = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = 1001;
                    returnObj.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.GetPickLists(currentUser.CompanyID, currentUser.UserId, "ItemMasterGroup", out returnObj))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = customerObj.GetLastErrorCode();
                    returnObj.ErrorMessage = customerObj.GetLastError();
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