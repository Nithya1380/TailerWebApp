using DAL.DBManager;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;

namespace TailerApp.UI.Tailer
{
    public partial class TailerHome : PageBase
    {
        public string ApplicationVirtualPath = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ApplicationVirtualPath = Utils.ApplicationVirtualPath;
                if (!IsPostBack)
                {
                    this.SelectUserBranch();

                }
            }
            catch(Exception ex)
            {
                Utils.Write(ex);
            }
        }

        private void SelectUserBranch()
        {
            List<BranchDetail> userBranchList=null;
            StringBuilder sbHtml = new StringBuilder();
            try
            {
                userBranchList = HttpContext.Current.Session["LoginUserBranchList"] as List<BranchDetail>;
                if(this.CURRENT_USER.UserBranchID==0 && userBranchList!=null && userBranchList.Count>1)
                {
                    sbHtml.Append("<div class=\"row BranchDiv\">");
                    sbHtml.Append("<div class=\"col-lg-6 col-md-6 col-sm-6\">");
                    sbHtml.Append("<div class=\"card\" style=\"width: 50%; position: fixed; overflow-y: scroll; max-height: 70%;\">");
                    sbHtml.Append("<div class=\"row\">");
                    sbHtml.Append("<table class=\"table\">");
                    sbHtml.Append("<thead><tr><th colspan=\"2\">Select Branch To Continue</th></tr></thead>");
                    sbHtml.Append("<tbody>");

                    foreach (BranchDetail item in userBranchList)
                    {
                        sbHtml.Append("<tr>");
                        sbHtml.Append("<td style=\"width: 85%;\">");
                        sbHtml.Append(item.BranchName);
                        sbHtml.Append("</td>");
                        sbHtml.Append("<td style=\"width: 15%;\">");
                        sbHtml.Append("<input type=\"button\" value=\"Select\" class=\"btn btn-lg btn-success\" data-ng-click=\"OnBranchSelection(" + item.BranchID + ")\" />");
                        sbHtml.Append("</td>");
                        sbHtml.Append("</tr>");
                    }

                    sbHtml.Append("</tbody>");
                    sbHtml.Append("</table>");
                    sbHtml.Append("</div>");
                    sbHtml.Append("</div></div></div>");

                    div_BranchSelection.InnerHtml = sbHtml.ToString();
                    div_BranchSelection.Style.Add(HtmlTextWriterStyle.Display, "block");
                    div_overLay.Style.Add(HtmlTextWriterStyle.Display, "block");
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }
        }

        [WebMethod]
        public static JsonResults SelectBranch(int branchID)
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

                if(branchID!=0)
                {
                    currentUser.UserBranchID = branchID;
                    HttpContext.Current.Session["LoginUser"] = currentUser;
                    custList.ErrorCode = 0;
                    custList.ErrorMessage = "";
                }
                else
                {
                    custList.ErrorCode = -1;
                    custList.ErrorMessage = "Invalid Branch Selection";
                }
                
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return custList;
        }

        [WebMethod]
        public static JsonResults GetDashboardDetails()
        {
            JsonResults dashboardDetails = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    dashboardDetails.ErrorCode = -1001;
                    dashboardDetails.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetDashboard(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID, out dashboardDetails))
                {
                    dashboardDetails.ErrorCode = 0;
                    dashboardDetails.ErrorMessage = "";
                }
                else
                {
                    dashboardDetails.ErrorCode = -1;
                    dashboardDetails.ErrorMessage = "Failed to get Dashboard details. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return dashboardDetails;
        }
    }
}