SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_C_AddModifyBranch]
	@CompanyID INT,
	@user INT,
	@BranchID INT,
	@BranchDetails VARCHAR(4000),
	@AddressDetails VARCHAR(2000),
	@Password VARBINARY(50),
	@UserLoginId VARCHAR(50)
AS
-- =============================================
-- Author:	Mahesh
-- Create date: 08th Sep 2018
-- Description:	Add Modify Branch
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @AddressID INT, @Role INT, @EmployeeID INT, @Home INT

    -- Insert statements for procedure here
	IF ISNULL(@CompanyID,0) = 0
		RETURN 1

	IF ISNULL(@BranchID,0)=0
	BEGIN
		INSERT INTO [Address](
				CompanyID,
				Address1,
				Address2,
				City,
				State,
				Pincode,
				OfficePhoneNo,
				MobileNo,
				AlternateNo,
				HomePhoneNo,
				EmailID,
				Website,
				CreatedBy
				)
		
		SELECT	@CompanyID,
				Address1,
				Address2,
				City,
				State,
				Pincode,
				OfficePhoneNo,
				MobileNo,
				AlternateNo,
				HomePhoneNo,
				EmailID,
				Website,
				@user
		FROM OPENJSON(@AddressDetails)  
			WITH (
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
			 Website VARCHAR(100)
			) 

		SET @AddressID = scope_identity()

		INSERT INTO BranchDetails(
			CompanyID,
			AddressID,
			BranchName,
			BranchLegalName,
			BranchCode,
			BranchSTNo,
			BranchITNo,
			BarnchCSTNo,
			BranchExciseNo,
			BranchContactPer,
			BranchCreatedDate,
			CreatedBy,
			ShortName,
			BranchNo,
			BranchType,
			BranchGSTIN,
			BranchTINNo,
			BranchSTDate,
			ExciseAddress,
			ExciseDivision,
			ExciseRange,
			ExciseState,
			PeriodFormDate,
			PeriodToDate,
			BranchDivision
		)
		SELECT
			@CompanyID,
			@AddressID, 
			BranchName,
			BranchLegalName,
			BranchCode,
			BranchSTNo,
			BranchITNo,
			BarnchCSTNo,
			BranchExciseNo,
			BranchContactPer,
			BranchCreatedDate,
			@user,
			ShortName,
			BranchNo,
			BranchType,
			BranchGSTIN,
			BranchTINNo,
			BranchSTDate,
			ExciseAddress,
			ExciseDivision,
			ExciseRange,
			ExciseState,
			PeriodFormDate,
			PeriodToDate,
			BranchDivision
		FROM OPENJSON(@BranchDetails)  
			WITH ( 
				BranchName	VARCHAR(100),
				BranchLegalName VARCHAR(100),
				BranchCode	VARCHAR(5),
				BranchSTNo VARCHAR(40),
				BranchITNo VARCHAR(40),
				BarnchCSTNo VARCHAR(40),
				BranchExciseNo VARCHAR(40),
				BranchContactPer VARCHAR(40),
				BranchCreatedDate DATETIME,
				ShortName VARCHAR(50),
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
			)

		IF EXISTS(SELECT TOP 1 1 FROM Roles WITH(NOLOCK) WHERE CompanyID = @CompanyID AND RoleName = 'Admin' AND ISNULL(isDeleted,0) = 0)
		BEGIN
			SELECT TOP 1 @Role = RoleID FROM Roles WITH(NOLOCK) WHERE CompanyID = @CompanyID AND RoleName = 'Admin' AND ISNULL(isDeleted,0) = 0
			
			INSERT INTO EmployeeMaster(CompanyID, CreatedBy, CreatedOn, FirstName, LastName, Position)
			VALUES(@CompanyID, @user, GETDATE(), 'Admin', 'Admin', 'Admin')

			SET @EmployeeID = scope_identity()

			INSERT INTO Users(CompanyID, LoginID, password, RoleID, Status, CreatedOn, CreatedBy, EmployeeID)
			VALUES(@CompanyID, @UserLoginId, @Password, @Role, 'Active', GETDATE(), @user, @EmployeeID)
		END
		ELSE
		BEGIN
			SELECT TOP 1 @Home = HomePageID FROM HomePages WITH(NOLOCK) WHERE HomePageURL = 'UI/Tailer/TailerHome.aspx'

			INSERT INTO Roles(CompanyID, RoleName, CreatedOn, CreatedBy, HomePage)
			VALUES(@CompanyID, 'Admin', GETDATE(), @user, @Home)

			SET @Role = scope_identity()

			INSERT INTO EmployeeMaster(CompanyID, CreatedBy, CreatedOn, FirstName, LastName)
			VALUES(@CompanyID, @user, GETDATE(), 'Admin', 'Admin')

			SET @EmployeeID = scope_identity()

			INSERT INTO Users(CompanyID, LoginID, password, RoleID, Status, CreatedOn, CreatedBy, EmployeeID)
			VALUES(@CompanyID, @UserLoginId, @Password, @Role, 'Active', GETDATE(), @user, @EmployeeID)
		END

	END
	ELSE IF ISNULL(@BranchID,0)>0
	BEGIN
		UPDATE BranchDetails
			SET BranchName = tempBranch.BranchName,
				BranchLegalName = tempBranch.BranchLegalName,
				BranchCode = tempBranch.BranchCode,
				BranchSTNo = tempBranch.BranchSTNo,
				BranchITNo = tempBranch.BranchITNo,
				BarnchCSTNo = tempBranch.BarnchCSTNo,
				BranchExciseNo = tempBranch.BranchExciseNo,
				BranchContactPer = tempBranch.BranchContactPer,
				BranchCreatedDate = tempBranch.BranchCreatedDate,
				ShortName = tempBranch.ShortName,
				BranchNo = tempBranch.BranchNo,
				BranchType = tempBranch.BranchType,
				BranchGSTIN = tempBranch.BranchGSTIN,
				BranchTINNo = tempBranch.BranchTINNo,
				BranchSTDate = tempBranch.BranchSTDate,
				ExciseAddress = tempBranch.ExciseAddress,
				ExciseDivision = tempBranch.ExciseDivision,
				ExciseRange = tempBranch.ExciseRange,
				ExciseState = tempBranch.ExciseState,
				PeriodFormDate = tempBranch.PeriodFormDate,
				PeriodToDate = tempBranch.PeriodToDate,
				BranchDivision = tempBranch.BranchDivision
			 FROM OPENJSON(@BranchDetails)  
					WITH ( 
						BranchName	VARCHAR(100),
						BranchLegalName VARCHAR(100),
						BranchCode	VARCHAR(5),
						BranchSTNo VARCHAR(40),
						BranchITNo VARCHAR(40),
						BarnchCSTNo VARCHAR(40),
						BranchExciseNo VARCHAR(40),
						BranchContactPer VARCHAR(40),
						BranchCreatedDate DATETIME,
						ShortName VARCHAR(50),
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
					) tempBranch
				WHERE BranchDetails.CompanyID = @CompanyID AND BranchDetails.BranchID = @BranchID

		UPDATE [Address]
			SET Address1 = tempAddress.Address1,
				Address2 = tempAddress.Address2,
				City = tempAddress.City,
				State = tempAddress.State,
				Pincode = tempAddress.Pincode,
				OfficePhoneNo = tempAddress.OfficePhoneNo,
				MobileNo = tempAddress.MobileNo,
				AlternateNo = tempAddress.AlternateNo,
				HomePhoneNo = tempAddress.HomePhoneNo,
				EmailID = tempAddress.EmailID,
				Website = tempAddress.Website
		FROM OPENJSON(@AddressDetails)  
			WITH (
			 AddressID INT,
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
			 Website VARCHAR(100)
			) tempAddress
		WHERE [Address].AddressID = tempAddress.AddressID
			AND [Address].CompanyID = @CompanyID
			--AND [Address].AddressID = @AddressID

	END
END
GO
