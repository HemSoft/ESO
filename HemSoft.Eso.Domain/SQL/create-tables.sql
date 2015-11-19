DROP TABLE EsoEvent
DROP TABLE EsoEventType
DROP TABLE EsoMount
DROP TABLE EsoCharacter
DROP TABLE EsoAccount
DROP TABLE EsoClass
DROP TABLE EsoRace
DROP TABLE EsoAlliance

/****** Object:  Table [dbo].[EsoAccount]    Script Date: 11/19/2015 3:04:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoAccount](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,
    [Password] [varchar](50) NOT NULL,
    [LastLogin] [datetime] NULL,
    [Description] [varchar](max) NULL,
 CONSTRAINT [PK_EsoAccount] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoAlliance]    Script Date: 11/19/2015 3:04:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoAlliance](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,
    [Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EsoFaction] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoCharacter]    Script Date: 11/19/2015 3:04:08 PM ******/
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
/****** Object:  Table [dbo].[EsoClass]    Script Date: 11/19/2015 3:04:08 PM ******/
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
/****** Object:  Table [dbo].[EsoEvent]    Script Date: 11/19/2015 3:04:08 PM ******/
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
/****** Object:  Table [dbo].[EsoEventType]    Script Date: 11/19/2015 3:04:08 PM ******/
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
/****** Object:  Table [dbo].[EsoMount]    Script Date: 11/19/2015 3:04:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoMount](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [CharacterId] [int] NOT NULL,
    [Speed] [int] NOT NULL,
    [Stamina] [int] NOT NULL,
    [Capacity] [int] NOT NULL,
    [LastUpdated] [datetime] NOT NULL,
    [TimeUntilTraining] [bigint] NULL,
 CONSTRAINT [PK_EsoMount] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[EsoRace]    Script Date: 11/19/2015 3:04:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EsoRace](
    [Id] [int] IDENTITY(1,1) NOT NULL,
    [Name] [varchar](50) NOT NULL,
    [Description] [varchar](max) NOT NULL,
    [AllianceId] [int] NULL,
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
ALTER TABLE [dbo].[EsoMount]  WITH CHECK ADD  CONSTRAINT [FK_EsoMount_EsoCharacter] FOREIGN KEY([CharacterId])
REFERENCES [dbo].[EsoCharacter] ([Id])
GO
ALTER TABLE [dbo].[EsoMount] CHECK CONSTRAINT [FK_EsoMount_EsoCharacter]
GO
ALTER TABLE [dbo].[EsoRace]  WITH CHECK ADD  CONSTRAINT [FK_EsoRace_EsoAlliance] FOREIGN KEY([AllianceId])
REFERENCES [dbo].[EsoAlliance] ([Id])
GO
ALTER TABLE [dbo].[EsoRace] CHECK CONSTRAINT [FK_EsoRace_EsoAlliance]
GO

-- EsoAlliance
INSERT INTO EsoAlliance (Name, Description) VALUES ('Daggerfall Covenant', 'Breton, Redguard and Orc.');
INSERT INTO EsoAlliance (Name, Description) VALUES ('Aldmeri Dominion', 'High Elf, Wood Elf and Khajiit.');
INSERT INTO EsoAlliance (Name, Description) VALUES ('Ebonheart Pact', 'Nord, Dark Elves and Argonian.');

-- EsoRace
DECLARE @Id INT
SELECT @Id = Id FROM EsoAlliance ea WHERE ea.Name = 'Daggerfall Covenant'
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Breton', 'Bretons magicka-themed skills make the race good for a Sorceror or Templar.', @Id);
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Redguard', 'Redguards increased stamina helps with blocking and the shield passive gives a boost to any Templars who want to be tanks.', @Id);
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Orc', '(Orsimer). All of the Orc abilities increase survivability, making the race well-suited for Templar or Dragon Knight tanks.', @Id);

SELECT @Id = Id FROM EsoAlliance ea WHERE ea.Name = 'Aldmeri Dominion'
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('High Elf', '(Altmer). A High Elfs skills lend themselves to damage-dealing magic, meaning the Sorcerer or Dragon Knight are your best class choices.', @Id);
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Wood Elf', '(Bosmer). The bow skill, that stealth bonus, and the stamina increases point to Nightblade as the best Wood Elf class.', @Id);
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Khajiit  ', '(Altmer). Like the Wood Elf, the Khajiits abilities make the race well-suited for the Nightblade. ', @Id);

SELECT @Id = Id FROM EsoAlliance ea WHERE ea.Name = 'Ebonheart Pact'
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Nord', 'Rugged - Increases Armor by 2/4/6.', @Id);
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Dark Elves', '(Dunmer). Dark Elves have Flame Talent and dual-wielding passives, which benefit the melee/magicka combo found in the Dragon Knight.', @Id);
INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Argonian', 'The Argonian boost to healing helps the heal-focused Templar, but the rest of their abilities would benefit any soloing.', @Id);

INSERT INTO EsoRace (Name, Description, AllianceId) VALUES ('Imperial', 'The Imperial race can pick any Alliance and is only available to buyers of the Imperial Edition. Their skills lend themselves towards tanking, meaning the Templar is one of the best choices.', NULL);
SELECT * FROM EsoRace er

-- EsoClass
INSERT INTO EsoClass (Name, Description) VALUES ('Dragon Knight', 'These are your basic fighters, with the added bonus of using fire magic. If you have messed with Death Knights in world of Warcraft, you have an idea of what to expect here.');
INSERT INTO EsoClass (Name, Description) VALUES ('Nightblade', 'This is your stealthy assassin class, mostly equivalent to Rogues or Rangers in other MMOs.');
INSERT INTO EsoClass (Name, Description) VALUES ('Sorcerer', ' This class is ESOs primary magic-using class. In other titles, the Sorcerer is called the Mage, Wizard, Warlock, or Necromancer.');
INSERT INTO EsoClass (Name, Description) VALUES ('Templar', 'The Templar is a warrior wielding Holy magic to smite enemies or heal allies. It is equivalent to the Paladin class in most other games.');
SELECT * FROM EsoClass ec

-- EsoAccount
INSERT INTO EsoAccount (Name, Password, LastLogin, Description) VALUES ('franzhemmer', 'Inxs1Inxs', NULL, 'franz_hemmer@hotmail.com');
INSERT INTO EsoAccount (Name, Password, LastLogin, Description) VALUES ('rhfactor', 'inxs14inxs', NULL, 'rhfactor / inxs14inxs');
INSERT INTO EsoAccount (Name, Password, LastLogin, Description) VALUES ('johnflannigan15', 'flanni2015', NULL, 'johnflannigan15 / johnflannigan15@gmail.com / flanni2015 / Birth: 03/08/1980 / Last name of favorite author = Tolstoy / HMAVPN: ');
SELECT * FROM EsoAccount ea

-- EsoCharacter
INSERT INTO EsoCharacter (Name, Description, RaceId, ClassId, LastLogin, TotalTimeMs, AccountId) VALUES ('Daedraulic', 'Templar/Magicka', 10, 4, NULL, NULL, 1);
SELECT
    ec.Id
  , ec.Name
  , ec.Description
  , er.Name AS Race
  , ec1.Name AS Class
  , ec.LastLogin
  , ec.TotalTimeMs
  , ea.Name AS Account
FROM
    EsoCharacter ec
    INNER JOIN EsoRace er ON ec.RaceId = er.Id
    INNER JOIN EsoClass ec1 ON ec.ClassId = ec1.Id
    INNER JOIN EsoAccount ea ON ec.AccountId = ea.Id

