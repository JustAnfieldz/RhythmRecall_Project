/*﻿
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Author         | Date             | Comments
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Vichayaphat P. | 2024-03-28       | Creating SP for inserting [dbo].[Users]
-- Vichayaphat P. | 2024-04-01       | Adding Refresh_token column for inserting
--------------------------------------------------------------------------------------------------------------------------------------------------
EXEC_TEST
	BEGIN TRANSACTION
	EXEC [dbo].[InsertUsers] @GoogleId = 'test', @Email = 'anf.patthikarnsakul@gmail.com',
	@User_name = 'JustAnfieldz', @Profile_picture = 'test', @Bio = 'Hello World',
	@Refresh_token = 'xxxxxxxxxxxx'
	ROLLBACK TRANSACTION
END_EXEC_TEST
*/

CREATE PROCEDURE [dbo].[InsertUsers]
	@GoogleId         NVARCHAR(255),
	@Email            NVARCHAR(255),
	@User_name        NVARCHAR(255),
	@Profile_picture  NVARCHAR(255),
	@Bio              NVARCHAR(255) = NULL,
	@Refresh_token    NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET XACT_ABORT ON;

    DECLARE @UserId       UNIQUEIDENTIFIER  = NEWID(),
            @DateCreated  DATETIME          = GETDATE(),
            @Role         NVARCHAR(5)       = 'user';

    BEGIN TRY
        BEGIN TRANSACTION;
        
        INSERT INTO [dbo].[Users] (UserId, GoogleId, Email, User_name, Profile_picture, Bio, Role, Refresh_token, DateCreated, CreatedBy, DateModified, ModifiedBy)
        VALUES (@UserId, @GoogleId, @Email, @User_name, @Profile_picture, @Bio, @Role, @Refresh_token, @DateCreated, @UserId, NULL, NULL);
        
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