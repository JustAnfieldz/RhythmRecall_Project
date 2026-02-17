/*﻿
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Author         | Date             | Comments
--------------------------------------------------------------------------------------------------------------------------------------------------
-- Anuwat P.      | 2024-02-08       | Create Stored for testing concert paging
-- Vichayaphat P. | 2024-02-15       | Rewriting format
-- Anuwat P.	  | 2024-03-26		 | Add Param for filter
--------------------------------------------------------------------------------------------------------------------------------------------------
EXEC_TEST
	EXEC [dbo].[GetConcertListDataTable]
	REVERT;
END_EXEC_TEST
*/

CREATE PROCEDURE [dbo].[GetConcertListDataTable]
	-- Add the parameters for the stored procedure here
	@PageNumber		INT = 1,
	@PageSize		INT = 20,
	@ConcertName	NVARCHAR(150) = '',
	@Organizer		NVARCHAR(100) = '',
	@LocationId		INT = NULL,
	@DateStart		DATETIME = NULL,
	@DateEnd		DATETIME = NULL,
	@SortBy			NVARCHAR(4) = 1 -- 1 = DateCreated desc, 2 = DateCreated asc, 3 = NoOfLike desc, 4 = NoOfLike asc

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET XACT_ABORT ON;

    -- Insert statements for procedure here
	SELECT c.ConcertId, c.BannerUrl, c.ConcertName, l.LocationName, c.DateStart, c.DateEnd, c.IsOneDay, c.Organizer, c.DateCreated
	INTO #Temp
	FROM Concerts c
	INNER JOIN Locations l on l.LocationId = c.LocationId
	WHERE (c.ConcertName like ('%' + @ConcertName + '%') OR @ConcertName = '')
	AND (c.Organizer like ('%' + @Organizer + '%') OR @Organizer = '')
	AND (l.LocationId = @LocationId OR @LocationId IS NULL)
	AND (
		(@DateStart IS NOT NULL AND @DateEnd IS NULL AND (CONVERT(DATE, c.DateStart) = CONVERT(DATE, @DateStart) OR CONVERT(DATE, c.DateEnd) = CONVERT(DATE, @DateStart))) OR
		(@DateStart IS NOT NULL AND @DateEnd IS NOT NULL AND (c.DateStart BETWEEN @DateStart AND @DateEnd OR c.DateEnd BETWEEN @DateStart AND @DateEnd)) OR
		(@DateStart IS NULL AND @DateEnd IS NOT NULL AND (c.DateStart <= @DateEnd OR c.DateEnd <= @DateEnd)) OR
		(@DateStart IS NULL AND @DateEnd IS NULL)
	)
	
	SELECT @PageNumber as [Page], @PageSize as PageSize, IIF((SELECT COUNT(*) FROM #Temp) > @PageSize, CEILING((SELECT COUNT(*) FROM #Temp) / CAST(@PageSize AS FLOAT)), 1) as TotalPage,
	       ConcertId, BannerUrl, ConcertName, LocationName, DateStart, DateEnd, IsOneDay, Organizer, DateCreated
	FROM #Temp
	ORDER BY 
		CASE WHEN @SortBy = '1' THEN DateCreated END DESC,
		CASE WHEN @SortBy = '2' THEN DateCreated END ASC
	OFFSET (@PageNumber - 1) * @PageSize ROWS 
	FETCH NEXT  @PageSize ROWS ONLY OPTION (RECOMPILE);

	DROP TABLE #Temp
END
GO