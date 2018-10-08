USE [TailerAppDB]
GO
/****** Object:  StoredProcedure [dbo].[GetPickLists]    Script Date: 25-09-2018 23:39:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[GetPickLists]
(
	@companyID INT,
	@user INT,
	@PickListName VARCHAR(50)
)
AS

BEGIN
	
	SELECT PickListValues.PickListValue, PickListValues.PickListLabel
		FROM PickListValues WITH (NOLOCK),PickListMaster WITH (NOLOCK)
			WHERE PickListValues.PickListMasterID=PickListMaster.PickListMasterID
				AND PickListMaster.PickListName=@PickListName
					FOR JSON PATH,INCLUDE_NULL_VALUES


	RETURN 1
END