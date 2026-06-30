USE ClothesShop;
GO

IF OBJECT_ID('trg_DeleteBlogComment', 'TR') IS NOT NULL
    DROP TRIGGER trg_DeleteBlogComment;
GO

CREATE TRIGGER trg_DeleteBlogComment
ON BlogComment
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. Lấy tất cả con cháu của các ID bị xóa
    ;WITH Descendants AS (
        SELECT ID, parentCommentID, 0 AS Level
        FROM deleted
        UNION ALL
        SELECT bc.ID, bc.parentCommentID, d.Level + 1
        FROM BlogComment bc
        INNER JOIN Descendants d ON bc.parentCommentID = d.ID
    )
    SELECT ID, Level
    INTO #TempToDelete
    FROM Descendants;

    -- 2. Xóa từ dưới lên trên (Level cao nhất xóa trước)
    DECLARE @MaxLevel INT;
    SELECT @MaxLevel = MAX(Level) FROM #TempToDelete;

    WHILE @MaxLevel >= 0
    BEGIN
        DELETE FROM BlogComment
        WHERE ID IN (SELECT ID FROM #TempToDelete WHERE Level = @MaxLevel);

        SET @MaxLevel = @MaxLevel - 1;
    END

    DROP TABLE #TempToDelete;
END;
GO
