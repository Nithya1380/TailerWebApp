using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TailerApp
{
    public partial class SitePopUp : System.Web.UI.MasterPage
    {
        public string ApplicationVirtualPath = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            ApplicationVirtualPath = TailerApp.Common.Utils.ApplicationVirtualPath;
        }
    }
}