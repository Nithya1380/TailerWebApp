SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SaveCompanyLogo]
	-- Add the parameters for the stored procedure here
	@Company INT,
	@user INT,
	@CompanyLogo IMAGE=NULL,
	@LogoName VARCHAR(100)=''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

BEGIN TRY
BEGIN TRAN
    -- Insert statements for procedure here
	IF EXISTS(SELECT TOP 1 1 FROM CompanyLogo WITH(NOLOCK) WHERE CompanyLogo.CompanyID = @Company)
		UPDATE CompanyLogo SET CompanyLogo = @CompanyLogo, LogoName = IIF(ISNULL(@LogoName,'')!='',@LogoName, LogoName) WHERE CompanyLogo.CompanyID = @Company
	ELSE
	BEGIN
		INSERT INTO CompanyLogo(CompanyID, CreatedBy, CompanyLogo, LogoName)
		VALUES(@Company, @user, @CompanyLogo, @LogoName) 
	END
COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
