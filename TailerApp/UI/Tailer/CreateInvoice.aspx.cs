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
    public partial class CreateInvoice : PageBase
    {
        public int CustomerID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString.Get("CustomerID")))
                CustomerID = Convert.ToInt32(Request.QueryString.Get("CustomerID"));
        }

        [WebMethod]
        public static JsonResults SearchCustomers(string searchText)
        {
            JsonResults custList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    custList.ErrorCode = -1001;
                    custList.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.SearchCustomers(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, searchText, out custList))
                {
                    custList.ErrorCode = 0;
                    custList.ErrorMessage = "";
                }
                else
                {
                    custList.ErrorCode = -1;
                    custList.ErrorMessage = "Failed to get Customer List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return custList;
        }

        [WebMethod]
        public static JsonResults SearchItems(string searchText)
        {
            JsonResults custList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    custList.ErrorCode = -1001;
                    custList.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.SearchItems(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, searchText, out custList))
                {
                    custList.ErrorCode = 0;
                    custList.ErrorMessage = "";
                }
                else
                {
                    custList.ErrorCode = -1;
                    custList.ErrorMessage = "Failed to get Items List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return custList;
        }

        [WebMethod]
        public static InvoicePickLists GetInvoicePickLists(string customerID)
        {
            InvoicePickLists invoicePickLists = new InvoicePickLists();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    invoicePickLists.ErrorCode = -1001;
                    invoicePickLists.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetInvoicePickLists(currentUser.CompanyID, string.IsNullOrEmpty(customerID) ? 0 : Convert.ToInt32(customerID), currentUser.UserId,
                                                  out invoicePickLists))
                {
                    invoicePickLists.ErrorCode = 0;
                    invoicePickLists.ErrorMessage = "";
                }
                else
                {
                    invoicePickLists.ErrorCode = -1;
                    invoicePickLists.ErrorMessage = "Failed to get dropdowns. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return invoicePickLists;
        }

        [WebMethod]
        public static JsonResults CreateNewInvoice(CustomerInvoice customerInvoice, List<CustomerInvoiceList> InvoiceList)
        {
            JsonResults returnObj = new JsonResults();
            LoginUser currentUser;
            string billNumber = "";
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = -1001;
                    returnObj.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.CreateNewInvoice(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, ref customerInvoice, ref InvoiceList, out billNumber))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";


                    returnObj.JSonstring = billNumber;
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

        [WebMethod]
        public static JsonResults GetLatestSeriesMaster()
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
                if (customerObj.GetLatestSeriesMaster(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, out returnObj))
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