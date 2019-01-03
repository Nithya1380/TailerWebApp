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
    public partial class AddEditSeriesMaster : PageBase
    {
        public int SeriesMasterID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("SeriesMasterID")))
                SeriesMasterID = Convert.ToInt32(this.GetDecryptedQueryString("SeriesMasterID"));
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
                    SeriesList.ErrorMessage = "Failed to get Series. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return SeriesList;
        }

        [WebMethod]
        public static JsonResults SaveSeriesMaster(string SeriesMasterID, string SeriesMaster)
        {
            JsonResults outobj = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    outobj.ErrorCode = 1001;
                    outobj.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.SaveSeriesMaster(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, string.IsNullOrEmpty(SeriesMasterID) ? 0 : Convert.ToInt32(SeriesMasterID), SeriesMaster, out outobj))
                {
                    outobj.ErrorCode = 0;
                    outobj.ErrorMessage = "";
                }
                else
                {
                    outobj.ErrorCode = -1;
                    outobj.ErrorMessage = "Failed to save Series. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return outobj;
        }
    }
}