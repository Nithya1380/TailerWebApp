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
    class AdminManagerSP : KanDelegate
    {

       public bool  _C_GetCompanyDetails(int CompanyID, int User, out Struct_Company Struct_Company){
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

    }
}
