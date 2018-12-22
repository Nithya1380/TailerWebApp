using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;

namespace TailerApp
{
    public partial class SiteMaster : MasterPage
    {
        public string ApplicationVirtualPath = string.Empty;
        public LoginUser CURRENT_USER
        {
            get
            {
                if (HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session["LoginUser"] != null)
                {
                    return HttpContext.Current.Session["LoginUser"] as LoginUser;
                }
                else
                {
                    Response.Redirect("/UI/Common/Login.aspx");
                    return null;
                }
            }
        } 
        protected void Page_Load(object sender, EventArgs e)
        {
            ApplicationVirtualPath = Utils.ApplicationVirtualPath;
            
        }
    }
}