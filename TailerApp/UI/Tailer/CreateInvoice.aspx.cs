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
                    custList.ErrorMessage = "Failed to get Customer List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return custList;
        }
    }
}