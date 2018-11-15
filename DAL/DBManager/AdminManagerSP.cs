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
    public class AdminManagerSP : KanDelegate
    {

       public bool  _C_GetCompanyDetails(int CompanyID, int User, out Struct_Company Struct_Company)
        {
            bool ret = false;
            Struct_Company = new Struct_Company();
            try
            {

                this.Connect(this.GetConnString());
                string spName = "_C_GetCompanyDetails";
                this.ClearSPParams();
                this.AddSPIntParam("@CompanyID", CompanyID);
                this.AddSPIntParam("@User", User);
                this.AddSPReturnIntParam("@return");

                using (SqlDataReader reader = this.ExecuteSelectSP(spName))
                {

                    while (reader.Read())
                    {

                        if (reader["CompanyDetails"] != DBNull.Value)
                            Struct_Company.CompanyDetails = reader["CompanyDetails"].ToString();
                        else
                            Struct_Company.CompanyDetails = "";

                        if (reader["AddressDetails"] != DBNull.Value)
                            Struct_Company.AddressDetails =  reader["AddressDetails"].ToString();
                        else
                            Struct_Company.AddressDetails = "";

                    }

                    reader.Close();
                    int retcode = this.GetOutValueInt("@return");

                  
                }
            }
            catch (Exception e)
            {
                SetError(-100, "Failed to get Company Details . Please try again later");
                Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
            }
            finally
            {
                this.ClearSPParams();
                this.Disconnect();
            }
            return ret;
        }

       public bool _C_AddModifyCompany(int CompanyID, int User, string CompanyDetails, string AddressDetails)
       {
           bool ret = false;
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_C_AddModifyCompany";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@User", User);
               this.AddSPStringParam("@CompanyDetails", CompanyDetails);
               this.AddSPStringParam("@AddressDetails", AddressDetails);
               this.AddSPReturnIntParam("@return");

               if (this.ExecuteNonSP(spName)==1)
               {
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to save Company Details. Please try again later");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save Company Details. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _C_GetBranchDetails(int CompanyID, int User, int BranchID, out Struct_Branch Struct_Branch)
       {
           bool ret = false;
           Struct_Branch = new Struct_Branch();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_C_GetBranchDetails";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@User", User);
               this.AddSPIntParam("@BranchID", BranchID);
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {

                   while (reader.Read())
                   {

                       if (reader["BranchDetails"] != DBNull.Value)
                           Struct_Branch.BranchDetails = reader["BranchDetails"].ToString();
                       else
                           Struct_Branch.BranchDetails = "";

                       if (reader["AddressDetails"] != DBNull.Value)
                           Struct_Branch.AddressDetails = reader["AddressDetails"].ToString();
                       else
                           Struct_Branch.AddressDetails = "";

                   }

                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");


               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to get Branch Details . Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _C_AddModifyBranch(int CompanyID, int User, int BranchID, string BranchDetails, string AddressDetails, string userloginid,  byte[] Password )
       {
           bool ret = false;
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_C_AddModifyBranch";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@User", User);
               this.AddSPIntParam("@BranchID", BranchID);
               this.AddSPStringParam("@BranchDetails", BranchDetails);
               this.AddSPStringParam("@AddressDetails", AddressDetails);
               this.AddSPVarBinaryParam("@Password", Password);
               this.AddSPStringParam("@UserLoginId", userloginid);
               this.AddSPReturnIntParam("@return");

               if (this.ExecuteNonSP(spName) == 1)
               {
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to save Branch Details. Please try again later");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save Branch Details . Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _C_GetCompanyAndBranchList(int CompanyID, int User, out Struct_Company Struct_Company)
       {
           bool ret = false;
           Struct_Company = new Struct_Company();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_C_GetCompanyAndBranchList";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@User", User);
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {

                   while (reader.Read())
                   {

                       if (reader["CompanyList"] != DBNull.Value)
                           Struct_Company.CompanyList = reader["CompanyList"].ToString();
                       else
                           Struct_Company.CompanyList = "";

                       if (reader["BranchList"] != DBNull.Value)
                           Struct_Company.BranchList = reader["BranchList"].ToString();
                       else
                           Struct_Company.BranchList = "";

                   }

                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to get Company and Branch List . Please try again later");
                           break;
                   }

               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to get Company and Branch List . Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _U_AddModifyDeleteRole(int CompanyID, int User, int RoleID, string RoleName, bool IsDelete)
       {
           bool ret = false;
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_AddModifyDeleteRole";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@user", User);
               this.AddSPIntParam("@RoleID", RoleID);
               this.AddSPStringParam("@RoleName", RoleName);
               this.AddSPBoolParam("@IsDeleted", IsDelete);
               this.AddSPReturnIntParam("@return");

               if (this.ExecuteNonSP(spName) == 1)
               {
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to save role. Please try again later");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save role. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_U_AddModifyDeleteRole", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _U_ModifyRolePermission(int CompanyID, int User, string RoleName, int RoleID, string PermissionAdded, string PermissionRemoved, bool isDeleted, int HomePage, out JSONReturnData Struct_Perm)
       {
           bool ret = false;
           Struct_Perm = new JSONReturnData();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_ModifyRolePermission";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", CompanyID);
               this.AddSPIntParam("@user", User);
               this.AddSPStringParam("@RoleName", RoleName);
               this.AddSPIntParam("@RoleID", RoleID);
               this.AddSPStringParam("@PermissionAdded", PermissionAdded);
               this.AddSPStringParam("@PermissionRemoved", PermissionRemoved);
               this.AddSPBoolParam("@isDeleted", isDeleted);
               this.AddSPIntParam("@HomePage", HomePage); 
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {
                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_Perm.Outvalue = reader.GetInt32(0);
                       else
                           Struct_Perm.Outvalue = 0;

                   }
                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       case 2:
                           SetError(2, "Can not deleted role, it is atteched to user(s).");
                           break;
                       case 3:
                           SetError(3, "Same role name is alrady exist.");
                           break;
                       default:
                           SetError(1, "Failed to save role permission. Please try again later.");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save role permission. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_U_ModifyRolePermission", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _U_GetRoles(int CompanyID, int User, out Struct_UserRole Struct_Role)
       {
           bool ret = false;
           Struct_Role = new Struct_UserRole();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_GetRoles";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@User", User);
               
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {

                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_Role.Roles = reader.GetString(0);
                       else
                           Struct_Role.Roles = "";

                   }

                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to get roles. Please try again later");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(1, "Failed to get roles . Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool _U_GetRolePermission(int CompanyID, int User, int RoleID, out Struct_UserRole Struct_Perm)
       {
           bool ret = false;
           Struct_Perm = new Struct_UserRole();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_GetRolePermission";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@user", User);
               this.AddSPIntParam("@RoleID", RoleID);
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {
                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_Perm.RoleName = reader.GetString(0);
                       else
                           Struct_Perm.RoleName = "";

                       if (!reader.IsDBNull(1))
                           Struct_Perm.HomePage = reader.GetInt32(1);
                       else
                           Struct_Perm.HomePage = 0; 

                   }
                   reader.NextResult();
                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_Perm.RolePermissions = reader.GetString(0);
                       else
                           Struct_Perm.RolePermissions = "";

                   }

                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to get role permissions. Please try again later");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(1, "Failed to get role permissions. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }
       public bool _U_GetUsers(int CompanyID, int User, out Struct_UserRole Struct_Users)
       {
           bool ret = false;
           Struct_Users = new Struct_UserRole();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_GetUsers";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", CompanyID);
               this.AddSPIntParam("@user", User);
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {

                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_Users.Users = reader.GetString(0);
                       else
                           Struct_Users.Users = "";

                   }

                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");
                   switch(retcode){
                       case 0: 
                           ret = true;
                           break;
                       default:
                           SetError(1, "Failed to get users. Please try again later");
                           break;
                   }

               }
           }
           catch (Exception e)
           {
               SetError(1, "Failed to get users. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_C_GetCompanyDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }
       public bool _U_AddModifyUser(int CompanyID, int User, int UserID, string UserName, string LoginID, int RoleID, byte[] Password,
           bool isPasswordRegenerated, bool isdeleted, int EmployeeID, string BranchIDs)
       {
           bool ret = false;
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_AddModifyUser";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", CompanyID);
               this.AddSPIntParam("@user", User);
               this.AddSPIntParam("@UserID", UserID);
               this.AddSPStringParam("@UserName", UserName);
               this.AddSPStringParam("@LoginID", LoginID);
               this.AddSPIntParam("@RoleID", RoleID);
               this.AddSPIntParam("@EmployeeID", EmployeeID);
               this.AddSPVarBinaryParam("@Password", Password);
               this.AddSPBoolParam("@isPasswordRegenerated", isPasswordRegenerated);
               this.AddSPBoolParam("@isdeleted", isdeleted);
               this.AddSPStringParam("@BranchIDs", BranchIDs);
               this.AddSPReturnIntParam("@return");

               if (this.ExecuteNonSP(spName) == 1)
               {
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       case 2:
                           SetError(2, "Login ID already exist in system.");
                           break;
                       default:
                           SetError(1, "Failed to save user. Please try again later");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save user. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "_U_AddModifyUser", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool GetItemMasterList(int companyID, int userID,int itemMasterID ,out ItemMasterList itemsMasterList)
       {
           itemsMasterList = new ItemMasterList();
           itemsMasterList.ItemsList = new List<ItemMaster>();
           string jsonString = string.Empty;
           bool ret = false;

           try
           {
               this.Connect(this.GetConnString());
               string spName = "GetItemMasterList";
               this.ClearSPParams();
               this.AddSPIntParam("@companyID", companyID);
               this.AddSPIntParam("@UserID", userID);
               this.AddSPIntParam("@ItemMasterID", itemMasterID);
               this.AddSPReturnIntParam("@return");
               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {
                   while (reader.Read())
                   {
                       jsonString += reader.GetString(0);
                   }

                   reader.Close();

                   itemsMasterList.ItemsList = Newtonsoft.Json.JsonConvert.DeserializeObject<List<ItemMaster>>(jsonString);
               }

               int retcode = this.GetOutValueInt("@return");

               switch (retcode)
               {
                   case 1: ret = true;
                       break;
                   default: SetError(-1, "Failed to get Items List. Please try again later");
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

       public bool AddEditItemMaster(int companyID, int userID, int UserBranchID,int itemMasterID,ref ItemMaster itemMaster)
       {
           bool ret = false;

           try
           {
               this.Connect(this.GetConnString());
               string spName = "AddEditItemMaster";
               this.ClearSPParams();
               this.AddSPIntParam("@companyID", companyID);
               this.AddSPIntParam("@UserID", userID);
               this.AddSPIntParam("@UserBranchID", UserBranchID);
               this.AddSPIntParam("@ItemMasterID", itemMasterID);
               this.AddSPStringParam("@itemMasterObj", Newtonsoft.Json.JsonConvert.SerializeObject(itemMaster));
               this.AddSPReturnIntParam("@return");
               this.ExecuteNonSP(spName);
               int retcode = this.GetOutValueInt("@return");

               switch (retcode)
               {
                   case 1: ret = true;
                       break;
                   case -2: SetError(-2, "Mandatory fileds are not entered. Failed to add new Item.");
                       break;
                   case -3: SetError(-3, "Item with same Item Code already exists.");
                       break;
                   default: SetError(-1, "Failed to add/Edit Item. Please try again later");
                       break;
               }
           }
           catch (Exception ex)
           {
               ret = false;
               SetError(-1, "Failed to add/Edit Item. Please try again later");
               Utils.Write(ex);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool GetEmployeeList(int companyID, int userID, bool isShort, out JsonResults EmployeeList)
       {
           EmployeeList = new JsonResults();
           bool ret = false;

           try
           {
               this.Connect(this.GetConnString());
               string spName = "GetEmployeeList";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", companyID);
               this.AddSPIntParam("@user", userID);
               this.AddSPBoolParam("@isShort", isShort);
               this.AddSPReturnIntParam("@return");
               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {
                   while (reader.Read())
                   {
                       if (!reader.IsDBNull(0))
                            EmployeeList.JSonstring = reader.GetString(0);
                   }

                   reader.Close();
               }

               int retcode = this.GetOutValueInt("@return");

               switch (retcode)
               {
                   case 0: ret = true;
                       break;
                   default: SetError(-1, "Failed to get Employee List. Please try again later");
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

       public bool SaveEmployeeMasterDetails(int CompanyID, int User, int EmployeeID, string EmployeeDetails, bool isDeleted, out Struct_Employee Struct_empl)
       {
           bool ret = false;
           Struct_empl = new Struct_Employee();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "SaveEmployeeMasterDetails";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", CompanyID);
               this.AddSPIntParam("@user", User);
               this.AddSPStringParam("@EmployeeDetails", EmployeeDetails);
               this.AddSPIntParam("@Employee", EmployeeID);
               this.AddSPBoolParam("@isDeleted", isDeleted);
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {
                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_empl.EmployeeID = reader.GetInt32(0);
                       else
                           Struct_empl.EmployeeID = 0;

                       if (!reader.IsDBNull(1))
                           Struct_empl.AddressID = reader.GetInt32(1);
                       else
                           Struct_empl.AddressID = 0;

                   }
                   reader.Close();
                   int retcode = this.GetOutValueInt("@return");
                   switch (retcode)
                   {
                       case 0:
                           ret = true;
                           break;
                       case 2:
                           SetError(2, "Can not deleted role, it is atteched to user(s).");
                           break;
                       case 3:
                           SetError(3, "Same role name is alrady exist.");
                           break;
                       default:
                           SetError(1, "Failed to save employee. Please try again later.");
                           break;
                   }
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save employee. Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "SaveEmployeeMasterDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool GetEmployeeMasterDetails(int CompanyID, int User, int EmployeeID, out Struct_Employee Struct_empl)
       {
           bool ret = false;
           Struct_empl = new Struct_Employee();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "GetEmployeeMasterDetails";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", CompanyID);
               this.AddSPIntParam("@User", User);
               this.AddSPIntParam("@Employee", EmployeeID);

               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {

                   while (reader.Read())
                   {

                       if (!reader.IsDBNull(0))
                           Struct_empl.EmployeeDetails = reader.GetString(0);
                       else
                           Struct_empl.EmployeeDetails = "";

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
               SetError(1, "Failed to get employee . Please try again later");
               Utils.Write(0, 0, "AdminManagerSP", "GetEmployeeMasterDetails", "", "", e);
           }
           finally
           {
               this.ClearSPParams();
               this.Disconnect();
           }
           return ret;
       }

       public bool GetPickLists(int companyID, int userID, string PickListName, out JsonResults plist)
       {
           plist = new JsonResults();
           bool ret = false;

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
                   while (reader.Read())
                   {
                       if (!reader.IsDBNull(0))
                           plist.JSonstring = reader.GetString(0);
                   }

                   reader.Close();
               }

               int retcode = this.GetOutValueInt("@return");

               switch (retcode)
               {
                   case 1: ret = true;
                       break;
                   default: SetError(-1, "Failed to get Position List. Please try again later");
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

       public bool GetUserBranch(int companyID, int user, int UserID, bool EncludAllBranch, out JsonResults plist)
       {
           plist = new JsonResults();
           bool ret = false;

           try
           {
               this.Connect(this.GetConnString());
               string spName = "GetUserBranch";
               this.ClearSPParams();
               this.AddSPIntParam("@Company", companyID);
               this.AddSPIntParam("@user", user);
               this.AddSPIntParam("@UserID", UserID);
               this.AddSPBoolParam("@EncludAllBranch", EncludAllBranch);
               this.AddSPReturnIntParam("@return");
               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {
                   while (reader.Read())
                   {
                       if (!reader.IsDBNull(0))
                           plist.JSonstring = reader.GetString(0);
                   }

                   reader.Close();
               }

               int retcode = this.GetOutValueInt("@return");

               switch (retcode)
               {
                   case 0: ret = true;
                       break;
                   default: SetError(-1, "Failed to get user branch. Please try again later");
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

       public bool SearchItems(int companyID, int userID, int branchID, string searchText, out JsonResults customerList)
       {
           customerList = new JsonResults();
           bool ret = false;

           try
           {
               this.Connect(this.GetConnString());
               string spName = "SearchItems";
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
                   default: SetError(-1, "Failed to get Items List. Please try again later");
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


    }
}
