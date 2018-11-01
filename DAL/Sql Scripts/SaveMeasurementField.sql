SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[SaveMeasurementField] 
	@CompanyID INT,
	@user INT,
	@MeasurementField VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
BEGIN TRY
	BEGIN TRAN
		MERGE MeasurementFieldMaster AS TARGET
		USING (
				SELECT MeasurementFieldID, FieldName, isRrepeat, OrderBy FROM OPENJSON(@MeasurementField)  
					WITH (
						MeasurementFieldID INT,
						FieldName VARCHAR(50),
						isRrepeat BIT,
						OrderBy INT
			  )) AS SOURCE 
		ON (TARGET.MeasurementFieldID = SOURCE.MeasurementFieldID AND TARGET.CompanyID = @CompanyID)
		WHEN MATCHED THEN
			UPDATE SET TARGET.FieldName = SOURCE.FieldName, 
					   TARGET.isRrepeat = SOURCE.isRrepeat,
					   TARGET.OrderBy = SOURCE.OrderBy
		WHEN NOT MATCHED BY TARGET THEN 
		 INSERT (FieldName, isRrepeat, OrderBy) 
		 VALUES (SOURCE.FieldName, SOURCE.isRrepeat, SOURCE.OrderBy);
		--WHEN NOT MATCHED BY SOURCE THEN 
		--DELETE;

	COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	RETURN 1
END CATCH
RETURN 0
END
GO
