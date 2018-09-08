
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
ROLLBACK

--Added by Mahesh On 22nd Aug 18
BEGIN TRAN
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

ROLLBACK


