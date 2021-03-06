GO
/****** Object:  StoredProcedure [dbo].[SaveEmployeeMasterDetails]    Script Date: 27-Nov-2018 22:46:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SaveEmployeeMasterDetails] 
	@Company INT,
	@User INT,
	@Employee INT,
	@EmployeeDetails VARCHAR(MAX),
	@isDeleted BIT
AS
-- =============================================
-- Author:	Mahesh
-- Create date: 6 Oct 2018
-- Description:	Save Employee Master Details
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @AddressID INT

BEGIN TRY
 BEGIN TRAN
	IF ISNULL(@Employee,0) = 0
	BEGIN
		INSERT INTO Address(
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
			CompanyID,
			CreatedBy,
			CreatedOn
		)
		SELECT   
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
			 @Company,
			 @User,
			 GETDATE()
			FROM OPENJSON(@EmployeeDetails)  
		WITH (Address NVARCHAR(max) as json  
		) as B  
		CROSS APPLY openjson (B.Address)  
		with  
		(  
			Address1 VARCHAR(100),
			Address2 VARCHAR(100),
			City VARCHAR(50),
			State VARCHAR(30),
			Pincode VARCHAR(10),
			OfficePhoneNo VARCHAR(20),
			MobileNo VARCHAR(20),
			AlternateNo VARCHAR(20),
			HomePhoneNo VARCHAR(20),
			EmailID VARCHAR(100)  
		) A

		SET @AddressID = SCOPE_IDENTITY()

		INSERT INTO EmployeeMaster(
			CompanyID,
			CreatedBy,
			CreatedOn,
			Gender,
			FirstName,
			MiddleName,
			LastName,
			BirthDate,
			HireDate,
			AddressID,
			Position
		)
		SELECT 
			@Company,
			@User,
			GETDATE(),
			Gender,
			FirstName,
			MiddleName,
			LastName,
			CONVERT(DATE,BirthDate,103),
			CONVERT(DATE,HireDate,103),
			@AddressID,
			Position
			FROM OPENJSON(@EmployeeDetails)  
			WITH (
				Gender VARCHAR(10),
				FirstName VARCHAR(50),
				MiddleName VARCHAR(20),
				LastName VARCHAR(50),
				BirthDate VARCHAR(10),
				HireDate VARCHAR(10),
				Position VARCHAR(50)
			)

		SET @Employee = SCOPE_IDENTITY()
		  
	END
	ELSE IF ISNULL(@isDeleted,0) = 1
	BEGIN
		UPDATE EmployeeMaster 
			SET isDeleted = 1,
				DeletedOn = GETDATE(),
				DeletedBy = @User
			WHERE CompanyID = @Company AND EmployeeMasterID = @Employee
	END
	ELSE
	BEGIN
		
		IF EXISTS(SEleCT 1 FROM EmployeeMaster WITH(NOLOCK) WHERE CompanyID = @Company AND EmployeeMasterID = @Employee AND ISNULL(AddressID,0) = 0)
		BEGIN
			INSERT INTO Address(
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
				CompanyID,
				CreatedBy,
				CreatedOn
			)
			SELECT   
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
				 @Company,
				 @User,
				 GETDATE()
				FROM OPENJSON(@EmployeeDetails)  
			WITH (Address NVARCHAR(max) as json  
			) as B  
			CROSS APPLY openjson (B.Address)  
			with  
			(  
				Address1 VARCHAR(100),
				Address2 VARCHAR(100),
				City VARCHAR(50),
				State VARCHAR(30),
				Pincode VARCHAR(10),
				OfficePhoneNo VARCHAR(20),
				MobileNo VARCHAR(20),
				AlternateNo VARCHAR(20),
				HomePhoneNo VARCHAR(20),
				EmailID VARCHAR(100)  
			) A

			SET @AddressID = SCOPE_IDENTITY()

			UPDATE EmployeeMaster SET AddressID = @AddressID WHERE CompanyID = @Company AND EmployeeMasterID = @Employee
		END
		ELSE
		BEGIN
			UPDATE Address
			SET 
				Address1 = AD.Address1, 
				Address2 = AD.Address2, 
				City = AD.City,
				State = AD.State, 
				Pincode = AD.Pincode,
				OfficePhoneNo = AD.OfficePhoneNo,
				MobileNo = AD.MobileNo,
				AlternateNo = AD.AlternateNo,
				HomePhoneNo = AD.HomePhoneNo,
				EmailID = AD.EmailID
			FROM OPENJSON(@EmployeeDetails)  
			WITH (Address NVARCHAR(max) as json  
			) as B  
			CROSS APPLY openjson (B.Address)  
			with  
			(  
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
				EmailID VARCHAR(100)  
			) AD
			WHERE Address.CompanyID = @Company AND Address.AddressID = AD.AddressID
		END

		UPDATE EmployeeMaster
			SET Gender = ED.Gender,
				FirstName = ED.FirstName,
				MiddleName = ED.MiddleName,
				LastName = ED.LastName,
				BirthDate = CONVERT(DATE,ED.BirthDate,103),
				HireDate = CONVERT(DATE,ED.HireDate,103),
				Position = ED.Position
			FROM OPENJSON(@EmployeeDetails)  
			WITH (
				Gender VARCHAR(10),
				FirstName VARCHAR(50),
				MiddleName VARCHAR(20),
				LastName VARCHAR(50),
				BirthDate VARCHAR(10),
				HireDate VARCHAR(10),
				Position VARCHAR(50)
			) ED
			WHERE CompanyID = @Company AND EmployeeMasterID = @Employee

		
	END

	SELECT @Employee as Employee, @AddressID as AddressID
 COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
END
