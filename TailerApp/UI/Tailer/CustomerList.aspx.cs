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
    public partial class CustomerList : PageBase
    {
        public int FromPage = 0;
        public string BirthDate = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString.Get("FromPage")))
                FromPage = Convert.ToInt32(Request.QueryString.Get("FromPage"));

            if (FromPage == 2)
            {
                BirthDate = DateTime.Now.ToString("dd/MM/yyyy").Replace('-', '/');
            }
        }

        [WebMethod]
        public static JsonResults GetCustomerList(string BirthDate)
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
                if (customerObj.GetCustomerList(currentUser.CompanyID, currentUser.UserId, BirthDate, out custList))
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