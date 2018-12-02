GO
/****** Object:  StoredProcedure [dbo].[GetMeasurementList]    Script Date: 28-Nov-2018 23:04:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[GetMeasurementList] 
	@Company INT,
	@User INT
AS
-- =============================================
-- Author: Mahesh
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @MeasurementList VARCHAR(MAX)

	SET @MeasurementList = 
	(
		SELECT MeasurementMaster.MeasurementMasterID,
			MeasurementMaster.ItemDesc,
			CONVERT(VARCHAR,MeasurementMaster.MeasCreatedOn,103) as MeasCreatedOn,
			CONVERT(VARCHAR,MeasurementMaster.TrialDate,103) as TrialDate,
			CONVERT(VARCHAR,MeasurementMaster.DeliDate,103) as DeliDate,
			AccountsMaster.AccountName
		FROM MeasurementMaster WITH(NOLOCK), AccountsMaster WITH(NOLOCK) 
			WHERE MeasurementMaster.CompanyID = @Company
				AND AccountsMaster.CompanyID = @Company
				AND AccountsMaster.AccountMasterID = MeasurementMaster.AccountID
			FOR JSON PATH
	)

	SELECT @MeasurementList MeasurementList

 RETURN 0
END
