using DAL.DBManager;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;

namespace TailerApp.UI.Admin
{
    public partial class EditLogo : PageBase
    {
        public int CompanyID;
        public string ApplicationVirtualPath = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                ApplicationVirtualPath = Utils.ApplicationVirtualPath;
                if (!string.IsNullOrEmpty(Request.QueryString["CompanyID"]))
                    CompanyID = Convert.ToInt32(Request.QueryString["CompanyID"]);

                if (!IsPostBack)
                {
                    GetLogo();
                }
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }

        void GetLogo()
        {
            byte[] CompanyLogo = null;
            AdminManagerSP ManagerObj = new AdminManagerSP();
            if (!ManagerObj.GetCompanyLogo(CURRENT_USER.CompanyID, CURRENT_USER.UserId, out CompanyLogo))
            {
                Utils.ShowAlert(this, ManagerObj.GetLastError());
            }
            else
            {
                if (CompanyLogo != null)
                {
                    string base64ImageData = Convert.ToBase64String(CompanyLogo, 0, CompanyLogo.Length);
                    img_Logo.ImageUrl = "data:image/png;base64," + base64ImageData;
                }
                else
                {
                    btn_Remove.Visible = false;
                }
            }
        }

        /// <summary>
        /// Created by: Anoop
        ///         On: Jan 13th, 2017
        ///Description: To remove company logo for a HHA
        /// </summary>
        protected void btn_Remove_Click(object sender, EventArgs e)
        {
            try
            {
                bool isSuccess; byte[] CompanyLogo = null; ;
                AdminManagerSP ManagerObj = new AdminManagerSP();
                isSuccess = ManagerObj.SaveCompanyLogo(CURRENT_USER.CompanyID, CURRENT_USER.UserId, CompanyLogo, "");

                if (isSuccess == true)
                {

                    Utils.ShowAlert(this, "Company Logo Removed Successfully.");
                }
                else
                {
                    Utils.ShowAlert(this, "There is no logo present for the company");
                }
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
            }
        }

        protected void btn_Upload_Click(object sender, EventArgs e)
        {
            try
            {
                //Audit Log Purpose

                string sFile = UploadingFileName_Txt.Value.Trim();
                string fileExtension = System.IO.Path.GetExtension(sFile);
                if (fileExtension == ".jpg" || fileExtension == ".tif" || fileExtension == ".png" || fileExtension == ".gif")
                {
                    Random rand = new Random();
                    //string fileStr = System.Configuration.ConfigurationManager.AppSettings.Get("TempLogoFolder") + "\\" + CURRENT_USER.CompanyID + "\\";

                    //if (!System.IO.Directory.Exists(fileStr))
                    //    System.IO.Directory.CreateDirectory(fileStr);

                    //fileStr += "\\" + Session.SessionID.ToString() + "_" + rand.Next().ToString() + ".xls";
                    //if (sFile.Length > 0)
                    //    UploadingFileName_Txt.PostedFile.SaveAs(fileStr);     

                    HttpPostedFile sPath = UploadingFileName_Txt.PostedFile;
                    string fileName = Path.GetFileName(sPath.FileName);
                    Stream stream = sPath.InputStream;
                    BinaryReader binaryReader = new BinaryReader(stream); 

                    //System.Drawing.Image FullsizeImage = System.Drawing.Image.FromFile(fileStr);
                    //ImageFile = GetResizedImage(FullsizeImage, 225, 80);
                    byte[] ImageBinaryFile = binaryReader.ReadBytes((int)stream.Length);// (UploadingFileName_Txt.PostedFile); 

                    //using (System.IO.MemoryStream streamReader = new System.IO.MemoryStream())
                    //{
                    //    ImageFile.Save(streamReader, System.Drawing.Imaging.ImageFormat.Png);
                    //    streamReader.Position = 0;
                    //    ImageBinaryFile = new byte[streamReader.Length];
                    //    streamReader.Read(ImageBinaryFile, 0, ImageBinaryFile.Length);
                    //    streamReader.Close();
                    //}

                    SetLogo(ImageBinaryFile, System.IO.Path.GetFileName(sFile));

                    //if (System.IO.File.Exists(fileStr))
                    //    System.IO.File.Delete(fileStr);

                    //string base64ImageData = Convert.ToBase64String(ImageBinaryFile, 0, ImageBinaryFile.Length);

                    // img_Logo.ImageUrl="data:image/png;base64," + base64ImageData;
                    Utils.ShowAlert(this, "Company Logo Updated Successfully.");
                    btn_Remove.Visible = true;
                }
                else
                {
                    Utils.ShowAlert(this, "Please choose a valid Image File like JPG, TIF, PNG, GIF, etc.");
                }
            }
            catch (Exception ee)
            {
                Utils.Write(ee);
                Utils.ShowAlert(this, ee.ToString());
            }
        }

        byte[] ReadFile(string sPath)
        {
            //Initialize byte array with a null value initially.
            byte[] data = null;

            //Use FileInfo object to get file size.
            FileInfo fInfo = new FileInfo(sPath);
            long numBytes = fInfo.Length;

            //Open FileStream to read file
            FileStream fStream = new FileStream(sPath, FileMode.Open, FileAccess.Read);

            //Use BinaryReader to read file stream into byte array.
            BinaryReader br = new BinaryReader(fStream);

            //When you use BinaryReader, you need to supply number of bytes 
            //to read from file.
            //In this case we want to read entire file. 
            //So supplying total number of bytes.
            data = br.ReadBytes((int)numBytes);

            return data;
        }

        void SetLogo(byte[] CompanyLogo, string LogoName)
        {
            AdminManagerSP ManagerObj = new AdminManagerSP();
            if (!ManagerObj.SaveCompanyLogo(CURRENT_USER.CompanyID, CURRENT_USER.UserId, CompanyLogo, LogoName))
            {
                Utils.ShowAlert(this, ManagerObj.GetLastError());
            }
            else
            {
                string base64ImageData = Convert.ToBase64String(CompanyLogo, 0, CompanyLogo.Length);
                img_Logo.ImageUrl = "data:image/png;base64," + base64ImageData;

            }
        }

        public static System.Drawing.Image GetResizedImage(System.Drawing.Image FullsizeImage, int newWidth, int maxHeight)
        {
            //System.Drawing.Image FullsizeImage = System.Drawing.Image.FromFile(orginalImageFileName);
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
            return NewImage;
        }
    }
}