const Router = require('./Router');
const genreController = require('./GenreController');
const filmController = require('./FilmController');
const filmGenreController = require('./FilmGenreController');
const router = new Router();

router.post('/genre', genreController.createGenre);
router.get('/genre', genreController.getGenre);
router.put('/genre', genreController.updateGenre);
router.delete('/genre', genreController.deleteGenre);

router.post('/film', filmController.createFilm);
router.get('/film', filmController.getFilm);
router.put('/film', filmController.updateFilm);
router.delete('/film', filmController.deleteFilm);


router.post('/filmgenre', filmGenreController.addFilmGenre);
router.get('/filmgenre', filmGenreController.getFilmGenre);
router.delete('/filmgenre', filmGenreController.deleteFilmGenre);

module.exports = router;