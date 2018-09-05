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
        protected void Page_Load(object sender, EventArgs e)
        {
            ApplicationVirtualPath = Utils.ApplicationVirtualPath;
        }
    }
}