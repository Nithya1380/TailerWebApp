GO
/****** Object:  StoredProcedure [dbo].[SaveMeasurementMaster]    Script Date: 24-Oct-2018 22:54:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SaveMeasurementMaster]
	@CompanyID INT,
	@user INT,
	@MeasurementMasterID INT,
	@Measurement VARCHAR(4000),
	@MeasurementField VARCHAR(8000)
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
			MeasWeight
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
			MeasWeight
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
				MeasWeight FLOAT
			) tempMeas

		 SET @MeasurementMasterID = SCOPE_IDENTITY()

		 INSERT INTO MeasurementFieldDetail(
				MeasurementFieldID, 
				MeasurementMasterID,
				FieldValue,
				CompanyID,
				CreatedBy)
		SELECT id,
			   @MeasurementMasterID,
			   FValue,
			   @CompanyID,
			   @user
			FROM OPENJSON(@MeasurementField)  
			WITH (
				id INT,
				FValue VARCHAR(500)
			) tempMeas


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
				MeasWeight = tempMeas.MeasWeight
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
				MeasWeight FLOAT
			) tempMeas 
		WHERE CompanyID = @CompanyID AND MeasurementMasterID = @MeasurementMasterID

		MERGE MeasurementFieldDetail AS TARGET
		USING (SELECT id, FValue FROM OPENJSON(@MeasurementField)  
					WITH (
						id INT,
						FValue VARCHAR(500)
					)) AS SOURCE
		ON (TARGET.MeasurementFieldID = SOURCE.id AND TARGET.MeasurementMasterID = @MeasurementMasterID AND TARGET.CompanyID = @CompanyID) 
		WHEN MATCHED AND TARGET.FieldValue <> SOURCE.FValue 
		THEN UPDATE SET TARGET.FieldValue = SOURCE.FValue
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT (MeasurementFieldID, MeasurementMasterID, FieldValue, CompanyID, CreatedBy) 
		VALUES (SOURCE.id, @MeasurementMasterID, SOURCE.FValue, @CompanyID, @user);

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
