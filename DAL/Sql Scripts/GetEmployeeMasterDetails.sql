GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeMasterDetails]    Script Date: 27-Nov-2018 22:45:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Mahesh
-- Create date: 06 Oct 2018
-- Description: Get Employee Master Details
-- =============================================
ALTER PROCEDURE [dbo].[GetEmployeeMasterDetails] 
	@Company INT,
	@User INT,
	@Employee INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @EmployeeDetails VARCHAR(MAX)
    -- Insert statements for procedure here
	SET @EmployeeDetails = 
	(
		SELECT 
			EmployeeMasterID,
			FirstName,
			MiddleName,
			LastName,
			CONVERT(VARCHAR(10),BirthDate,103) as BirthDate,
			CONVERT(VARCHAR(10),HireDate,103) as HireDate,
			Gender,
			Position,
			(SELECT 
				Ad.AddressID,
				Ad.Address1,
				Ad.Address2,
				Ad.City,
				Ad.MobileNo,
				Ad.EmailID,
				Ad.State,
				Ad.Pincode,
				Ad.HomePhoneNo,
				Ad.OfficePhoneNo
				FROM Address as Ad WITH(NOLOCK) WHERE Ad.CompanyID = @Company AND Ad.AddressID = EmployeeMaster.AddressID
				FOR JSON PATH
				) as 'Address'
		FROM EmployeeMaster WITH(NOLOCK)
			WHERE EmployeeMaster.CompanyID = @Company
				AND EmployeeMaster.EmployeeMasterID = @Employee
		FOR JSON PATH
	)
	SELECT @EmployeeDetails EmployeeDetails
END
