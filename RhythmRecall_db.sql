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
	[CreatedBy] [nvarchar](50) NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	CONSTRAINT [PK_Locations] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Locations] ADD CONSTRAINT UQ01__LocationName__Address UNIQUE (LocationName, Address)
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
	[Organizer] [nvarchar](50) NOT NULL,
	[BannerURL] [nvarchar](200) NOT NULL,
	[ChartURL] [nvarchar](200) NOT NULL, 
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
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
	[Shape] [nvarchar](20) NULL,
	[Coords] [nvarchar](200) NULL,
	[ConcertId] [int] NOT NULL,
	[Description] [nvarchar](500)  NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50)  NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [nvarchar](50)  NULL,
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

CREATE TABLE [dbo].[Media](
	[MediaId] [int] IDENTITY(1,1) NOT NULL,
	[MediaName] [nvarchar](200) NOT NULL,
	[MediaType] [nvarchar](60) NOT NULL,
	[Description] [nvarchar](500) NOT NULL,
	[NoOfLike] [int] NULL,
	[ZoneId] [int] NOT NULL,
	[DateCreated] [datetime] NOT NULL,
	[CreatedBy] [nvarchar](50) NOT NULL,
	[DateModified] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	CONSTRAINT [PK_Media] PRIMARY KEY CLUSTERED
	(
	[MediaId] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Media] WITH CHECK ADD CONSTRAINT [FK_Zone_Media] FOREIGN KEY([ZoneId])
REFERENCES [dbo].[Zones] ([ZoneId])
GO

ALTER TABLE [dbo].[Media] CHECK CONSTRAINT [FK_Zone_Media]
GO

ALTER TABLE [dbo].[Media] ADD CONSTRAINT UQ01__MediaName UNIQUE (MediaName)
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

-- INSERTING DEFAULT DATA

INSERT INTO [dbo].[Locations] VALUES (N'Thunder Dome', N'47 569-576 หมู่ที่ 3 ถ. ป๊อปปูล่า ตำบลบ้านใหม่ อำเภอปากเกร็ด นนทบุรี 11120', GETDATE(), 'System', NULL, NULL)

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
    'https://rhythmrecallbucket.s3.ap-southeast-2.amazonaws.com/1/Concert_1_Banner',
    'https://rhythmrecallbucket.s3.ap-southeast-2.amazonaws.com/1/Concert_1_Chart',
    GETDATE(), -- DateCreated (current date and time)
    'System'
);

INSERT INTO [dbo].[Zones] VALUES (
    'A', 'Rectangle', '165,144', 1, 'This is Zone A of ITZY THE 1ST WORLD TOUR.', getdate(), 'System', null, null
)

INSERT INTO [dbo].[Zones] VALUES (
    'B', 'Square', '157,146', 1, 'This is Zone B of ITZY THE 1ST WORLD TOUR.', getdate(), 'System', null, null
)

INSERT INTO [dbo].[Media] VALUES (
    'https://rhythmrecallbucket.s3.ap-southeast-2.amazonaws.com/1/Media/20230408_172302.mp4','video/mp4', 
	'Media for ITZY 1st World Tour Concert', null, 1, getdate(), 'System', null, null
)