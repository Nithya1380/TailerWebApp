GO
/****** Object:  StoredProcedure [dbo].[GetMeasurementMaster]    Script Date: 24-Oct-2018 22:53:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetMeasurementMaster] 
	@CompanyID INT,
	@user INT,
	@MeasurementMasterID INT
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

	DECLARE @Measurement VARCHAR(5000),
			@MeasurementField VARCHAR(8000)

	DECLARE @tempMeas TABLE(id INT, DetailID INT, lab VARCHAR(50), col VARCHAR(50), isRrepeat BIT, _val VARCHAR(500), ItemGroup VARCHAR(50))


	IF ISNULL(@MeasurementMasterID,0) > 0
	BEGIN
		
		SET @Measurement = 
		(
			SELECT 
				AccountID as [Account.AccountMasterID],
				AccountsMaster.AccountCode as [Account.AccountCode],
				AccountsMaster.AccountName as [Account.AccountName],
				AccountID,
				MeasuNo,
				CONVERT(VARCHAR(10),MeasCreatedOn,103) As MeasCreatedOn,
				ItemID,
				ItemDesc,
				BodyFit,
				Remark,
				CONVERT(VARCHAR(10),TrialDate,103) AS TrialDate,
				CONVERT(VARCHAR(10),DeliDate,103) AS DeliDate,
				CONVERT(VARCHAR(10),MeasDate,103) AS MeasDate,
				Qty,
				MeasWeight
			FROM MeasurementMaster WITH(NOLOCK), AccountsMaster WITH(NOLOCK) 
				WHERE MeasurementMaster.CompanyID = @CompanyID AND MeasurementMasterID = @MeasurementMasterID
					AND AccountsMaster.AccountMasterID = MeasurementMaster.AccountID
			FOR JSON PATH
		)

		INSERT INTO @tempMeas(id, lab, isRrepeat, ItemGroup)
		SELECT MeasurementFieldID, FieldName, isRrepeat, ItemGroup FROM MeasurementFieldMaster WITH(NOLOCK)
			ORDER BY OrderBy

		UPDATE @tempMeas 
			SET _val = MeasurementFieldDetail.FieldValue,
			    DetailID = MeasurementFieldDetail.MeasurementFieldDetailID
			FROM  MeasurementFieldDetail WITH(NOLOCK)
			WHERE [@tempMeas].id = MeasurementFieldDetail.MeasurementFieldID
				AND MeasurementFieldDetail.MeasurementMasterID = @MeasurementMasterID
				AND MeasurementFieldDetail.CompanyID = @CompanyID

		SET @MeasurementField = 
		(
			SELECT 
				id,
				DetailID,
				lab FieldName,
				isRrepeat,
				(SELECT CONVERT(INT,value) as val FROM string_split(ISNULL(_val,'0'), ',') WHERE _val!='' FOR JSON PATH) as FieldValue,
				'' FValue,
				ItemGroup
			FROM @tempMeas 
			FOR JSON PATH
		)

	END
	ELSE
	BEGIN
		SET @MeasurementField = 
		(
			SELECT 
				MeasurementFieldMaster.MeasurementFieldID as id,
				0 as DetailID,
				FieldName,
				isRrepeat,
				(SELECT value as val FROM string_split('0', ',') FOR JSON PATH) as FieldValue,
				'' FValue,
				ItemGroup
			FROM MeasurementFieldMaster WITH(NOLOCK)
			ORDER BY OrderBy
			FOR JSON PATH
		)
	END
	

	SELECT @Measurement as Measurement,
		   @MeasurementField as MeasurementField

RETURN 0
END
