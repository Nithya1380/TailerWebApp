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
        public static JsonResults GetMeasurementList()
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
                if (customerObj.GetMeasurementList(currentUser.CompanyID, currentUser.UserId, out MeasurList))
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
    }
}