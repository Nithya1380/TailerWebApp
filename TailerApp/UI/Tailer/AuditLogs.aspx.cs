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
    public partial class AuditLogs : PageBase
    {
        public string ActivityType = "";
        public int ActivitID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("ActivityType")))
                ActivityType = Convert.ToString(this.GetDecryptedQueryString("ActivityType"));

            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("ActivitID")))
                ActivitID = Convert.ToInt32(this.GetDecryptedQueryString("ActivitID"));
        }

        [WebMethod]
        public static JsonResults GetAuditLogs(string ActivityType, string ActivitID)
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
                if (customerObj.GetAuditLogs(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, ActivityType, string.IsNullOrEmpty(ActivitID) ? 0 : Convert.ToInt32(ActivitID), out SeriesList))
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
    }
}