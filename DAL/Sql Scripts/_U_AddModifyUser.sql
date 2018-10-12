SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[_U_AddModifyUser] 
	@Company INT,
	@user INT,
	@UserID INT,
	@UserName VARCHAR(50),
	@LoginID VARCHAR(50),
	@RoleID INT,
	@Password VARBINARY(50),
	@isPasswordRegenerated BIT,
	@isdeleted BIT,
	@EmployeeID INT,
	@BranchIDs VARCHAR(2000)

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

    -- Insert statements for procedure here
BEGIN TRY

BEGIN TRAN
	IF ISNULL(@UserID,0) = 0
		IF EXISTS(SELECT TOP 1 1 FROM Users WITH(NOLOCK) WHERE CompanyID = @Company AND LoginID = @LoginID)
		 RETURN 2

	IF ISNULL(@UserID,0) = 0
	BEGIN
		INSERT INTO Users(CompanyID, LoginID, password, RoleID, Status, isPasswordRegenerated, CreatedOn, CreatedBy, UserName, EmployeeID)
		VALUES(@Company, @LoginID, @Password, @RoleID,'Active', @isPasswordRegenerated, GETDATE(), @user, @UserName, @EmployeeID)

		SET @UserID = SCOPE_IDENTITY()
	END 
	ELSE IF ISNULL(@isPasswordRegenerated,0) = 1 AND ISNULL(@UserID,0)>0
	BEGIN
		UPDATE Users SET password = @Password, isPasswordRegenerated = 1 
			WHERE CompanyID = @Company AND UserID  = @UserID
	END
	ELSE IF ISNULL(@isdeleted,0) = 1 AND ISNULL(@UserID,0)>0
	BEGIN
		UPDATE Users SET isDeleted = 1, DeletedOn = GETDATE(), DeletedBy = @user		
			WHERE CompanyID = @Company AND UserID  = @UserID
	END
	ELSE IF ISNULL(@UserID,0)>0
	BEGIN
		UPDATE Users SET UserName = @UserName, LoginID = @LoginID		
			WHERE CompanyID = @Company AND UserID  = @UserID
	END

	--IF ISNULL(@BranchIDs,'')!=''
	--BEGIN
		
	--END

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
