GO
/****** Object:  StoredProcedure [dbo].[_U_GetRolePermission]    Script Date: 27-Nov-2018 22:40:34 ******/
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
	DECLARE @Permissions VARCHAR(MAX)
	
	SELECT Roles.RoleName, Roles.HomePage FROM Roles WITH(NOLOCK) WHERE Roles.CompanyID = @CompanyID AND Roles.RoleID = @RoleID
	
	SET @Permissions =
	 (SELECT 
		PermissionListMaster.PermissionDesc,
		ISNULL(PermissionListMaster.PermissionIndexID,0) as PermissionIndexID,
		ISNULL(PermissionListMaster.ParentPermissionIndexID,0) as ParentPermissionIndexID,
		ISNULL(PermissionListMaster.IsMenu,0) as IsMenu,
		ISNULL(RoleScope.RolesScopeID,0) as RolesScopeID,
		ISNULL(CompanyPermissions.CompanyPermissionID,0) as CompanyPermissionID,
		CONVERT(BIT,(CASE WHEN ISNULL(RoleScope.CompanyPermissionID,0)>0 THEN 1 ELSE 0 END)) as isChecked,
		CONVERT(BIT,(CASE WHEN ISNULL(RoleScope.CompanyPermissionID,0)>0 THEN 1 ELSE 0 END)) as isOldChecked
	FROM CompanyPermissions WITH(NOLOCK)
		INNER JOIN PermissionListMaster WITH(NOLOCK) 
			ON CompanyPermissions.PermissionIndexID = PermissionListMaster.PermissionIndexID 
		LEFT JOIN RoleScope WITH(NOLOCK)
			ON CompanyPermissions.CompanyPermissionID = RoleScope.CompanyPermissionID 
				AND RoleScope.CompanyID = @CompanyID AND RoleScope.RoleID = @RoleID AND ISNULL(RoleScope.isDeleted,0) = 0
		WHERE CompanyPermissions.CompanyID = @CompanyID
	ORDER BY PermissionListMaster.PermissionDesc
	FOR JSON PATH)

	SELECT @Permissions as 'Permissions'
END
