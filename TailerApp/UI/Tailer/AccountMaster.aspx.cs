using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;
using DAL.DBManager;

namespace TailerApp.UI.Tailer
{
    public partial class AccountMaster : PageBase
    {
        public int CustomerID { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!string.IsNullOrEmpty(Request.QueryString.Get("CustomerID")))
                    CustomerID = Convert.ToInt32(Request.QueryString.Get("CustomerID"));
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }
        }

        [WebMethod]
        public static CustomerPickLists GetCustomerPickLists(string customerID)
        {
            CustomerPickLists customerMasterPickLists = new CustomerPickLists();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    customerMasterPickLists.ErrorCode = -1001;
                    customerMasterPickLists.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetCustomerPickLists(currentUser.CompanyID, string.IsNullOrEmpty(customerID) ? 0 : Convert.ToInt32(customerID), currentUser.UserId,
                                                  out customerMasterPickLists))
                {
                    customerMasterPickLists.ErrorCode = 0;
                    customerMasterPickLists.ErrorMessage = "";
                }
                else
                {
                    customerMasterPickLists.ErrorCode = -1;
                    customerMasterPickLists.ErrorMessage = "Failed to get dropdowns. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return customerMasterPickLists;
        }

        [WebMethod]
        public static CustomerMaster GetCustomerDetails(string customerID)
        {
            CustomerMaster CustomerDetails = new CustomerMaster();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    CustomerDetails.ErrorCode = -1001;
                    CustomerDetails.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetCustomerDetails(currentUser.CompanyID, string.IsNullOrEmpty(customerID) ? 0 : Convert.ToInt32(customerID), currentUser.UserId,
                                                  out CustomerDetails))
                {
                    CustomerDetails.ErrorCode = 0;
                    CustomerDetails.ErrorMessage = "";
                }
                else
                {
                    CustomerDetails.ErrorCode = customerObj.GetLastErrorCode();
                    CustomerDetails.ErrorMessage = customerObj.GetLastError();
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return CustomerDetails;
        }
    }
}