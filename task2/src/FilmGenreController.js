const db = require('./dbset');

class FilmGenreController {
    addFilmGenre = async (req, res) => {
        const { film_id, genre_id } = req.body;

        try {
            const filmGenre = await db.query(`INSERT INTO film_genre VALUES ($1, $2) RETURNING film_id, genre_id`, [film_id, genre_id]);
            res.end(JSON.stringify(filmGenre.rows[0]));
        } catch (error) {
            console.log(error);
            res.end('Error: ' + error.detail);
        }
    }
    getFilmGenre = async (req, res) => {
        const { film_id, genre_id } = req.params;
        let filmGenres;
        if (!film_id && !genre_id) {
            filmGenres = await db.query(`SELECT film_id, genre_id FROM film_genre`);
        } else if (!film_id) {
            filmGenres = await db.query(`SELECT film_id, genre_id FROM film_genre WHERE genre_id = $1`, [genre_id]);
        } else if (!genre_id) {
            filmGenres = await db.query(`SELECT film_id, genre_id FROM film_genre WHERE film_id = $1`, [film_id]);
        } else {
            filmGenres = await db.query(`SELECT film_id, genre_id FROM film_genre WHERE film_id = $1 AND genre_id = $2`, [film_id, genre_id]);
            res.end(JSON.stringify(filmGenres.rows[0]));
            return;
        }
        res.end(JSON.stringify(filmGenres.rows));
    }
    deleteFilmGenre = async (req, res) => {
        const { film_id, genre_id } = req.body;
        let filmGenres;
        if(film_id && genre_id){
            filmGenres = await db.query(`DELETE FROM film_genre WHERE film_id = $1 AND genre_id = $2 RETURNING film_id, genre_id`, [film_id, genre_id]);
            res.end(JSON.stringify(filmGenres.rows[0]));
            return;
        }else if(film_id){
            filmGenres = await db.query(`DELETE FROM film_genre WHERE film_id = $1 RETURNING film_id, genre_id`, [film_id]);
        }else if(genre_id){
            filmGenres = await db.query(`DELETE FROM film_genre WHERE genre_id = $1 RETURNING film_id, genre_id`, [genre_id]);
        }else{
            res.end(JSON.stringify({}));
            return;
        }
        res.end(JSON.stringify(filmGenres.rows));
    }
}

module.exports = new FilmGenreController();