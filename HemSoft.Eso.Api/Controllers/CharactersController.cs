﻿namespace HemSoft.Eso.Api.Controllers
{
    using System.Collections.Generic;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using System.Net;
    using System.Threading.Tasks;
    using System.Web.Http;
    using System.Web.Http.Cors;
    using System.Web.Http.Description;
    using Domain;
    using Domain.Managers;

    [EnableCors("*", "*", "*")]
    public class CharactersController : ApiController
    {
        private readonly EsoEntities db = new EsoEntities();

        private bool CharacterExists(int id)
        {
            return db.Characters.Count(e => e.Id == id) > 0;
        }

        // DELETE: api/Characters/5
        [ResponseType(typeof(Character))]
        public async Task<IHttpActionResult> DeleteCharacter(int id)
        {
            db.Configuration.ProxyCreationEnabled = false;
            Character character = await db.Characters.FindAsync(id);
            if (character == null)
            {
                return NotFound();
            }

            db.Characters.Remove(character);
            await db.SaveChangesAsync();

            return Ok(character);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public List<Character> GetAllCharacterQuests()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterManager.GetAllWithQuests();
        }

        public List<GetAllInventory_Result> GetAllInventory()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterInventoryManager.GetAllInventory();
        }

        public IQueryable<Character> GetCharacters()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return db.Characters;
        }

        public IQueryable<Character> GetCharactersByAccountId(int accountId)
        {
            db.Configuration.ProxyCreationEnabled = false;
            return db.Characters.Where(x => x.AccountId == accountId);
        }

        public List<CharactersNeedingAttention_Result> GetCharactersNeedingAttention()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterManager.GetCharactersNeedingAttention();
        }

        public List<Character> GetCharacterQuests(int characterId)
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterManager.GetCharacterQuests(characterId);
        }

        public List<CharacterResearch_Result> GetCharacterResearch()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterManager.GetCharacterResearch();
        }

        public List<GetCharacterSkills_Result> GetCharacterSkills()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterManager.GetCharacterSkills();
        }

        // GET: api/Characters/5
        [ResponseType(typeof(Character))]
        public async Task<IHttpActionResult> GetCharacter(int id)
        {
            db.Configuration.ProxyCreationEnabled = false;
            Character character = await db.Characters.FindAsync(id);
            if (character == null)
            {
                return NotFound();
            }

            return Ok(character);
        }

        public List<OrsiniumDaily> GetOrsiniumStatus()
        {
            var status = CharacterQuestManager.GetOrsiniumDailiesStatus();
            return status;
        }

        public List<DailyPledge> GetPledgeStatus()
        {
            var dailyPledgeStatus = CharacterQuestManager.GetPledgeStatus();
            return dailyPledgeStatus;
        }
        
        public List<DailyWrit> GetWritStatus()
        {
            var dailyWritStatus = CharacterQuestManager.GetWritStatus();
            return dailyWritStatus;
        }

        public NextUpInResearch_Result GetNextUpInResearch()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return CharacterManager.GetNextUpInResearch();
        }

        // POST: api/Characters
        [ResponseType(typeof(Character))]
        public async Task<IHttpActionResult> PostCharacter(Character character)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.Configuration.ProxyCreationEnabled = false;
            db.Characters.Add(character);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = character.Id }, character);
        }

        // PUT: api/Characters/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutCharacter(int id, Character character)
        {
            db.Configuration.ProxyCreationEnabled = false;
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != character.Id)
            {
                return BadRequest();
            }

            db.Entry(character).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CharacterExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}