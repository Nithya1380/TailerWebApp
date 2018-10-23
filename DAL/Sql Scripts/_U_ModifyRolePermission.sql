SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_U_ModifyRolePermission] 
	@Company INT,
	@user INT,
	@RoleName VARCHAR(50),
	@PermissionAdded VARCHAR(4000),
	@PermissionRemoved VARCHAR(4000),
	@RoleID INT,
	@isDeleted BIT,
	@HomePage INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 21st Sep 2018
-- Description: Modify Role Permission 
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
BEGIN TRY

	IF ISNULL(@isDeleted,0)=1 AND EXISTS(SELECT TOP 1 1 FROM Users WITH(NOLOCK) WHERE CompanyID = @Company AND ISNULL(isDeleted,0) = 0 AND RoleID = @RoleID)
		RETURN 2

	IF EXISTS(SELECT TOP 1 1 FROM Roles WITH(NOLOCK) WHERE Roles.CompanyID = @Company AND Roles.RoleID != @RoleID 
				AND ISNULL(isDeleted,0) = 0 AND RoleName = @RoleName)
		RETURN 3
	
BEGIN TRAN

	IF ISNULL(@RoleID,0) = 0
	BEGIN
		INSERT INTO Roles(CompanyID, RoleName, CreatedOn, CreatedBy, HomePage)
		VALUES(@Company, @RoleName, GETDATE(), @user, @HomePage)

		SET @RoleID = SCOPE_IDENTITY()
	END
	ELSE IF ISNULL(@isDeleted,0)=1
	BEGIN
		UPDATE Roles
				SET isDeleted = 1,
					DeletedBy = @user,
					DeletedOn = GETDATE()
			WHERE Roles.CompanyID = @Company AND Roles.RoleID = @RoleID
	END
	ELSE IF EXISTS(SELECT TOP 1 1 FROM Roles WITH(NOLOCK) WHERE Roles.CompanyID = @Company AND Roles.RoleID = @RoleID AND RoleName != @RoleName)
	BEGIN
		UPDATE Roles
			SET RoleName = @RoleName, HomePage = @HomePage
		WHERE Roles.CompanyID = @Company AND Roles.RoleID = @RoleID
	END 

	IF NOT EXISTS(SELECT TOP 1 1 FROM Roles WITH(NOLOCK) WHERE Roles.CompanyID = @Company AND Roles.RoleID = @RoleID)
		RETURN 1


	IF ISNULL(@PermissionRemoved,'')!= ''
	BEGIN
		UPDATE RoleScope 
			SET isDeleted = 1, DeletedOn = GETDATE(), DeletedBy = @user
		 WHERE RoleScope.CompanyID = @Company AND RoleScope.RoleID = @RoleID
			AND RoleScope.CompanyPermissionID in(SELECT VALUE FROM STRING_SPLIT(@PermissionRemoved,',') WHERE VALUE!='')
			 
	END
	
	IF ISNULL(@PermissionAdded,'')!=''
	BEGIN
		UPDATE RoleScope 
			SET isDeleted = NULL
		 WHERE RoleScope.CompanyID = @Company AND RoleScope.RoleID = @RoleID
			AND RoleScope.CompanyPermissionID in(SELECT VALUE FROM STRING_SPLIT(@PermissionAdded,',') WHERE VALUE!='') 

		INSERT INTO RoleScope(RoleID, CompanyPermissionID, CompanyID, CreatedOn, CreatedBy)
		SELECT @RoleID, VALUE, @Company, GETDATE(), @user 
			FROM STRING_SPLIT(@PermissionAdded,',') WHERE VALUE!=''
				AND NOT EXISTS(SELECT 1 FROM RoleScope WITH(NOLOCK) 
							WHERE RoleScope.CompanyID = @Company AND RoleScope.RoleID = @RoleID
								AND VALUE = RoleScope.CompanyPermissionID)
	END

	SELECT @RoleID as RoleID
COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
