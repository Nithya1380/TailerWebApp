ALTER PROCEDURE GetItemRates
( 
    @CompanyID INT,
	@UserID INT,
	@ItemMasterID INT,
	@ItemRateID INT
)

AS
BEGIN
   IF(ISNULL(@CompanyID,0)=0 OR ISNULL(@ItemMasterID,0)=0)
	 RETURN -1

   SELECT ItemRateID,
          ItemMasterID,
		  CASE WHEN StartDate IS NULL THEN 'From Begining' ELSE CONVERT(VARCHAR,StartDate,101) END AS StartDate,
		  CASE WHEN EndDate IS NULL THEN 'Till End' ELSE CONVERT(VARCHAR,EndDate,101) END AS EndDate,
		  ItemPrice,
		  TotalGST,
		  SGSTPer,
		  SGST,
		  CGSTPer,
		  CGST,
		  BillAmt 
     FROM ItemRates WITH(nolock)
	   WHERE CompanyID=@CompanyID
	     AND ItemMasterID=@ItemMasterID
		 AND (ISNULL(@ItemRateID,0)=0 OR ItemRateID=@ItemRateID)
		 AND ISNULL(isDeleted,0)=0
		  FOR JSON PATH
  
    RETURN 1
END