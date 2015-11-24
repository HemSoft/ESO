--==============================================================================================================--
--==============================================================================================================--
--==============================================================================================================--

DROP TABLE CharacterActivity
DROP TABLE [Character]
DROP TABLE ClassLookup
DROP TABLE RaceLookup
DROP TABLE AllianceLookup
DROP TABLE Account

--==============================================================================================================--
--==============================================================================================================--
--==============================================================================================================--

/****** Object:  Table [dbo].[Account]    Script Date: 11/24/2015 3:19:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Password] [varchar](50) NULL,
	[LastLogin] [datetime] NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[AllianceLookup]    Script Date: 11/24/2015 3:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllianceLookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EsoFaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[Character]    Script Date: 11/24/2015 3:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Character](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
	[LastLogin] [datetime] NULL,
	[AccountId] [int] NOT NULL,
	[ClassId] [int] NOT NULL,
	[RaceId] [int] NOT NULL,
	[AllianceId] [int] NOT NULL,
 CONSTRAINT [PK_Character] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[CharacterActivity]    Script Date: 11/24/2015 3:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CharacterActivity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CharacterId] [int] NOT NULL,
	[AlliancePoints] [int] NULL,
	[BankedCash] [int] NULL,
	[BankedTelvarStones] [int] NULL,
	[Cash] [int] NULL,
	[ChampionPointsEarned] [int] NULL,
	[GuildCount] [int] NULL,
	[LastLogin] [datetime] NULL,
	[MailCount] [int] NULL,
	[MailMax] [int] NULL,
	[MaxBagSize] [int] NULL,
	[MaxBankSize] [int] NULL,
	[NumberOfFriends] [int] NULL,
	[SecondsPlayed] [bigint] NULL,
	[UsedBagSlots] [int] NULL,
	[UsedBankSlots] [int] NULL,
 CONSTRAINT [PK_CharacterActivity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[ClassLookup]    Script Date: 11/24/2015 3:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClassLookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_EsoClass] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[RaceLookup]    Script Date: 11/24/2015 3:19:05 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RaceLookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_EsoRace] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
ALTER TABLE [dbo].[Character]  WITH CHECK ADD  CONSTRAINT [FK_Character_Account] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([Id])
GO
ALTER TABLE [dbo].[Character] CHECK CONSTRAINT [FK_Character_Account]
GO
ALTER TABLE [dbo].[Character]  WITH CHECK ADD  CONSTRAINT [FK_Character_Account1] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([Id])
GO
ALTER TABLE [dbo].[Character] CHECK CONSTRAINT [FK_Character_Account1]
GO
ALTER TABLE [dbo].[Character]  WITH CHECK ADD  CONSTRAINT [FK_Character_AllianceLookup] FOREIGN KEY([AllianceId])
REFERENCES [dbo].[AllianceLookup] ([Id])
GO
ALTER TABLE [dbo].[Character] CHECK CONSTRAINT [FK_Character_AllianceLookup]
GO
ALTER TABLE [dbo].[Character]  WITH CHECK ADD  CONSTRAINT [FK_Character_Class] FOREIGN KEY([ClassId])
REFERENCES [dbo].[ClassLookup] ([Id])
GO
ALTER TABLE [dbo].[Character] CHECK CONSTRAINT [FK_Character_Class]
GO
ALTER TABLE [dbo].[Character]  WITH CHECK ADD  CONSTRAINT [FK_Character_Race] FOREIGN KEY([RaceId])
REFERENCES [dbo].[RaceLookup] ([Id])
GO
ALTER TABLE [dbo].[Character] CHECK CONSTRAINT [FK_Character_Race]
GO
ALTER TABLE [dbo].[CharacterActivity]  WITH CHECK ADD  CONSTRAINT [FK_CharacterActivity_Character] FOREIGN KEY([CharacterId])
REFERENCES [dbo].[Character] ([Id])
GO
ALTER TABLE [dbo].[CharacterActivity] CHECK CONSTRAINT [FK_CharacterActivity_Character]
GO

--==============================================================================================================--
--==============================================================================================================--
--==============================================================================================================--

-- AllianceLookup
INSERT INTO AllianceLookup (Name, Description) VALUES ('Daggerfall Covenant', 'Breton, Redguard and Orc.');
INSERT INTO AllianceLookup (Name, Description) VALUES ('Aldmeri Dominion', 'High Elf, Wood Elf and Khajiit.');
INSERT INTO AllianceLookup (Name, Description) VALUES ('Ebonheart Pact', 'Nord, Dark Elves and Argonian.');

-- RaceLookup
INSERT INTO RaceLookup (Name, Description) VALUES ('Breton', 'Bretons magicka-themed skills make the race good for a Sorceror or Templar.');
INSERT INTO RaceLookup (Name, Description) VALUES ('Redguard', 'Redguards increased stamina helps with blocking and the shield passive gives a boost to any Templars who want to be tanks.');
INSERT INTO RaceLookup (Name, Description) VALUES ('Orc', '(Orsimer). All of the Orc abilities increase survivability, making the race well-suited for Templar or Dragon Knight tanks.');

INSERT INTO RaceLookup (Name, Description) VALUES ('High Elf', '(Altmer). A High Elfs skills lend themselves to damage-dealing magic, meaning the Sorcerer or Dragon Knight are your best class choices.');
INSERT INTO RaceLookup (Name, Description) VALUES ('Wood Elf', '(Bosmer). The bow skill, that stealth bonus, and the stamina increases point to Nightblade as the best Wood Elf class.');
INSERT INTO RaceLookup (Name, Description) VALUES ('Khajiit  ', '(Altmer). Like the Wood Elf, the Khajiits abilities make the race well-suited for the Nightblade. ');

INSERT INTO RaceLookup (Name, Description) VALUES ('Nord', 'Rugged - Increases Armor by 2/4/6.');
INSERT INTO RaceLookup (Name, Description) VALUES ('Dark Elves', '(Dunmer). Dark Elves have Flame Talent and dual-wielding passives, which benefit the melee/magicka combo found in the Dragon Knight.');
INSERT INTO RaceLookup (Name, Description) VALUES ('Argonian', 'The Argonian boost to healing helps the heal-focused Templar, but the rest of their abilities would benefit any soloing.');

INSERT INTO RaceLookup (Name, Description) VALUES ('Imperial', 'The Imperial race can pick any Alliance and is only available to buyers of the Imperial Edition. Their skills lend themselves towards tanking, meaning the Templar is one of the best choices.');

-- ClassLookup
INSERT INTO ClassLookup (Name, Description) VALUES ('Dragon Knight', 'These are your basic fighters, with the added bonus of using fire magic. If you have messed with Death Knights in world of Warcraft, you have an idea of what to expect here.');
INSERT INTO ClassLookup (Name, Description) VALUES ('Nightblade', 'This is your stealthy assassin class, mostly equivalent to Rogues or Rangers in other MMOs.');
INSERT INTO ClassLookup (Name, Description) VALUES ('Sorcerer', ' This class is ESOs primary magic-using class. In other titles, the Sorcerer is called the Mage, Wizard, Warlock, or Necromancer.');
INSERT INTO ClassLookup (Name, Description) VALUES ('Templar', 'The Templar is a warrior wielding Holy magic to smite enemies or heal allies. It is equivalent to the Paladin class in most other games.');

SELECT * FROM CharacterActivity ca