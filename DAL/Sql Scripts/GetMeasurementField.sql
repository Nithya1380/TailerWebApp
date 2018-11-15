
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetMeasurementField]
	@CompanyID INT,
	@user INT
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

	DEclare @MeasurementField VARCHAR(4000)

    -- Insert statements for procedure here
	SET @MeasurementField = 
		(
			SELECT 
				MeasurementFieldID,
				FieldName,
				isRrepeat,
				ItemGroup [ItemGroup.PickListValue],
				ItemGroup [ItemGroup.PickListLabel],
				OrderBy
			FROM MeasurementFieldMaster WITH(NOLOCK) WHERE CompanyID = @CompanyID
				ORDER BY OrderBy
			FOR JSON PATH
		)

	SELECT @MeasurementField MeasurementField

END
GO
