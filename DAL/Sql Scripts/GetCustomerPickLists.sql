ALTER PROCEDURE DBO.GetCustomerPickLists
(
	@companyID INT,
	@CustomerID INT,
	@UserID INT
)
AS

BEGIN
		EXEC GetPickLists @companyID, @UserID, 'AccountCategory'

		EXEC GetPickLists @companyID, @UserID,'AccountDateCategory'

		EXEC GetPickLists @companyID, @UserID,'AccountParentType'

		EXEC GetPickLists @companyID, @UserID,'AccountReverse'

		EXEC GetPickLists @companyID, @UserID,'AccountSch6Group'

		EXEC GetPickLists @companyID, @UserID,'AccountTDSCategory'

		EXEC GetPickLists @companyID, @UserID,'AccountTDSDefault'

		EXEC GetPickLists @companyID, @UserID,'AccountType'

		EXEC GetPickLists @companyID, @UserID,'City'

		EXEC GetPickLists @companyID, @UserID,'Country'

		EXEC GetPickLists @companyID, @UserID,'State'

		EXEC GetPickLists @companyID, @UserID,'SRNames'

		EXEC GetPickLists @companyID, @UserID,'SupplierCategories'

		EXEC GetPickLists @companyID, @UserID,'SupplierTypes'

		RETURN 1

		
END