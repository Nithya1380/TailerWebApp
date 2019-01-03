SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetAuditLogs]
	-- Add the parameters for the stored procedure here
	@Company INT,
	@user INT,
	@Branch INT,
	@ActivityType VARCHAR(50),
	@ActivitID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	DECLARE @AuditLogs VARCHAR(MAX)

	IF ISNULL(@ActivitID,0) > 0
	BEGIN
		SET @AuditLogs = 
		(
			SELECT 
				CONVERT(VARCHAR,AuditLogs.CreatedOn,103) as MdDate,
				CONVERT(VARCHAR(5),AuditLogs.CreatedOn,8) as MdTime,
				EmployeeMaster.FirstName+' '+EmployeeMaster.LastName as EmployeeName,
				AuditLogs.LogDescription		
			FROM AuditLogs WITH(NOLOCK), Users WITH(NOLOCK), EmployeeMaster WITH(NOLOCK)
				WHERE AuditLogs.CompanyID = @Company AND Users.CompanyID = @Company AND EmployeeMaster.CompanyID = @Company
					AND AuditLogs.CreatedBy = Users.UserID
					AND EmployeeMaster.EmployeeMasterID = Users.EmployeeID
					AND AuditLogs.ActivityType = @ActivityType
					AND AuditLogs.ActivitID = @ActivitID
				ORDEr BY AuditLogs.CreatedOn DESC
				FOR JSON PATH
		)

	END
	ELSE
	BEGIN
		SET @AuditLogs = 
		(
			SELECT 
				CONVERT(VARCHAR,AuditLogs.CreatedOn,103) as MdDate,
				CONVERT(VARCHAR(5),AuditLogs.CreatedOn,8) as MdTime,
				EmployeeMaster.FirstName+' '+EmployeeMaster.LastName as EmployeeName,
				AuditLogs.LogDescription		
			FROM AuditLogs WITH(NOLOCK), Users WITH(NOLOCK), EmployeeMaster WITH(NOLOCK)
				WHERE AuditLogs.CompanyID = @Company AND Users.CompanyID = @Company AND EmployeeMaster.CompanyID = @Company
					AND AuditLogs.CreatedBy = Users.UserID
					AND EmployeeMaster.EmployeeMasterID = Users.EmployeeID
					AND AuditLogs.ActivityType = @ActivityType
				ORDEr BY AuditLogs.CreatedOn DESC
				FOR JSON PATH
		)
	END

	SELECT @AuditLogs AuditLogs

END TRY
BEGIN CATCH

END CATCH
	
END
GO
