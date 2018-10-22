SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetEmployeeList] 
	@Company INT,
	@user INT,
	@isShort BIT
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
	DECLARE @EmploreeList VARCHAR(MAX)

	IF ISNULL(@isShort, 0) = 1
	BEGIN
		SET @EmploreeList = 
		(
		SELECT 
			EmployeeMaster.EmployeeMasterID,
			FirstName+' '+LastName as EmployeeName
		FROM EmployeeMaster WITH(NOLOCK)
			WHERE CompanyID = @Company AND ISNULL(isDeleted,0)=0
		FOR JSON PATH
		)
	END
	ELSE
	BEGIN
		SET @EmploreeList = 
		(
		SELECT 
			EmployeeMaster.EmployeeMasterID,
			FirstName+' '+LastName as EmployeeName,
			HireDate,
			Position,
			Address.MobileNo,
			Address.HomePhoneNo,
			Address.EmailID,
			Address.Address1,
			Address.Address2
		FROM EmployeeMaster WITH(NOLOCK) 
		LEFT OUTER JOIN Address WITH(NOLOCK) ON Address.CompanyID = @Company AND Address.AddressID = EmployeeMaster.AddressID
			WHERE EmployeeMaster.CompanyID = @Company AND ISNULL(EmployeeMaster.isDeleted,0)=0
		FOR JSON PATH
		)
	END
	SELECT @EmploreeList as EmploreeList
END
GO
