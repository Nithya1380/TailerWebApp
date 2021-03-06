ALTER PROCEDURE AddEditItemRate
( 
    @CompanyID INT,
	@UserID INT,
	@ItemMasterID INT,
	@ItemRateID INT,
	@StartDate VARCHAR(15),
	@ItemPrice VARCHAR(10),
	@TotalGST FLOAT = 0, 
	@SGSTPer FLOAT = 0, 
	@SGST FLOAT = 0, 
	@CGSTPer FLOAT = 0, 
	@CGST FLOAT = 0, 
	@BillAmt FLOAT = 0
)

AS

BEGIN
  IF(ISNULL(@CompanyID,0)=0 OR ISNULL(@ItemMasterID,0)=0  ) --OR ISDATE(@StartDate)=0
	 RETURN -1

  IF(ISNULL(@ItemRateID,0)<>0)
  BEGIN
    DECLARE @PreviousRateID INT

    IF EXISTS(SELECT 1 FROM ItemRates WITH(nolock) WHERE CompanyID=@CompanyID AND ItemMasterID=@ItemMasterID AND ItemRateID<>@ItemRateID
	            AND StartDate BETWEEN ISNULL(StartDate,'01/01/1900') AND EndDate )
		RETURN -2
  
     SELECT @PreviousRateID=(SELECT TOP 1 ItemRateID
	                           FROM ItemRates WITH(nolock) WHERE CompanyID=@CompanyID 
							     AND ItemMasterID=@ItemMasterID
								 AND ItemRateID<>@ItemRateID
								   ORDER BY StartDate DESC)

	 IF EXISTS(SELECT 1 FROM ItemRates WITH(nolock) WHERE CompanyID=@CompanyID AND ItemMasterID=@ItemMasterID 
		             AND ItemRateID=@PreviousRateID AND StartDate>DATEADD(DAY,-1,CONVERT(DATE,@StartDate,103)))
			RETURN -3

	 UPDATE ItemRates SET ItemPrice=@ItemPrice,
	                      StartDate= CONVERT(DATE,@StartDate,103),
						  TotalGST = @TotalGST, 
						  SGSTPer = @SGSTPer, 
						  SGST = @SGST, 
						  CGSTPer = @CGSTPer, 
						  CGST = @CGST, 
						  BillAmt = @BillAmt
		WHERE CompanyID=@CompanyID AND ItemMasterID=@ItemMasterID
		  AND ItemRateID=@ItemRateID

	 UPDATE ItemRates SET EndDate=DATEADD(DAY,-1,CONVERT(DATE,@StartDate, 103))
		WHERE ItemRateID=@PreviousRateID
	
  END
  ELSE
  BEGIN
     IF NOT EXISTS(SELECT 1 FROM ItemRates WITH(nolock) WHERE CompanyID=@CompanyID AND ItemMasterID=@ItemMasterID)
	 BEGIN 
	   DECLARE @BasePrice MONEY

	   SELECT @BasePrice=ItemPrice
	     FROM ItemMaster WITH(nolock)
		   WHERE CompanyID=@CompanyID
		     AND ItemmasterID=@ItemMasterID

	   INSERT INTO ItemRates(ItemMasterID,CompanyID,ItemPrice,EndDate,CreatedOn,CreatedBy, TotalGST, SGSTPer, SGST, CGSTPer, CGST, BillAmt) 
	   VALUES(@ItemMasterID,@CompanyID,@BasePrice,DATEADD(DAY,-1,CONVERT(DATE,@StartDate, 103)),GETDATE(),@UserID,  @TotalGST, @SGSTPer, @SGST, @CGSTPer, @CGST, @BillAmt)

	   SELECT @PreviousRateID=SCOPE_IDENTITY()
	 END
	 ELSE
	 BEGIN

		 SELECT @PreviousRateID=(SELECT TOP 1 ItemRateID
								   FROM ItemRates WITH(nolock) WHERE CompanyID=@CompanyID 
									 AND ItemMasterID=@ItemMasterID
									   ORDER BY StartDate DESC)

		IF EXISTS(SELECT 1 FROM ItemRates WITH(nolock) WHERE CompanyID=@CompanyID AND ItemMasterID=@ItemMasterID 
		             AND ItemRateID=@PreviousRateID AND StartDate>DATEADD(DAY,-1,CONVERT(DATE,@StartDate, 103)))
			RETURN -3

		 UPDATE ItemRates SET EndDate=DATEADD(DAY,-1,CONVERT(DATE,@StartDate,103))
		   WHERE ItemRateID=@PreviousRateID

	END

	INSERT INTO ItemRates(ItemMasterID,CompanyID,ItemPrice,StartDate,CreatedOn,CreatedBy, TotalGST, SGSTPer, SGST, CGSTPer, CGST, BillAmt) 
	   VALUES(@ItemMasterID,@CompanyID,@ItemPrice,CONVERT(DATE,@StartDate,103),GETDATE(),@UserID, @TotalGST, @SGSTPer, @SGST, @CGSTPer, @CGST, @BillAmt)
  END

  RETURN 1
END