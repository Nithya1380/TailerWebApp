using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TailerApp.UI.Tailer
{
    public partial class PrintMeasurement : PageBase
    {
        public int MeasurementID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(this.GetDecryptedQueryString("MeasurementID")))
                MeasurementID = Convert.ToInt32(this.GetDecryptedQueryString("MeasurementID"));
        }
    }
}