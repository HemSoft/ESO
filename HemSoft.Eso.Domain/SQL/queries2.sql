--EXEC CharactersNeedingAttention
--EXEC CharactersNeedingAttentionWithinHours 2
--EXEC GetLastCharacterActivity

--SELECT COUNT(*) FROM CharacterActivity ca

--SELECT * FROM CharacterActivity ca

--SELECT * FROM SkillLookup ORDER BY Name

--SELECT
--    c.Id AS CharacterId
--  , c.Name AS CharacterName
--  , sl.Id AS SKillId
--  , sl.Name AS SkillName
--  , cs.Rank
--  , cs.LastRankXP
--  , cs.NextRankXP
--  , cs.XP
--FROM
--    [Character] c
--    INNER JOIN CharacterSkill cs ON c.Id = cs.CharacterId
--    INNER JOIN SkillLookup    sl ON cs.SkillId = sl.Id
--ORDER BY
--    c.Name, sl.Name


--GetCharacterSkills

--SELECT
--    c.Name AS CharacterName
--  , sl.Name AS SkillName
--  , cs.Rank
--  , cs.XP
--  , cs.LastRankXP
--  , cs.NextRankXP
--  , CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT)
--FROM
--    CharacterSkill cs
--    INNER JOIN Character c ON cs.CharacterId = c.Id
--    INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id

SELECT
    c.Id
    , c.Name
    , c.EnlightenedPool
    , c.EffectiveLevel

    -- Crafting
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Blacksmithing') AS Blacksmithing
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Blacksmithing') AS BlacksmithingPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Clothing') AS Clothing
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Clothing') AS ClothingPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Woodworking') AS Woodworking
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Woodworking') AS WoodworkingPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Alchemy') AS Alchemy
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Alchemy') AS AlchemyPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Enchanting') AS Enchanting
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Enchanting') AS EnchantingPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Provisioning') AS Provisioning
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Provisioning') AS ProvisioningPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Light Armor') AS LightArmor
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Light Armor') AS LightArmorPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Medium Armor') AS MediumArmor
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Medium Armor') AS MediumArmorPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Heavy Armor') AS HeavyArmor
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Heavy Armor') AS HeavyArmorPercent

    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Soul Magic') AS SoulMagic
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Soul Magic') AS SoulMagicPercent

    -- Guilds
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Fighters Guild') AS FightersGuild
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Fighters Guild') AS FightersGuildPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Mages Guild') AS MagesGuild
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Mages Guild') AS MagesGuildPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Undaunted') AS Undaunted
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Undaunted') AS UndauntedPercent

    -- PVP: Assault/Support
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Assault') AS Assault
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Assault') AS AssaultPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Support') AS Support
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Support') AS SupportPercent

    -- Race Skills, Templar
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Aedric Spear') AS AedricSpear
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Aedric Spear') AS AedricSpearPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Dawn''s Wrath') AS DawnsWrath
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Dawn''s Wrath') AS DawnsWrathPercent
    , (SELECT cs.Rank FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Restoring Light') AS RestoringLight
    , (SELECT CAST(CAST(cs.XP - cs.LastRankXP AS DECIMAL) / CAST(cs.NextRankXP - cs.LastRankXP as DECIMAL) * 100 as INT) FROM CharacterSkill cs INNER JOIN SkillLookup sl ON cs.SkillId = sl.Id WHERE cs.CharacterId = c.Id AND sl.Name = 'Restoring Light') AS RestoringLightPercent

FROM
    [Character] c

--SELECT * FROM CharacterSkill cs
--SELECT * FROM SkillLookup