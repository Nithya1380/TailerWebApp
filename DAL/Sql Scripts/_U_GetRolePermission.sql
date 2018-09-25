SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_U_GetRolePermission] 
	-- Add the parameters for the stored procedure here
	@CompanyID INT,
	@user INT,
	@RoleID INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 18th Sep 2018
-- Description:	Get Menu and Premission list
-- =============================================

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT 
		PermissionListMaster.PermissionDesc,
		PermissionListMaster.PermissionIndexID,
		PermissionListMaster.ParentPermissionIndexID,
		PermissionListMaster.IsMenu,
		RoleScope.RolesScopeID	
	FROM CompanyPermissions WITH(NOLOCK)
		INNER JOIN PermissionListMaster WITH(NOLOCK) 
			ON CompanyPermissions.PermissionIndexID = PermissionListMaster.PermissionIndexID 
		LEFT JOIN RoleScope WITH(NOLOCK)
			ON CompanyPermissions.CompanyPermissionID = RoleScope.CompanyPermissionID 
				AND RoleScope.CompanyID = @CompanyID AND RoleScope.RoleID = @RoleID AND ISNULL(RoleScope.isDeleted,0) = 0
		WHERE CompanyPermissions.CompanyID = @CompanyID
	ORDER BY PermissionListMaster.PermissionDesc
	FOR JSON PATH
END

