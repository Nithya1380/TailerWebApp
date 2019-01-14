using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Model
{
    public class Struct
    {
    }

    public class Struct_LoginUser
    {
        public string userName { get; set; }
        public string loginId { get; set; }
        public int failedAttempts { get; set; }
        public string userNode { get; set; }
        public int RoleID { get; set; }
        public string loginstatus { get; set; }
        public int CompanyID { get; set; }
        public string rolescope { get; set; }
        public string Landingpage { get; set; }
        public DateTime lastlogindate { get; set; }
        public string lastlogindateString { get; set; }
        public DateTime currentlogindate { get; set; }
        public int UserId { get; set; }
        public int UserType { get; set; }
        public int UserPrimaryKey { get; set; }
        public string RoleName { get; set; }
        public bool Is_Password_Regenerated { get; set; }
        public string mainMenuList { get; set; }
        public string subMenuList { get; set; }
        public string subSubMenuList { get; set; }
        public DateTime PASSWD_EXPIRY { get; set; }
        public string TimeZone { get; set; }
        public int roleType { get; set; }
        public int SessionOutTime { get; set; }
        public bool IsSSOLogin { get; set; }
        public string UserSessionID { get; set; }
        public bool enableAutoSessionOut { get; set; }

    }

    public class BranchDetail
    {
        public int BranchID { get; set; }
        public string BranchName { get; set; }
    }

    public class CustomerMaster: JsonResults
    {
        public CustomerAccount CustomerAccount { get; set; }
        public Customer Customer { get; set; }
        public CustomerSupply CustomerSupply { get; set; }
        public List<CustomerBranches> CustomerBranches { get; set; }
    }

    public class CustomerAccount
    {
        public int CompanyID{get;set;}
        public int CustomerMasterID {get;set;}
        public string AccountCode {get;set;}
        public string AccountName {get;set;}
        public bool IsCommonAccount {get;set;}
        public string IsActive {get;set;}
        public string AccountType {get;set;}
        public string OpeningBalance {get;set;}
        public string ClosingBalance{get;set;}
        public string ParentGroup {get;set;}
        public string AccountCategory {get;set;}
        public string AccountCreatedDate{get;set;}
        public string PartyAlert {get;set;}
        public bool IsTDSApplicable {get;set;}
        public string TDSCategory {get;set;}
        public string TDSDepriciation {get;set;}
        public string Default{get;set;}
        public string Reverse {get;set;}
        public string Sequence {get;set;}
        public string Sh6Group {get;set;}
        public string Sh6AccountNumber { get; set; }
    }

    public class Customer
    {
       public int CustomerID { get; set; }
       public int CompanyID{get;set;}
       public string Gender {get;set;}
       public string FullName{get;set;}
       public string FirstName {get;set;}
       public string MiddleName {get;set;}
       public string SurName {get;set;}
       public string ContactPerson {get;set;}
       public string BirthDate {get;set;}
       public string OpenDate {get;set;}
       public string CustomerAddressID {get;set;}
       public string PANNumber {get;set;}
       public string ReferenceNumber {get;set;}
       public string Remarks {get;set;}
       public string AnnDate {get;set;}
       public string SRName {get;set;}
       public string CustomerCardNumber { get; set; }
       public string Address1{ get; set; }
       public string Address2{ get; set; }
       public string City{ get; set; }
       public string State{ get; set; }
       public string Pincode{ get; set; }
       public string MobileNo{ get; set; }
       public string HomePhoneNo{ get; set; }
       public string EmailID { get; set; }
       public string CustomerPhoto { get; set; }
    }

    public class CustomerSupply
    {
        public int CustomerMasterID {get;set;}
        public int CompanyID {get;set;}
   	    public string SupplierCode {get;set;}
        public string SupplierName {get;set;}
        public string SupplierType {get;set;}
	    public string SupplierCategory {get;set;}
        public string CSTNumber {get;set;}
        public string CSTDate {get;set;}
        public string STDate {get;set;}
        public string STNumber {get;set;}
        public string GSTINNumber{get;set;}
        public string TINNumber {get;set;}
        public string VATNumber {get;set;}
        public string SupplierPANNumber {get;set;}
        public string LessVATPercent {get;set;}
        public string MarkUpPercent {get;set;}
        public string MarkDownPercent {get;set;}
        public string CreditDays { get; set; }
    }

    public class CustomerBranches
    {
        public int CompanyID { get; set; }
        public int BranchID { get; set; }
        public string BranchName { get; set; }
    }

    public class CustomerPickLists : JsonResults
    {
        public CustomerPickLists()
        {
            this.AccountCategory = new List<PickList>();
            this.AccountDateCategory = new List<PickList>();
            this.AccountParentType = new List<PickList>();
            this.AccountReverse = new List<PickList>();
            this.AccountSch6Group = new List<PickList>();
            this.AccountTDSCategory = new List<PickList>();
            this.AccountTDSDefault = new List<PickList>();
            this.AccountType = new List<PickList>();
            this.City = new List<PickList>();
            this.Country = new List<PickList>();
            this.SRNames = new List<PickList>();
            this.State = new List<PickList>();
            this.SupplierCategories = new List<PickList>();
            this.SupplierTypes = new List<PickList>();
        }
        public List<PickList> AccountType { get; set; }
        public List<PickList> AccountParentType { get; set; }
        public List<PickList> AccountCategory { get; set; }
        public List<PickList> AccountDateCategory { get; set; }
        public List<PickList> AccountTDSCategory { get; set; }
        public List<PickList> AccountTDSDefault { get; set; }
        public List<PickList> AccountReverse { get; set; }
        public List<PickList> AccountSch6Group { get; set; }
        public List<PickList> Country { get; set; }
        public List<PickList> State { get; set; }
        public List<PickList> City { get; set; }
        public List<PickList> SRNames { get; set; }
        public List<PickList> SupplierTypes { get; set; }
        public List<PickList> SupplierCategories { get; set; }
   }

    public class PickList
    {
        public string PickListLabel { get; set; }
        public string PickListValue { get; set; }
    }

    public class GenericPickList : JsonResults
    {
        public List<PickList> PickListItems { get; set; }
    }

    public class JsonResults
    {
        public int ErrorCode { get; set; }
        public string ErrorMessage { get; set; }
        public string JSonstring { get; set; }
        public string JSonstring2 { get; set; }
        public int OutValue { get; set; }
    }

    public class ItemMaster
    {
        public int ItemmasterID { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string ItemGroup { get; set; }
        public string ItemAlias{ get; set; }
        public string ItemPrice { get; set; }
        public string TotalGST { get; set; } 
		public string SGSTPer { get; set; }
		public string SGST { get; set; }
		public string CGSTPer { get; set; }
		public string CGST { get; set; }
		public string BillAmt { get; set; }
    }

    public class ItemMasterList:JsonResults
    {
        public List<ItemMaster> ItemsList { get; set; }
    }


    public class InvoicePickLists : JsonResults
    {
        public InvoicePickLists()
        {
            this.AccountSeries = new List<PickList>();
            this.InvoiceLessCategory = new List<PickList>();
            this.InvoiceTaxCategory = new List<PickList>();
            this.Designers = new List<EmployeePositions>();
            this.Masters = new List<EmployeePositions>();
            this.SalesReps = new List<EmployeePositions>();
            this.InvoicePaymentMethod = new List<PickList>(); 
        }
        public List<PickList> AccountSeries { get; set; }
        public List<PickList> InvoiceLessCategory { get; set; }
        public List<PickList> InvoiceTaxCategory { get; set; }
        public List<PickList> InvoicePaymentMethod { get; set; } 
        public List<EmployeePositions> Masters { get; set; }
        public List<EmployeePositions> Designers { get; set; }
        public List<EmployeePositions> SalesReps { get; set; }

    }
    public class EmployeePositions
    {
        public int EmployeeMasterID { get; set; }
        public string EmployeeName { get; set; }
    }

    public class CustomerInvoice
    {
        public string InvoiceSeries { get; set; }
        public string MobileNumber { get; set; }
        public string BillNumber { get; set; }
        public string InvoiceDate { get; set; }
        public int CustomerID { get; set; }
        public string TrailDate { get; set; }
        public string TrailTime { get; set; }
        public int SalesRepID { get; set; }
        public int MasterID { get; set; }
        public int DesignerID { get; set; }
        public string DeliveryDate { get; set; }
        public string DeliveryTime { get; set; }
        public string PaymentNumber { get; set; }
        public string InvoiceLessCategory { get; set; }
        public string LessRs { get; set; }
        public string LessRsAmount { get; set; }
        public string Remarks { get; set; }
        public string NetAmount { get; set; }


    }

    public class CustomerInvoiceList
    {
        public int ItemMasterID { get; set; }
        public string ItemCode { get; set; }
        public string ItemDescription { get; set; }
        public string ItemQuantity { get; set; }
        public string ItemPrice { get; set; }
        public string ItemDiscount { get; set; }
        public string GST { get; set; }
        public string SGST { get; set; }
        public string AmountPending { get; set; }
        public string ItemDiscountPer { get; set; }
        public string GSTP { get; set; }
        public string SGSTP { get; set; }
    }
    public class ST_MeasurementField 
    {
       public int MeasurementFieldID {get;set;}
	   public string FieldName {get;set;}
	   public bool isRrepeat {get;set;}
	   public int OrderBy	{get;set;}
	   public string ValItemGroup {get;set;}
	   public string Lang {get;set;}
    }

    public class ST_Measurement : JsonResults
    {
        public List<ST_MeasurementField> MeasurementList { get; set; }
    }
}
