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

	IF ISNULL(@BranchIDs,'')!=''
	BEGIN
		UPDATE UserBranch SET isDeleted = NULL, DeletedBy = NULL, DeletedOn = NULL
			WHERE UserBranch.UserID = @UserID AND UserBranch.CompanyID = @Company
				AND UserBranch.isDeleted = 1 
				AND UserBranch.BranchID IN(SELECT value FROM STRING_SPLIT(@BranchIDs, ',') WHERE ISNULL(value,'')!='')

		UPDATE UserBranch SET isDeleted = 1, DeletedOn = GETDATE(), DeletedBy = @user
			WHERE UserBranch.UserID = @UserID AND UserBranch.CompanyID = @Company
				AND ISNULL(UserBranch.isDeleted,0) = 0 
				AND UserBranch.BranchID NOT IN(SELECT value FROM STRING_SPLIT(@BranchIDs, ',') WHERE ISNULL(value,'')!='')

		INSERT INTO UserBranch(CompanyID, UserID, BranchID, CreatedBy, CreatedOn)
		SELECT @Company, @UserID, value, @user, GETDATE() FROM STRING_SPLIT(@BranchIDs, ',')
			WHERE ISNULL(value,'')!=''
				AND NOT EXISTS(SELECT UserBranch.BranchID FROM UserBranch WITH(NOLOCK) 
								WHERE UserBranch.CompanyID = @Company AND UserBranch.UserID=@UserID
									AND value = UserBranch.BranchID)

	END
	ELSE
	BEGIN
		UPDATE UserBranch SET isDeleted = NULL, DeletedBy = NULL, DeletedOn = NULL
			WHERE UserBranch.UserID = @UserID AND UserBranch.CompanyID = @Company
				AND UserBranch.isDeleted = 1 

		INSERT INTO UserBranch(CompanyID, UserID, BranchID, CreatedBy, CreatedOn)
		SELECT @Company, @UserID, BranchDetails.BranchID, @user, GETDATE() FROM  BranchDetails WITH(NOLOCK)
			WHERE BranchDetails.CompanyID =  @Company 
				AND ISNULL(BranchDetails.isDeleted ,0)= 0
				AND NOT EXISTS(SELECT UserBranch.BranchID FROM UserBranch WITH(NOLOCK) 
								WHERE UserBranch.CompanyID = @Company AND UserBranch.UserID=@UserID
									AND BranchDetails.BranchID = UserBranch.BranchID)

	END

COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
