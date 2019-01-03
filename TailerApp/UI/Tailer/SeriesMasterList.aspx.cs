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
    public partial class SeriesMasterList : PageBase
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        [WebMethod]
        public static JsonResults GetSeriesMaster(int SeriesMasterID)
        {
            JsonResults SeriesList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    SeriesList.ErrorCode = 1001;
                    SeriesList.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.GetSeriesMaster(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, SeriesMasterID, out SeriesList))
                {
                    SeriesList.ErrorCode = 0;
                    SeriesList.ErrorMessage = "";
                }
                else
                {
                    SeriesList.ErrorCode = -1;
                    SeriesList.ErrorMessage = "Failed to get Series List. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return SeriesList;
        }
    }
}