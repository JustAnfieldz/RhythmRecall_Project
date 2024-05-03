SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET XACT_ABORT ON;

CREATE DATABASE [RhythmRecall]
GO

/*
USE [master]
GO
*/
	
USE [RhythmRecall]
GO

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

/****** Object:  Table [dbo].[Locations]    Script Date: 10/12/2023 21:37:21 ******/

CREATE TABLE [dbo].[Locations](
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[LocationName] [nvarchar](200) NOT NULL,
	[Address] [nvarchar](500) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Locations] ADD CONSTRAINT UQ01__LocationName UNIQUE (LocationName)
GO

/****** Object:  Table [dbo].[Concerts]    Script Date: 10/12/2023 21:37:13 ******/

CREATE TABLE [dbo].[Concerts](
	[ConcertId] [int] IDENTITY(1,1) NOT NULL,
	[ConcertName] [nvarchar](150) NOT NULL,
	[DateStart] [datetime] NOT NULL,
	[DateEnd] [datetime] NOT NULL,
	[IsOneDay] [bit] NOT NULL,
	[LocationId] [int] NOT NULL,
	[Description] [nvarchar](1500) NULL,
	[Organizer] [nvarchar](100) NOT NULL,
	[BannerURL] [nvarchar](200) NOT NULL,
	[ChartURL] [nvarchar](200) NOT NULL, 
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Concerts] PRIMARY KEY CLUSTERED 
(
	[ConcertId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Concerts]  WITH CHECK ADD  CONSTRAINT [FK_Location_Concert] FOREIGN KEY([LocationId])
REFERENCES [dbo].[Locations] ([LocationId])
GO

ALTER TABLE [dbo].[Concerts] CHECK CONSTRAINT [FK_Location_Concert]
GO

ALTER TABLE [dbo].[Concerts] ADD CONSTRAINT UQ01__ConcertName UNIQUE (ConcertName)
GO

ALTER TABLE [dbo].[Concerts] ADD CONSTRAINT UQ02__BannerURL UNIQUE (BannerURL)
GO

ALTER TABLE [dbo].[Concerts] ADD CONSTRAINT UQ03__ChartURL UNIQUE (ChartURL)
GO

/****** Object:  Table [dbo].[Zones]    Script Date: 10/12/2023 21:37:35 ******/

CREATE TABLE [dbo].[Zones](
	[ZoneId] [int] IDENTITY(1,1) NOT NULL,
	[ZoneName] [nvarchar](20) NOT NULL,
	[Points] [nvarchar](1000) NULL,
	[ConcertId] [int] NOT NULL,
	[Description] [nvarchar](500)  NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Zone] PRIMARY KEY CLUSTERED 
(
	[ZoneId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Zones]  WITH CHECK ADD  CONSTRAINT [FK_Concert_Zone] FOREIGN KEY([ConcertId])
REFERENCES [dbo].[Concerts] ([ConcertId])
GO

ALTER TABLE [dbo].[Zones] CHECK CONSTRAINT [FK_Concert_Zone]
GO

ALTER TABLE [dbo].[Zones] ADD CONSTRAINT UQ01__ZoneName__ConcertId UNIQUE (ZoneName, ConcertId)
GO

CREATE TABLE [dbo].[Users] (
	[UserId] [uniqueidentifier] NOT NULL,
	[GoogleId] [nvarchar](255) NOT NULL,
	[Email] [nvarchar](255) NOT NULL,
	[User_name] [nvarchar](50) NOT NULL,
	[Profile_picture] [nvarchar](255) NULL,
	[Bio] [nvarchar](1000) NULL,
	[Role] [nvarchar](5) NOT NULL,
	[Refresh_token] [nvarchar](500) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD CONSTRAINT UQ01__GoogleId UNIQUE (GoogleId)
GO

ALTER TABLE [dbo].[Users] ADD CONSTRAINT UQ02__Email UNIQUE (Email)
GO

ALTER TABLE [dbo].[Users] ADD CONSTRAINT UQ03__Refresh_token UNIQUE (Refresh_token)
GO

CREATE TABLE [dbo].[Posts](
	[PostId] [int] IDENTITY(1,1) NOT NULL,
	[Caption] [nvarchar](500) NULL,
	[NoOfLike] [int] NOT NULL,
	[ZoneId] [int] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[isHided] [bit] NOT NULL,
	[isDeleted] [bit] NOT NULL,
	[ReportReason] [nvarchar](255) NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Posts] PRIMARY KEY CLUSTERED
	(
	[PostId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Posts] WITH CHECK ADD CONSTRAINT [FK_Zone_Posts] FOREIGN KEY([ZoneId])
REFERENCES [dbo].[Zones] ([ZoneId])
GO

ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK_Zone_Posts]
GO

ALTER TABLE [dbo].[Posts]  WITH CHECK ADD  CONSTRAINT [FK_Users_Posts] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[Posts] CHECK CONSTRAINT [FK_Users_Posts]
GO

CREATE TABLE [dbo].[Media](
	[MediaId] [int] IDENTITY(1,1) NOT NULL,
	[MediaName] [nvarchar](200) NOT NULL,
	[MediaType] [nvarchar](60) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[PostId] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Media] PRIMARY KEY CLUSTERED
	(
	[MediaId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Media] WITH CHECK ADD CONSTRAINT [FK_Posts_Media] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([PostId])
GO

ALTER TABLE [dbo].[Media] CHECK CONSTRAINT [FK_Posts_Media]
GO

ALTER TABLE [dbo].[Media] ADD CONSTRAINT UQ01__MediaName UNIQUE (MediaName)
GO

/*
CREATE TABLE [dbo].[LikedPosts] (
	[LikeId] [int] IDENTITY(1,1) NOT NULL,
	[ByUserId] [uniqueidentifier] NOT NULL,
	[PostId] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_LikedPosts] PRIMARY KEY CLUSTERED	
(
	[LikeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[LikedPosts] ADD CONSTRAINT UQ01__ByUserId__PostId UNIQUE (ByUserId, PostId)
GO

ALTER TABLE [dbo].[LikedPosts]  WITH CHECK ADD  CONSTRAINT [FK_Posts_LikedPosts] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([PostId])
GO

ALTER TABLE [dbo].[LikedPosts] CHECK CONSTRAINT [FK_Posts_LikedPosts]
GO

ALTER TABLE [dbo].[LikedPosts]  WITH CHECK ADD  CONSTRAINT [FK_Users_LikedPosts] FOREIGN KEY([ByUserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[LikedPosts] CHECK CONSTRAINT [FK_Users_LikedPosts]
GO

CREATE TABLE [dbo].[Comments] (
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[ByUserId] [uniqueidentifier] NOT NULL,
	[PostId] [int] NOT NULL,
	[Comment] [varchar](1000) NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED	
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Posts_Comments] FOREIGN KEY([PostId])
REFERENCES [dbo].[Posts] ([PostId])
GO

ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Posts_Comments]
GO

ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Users_Comments] FOREIGN KEY([ByUserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Users_Comments]
GO
*/

CREATE TABLE [dbo].[ReportedLogs] (
	[ReportId] [int] IDENTITY(1,1) NOT NULL,
	[ReportReason] [nvarchar](500) NOT NULL,
	[ByUserId] [uniqueidentifier] NOT NULL,
	[PostId] [int] NOT NULL,
	[isCompleted] [bit] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [uniqueidentifier] NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	CONSTRAINT [PK_ReportedLogs] PRIMARY KEY CLUSTERED	
(
	[ReportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReportedLogs]  WITH CHECK ADD  CONSTRAINT [FK_Users_ReportedLogs] FOREIGN KEY([ByUserId])
REFERENCES [dbo].[Users] ([UserId])
GO

ALTER TABLE [dbo].[ReportedLogs] CHECK CONSTRAINT [FK_Users_ReportedLogs]
GO

ALTER TABLE [dbo].[ReportedLogs] ADD CONSTRAINT UQ01__ByUserId__PostId UNIQUE (ByUserId, PostId)
GO

-- CREATING NON CLUSTERED INDEX

CREATE NONCLUSTERED INDEX IX01__BannerURL__ConcertName__DateStart ON [dbo].[Concerts]
(
	[BannerURL] ASC
	,[ConcertName] ASC
	,[DateStart] ASC
)
WITH (DATA_COMPRESSION = PAGE, MAXDOP = 1)
GO

CREATE NONCLUSTERED INDEX IX01__Caption__NoOfLike__UserId__DateCreated__CreatedBy__isHided__isDeleted__INC ON [dbo].[Posts]
(
	[Caption] ASC
	,[NoOfLike] ASC
	,[UserId] ASC
	,[DateCreated] ASC
	,[CreatedBy] ASC
	,[isHided] ASC
	,[isDeleted] ASC
)
INCLUDE (ZoneId)
WITH (DATA_COMPRESSION = PAGE, MAXDOP = 1)
GO

CREATE NONCLUSTERED INDEX IX01__User_name__Profile_picture ON [dbo].[Users]
(
	[User_name] ASC
	,[Profile_picture] ASC
)
WITH (DATA_COMPRESSION = PAGE, MAXDOP = 1)
GO

-- INSERTING DEFAULT DATA

INSERT INTO [dbo].[Users] VALUES (
	'1967A7D3-F876-4596-9EEB-AD31EA25B774', '111948484750626382289', 'mojojojoeiei@gmail.com', 'NINE NP.',
	'https://lh3.googleusercontent.com/a/ACg8ocJrtXY44e7NPucIATVQS6Mq4Ql8SS38nsZIpoy3bLnPahA=s96-c', NULL, 'admin', 
	'xxxxxxx', getdate(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', NULL, NULL -- ADMIN ACCOUNT
),
(	'8E282F23-2F95-4368-930B-BFF7C602649B', '114155972441887554518', 'nutchanon.nine@mail.kmutt.ac.th', 'NUTCHANON ASSAWACHIN',
	'https://lh3.googleusercontent.com/a/ACg8ocJOoKVzvvfQNml2JvvsbzD8OFyBjch2wyp4GHgqVx2g=s96-c', NULL, 'user',
	'xxxxxxxxxx', getdate(), '8E282F23-2F95-4368-930B-BFF7C602649B', NULL, NULL -- USER ACCOUNT
)

INSERT INTO [dbo].[Locations] VALUES (
	N'Thunder Dome', N'47 569-576 หมู่ที่ 3 ถ. ป๊อปปูล่า ตำบลบ้านใหม่ อำเภอปากเกร็ด นนทบุรี 11120', 
	GETDATE(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', NULL, NULL
)

INSERT INTO [dbo].[Concerts] (
    [ConcertName],
    [DateStart],
    [DateEnd],
    [IsOneDay],
    [LocationID],
    [Description],
    [Organizer],
    [BannerURL],
    [ChartURL],
    [DateCreated],
    [CreatedBy]
) VALUES (
    'ITZY THE 1ST WORLD TOUR < CHECKMATE > BANGKOK',
    '2023-04-08 10:00:00', -- DateStart
    '2023-04-08 12:00:00', -- DateEnd
    1, -- IsOneDay (1 for true)
    1, -- LocationID (assuming this refers to an existing location)
    N'มาตรการสําหรับผู้เข้าชมการแสดง 
	• ผู้เข้าชมทุกท่านต้องสวมหน้ากากอนามัยตลอดการชมการแสดง
	• รักษาระยะห่างระหว่างบุคคล 
	• ไม่อนุญาตให้เปลี่ยนหรือย้ายที่นั่ง
	• ทำความสะอาดมืออยู่เสมอ ด้วยเจลแอลกอฮอล์ที่จัดให้บริการตามจุดต่างๆ ภายในบริเวณงาน
	• ไม่อนุญาตให้นำสิ่งของต้องห้ามเข้าภายในฮอลล์ ได้แก่ อาวุธทุกชนิด กล้องและเครื่องบันทึกเสียงทุกชนิด อาหาร และเครื่องดื่ม กระเป๋าขนาดใหญ่ ไม้เซลฟี่ แท็ปเล็ต หรือ โน้ตบุคที่มีขนาดเกินกว่า 7” ปากกาเลเซอร์ เป็นต้น
	• กรุณาเผื่อเวลาในการเดินทางและการตรวจคัดกรองก่อนเข้าชมการแสดง อย่างน้อย 1 ชม. ก่อนเริ่มการแสดง \n • เพื่อเป็นการป้องกันแพร่ระบาดของโรคโควิด-19 หากท่านมีอาการป่วย ไอ จาม มีน้ำมูก หรือมีไข้สูงเกินกว่า 37.5 องศาเซลเซียส หรือมีผลตรวจโควิด-19 เป็นบวก ผู้จัดมีสิทธิปฏิเสธการเข้าชมการแสดงได้ โดยทางผู้จัดสงวนสิทธิในการไม่คืนเงินในทุกกรณี',
    'THAITICKETMAJOR',
    'https://firebasestorage.googleapis.com/v0/b/rhythmrecall.appspot.com/o/1%2FConcert_1_Banner.jpg?alt=media',
    'https://firebasestorage.googleapis.com/v0/b/rhythmrecall.appspot.com/o/1%2FConcert_1_Chart.png?alt=media',
    GETDATE(), -- DateCreated (current date and time)
    '1967A7D3-F876-4596-9EEB-AD31EA25B774'
);

INSERT INTO [dbo].[Zones] VALUES (
    'A1', '[{ x: 238, y: 473 },{ x: 319, y: 473 },{ x: 319, y: 439 },{ x: 352, y: 439 },{ x: 351, y: 327 },{ x: 238, y: 331 },]', 
	1, 'This is Zone A1 of ITZY THE 1ST WORLD TOUR.', getdate(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', null, null
),
(
    'D', '[{ x: 330, y: 662 },{ x: 330, y: 737 },{ x: 212, y: 739 },{ x: 176, y: 701 },{ x: 189, y: 687 },{ x: 204, y: 703 },{ x: 241, y: 662 },]', 
	1, 'This is Zone D of ITZY THE 1ST WORLD TOUR.', getdate(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', null, null
),
(
    'G', '[{ x: 586, y: 690 },{ x: 573, y: 679 },{ x: 590, y: 663 },{ x: 547, y: 625 },{ x: 549, y: 535 },{ x: 622, y: 535 },{ x: 623, y: 654 },]', 
	1, 'This is Zone G of ITZY THE 1ST WORLD TOUR.', getdate(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', null, null
)

INSERT INTO [dbo].[Posts] VALUES (
	'#Concerttour2024', 0, 1, '1967A7D3-F876-4596-9EEB-AD31EA25B774', 0, 0, getdate(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', null, null
)

INSERT INTO [dbo].[Media] VALUES (
    'https://firebasestorage.googleapis.com/v0/b/rhythmrecall.appspot.com/o/1%2FMedia%2F20230408_172302.mp4?alt=media','video/mp4', 
	'test.mp4', 1, getdate(), '1967A7D3-F876-4596-9EEB-AD31EA25B774', null, null
)
