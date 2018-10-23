SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetAccountList]
	@Company INT,
	@user INT
AS
-- =============================================
-- Author:	Mahesh
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @AccountList VARCHAR(MAX)

	SET @AccountList = 
	(
		SELECT AccountCode, AccountName, AccountMasterID
			FROM AccountsMaster WITH(NOLOCK) WHERE CompanyID = @Company 
		FOR JSON PATH
	)

	SELECT @AccountList as AccountList

END
GO
