SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_U_AddModifyDeleteRole] 
	@CompanyID INT,
	@user INT,
	@RoleID INT,
	@RoleName VARCHAR(50),
	@IsDeleted BIT
AS
-- =============================================
-- Author: Mahesh
-- Create date: 18th Sep 2018
-- Description:	Add modify role
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
 BEGIN TRAN
	IF ISNULL(@RoleID,0) = 0
	BEGIN
		INSERT INTO Roles(CompanyID, RoleName, CreatedOn, CreatedBy)
		VALUES(@CompanyID, @RoleName, GETDATE(), @user)
	END
	ELSE IF ISNULL(@IsDeleted,0) = 0 AND ISNULL(@RoleID,0) > 0
	BEGIN
		UPDATE Roles SET RoleName = @RoleName
			WHERE CompanyID = @CompanyID AND RoleID = @RoleID
	END
	ELSE
	BEGIN
		UPDATE Roles SET isDeleted = 1, DeletedBy = @user, DeletedOn = GETDATE()
			WHERE CompanyID = @CompanyID AND RoleID = @RoleID
	END
 COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK TRAN
	RETURN 1
END CATCH
RETURN 0
END
GO
