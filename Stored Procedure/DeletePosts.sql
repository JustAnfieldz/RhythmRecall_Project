/*
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Author         | Date             | Comments
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Vichayaphat P. | 2024-04-01       | Creating SP for Deleting [dbo].[Posts] and [dbo].[Media]
--------------------------------------------------------------------------------------------------------------------------------------------------
EXEC_TEST
	BEGIN TRANSACTION
	EXEC [dbo].[DeletePosts] @PostId = 1
	ROLLBACK TRANSACTION
END_EXEC_TEST
*/

CREATE PROCEDURE [dbo].[DeletePosts]
	
	@PostId	      INT

AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET XACT_ABORT ON;

    BEGIN TRY 
        BEGIN TRANSACTION;
        
        DELETE FROM [dbo].[Media]
        WHERE PostId = @PostId

        DELETE FROM [dbo].[Posts]
        WHERE PostId = @PostId
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ;THROW;
    END CATCH;
END;
GO