SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SaveMeasurementMaster]
	@CompanyID INT,
	@user INT,
	@MeasurementMasterID INT,
	@Measurement VARCHAR(4000)
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
BEGIN TRY
BEGIN TRAN
    IF ISNULL(@MeasurementMasterID,0) = 0
	BEGIN
		INSERT INTO MeasurementMaster(
			CompanyID,
			AccountID,
			MeasuNo,
			CreatedBy,
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
		)
		SELECT 
			@CompanyID,
			AccountID,
			MeasuNo,
			@user,
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
		FROM OPENJSON(@Measurement)  
			WITH (
				AccountID INT,
				MeasuNo VARCHAR(20),
				CreatedBy INT,
				MeasCreatedOn DATETIME,
				ItemID INT,
				ItemDesc VARCHAR(30),
				BodyFit VARCHAR(20),
				Remark VARCHAR(50),
				TrialDate DATETIME,
				DeliDate DATETIME,
				MeasDate DATETIME,
				Qty INT,
				MeasWeight FLOAT,
				text1 FLOAT,
				text2 FLOAT,
				text3 FLOAT,
				text4 VARCHAR(20),
				text5 VARCHAR(30),
				text6 VARCHAR(40),
				text7 FLOAT,
				text8 FLOAT,
				text9 FLOAT,
				text10 FLOAT,
				text11 FLOAT,
				text12 FLOAT,
				text13 FLOAT,
				text14 FLOAT,
				text15 FLOAT,
				text16 FLOAT,
				text17 FLOAT,
				text18 FLOAT,
				text19 FLOAT,
				text20 FLOAT,
				text21 FLOAT,
				text22 FLOAT,
				text23 VARCHAR(20),
				text24 FLOAT,
				text25 FLOAT,
				text26 FLOAT,
				text27 FLOAT,
				text28 FLOAT,
				text29 FLOAT,
				text30 FLOAT,
				text31 FLOAT
			) tempMeas

		 SET @MeasurementMasterID = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		UPDATE MeasurementMaster
			SET AccountID = tempMeas.AccountID,
				MeasuNo = tempMeas.MeasuNo,
				MeasCreatedOn = tempMeas.MeasCreatedOn,
				ItemID = tempMeas.ItemID,
				ItemDesc = tempMeas.ItemDesc,
				BodyFit = tempMeas.BodyFit,
				Remark = tempMeas.Remark,
				TrialDate = tempMeas.TrialDate,
				DeliDate = tempMeas.DeliDate,
				MeasDate = tempMeas.MeasDate,
				Qty = tempMeas.Qty,
				MeasWeight = tempMeas.MeasWeight,
				text1 = tempMeas.text1,
				text2 = tempMeas.text2,
				text3 = tempMeas.text3,
				text4 = tempMeas.text4,
				text5 = tempMeas.text5,
				text6 = tempMeas.text6,
				text7 = tempMeas.text7,
				text8 = tempMeas.text8,
				text9= tempMeas.text9,
				text10 = tempMeas.text10,
				text11 = tempMeas.text11,
				text12 = tempMeas.text12,
				text13 = tempMeas.text13,
				text14 = tempMeas.text14,
				text15 = tempMeas.text15,
				text16 = tempMeas.text16,
				text17 = tempMeas.text17,
				text18 = tempMeas.text18,
				text19 = tempMeas.text19,
				text20 = tempMeas.text20,
				text21 = tempMeas.text21,
				text22 = tempMeas.text22,
				text23 = tempMeas.text23,
				text24 = tempMeas.text24,
				text25 = tempMeas.text25,
				text26 = tempMeas.text26,
				text27 = tempMeas.text27,
				text28 = tempMeas.text28,
				text29 = tempMeas.text29,
				text30 = tempMeas.text30,
				text31 = tempMeas.text31
		FROM OPENJSON(@Measurement)  
			WITH (
				AccountID INT,
				MeasuNo VARCHAR(20),
				CreatedBy INT,
				MeasCreatedOn DATETIME,
				ItemID INT,
				ItemDesc VARCHAR(30),
				BodyFit VARCHAR(20),
				Remark VARCHAR(50),
				TrialDate DATETIME,
				DeliDate DATETIME,
				MeasDate DATETIME,
				Qty INT,
				MeasWeight FLOAT,
				text1 FLOAT,
				text2 FLOAT,
				text3 FLOAT,
				text4 VARCHAR(20),
				text5 VARCHAR(30),
				text6 VARCHAR(40),
				text7 FLOAT,
				text8 FLOAT,
				text9 FLOAT,
				text10 FLOAT,
				text11 FLOAT,
				text12 FLOAT,
				text13 FLOAT,
				text14 FLOAT,
				text15 FLOAT,
				text16 FLOAT,
				text17 FLOAT,
				text18 FLOAT,
				text19 FLOAT,
				text20 FLOAT,
				text21 FLOAT,
				text22 FLOAT,
				text23 VARCHAR(20),
				text24 FLOAT,
				text25 FLOAT,
				text26 FLOAT,
				text27 FLOAT,
				text28 FLOAT,
				text29 FLOAT,
				text30 FLOAT,
				text31 FLOAT
			) tempMeas 
		WHERE CompanyID = @CompanyID AND MeasurementMasterID = @MeasurementMasterID
	END

	SELECT @MeasurementMasterID
COMMIT TRAN
END TRY
BEGIN CATCH
	
	ROLLBACK TRAN
	RETURN 1
END CATCH
RETURN 0
END
GO
