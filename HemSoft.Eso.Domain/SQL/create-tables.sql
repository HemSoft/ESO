/****** Object:  StoredProcedure [dbo].[NextUpInResearch]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP PROCEDURE [dbo].[NextUpInResearch]
GO
/****** Object:  StoredProcedure [dbo].[GetLastCharacterActivity]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP PROCEDURE [dbo].[GetLastCharacterActivity]
GO
/****** Object:  StoredProcedure [dbo].[GetCharacterSkills]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP PROCEDURE [dbo].[GetCharacterSkills]
GO
/****** Object:  StoredProcedure [dbo].[GetAccounts]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP PROCEDURE [dbo].[GetAccounts]
GO
/****** Object:  StoredProcedure [dbo].[CharactersNeedingAttention]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP PROCEDURE [dbo].[CharactersNeedingAttention]
GO
/****** Object:  StoredProcedure [dbo].[CharacterResearch]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP PROCEDURE [dbo].[CharacterResearch]
GO
ALTER TABLE [dbo].[CharacterSkill] DROP CONSTRAINT [FK_CharacterSkill_SkillLookup]
GO
ALTER TABLE [dbo].[CharacterSkill] DROP CONSTRAINT [FK_CharacterSkill_Character]
GO
ALTER TABLE [dbo].[CharacterDailyQuest] DROP CONSTRAINT [FK_CharacterDailyQuest_Character]
GO
ALTER TABLE [dbo].[CharacterActivity] DROP CONSTRAINT [FK_CharacterActivity_Character]
GO
ALTER TABLE [dbo].[Character] DROP CONSTRAINT [FK_Character_Race]
GO
ALTER TABLE [dbo].[Character] DROP CONSTRAINT [FK_Character_Class]
GO
ALTER TABLE [dbo].[Character] DROP CONSTRAINT [FK_Character_AllianceLookup]
GO
ALTER TABLE [dbo].[Character] DROP CONSTRAINT [FK_Character_Account]
GO
/****** Object:  Table [dbo].[SkillLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[SkillLookup]
GO
/****** Object:  Table [dbo].[RaceLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[RaceLookup]
GO
/****** Object:  Table [dbo].[ClassLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[ClassLookup]
GO
/****** Object:  Table [dbo].[CharacterSkill]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[CharacterSkill]
GO
/****** Object:  Table [dbo].[CharacterDailyQuest]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[CharacterDailyQuest]
GO
/****** Object:  Table [dbo].[CharacterActivity]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[CharacterActivity]
GO
/****** Object:  Table [dbo].[Character]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[Character]
GO
/****** Object:  Table [dbo].[AllianceLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[AllianceLookup]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 12/9/2015 9:49:35 AM ******/
DROP TABLE [dbo].[Account]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Password] [varchar](50) NULL,
	[ChampionPointsEarned] [int] NULL,
	[EnlightenedPool] [int] NULL,
	[LastLogin] [datetime] NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_Account] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[AllianceLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AllianceLookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_EsoFaction] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[Character]    Script Date: 12/9/2015 9:49:35 AM ******/
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
	[ClassId] [int] NULL,
	[RaceId] [int] NULL,
	[AllianceId] [int] NULL,
	[ChampionPointsEarned] [int] NULL,
	[EffectiveLevel] [int] NULL,
	[EnlightenedPool] [int] NULL,
 CONSTRAINT [PK_Character] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[CharacterActivity]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CharacterActivity](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CharacterId] [int] NOT NULL,
	[AlliancePoints] [int] NULL,
	[AvailableSkillPoints] [int] NULL,
	[BankedCash] [int] NULL,
	[BankedTelvarStones] [int] NULL,
	[BlacksmithingSecondsMaximumLeft] [int] NULL,
	[BlacksmithingSecondsMaximumTotal] [int] NULL,
	[BlacksmithingSecondsMinimumLeft] [int] NULL,
	[BlacksmithingSecondsMinimumTotal] [int] NULL,
	[BlacksmithingSlotsFree] [int] NULL,
	[BlacksmithingSlotsMax] [int] NULL,
	[Cash] [int] NULL,
	[ChampionPointsEarned] [int] NULL,
	[ClothingSecondsMaximumLeft] [int] NULL,
	[ClothingSecondsMaximumTotal] [int] NULL,
	[ClothingSecondsMinimumLeft] [int] NULL,
	[ClothingSecondsMinimumTotal] [int] NULL,
	[ClothingSlotsFree] [int] NULL,
	[ClothingSlotsMax] [int] NULL,
	[EffectiveLevel] [int] NULL,
	[EnlightenedPool] [int] NULL,
	[GuildCount] [int] NULL,
	[IsVeteran] [bit] NULL,
	[LastLogin] [datetime] NULL,
	[Level] [int] NULL,
	[MailCount] [int] NULL,
	[MailMax] [int] NULL,
	[MaxBagSize] [int] NULL,
	[MaxBankSize] [int] NULL,
	[MountCapacity] [int] NULL,
	[MountStamina] [int] NULL,
	[MountSpeed] [int] NULL,
	[NumberOfFriends] [int] NULL,
	[SecondsPlayed] [bigint] NULL,
	[SecondsUntilMountTraining] [bigint] NULL,
	[Skyshards] [int] NULL,
	[UsedBagSlots] [int] NULL,
	[UsedBankSlots] [int] NULL,
	[VeteranRank] [int] NULL,
	[VP] [int] NULL,
	[VPMax] [int] NULL,
	[WoodworkingSecondsMaximumLeft] [int] NULL,
	[WoodworkingSecondsMaximumTotal] [int] NULL,
	[WoodworkingSecondsMinimumLeft] [int] NULL,
	[WoodworkingSecondsMinimumTotal] [int] NULL,
	[WoodworkingSlotsFree] [int] NULL,
	[WoodworkingSlotsMax] [int] NULL,
	[XP] [int] NULL,
	[XPMax] [int] NULL,
	[Zone] [varchar](100) NULL,
 CONSTRAINT [PK_CharacterActivity] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[CharacterDailyQuest]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CharacterDailyQuest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CharacterId] [int] NOT NULL,
	[AlchemistCompleted] [datetime] NULL,
	[AlchemistLevel] [int] NULL,
	[BlacksmithCompleted] [datetime] NULL,
	[BlacksmithLevel] [int] NULL,
	[ClothierCompleted] [datetime] NULL,
	[ClothierLevel] [int] NULL,
	[EnchanterCompleted] [datetime] NULL,
	[EnchanterLevel] [int] NULL,
	[ProvisionerCompleted] [datetime] NULL,
	[ProvisionerLevel] [int] NULL,
	[OrsiniumHeresyOfIgnoranceCompleted] [datetime] NULL,
	[OrsiniumHeresyOfIgnoranceLevel] [int] NULL,
	[OrsiniumMadUrkazburCompleted] [datetime] NULL,
	[OrsiniumMadUrkazburLevel] [int] NULL,
	[OrsiniumMeatForTheMassesCompleted] [datetime] NULL,
	[OrsiniumMeatForTheMassesLevel] [int] NULL,
	[OrsiniumNaturesBountyCompleted] [datetime] NULL,
	[OrsiniumNaturesBountyLevel] [int] NULL,
	[OrsiniumReekingOfFoulPlayCompleted] [datetime] NULL,
	[OrsiniumReekingOfFoulPlayLevel] [int] NULL,
	[OrsiniumSnowAndSteamCompleted] [datetime] NULL,
	[OrsiniumSnowAndSteamLevel] [int] NULL,
 CONSTRAINT [PK_CharacterDailyQuest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[CharacterSkill]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CharacterSkill](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CharacterId] [int] NOT NULL,
	[SkillId] [int] NOT NULL,
	[Rank] [int] NOT NULL,
	[XP] [int] NOT NULL,
	[LastRankXP] [int] NOT NULL,
	[NextRankXP] [int] NOT NULL,
 CONSTRAINT [PK_CharacterSkill] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[ClassLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
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
/****** Object:  Table [dbo].[RaceLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RaceLookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_EsoRace] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
/****** Object:  Table [dbo].[SkillLookup]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SkillLookup](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Description] [varchar](max) NULL,
 CONSTRAINT [PK_SkillLookup] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF)
)

GO
SET IDENTITY_INSERT [dbo].[AllianceLookup] ON 

GO
INSERT [dbo].[AllianceLookup] ([Id], [Name], [Description]) VALUES (1, N'Daggerfall Covenant', N'Breton, Redguard and Orc.')
GO
INSERT [dbo].[AllianceLookup] ([Id], [Name], [Description]) VALUES (2, N'Aldmeri Dominion', N'High Elf, Wood Elf and Khajiit.')
GO
INSERT [dbo].[AllianceLookup] ([Id], [Name], [Description]) VALUES (3, N'Ebonheart Pact', N'Nord, Dark Elves and Argonian.')
GO
SET IDENTITY_INSERT [dbo].[AllianceLookup] OFF
GO
SET IDENTITY_INSERT [dbo].[ClassLookup] ON 

GO
INSERT [dbo].[ClassLookup] ([Id], [Name], [Description]) VALUES (1, N'Dragon Knight', N'These are your basic fighters, with the added bonus of using fire magic. If you have messed with Death Knights in world of Warcraft, you have an idea of what to expect here.')
GO
INSERT [dbo].[ClassLookup] ([Id], [Name], [Description]) VALUES (2, N'Nightblade', N'This is your stealthy assassin class, mostly equivalent to Rogues or Rangers in other MMOs.')
GO
INSERT [dbo].[ClassLookup] ([Id], [Name], [Description]) VALUES (3, N'Sorcerer', N' This class is ESOs primary magic-using class. In other titles, the Sorcerer is called the Mage, Wizard, Warlock, or Necromancer.')
GO
INSERT [dbo].[ClassLookup] ([Id], [Name], [Description]) VALUES (4, N'Templar', N'The Templar is a warrior wielding Holy magic to smite enemies or heal allies. It is equivalent to the Paladin class in most other games.')
GO
SET IDENTITY_INSERT [dbo].[ClassLookup] OFF
GO
SET IDENTITY_INSERT [dbo].[RaceLookup] ON 

GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (1, N'Breton', N'Bretons magicka-themed skills make the race good for a Sorceror or Templar.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (2, N'Redguard', N'Redguards increased stamina helps with blocking and the shield passive gives a boost to any Templars who want to be tanks.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (3, N'Orc', N'(Orsimer). All of the Orc abilities increase survivability, making the race well-suited for Templar or Dragon Knight tanks.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (4, N'High Elf', N'(Altmer). A High Elfs skills lend themselves to damage-dealing magic, meaning the Sorcerer or Dragon Knight are your best class choices.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (5, N'Wood Elf', N'(Bosmer). The bow skill, that stealth bonus, and the stamina increases point to Nightblade as the best Wood Elf class.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (6, N'Khajiit  ', N'(Altmer). Like the Wood Elf, the Khajiits abilities make the race well-suited for the Nightblade. ')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (7, N'Nord', N'Rugged - Increases Armor by 2/4/6.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (8, N'Dark Elves', N'(Dunmer). Dark Elves have Flame Talent and dual-wielding passives, which benefit the melee/magicka combo found in the Dragon Knight.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (9, N'Argonian', N'The Argonian boost to healing helps the heal-focused Templar, but the rest of their abilities would benefit any soloing.')
GO
INSERT [dbo].[RaceLookup] ([Id], [Name], [Description]) VALUES (10, N'Imperial', N'The Imperial race can pick any Alliance and is only available to buyers of the Imperial Edition. Their skills lend themselves towards tanking, meaning the Templar is one of the best choices.')
GO
SET IDENTITY_INSERT [dbo].[RaceLookup] OFF
GO
ALTER TABLE [dbo].[Character]  WITH CHECK ADD  CONSTRAINT [FK_Character_Account] FOREIGN KEY([AccountId])
REFERENCES [dbo].[Account] ([Id])
GO
ALTER TABLE [dbo].[Character] CHECK CONSTRAINT [FK_Character_Account]
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
ALTER TABLE [dbo].[CharacterDailyQuest]  WITH CHECK ADD  CONSTRAINT [FK_CharacterDailyQuest_Character] FOREIGN KEY([CharacterId])
REFERENCES [dbo].[Character] ([Id])
GO
ALTER TABLE [dbo].[CharacterDailyQuest] CHECK CONSTRAINT [FK_CharacterDailyQuest_Character]
GO
ALTER TABLE [dbo].[CharacterSkill]  WITH CHECK ADD  CONSTRAINT [FK_CharacterSkill_Character] FOREIGN KEY([CharacterId])
REFERENCES [dbo].[Character] ([Id])
GO
ALTER TABLE [dbo].[CharacterSkill] CHECK CONSTRAINT [FK_CharacterSkill_Character]
GO
ALTER TABLE [dbo].[CharacterSkill]  WITH CHECK ADD  CONSTRAINT [FK_CharacterSkill_SkillLookup] FOREIGN KEY([SkillId])
REFERENCES [dbo].[SkillLookup] ([Id])
GO
ALTER TABLE [dbo].[CharacterSkill] CHECK CONSTRAINT [FK_CharacterSkill_SkillLookup]
GO
/****** Object:  StoredProcedure [dbo].[CharacterResearch]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CharacterResearch]
AS
BEGIN

    SELECT
        c.Id AS CharacterId
      , c.Name AS CharacterName
      , ca.LastLogin
      , DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin) AS HorseDue
      , DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin) AS BlacksmithingDue
      , DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin) AS ClothingDue
      , DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin) AS WoodworkingDue
      , CASE
            WHEN COALESCE(ca.SecondsUntilMountTraining, 9999999999) < COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.SecondsUntilMountTraining, 9999999999) < COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.SecondsUntilMountTraining, 9999999999) < COALESCE(ca.WoodworkingSecondsMinimumLeft, 9999999999) THEN
               DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin)
            WHEN COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) < COALESCE(ca.SecondsUntilMountTraining, 9999999999) AND
                 COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) < COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) < COALESCE(ca.WoodworkingSecondsMinimumLeft, 9999999999) THEN
               DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)
            WHEN COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) < COALESCE(ca.SecondsUntilMountTraining, 9999999999) AND
                 COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) < COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) < COALESCE(ca.WoodworkingSecondsMinimumLeft, 9999999999) THEN
                DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)
            WHEN ca.WoodworkingSecondsMaximumLeft IS NOT NULL THEN
                DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin)
            ELSE
                NULL
        END AS NextDue
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin)) AS HorseInMinutes
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)) AS BlacksmithingInMinutes
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)) AS ClothingInMinutes
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin)) AS WoodworkingInMinutes
      , CASE
            WHEN COALESCE(ca.SecondsUntilMountTraining, 9999999999) < COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.SecondsUntilMountTraining, 9999999999) < COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.SecondsUntilMountTraining, 9999999999) < COALESCE(ca.WoodworkingSecondsMinimumLeft, 9999999999) THEN
                DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin))
            WHEN COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) < COALESCE(ca.SecondsUntilMountTraining, 9999999999) AND
                 COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) < COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) < COALESCE(ca.WoodworkingSecondsMinimumLeft, 9999999999) THEN
                DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)) 
            WHEN COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) < COALESCE(ca.SecondsUntilMountTraining, 9999999999) AND
                 COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) < COALESCE(ca.BlacksmithingSecondsMinimumLeft, 9999999999) AND
                 COALESCE(ca.ClothingSecondsMinimumLeft, 9999999999) < COALESCE(ca.WoodworkingSecondsMinimumLeft, 9999999999) THEN
                DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)) 
            WHEN ca.WoodworkingSecondsMaximumLeft IS NOT NULL THEN
                DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin))
            ELSE
                NULL
        END AS NextInMinutes
    FROM
        CharacterActivity ca
        INNER JOIN Character c ON ca.CharacterId = c.Id
    WHERE
        ca.Id IN 
        (
            SELECT
                (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id) AS ActivityId
            FROM
                Character c
                INNER JOIN CharacterActivity ca ON ca.CharacterId = c.Id AND ca.Id = (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id)
        )
    ORDER BY
        NextInMinutes
END


GO
/****** Object:  StoredProcedure [dbo].[CharactersNeedingAttention]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CharactersNeedingAttention]
AS
BEGIN
    -- Get Research Past Due:
    SELECT
        c.Id AS CharacterId
      , c.Name AS CharacterName
      , ca.LastLogin

      , CASE
            WHEN DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin) < GETDATE() THEN
                DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin)
            ELSE
                NULL
        END HorseFeedingStatus
      , CASE
            WHEN DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin) < GETDATE() THEN
                DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)
            ELSE
                NULL
        END BlacksmithingStatus
      , CASE
            WHEN DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin) < GETDATE() THEN
                DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)
            ELSE
                NULL
        END ClothingStatus
      , CASE
            WHEN DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin) < GETDATE() THEN
                DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin)
            ELSE
                NULL
        END WoodworkingStatus
    FROM
        CharacterActivity ca
        INNER JOIN Character c ON ca.CharacterId = c.Id
    WHERE
        ca.Id IN 
        (
            SELECT
              (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id) AS ActivityId
            FROM
                Character c
                INNER JOIN CharacterActivity ca ON ca.CharacterId = c.Id AND ca.Id = (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id)
        )
        AND
        (
            DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin) < GETDATE()
            OR
            DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin) < GETDATE()
            OR
            DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin) < GETDATE()
            OR
            DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin) < GETDATE()
        )
    ORDER BY
        c.Name
END


GO
/****** Object:  StoredProcedure [dbo].[GetAccounts]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetAccounts]
AS
BEGIN
    SELECT
        a.Id AS AccountId
      , a.Name AS AccountName
      , a.Password AS AccountPassword
      , a.LastLogin
      , a.Description
      , c.Name AS CharacterName
      , ca.EnlightenedPool
    FROM
        Account a
        INNER JOIN Character c ON a.Id = c.Id
        LEFT OUTER JOIN CharacterActivity ca ON c.Id = ca.CharacterId
    WHERE
        ca.Id IN 
        (
            SELECT
              (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id) AS ActivityId
            FROM
                Character c
                INNER JOIN CharacterActivity ca ON ca.CharacterId = c.Id AND ca.Id = (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id)
        )
END


GO
/****** Object:  StoredProcedure [dbo].[GetCharacterSkills]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetCharacterSkills]
AS
BEGIN
    SELECT
        c.Id
      , c.Name
      , c.ChampionPointsEarned
      , c.EnlightenedPool
      , c.EffectiveLevel
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Blacksmithing') AS Blacksmithing
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Clothing') AS Clothing
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Woodworking') AS Woodworking
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Alchemy') AS Alchemy
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Enchanting') AS Enchanting
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Provisioning') AS Provisioning
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Light Armor') AS LightArmor
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Medium Armor') AS MediumArmor
      , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Heavy Armor') AS HeavyArmor
    FROM
        [Character] c
END

GO
/****** Object:  StoredProcedure [dbo].[GetLastCharacterActivity]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[GetLastCharacterActivity]
AS
BEGIN

    SELECT
        c.Id AS CharacterId
      , c.Name AS CharacterName
      , ca.Id AS ActivityId
      , ca.AlliancePoints
      , ca.BankedCash
      , ca.BankedTelvarStones
      , ca.Cash
      , ca.ChampionPointsEarned
      , ca.EnlightenedPool
      , ca.GuildCount
      , ca.LastLogin
      , ca.MailCount
      , ca.MailMax
      , ca.MaxBagSize
      , ca.MaxBankSize
      , ca.NumberOfFriends
      , ca.SecondsPlayed
      , ca.SecondsPlayed / 60 / 60 AS HoursPlayed
      , ca.UsedBagSlots
      , ca.UsedBankSlots
      , DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin) AS BlackmithingAvailableAt
      , DATEDIFF(SECOND, GETDATE(), DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)) AS BlacksmithingSecondsLeft
      , ca.BlacksmithingSecondsMinimumLeft / 60 AS BlacksmithingMinutesLeft
      , ca.BlacksmithingSlotsFree
      , ca.BlacksmithingSlotsMax
      , ca.ClothingSecondsMinimumLeft / 60 AS ClothingMinutesLeft
      , (ca.ClothingSecondsMinimumLeft / ca.ClothingSecondsMinimumTotal) * 100 AS ClothingPercentDone
      , ca.ClothingSlotsFree
      , ca.ClothingSlotsMax
      , ca.WoodworkingSecondsMaximumLeft / 60 AS WoodworkingMinutesLeft
      , (ca.WoodworkingSecondsMaximumLeft / ca.WoodworkingSecondsMaximumTotal) * 100 AS WoodworkingPercentDone
      , ca.WoodworkingSlotsFree
      , ca.WoodworkingSlotsMax
      , ca.MountCapacity
      , ca.MountStamina
      , ca.MountSpeed
      , ca.SecondsUntilMountTraining
    FROM
        CharacterActivity ca
        INNER JOIN Character c ON ca.CharacterId = c.Id
    WHERE
        ca.Id IN 
        (
            SELECT
              (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id) AS ActivityId
            FROM
                Character c
                INNER JOIN CharacterActivity ca ON ca.CharacterId = c.Id AND ca.Id = (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id)
        )
END


GO
/****** Object:  StoredProcedure [dbo].[NextUpInResearch]    Script Date: 12/9/2015 9:49:35 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[NextUpInResearch]
AS
BEGIN

    SELECT
        TOP 1
        c.Id AS CharacterId
      , c.Name AS CharacterName
      , ca.LastLogin
      , DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin) AS HorseDue
      , DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin) AS BlacksmithingDue
      , DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin) AS ClothingDue
      , DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin) AS WoodworkingDue
      , CASE
            WHEN ca.SecondsUntilMountTraining < ca.BlacksmithingSecondsMinimumLeft AND
                 ca.SecondsUntilMountTraining < ca.ClothingSecondsMinimumLeft AND
                 ca.SecondsUntilMountTraining < ca.WoodworkingSecondsMinimumLeft THEN
                DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin)
            WHEN ca.BlacksmithingSecondsMinimumLeft < ca.SecondsUntilMountTraining AND
                 ca.BlacksmithingSecondsMinimumLeft < ca.ClothingSecondsMinimumLeft AND
                 ca.BlacksmithingSecondsMinimumLeft < ca.WoodworkingSecondsMinimumLeft THEN
                DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)
            WHEN ca.ClothingSecondsMinimumLeft < ca.SecondsUntilMountTraining AND
                 ca.ClothingSecondsMinimumLeft < ca.BlacksmithingSecondsMinimumLeft AND
                 ca.ClothingSecondsMinimumLeft < ca.WoodworkingSecondsMinimumLeft THEN
                DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)
            ELSE
                DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin)
        END AS NextDue
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin)) AS HorseInMinutes
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)) AS BlacksmithingInMinutes
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)) AS ClothingInMinutes
      , DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin)) AS WoodworkingInMinutes
      , CASE
            WHEN ca.SecondsUntilMountTraining < ca.BlacksmithingSecondsMinimumLeft AND
                 ca.SecondsUntilMountTraining < ca.ClothingSecondsMinimumLeft AND
                 ca.SecondsUntilMountTraining < ca.WoodworkingSecondsMinimumLeft THEN
                 DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.SecondsUntilMountTraining, ca.LastLogin))
            WHEN ca.BlacksmithingSecondsMinimumLeft < ca.SecondsUntilMountTraining AND
                 ca.BlacksmithingSecondsMinimumLeft < ca.ClothingSecondsMinimumLeft AND
                 ca.BlacksmithingSecondsMinimumLeft < ca.WoodworkingSecondsMinimumLeft THEN
                 DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.BlacksmithingSecondsMinimumLeft, ca.LastLogin)) 
            WHEN ca.ClothingSecondsMinimumLeft < ca.SecondsUntilMountTraining AND
                 ca.ClothingSecondsMinimumLeft < ca.BlacksmithingSecondsMinimumLeft AND
                 ca.ClothingSecondsMinimumLeft < ca.WoodworkingSecondsMinimumLeft THEN
                 DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.ClothingSecondsMinimumLeft, ca.LastLogin)) 
            ELSE
                DATEDIFF(MINUTE, GETDATE(), DATEADD(ss, ca.WoodworkingSecondsMinimumLeft, ca.LastLogin))
        END AS NextInMinutes
    FROM
        CharacterActivity ca
        INNER JOIN Character c ON ca.CharacterId = c.Id
    WHERE
        ca.Id IN 
        (
            SELECT
                (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id) AS ActivityId
            FROM
                Character c
                INNER JOIN CharacterActivity ca ON ca.CharacterId = c.Id AND ca.Id = (SELECT MAX(Id) FROM CharacterActivity ca WHERE ca.CharacterId = c.Id)
        )
    ORDER BY
        NextInMinutes
END

GO
