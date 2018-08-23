
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_C_AddModifyCompany] 
	@CompanyID INT,
	@user INT,
	@CompanyDetails VARCHAR(4000),
	@AddressDetails VARCHAR(2000)
AS
-- =============================================
-- Author: Mahesh
-- Create date: 22nd Aug 2018
-- Description: Add Modify Company
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	DECLARE @AddressID INT

  BEGIN TRAN
	IF ISNULL(@CompanyID,0) = 0
	BEGIN

		INSERT INTO CompanyMaster(
			CompanyName,
			CompanyCode,
			CreatedBy,
			CompLegalName,
			CompCreatedDate,
			CompBusType,
			TDSNo,
			TDSCircle,
			TDSChallanNo,
			PanNo,
			CSTNo,
			CSTDate)
		SELECT CompanyName,
			CompanyCode,
			@user,
			CompLegalName,
			CompCreatedDate,
			CompBusType,
			TDSNo,
			TDSCircle,
			TDSChallanNo,
			PanNo,
			CSTNo,
			CSTDate
		 FROM OPENJSON(@CompanyDetails)  
			WITH (	CompanyName	VARCHAR(50),
					CompanyCode	VARCHAR(5),
					CreatedOn DATETIME,
					CompLegalName VARCHAR(40),
					CompCreatedDate DATETIME,
					CompBusType CHAR(1),
					TDSNo VARCHAR(50),
					TDSCircle VARCHAR(50),
					TDSChallanNo VARCHAR(50),
					PanNo VARCHAR(15),
					CSTNo VARCHAR(30),
					CSTDate DATETIME
					) 
					
		SET @CompanyID = scope_identity()

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

		UPDATE CompanyMaster SET AddressID = @AddressID WHERE CompanyID = @CompanyID

	END
	ELSE
	BEGIN
		UPDATE CompanyMaster
			SET CompanyName = tempCompany.CompanyName,
			CompanyCode  = tempCompany.CompanyCode,
			CompLegalName  = tempCompany.CompLegalName,
			CompCreatedDate  = tempCompany.CompCreatedDate,
			CompBusType  = tempCompany.CompBusType,
			TDSNo  = tempCompany.TDSNo,
			TDSCircle  = tempCompany.TDSCircle,
			TDSChallanNo  = tempCompany.TDSChallanNo,
			PanNo  = tempCompany.PanNo,
			CSTNo  = tempCompany.CSTNo,
			CSTDate  = tempCompany.CSTDate
		FROM  OPENJSON(@CompanyDetails)  
			WITH (	CompanyName	VARCHAR(50),
					CompanyCode	VARCHAR(5),
					AddressID INT,
					CreatedBy INT,
					CreatedOn DATETIME,
					CompLegalName VARCHAR(40),
					CompCreatedDate DATETIME,
					CompBusType CHAR(1),
					TDSNo VARCHAR(50),
					TDSCircle VARCHAR(50),
					TDSChallanNo VARCHAR(50),
					PanNo VARCHAR(15),
					CSTNo VARCHAR(30),
					CSTDate DATETIME
					) tempCompany
		WHERE CompanyMaster.CompanyID = @CompanyID

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
	END
  COMMIT TRAN
END TRY
BEGIN CATCH
	RETURN 1
END CATCH
RETURN 0
END
GO
