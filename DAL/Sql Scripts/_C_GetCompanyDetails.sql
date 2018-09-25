SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_C_GetCompanyDetails]
	@CompanyID INT,
	@user INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 22nd Aug 2018
-- Description:	 Get Company Details
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AddressID INT,
			@CompanyDetails VARCHAR(4000),
			@AddressDetails VARCHAR(2000)

	SELECT @AddressID = AddressID FROM CompanyMaster WITH(NOLOCK) WHERE CompanyID = @CompanyID

	SET @CompanyDetails = 
		(SELECT CompanyName,
			CompanyCode,
			AddressID,
			CompLegalName,
			CONVERT(VARCHAR,CompCreatedDate,101) as CompCreatedDate,
			CompBusType,
			TDSNo,
			TDSCircle,
			TDSChallanNo,
			PanNo,
			CSTNo,
			CSTDate
		FROM CompanyMaster WITH(NOLOCK) WHERE CompanyID = @CompanyID
		FOR JSON PATH
		)

	SET @AddressDetails = 
		(SELECT AddressID,
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
				Website
		FROM [Address] WHERE AddressID = @AddressID AND CompanyID = @CompanyID
		FOR JSON PATH
		)

	SELECT @CompanyDetails CompanyDetails, @AddressDetails AddressDetails
END
GO
