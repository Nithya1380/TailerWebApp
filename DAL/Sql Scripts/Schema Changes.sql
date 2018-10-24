
BEGIN TRAN
   CREATE TABLE CompanyMaster
   (
      CompanyID	INT NOT NULL PRIMARY KEY IDENTITY(1,1),
      CompanyName VARCHAR(50),
      CompanyCode VARCHAR(5),
      AddressID	INT,
      CreatedBy	INT,
      CreatedOn	DATETIME,
      IsDeleted	BIT,
      DeletedBy	INT,
      DeletedOn	DATETIME
   )

   GO
   CREATE TABLE HomePages
   (
	  HomePageID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	  HomePageName VARCHAR(30) NOT NULL,
	  HomePageURL VARCHAR(100) NOT NULL
   )

   GO
   CREATE TABLE Roles
   (
	RoleID	INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    CompanyID	INT NOT NULL,
    RoleName	VARCHAR(50),
    isDeleted	BIT,
    CreatedOn	DATETIME,
    CreatedBy	INT,
    DeletedOn	DATETIME,
    DeletedBy	INT,
	HomePage    INT,
	CONSTRAINT FK_Roles_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
	CONSTRAINT FK_Roles_HomePage FOREIGN KEY(HomePage) REFERENCES HomePages(HomePageID)
   )

   GO
   CREATE TABLE Users
   (
	UserID	INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    CompanyID	INT NOT NULL,
    LoginID		VARCHAR(50),
    password	VARBINARY(50),
    RoleID		INT NOT NULL,
    Status		VARCHAR(10),
    isDeleted	BIT,
    isPasswordRegenerated	BIT,
    PassowordExpireOn	DATETIME,
    CreatedOn	DATETIME,
    CreatedBy	INT,
    DeletedOn	DATETIME,
    DeletedBy	INT,
	CONSTRAINT FK_Users_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
	CONSTRAINT FK_Users_RoleID FOREIGN KEY(RoleID) REFERENCES Roles(RoleID),
	CONSTRAINT FK_Users_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_Users_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
   )

   GO
   CREATE TABLE Address
   (
     AddressID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
     CompanyID INT,
     Address1 VARCHAR(100),
     Address2 VARCHAR(100),
     City VARCHAR(50),
     State VARCHAR(30),
     Pincode VARCHAR(10),
     OfficePhoneNo VARCHAR(20),
     MobileNo VARCHAR(20),
     AlternateNo VARCHAR(20),
     HomePhoneNo VARCHAR(20),
     EmailID VARCHAR(100),
     Website VARCHAR(100),
     CreatedOn DATETIME,
     CreatedBy	INT,
     isDeleted	BIT,
     DeletedOn	DATETIME,
     DeletedBy	INT,
	 CONSTRAINT FK_Address_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID)
   )
   GO
   ALTER TABLE CompanyMaster ADD CONSTRAINT FK_CompanyMaster_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
   GO
   ALTER TABLE CompanyMaster ADD CONSTRAINT FK_CompanyMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
   GO
   ALTER TABLE Roles ADD CONSTRAINT FK_Roles_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
   GO
   ALTER TABLE Roles ADD CONSTRAINT FK_Roles_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
   GO
   ALTER TABLE Address ADD CONSTRAINT FK_Address_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
   GO
   ALTER TABLE Address ADD CONSTRAINT FK_Address_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
  
  GO
  CREATE TABLE PermissionListMaster
  (
	PermissionIndexID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    ParentPermissionIndexID	INT,
    PermissionDesc VARCHAR(100),
    Status VARCHAR(10),
    isDeleted	BIT,
    CreatedOn	DATETIME,
    CreatedBy	INT,
    DeletedOn	DATETIME,
    DeletedBy	INT,
	CONSTRAINT FK_PermissionListMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_PermissionListMaster_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
  )

  GO
  CREATE TABLE CompanyPermissions
  (
	CompanyPermissionID	INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    PermissionIndexID INT NOT NULL,	
    isDeleted	BIT,
    CreatedOn	DATETIME,
    CreatedBy	INT,
    DeletedOn	DATETIME,
    DeletedBy	INT,
	CONSTRAINT FK_CompanyPermissions_PermissionIndexID FOREIGN KEY(PermissionIndexID) REFERENCES PermissionListMaster(PermissionIndexID),
	CONSTRAINT FK_CompanyPermissions_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_CompanyPermissions_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
  )

  GO
  CREATE TABLE RoleScope
  (
	RolesScopeID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    RoleID INT NOT NULL,
    CompanyPermissionID	INT,
	CompanyID INT,	
    isDeleted	BIT,
    CreatedOn	DATETIME,
    CreatedBy	INT,
    DeletedOn	DATETIME,
    DeletedBy	INT,
	CONSTRAINT FK_RoleScope_RoleID FOREIGN KEY(RoleID) REFERENCES Roles(RoleID),
	CONSTRAINT FK_RoleScope_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
	CONSTRAINT FK_RoleScope_CompanyPermissionID FOREIGN KEY(CompanyPermissionID) REFERENCES CompanyPermissions(CompanyPermissionID),
	CONSTRAINT FK_RoleScope_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
	CONSTRAINT FK_RoleScope_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
  )

	GO
    CREATE TABLE [dbo].[_H_Login](
	[DB_SESSION_ID] [int] IDENTITY(1,1) NOT NULL,
	[LoginID] [varchar](100) NULL,
	[FailedPassword] [varchar](250) NULL,
	[IPAddress] [varchar](20) NULL,
	[LoginTime] [datetime] NULL,
	[LoginStatus] [tinyint] NULL,
	[LogoutTime] [datetime] NULL,
	[UserSessionID] [varchar](50) NULL,
	[ServerName] [varchar](50) NULL,
	[LoginType] [tinyint] NULL,
	[UserSystemInfo] [varchar](800) NULL,
	[CompanyID] [int] NULL,
	[UserID] [int] NULL,
	[LastAccessedTime] [datetime] NULL,
	[instanceName] [varchar](30) NULL,
	[initialInstance] [varchar](30) NULL,
	[CreatedOn] [datetime] NULL,
	[BrowserVersion] [varchar](100) NULL,
	[LoginSuccess] [bit] NULL,
	[OperatingSystem] [varchar](100) NULL,
	[Browser] [varchar](100) NULL,
	[SSOAuthKey] [varchar](100) NULL,
	 CONSTRAINT [PK__H_Login] PRIMARY KEY NONCLUSTERED 
	(
		[DB_SESSION_ID] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
	) ON [PRIMARY]

	GO
	ALTER TABLE [dbo].[_H_Login] ADD DEFAULT (getdate()) FOR [CreatedOn]
	GO
	ALTER TABLE [dbo].[_H_Login] ADD CONSTRAINT FK_H_Login_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID)


