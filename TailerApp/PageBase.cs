using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using TailerApp.Common;

namespace TailerApp
{
    public class PageBase : System.Web.UI.Page
    {
        public LoginUser CURRENT_USER
        {
            get { 
              if(HttpContext.Current!=null && HttpContext.Current.Session!=null && HttpContext.Current.Session["LoginUser"]!=null)
              {
                  return HttpContext.Current.Session["LoginUser"] as LoginUser;
              }
              else
              {
                  return null;
              }
            }
        }

        public static bool GetUserSession(out LoginUser currentUser)
        {
            bool ret = false;
            currentUser = null;
            try
            {
                if (HttpContext.Current != null && HttpContext.Current.Session != null && HttpContext.Current.Session["LoginUser"] != null)
                {
                    currentUser=HttpContext.Current.Session["LoginUser"] as LoginUser;
                    ret = true;
                }
                else
                {
                    ret = false;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                Utils.Write(ex);
            }
            return ret;
        }
    }
}