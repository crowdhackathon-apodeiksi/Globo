USE [master]
GO
/****** Object:  Database [hackathonDB]    Script Date: 14/6/2015 9:41:27 μμ ******/
CREATE DATABASE [hackathonDB] ON  PRIMARY 
( NAME = N'hackathonDB', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL.3\MSSQL\DATA\hackathonDB.mdf' , SIZE = 2048KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'hackathonDB_log', FILENAME = N'c:\Program Files (x86)\Microsoft SQL Server\MSSQL.3\MSSQL\DATA\hackathonDB_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [hackathonDB] SET COMPATIBILITY_LEVEL = 90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [hackathonDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [hackathonDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [hackathonDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [hackathonDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [hackathonDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [hackathonDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [hackathonDB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [hackathonDB] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [hackathonDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [hackathonDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [hackathonDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [hackathonDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [hackathonDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [hackathonDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [hackathonDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [hackathonDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [hackathonDB] SET  DISABLE_BROKER 
GO
ALTER DATABASE [hackathonDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [hackathonDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [hackathonDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [hackathonDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [hackathonDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [hackathonDB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [hackathonDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [hackathonDB] SET  MULTI_USER 
GO
ALTER DATABASE [hackathonDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [hackathonDB] SET DB_CHAINING OFF 
GO
USE [hackathonDB]
GO
/****** Object:  User [hackathonUser]    Script Date: 14/6/2015 9:41:28 μμ ******/
CREATE USER [hackathonUser] FOR LOGIN [hackathonUser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  StoredProcedure [dbo].[get_statistical_data]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[get_statistical_data] 
	@dateFrom DATETIME,
	@dateTo DATETIME,
	@city NVARCHAR(50)
AS
BEGIN

	SET NOCOUNT ON;

	IF (@city IS NULL)
	BEGIN
		IF (@dateFrom IS NULL AND @dateTo IS NULL)
		BEGIN
			SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts 
			INNER JOIN Companies ON Receipts.afm = Companies.afm
			INNER JOIN Categories ON Categories.id = Companies.categoryid
			INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
			WHERE Receipts.user_registration_id IS NOT NULL
		END
		ELSE 
		BEGIN
			IF (@dateFrom IS NULL)
			BEGIN
				SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts 
				INNER JOIN Companies ON Receipts.afm = Companies.afm 
				INNER JOIN Categories ON Categories.id = Companies.categoryid
				INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
				WHERE Receipts.date_issued <= @dateTo AND Receipts.user_registration_id IS NOT NULL
			END
			ELSE IF (@dateTo IS NULL)
			BEGIN
				SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts 
				INNER JOIN Companies ON Receipts.afm = Companies.afm 
				INNER JOIN Categories ON Categories.id = Companies.categoryid
				INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
				WHERE Receipts.date_issued >= @dateFrom AND Receipts.user_registration_id IS NOT NULL
			END
			ELSE 
			BEGIN
				SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts 
				INNER JOIN Companies ON Receipts.afm = Companies.afm 
				INNER JOIN Categories ON Categories.id = Companies.categoryid
				INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
				WHERE Receipts.date_issued <= @dateTo AND Receipts.date_issued >= @dateFrom AND Receipts.user_registration_id IS NOT NULL
			END
		END
	END
	ELSE 
	BEGIN	
		IF (@dateFrom IS NULL AND @dateTo IS NULL)
		BEGIN
			SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts  
			INNER JOIN Companies ON Receipts.afm = Companies.afm
			INNER JOIN Categories ON Categories.id = Companies.categoryid
			INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
			WHERE Receipts.user_registration_id IS NOT NULL AND Companies.city = @city
		END
		ELSE 
		BEGIN
			IF (@dateFrom IS NULL)
			BEGIN
				SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts 
				INNER JOIN Companies ON Receipts.afm = Companies.afm 
				INNER JOIN Categories ON Categories.id = Companies.categoryid
				INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
				WHERE Receipts.date_issued <= @dateTo AND Receipts.user_registration_id IS NOT NULL AND Companies.city = @city
			END
			ELSE IF (@dateTo IS NULL)
			BEGIN
				SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts 
				INNER JOIN Companies ON Receipts.afm = Companies.afm 
				INNER JOIN Categories ON Categories.id = Companies.categoryid
				INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
				WHERE Receipts.date_issued >= @dateFrom AND Receipts.user_registration_id IS NOT NULL AND Companies.city = @city
			END
			ELSE 
			BEGIN
				SELECT User_info.[dob],User_info.[gender], User_info.[country], User_info.[city], Receipts.[afm], Receipts.[receipt_no], 
				   Receipts.[date_issued], Receipts.[amount], Receipts.[vat], Receipts.ccn, Companies.[company_name], Companies.[categoryid], [Categories].[cat_name]
			FROM Receipts  
				INNER JOIN Companies ON Receipts.afm = Companies.afm
				INNER JOIN Categories ON Categories.id = Companies.categoryid
				INNER JOIN User_info ON User_info.userid = Receipts.user_registration_id
				WHERE Receipts.date_issued <= @dateTo AND Receipts.date_issued >= @dateFrom AND Receipts.user_registration_id IS NOT NULL AND Companies.city = @city
			END
		END
	END

	SET NOCOUNT OFF;
	
END

GO
/****** Object:  StoredProcedure [dbo].[getExpensesPerUser]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[getExpensesPerUser]
	@userid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Receipts.categoryid, SUM(FLOOR(Receipts.amount)) as catAmount, Categories.cat_name
	FROM Receipts 
	INNER JOIN Categories ON Receipts.categoryid = Categories.id
	WHERE Receipts.user_registration_id = @userid 
	GROUP BY Receipts.categoryid, Categories.cat_name
	ORDER BY catAmount DESC


	SET NOCOUNT OFF;
END


GO
/****** Object:  StoredProcedure [dbo].[getReceipts]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[getReceipts]
	@userid int,
	@langid int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT Receipts.id, Receipts.afm, Receipts.receipt_no, Receipts.date_issued, Receipts.amount, Receipts.vat, Receipts.ccn, Receipts.categoryid, Receipts.user_registration_id, Receipts.company_reg_id, Categories.cat_name, Companies.company_name
    FROM Receipts
   INNER JOIN Categories ON Receipts.categoryid = Categories.id
   INNER JOIN Companies ON Companies.afm = Receipts.afm
   WHERE user_registration_id = @userid AND langid = @langid

   SET NOCOUNT OFF;

END

GO
/****** Object:  StoredProcedure [dbo].[insertCompaint]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[insertCompaint] 	
	@userid int,
	@afm NVARCHAR(50),
	@desc NVARCHAR(MAX),
	@date datetime,
	@longitude NVARCHAR(50),
	@latitude NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	INSERT INTO [dbo].[Complaints] ([userid], [description], [date], [longitude], [latitude], [afm])
	VALUES ( @userid, @desc, @date, @longitude, @latitude, @afm );

	SELECT 1 AS response;
	
	SET NOCOUNT OFF;

END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertToReceipts]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_InsertToReceipts] 
	@afm nvarchar(50),
	@receipt_no int,
	@date_issued Datetime,
	@amount float,
	@vat float,
	@ccn int,
	@categoryid int,
	@user_registration_id int,
	@langid int
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @total int
	SELECT @total = [user_points] FROM [dbo].[User_info] WHERE [userid] = @user_registration_id

	IF( (SELECT COUNT(id)  FROM [dbo].[Companies] WHERE [afm] = @afm) = 0)
	BEGIN 
		INSERT INTO [dbo].[Companies] ([afm], [company_name], [categoryid], [country], [city], [address], [phone], [rating])
		VALUES ( @afm, 'Unknown company', @categoryid, '', '', '', '', 0 );
	END

	IF((SELECT COUNT(id)  FROM Receipts
	WHERE [afm] = @afm AND [receipt_no] = @receipt_no) = 0)
		BEGIN 
			INSERT INTO [hackathonDB].[dbo].[Receipts] ([afm] ,[receipt_no], [date_issued] ,[amount] ,[vat] ,[ccn] ,[categoryid] ,[user_registration_id] ,[langid])
			VALUES ( @afm, @receipt_no, @date_issued, @amount, @vat, @ccn, @categoryid, @user_registration_id, @langid );

			UPDATE [User_info] SET [user_points] = ((@total) + FLOOR(@amount)) WHERE [User_info].[userid] = @user_registration_id;
		
			SELECT 1 AS MSG;

		END
	ELSE
		BEGIN
			IF ((SELECT COUNT(id)  FROM Receipts
				WHERE [afm] = @afm AND [receipt_no] = @receipt_no AND [Receipts].[user_registration_id] IS NULL ) > 0 )
				BEGIN
					UPDATE [Receipts] SET [user_registration_id] = @user_registration_id WHERE [afm] = @afm AND [receipt_no] = @receipt_no;

					UPDATE [User_info] SET [user_points] = ((@total) + FLOOR(@amount)) WHERE [User_info].[userid] = @user_registration_id;

					SELECT 1 AS MSG;
				END
			ELSE 
				BEGIN
					SELECT 0 AS MSG;
				END
		END

	SET NOCOUNT OFF;

END


GO
/****** Object:  Table [dbo].[Badges]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Badges](
	[id] [int] NOT NULL,
	[title] [nvarchar](50) NULL,
	[descriptionbefore] [nvarchar](max) NULL,
	[photourl] [nvarchar](50) NULL,
	[points] [int] NULL,
	[langid] [int] NOT NULL,
	[descriptionafter] [nvarchar](max) NULL,
 CONSTRAINT [PK_Badges] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[langid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Categories]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cat_name] [nvarchar](50) NULL,
	[cat_desc] [nvarchar](max) NULL,
	[languageid] [int] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[languageid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Companies]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Companies](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[afm] [nvarchar](50) NOT NULL,
	[company_name] [nvarchar](50) NULL,
	[categoryid] [int] NOT NULL,
	[country] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[address] [nvarchar](50) NULL,
	[phone] [nvarchar](50) NULL,
	[rating] [int] NULL,
 CONSTRAINT [PK_Companies] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Complaints]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Complaints](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[userid] [int] NOT NULL,
	[description] [nvarchar](max) NULL,
	[date] [datetime] NULL,
	[longitude] [nvarchar](50) NULL,
	[latitude] [nvarchar](50) NULL,
	[afm] [nvarchar](50) NULL,
 CONSTRAINT [PK_Complaints] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Languages]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[id] [int] NOT NULL,
	[language] [nvarchar](10) NOT NULL,
 CONSTRAINT [PK_Languages] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Offer_details]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Offer_details](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[offerid] [int] NOT NULL,
	[languageid] [int] NOT NULL,
	[title] [nvarchar](50) NULL,
	[description] [nvarchar](max) NULL,
	[photourl] [nvarchar](50) NULL,
	[photourlList] [nvarchar](50) NULL,
 CONSTRAINT [PK_Offer_details] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Offers]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Offers](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[companyid] [int] NOT NULL,
	[points_required] [int] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK_Offers] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Receipts]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Receipts](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[afm] [nvarchar](50) NOT NULL,
	[receipt_no] [int] NOT NULL,
	[date_issued] [datetime] NULL,
	[amount] [float] NULL,
	[vat] [float] NULL,
	[ccn] [int] NULL,
	[categoryid] [int] NOT NULL,
	[user_registration_id] [int] NULL,
	[company_reg_id] [int] NULL,
	[langid] [int] NOT NULL,
 CONSTRAINT [PK_Receipts] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[user_badge]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_badge](
	[userid] [int] NOT NULL,
	[badgeid] [int] NOT NULL,
	[langid] [int] NOT NULL,
 CONSTRAINT [PK_user_badge] PRIMARY KEY CLUSTERED 
(
	[userid] ASC,
	[badgeid] ASC,
	[langid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[User_info]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User_info](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[fname] [nvarchar](50) NULL,
	[lname] [nvarchar](50) NULL,
	[dob] [datetime] NULL,
	[gender] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[phone] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[address] [nvarchar](50) NULL,
	[postcode] [int] NULL,
	[afm] [nvarchar](50) NOT NULL,
	[userid] [int] NOT NULL,
	[user_points] [int] NULL,
 CONSTRAINT [PK_User_info] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 14/6/2015 9:41:28 μμ ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[username] [nvarchar](50) NOT NULL,
	[isLocal] [bit] NOT NULL,
	[password] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Badges]  WITH CHECK ADD  CONSTRAINT [FK_Badges_Languages] FOREIGN KEY([langid])
REFERENCES [dbo].[Languages] ([id])
GO
ALTER TABLE [dbo].[Badges] CHECK CONSTRAINT [FK_Badges_Languages]
GO
ALTER TABLE [dbo].[Categories]  WITH CHECK ADD  CONSTRAINT [FK_Categories_Languages] FOREIGN KEY([languageid])
REFERENCES [dbo].[Languages] ([id])
GO
ALTER TABLE [dbo].[Categories] CHECK CONSTRAINT [FK_Categories_Languages]
GO
ALTER TABLE [dbo].[Complaints]  WITH CHECK ADD  CONSTRAINT [FK_Complaints_Users] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[Complaints] CHECK CONSTRAINT [FK_Complaints_Users]
GO
ALTER TABLE [dbo].[Offer_details]  WITH CHECK ADD  CONSTRAINT [FK_Offer_details_Languages] FOREIGN KEY([languageid])
REFERENCES [dbo].[Languages] ([id])
GO
ALTER TABLE [dbo].[Offer_details] CHECK CONSTRAINT [FK_Offer_details_Languages]
GO
ALTER TABLE [dbo].[Offer_details]  WITH CHECK ADD  CONSTRAINT [FK_Offer_details_Offers] FOREIGN KEY([offerid])
REFERENCES [dbo].[Offers] ([id])
GO
ALTER TABLE [dbo].[Offer_details] CHECK CONSTRAINT [FK_Offer_details_Offers]
GO
ALTER TABLE [dbo].[Offers]  WITH CHECK ADD  CONSTRAINT [FK_Offers_Companies] FOREIGN KEY([companyid])
REFERENCES [dbo].[Companies] ([id])
GO
ALTER TABLE [dbo].[Offers] CHECK CONSTRAINT [FK_Offers_Companies]
GO
ALTER TABLE [dbo].[Receipts]  WITH CHECK ADD  CONSTRAINT [FK_Receipts_Categories] FOREIGN KEY([categoryid], [langid])
REFERENCES [dbo].[Categories] ([id], [languageid])
GO
ALTER TABLE [dbo].[Receipts] CHECK CONSTRAINT [FK_Receipts_Categories]
GO
ALTER TABLE [dbo].[user_badge]  WITH CHECK ADD  CONSTRAINT [FK_user_badge_Badges] FOREIGN KEY([badgeid], [langid])
REFERENCES [dbo].[Badges] ([id], [langid])
GO
ALTER TABLE [dbo].[user_badge] CHECK CONSTRAINT [FK_user_badge_Badges]
GO
ALTER TABLE [dbo].[user_badge]  WITH CHECK ADD  CONSTRAINT [FK_user_badge_Users] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[user_badge] CHECK CONSTRAINT [FK_user_badge_Users]
GO
ALTER TABLE [dbo].[User_info]  WITH CHECK ADD  CONSTRAINT [FK_User_info_Users] FOREIGN KEY([userid])
REFERENCES [dbo].[Users] ([id])
GO
ALTER TABLE [dbo].[User_info] CHECK CONSTRAINT [FK_User_info_Users]
GO
USE [master]
GO
ALTER DATABASE [hackathonDB] SET  READ_WRITE 
GO
