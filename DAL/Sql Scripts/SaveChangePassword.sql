SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveChangePassword] 
	-- Add the parameters for the stored procedure here
	@Company INT,
	@user INT,
	@Password VARBINARY(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS(SELECT 1 FROM Users WITH(NOLOCK) WHERE CompanyID = @Company AND UserID = @user)
		RETURN 1

BEGIN TRY
	BEGIN TRAN
		UPDATE Users
			SET password = @Password,
				isPasswordRegenerated = NULL
			WHERE CompanyID = @Company AND UserID = @user
	COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK
	REtURN 1
END CATCH
END
RETURN 0
GO
