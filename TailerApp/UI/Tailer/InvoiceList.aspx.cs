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
    public partial class InvoiceList : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JsonResults GetInvoiceList()
        {
            JsonResults invoiceList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    invoiceList.ErrorCode = -1001;
                    invoiceList.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetCustomerList(currentUser.CompanyID, currentUser.UserId, out invoiceList))
                {
                    invoiceList.ErrorCode = 0;
                    invoiceList.ErrorMessage = "";
                }
                else
                {
                    invoiceList.ErrorCode = -1;
                    invoiceList.ErrorMessage = "Failed to get Invoice List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return invoiceList;
        }
    }
}