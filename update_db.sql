USE ClothesShop;
GO

IF OBJECT_ID('sp_DeleteBlogComment', 'P') IS NOT NULL
    DROP PROCEDURE sp_DeleteBlogComment;
GO

CREATE PROCEDURE sp_DeleteBlogComment
    @CommentID INT,
    @AccountID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @AccountID IS NOT NULL
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM BlogComment WHERE ID = @CommentID AND accountID = @AccountID)
        BEGIN
            RETURN 0;
        END
    END

    ;WITH Descendants AS (
        SELECT ID, parentCommentID, 0 AS Level
        FROM BlogComment WHERE ID = @CommentID
        UNION ALL
        SELECT bc.ID, bc.parentCommentID, d.Level + 1
        FROM BlogComment bc
        INNER JOIN Descendants d ON bc.parentCommentID = d.ID
    )
    SELECT ID, Level
    INTO #TempToDelete
    FROM Descendants;

    DECLARE @MaxLevel INT;
    SELECT @MaxLevel = MAX(Level) FROM #TempToDelete;
    DECLARE @RowsDeleted INT = 0;

    WHILE @MaxLevel >= 0
    BEGIN
        DELETE FROM BlogComment
        WHERE ID IN (SELECT ID FROM #TempToDelete WHERE Level = @MaxLevel);
        
        SET @RowsDeleted = @RowsDeleted + @@ROWCOUNT;
        SET @MaxLevel = @MaxLevel - 1;
    END

    DROP TABLE #TempToDelete;
    RETURN @RowsDeleted;
END;
GO
