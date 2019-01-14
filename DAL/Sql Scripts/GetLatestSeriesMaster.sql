SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetLatestSeriesMaster] 
	-- Add the parameters for the stored procedure here
	@Company INT,
	@user INT,
	@Branch INT
AS
BEGIN
BEGIN TRY
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @SeriesMasterID INT 

	SELECT TOP 1 @SeriesMasterID = SeriesMasterID  FROM SeriesMaster WITH(NOLOCK)
		WHERE SeriesMaster.CompanyID = @Company 
	ORDER BY SeriesMaster.StartDate DESC

	SELECT TOP 1 
		SeriesMasterID,
		Prefix,
		LastValue,
		WithZero,
		Width
	FROM SeriesMaster WITH(NOLOCK) WHERE SeriesMaster.CompanyID = @Company AND SeriesMasterID = @SeriesMasterID
		FOR JSON PATH

--BEGIN TRAN
--	UPDATE SeriesMaster SET LastValue = ISNULL(LastValue,0)+1 
--		WHERE SeriesMaster.CompanyID = @Company AND SeriesMasterID = @SeriesMasterID
--COMMIT TRAN
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0	
END
GO
