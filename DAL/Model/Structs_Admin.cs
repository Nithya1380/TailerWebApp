﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{

    public class JSONReturnData
    {
        public int Outvalue;
        public int errorCode;
        public string errorMessage;
        public bool Outflag;
        public int SuccessCount;
        public int FailureCount;
        public string String_Outvalue;
        public int OrderID_subform;
        public string Str_OrderNo;
        public string MainWorldviewValue;

    }
    class Structs_Admin
    {
    }

    public class Struct_Company : JSONReturnData
    {
        public string CompanyDetails { get; set; }
        public string AddressDetails { get; set; }
        public string CompanyList { get; set; }
        public string BranchList { get; set; }
    }

    public class Struct_Branch : JSONReturnData
    {
        public string BranchDetails { get; set; }
        public string AddressDetails { get; set; }
    }

    public class Struct_UserRole : JSONReturnData
    {
        public string Roles { get; set; }
        public string RolePermissions { get; set; }
        public string Users { get; set; }
        public string RoleName { get; set; }
        public string EmployeeList { get; set; }
    }

    public class Struct_Employee : JSONReturnData
    {
        public int EmployeeID { get; set; }
        public int AddressID { get; set; }
        public string EmployeeDetails { get; set; }
    }

}
