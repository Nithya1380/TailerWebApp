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
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
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
                    sbHtml.Append("<div class=\"col-lg-12 col-md-12 col-sm-12\">");
                    sbHtml.Append("<div class=\"card\">");
                    sbHtml.Append("<div class=\"row\">");
                    sbHtml.Append("<table class=\"table\">");
                    sbHtml.Append("<thead><tr><th colspan=\"2\">Select Branch To Continue</th></tr></thead>");
                    sbHtml.Append("<tbody>");

                    foreach (BranchDetail item in userBranchList)
                    {
                        sbHtml.Append("<tr>");
                        sbHtml.Append("<td>");
                        sbHtml.Append(item.BranchName);
                        sbHtml.Append("</td>");
                        sbHtml.Append("<td>");
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
    }
}