--Added by Mahesh On 22nd Aug 18
	GO
	CREATE TABLE BranchDetails(
		BranchID INT NOT NULL PRIMARY KEY IDENTITY(1,1),	--	PK(1,1)
		CompanyID INT, 	--	FK=> Company.CompanyID
		AddressID	INT,	--	FK=> Address.AddressID
		BranchName	VARCHAR(100),
		BranchLegalName VARCHAR(100),
		BranchCode	VARCHAR(5),
		BranchSTNo VARCHAR(40),
		BranchITNo VARCHAR(40),
		BarnchCSTNo VARCHAR(40),
		BranchExciseNo VARCHAR(40),
		BranchContactPer VARCHAR(40),
		BranchCreatedDate DATETIME,
		CreatedBy	INT,
		CreatedOn	DATETIME DEFAULT getdate(),
		isDeleted	BIT,
		DeletedBy	INT,
		DeletedOn	DATETIME,
		CONSTRAINT FK_CompanyMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_Address_AddressID FOREIGN KEY(AddressID) REFERENCES Address(AddressID),
		CONSTRAINT FK_Users_UserID FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
	)

	GO
	ALTER TABLE CompanyMaster 
		ADD	CompLegalName VARCHAR(40),
			CompCreatedDate DATETIME,
			CompBusType CHAR(1),
			TDSNo VARCHAR(50),
			TDSCircle VARCHAR(50),
			TDSChallanNo VARCHAR(50),
			PanNo VARCHAR(15),
			CSTNo VARCHAR(30),
			CSTDate DATETIME

	GO
	ALTER TABLE BranchDetails
		ADD ShortName VARCHAR(50),
			BranchNo VARCHAR(20),
			BranchType VARCHAR(5),
			BranchGSTIN VARCHAR(40),
			BranchTINNo VARCHAR(40),
			BranchSTDate DATETIME,
			ExciseAddress VARCHAR(40),
			ExciseDivision VARCHAR(40),
			ExciseRange VARCHAR(40),
			ExciseState VARCHAR(40),
			PeriodFormDate DATETIME,
			PeriodToDate DATETIME,
			BranchDivision VARCHAR(40)

	GO
	CREATE TABLE CustomerMaster
	(
		CustomerMasterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CompanyID INT NOT NULL,
		CreatedBy INT,
		CreatedOn DATETIME,
		Gender VARCHAR(10),
		FullName VARCHAR(100),
		FirstName VARCHAR(50),
		MiddleName VARCHAR(20),
		SurName VARCHAR(20),
		ContactPerson VARCHAR(100),
		BirthDate DATE,
		OpenDate DATE,
		CustomerAddressID INT,
		PANNumber VARCHAR(20),
		ReferenceNumber VARCHAR(100),
		Remarks VARCHAR(100),
		AnnDate DATETIME,
		SRName VARCHAR(50),
		CustomerCardNumber VARCHAR(100),
		CONSTRAINT FK_CustomerMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_CustomerMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_CustomerMaster_CustomerAddressID  FOREIGN KEY(CustomerAddressID) REFERENCES Address(AddressID)    
	)

	GO
	CREATE TABLE AccountsMaster
	(
		AccountMasterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CompanyID INT NOT NULL,
		CustomerMasterID INT NOT NULL,
		CreatedBy INT,
		CreatedOn DATETIME,
		AccountCode VARCHAR(20) NOT NULL,
		AccountName VARCHAR(100) NOT NULL,
		IsCommonAccount BIT,
		IsActive BIT,
		AccountType VARCHAR(50),
		OpeningBalance MONEY,
		ClosingBalance MONEY,
		ParentGroup VARCHAR(50),
		AccountCategory VARCHAR(50),
		AccountCreatedDate DATETIME,
		PartyAlert VARCHAR(50),
		IsTDSApplicable BIT,
		TDSCategory VARCHAR(50),
		TDSDepriciation VARCHAR(50),
		[Default] VARCHAR(50),
		[Reverse] VARCHAR(50),
		[Sequence] VARCHAR(20),
		Sh6Group VARCHAR(50),
		Sh6AccountNumber VARCHAR(50),
		CONSTRAINT FK_AccountsMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_AccountsMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_AccountsMaster_CustomerMasterID FOREIGN KEY(CustomerMasterID) REFERENCES CustomerMaster(CustomerMasterID)
	)


	GO
	CREATE TABLE CustomerPhoto
	(
	   CustomerPhotoID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	   CustomerMasterID INT NOT NULL,
	   CustomerPhoto VARBINARY(MAX),
	   CompanyID INT NOT NULL,
	   CreatedBy INT,
	   CreatedOn DATETIME,
	   CONSTRAINT FK_CustomerPhoto_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
	   CONSTRAINT FK_CustomerPhoto_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
	   CONSTRAINT FK_CustomerPhoto_CustomerMasterID FOREIGN KEY(CustomerMasterID) REFERENCES CustomerMaster(CustomerMasterID)
	)

	GO
	CREATE TABLE CustomerSupplierMaster
	(
		SupplierMasterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CustomerMasterID INT NOT NULL,
		CompanyID INT NOT NULL,
		CreatedBy INT,
		CreatedOn DATETIME,
		SupplierCode VARCHAR(20),
		SupplierName VARCHAR(100),
		SupplierType VARCHAR(20),
		SupplierCategory VARCHAR(50),
		CSTNumber VARCHAR(30),
		CSTDate DATETIME,
		STDate DATETIME,
		STNumber VARCHAR(30),
		GSTINNumber VARCHAR(30),
		TINNumber VARCHAR(30),
		VATNumber VARCHAR(30),
		SupplierPANNumber VARCHAR(30),
		LessVATPercent FLOAT,
		MarkUpPercent FLOAT,
		MarkDownPercent FLOAT,
		CreditDays INT,
		CONSTRAINT FK_CustomerSupplierMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_CustomerSupplierMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_CustomerSupplierMaster_CustomerMasterID FOREIGN KEY(CustomerMasterID) REFERENCES CustomerMaster(CustomerMasterID)
	)

	GO
	CREATE TABLE CustomerBranchMaster
	(
		CustomerBranchMasterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CustomerMasterID INT NOT NULL,
		BranchID INT NOT NULL,
		CompanyID INT NOT NULL,
		CreatedBy INT,
		CreatedOn DATETIME,
		CONSTRAINT FK_CustomerBranchMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_CustomerBranchMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_CustomerBranchMaster_CustomerMasterID FOREIGN KEY(CustomerMasterID) REFERENCES CustomerMaster(CustomerMasterID)
	)


	GO
	CREATE TABLE PickListMaster
	(
		PickListMasterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		PickListName VARCHAR(50)
	)

	GO
	CREATE TABLE PickListValues
	(
		PickListValueID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		PickListMasterID INT NOT NULL,
		PickListValue VARCHAR(50),
		PickListLabel VARCHAR(50),
		CONSTRAINT FK_PickListValues_PickListMasterID FOREIGN KEY(PickListMasterID) REFERENCES PickListMaster(PickListMasterID)
	)

	ALTER TABLE PermissionListMaster ADD IsMenu BIT
	ALTER TABLE CompanyPermissions ADD CompanyID INT
	ALTER TABLE CompanyPermissions ADD CONSTRAINT FK_CompanyPermissions_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID)
	ALTER TABLE Users ADD UserName VARCHAR(150)

	GO
	CREATE TABLE EmployeeMaster
	(
		EmployeeMasterID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CompanyID INT NOT NULL,
		CreatedBy INT,
		CreatedOn DATETIME,
		Gender VARCHAR(10),
		FirstName VARCHAR(50),
		MiddleName VARCHAR(20),
		LastName VARCHAR(50),
		BirthDate DATE,
		HireDate DATE,
		AddressID INT,
		Position VARCHAR(50), 
		isDeleted BIT,
		DeletedOn DATETIME,
		DeletedBy INT,
		CONSTRAINT FK_EmployeeMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_EmployeeMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_EmployeeMaster_CustomerAddressID  FOREIGN KEY(AddressID) REFERENCES Address(AddressID),
		CONSTRAINT FK_EmployeeMaster_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)      
	)

	GO
	CREATE TABLE UserBranch(
		UserBranchID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
		CompanyID INT NOT NULL,
		UserID INT NOT NULL,
		BranchID INT,
		CreatedBy INT,
		CreatedOn DATETIME,
		isDeleted BIT,
		DeletedBy INT,
		DeletedOn DATETIME,
		CONSTRAINT FK_UserBranch_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_UserBranch_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_UserBranch_UserID FOREIGN KEY(UserID) REFERENCES Users(UserID),
		CONSTRAINT FK_UserBranch_BranchID  FOREIGN KEY(BranchID) REFERENCES BranchDetails(BranchID),
		CONSTRAINT FK_UserBranch_DeletedBy FOREIGN KEY(DeletedBy) REFERENCES Users(UserID)
	)

	ALTER TABLE Users ADD EmployeeID INT
	ALTER TABLE Users ADD CONSTRAINT FK_Users_EmployeeID  FOREIGN KEY(EmployeeID) REFERENCES EmployeeMaster(EmployeeMasterID)


	GO
	CREATE TABLE ItemMaster
	   (
		ItemmasterID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
		CompanyID	INT NOT NULL,
		ItemCode	VARCHAR(50),
		ItemDescription	VARCHAR(200),
		ItemGroup	VARCHAR(50),
		ItemAlias	VARCHAR(100),
		ItemPrice   MONEY,
		isDeleted	BIT,
		CreatedOn	DATETIME,
		CreatedBy	INT,
		DeletedOn	DATETIME,
		DeletedBy	INT
		CONSTRAINT FK_ItemMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_ItemMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID)
	   )

	GO
	ALTER TABLE CustomerMaster ADD BranchID INT
