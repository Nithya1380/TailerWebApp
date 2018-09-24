SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_U_GetRoles]
	@CompanyID INT,
	@user INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 18th Sep 2018
-- Description: Get Role List
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT RoleID, RoleName 
		FROM Roles WITH(NOLOCK) WHERE Roles.CompanyID = @CompanyID AND ISNULL(isDeleted,0) = 0
	 ORDER BY RoleName 
	 FOR JSON PATH
END
GO
