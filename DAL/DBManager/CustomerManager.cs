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

        public bool GetPickLists(int companyID, int userID, string PickListName, out GenericPickList MasterPickLists)
        {
            MasterPickLists = new GenericPickList();
            bool ret = false;
            string dropdowns = string.Empty;
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetPickLists";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@user", userID);
                this.AddSPStringParam("@PickListName", PickListName);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    MasterPickLists.PickListItems = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get dropdowns. Please try again later");
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

        public bool AddNewCustomer(int companyID, int userID, int UserBranchID, ref Customer customerObj,ref CustomerAccount customerAccountObj)
        {
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "AddNewCustomer";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPIntParam("@UserBranchID", UserBranchID);
                this.AddSPStringParam("@customerObj", Newtonsoft.Json.JsonConvert.SerializeObject(customerObj));
                this.AddSPStringParam("@customerAccountObj", Newtonsoft.Json.JsonConvert.SerializeObject(customerAccountObj));
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
                    case -4: SetError(-4, "Customer code already exists. Failed to add new customer.");
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

        public bool SaveCustomerDetails(int companyID, int userID,int customerID,int customerBranch,ref CustomerMaster customerObj,out int newCustomerID)
        {
            bool ret = false;
            newCustomerID=0;
            try
            {
                this.Connect(this.GetConnString());
                string spName = "SaveCustomerDetails";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@CustomerID", customerID);
                this.AddSPIntParam("@CustomerBranchID", customerBranch);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPStringParam("@customerObj", Newtonsoft.Json.JsonConvert.SerializeObject(customerObj));
                this.AddSPReturnIntParam("@return");
                this.ExecuteNonSP(spName);
                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        newCustomerID = this.GetOutValueInt("@CustomerID");
                        break;
                    case -2: SetError(-2, "Mandatory fileds are not entered. Failed to Save.");
                        break;
                    case -3: SetError(-3, "Customer with same name already exists. Failed to Save customer.");
                        break;
                    case -4: SetError(-4, "Customer code already exists. Failed to Save customer.");
                        break;
                    default: SetError(-1, "Failed to save customer information.Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to save customer information.Please try again later");
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool SearchCustomers(int companyID, int userID,int branchID,string searchText,out JsonResults customerList)
        {
            customerList = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "SearchCustomer";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@BranchID", branchID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPStringParam("@SearchText", searchText);
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

        public bool GetMeasurementMaster(int companyID, int userID, int MeasurementMasterID, out JsonResults Measu, bool isPrint = false)
        {
            Measu = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetMeasurementMaster";
                this.ClearSPParams();
                this.AddSPIntParam("@CompanyID", companyID);
                this.AddSPIntParam("@user", userID);
                this.AddSPIntParam("@MeasurementMasterID", MeasurementMasterID);
                this.AddSPBoolParam("@isPrint", isPrint);

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        if (!reader.IsDBNull(0))
                            Measu.JSonstring = reader.GetString(0);

                        if (!reader.IsDBNull(1))
                            Measu.JSonstring2 = reader.GetString(1);
                    }
                    reader.Close();
                }
                int retcode = this.GetOutValueInt("@return");
                switch (retcode)
                {
                    case 0: ret = true;
                        break;

                    default: SetError(-1, "Failed to get Measurement. Please try again later");
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


        public bool GetCompanyHeaderInfo(int companyID, int userID, int Location, out JsonResults Measu)
        {
            Measu = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetCompanyHeaderInfo";
                this.ClearSPParams();
                this.AddSPIntParam("@CompanyID", companyID);
                this.AddSPIntParam("@user", userID);
                this.AddSPIntParam("@location", Location);

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        if (!reader.IsDBNull(0))
                            Measu.JSonstring = reader.GetString(0);
                    }
                    reader.Close();
                }
                int retcode = this.GetOutValueInt("@return");
                switch (retcode)
                {
                    case 0: ret = true;
                        break;

                    default: SetError(-1, "Failed to get Company Header Info. Please try again later");
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
        public bool SaveMeasurementMaster(int CompanyID, int User, int MeasurementMasterID, string Measurement, string MeasurementField, out JsonResults Measu)
        {
            bool ret = false;
            Measu = new JsonResults();

            try
            {
                this.Connect(this.GetConnString());
                string spName = "SaveMeasurementMaster";
                this.ClearSPParams();
                this.AddSPIntParam("@CompanyID", CompanyID);
                this.AddSPIntParam("@user", User);
                this.AddSPStringParam("@Measurement", Measurement);
                this.AddSPStringParam("@MeasurementField", MeasurementField);
                this.AddSPIntParam("@MeasurementMasterID", MeasurementMasterID);
                this.AddSPReturnIntParam("@return");

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {

                    while (reader.Read())
                    {

                        if (!reader.IsDBNull(0))
                            Measu.OutValue = reader.GetInt32(0);
                        else
                            Measu.OutValue = 0;
                    }
                    reader.Close();

                    int retcode = this.GetOutValueInt("@return");
                    switch (retcode)
                    {
                        case 0:
                            ret = true;
                            break;

                        default:
                            SetError(1, "Failed to save Measurement. Please try again later.");
                            break;
                    }
                }
            }
            catch (Exception e)
            {
                SetError(-100, "Failed to save Measurement. Please try again later");
                Utils.Write(0, 0, "CustomerManager", "SaveMeasurementMaster", "", "", e);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetMeasurementList(int CompanyID, int User, out JsonResults Measu)
        {
            bool ret = false;
            Measu = new JsonResults();
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetMeasurementList";
                this.ClearSPParams();
                this.AddSPIntParam("@Company", CompanyID);
                this.AddSPIntParam("@User", User);
                this.AddSPReturnIntParam("@return");

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {

                        if (!reader.IsDBNull(0))
                            Measu.JSonstring = reader.GetString(0);
                        else
                            Measu.JSonstring = "";
                    }

                    reader.Close();
                    int retcode = this.GetOutValueInt("@return");

                    switch (retcode)
                    {
                        case 0:
                            ret = true;
                            break;

                        default:
                            SetError(1, "Failed to get employee. Please try again later");
                            break;
                    }
                }
            }
            catch (Exception e)
            {
                SetError(1, "Failed to get Measurement List . Please try again later");
                Utils.Write(0, 0, "CustomerManager", "GetEmployeeMasterDetails", "", "", e);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }


        public bool GetAccountList(int CompanyID, int User, out JsonResults Accou)
        {

            bool ret = false;
            Accou = new JsonResults();
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetAccountList";
                this.ClearSPParams();
                this.AddSPIntParam("@Company", CompanyID);
                this.AddSPIntParam("@user", User);
                this.AddSPReturnIntParam("@return");

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        if (!reader.IsDBNull(0))
                            Accou.JSonstring = reader.GetString(0);
                        else
                            Accou.JSonstring = "";
                    }

                    reader.Close();
                    int retcode = this.GetOutValueInt("@return");
                    switch (retcode)
                    {
                        case 0:
                            ret = true;
                            break;
                        default:
                            SetError(1, "Failed to get Account List. Please try again later");
                            break;
                    }
                }
            }
            catch (Exception e)
            {
                SetError(1, "Failed to get Account List . Please try again later");
                Utils.Write(0, 0, "CustomerManager", "GetAccountList", "", "", e);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetMeasurementField(int companyID, int userID, out JsonResults Measu)
        {
            Measu = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetMeasurementField";
                this.ClearSPParams();
                this.AddSPIntParam("@CompanyID", companyID);
                this.AddSPIntParam("@user", userID);

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        if (!reader.IsDBNull(0))
                            Measu.JSonstring = reader.GetString(0);
                    }
                    reader.Close();
                }
                int retcode = this.GetOutValueInt("@return");
                switch (retcode)
                {
                    case 0: ret = true;
                        break;

                    default: SetError(-1, "Failed to get Measurement field. Please try again later");
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

        public bool SaveMeasurementField(int CompanyID, int User, string MeasurField)
        {
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "SaveMeasurementField";
                this.ClearSPParams();
                this.AddSPIntParam("@CompanyID", CompanyID);
                this.AddSPIntParam("@user", User);
                this.AddSPStringParam("@MeasurementField", MeasurField);
                this.AddSPReturnIntParam("@return");

                this.ExecuteNonSP(spName);

                int retcode = this.GetOutValueInt("@return");
                switch (retcode)
                {
                    case 0:
                        ret = true;
                        break;

                    default:
                        SetError(1, "Failed to save Measurement field. Please try again later.");
                        break;
                }

            }
            catch (Exception e)
            {
                SetError(-100, "Failed to save Measurement field. Please try again later");
                Utils.Write(0, 0, "CustomerManager", "SaveMeasurementField", "", "", e);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetInvoicePickLists(int companyID, int customerID, int userID, out InvoicePickLists invoicePickLists)
        {
            invoicePickLists = new InvoicePickLists();
            bool ret = false;
            string dropdowns = string.Empty;
            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetInvoicePickLists";
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

                    invoicePickLists.AccountSeries = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    invoicePickLists.InvoiceLessCategory = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    invoicePickLists.InvoiceTaxCategory = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);


                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    invoicePickLists.InvoicePaymentMethod = Newtonsoft.Json.JsonConvert.DeserializeObject<List<PickList>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    invoicePickLists.Masters = Newtonsoft.Json.JsonConvert.DeserializeObject<List<EmployeePositions>>(dropdowns);

                    reader.NextResult();
                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    invoicePickLists.Designers = Newtonsoft.Json.JsonConvert.DeserializeObject<List<EmployeePositions>>(dropdowns);

                    reader.NextResult();

                    dropdowns = string.Empty;
                    while (reader.Read())
                    {
                        dropdowns += reader.GetString(0);
                    }

                    invoicePickLists.SalesReps = Newtonsoft.Json.JsonConvert.DeserializeObject<List<EmployeePositions>>(dropdowns);


                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1:
                        ret = true;
                        break;
                    default:
                        SetError(-1, "Failed to get Invoice dropdowns. Please try again later");
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
        public bool CreateNewInvoice(int companyID, int userID, int customerBranch, ref CustomerInvoice customerInvoice, ref List<CustomerInvoiceList> customerInvoiceList, out string billNumber)
        {
            bool ret = false;
            billNumber = string.Empty;
            try
            {
                this.Connect(this.GetConnString());
                string spName = "CreateNewInvoice";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@CustomerBranchID", customerBranch);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPStringParam("@customerInvoiceObj", Newtonsoft.Json.JsonConvert.SerializeObject(customerInvoice));
                this.AddSPStringParam("@customerInvoiceList", Newtonsoft.Json.JsonConvert.SerializeObject(customerInvoiceList));
                this.AddSPReturnIntParam("@return");
                this.AddSPStringParamOut("@BillNumber", 100);
                this.ExecuteNonSP(spName);
                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1:
                        ret = true;
                        billNumber = this.GetOutValueString("@BillNumber");
                        break;
                    case -2:
                        SetError(-2, "Mandatory fileds are not entered. Failed to create Invoice.");
                        break;
                    case -3:
                        SetError(-3, "Invoice Item lists are empty. Failed to create Invoice.");
                        break;
                    default:
                        SetError(-1, "Failed to create Invoice..Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to create Invoice.Please try again later");
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetInvoiceList(int companyID, int userID, int branchID, out JsonResults customerList)
        {
            customerList = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetInvoiceList";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@BranchID", branchID);
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
                    default: SetError(-1, "Failed to get Invoice List. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to get Invoice List. Please try again later");
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetItemMasterRates(int companyID, int userID, int ItemMasterID, int ItemRateID, out JsonResults itemRateList)
        {
            itemRateList = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetItemRates";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@ItemMasterID", ItemMasterID);
                this.AddSPIntParam("@ItemRateID", ItemRateID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        itemRateList.JSonstring += reader.GetString(0);
                    }

                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get Item Rates. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to get Item Rates. Please try again later");
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetInvoiceDetails(int companyID, int userID, int branchID,int invoiceID,out JsonResults invoiceDetails)
        {
            invoiceDetails = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetInvoiceDetails";
                this.ClearSPParams();
                this.AddSPIntParam("@companyID", companyID);
                this.AddSPIntParam("@BranchID", branchID);
                this.AddSPIntParam("@UserID", userID);
                this.AddSPIntParam("@InvoiceID", invoiceID);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        invoiceDetails.JSonstring += reader.GetString(0);
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        invoiceDetails.JSonstring2 += reader.GetString(0);
                    }

                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get Invoice Details. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to get Invoice Details. Please try again later");
                Utils.Write(ex);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

        public bool GetDashboard(int companyID, int userID, int branchID,out JsonResults dashboardDetails)
        {
            dashboardDetails = new JsonResults();
            bool ret = false;

            try
            {
                this.Connect(this.GetConnString());
                string spName = "GetDashboard";
                this.ClearSPParams();
                this.AddSPIntParam("@Company", companyID);
                this.AddSPIntParam("@BranchID", branchID);
                this.AddSPIntParam("@user", userID);
                this.AddSPReturnIntParam("@return");
                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {
                    while (reader.Read())
                    {
                        dashboardDetails.JSonstring += reader.GetString(0);
                    }

                    reader.NextResult();
                    while (reader.Read())
                    {
                        dashboardDetails.JSonstring2 += reader.GetString(0);
                    }

                    reader.Close();
                }

                int retcode = this.GetOutValueInt("@return");

                switch (retcode)
                {
                    case 1: ret = true;
                        break;
                    default: SetError(-1, "Failed to get Dashboard Details. Please try again later");
                        break;
                }
            }
            catch (Exception ex)
            {
                ret = false;
                SetError(-1, "Failed to get Dashboard Details. Please try again later");
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