GO
ALTER TABLE CustomerMaster ADD CONSTRAINT FK_CustomerMaster_BranchID FOREIGN KEY(BranchID) REFERENCES BranchDetails(BranchID)

GO
SET IDENTITY_INSERT dbo.PermissionListMaster ON
SET IDENTITY_INSERT dbo.HomePages ON

	GO
	CREATE TABLE MeasurementMaster
	(
		MeasurementMasterID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
		CompanyID INT,
		AccountID INT,
		MeasuNo VARCHAR(20),
		CreatedOn DATETIME DEFAULT GETDATE(),
		CreatedBy INT,
		MeasCreatedOn DATETIME,
		ItemID INT,
		ItemDesc VARCHAR(30),
		BodyFit VARCHAR(20),
		Remark VARCHAR(50),
		TrialDate DATETIME,
		DeliDate DATETIME,
		MeasDate DATETIME,
		Qty INT,
		MeasWeight FLOAT,
		text1 FLOAT,
		text2 FLOAT,
		text3 FLOAT,
		text4 VARCHAR(20),
		text5 VARCHAR(30),
		text6 VARCHAR(40),
		text7 FLOAT,
		text8 FLOAT,
		text9 FLOAT,
		text10 FLOAT,
		text11 FLOAT,
		text12 FLOAT,
		text13 FLOAT,
		text14 FLOAT,
		text15 FLOAT,
		text16 FLOAT,
		text17 FLOAT,
		text18 FLOAT,
		text19 FLOAT,
		text20 FLOAT,
		text21 FLOAT,
		text22 FLOAT,
		text23 VARCHAR(20),
		text24 FLOAT,
		text25 FLOAT,
		text26 FLOAT,
		text27 FLOAT,
		text28 FLOAT,
		text29 FLOAT,
		text30 FLOAT,
		text31 FLOAT,

		CONSTRAINT FK_MeasurementMaster_CompanyID FOREIGN KEY(CompanyID) REFERENCES CompanyMaster(CompanyID),
		CONSTRAINT FK_MeasurementMaster_CreatedBy FOREIGN KEY(CreatedBy) REFERENCES Users(UserID),
		CONSTRAINT FK_MeasurementMaster_AccountID FOREIGN KEY(AccountID) REFERENCES AccountsMaster(AccountMasterID),
		CONSTRAINT FK_MeasurementMaster_ItemID FOREIGN KEY(ItemID) REFERENCES ItemMaster(ItemmasterID),
	)


ROLLBACK TRAN

