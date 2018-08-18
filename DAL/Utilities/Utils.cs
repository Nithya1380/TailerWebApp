using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace DAL.Utilities
{
    public static class Utils
    {
       
        public static DataTable LinqQueryToDataTable<T>(IEnumerable<T> linqQuery)
        {
            DataTable Dt = null;
            Type ObjType = null;
            PropertyInfo[] PropInfo = null;
            try
            {
                Dt = new DataTable();
                ObjType = typeof(T);
                PropInfo = ObjType.GetProperties();
                if (PropInfo != null)
                {
                    foreach (PropertyInfo pi in PropInfo)
                    {
                        Type pt = pi.PropertyType;
                        //if the incoming datatype is nulll then we need to get the Underlying is datatype
                        //This occures if the filed is a nullable type.
                        if (pt.IsGenericType && pt.GetGenericTypeDefinition() == typeof(Nullable<>))
                            pt = Nullable.GetUnderlyingType(pt);
                        Dt.Columns.Add(pi.Name, pt);
                    }
                }

                if (linqQuery != null)
                {
                    foreach (T item in linqQuery)
                    {
                        DataRow Drw = Dt.NewRow();
                        Drw.BeginEdit();
                        foreach (PropertyInfo pi in PropInfo)
                        {
                            if (pi != null)
                            {
                                object objval = pi.GetValue(item, null);
                                Drw[pi.Name] = (objval == null ? DBNull.Value : objval);
                            }
                        }
                        Drw.EndEdit();
                        Dt.Rows.Add(Drw);
                    }
                }
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils","LinqQueryToDataTable", "", "", ee);
            }

            return Dt;
        }

    
      
        public static DataTable LinqQueryToDataTable<T>(T linqQuery)
        {
            DataTable Dt = null;
            Type ObjType = null;
            PropertyInfo[] PropInfo = null;
            try
            {
                Dt = new DataTable();
                ObjType = typeof(T);
                PropInfo = ObjType.GetProperties();
                foreach (PropertyInfo pi in PropInfo)
                {
                    Type pt = pi.PropertyType;
                    //if the incoming datatype is nulll then we need to get the Underlying is datatype
                    //This occures if the filed is a nullable type.
                    if (pt.IsGenericType && pt.GetGenericTypeDefinition() == typeof(Nullable<>))
                        pt = Nullable.GetUnderlyingType(pt);
                    Dt.Columns.Add(pi.Name, pt);
                }

                DataRow Drw = Dt.NewRow();
                Drw.BeginEdit();
                foreach (PropertyInfo pi in PropInfo)
                {
                    object objval = pi.GetValue(linqQuery, null);
                    Drw[pi.Name] = (objval == null ? DBNull.Value : objval);
                }
                Drw.EndEdit();
                Dt.Rows.Add(Drw);
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils","LinqQueryToDataTable", "", "", ee);
            }

            return Dt;
        }
      
        public static void Write(Exception exp)
        {
            int writeLogToDataBase = 0;
            int userId = 0;
            int hhaID = 0;
            try
            {
                if (!String.IsNullOrEmpty(Utils.getConfigParam<string>("WriteLogToDatabase")))
                    writeLogToDataBase = Convert.ToInt32(Utils.getConfigParam<string>("WriteLogToDatabase"));

                if (writeLogToDataBase == 1)
                {
                    StackTrace st = new StackTrace(0, true);
                    StackFrame sf = new StackFrame();
                    sf = st.GetFrame(1);
                    System.IO.FileInfo fInfo = new FileInfo(sf.GetFileName());


                    WriteExceptionToDatabase(hhaID, userId, sf.GetMethod().Name, fInfo.Name, "", "", exp);

                }
                else
                {
                    StringBuilder strbuilder = new StringBuilder();
                    strbuilder.Append("************************************************************************************\t");
                    strbuilder.Append(string.Format("DATE: {0}", DateTime.Now.ToString("MMM, d yyyy HH:mm:ss")) + "\t");
                    strbuilder.Append(string.Format("Source: {0}", exp.Source) + "\t");
                    strbuilder.Append(string.Format("StackTrace: {0}", exp.StackTrace) + "\t");
                    strbuilder.Append(string.Format("Data: {0}", exp.Data) + "\t");

                    if (null != exp)
                    {
                        string _msg = strbuilder.ToString() + "\t" + "Message:" + exp.Message;
                        if (exp.InnerException != null)
                            _msg += " - Inner Exep :" + exp.InnerException.ToString();
                        Utils.Write(_msg);
                    }
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex.ToString());
            }
        }
      
        public static void Write(string str)
        {
            try
            {
                string fileToWrite = Utils.getConfigParam<string>("ExceptionLogFile");
                if (null != fileToWrite && fileToWrite != "")
                {
                    //Create the directory if it not exists.
                    string dir = fileToWrite.Substring(0, fileToWrite.LastIndexOf("\\"));
                    if (null != dir)
                    {
                        if (!System.IO.Directory.Exists(dir))
                            System.IO.Directory.CreateDirectory(dir);
                    }
                    StreamWriter sw = new StreamWriter(fileToWrite, true);
                    sw.WriteLine(str);
                    sw.Close();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static void Write(int hha, int user, string fileName, string functionName, string queryString, string clientIP, Exception ex)
        {
            string fileToWrite = string.Empty;
            string _msg = string.Empty;
            StreamWriter sw = null;
            int writeLogToDataBase = 0;
            try
            {
                if (!String.IsNullOrEmpty(Utils.getConfigParam<string>("WriteLogToDatabase")))
                    writeLogToDataBase = Convert.ToInt32(Utils.getConfigParam<string>("WriteLogToDatabase"));

                if (writeLogToDataBase == 1)
                {
                    WriteExceptionToDatabase(hha, user, functionName, fileName, queryString, clientIP, ex);
                }
                else
                {
                    fileToWrite = Utils.getConfigParam<string>("ExceptionLogFile");
                    if (null != ex)
                    {
                        _msg = DateTime.Now.ToString("MMM, d yyyy HH:mm:ss") + "\t" +
                            "hha: " + hha.ToString() + "\t" +
                            "user: " + user.ToString() + "\t" +
                            "fileName: " + fileName + "\t" +
                            "functionName: " + functionName + "\t" +
                            "queryString: " + queryString + "\t" +
                            "clientIP: " + clientIP + "\t" +
                            ex.Message;
                        if (ex.InnerException != null)
                            _msg += "\t - Inner Exep :" + ex.InnerException.ToString();
                    }
                    if (null != fileToWrite && fileToWrite != "")
                    {
                        //Create the directory if it not exists.
                        string dir = fileToWrite.Substring(0, fileToWrite.LastIndexOf("\\"));
                        if (null != dir)
                        {
                            if (!System.IO.Directory.Exists(dir))
                                System.IO.Directory.CreateDirectory(dir);
                        }
                        sw = new StreamWriter(fileToWrite, true);
                        sw.WriteLine(_msg);
                    }
                }
            }
            catch (Exception ee)
            {
                Utils.Write(ee.ToString());
            }
            finally
            {
                if (sw != null)
                {
                    sw.Close();
                    sw.Dispose();
                }
            }
        }
      
      
    
        public static T getConfigParam<T>(string configParam)
        {
            T objSession = default(T);
            object configObj = null;
            try
            {
                if (System.Configuration.ConfigurationManager.AppSettings.Get(configParam) != null)
                {
                    configObj = (object)System.Configuration.ConfigurationManager.AppSettings.Get(configParam);
                    if ((System.Type)configObj.GetType() == typeof(T))
                        objSession = (T)(object)System.Configuration.ConfigurationManager.AppSettings.Get(configParam);
                }
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils","getConfigParam", "", "", ee);
            }
            return objSession;
        }
     

        public static string GetMoneyFormatted(object moneyfield)
        {

            string moneystr = null;
            try
            {
                if (Convert.ToInt32(moneyfield) != 0)
                {
                    moneystr = String.Format("{0:0.00}", moneyfield);
                }
                else
                {
                    moneystr = "";
                }
            }
            catch (Exception ee)
            {

                Utils.Write(0, 0, "Utils", "GetMoneyFormatted", "", "", ee);
            }
            return moneystr;
        }


       
        public static DataTable GetDataTable<T>(this IEnumerable<T> linqQuery)
        {
            DataTable Dt = null;
            Type ObjType = null;
            PropertyInfo[] PropInfo = null;
            try
            {
                Dt = new DataTable();
                ObjType = typeof(T);
                PropInfo = ObjType.GetProperties();
                if (PropInfo != null)
                    foreach (PropertyInfo pi in PropInfo)
                    {
                        Type pt = pi.PropertyType;
                        //if the incoming datatype is nulll then we need to get the Underlying is datatype
                        //This occures if the filed is a nullable type.
                        if (pt.IsGenericType && pt.GetGenericTypeDefinition() == typeof(Nullable<>))
                            pt = Nullable.GetUnderlyingType(pt);
                        Dt.Columns.Add(pi.Name, pt);
                    }

                if (linqQuery != null)
                    foreach (T item in linqQuery)
                    {
                        DataRow Drw = Dt.NewRow();
                        Drw.BeginEdit();
                        if (PropInfo != null)
                            foreach (PropertyInfo pi in PropInfo)
                            {
                                try
                                {
                                    object objval = pi.GetValue(item, null);
                                    Drw[pi.Name] = (objval == null ? DBNull.Value : objval);
                                }
                                catch (Exception ee)
                                {
                                    Utils.Write(ee);
                                }
                            }
                        Drw.EndEdit();
                        Dt.Rows.Add(Drw);
                    }
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils", "GetDataTable", "", "", ee);
            }
            return Dt;
        }
       
        public static string GetCSVFormat(string str)
        {
            try
            {
                str = str.Replace(",", "").Replace("\r\n", ". ").Replace("\"", "'").Trim();
                str = Regex.Replace(str, @"\s{2,}", " ");
                str = Regex.Replace(str, @"\s{3,}", " ");
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils", "GetCSVFormat", "", "", ee);
            }
            return str + ','.ToString().Trim();
        }

        
        public static string GetCSVFormat2(string str)
        {
            try
            {
                str = str.Replace(",", "").Replace("\r\n", ". ").Trim();
                str = Regex.Replace(str, @"\s{2,}", " ");
                str = Regex.Replace(str, @"\s{3,}", " ");
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils", "GetCSVFormat", "", "", ee);
            }
            return str + ','.ToString().Trim();
        }


      
        public static string GetOrdersCSVFormat(string str)
        {
            try
            {
                str = str.Replace(",", "").Replace("\r\n", ". ").Replace("\n", ". ").Replace("\"", "'").Trim();
                str = Regex.Replace(str, @"\s{2,}", " ");
                str = Regex.Replace(str, @"\s{3,}", " ");
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils", "GetCSVFormat", "","", ee);
            }
            return str + ','.ToString().Trim();
        }

     
        public static string GetCSVFormatWithComma(string str)
        {
            try
            {
                str = str.Replace("\r\n", ". ").Replace("\"", "'").Trim();
                str = Regex.Replace(str, @"\s{2,}", " ");
                str = Regex.Replace(str, @"\s{3,}", " ");
                str = '"' + str + '"';
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "Utils", "GetCSVFormat", "", "", ee);
            }
            return str + ','.ToString().Trim();
        }

     
        public static string FormatMoney(string moneyString, short NumbersofDigitsafterDecimal = 0)
        {
            try
            {
                if (!String.IsNullOrEmpty(moneyString))
                {
                    if (moneyString.Contains("**"))
                        return moneyString;

                    CultureInfo moneyCultureInfo = new CultureInfo("en-us");

                    string C = "C";
                    if (NumbersofDigitsafterDecimal > 0)
                        C += NumbersofDigitsafterDecimal.ToString();

                    string OutStr = Convert.ToDouble(moneyString).ToString(C, moneyCultureInfo);
                    //if (NumbersofDigitsafterDecimal > 2)
                    //{
                    //    string pattern = "[0]+";
                    //    Regex rg = new Regex(pattern);
                    //    OutStr = rg.Replace(OutStr, "", 1, OutStr.IndexOf('.') + 3);
                    //}

                    if (NumbersofDigitsafterDecimal > 2)
                        if (OutStr.IndexOf('0', OutStr.Length - 1) == OutStr.Length - 1)
                            OutStr = OutStr.Substring(0, OutStr.Length - 1);

                    if (NumbersofDigitsafterDecimal > 3)
                        if (OutStr.IndexOf('0', OutStr.Length - 1) == OutStr.Length - 1)
                            OutStr = OutStr.Substring(0, OutStr.Length - 1);

                    return OutStr;

                }
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "From Uitls.cs & Para : " + moneyString, "FormatMoney", "", "", ee);
                throw (ee);
            }

            return moneyString;
        }

  

        public static void WriteExceptionToDatabase(int hha, int userID, string functionName, string fileName, string queryString, string clientIP, Exception ex)
        {
            try
            {

                string exception = ex.ToString();
                string hostName = "";
                if (Utils.getConfigParam<string>("InstanceName") != null)
                    hostName = Utils.getConfigParam<string>("InstanceName").ToString();

                //if (String.IsNullOrEmpty(fileName))
                //{
                //    System.IO.FileInfo fInfo = new FileInfo(HttpContext.Current.Request.PhysicalPath);
                //    fileName = fInfo.Name; //HttpContext.Current.Request.FilePath;
                //}
                //if (String.IsNullOrEmpty(clientIP))
                //    clientIP = HttpContext.Current.Request.UserHostAddress.ToString();
                if (exception.Length > 2000)
                    exception = exception.Substring(0, 2000);
                if (queryString.Length > 2000)
                    queryString = queryString.Substring(0, 2000);

                //SetUpManager_SP managerObj = new SetUpManager_SP();
                //bool ret = managerObj.AddWebException(hha, userID, fileName, functionName, queryString, clientIP, hostName, exception);
                //if (!ret)
                //{

                //    Write(DateTime.Now.ToString() + " Failed to log exception to WebLog\n" + ex.ToString());
                //}
            }
            catch (Exception excep)
            {
                Write(DateTime.Now.ToString() + " Failed to log exception to WebLog\n" + excep.ToString());
            }
        }


      
        public static double FormatMoneyNew(string moneyString, short NumbersofDigitsafterDecimal = 0)
        {
            try
            {
                CultureInfo moneyCultureInfo = new CultureInfo("en-us");
                string C = "C";
                if (!String.IsNullOrEmpty(moneyString))
                {

                    if (NumbersofDigitsafterDecimal > 0)
                        C += NumbersofDigitsafterDecimal.ToString();

                    string OutStr = Convert.ToDouble(moneyString).ToString();
                    if (NumbersofDigitsafterDecimal > 2)
                    {
                        string pattern = "[0]+";
                        Regex rg = new Regex(pattern);
                        OutStr = rg.Replace(OutStr, "", 1, OutStr.IndexOf('.') + 3);
                    }

                    if (NumbersofDigitsafterDecimal > 2)
                        if (OutStr.IndexOf('0', OutStr.Length - 1) == OutStr.Length - 1)
                            OutStr = OutStr.Substring(0, OutStr.Length - 1);

                    if (NumbersofDigitsafterDecimal > 3)
                        if (OutStr.IndexOf('0', OutStr.Length - 1) == OutStr.Length - 1)
                            OutStr = OutStr.Substring(0, OutStr.Length - 1);

                    double retval = Convert.ToDouble(string.Format("{0:C}", OutStr));
                    return retval;

                }
            }
            catch (Exception ee)
            {
                Utils.Write(0, 0, "From Utls.cs & Para : " + moneyString, "FormatMoneyNew", "", "", ee);
                throw (ee);
            }

            return Convert.ToDouble(moneyString);
        }


     

    }
}
