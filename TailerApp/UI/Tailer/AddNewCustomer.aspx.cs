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
    public partial class AddNewCustomer : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JsonResults AddNewCustomerToDB(Customer Customer)
        {
            JsonResults returnObj = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = -1001;
                    returnObj.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.AddNewCustomer(currentUser.CompanyID, currentUser.UserId, ref Customer))
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