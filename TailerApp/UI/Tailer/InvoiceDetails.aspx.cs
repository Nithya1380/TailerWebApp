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
    public partial class InvoiceDetails : PageBase
    {
        public int InvoiceID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString.Get("InvoiceID")))
                InvoiceID = Convert.ToInt32(Request.QueryString.Get("InvoiceID"));
        }

        [WebMethod]
        public static JsonResults GetInvoiceDetails(int invoiceID)
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
                if (customerObj.GetInvoiceDetails(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID,invoiceID, out invoiceList))
                {
                    invoiceList.ErrorCode = 0;
                    invoiceList.ErrorMessage = "";
                }
                else
                {
                    invoiceList.ErrorCode = -1;
                    invoiceList.ErrorMessage = "Failed to get Invoice Details. please try again later";
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