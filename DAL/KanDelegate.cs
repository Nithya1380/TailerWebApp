using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL
{
    public class KanDelegate : KanDB
    {
        public string webConnstring = "";
        public KanDelegate()
        {
            //this.SetConnString(System.Configuration.ConfigurationManager.ConnectionStrings["ZephyrLiveConnectionString"].ToString());
            webConnstring = ConfigurationManager.ConnectionStrings["AppConnectionString"].ToString();

            this.SetConnString(webConnstring);
        }
    }
}
