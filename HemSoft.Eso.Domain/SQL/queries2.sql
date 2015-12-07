EXEC CharactersNeedingAttention
--EXEC CharactersNeedingAttentionWithinHours 2
--EXEC GetLastCharacterActivity

--SELECT COUNT(*) FROM CharacterActivity ca


SELECT * FROM CharacterActivity ca

SELECT * FROM SkillLookup ORDER BY Name

SELECT
    c.Id AS CharacterId
  , c.Name AS CharacterName
  , sl.Id AS SKillId
  , sl.Name AS SkillName
  , cs.Rank
  , cs.LastRankXP
  , cs.NextRankXP
  , cs.XP
FROM
    [Character] c
    INNER JOIN CharacterSkill cs ON c.Id = cs.CharacterId
    INNER JOIN SkillLookup    sl ON cs.SkillId = sl.Id
ORDER BY
    c.Name, sl.Name
