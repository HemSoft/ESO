-- Get Last CharacterActivity per Character:
SELECT
    c.Id AS CharacterId
  , c.Name AS CharacterName
  , ca.Id AS ActivityId
  , ca.AlliancePoints
  , ca.BankedCash
  , ca.BankedTelvarStones
  , ca.Cash
  , ca.ChampionPointsEarned
  , ca.GuildCount
  , ca.LastLogin
  , ca.MailCount
  , ca.MailMax
  , ca.MaxBagSize
  , ca.MaxBankSize
  , ca.NumberOfFriends
  , ca.SecondsPlayed
  , ca.UsedBagSlots
  , ca.UsedBankSlots
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
