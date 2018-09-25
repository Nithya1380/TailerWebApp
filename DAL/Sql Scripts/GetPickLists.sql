ALTER PROCEDURE DBO.GetPickLists
(
	@companyID INT,
	@PickListName VARCHAR(50)
)
AS

BEGIN
	
	SELECT PickListValues.PickListValue,PickListValue,PickListLabel
		FROM PickListValues WITH (NOLOCK),PickListMaster WITH (NOLOCK)
			WHERE PickListValues.PickListMasterID=PickListMaster.PickListMasterID
				AND PickListMaster.PickListName=@PickListName
					FOR JSON PATH,INCLUDE_NULL_VALUES


	RETURN 1
END