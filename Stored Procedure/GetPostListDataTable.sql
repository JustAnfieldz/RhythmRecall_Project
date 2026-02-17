/*﻿
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Author         | Date             | Comments
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Anuwat P.      | 2024-03-27       | Create Stored for media post paging
-- Vichayaphat P. | 2024-04-02       | Getting data into #Temp to count after filtering
--------------------------------------------------------------------------------------------------------------------------------------------------
EXEC_TEST
	EXEC [dbo].[GetPostListDataTable]
	REVERT;
END_EXEC_TEST
*/

CREATE PROCEDURE [dbo].[GetPostListDataTable]
	-- Add the parameters for the stored procedure here
	@PageNumber		INT = 1,
	@PageSize		INT = 20,
	@ZoneId			INT,
	@UserId			UNIQUEIDENTIFIER = NULL,
	@DateCreated	DATETIME = NULL,
	@SortBy			NVARCHAR(4) = 1 -- 1 = DateCreated desc, 2 = DateCreated asc, 3 = NoOfLike desc, 4 = NoOfLike asc

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET XACT_ABORT ON;

    SELECT z.ZoneId, z.ZoneName, c.concertName, c.chartURL, u.User_name, u.Profile_picture, p.PostId, p.Caption, p.NoOfLike, p.UserId, p.DateCreated, p.CreatedBy, p.isHided, p.isDeleted
	INTO #Temp
	FROM Posts p
	INNER JOIN Zones z on z.ZoneId = p.ZoneId
	INNER JOIN Concerts c on c.ConcertId = z.ConcertId
	INNER JOIN Users u on u.UserId = p.UserId
	WHERE p.ZoneId = @ZoneId
	AND (p.isHided = 0 OR (p.UserId = @UserId AND @UserId IS NOT NULL))
	AND (p.isDeleted = 0 OR (p.UserId = @UserId AND @UserId IS NOT NULL))

	SELECT ZoneId, IIF((SELECT COUNT(*) FROM #Temp) > @PageSize, CEILING((SELECT COUNT(*) FROM #Temp) / CAST(@PageSize AS FLOAT)), 1) as TotalPage,
	       ZoneName, concertName, chartURL, User_name as UserName, Profile_picture as Avatar, PostId, Caption, NoOfLike, UserId, isHided, isDeleted, DateCreated, CreatedBy
	FROM #Temp
	ORDER BY CASE WHEN @SortBy = 1 THEN DateCreated END DESC,
			 CASE WHEN @SortBy = 2 THEN DateCreated END ASC,
			 CASE WHEN @SortBy = 3 THEN NoOfLike END DESC,
			 CASE WHEN @SortBy = 4 THEN NoOfLike END ASC
	OFFSET (@PageNumber - 1) * @Pagesize ROWS 
	FETCH NEXT  @PageSize ROWS ONLY OPTION (RECOMPILE);

	DROP TABLE #Temp

END
GO