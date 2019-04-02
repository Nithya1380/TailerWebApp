
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetCompanyLogo] 
	-- Add the parameters for the stored procedure here
	@Company INT,
	@user INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT CompanyLogo FROM CompanyLogo WITH(NOLOCK) WHERE CompanyLogo.CompanyID = @Company 
RETURN 0
END
GO
