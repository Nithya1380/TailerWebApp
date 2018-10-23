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

	DECLARE @Measurement VARCHAR(5000)

	SET @Measurement = 
	(
		SELECT 
			AccountID,
			AccountsMaster.AccountCode,
			AccountsMaster.AccountName,
			MeasuNo,
			MeasCreatedOn,
			ItemID,
			ItemDesc,
			BodyFit,
			Remark,
			TrialDate,
			DeliDate,
			MeasDate,
			Qty,
			MeasWeight,
			text1,
			text2,
			text3,
			text4,
			text5,
			text6,
			text7,
			text8,
			text9,
			text10,
			text11,
			text12,
			text13,
			text14,
			text15,
			text16,
			text17,
			text18,
			text19,
			text20,
			text21,
			text22,
			text23,
			text24,
			text25,
			text26,
			text27,
			text28,
			text29,
			text30,
			text31
		FROM MeasurementMaster WITH(NOLOCK), AccountsMaster WITH(NOLOCK) 
			WHERE MeasurementMaster.CompanyID = @CompanyID AND MeasurementMasterID = @MeasurementMasterID
				AND AccountsMaster.AccountMasterID = MeasurementMaster.AccountID
		FOR JSON PATH
	)

	SELECT @Measurement as Measurement

RETURN 0
END
GO
