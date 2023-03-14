const db = require('./dbset');

class FilmController {
    createFilm = async (req, res) => {
        const { name, year } = req.body;
        try {
            const newFilm = await db.query(`INSERT INTO film (film_name, film_year) VALUES ($1, $2) RETURNING film_id, film_name, film_year`, [name, year]);
            res.end(JSON.stringify(newFilm.rows[0]));
        } catch (error) {
            console.log(error);
            res.end('Error: Year less than 1895 => ' + error.detail);
        }
    }
    getFilm = async (req, res) => {
        let film;
        if (req.params.id) {
            const id = req.params.id;
            film = await db.query(`SELECT film_id, film_name, film_year FROM film WHERE film_id = $1`, [id]);
            res.end(JSON.stringify(film.rows[0]));
        } else {
            film = await db.query(`SELECT film_id, film_name, film_year FROM film`);
            res.end(JSON.stringify(film.rows));
        }
    }
    updateFilm = async (req, res) => {
        const { id, name, year } = req.body;
        try {
            const film = await db.query('UPDATE film SET film_name = $2, film_year = $3 WHERE film_id = $1 RETURNING film_id, film_name, film_year', [id, name, year]);
            res.end(JSON.stringify(film.rows[0]));
        } catch (error) {
            console.log(error);
            res.end('Error: Year less than 1895 => ' + error.detail);
        }

    }
    deleteFilm = async (req, res) => {
        const id = req.params.id;
        const film = await db.query(`DELETE FROM film WHERE film_id = $1 RETURNING film_id, film_name, film_year`, [id]);
        res.end(JSON.stringify(film.rows[0]));
    }

}

module.exports = new FilmController();