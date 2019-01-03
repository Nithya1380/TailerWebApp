SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[GetSeriesMaster]
	@Company INT,
	@user INT,
	@Branch INT,
	@SeriesMasterID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	DEclare @SeriesMaster VARCHAR(5000)
	
	IF ISNULL(@SeriesMasterID,0) > 0
	BEGIN
		SET @SeriesMaster = 
			(SELECT SeriesMasterID,
				   CONVERT(VARCHAR,StartDate,103) as StartDate,
				   Prefix,
				   LastValue,
				   WithZero,
				   Width
			 FROM SeriesMaster WITH(NOLOCk)
				WHERE CompanyID = @Company
					AND SeriesMasterID = @SeriesMasterID
				FOR JSON PATH
				)
	END
	ELSE
	BEGIN 
		SET @SeriesMaster = 
			(SELECT SeriesMasterID,
			   CONVERT(VARCHAR,StartDate,103) as StartDate,
			   Prefix,
			   LastValue,
			   WithZero,
			   Width
		 FROM SeriesMaster WITH(NOLOCk)
			WHERE CompanyID = @Company
			ORDER BY SeriesMaster.StartDate
			FOR JSON PATH
			)
	END

	SELECT @SeriesMaster as SeriesMaster
END TRY
BEGIN CATCH
	RETURN 1
END CATCH
RETURN 0
END
GO
