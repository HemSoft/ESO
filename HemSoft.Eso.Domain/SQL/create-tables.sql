/****** Object:  Table [dbo].[EsoAccount]    Script Date: 11/18/2015 4:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoAccount](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[LastLogin] [datetime] NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_EsoAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoCharacter]    Script Date: 11/18/2015 4:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoCharacter](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
	[RaceId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[LastLogin] [datetime] NULL,
	[TotalTimeMs] [bigint] NULL,
	[AccountId] [int] NOT NULL,
 CONSTRAINT [PK_EsoCharacter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoClass]    Script Date: 11/18/2015 4:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoClass](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_EsoClass] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoEvent]    Script Date: 11/18/2015 4:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoEvent](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[EventTime] [datetime] NOT NULL,
	[EventTypeId] [int] NOT NULL,
	[Event] [varchar](max) NOT NULL,
	[CharacterId] [int] NOT NULL,
 CONSTRAINT [PK_EsoEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoEventType]    Script Date: 11/18/2015 4:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoEventType](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EsoEventType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoRace]    Script Date: 11/18/2015 4:33:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoRace](
	[Id] [int] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EsoRace] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER TABLE [dbo].[EsoCharacter]  WITH CHECK ADD  CONSTRAINT [FK_EsoCharacter_EsoAccount] FOREIGN KEY([AccountId])
REFERENCES [dbo].[EsoAccount] ([Id])
GO
ALTER TABLE [dbo].[EsoCharacter] CHECK CONSTRAINT [FK_EsoCharacter_EsoAccount]
GO
ALTER TABLE [dbo].[EsoCharacter]  WITH CHECK ADD  CONSTRAINT [FK_EsoCharacter_EsoClass] FOREIGN KEY([ClassId])
REFERENCES [dbo].[EsoClass] ([Id])
GO
ALTER TABLE [dbo].[EsoCharacter] CHECK CONSTRAINT [FK_EsoCharacter_EsoClass]
GO
ALTER TABLE [dbo].[EsoCharacter]  WITH CHECK ADD  CONSTRAINT [FK_EsoCharacter_EsoRace] FOREIGN KEY([RaceId])
REFERENCES [dbo].[EsoRace] ([Id])
GO
ALTER TABLE [dbo].[EsoCharacter] CHECK CONSTRAINT [FK_EsoCharacter_EsoRace]
GO
ALTER TABLE [dbo].[EsoEvent]  WITH CHECK ADD  CONSTRAINT [FK_EsoEvent_EsoCharacter] FOREIGN KEY([CharacterId])
REFERENCES [dbo].[EsoCharacter] ([Id])
GO
ALTER TABLE [dbo].[EsoEvent] CHECK CONSTRAINT [FK_EsoEvent_EsoCharacter]
GO
ALTER TABLE [dbo].[EsoEvent]  WITH CHECK ADD  CONSTRAINT [FK_EsoEvent_EsoEventType] FOREIGN KEY([EventTypeId])
REFERENCES [dbo].[EsoEventType] ([Id])
GO
ALTER TABLE [dbo].[EsoEvent] CHECK CONSTRAINT [FK_EsoEvent_EsoEventType]
GO
