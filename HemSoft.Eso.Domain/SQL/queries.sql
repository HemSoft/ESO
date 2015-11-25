SELECT
    a.Id AS AccountId
  , a.Name AS AccountName
  , c.Name AS CharacterName
  , c.LastLogin AS CharacterLastLogin
  , ca.Cash
  , ca.BankedCash
  , ca.ChampionPointsEarned
  , CONVERT(VARCHAR, ca.UsedBagSlots) + '/' + CONVERT(VARCHAR, ca.MaxBagSize) AS Bag
  , CONVERT(VARCHAR, ca.UsedBankSlots) + '/' + CONVERT(VARCHAR, ca.MaxBankSize) AS Bank
  , ca.AlliancePoints
  , CONVERT(VARCHAR, ca.MailCount) + '/' + CONVERT(VARCHAR, ca.MailMax) AS Mail
  , ca.SecondsPlayed
FROM
    Account a
    INNER JOIN Character c ON a.Id = c.AccountId
    INNER JOIN CharacterActivity ca ON c.Id = ca.CharacterId

SELECT
    SUM(Cash) AS TotalCash
FROM
    CharacterActivity ca
    INNER JOIN Character c ON ca.CharacterId = c.Id
    INNER JOIN Account a ON c.AccountId = a.Id
WHERE
    a.Name = 'franzhemmer'
