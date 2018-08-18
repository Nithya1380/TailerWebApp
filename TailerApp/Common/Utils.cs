using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Reflection;
using System.Text;
using System.Web;

namespace TailerApp.Common
{
    public static class Utils
    {

        public static DayOfWeek GetDayOfWeek(int dayNo)
        {
            DayOfWeek dayOfWeek = DayOfWeek.Sunday;
            DayOfWeek[] daysOfWeek = { DayOfWeek.Sunday, DayOfWeek.Monday, DayOfWeek.Tuesday, DayOfWeek.Wednesday, DayOfWeek.Thursday, DayOfWeek.Friday, DayOfWeek.Saturday };
            try
            {
                if (dayNo > 0)
                    dayOfWeek = daysOfWeek[dayNo - 1];
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return dayOfWeek;
        }

       
        public static int GetWeekNumber(DateTime dtPassed, DayOfWeek dayOfWeek)
        {
            CultureInfo ciCurr = CultureInfo.CurrentCulture;
            int weekNum = ciCurr.Calendar.GetWeekOfYear(dtPassed, CalendarWeekRule.FirstFourDayWeek, dayOfWeek);
            return weekNum;
        }

      
        public static int GetWeekNumberOfYear(DateTime dtPassed, int weekStart)
        {
            CultureInfo ciCurr = CultureInfo.CurrentCulture;

            DayOfWeek[] dayOfWeek = { DayOfWeek.Sunday, DayOfWeek.Monday, DayOfWeek.Tuesday, DayOfWeek.Wednesday, DayOfWeek.Thursday, DayOfWeek.Friday, DayOfWeek.Saturday };

            int weekNum = ciCurr.Calendar.GetWeekOfYear(dtPassed, CalendarWeekRule.FirstFourDayWeek, dayOfWeek[weekStart - 1]);
            return weekNum;
        }


        public static void GetPhoneParts(string phone, ref string code, ref string localNumber)
        {
            /*
             * extract Phone Number = Phone Code + Number           
             * */
            code = "";
            localNumber = "";
            if (phone == null)
                return;
            phone = phone.Trim();
            if (phone == "" || phone.Length < 13)
                return;
            try
            {
                code = phone.Substring(1, 3);
                localNumber = phone.Substring(6, 8);
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }

    
        public static string ApplicationVirtualPath
        {
            get
            {
                string UrlScheme = null;
                UrlScheme = System.Web.HttpContext.Current.Request.Url.Scheme;
                string AppName = null;
                AppName = Utils.GetConfigParam<string>("ApplicationName");
                if (String.IsNullOrEmpty(AppName))
                    AppName = System.Web.HttpContext.Current.Request.Url.Authority.ToString();
                else
                    AppName = System.Web.HttpContext.Current.Request.Url.Authority.ToString() + "/" + AppName;
                return String.Format("{0}://{1}", UrlScheme, AppName);
            }
        }
      
        public static string GetFormattedName(string firstName, string lastName, string middleName, string suffix)
        {
            string name = "";
            try
            {
                name = lastName + ", " + firstName + " " + suffix;
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return name;
        }


      
        public static void Log(int TimeCount, string PageName)
        {
            try
            {
                if (0 != TimeCount)
                {
                    TimeSpan TimeInSeconds = TimeSpan.FromSeconds(TimeCount);
                    if (TimeCount.ToString() != null)
                    {
                        Utils.Log(PageName + " " + TimeInSeconds.ToString());
                    }
                }
            }
            catch (Exception ee)
            {

                Utils.Write(ee);
            }
        }

    
        public static void Log(string str)
        {
            try
            {
                string fileToWrite = Utils.GetConfigParam<string>("LogFileName");
                string userLogFileName = string.Empty;
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
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }


      
        public static void Write(Exception exp)
        {
            int writeLogToDataBase = 0;
            try
            {

                if (!String.IsNullOrEmpty(Utils.GetConfigParam<string>("WriteLogToDataBase")))
                    writeLogToDataBase = Convert.ToInt32(Utils.GetConfigParam<string>("WriteLogToDataBase"));

                if (writeLogToDataBase == 1)
                {
                    StackTrace st = new StackTrace(0, true);
                    StackFrame sf = new StackFrame();
                    string fileName = string.Empty;
                    string methodname = string.Empty;

                    if (st != null && st.FrameCount > 1)
                    {
                        sf = st.GetFrame(1);
                        if (sf != null && !string.IsNullOrEmpty(sf.GetFileName()))
                        {
                            System.IO.FileInfo fInfo = new FileInfo(sf.GetFileName());

                            MethodBase mBase = sf.GetMethod();

                            if (mBase != null)
                                methodname = mBase.Name;

                            if (fInfo != null && !string.IsNullOrEmpty(fInfo.Name))
                                fileName = fInfo.Name;
                        }
                    }

                    WriteExceptionToDatabase(0, 0, methodname, fileName, "", "", exp);
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
            catch (Exception ee)
            {

                Utils.Write(ee.ToString());
            }
        }
      
        public static void Write(string str)
        {
            try
            {
                string fileToWrite = Utils.GetConfigParam<string>("exceptionLogfileParamName");
                string userLogFileName = string.Empty;
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
                    sw.WriteLine(DateTime.Now.ToString("MMM, d yyyy HH:mm:ss") + "\t" + str);
                    sw.Close();
                }
            }
            catch (Exception)
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
                if (!String.IsNullOrEmpty(Utils.GetConfigParam<string>("writeLogToDataBase")))
                    writeLogToDataBase = Convert.ToInt32(Utils.GetConfigParam<string>("writeLogToDataBase"));

                if (writeLogToDataBase == 1)
                {
                    WriteExceptionToDatabase(hha, user, functionName, fileName, queryString, clientIP, ex);
                }
                else
                {
                    fileToWrite = Utils.GetConfigParam<string>("exceptionLogfileParamName");
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
      
        public static T GetConfigParam<T>(string configParam)
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
                Utils.Write(ee);
            }
            return objSession;
        }
        public static string GetCustomError(int id)
        {
            //read the Messages.xml file and return the message.
            return "eror";
        }
       
        public static void ShowMessage(System.Web.UI.HtmlControls.HtmlTableCell cell, string msg)
        {
            if (cell != null && msg != null)
                cell.InnerHtml = msg;
        }

        public static void ShowMessage(System.Web.UI.HtmlControls.HtmlTableCell cell, string msg, bool isSuccess)
        {
            if (cell != null && msg != null)
            {
                cell.Attributes.Add("class", (isSuccess ? "Success" : "Failed"));
                ShowMessage(cell, msg);
            }
        }

     
        public static void ShowMessage(System.Web.UI.HtmlControls.HtmlTableCell cell, string msg, string style)
        {
            if (cell != null && msg != null)
            {
                cell.Attributes.Add("class", style);
                ShowMessage(cell, msg);
            }
        }
      

       
        public static void ShowPage(string pageUrl)
        {
            //TODO: Need to implement the back funcationality here , store the page urls in a hash table.
            HttpContext.Current.Response.Redirect(Utils.ApplicationVirtualPath + (!pageUrl.StartsWith("/") ? "/" : "") + pageUrl, false);
        }

      
        public static System.Drawing.Image GetResizedImage(string orginalImageFileName, string newImageFileName, int newWidth, int maxHeight)
        {
            System.Drawing.Image FullsizeImage = System.Drawing.Image.FromFile(orginalImageFileName);
            FullsizeImage.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
            FullsizeImage.RotateFlip(System.Drawing.RotateFlipType.Rotate180FlipNone);
            int NewHeight = FullsizeImage.Height * newWidth / FullsizeImage.Width;
            if (NewHeight > maxHeight)
            {
                newWidth = FullsizeImage.Width * maxHeight / FullsizeImage.Height;
                NewHeight = maxHeight;
            }
            System.Drawing.Image NewImage = FullsizeImage.GetThumbnailImage(newWidth, NewHeight, null, IntPtr.Zero);
            FullsizeImage.Dispose();
            //NewImage.Save(newImageFileName);
            return NewImage;
        }
       
        public static string GetMoneyFormat(object moneyfield)
        {
            string moneystr = null;
            try
            {
                moneystr = String.Format("{0:0.00}", moneyfield);
            }
            catch (Exception)
            {
                throw;
            }
            return moneystr;
        }

       
        public static void GetResizedImage(string sourceImageFileName, string desImageFileName, int desImageheight, int desImageWidth, bool isSized)
        {
            try
            {
                Decimal currentHeight = 0;
                Decimal currentWidth = 0;
                Decimal thumbnailHeight = desImageheight;
                Decimal thumbnailWidth = desImageWidth;
                System.Drawing.Bitmap sourceImage = new System.Drawing.Bitmap(sourceImageFileName);
                if (!isSized)
                {
                    if (sourceImage.Width < desImageWidth && sourceImage.Height < desImageheight)
                    {
                        System.IO.File.Copy(sourceImageFileName, desImageFileName);
                        sourceImage.Dispose();
                        return;
                    }
                    if (sourceImage.Width > sourceImage.Height)
                    {
                        currentWidth = thumbnailWidth;
                        currentHeight = Convert.ToDecimal(sourceImage.Height) * Convert.ToDecimal(thumbnailWidth / sourceImage.Width);
                    }
                    else
                    {
                        currentHeight = thumbnailHeight;
                        currentWidth = Convert.ToDecimal(sourceImage.Width) * (thumbnailHeight / Convert.ToDecimal(sourceImage.Height));

                        if (sourceImage.Width > desImageWidth)
                        {
                            currentWidth = desImageWidth;
                            currentHeight = Convert.ToDecimal(sourceImage.Height) * (thumbnailWidth / Convert.ToDecimal(sourceImage.Width));
                        }
                    }
                }
                else
                {
                    if (sourceImage.Width < desImageWidth && sourceImage.Height < desImageheight)
                    {
                        File.Copy(sourceImageFileName, desImageFileName);
                        sourceImage.Dispose();
                        return;
                    }
                    currentWidth = thumbnailWidth;
                    currentHeight = thumbnailHeight;
                }
                //To create the actual png image 
                System.Drawing.Bitmap destImage = new System.Drawing.Bitmap(Convert.ToInt32(currentWidth), Convert.ToInt32(currentHeight));
                System.Drawing.Graphics graphicsImg = System.Drawing.Graphics.FromImage(destImage);
                graphicsImg.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                graphicsImg.FillRectangle(System.Drawing.Brushes.White, 0, 0, Convert.ToInt32(currentWidth), Convert.ToInt32(currentHeight));
                graphicsImg.DrawImage(sourceImage, -1, -1, Convert.ToInt32(currentWidth) + 1, Convert.ToInt32(currentHeight) + 1);
                destImage.Save(desImageFileName, System.Drawing.Imaging.ImageFormat.Png);
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }

       
        public static string GetFormattedSSN(string ssn)
        {
            try
            {
                //format should be 123-45-6789
                System.Text.RegularExpressions.Regex _ssnRegex = new System.Text.RegularExpressions.Regex("[0-9]{3}-[0-9]{2}-[0-9]{4}");
                if (!_ssnRegex.IsMatch(ssn))
                    ssn = ssn.Substring(0, 3) + "-" + ssn.Substring(3, 2) + "-" + ssn.Substring(5, 4);
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return ssn;
        }


        
        public static void DownloadFile(string stringToDownload, FileTypes fileType, string outputFileName)
        {
            try
            {
                byte[] strBytes = System.Text.Encoding.GetEncoding("iso-8859-1").GetBytes(stringToDownload);
                MemoryStream mStream = new MemoryStream(strBytes);
                int BUFFER_SIZE = Convert.ToInt32(mStream.Length);
                int nBytesRead = 0;
                Byte[] Buffer = new Byte[BUFFER_SIZE];
                nBytesRead = mStream.Read(Buffer, 0, BUFFER_SIZE);
                mStream.Close();
                HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=" + outputFileName + Utils.GetFileExtension(fileType));
                HttpContext.Current.Response.ContentType = "application/octet-stream";

                HttpContext.Current.Response.BinaryWrite(Buffer);
                HttpContext.Current.Response.End();
            }
            catch (System.Threading.ThreadAbortException) { }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }

        public static string GetFileExtension(FileTypes fileType)
        {
            string extension = "";
            switch (fileType)
            {
                case FileTypes.Text:
                    extension = ".txt";
                    break;
                case FileTypes.Doc:
                    extension = ".doc";
                    break;

                case FileTypes.Excel:
                    extension = ".xls";
                    break;

                case FileTypes.ExcelX:
                    extension = ".xlsx";
                    break;

                case FileTypes.PDF:
                    extension = ".pdf";
                    break;
                case FileTypes.csv:
                    extension = ".csv";
                    break;
                case FileTypes.XML:
                    extension = ".xml";
                    break;
                case FileTypes.Zip:
                    extension = ".zip";
                    break;
                case FileTypes.IIF:
                    extension = ".IIF";
                    break;
            }
            return extension;
        }
      
        public static byte[] GetBinaryContent(string fileName)
        {
            try
            {
                System.IO.FileStream fs = System.IO.File.Open(fileName, System.IO.FileMode.Open);
                int BUFFER_SIZE = Convert.ToInt32(fs.Length);
                int nBytesRead = 0;
                Byte[] Buffer = new Byte[BUFFER_SIZE];
                nBytesRead = fs.Read(Buffer, 0, BUFFER_SIZE);
                fs.Close();
                return Buffer;
            }
            catch (System.Threading.ThreadAbortException) { }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return null;
        }
    

        public static string DocumentPhysicalPath
        {
            get { return GetConfigParam<string>("PhysicalDocumentPath"); }
        }

        public static string DocumentVirtualPath
        {
            get { return GetConfigParam<string>("DocumentURL"); }
        }
        
        public static string ApplicationPhysicalTempPath
        {
            get { return GetConfigParam<string>("DocumentsFolderPhysicalPath") + GetConfigParam<string>("Temp"); }
        }
        
        public static string WriteBytesToFile(Byte[] bytes, string outputFileName)
        {
            try
            {
                if (!string.IsNullOrEmpty(outputFileName))
                {
                    byte[] strBytes = bytes;
                    MemoryStream mStream = new MemoryStream(strBytes);
                    int BUFFER_SIZE = Convert.ToInt32(mStream.Length);
                    int nBytesRead = 0;
                    Byte[] Buffer = new Byte[BUFFER_SIZE];
                    nBytesRead = mStream.Read(Buffer, 0, BUFFER_SIZE);
                    mStream.Close();
                    System.IO.File.WriteAllBytes(outputFileName, Buffer);
                }
                return outputFileName;
            }
            catch (System.Threading.ThreadAbortException) { }
            catch (Exception ee)
            {
                Utils.Write("PDF IS EMPTY");
                Utils.Write(ee);
            }
            return outputFileName;
        }

     
        public static void DownloadFile(string fileName, string ouptFileName)
        {
            try
            {
                System.IO.FileStream fs = System.IO.File.Open(fileName, System.IO.FileMode.Open);
                int BUFFER_SIZE = Convert.ToInt32(fs.Length);
                int nBytesRead = 0;
                Byte[] Buffer = new Byte[BUFFER_SIZE];
                nBytesRead = fs.Read(Buffer, 0, BUFFER_SIZE);
                fs.Close();
                HttpContext.Current.Response.AddHeader("Content-disposition", "attachment; filename=" + ouptFileName + System.IO.Path.GetExtension(fileName).ToLower());
                HttpContext.Current.Response.ContentType = GetContentType(fileName);
                HttpContext.Current.Response.BinaryWrite(Buffer);
                HttpContext.Current.Response.End();
            }
            catch (System.Threading.ThreadAbortException) { }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }

    
        private static string GetContentType(string fileName)
        {
            string contentType = "application/octetstream";
            try
            {
                string ext = System.IO.Path.GetExtension(fileName).ToLower();
                Microsoft.Win32.RegistryKey registryKey = Microsoft.Win32.Registry.ClassesRoot.OpenSubKey(ext);
                if (registryKey != null && registryKey.GetValue("Content Type") != null)
                    contentType = registryKey.GetValue("Content Type").ToString();
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
            return contentType;
        }

  
        public static void ShowAlert(this System.Web.UI.Page pge, string message)
        {
            try
            {
                message = (message == null ? "" : message);
                message = Utils.InsertEscapeCharacters(message);
                //Replacing the single quotes if wny with an escape char.
                string script = "alert('" + message + "');";
                System.Web.UI.ScriptManager.RegisterClientScriptBlock(pge, pge.GetType(), "Alert", script, true);
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }
        public static string InsertEscapeCharacters(string message)
        {
            return (message != null ? message.Replace("'", @"\'").Replace("\n", @"\n").Replace("\t", @"\t") : message);//Replacing the single quotes if wny with an escape char.
        }

        public static void ShowAlert(this System.Web.UI.UserControl page, string message)
        {
            try
            {
                page.Parent.Page.ShowAlert(message);
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }
        public static void ExecuteScript(this System.Web.UI.Page pge, string script)
        {
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(pge, pge.GetType(), "Script_" + new Random().Next(1000).ToString() + pge.ClientID, script, true);
        }
      
       
        public static string GetPageName(string rowURL)
        {
            /*
             * Function to get aspx name from a given URL (with extension)
             * */

            try
            {
                string aspxName = rowURL.Substring(rowURL.LastIndexOf('/') + 1, rowURL.Length - rowURL.LastIndexOf('/') - 1);
                if (aspxName.IndexOf("?") >= 0)
                    aspxName = aspxName.Substring(0, aspxName.IndexOf("?"));

                return aspxName;
            }
            catch (Exception)
            {
            }

            return rowURL;
        }
       
        public static string GetIPAddress()
        {
            string strHostName = "";
            strHostName = System.Net.Dns.GetHostName();
            IPHostEntry ipEntry = System.Net.Dns.GetHostEntry(strHostName);
            IPAddress[] addr = ipEntry.AddressList;
            return addr[addr.Length - 1].ToString();
        }


       
        public static void WriteFile(string str)
        {
            try
            {
                string fileToWrite = Utils.GetConfigParam<string>("exceptionLogfile");
                string userLogFileName = string.Empty;
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
                    sw.Write(str + "\n");
                    sw.Close();
                }
            }
            catch (Exception)
            {

                throw;
            }
        }

        
        public static void WriteExceptionToDatabase(int hha, int userID, string functionName, string fileName, string queryString, string clientIP, Exception ex)
        {
            try
            {

                string exception = ex.ToString();
                string instanceName = "";
                if (Utils.GetConfigParam<string>("InstanceName") != null)
                    instanceName = Utils.GetConfigParam<string>("InstanceName").ToString();
                if (String.IsNullOrEmpty(fileName))
                {
                    System.IO.FileInfo fInfo = new FileInfo(HttpContext.Current.Request.PhysicalPath);
                    fileName = fInfo.Name; //HttpContext.Current.Request.FilePath;
                }
                if (String.IsNullOrEmpty(clientIP))
                    clientIP = HttpContext.Current.Request.UserHostAddress.ToString();
                if (exception.Length > 2000)
                    exception = exception.Substring(0, 2000);
                if (queryString.Length > 2000)
                    queryString = queryString.Substring(0, 2000);

                //SetUpManager_SP managerObj = new SetUpManager_SP();
                //bool ret = managerObj.AddWebException(hha, userID, fileName, functionName, queryString, clientIP, instanceName, exception);
                //if (!ret)
                //{
                //    WriteFile(DateTime.Now.ToString() + " Failed to log exception to WebLog\n" + ex.ToString());
                //}
            }
            catch (Exception excep)
            {
                WriteFile(DateTime.Now.ToString() + " Failed to log exception to WebLog\n" + excep.ToString());
            }
        }

        public enum FileTypes
        {
            Text = 1,
            PDF,
            Excel,
            Doc,
            csv,
            XML,
            ExcelX,
            Zip,
            IIF

        }
    }
}