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

       public bool _C_AddModifyBranch(int CompanyID, int User, int BranchID, string BranchDetails, string AddressDetails)
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

       public bool _C_GetCompanyAndBranchList(int User, out Struct_Company Struct_Company)
       {
           bool ret = false;
           Struct_Company = new Struct_Company();
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_C_GetCompanyAndBranchList";
               this.ClearSPParams();
               this.AddSPIntParam("@User", User);
               this.AddSPReturnIntParam("@return");

               using (SqlDataReader reader = this.ExecuteSelectSP(spName))
               {

                   while (reader.Read())
                   {

                       if (reader["CompanyList"] != DBNull.Value)
                           Struct_Company.CompanyDetails = reader["CompanyList"].ToString();
                       else
                           Struct_Company.CompanyDetails = "";

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

       public bool _U_ModifyRolePermission(int CompanyID, int User, string RoleName, int RoleID, string PermissionAdded, string PermissionRemoved)
       {
           bool ret = false;
           try
           {

               this.Connect(this.GetConnString());
               string spName = "_U_ModifyRolePermission";
               this.ClearSPParams();
               this.AddSPIntParam("@CompanyID", CompanyID);
               this.AddSPIntParam("@User", User);
               this.AddSPStringParam("@RoleName", RoleName);
               this.AddSPIntParam("@RoleID", RoleID);
               this.AddSPStringParam("@PermissionAdded", PermissionAdded);
               this.AddSPStringParam("@PermissionRemoved", PermissionRemoved);
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
                           SetError(1, "Failed to save role permission. Please try again later");
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
       public bool _U_AddModifyUser(int CompanyID, int User, int UserID, string UserName, string LoginID, int RoleID, byte[] Password, bool isPasswordRegenerated, bool isdeleted)
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
               this.AddSPVarBinaryParam("@Password", Password);
               this.AddSPBoolParam("@isPasswordRegenerated", isPasswordRegenerated);
               this.AddSPBoolParam("@isdeleted", isdeleted);
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


    }
}
