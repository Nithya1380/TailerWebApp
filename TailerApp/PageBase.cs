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

        protected string GetDecryptedQueryString(string queryString)
        {
            string rowUrl = null;
            string queryStringVal = null;
            try
            {
                if (HttpContext.Current.Request.Url.ToString().Contains('?'))
                {
                    rowUrl = HttpContext.Current.Request.Url.ToString().Split('?')[1];
                    string[] actualQueryStrings = TailerApp.Common.Cryptography.Decrypt(rowUrl.Substring(rowUrl.IndexOf('?') + 1)).Split(new char[] { '&' });
                    if (actualQueryStrings != null && actualQueryStrings.Length > 0)
                    {
                        var objQuery = actualQueryStrings.Where(str => str.StartsWith(queryString + "="));
                        var queryString_EqualsCount = 0;
                        if (objQuery.Count() > 0)
                        {
                            queryStringVal = objQuery.First().Split('=')[1];

                            queryString_EqualsCount = objQuery.First().Count(X => X == '=');
                        }

                        if (queryString_EqualsCount >= 2)
                        {
                            int firstEqualIndex = objQuery.First().IndexOf('=');
                            queryStringVal = objQuery.First().Substring(firstEqualIndex + 1);
                        }

                    }
                }
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return queryStringVal;
        }
    }
}