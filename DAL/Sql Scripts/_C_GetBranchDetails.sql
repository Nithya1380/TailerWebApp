
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_C_GetBranchDetails] 
	@CompanyID INT,
	@user INT,
	@BranchID INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 08 Sep 2018
-- Description:	Get Branch Details
-- =============================================
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @BranchDetails VARCHAR(4000),
			@AddressDetails VARCHAR(2000),
			@AddressID INT

	SELECT @AddressID = AddressID FROM BranchDetails WITH(NOLOCK) WHERE CompanyID = @CompanyID AND BranchID = @BranchID

    SET @BranchDetails = (
			SELECT 
				BranchID,
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
				CONVERT(VARCHAR,BranchCreatedDate,101) as BranchCreatedDate,
				ShortName,
				BranchNo,
				BranchType,
				BranchGSTIN,
				BranchTINNo,
				CONVERT(VARCHAR,BranchSTDate,101) as BranchSTDate,
				ExciseAddress,
				ExciseDivision,
				ExciseRange,
				ExciseState,
				CONVERT(VARCHAR,PeriodFormDate, 101) as PeriodFormDate,
				CONVERT(VARCHAR,PeriodToDate, 101) as PeriodToDate,
				BranchDivision
			FROM BranchDetails WITH(NOLOCK) WHERE CompanyID = @CompanyID AND BranchID = @BranchID
		FOR JSON PATH)

	SET @AddressDetails = (
			SELECT 
				AddressID
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
				Website
			FROM [Address] WHERE CompanyID = @CompanyID AND AddressID = @AddressID
		FOR JSON PATH)

	SELECT @BranchDetails as BranchDetails, @AddressDetails as AddressDetails
END TRY
BEGIN CATCH
	RETURN 1
END CATCH
RETURN 0
END
GO
