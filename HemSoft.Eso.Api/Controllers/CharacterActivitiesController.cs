using HemSoft.Eso.Domain.Managers;

namespace HemSoft.Eso.Api.Controllers
{
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure;
    using System.Linq;
    using System.Net;
    using System.Threading.Tasks;
    using System.Web.Http;
    using System.Web.Http.Cors;
    using System.Web.Http.Description;
    using Domain;

    [EnableCors("*", "*", "*")]
    public class CharacterActivitiesController : ApiController
    {
        private EsoEntities db = new EsoEntities();

        // GET: api/CharacterActivities/GetCharacterActivities
        public IQueryable<CharacterActivity> GetCharacterActivities()
        {
            db.Configuration.ProxyCreationEnabled = false;
            return db.CharacterActivities;
        }

        public IQueryable<CharacterActivity> GetCharacterActivitiesByCharacterId(int characterId)
        {
            db.Configuration.ProxyCreationEnabled = false;
            return db.CharacterActivities.Where(x => x.CharacterId == characterId);
        }

        // GET: api/CharacterActivities/5
        [ResponseType(typeof(CharacterActivity))]
        public async Task<IHttpActionResult> GetCharacterActivity(int id)
        {
            db.Configuration.ProxyCreationEnabled = false;
            CharacterActivity characterActivity = await db.CharacterActivities.FindAsync(id);
            if (characterActivity == null)
            {
                return NotFound();
            }

            return Ok(characterActivity);
        }

        // GET: api/CharacterActivities/GetLastCharacterActivity
        public CharacterActivity GetLastCharacterActivity(int characterId)
        {
            return CharacterActivityManager.GetLastActivity(characterId);
        }

        // PUT: api/CharacterActivities/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> PutCharacterActivity(int id, CharacterActivity characterActivity)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != characterActivity.Id)
            {
                return BadRequest();
            }

            db.Entry(characterActivity).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CharacterActivityExists(id))
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

        // POST: api/CharacterActivities
        [ResponseType(typeof(CharacterActivity))]
        public async Task<IHttpActionResult> PostCharacterActivity(CharacterActivity characterActivity)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.CharacterActivities.Add(characterActivity);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = characterActivity.Id }, characterActivity);
        }

        // DELETE: api/CharacterActivities/5
        [ResponseType(typeof(CharacterActivity))]
        public async Task<IHttpActionResult> DeleteCharacterActivity(int id)
        {
            CharacterActivity characterActivity = await db.CharacterActivities.FindAsync(id);
            if (characterActivity == null)
            {
                return NotFound();
            }

            db.CharacterActivities.Remove(characterActivity);
            await db.SaveChangesAsync();

            return Ok(characterActivity);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool CharacterActivityExists(int id)
        {
            return db.CharacterActivities.Count(e => e.Id == id) > 0;
        }
    }
}