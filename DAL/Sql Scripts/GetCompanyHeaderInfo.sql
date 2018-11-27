SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCompanyHeaderInfo]
	-- Add the parameters for the stored procedure here
	@CompanyID INT,
	@user INT,
	@location INT
AS
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @CompanyHeaderInfo varchar(5000)

	SET @CompanyHeaderInfo = 
	(
		SELECT 
			CompanyMaster.CompanyName,
			temBranch.BranchName,
			tempAddress.Address1,
			tempAddress.Address2,
			tempAddress.State,
			tempAddress.City,
			tempAddress.OfficePhoneNo,
			tempAddress.HomePhoneNo,
			tempAddress.Pincode
		FROM CompanyMaster WITH(NOLOCK)
			CROSS APPLY(
				SELECT BranchDetails.BranchName, BranchDetails.AddressID FROM BranchDetails WITH(NOLOCK)
					WHERE BranchDetails.CompanyID = CompanyMaster.CompanyID
						AND BranchDetails.BranchID = @location
			)temBranch
			CROSS APPLY(
				SELECT Address1, Address2, State, City, OfficePhoneNo, HomePhoneNo, Pincode
					FROM Address WITH(NOLOCK)
						WHERE Address.CompanyID = @CompanyID
							AND Address.AddressID = temBranch.AddressID
			) tempAddress
		WHERE CompanyMaster.CompanyID = @CompanyID
		FOR JSON PATH
	)

	SELECT @CompanyHeaderInfo as CompanyHeaderInfo
END
GO
