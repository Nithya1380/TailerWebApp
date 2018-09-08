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
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public CustomerPickLists GetCustomerPickLists(string customerID)
        {
            CustomerPickLists customerMasterPickLists = new CustomerPickLists();
            try
            {
                if(this.CURRENT_USER==null)
                {
                    customerMasterPickLists.ErrorCode = -1001;
                    customerMasterPickLists.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetCustomerPickLists(this.CURRENT_USER.CompanyID, string.IsNullOrEmpty(customerID) ? 0 : Convert.ToInt32(customerID), this.CURRENT_USER.UserId,
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
    }
}