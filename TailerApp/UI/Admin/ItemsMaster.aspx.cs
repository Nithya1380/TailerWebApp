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

namespace TailerApp.UI.Admin
{
    public partial class ItemsMaster : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static ItemMasterList GetItemsList()
        {
            ItemMasterList returnObj = new ItemMasterList();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = -1001;
                    returnObj.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.GetItemMasterList(currentUser.CompanyID, currentUser.UserId,0, out returnObj))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = -1;
                    returnObj.ErrorMessage = "Failed to get Items List. please try again later";
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