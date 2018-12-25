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
        public int FromPage = 0;
        public string InvoiceDateFrom = string.Empty;
        public string InvoiceDateTo = string.Empty;
        public string DeleveryDate = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (!string.IsNullOrEmpty(Request.QueryString.Get("FromPage")))
                FromPage = Convert.ToInt32(Request.QueryString.Get("FromPage"));

            InvoiceDateFrom = DateTime.Now.AddMonths(-1).ToString("dd/MM/yyyy").Replace('-', '/');
            InvoiceDateTo = DateTime.Now.ToString("dd/MM/yyyy").Replace('-', '/');

            if(FromPage==2)
            {
                InvoiceDateFrom = DateTime.Now.AddMonths(-1).ToString("dd/MM/yyyy").Replace('-', '/');
                InvoiceDateTo = DateTime.Now.ToString("dd/MM/yyyy").Replace('-', '/');
            }
            else if(FromPage==3)
            {
                DeleveryDate = DateTime.Now.ToString("dd/MM/yyyy").Replace('-', '/');
            }
        }

        [WebMethod]
        public static JsonResults GetInvoiceList(string invoiceDateFrom,string invoiceDateTo,string deleveryDate)
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
                if (customerObj.GetInvoiceList(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID,invoiceDateFrom,invoiceDateTo,deleveryDate, out invoiceList))
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

        [WebMethod]
        public static JsonResults DeleteInvoice(string invoiceIds)
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
                if (customerObj.DeleteInvoices(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, invoiceIds))
                {
                    invoiceList.ErrorCode = 0;
                    invoiceList.ErrorMessage = "";
                }
                else
                {
                    invoiceList.ErrorCode = -1;
                    invoiceList.ErrorMessage = "Failed to delete Invoice(s). please try again later";
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