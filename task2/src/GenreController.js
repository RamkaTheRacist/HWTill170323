const db = require('./dbset');

class GenreController {
    createGenre = async (req, res) => {
        const { name } = req.body;
        try {
            const newGenre = await db.query(`INSERT INTO genre (genre_name) VALUES ($1) RETURNING genre_id, genre_name`, [name]);
            res.end(JSON.stringify(newGenre.rows[0]));
        } catch (error) {
            console.log(error);
            res.end('Error: ' + error.detail);
        }
    }
    getGenre = async (req, res) => {
        if (req.params.id) {
            const id = req.params.id;
            const genre = await db.query(`SELECT genre_id, genre_name FROM genre WHERE genre_id = $1`, [id]);
            res.end(JSON.stringify(genre.rows[0]));
        } else {
            const genres = await db.query(`SELECT genre_id, genre_name FROM genre`);
            res.end(JSON.stringify(genres.rows));
        }
    }
    updateGenre = async (req, res) => {
        const { id, name } = req.body;
        try {
            const genre = await db.query('UPDATE genre SET genre_name = $2 WHERE genre_id = $1 RETURNING genre_id, genre_name', [id, name]);
            res.end(JSON.stringify(genre.rows[0]));
        } catch (error) {
            console.log(error);
            res.end('Error: ' + error.detail);
        }
    }
    deleteGenre = async (req, res) => {
        const id = req.params.id;
        const genre = await db.query(`DELETE FROM genre WHERE genre_id = $1 RETURNING genre_id, genre_name`, [id]);
        res.end(JSON.stringify(genre.rows[0]));
    }

}

module.exports = new GenreController();
