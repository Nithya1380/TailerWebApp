using DAL.Model;
using DAL.Utilities;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.DBManager
{
    public class CustomerManager : KanDelegate
    {
        public bool GetCustomerDetails(int companyID, int customerID, int userID, out CustomerMaster customerMaster)
        {
            customerMaster = new CustomerMaster();
            customerMaster.Customer = new Customer();
            customerMaster.CustomerAccount = new CustomerAccount();
            customerMaster.CustomerSupply = new CustomerSupply();
            customerMaster.CustomerBranches = new List<CustomerBranches>();
            string jsonData = string.Empty;
            bool ret = false;
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetCustomerDetails";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@CustomerID", customerID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    //Get Customer
                    jsonData = string.Empty;
                    while (reader.Read())
                    {
                        jsonData += reader.GetString(0);
                    }

                    customerMaster.Customer = Newtonsoft.Json.JsonConvert.DeserializeObject<Customer>(jsonData);

                    //Get Account
                    reader.NextResult();
                    jsonData = string.Empty;
                    while (reader.Read())
                    {
                        jsonData += reader.GetString(0);
                    }

                    customerMaster.CustomerAccount = Newtonsoft.Json.JsonConvert.DeserializeObject<CustomerAccount>(jsonData);

                    reader.NextResult();
                    jsonData = string.Empty;
                    byte[] photobyte = null;
                    while (reader.Read())
                    {
                        photobyte = (byte[])reader.GetValue(0);
                    }

                    if (customerMaster != null && customerMaster.Customer!=null && photobyte !=null && photobyte.Length>0)
                         customerMaster.Customer.CustomerPhoto = Convert.ToBase64String(photobyte, 0, photobyte.Length);

                    reader.NextResult();
                    jsonData = string.Empty;
                    while (reader.Read())
                    {
                        jsonData += reader.GetString(0);
                    }

                    customerMaster.CustomerBranches = Newtonsoft.Json.JsonConvert.DeserializeObject<List<CustomerBranches>>(jsonData);

                    reader.NextResult();
                    jsonData = string.Empty;
                    while (reader.Read())
                    {
                        jsonData += reader.GetString(0);
                    }

                    customerMaster.CustomerSupply = Newtonsoft.Json.JsonConvert.DeserializeObject<CustomerSupply>(jsonData);

                    reader.Close();
                }
                
                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get customer details. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetCustomerPickLists(int companyID, int customerID, int userID, out CustomerPickLists customerMasterPickLists)
        {
            customerMasterPickLists = new CustomerPickLists();
            bool ret = false;
            string dropdowns = string.Empty;
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetCustomerPickLists";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@CustomerID", customerID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountCategory = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountDateCategory = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountParentType = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountReverse = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountSch6Group = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountTDSCategory = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountTDSDefault = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.AccountType = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.City = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.Country = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.State = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.SRNames = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.SupplierCategories = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        
                        dropdowns += reader.GetString(0);
                    }

                    customerMasterPickLists.SupplierTypes = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);
                    
                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get customer dropdowns. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetCustomerList(int companyID, int userID, out JsonResults customerList)
        {
            customerList = new JsonResults();
            bool ret = false;
           
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetCustomerList";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        customerList.JSonstring += reader.GetString(0);
                    }

                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get customer List. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool AddNewCustomer(int companyID, int userID, ref Customer customerObj)
        {
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "AddNewCustomer";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPStringParam("@customerObj", Newtonsoft.Json.JsonConvert.SerializeObject(customerObj));
                this.AddSPReturnIntParam("@return");
                this.ExecuteNonSP(spName);
                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    case -2: SetError(-2, "Mandatory fileds are not entered. Failed to add new customer.");
                        break;
                    case -3: SetError(-3, "Customer with same name already exists. Failed to add new customer.");
                        break;
                    default: SetError(-1, "Failed to add new customer. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to add new customer. Please try again later");
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }
    }
}
