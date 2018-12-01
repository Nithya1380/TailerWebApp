using DAL.DBManager;
using DAL.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using TailerApp.Common;

namespace TailerApp.UI.Admin
{
    public partial class AddEditItemMaster : PageBase
    {
        public int ItemMasterID { get; set; }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request.QueryString.Get("ItemMasterID")))
                ItemMasterID = Convert.ToInt32(Request.QueryString.Get("ItemMasterID"));
        }

        [WebMethod]
        public static GenericPickList GetItemGroups()
        {
            GenericPickList returnObj = new GenericPickList();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = -1001;
                    returnObj.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetPickLists(currentUser.CompanyID, currentUser.UserId, "ItemMasterGroup", out returnObj))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = customerObj.GetLastErrorCode();
                    returnObj.ErrorMessage = customerObj.GetLastError();
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return returnObj;
        }

        [WebMethod]
        public static ItemMasterList GetItemDetails(int itemMasterID)
        {
            ItemMasterList returnObj = new ItemMasterList();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = -1001;
                    returnObj.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.GetItemMasterList(currentUser.CompanyID, currentUser.UserId, itemMasterID, out returnObj))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = -1;
                    returnObj.ErrorMessage = "Failed to get Item Details. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return returnObj;
        }

        [WebMethod]
        public static JsonResults AddEditItemToDB(ItemMaster ItemMaster, int itemMasterID)
        {
            JsonResults returnObj = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    returnObj.ErrorCode = -1001;
                    returnObj.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.AddEditItemMaster(currentUser.CompanyID, currentUser.UserId, currentUser.UserBranchID,itemMasterID, ref ItemMaster))
                {
                    returnObj.ErrorCode = 0;
                    returnObj.ErrorMessage = "";
                }
                else
                {
                    returnObj.ErrorCode = customerObj.GetLastErrorCode();
                    returnObj.ErrorMessage = customerObj.GetLastError();
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return returnObj;
        }

        [WebMethod]
        public static JsonResults GetItemRatesList(int ItemMasterID, int ItemRateID)
        {
            JsonResults invoiceList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    invoiceList.ErrorCode = -1001;
                    invoiceList.ErrorMessage = "";
                }

                CustomerManager customerObj = new CustomerManager();
                if (customerObj.GetItemMasterRates(currentUser.CompanyID, currentUser.UserId, ItemMasterID,ItemRateID, out invoiceList))
                {
                    invoiceList.ErrorCode = 0;
                    invoiceList.ErrorMessage = "";
                }
                else
                {
                    invoiceList.ErrorCode = -1;
                    invoiceList.ErrorMessage = "Failed to get Item Rates. please try again later";
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return invoiceList;
        }

        [WebMethod]
        public static JsonResults AddEditItemRate(string StartDate, string ItemPrice, int ItemRateID, int itemMasterID)
        {
            JsonResults invoiceList = new JsonResults();
            LoginUser currentUser;
            try
            {
                if (!GetUserSession(out currentUser))
                {
                    invoiceList.ErrorCode = -1001;
                    invoiceList.ErrorMessage = "";
                }

                AdminManagerSP customerObj = new AdminManagerSP();
                if (customerObj.AddEditItemRate(currentUser.CompanyID, currentUser.UserId, ItemRateID, itemMasterID, ItemPrice, StartDate))
                {
                    invoiceList.ErrorCode = 0;
                    invoiceList.ErrorMessage = "";
                }
                else
                {
                    invoiceList.ErrorCode = customerObj.GetLastErrorCode();
                    invoiceList.ErrorMessage = customerObj.GetLastError();
                }
            }
            catch (Exception ex)
            {
                Utils.Write(ex);
            }

            return invoiceList;
        }
    }
}