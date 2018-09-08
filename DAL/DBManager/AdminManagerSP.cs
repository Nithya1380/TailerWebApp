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
               }
           }
           catch (Exception e)
           {
               SetError(-100, "Failed to save Company Details . Please try again later");
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

    }
}
